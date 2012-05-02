# false by default
#
class Bool extends Obj
    constructor: ( data ) ->
        super()

        @_data = false

        # default values
        if data?
            @_set data
    
    # toggle true / false ( 1 / 0 )
    toggle: ->
        @set not @_data

    toBoolean: ->
        @_data

    #
    deep_copy: ->
        new Bool @_data

    # we do not take _set from Obj because we want a conversion if value is not a boolean
    _set: ( value ) ->
        if n instanceof Model
            n = value.toBoolean()
        else if value == "false"
            n = false
        else if value == "true"
            n = true
        else
            n = Boolean value

        if @_data != n
            @_data = n
            return true

        return false
        