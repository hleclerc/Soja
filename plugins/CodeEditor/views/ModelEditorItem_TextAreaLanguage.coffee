# allow code editor
#
class ModelEditorItem_TextAreaLanguage extends ModelEditorItem
    constructor: ( params ) ->
        super params
        
        
        @textarea = new_dom_element
            parentNode: @ed
            nodeName  : "textarea"
            className : "code_editor"
            txt       : @model.get()
#             onclick   : ( evt )  =>
#                 # popup construction
#                 if not @d?
#                     @d = new_dom_element()
#                     @item_cp = new ModelEditorItem_ColorPicker
#                         el    : @d
#                         model : @model
#                         parent: this
#                 p = new_popup @label or "Color picker", event : evt
#                 p.appendChild @d


#         .CodeMirror-fullscreen {
#             display: block;
#             position: absolute;
#             top: 0;
#             left: 0;
#             width: 100%;
#             height: 100%;
#             z-index: 9999;
#             margin: 0;
#             padding: 0;
#             border: 0px solid #BBBBBB;
#             opacity: 1;
#         }

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
