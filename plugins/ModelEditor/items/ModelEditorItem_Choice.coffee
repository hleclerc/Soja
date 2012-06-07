#
class ModelEditorItem_Choice extends ModelEditorItem
    constructor: ( params ) ->
        super params

        @select = new_dom_element
            parentNode: @ed
            nodeName  : "select"
            onchange  : =>
                @get_undo_manager()?.snapshot()
                @model.set @select.value
            style:
                width: @ew + "%"

        @ev?.onmousedown = =>
            @get_focus()?.set @view_id
            
    onchange: ->
        if @model.lst.has_been_modified()
            if @model.lst.length == 0
                @ed.style.display = 'none'
                return
            else
                @ed.style.display = 'block'
                
            while @select.firstChild?
                @select.removeChild @select.firstChild

            cpt = 0
            for i in @model._nlst()
                new_dom_element
                    parentNode : @select
                    nodeName   : "option"
                    txt        : i.toString()
                    value      : cpt
                    
                cpt += 1
            
        if @model.num.has_been_modified()
            @select.value = @model.num.get()
 
        if @get_focus()?.has_been_modified()
            if @get_focus().get() == @view_id
                setTimeout ( => @select.focus() ), 1
            else
                @select.blur()