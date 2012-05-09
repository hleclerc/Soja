#
class File extends Model
    constructor: ( name = "", ptr_or_model = 0, info = {} ) ->
        super()

        @add_attr
            name: name
            _ptr: new Ptr ptr_or_model
            _info: info
            # -> img : "data/base64...."
            # -> icon: "toto"
            # -> model_type: "Directory"...
            