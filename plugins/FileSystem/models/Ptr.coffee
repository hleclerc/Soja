# contains an id of a model on the server
#
#
class Ptr extends Model
    constructor: ( model ) ->
        super()
        
        @data =
            model: model
            value: 0
            
        
    _get_fs_data: ( out ) ->
        out.mod += "C #{@_checked_server_id out} #{@data.model._checked_server_id out} "

    _set: ( value ) ->
        if @data != value
            @data = value
            return true
        return false
            
    _get_state: ->
        @_data

    _set_state: ( str, map ) ->
        @set str

