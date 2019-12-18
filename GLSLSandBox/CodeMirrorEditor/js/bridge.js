function getCode() {
    if (editor) return editor.getValue();
    return "";
}

function setCode(code) {
    if (!editor) return;
    editor.setValue(code);
}
