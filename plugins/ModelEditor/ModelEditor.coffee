# create a view with linked inputs to modify the value(s) of a model
# input types depend on model types.
# see new_model_editor for construction
class ModelEditor # extends View
    #
    @default_types: [
        ( model ) -> ModelEditorItem_CheckBox       if model instanceof Bool
        ( model ) -> ModelEditorItem_Choice         if model instanceof Choice
        ( model ) -> ModelEditorItem_Button         if model instanceof Button
        ( model ) -> ModelEditorItem_ConstrainedVal if model instanceof ConstrainedVal
        ( model ) -> ModelEditorItem_Input          if model instanceof Obj
        ( model ) -> ModelEditorItem_List           if model.dim() # Tensor
    ]

    # attribute name -> display name
    @trans_name: ( name ) ->
        r = /\_/g
        res = name.replace r, " "
        return res[ 0 ].toUpperCase() + res[ 1... ]
 
    @get_item_type_for: ( model, parent ) ->
        # individual behavior
        if model._model_editor_item_type?
            return model._model_editor_item_type
            
        # 
        if parent?
            return parent.get_item_type_for model
            
        # global default types
        for t in ModelEditor.default_types
            r = t model
            if r?
                return r

        return ModelEditorItem_Aggregate

        
# return a child inst of ModelEditorItem, with type in adequation with $model
# @see ModelEditor.get_item_type_for
# Mandatory params:
#  - el
#  - model
# Optionnal params:
#  - optionnal_label
#  - parent
#  - call_onchange
#  - item_width
#  - label_ratio
#  - undo_manager
#  - closed_models (new Lst)
#  - item_type

new_model_editor = ( params ) ->
    # if we only want to display a sub item
    sub_model = params.model.disp_only_in_model_editor?()
    if sub_model?
        n_params = {}
        for key, val of params
            n_params[ key ] = val
        n_params.model = sub_model
        return new_model_editor n_params

    #
    if params.item_type?
        return new params.item_type params
        
    # find an item type
    TI = ModelEditor.get_item_type_for params.model, params.parent
    return new TI params

    
    