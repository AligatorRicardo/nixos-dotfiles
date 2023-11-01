"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PTY = void 0;
const vscode = require("vscode");
class PTY {
    write(...message) {
        const write = message.join(" ");
        // somewhere is a bug that send every message twice :/
        if (this.lastWrite === write)
            return;
        this.terminal.sendText(write, true);
        this.lastWrite = write;
    }
    constructor(open = true) {
        this.lastWrite = "";
        this.writeEmitter = new vscode.EventEmitter();
        const pty = {
            onDidWrite: this.writeEmitter.event,
            open: () => { },
            close: () => {
                this.writeEmitter.dispose();
            },
            handleInput: (data) => this.writeEmitter.fire(data === "\r" ? "\r\n" : data + "\r\n"),
        };
        this.terminal = vscode.window.createTerminal({ name: "Five Server", pty });
        if (open)
            this.terminal.show();
        // hide cursor
        this.terminal.sendText("\u001B[?25l");
    }
    dispose() {
        this.terminal.dispose();
    }
}
exports.PTY = PTY;
//# sourceMappingURL=pty.js.map