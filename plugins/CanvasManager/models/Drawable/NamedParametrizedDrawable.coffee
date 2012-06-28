#
class NamedParametrizedDrawable extends ParametrizedDrawable
    constructor: ( name, data ) ->
        super data
        
        @add_attr
            name: name
    
    toString: ->
        @name.get()
