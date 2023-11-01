"use strict";
/* eslint-disable @typescript-eslint/naming-convention */
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.deactivate = exports.activate = void 0;
// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
const vscode = require("vscode");
const misc_1 = require("five-server/lib/misc");
const msg_1 = require("five-server/lib/msg");
const pty_1 = require("./pty");
const path_1 = require("path");
const decorator_1 = require("./decorator");
const helpers_1 = require("./helpers");
let openURL = "";
let pty;
let activeFileName = "";
let root = "";
let _root = null;
let workspace;
let rootAbsolute;
let config = {};
let fiveServer;
let myStatusBarItem;
let debug = false;
const state = `${helpers_1.namespace}.state`;
const openCommand = `${helpers_1.namespace}.open`;
const openRootCommand = `${helpers_1.namespace}.openRoot`;
const startCommand = `${helpers_1.namespace}.start`;
const closeCommand = `${helpers_1.namespace}.close`;
const statusBarItemCommand = `${helpers_1.namespace}.statusBar`;
const page = {
    current: { text: "", fileName: "" },
    last: { text: "", fileName: "" },
};
const updatePage = (fileName, text) => {
    if (!fileName)
        return;
    if (!text)
        return;
    const _current = Object.assign({}, page.current);
    page.current = { text, fileName };
    page.last = _current;
};
const isHtml = (file) => {
    if (!file)
        return false;
    return /\.html$/.test(file);
};
const isPhp = (file) => {
    if (!file)
        return false;
    return /\.php$/.test(file);
};
const isCss = (file) => {
    if (!file)
        return false;
    return /\.css$/.test(file);
};
const isJs = (file) => {
    if (!file)
        return false;
    return /\.js$/.test(file);
};
// check for </head> </body> or </html>tag
const containsTags = (text) => {
    return /<\/head>|<\/body>|<\/html>/gm.test(text);
};
// navigate to .html and .php files
const shouldNavigate = (file, text) => {
    if (!file)
        return false;
    if (!text)
        return false;
    if (config && config.navigate === false)
        return false;
    if (!isHtml(file) && !isPhp(file))
        return false;
    // do not navigate to a .html file that does not contain the required tags.
    if ((isHtml(file) || isPhp(file)) && !containsTags(text)) {
        msg_1.message.pretty(`File: ${file} does not contain required HTML tags.`, {
            id: "vscode",
        });
        return false;
    }
    if (config && config.navigate === true)
        return true;
    return false;
};
// highlight only .html files
const shouldHighlight = (file) => {
    if (config && config.highlight === true)
        return true;
    if (!isHtml(file))
        return false;
    return false;
};
// default: true
const shouldInjectCss = () => {
    if (config && config.injectCss === false)
        return false;
    return true;
};
// default: false
const shouldInjectBody = () => {
    if (config && config.injectBody === true)
        return true;
    return false;
};
function activate(context) {
    context.workspaceState.update(state, "off");
    // vscode.window.showInformationMessage("Plugin Activated");
    // navigate to new file
    vscode.window.onDidChangeActiveTextEditor((e) => {
        if (!(fiveServer === null || fiveServer === void 0 ? void 0 : fiveServer.isRunning))
            return;
        (0, decorator_1.refreshDecorations)(e === null || e === void 0 ? void 0 : e.document.fileName, { force: true });
        navigate(e === null || e === void 0 ? void 0 : e.document.fileName, e === null || e === void 0 ? void 0 : e.document.getText());
    });
    // change highlight
    vscode.window.onDidChangeTextEditorSelection((e) => {
        if (!(fiveServer === null || fiveServer === void 0 ? void 0 : fiveServer.isRunning))
            return;
        const fileName = e.textEditor.document.fileName;
        const text = e.textEditor.document.getText();
        if (!isHtml(fileName) && !isPhp(fileName))
            return;
        if (!shouldInjectBody())
            return;
        updatePage(fileName, text);
        updateBody(fileName);
    });
    // reload browser
    vscode.workspace.onDidSaveTextDocument((e) => {
        if (!(fiveServer === null || fiveServer === void 0 ? void 0 : fiveServer.isRunning))
            return;
        // don't reload browser if we modify css and inject css
        if (shouldInjectCss() && isCss(e.fileName))
            return;
        fiveServer.reloadBrowserWindow();
        // // we do not highlight other file than .html
        if (!isHtml(e.fileName))
            return;
        if (!shouldInjectBody())
            return;
        // // TODO: Maybe this needs improvement?
        updateBody(e.fileName);
        setTimeout(() => updateBody(e.fileName), 250);
        setTimeout(() => updateBody(e.fileName), 500);
        setTimeout(() => updateBody(e.fileName), 1000);
    });
    // inject body into .html file
    vscode.workspace.onDidChangeTextDocument((e) => {
        if (!(fiveServer === null || fiveServer === void 0 ? void 0 : fiveServer.isRunning))
            return;
        if (!isHtml(e.document.fileName) && !isPhp(e.document.fileName))
            return;
        if (!shouldInjectBody())
            return;
        updatePage(e.document.fileName, e.document.getText());
        updateBody(page.current.fileName);
    });
    const updateBody = (fileName) => {
        var _a;
        if (page.current.fileName !== page.last.fileName)
            return;
        if (!isHtml(fileName) && !isPhp(fileName))
            return;
        if (!shouldInjectBody())
            return;
        fiveServer === null || fiveServer === void 0 ? void 0 : fiveServer.parseBody.updateBody(fileName, page.current.text, shouldHighlight(fileName), (_a = vscode.window.activeTextEditor) === null || _a === void 0 ? void 0 : _a.selection.active);
    };
    const navigate = (fileName, text) => {
        if (!(fiveServer === null || fiveServer === void 0 ? void 0 : fiveServer.isRunning))
            return;
        if (!fileName)
            return;
        if (!text)
            return;
        if (!shouldNavigate(fileName, text))
            return;
        if (activeFileName === fileName)
            return;
        activeFileName = fileName;
        if (fileName && workspace) {
            fileName = fileName.replace(rootAbsolute, "").replace(/^\\|^\//gm, "");
            fiveServer.navigate(`/${fileName}`);
        }
    };
    const updateStatusBarItem = (status) => {
        if (status === "on") {
            myStatusBarItem.text = `$(zap) ${openURL}`;
            myStatusBarItem.tooltip = "Close Five Server";
            myStatusBarItem.color = helpers_1.colors.yellow;
            myStatusBarItem.show();
        }
        else if (status === "loading") {
            myStatusBarItem.text = `$(sync~spin) Going Live...`;
            myStatusBarItem.tooltip = "Loading Five Server";
            myStatusBarItem.color = undefined;
            myStatusBarItem.show();
        }
        else {
            myStatusBarItem.text = `$(play-circle) Go Live`;
            myStatusBarItem.tooltip = "Open Five Server";
            myStatusBarItem.color = undefined;
            myStatusBarItem.show();
        }
    };
    let lastMessage = "";
    const messageHandler = (message) => {
        if (lastMessage !== message && pty && message && message.msg) {
            pty.write(message.msg);
        }
        lastMessage = message;
    };
    const startServer = (uri) => __awaiter(this, void 0, void 0, function* () {
        var _a, _b, _c;
        let startWorkers = false;
        updateStatusBarItem("loading");
        context.workspaceState.update(state, "loading");
        // display loading text
        yield new Promise((r) => setTimeout(r, 250));
        if (!pty)
            pty = new pty_1.PTY((0, helpers_1.getConfig)("openTerminal"));
        if (!fiveServer) {
            const FiveServer = yield Promise.resolve().then(() => require("five-server"));
            fiveServer = new FiveServer.default();
            startWorkers = true;
        }
        // @ts-ignore
        msg_1.message.removeListener("message", messageHandler);
        // @ts-ignore
        msg_1.message.addListener("message", messageHandler);
        // reset config
        config = {};
        // get config from VSCode
        config = (0, helpers_1.assignVSCodeConfiguration)();
        workspace = (_a = vscode.workspace.workspaceFolders) === null || _a === void 0 ? void 0 : _a[0].uri.fsPath;
        if (workspace) {
            // get file stat (if uri is available)
            const stat = uri ? yield vscode.workspace.fs.stat(uri) : null;
            // open directory as root (1 = File; 2 = Directory)
            if ((stat === null || stat === void 0 ? void 0 : stat.type) === 2)
                _root = uri.fsPath.replace(workspace, "");
            // get configFile for "root, injectBody and highlight"
            config = Object.assign(Object.assign({}, config), (yield (0, misc_1.getConfigFile)(true, workspace)));
            if (_root)
                root = _root;
            else if (config && config.root)
                root = config.root;
            else
                root = "";
            // @ts-ignore
            if (config && config.debugVSCode === true)
                debug = true;
            else
                debug = false;
            rootAbsolute = (0, path_1.join)(workspace, root);
            if (debug) {
                pty.write("DEBUG:", '"workspace", "root" and "open" will be passed to fiveServer.start()');
                pty.write("Workspace:", workspace);
                pty.write("Root:", root);
                pty.write("Absolute (workspace + root):", rootAbsolute);
                pty.write("File:", uri === null || uri === void 0 ? void 0 : uri.fsPath);
            }
            if (uri === null || uri === void 0 ? void 0 : uri.fsPath) {
                let file = uri.fsPath
                    .replace(rootAbsolute, "")
                    .replace(/^\\|^\//gm, "");
                const isFile = (0, path_1.extname)(file) !== "";
                // serve .preview for all "files" other than .html and .php
                if (isFile && !isHtml(file) && !isPhp(file))
                    file += ".preview";
                activeFileName = file;
                if (debug)
                    pty.write("Open:", file);
                yield fiveServer.start(Object.assign(Object.assign({}, config), { injectBody: shouldInjectBody(), open: config.open !== undefined ? config.open : file, root,
                    workspace, _cli: true }));
            }
            //
            else {
                let file = "";
                // get current open file
                const fileName = (_b = vscode.window.activeTextEditor) === null || _b === void 0 ? void 0 : _b.document.fileName;
                if (fileName)
                    file = fileName.replace(rootAbsolute, "").replace(/^\\|^\//gm, "");
                if (debug)
                    pty.write("Open:", file);
                yield fiveServer.start(Object.assign(Object.assign({}, config), { injectBody: shouldInjectBody(), open: config.open !== undefined ? config.open : file, root,
                    workspace, _cli: true }));
            }
        }
        //
        else if (!workspace) {
            // no workspace?
            // the user opened probably only a single file instead of a folder
            msg_1.message.pretty('No Workspace found! You probably opened a "single file" instead of a "folder".', { id: "vscode" });
            // we get the path and filename from the window
            const fileName = (_c = vscode.window.activeTextEditor) === null || _c === void 0 ? void 0 : _c.document.fileName;
            if (!fileName) {
                msg_1.message.pretty("Could not detect a valid file.", { id: "vscode" });
                updateStatusBarItem("off");
                context.workspaceState.update(state, "off");
                return;
            }
            const file = (0, path_1.basename)(fileName);
            const root = fileName.replace(file, "");
            // start a simple server
            yield fiveServer.start(Object.assign(Object.assign({}, config), { injectBody: shouldInjectBody(), root, open: file }));
        }
        openURL = fiveServer.openURL;
        updateStatusBarItem("on");
        context.workspaceState.update(state, "on");
        // start workers
        if (startWorkers) {
            fiveServer.parseBody.workers.on("message", (msg) => {
                const json = JSON.parse(msg);
                if (json.report && json.report.results) {
                    const results = json.report.results;
                    if (results.length === 0) {
                        (0, decorator_1.decorate)(page.current.fileName, [], helpers_1.colors.yellow);
                        return;
                    }
                    const htmlErrors = results[0].messages.map((m) => {
                        const { message, ruleId, line } = m;
                        return { message, ruleId, line };
                    });
                    (0, decorator_1.decorate)(page.current.fileName, htmlErrors.map((e) => {
                        return { text: `// ${e.message}`, line: e.line };
                    }), helpers_1.colors.yellow);
                }
            });
        }
        return "done";
    });
    const closeServer = () => {
        updateStatusBarItem("loading");
        context.workspaceState.update(state, "loading");
        // @ts-ignore
        msg_1.message.removeListener("message", messageHandler);
        // reset tmp root
        _root = null;
        if (fiveServer) {
            fiveServer.shutdown().then(() => {
                // @ts-ignore
                fiveServer = null;
                updateStatusBarItem("off");
                context.workspaceState.update(state, "off");
            });
        }
        if (pty) {
            pty.dispose();
            // @ts-ignore
            pty = null;
        }
        return "done";
    };
    const toggleServer = () => {
        const _state = context.workspaceState.get(state);
        if (_state === "on")
            vscode.commands.executeCommand(closeCommand);
        else if (_state === "off")
            vscode.commands.executeCommand(startCommand);
    };
    context.subscriptions.push(vscode.commands.registerCommand(startCommand, startServer));
    context.subscriptions.push(vscode.commands.registerCommand(openCommand, startServer));
    context.subscriptions.push(vscode.commands.registerCommand(openRootCommand, startServer));
    context.subscriptions.push(vscode.commands.registerCommand(closeCommand, closeServer));
    context.subscriptions.push(vscode.commands.registerCommand(statusBarItemCommand, toggleServer));
    // create a new status bar item that we can now manage
    myStatusBarItem = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Right, 0);
    myStatusBarItem.command = statusBarItemCommand;
    updateStatusBarItem("off");
    context.subscriptions.push(myStatusBarItem);
}
exports.activate = activate;
function deactivate(context) {
    vscode.commands.executeCommand(closeCommand);
}
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map