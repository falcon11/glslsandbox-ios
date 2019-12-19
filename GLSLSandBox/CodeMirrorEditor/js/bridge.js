function getCode() {
    if (editor) return editor.getValue();
    return "";
}

function setCode(code, readOnly = false) {
    if (!editor) return;
    editor.setValue(code);
    if (readOnly) {
        editor.setOption('readOnly', 'nocursor');
    }
}
