# scalar
class ConstrainedVal extends Model
    constructor: ( value, params = {} ) ->
        super()

        @add_attr
            val : value or 0
            _min: if params.min? then params.min else 0
            _max: if params.max? then params.max else 100
            _div: if params.div? then params.div else 0

    get: ->
        @val.get()

    ratio: ->
        ( @val.get() - @_min.get() ) / @delta()
    
    delta: ->
        @_max.get() - @_min.get()
    
    #
    _set: ( value ) ->
        if value instanceof ConstrainedVal
            return @val._set value.get()
        res = @val.set value
        @_check_val()
        return res

    #
    _check_val: ->
        v = @val .get()
        m = @_min.get()
        n = @_max.get()
        d = @_div.get()
        
        if v < m
            @val.set m
        if v > n
            @val.set n
            
        if d
            s = ( n - m ) / d
            r = m + Math.round( ( @val.get() - m ) / s ) * s
            @val.set r
