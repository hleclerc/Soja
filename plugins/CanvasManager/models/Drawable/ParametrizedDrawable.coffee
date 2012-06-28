# Interface to an object the contains 
#   - a method draw which takes ( info )
#   - a method get_drawing_parameters which permits  to complete the model attributes
class ParametrizedDrawable extends Drawable
    constructor: ( data ) ->
        super()
        
        @add_attr
            # parameters: ... -> filled after
            data: data

    draw: ( info ) ->
        @_udpate_parameters_if_necessary()
        @data.draw info, this
            
    _udpate_parameters_if_necessary: ->
        if not @parameters?
            @data.get_drawing_parameters this
        
    