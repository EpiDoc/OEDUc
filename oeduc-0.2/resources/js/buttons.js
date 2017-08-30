
$(document).ready(function () {
    $('#underdot').on('click', function () {
        
        insertAtCaret('L+text', '&#x323;')
    });
    
    $('#abbreviation').on('click', function () {
        
        insertAtCaret('L+text', '(())')
    });
    
    $('#choice').on('click', function () {
        
        insertAtCaret('L+text', '<:|corr|:>')
    });
    
    
    $('#linebreak').on('click', function () {
        
        insertAtCaret('L+text', '1. ')
    });
    
    $('#supplied').on('click', function () {
        
        insertAtCaret('L+text', '[]')
    });
    
    $('#omitted').on('click', function () {
        
        insertAtCaret('L+text', '<>')
    });
    
    $('#deleted').on('click', function () {
        
        insertAtCaret('L+text', '〚〛')
    });
    
    $('#gap').on('click', function () {
        
        insertAtCaret('L+text', '.?')
    });
});

function insertAtCaret(areaId, text) {
    var txtarea = document.getElementById(areaId);
    if (! txtarea) {
        return;
    }
    
    var scrollPos = txtarea.scrollTop;
    var strPos = 0;
    var br = ((txtarea.selectionStart || txtarea.selectionStart == '0') ?
    "ff": (document.selection ? "ie": false));
    if (br == "ie") {
        txtarea.focus();
        var range = document.selection.createRange();
        range.moveStart ('character', - txtarea.value.length);
        strPos = range.text.length;
    } else if (br == "ff") {
        strPos = txtarea.selectionStart;
    }
    
    var front = (txtarea.value).substring(0, strPos);
    var back = (txtarea.value).substring(strPos, txtarea.value.length);
    txtarea.value = front + text + back;
    strPos = strPos + text.length;
    if (br == "ie") {
        txtarea.focus();
        var ieRange = document.selection.createRange();
        ieRange.moveStart ('character', - txtarea.value.length);
        ieRange.moveStart ('character', strPos);
        ieRange.moveEnd ('character', 0);
        ieRange.select();
    } else if (br == "ff") {
        txtarea.selectionStart = strPos;
        txtarea.selectionEnd = strPos;
        txtarea.focus();
    }
    
    txtarea.scrollTop = scrollPos;
}