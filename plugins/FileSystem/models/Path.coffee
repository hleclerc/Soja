# contains (privately on the server) a path to data on the server
class Path extends Model
    # @file is optionnal. Must be a javascript File object
    constructor: ( @file ) ->
        super()

    _get_fs_data: ( out ) ->
        # will make a new
        if @file?
            FileSystem.set_server_id_if_necessary out, this
            if @_server_id & 3
                FileSystem._files_to_upload[ @_server_id ] = this
    