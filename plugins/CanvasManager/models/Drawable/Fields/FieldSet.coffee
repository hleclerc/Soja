#
class FieldSet extends Model
    constructor: ->
        super()
        
        @add_attr
            color_by: new Choice # list of NamedParametrizedDrawable containing fields
            warp_by : new Choice # list of NamedParametrizedDrawable containing nD fields
        
    get_model_editor_parameters: ( res ) ->
        res.model_editor[ "color_by" ] = ModelEditorItem_ChoiceWithEditableItems
        res.model_editor[ "warp_by" ] = ModelEditorItem_ChoiceWithEditableItems
            
    draw: ( info ) ->
        f = @color_by.get()
        if f
            f.draw info, @warp_by.get()
            