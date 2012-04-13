#
# data from changed object are sent if not activity since 100ms
# 
#
class FileSystem
    # when object are saved, their _server_id is assigned to a tmp value
    @_cur_tmp_server_id = 0
    @_sig_server = true # if changes has to be sent
    
    # data are sent after a timeout (and are concatened before)
    @_objects_to_send = {}
    @_timer_send = undefined #
    @_timer_chan = undefined #
    
    # functions to be called after an answer
    @_nb_callbacks = 0
    @_callbacks = {}

    # instances of FileSystem
    @_nb_insts = 0
    @_insts = {}
    
    # ..._server_id -> object
    @_tmp_objects = {} # objects waiting for a real _server_id
    @_objects = {} # _server_id -> object
    
    constructor: ( @url = "/cmd" ) ->
        # default values
        @_data_to_send    = ""
        @_session_num     = -2 # -1 means that we are waiting for a session id after a first request.
        @_num_inst        = FileSystem._nb_insts++
        
        # register this in FileSystem instances
        FileSystem._insts[ @_num_inst ] = this    
        
        # first, we need a session id fom the server
        @send "S #{@_num_inst} "
        
    
    # load object in $path and call $callback with the corresponding ref
    load: ( path, callback ) ->
        @send "L #{encodeURI path} #{FileSystem._nb_callbacks} "
        FileSystem._callbacks[ FileSystem._nb_callbacks ] = callback
        FileSystem._nb_callbacks++
        
    # explicitly send a command
    send: ( data ) ->
        @_data_to_send += data
        if not FileSystem._timer_send?
            FileSystem._timer_send = setTimeout FileSystem._timeout_send_func, 1

    # send a request for a "push" channel
    make_channel: ->
        xhr_object = FileSystem._my_xml_http_request()
        xhr_object.open 'GET', "/_?s=#{@_session_num}", true
        xhr_object.onreadystatechange = ->
            if @readyState == 4 and @status == 200
                console.log "chan ->", @responseText
                FileSystem._sig_server = false
                eval @responseText
                FileSystem._sig_server = true
        xhr_object.send()
        
    # 
    @save_if_necessary: ( out, obj ) ->
        if not obj._server_id?
            obj._server_id = FileSystem._get_cur_tmp_server_id()
            obj._get_fs_data out, "N", "#{Model.get_object_class( obj )} "
            FileSystem._tmp_objects[ obj._server_id ] = obj

    # send changes of m to instances. m is assumed to have a _server_id 
    @signal_change: ( m ) ->
        if FileSystem._sig_server
            FileSystem._objects_to_send[ m.model_id ] = m
            if FileSystem._timer_chan?
                clearTimeout FileSystem._timeout_chan
            FileSystem._timer_chan = setTimeout FileSystem._timeout_chan_func, 100

    #
    @_tmp_id_to_real= ( tmp_id, res ) ->
        tmp = FileSystem._tmp_objects[ tmp_id ]
        delete FileSystem._tmp_objects[ tmp_id ]
        FileSystem._objects[ res ] = tmp
        tmp._server_id = res

    @_get_cur_tmp_server_id: ->
        FileSystem._cur_tmp_server_id++
        if FileSystem._cur_tmp_server_id % 4 == 0
            FileSystem._cur_tmp_server_id++
        FileSystem._cur_tmp_server_id
            
    # timeout for at least one changed object
    @_timeout_chan_func: ->
        for n, m of FileSystem._objects_to_send
            m._get_fs_data ( d ) => 
                for k, f of FileSystem._insts
                    f.send d
        #
        delete FileSystem._timer_chan
        FileSystem._objects_to_send = {}

    # 
    @_timeout_send_func: ->
        for k, f of FileSystem._insts when f._data_to_send.length
            # if we are waiting for a session id, do not send the data
            # (@responseText will contain another call to @_timeout_send with the session id)
            if f._session_num == -1
                continue
            
            # for first call, do not add the session id (but say that we are waiting for one)
            if f._session_num == -2
                f._session_num = -1
            else
                f._data_to_send = "s #{f._session_num} " + f._data_to_send
                
            # request
            xhr_object = FileSystem._my_xml_http_request()
            xhr_object.open 'POST', f.url, true
            xhr_object.onreadystatechange = ->
                if @readyState == 4 and @status == 200
                    console.log "resp ->", @responseText
                    FileSystem._sig_server = false
                    eval @responseText
                    FileSystem._sig_server = true
            xhr_object.send f._data_to_send + "E "
            console.log "-> ", f._data_to_send
            f._data_to_send = ""
        #
        delete FileSystem._timer_send
    
    @_my_xml_http_request: ->
        if window.XMLHttpRequest
            return new XMLHttpRequest
        if window.ActiveXObject
            return new ActiveXObject 'Microsoft.XMLHTTP'
        alert 'Your browser does not seem to support XMLHTTPRequest objects...'
