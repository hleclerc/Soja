# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2012 Hugo Leclerc
#
# This file is part of Soda.
#
# Soda is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Soda is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with Soda. If not, see <http://www.gnu.org/licenses/>.



# allow code editor
#
class ModelEditorItem_TextAreaLanguage extends ModelEditorItem
    constructor: ( params ) ->
        super params
        
        @current_path = "/scripts"
                
        @button = new_dom_element
            parentNode: @ed
            nodeName  : "input"
            type      : "button"
            value     : "FullScreen"
            onclick   : ( evt )  =>
                # popup construction
                p = new_popup @label or "Code Editor", event : evt, width: "50", onclose: =>
                    @onPopupClose( )

#                 win = window.open("","Code Editor", "menubar=no, status=no, scrollbars=yes, menubar=no, width=500, height=600")

                p.appendChild @textarea
                @code_mirror.save() # Copy the content of the editor into the textarea
                @model.set @code_mirror.getValue()
                @fullscreen_code_mirror = CodeMirror.fromTextArea @textarea, {
                    lineNumbers : true,
                    mode: @model.get_language(),
                    lineWrapping: true,
                    onChange: =>
                        changed_string = @fullscreen_code_mirror.getValue()
                        @model.set changed_string
                        @model.callback?()
                        @get_focus()?.set @view_id
                    onCursorActivity: =>
                        @fullscreen_code_mirror.setLineClass(@hlLine, null)
                        @hlLine = @fullscreen_code_mirror.setLineClass(@fullscreen_code_mirror.getCursor().line, "activeline")
                        @fullscreen_code_mirror.matchHighlight("CodeMirror-matchhighlight")
#                     extraKeys: {
#                         "F11": ->
#                             scroller = @fullscreen_code_mirror.getScrollerElement()
#                             if (scroller.className.search(/\bCodeMirror-fullscreen\b/) == -1)
#                                 scroller.className += " CodeMirror-fullscreen";
#                                 scroller.style.height = "100%";
#                                 scroller.style.width = "100%";
#                                 @fullscreen_code_mirror.refresh();
#                             else
#                                 scroller.className = scroller.className.replace(" CodeMirror-fullscreen", "")
#                                 scroller.style.height = ''
#                                 scroller.style.width = ''
#                                 @fullscreen_code_mirror.refresh()
#                         ,
#                         "Esc": -> 
#                             scroller = @fullscreen_code_mirror.getScrollerElement()
#                             if (scroller.className.search(/\bCodeMirror-fullscreen\b/) != -1)
#                                 scroller.className = scroller.className.replace(" CodeMirror-fullscreen", "")
#                                 scroller.style.height = ''
#                                 scroller.style.width = ''
#                                 @fullscreen_code_mirror.refresh()
#                     }
                }
                @hlLine = @fullscreen_code_mirror.setLineClass(0, "activeline")

#         @save = new_dom_element
#             parentNode: @ed
#             nodeName  : "input"
#             type      : "button"
#             value     : "Save"
#             onclick   : ( evt )  =>
#                 console.log 'save'
#                 if FileSystem?
#                     fs = FileSystem.get_inst()
#                     # we should ask for filename and path
#                     name = "my-script"
#                     path = @current_path
#                     fs.load path, ( m, err ) ->
#                         m.add_file name, new Path @model.get(), info.model_type "txt"

        @textarea = new_dom_element
            parentNode: @ed
            nodeName  : "textarea"
            className : "code_editor"
            txt       : @model.get()
            
        @ev?.onmousedown = =>
            @get_focus()?.set @view_id

        @code_mirror = CodeMirror.fromTextArea @textarea, {
            lineNumbers : true,
            mode: @model.get_language(),
            lineWrapping: true,
            onChange: =>
                @model.set @code_mirror.getValue()
                @model.callback?()
                setTimeout ( => @code_mirror.focus() ), 1
                
            onCursorActivity: =>
                @code_mirror.setLineClass(@hlLine2, null)
                @hlLine2 = @code_mirror.setLineClass(@code_mirror.getCursor().line, "activeline")
                @code_mirror.matchHighlight("CodeMirror-matchhighlight")
        }
#             indentUnit = @code_mirror.getOption('indentUnit')
        @code_mirror.getWrapperElement().onmousedown = =>
            @get_focus()?.set @view_id
            
        @hlLine2 = @code_mirror.setLineClass(0, "activeline")
        
    onchange: ->
        if @get_focus()?.has_been_modified()
            if @get_focus().get() == @view_id
                setTimeout ( => @code_mirror.focus() ), 1

    onPopupClose: ( ) ->
        changed_string = @fullscreen_code_mirror.getValue()
        @model.set changed_string
        @code_mirror.setValue changed_string
# 
ModelEditorItem.default_types.push ( model ) -> ModelEditorItem_TextAreaLanguage if model instanceof StrLanguage
