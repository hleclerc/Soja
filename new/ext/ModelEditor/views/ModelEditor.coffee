# dep items/ModelEditorItem_Input.coffee

# construct a view of a model, mainly with editor fields...
# 
# 
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
class ModelEditor
    constructor: ( params ) ->
        TI = ModelEditorItem.get_item_type_for params
        @editor = new TI params
