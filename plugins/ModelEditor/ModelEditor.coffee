# return a child inst of ModelEditorItem, with type in adequation with $model
# @see ModelEditor.get_item_type_for
# Mandatory params:
#  - el
#  - model
# Optionnal params:
#  - name -> attribute name
#  - label -> attribute name used for the display
#  - parent
#  - call_onchange
#  - item_width
#  - label_ratio
#  - focus -> a Val representing the view_id of the focused view
#  - undo_manager
#  - closed_models (Lst)
#  - item_type
#  - class_name
new_model_editor = ( params ) ->
    # if we only want to display a sub item
    sub_model = params.model.disp_only_in_model_editor?()
    if sub_model?
        n_params = {}
        for key, val of params
            n_params[ key ] = val
        n_params.model = sub_model
        return new_model_editor n_params
        
    # find an item type
    TI = ModelEditorItem.get_item_type_for params
    return new TI params

    
    