# List of files
class Directory extends Lst
    constructor: () ->
        super()

    base_type: ->
        File
    
    find: ( name ) ->
        for f in this
            if f.name.equals name
                return f
        return undefined
        
    add_file: ( name, obj, params = {} ) ->
        o = @find name
        if o?
            return o
        res = new File name, obj, params
        @push res
        return res

    get_file_info: ( info ) ->
        info.model_type = "Directory"
        info.icon = "folder"
