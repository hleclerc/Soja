
class UploadData extends Model
    constructor: ( data = undefined ) ->
        super()
        
        @data = data
        
    get: ->
        return @data
        
    set: ( data ) ->
        @data = data