# String
class Str extends Obj
    constructor: ( data ) ->
        super()
        
        # default value
        @_data = ""
        @length = 0

        # init if possible
        if data?
            @_set data

    # toggle presence of str in this
    toggle: ( str, space = " " ) ->
        l = @_data.split space
        i = l.indexOf str
        if i < 0
            l.push str
        else
            l.splice i, 1
        @set l.join " "

    # true if str is contained in this
    contains: ( str ) ->
        @_data.indexOf( str ) >= 0

    #
    equals: ( str ) ->
        return @_data == str.toString()

    _get_fs_data: ( out ) ->
        out "C #{@_server_id} #{encodeURI @_data} "

    #
    _set: ( value ) ->
        if not value?
            return @_set ""
        n = value.toString()
        if @_data != n
            @_data = n
            @length = @_data.length
            return true
        return false

    #
    _get_state: ->
        encodeURI @_data

    _set_state: ( str, map ) ->
        @set decodeURIComponent str

    
    