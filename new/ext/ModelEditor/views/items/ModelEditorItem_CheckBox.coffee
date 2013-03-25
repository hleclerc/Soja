# dep ModelEditorItem.coffee

#
class ModelEditorItem_CheckBox extends ModelEditorItem
    constructor: ( params ) ->
        super params
        
        # a span to dill the spacz
        span = new_dom_element
            parentNode: @ed
            nodeName  : "span"
            style     :
                width  : @ew + "%"
                display: "inline-block"
        
        # checkbox
        @input = new_dom_element
            parentNode: span
            type      : "checkbox"
            nodeName  : "input"
            onchange  : =>
                @snapshot()
                @model.set @input.checked

        #
        @legend_focus = params.parent?.legend_focus
        if @legend_focus
            @ev?.onmousedown = =>
                @get_focus()?.set @view_id
                @model.toggle()
            
    onchange: ->
        if @model.has_been_modified
            @input.checked = @model.toBoolean()

            if @label?
                if @model.toBoolean()
                    add_class @label, "modelEditor_checked"
                else
                    rem_class @label, "modelEditor_checked"
                    
        if @legend_focus != false
            if @get_focus()?.has_been_modified
                if @get_focus().get() == @view_id
                    @input.focus()
                else
                    @input.blur()

