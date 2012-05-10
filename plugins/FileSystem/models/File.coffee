#
class File extends Model
    constructor: ( name = "", ptr_or_model = 0, info = {} ) ->
        super()

        # 
        cp_info = {}
        for key, val of info
            cp_info[ key ] = val
        
        if ptr_or_model instanceof Model
            if not cp_info.model_type?
                cp_info.model_type = Model.get_object_class ptr_or_model
            ptr_or_model.get_file_info? cp_info

        #
        @add_attr
            name: name
            _ptr: new Ptr ptr_or_model
            _info: cp_info
            # -> img : "data/base64...."
            # -> icon: "toto"
            # -> model_type: "Directory"...
            