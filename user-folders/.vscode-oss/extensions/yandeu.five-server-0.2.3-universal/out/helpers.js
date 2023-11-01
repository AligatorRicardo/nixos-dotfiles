"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.assignVSCodeConfiguration = exports.getConfig = exports.strToHash = exports.colors = exports.isDarkTheme = exports.namespace = void 0;
const vscode = require("vscode");
exports.namespace = "fiveServer";
const isDarkTheme = () => {
    const theme = vscode.window.activeColorTheme;
    return theme.kind === vscode.ColorThemeKind.Dark;
};
exports.isDarkTheme = isDarkTheme;
exports.colors = {
    get yellow() {
        return (0, exports.isDarkTheme)() ? "#ebb549" : "#f69d50";
    },
};
const strToHash = (s) => {
    let hash = 0;
    for (let i = 0; i < s.length; i++) {
        const chr = s.charCodeAt(i);
        hash = (hash << 5) - hash + chr;
        hash |= 0; // Convert to 32bit integer
    }
    return Math.abs(hash).toString(32);
};
exports.strToHash = strToHash;
const getConfig = (config) => vscode.workspace.getConfiguration().get(`${exports.namespace}.${config}`);
exports.getConfig = getConfig;
const assignVSCodeConfiguration = () => {
    const browser = (0, exports.getConfig)("browser");
    const ignore = (0, exports.getConfig)("ignore");
    const navigate = (0, exports.getConfig)("navigate");
    const php = (0, exports.getConfig)("php.executable");
    const phpIni = (0, exports.getConfig)("php.ini");
    const host = (0, exports.getConfig)("host");
    const port = (0, exports.getConfig)("port");
    const injectBody = (0, exports.getConfig)("injectBody");
    const highlight = (0, exports.getConfig)("highlight");
    return {
        browser,
        ignore,
        navigate,
        php,
        phpIni,
        host,
        port,
        injectBody,
        highlight,
    };
};
exports.assignVSCodeConfiguration = assignVSCodeConfiguration;
//# sourceMappingURL=helpers.js.map