# contains an id of a model on the server
#
#
class Ptr extends Model
    constructor: ( model ) ->
        super()
        
        if typeof model == "number"
            @data =
                value: 0
        else if model instanceof Model
            @data =
                model: model
                value: model._server_id
            
        
    load: ( callback ) ->
        if @data.model?
            callback @data.model, false
        else if FileSystem._insts.length
            FileSystem._insts[ 0 ].load_ptr @data.value, callback
            
        
    _get_fs_data: ( out ) ->
        if @data.model?
            out.mod += "C #{@_checked_server_id out} #{@data.model._checked_server_id out} "
            #
            @data.value = @data.model._server_id
            if @data.model._server_id & 3
                FileSystem._ptr_to_update[ @model_id ] = this
        else
            out.mod += "C #{@_checked_server_id out} #{@data.value} "

    _set: ( value ) ->
        if @data != value
            @data = value
            return true
        return false
            
    _get_state: ->
        @_data

    _set_state: ( str, map ) ->
        @set str

