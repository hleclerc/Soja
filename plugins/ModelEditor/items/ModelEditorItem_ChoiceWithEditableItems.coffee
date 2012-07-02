# 
class ModelEditorItem_ChoiceWithEditableItems extends ModelEditorItem
    constructor: ( params ) ->
        super params

        # choice
        @choice = new_model_editor
            el        : @ed
            model     : @model
            parent    : this
            item_type : ModelEditorItem_Choice

        @editdiv = new_dom_element
            parentNode: @ed
            nodeName  : "span"
            
        @editors = []
            
    onchange: ->
        if @model.lst.has_been_directly_modified()
            for e in @editors
                e.destructor()

            @editors = for l in @model.lst
                new_model_editor
                    el        : @editdiv
                    model     : l
                    parent    : this
                        
            
        if @model.num.has_been_modified() or @model.lst.has_been_directly_modified()
            for e, i in @editors
                e.ed.style.display = ( if @model.num.get() == i then "block" else "none" )
                

    ok_for_label: ->
        false
            