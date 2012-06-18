# 
class InterpolatedField extends Model
    constructor: ( name ) ->
        super()
        
        @add_attr
            name: name
            data: [] # List of { pos: list of { axe_name: ..., axe_value: ... }, field: ... }
        
    toString: ->
        @name.get()

    draw: ( info, display_style, triangles, proj, legend ) ->
        # TODO other axes
        for t, n in @data
            if t.pos.axe_value.get() >= info.time
                return t.pos.field.draw info, display_style, triangles, proj, legend
        if @data.length
            @data[ 0 ].field.draw info, display_style, triangles, proj, legend
    