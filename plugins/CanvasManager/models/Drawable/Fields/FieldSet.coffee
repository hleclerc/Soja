#
class FieldSet extends Drawable
    constructor: ->
        super()
        
        @add_attr
            color_by   : new Choice # list of NamedParametrizedDrawable containing fields
            warp_by    : new Choice # list of NamedParametrizedDrawable containing nD fields
            warp_factor: 0 # 
            # gradient  : new Gradient
        
    get_model_editor_parameters: ( res ) ->
        res.model_editor[ "color_by" ] = ModelEditorItem_ChoiceWithEditableItems
        # res.model_editor[ "warp_by" ] = ModelEditorItem_ChoiceWithEditableItems
            
    draw: ( info ) ->
        f = @color_by.item()
        if f?
            f.draw info,
                warp_by    : @warp_by.item().data
                warp_factor: @warp_factor.get()
                # gradient   : @gradient

    z_index: ->
        50
        