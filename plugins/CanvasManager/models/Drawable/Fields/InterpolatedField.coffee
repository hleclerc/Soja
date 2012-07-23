# 
class InterpolatedField extends Model
    constructor: ( name ) ->
        super()
        
        @add_attr
            _data: [] # List of { pos: list of { axe_name: ..., axe_value: ... }, field: ... }

    get_drawing_parameters: ( model ) ->
        if @_data.length
            @_data[ 0 ].field.get_drawing_parameters model

    get_sub_field: ( info ) ->
        # TODO other axes
        for t, n in @_data
            if t.pos[ 0 ].axe_name.equals "time"
                if t.pos[ 0 ].axe_value.get() >= info.time
                    return t.field
        if @_data.length
            return @_data[ @_data.length - 1 ].field
            
    get_val: ( info, i ) ->
        f = @get_sub_field info
        if f?
            f.get_val info, i

    draw: ( info, parameters, additionnal_parameters ) ->
        if parameters?.legend?.auto_fit?.get()
            @actualise_value_legend_all_fields parameters
            
        f = @get_sub_field info
        if f?
            f.draw info, parameters, additionnal_parameters
    
    z_index: ->
        if @_data.length
            @_data[ 0 ].field.z_index()
        else
            0
    sub_canvas_items: ->
        console.log 'interpolated sub canvas'

    actualise_value_legend_all_fields: ( parameters ) ->
        max = -Infinity
        min = Infinity
        for interpo_field in @_data
            field = interpo_field.field
            maxus = field.get_max_data()
            minus = field.get_min_data()
            if minus < min
                min = minus
            if maxus > max
                max = maxus
        parameters.legend.min_val.set min
        parameters.legend.max_val.set max
