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
                warp_by    : if @warp_by.item()? then @warp_by.item().data else undefined
                warp_factor: @warp_factor.get()
                # gradient   : @gradient
                
    sub_canvas_items: ( additionnal_parameters ) ->
        f = @color_by.item()
        if f?
            f.sub_canvas_items additionnal_parameters
        else
            []

    z_index: ->
        150
        