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

    onchange: ->
        if @model.lst.has_been_modified()
            while @select.firstChild?
                @select.removeChild @select.firstChild

            cpt = 0
            for i in @model.lst
                new_dom_element
                    parentNode : @select
                    nodeName   : "option"
                    txt        : i.get()
                    value      : cpt
                    
                cpt += 1
            
        if @model.num.has_been_modified()
            @select.value = @model.num.get()
 