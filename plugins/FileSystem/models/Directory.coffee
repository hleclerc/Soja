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
        
    add_file: ( name, obj ) ->
        
        @push new File name, 1
   