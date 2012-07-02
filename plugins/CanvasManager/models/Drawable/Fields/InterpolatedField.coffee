# 
class InterpolatedField extends Model
    constructor: ( name ) ->
        super()
        
        @add_attr
            _data: [] # List of { pos: list of { axe_name: ..., axe_value: ... }, field: ... }

    get_drawing_parameters: ( model ) ->
        if @_data.length
            @_data[ 0 ].field.get_drawing_parameters model
            

    draw: ( info, parameters ) ->
        # TODO other axes
        for t, n in @_data
            if t.pos[ 0 ].axe_name.get().toLowerCase() == "time"
                if t.pos[ 0 ].axe_value.get() >= info.time
                    return t.field.draw info, parameters
        if @_data.length
            @_data[ 0 ].field.draw info, parameters
    
    z_index: ->
        if @_data.length
            @_data[ 0 ].field.z_index()
        else
            0
            