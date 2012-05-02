# scalar
class Val extends Obj
    constructor: ( data ) ->
        super()

        @_data = 0

        # default values
        if data?
            @_set data
    
    # toggle true / false ( 1 / 0 )
    toggle: ->
        @set not @_data

    #
    toBoolean: ->
        Boolean @_data

    #
    deep_copy: ->
        new Val @_data

    # we do not take _set from Obj because we want a conversion if value is not a number
    _set: ( value ) ->
        if typeof value == "string"
            if value.slice( 0, 2 ) == "0x"
                n = parseInt value, 16
            else
                n = parseFloat value
                if isNaN n
                    n = parseInt value
                if isNaN n
                    console.log "Don't know how to transform #{value} to a Val"
        else if typeof value == "boolean"
            n = 1 * value
        else if value instanceof Val
            n = value._data
        else # assuming a number
            n = value

        if @_data != n
            @_data = n
            return true

        return false
        