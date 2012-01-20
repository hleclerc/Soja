# generic object with data
class Obj extends Model 
    constructor: ( data ) ->
        super()
        
        if data?
            @_set data

    toString: ->
        @_data.toString()

    equals: ( obj ) ->
        if obj instanceof Obj
            return @_data == obj._data
        return @_data == obj

    get: ->
        @_data

    _set: ( value ) ->
        if @_data != value
            @_data = value
            return true
        return false
            
    _get_state: ->
        @_data

    _set_state: ( str, map ) ->
        @set str

    _get_patch: ( o, path ) ->
        if o != @_data
            return "SET " + path + " " + @_data
        return ""
        