#
class FileItem extends TreeItem
    constructor: ( file ) ->
        super()
        
        if file?
            @add_attr
                _ptr: file._ptr
            
            @_name.set file.name
            @_ico.set "img/view-presentation.png"
            