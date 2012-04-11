#
class FileSystem
    # data are sent after a timeout (and are concatened before)
    @_timer = undefined #
    
    # functions to be called after an answer
    @_nb_callbacks = 0
    @_callbacks = {}

    # instances of FileSystem
    @_nb_insts = 0
    @_insts = {}
    
    # _server_id -> object
    @_objects = {}
    
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
        if not FileSystem._timer?
            FileSystem._timer = setTimeout FileSystem._timeout_func, 0

    # send a request for a "push" channel
    make_channel: ->
        xhr_object = FileSystem._my_xml_http_request()
        xhr_object.open 'GET', "/_?s=#{@_session_num}", true
        xhr_object.onreadystatechange = ->
            if @readyState == 4 and @status == 200
                # console.log "chan ->", @responseText
                eval @responseText
        xhr_object.send()

    # send changes of m to instances. m is assumed to have a _server_id 
    @signal_change: ( m ) ->
        for k, f of FileSystem._insts
            f.send "C #{m._server_id} #{m._get_state()} "
        

    # 
    @_timeout_func: ->
        delete FileSystem._timer
        for k, f of FileSystem._insts when f._data_to_send.length
            # if we are waiting for a session id, do not send the data
            # (@responseText will contain another call to @_timeout_func with the session id)
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
                    #console.log "resp ->", @responseText
                    eval @responseText
            xhr_object.send f._data_to_send + "E "
            # console.log "-> ", f._data_to_send
            f._data_to_send = ""
    
    @_my_xml_http_request: ->
        if window.XMLHttpRequest
            return new XMLHttpRequest
        if window.ActiveXObject
            return new ActiveXObject 'Microsoft.XMLHTTP'
        alert 'Your browser does not seem to support XMLHTTPRequest objects...'
