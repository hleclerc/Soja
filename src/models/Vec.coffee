# Vector of Val
class Vec extends Lst
    constructor: ( data ) ->
        super data

    base_type: ->
        Val

    _underlying_fs_type: ->
        "Lst"
        