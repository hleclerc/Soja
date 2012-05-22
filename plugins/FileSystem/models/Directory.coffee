# List of files
# _underlying_fs_type is not needed ()
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

    load: ( name, callback ) ->
        f = @find name
        if f
            f.load callback
        else
            callback undefined, "file does not exist"
        
    has: ( name ) ->
        for f in this
            if f.name.equals name
                return true
        return false
    
    add_file: ( name, obj, params = {} ) ->
        o = @find name
        if o?
            return o
        res = new File name, obj, params
        @push res
        return res

    get_file_info: ( info ) ->
        info.icon = "folder"
        
