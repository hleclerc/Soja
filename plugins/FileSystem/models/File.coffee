class File extends Model
    constructor: ( name = "", ptr = 0 ) ->
        super()

        @add_attr
            name: name
            _info: {
                #img : "data/base64...."
                #icon: "toto"
                #model_type:
            }
            _ptr: ptr # _server_id of the object. The corresponding model can be found using FilesSystem._objects[ _ptr ]
    
        icones =
            toto: new Image
                src: "data/base64...."
            