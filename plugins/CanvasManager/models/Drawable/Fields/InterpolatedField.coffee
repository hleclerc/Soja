# 
class InterpolatedField extends Model
    constructor: ( name ) ->
        super()
        
        @add_attr
            data: [] # List of { pos: list of { axe_name: ..., axe_value: ... }, field: ... }

    get_drawing_parameters: ( model ) ->
        if @data.length
            @data[ 0 ].field.get_drawing_parameters model
            

    draw: ( info, parameters ) ->
        # TODO other axes
        for t, n in @data
            if t.pos[ 0 ].axe_name.get().toLowerCase() == "time"
                if t.pos[ 0 ].axe_value.get() >= info.time
                    return t.field.draw info, parameters
        if @data.length
            @data[ 0 ].field.draw info, parameters
    
    z_index: ->
        if @data.length
            @data[ 0 ].field.z_index()
        else
            0
            