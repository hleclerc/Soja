# 
class InterpolatedField extends Model
    constructor: ( name ) ->
        super()
        
        @add_attr
            name: name
            data: [] # List of { pos: list of { axe_name: ..., axe_value: ... }, field: ... }
        
    toString: ->
        @name.get()

    draw: ( info, proj ) ->
        # TODO other axes
        console.log 'drawing interpolated field at time ', info.time
        for t, n in @data
            if t.pos.axe_name.get().toLowerCase() == "time"
                if t.pos.axe_value.get() >= info.time
                    return t.pos.field.draw info, proj
        if @data.length
            @data[ 0 ].field.draw info, proj
    