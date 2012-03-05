# allow code editor
#
class ModelEditorItem_TextAreaLanguage extends ModelEditorItem
    constructor: ( params ) ->
        super params
        
        
        @button = new_dom_element
            parentNode: @ed
            nodeName  : "input"
            type      : "button"
            className : "code_editor"
            value     : "FullScreen"
            onclick   : ( evt )  =>
                # popup construction
                p = new_popup @label or "Code Editor", event : evt, width: "50"
                p.appendChild @textarea
                code_mirror = CodeMirror.fromTextArea @textarea, {
                    lineNumbers : true,
                    mode: "javascript",
                    lineWrapping: true,
                    onCursorActivity: =>
                        code_mirror.setLineClass(@hlLine, null)
                        @hlLine = code_mirror.setLineClass(code_mirror.getCursor().line, "activeline")
                        code_mirror.matchHighlight("CodeMirror-matchhighlight")
                    extraKeys: {
                        "F11": ->
                            scroller = code_mirror.getScrollerElement()
                            if (scroller.className.search(/\bCodeMirror-fullscreen\b/) == -1)
                                scroller.className += " CodeMirror-fullscreen";
                                scroller.style.height = "100%";
                                scroller.style.width = "100%";
                                code_mirror.refresh();
                            else
                                scroller.className = scroller.className.replace(" CodeMirror-fullscreen", "")
                                scroller.style.height = ''
                                scroller.style.width = ''
                                code_mirror.refresh()
                        ,
                        "Esc": -> 
                            scroller = code_mirror.getScrollerElement()
                            if (scroller.className.search(/\bCodeMirror-fullscreen\b/) != -1)
                                scroller.className = scroller.className.replace(" CodeMirror-fullscreen", "")
                                scroller.style.height = ''
                                scroller.style.width = ''
                                code_mirror.refresh()
                    }
                }
                @hlLine = code_mirror.setLineClass(0, "activeline")

        @textarea = new_dom_element
            parentNode: @ed
            nodeName  : "textarea"
            className : "code_editor"
            txt       : @model.get()
            

        code_mirror = CodeMirror.fromTextArea @textarea, {
            lineNumbers : true,
            mode: "javascript",
            lineWrapping: true,
            onCursorActivity: =>
                code_mirror.setLineClass(@hlLine, null)
                @hlLine = code_mirror.setLineClass(code_mirror.getCursor().line, "activeline")
                code_mirror.matchHighlight("CodeMirror-matchhighlight")
            extraKeys: {
                "F11": ->
                    scroller = code_mirror.getScrollerElement()
                    if (scroller.className.search(/\bCodeMirror-fullscreen\b/) == -1)
                        scroller.className += " CodeMirror-fullscreen";
                        scroller.style.height = "100%";
                        scroller.style.width = "100%";
                        code_mirror.refresh();
                    else
                        scroller.className = scroller.className.replace(" CodeMirror-fullscreen", "")
                        scroller.style.height = ''
                        scroller.style.width = ''
                        code_mirror.refresh()
                ,
                "Esc": -> 
                    scroller = code_mirror.getScrollerElement()
                    if (scroller.className.search(/\bCodeMirror-fullscreen\b/) != -1)
                        scroller.className = scroller.className.replace(" CodeMirror-fullscreen", "")
                        scroller.style.height = ''
                        scroller.style.width = ''
                        code_mirror.refresh()
            }
        }
        @hlLine = code_mirror.setLineClass(0, "activeline")
    onchange: ->
        

# 
ModelEditor.default_types.push ( model ) -> ModelEditorItem_TextAreaLanguage if model instanceof StrLanguage
