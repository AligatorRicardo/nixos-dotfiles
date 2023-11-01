"use strict";
/**
 * @copyright   Copyright (c) 2017 Wix.com
 * @license     {@link https://github.com/wix/import-cost/blob/master/LICENSE MIT}
 * @description copied and modified from (https://github.com/wix/import-cost/blob/master/packages/vscode-import-cost/src/decorator.ts)
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.clearDecorations = exports.refreshDecorations = exports.decorate = void 0;
const vscode_1 = require("vscode");
const helpers_1 = require("./helpers");
let decorations = {};
let decorationsDebounce;
let prevDecs = "empty";
/** Add/Replace all decorations "fileName". */
const decorate = (fileName, props, color) => {
    const hash = (0, helpers_1.strToHash)(fileName);
    // remove all decorations for "fileName"
    decorations[hash] = [];
    props.forEach((p) => {
        const { text, line } = p;
        decorations[hash].push({
            renderOptions: { after: { contentText: text, color } },
            range: new vscode_1.Range(new vscode_1.Position(line - 1, 1024), new vscode_1.Position(line - 1, 1024)),
        });
    });
    (0, exports.refreshDecorations)(fileName);
};
exports.decorate = decorate;
const decorationType = vscode_1.window.createTextEditorDecorationType({
    after: { margin: "0 0 0 1rem" },
});
const refreshDecorations = (fileName, options = {}) => {
    if (!fileName)
        return;
    const { delay = 250, force = false } = options;
    const hash = (0, helpers_1.strToHash)(fileName);
    if (!force && prevDecs === JSON.stringify(decorations))
        return;
    prevDecs = JSON.stringify(decorations);
    clearTimeout(decorationsDebounce);
    decorationsDebounce = setTimeout(() => {
        getEditors(fileName).forEach((editor) => {
            editor.setDecorations(decorationType, decorations[hash] || []);
        });
    }, delay);
};
exports.refreshDecorations = refreshDecorations;
const getEditors = (fileName) => {
    return vscode_1.window.visibleTextEditors.filter((editor) => editor.document.fileName === fileName);
};
const clearDecorations = () => {
    vscode_1.window.visibleTextEditors.forEach((textEditor) => {
        decorations = {};
        return textEditor.setDecorations(decorationType, []);
    });
};
exports.clearDecorations = clearDecorations;
//# sourceMappingURL=decorator.js.map