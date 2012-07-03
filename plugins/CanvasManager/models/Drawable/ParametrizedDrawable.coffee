# Interface to an object the contains 
#   - a method draw which takes ( info )
#   - a method get_drawing_parameters which permits  to complete the model attributes
class ParametrizedDrawable extends Drawable
    constructor: ( data ) ->
        super()
        
        @add_attr
            # drawing_parameters: ... -> filled after
            data: data

    draw: ( info, additionnal_parameters ) ->
        @_udpate_parameters_if_necessary()
        @data.draw info, @drawing_parameters, additionnal_parameters
        
    disp_only_in_model_editor: ->
        @drawing_parameters
        
    z_index: ->
        @data.z_index()
            
    _udpate_parameters_if_necessary: ->
        if not @drawing_parameters?
            @data.get_drawing_parameters this
    