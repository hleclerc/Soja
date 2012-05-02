class File extends Model
    constructor: ( name = "", ptr = 0 ) ->
        super()

        @add_attr
            name: name
            _ptr: ptr # _server_id of the object. The corresponding model can be found using FilesSystem._objects[ _ptr ]
    