class File extends Model
    constructor: ( name = "" ) ->
        super()

        @add_attr
            name: name
            _ptr: 0
    