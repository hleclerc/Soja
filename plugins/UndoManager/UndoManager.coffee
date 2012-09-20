# each time you are going to make an important modification, call snapshot()
# 
class UndoManager
    
    #
    constructor: ( @model ) ->
        @max_patchs = 3
        @patch_undo = []
        @patch_redo = []
        @snapshotok = true
            
    #
    snapshot: ( force = false ) ->
        if @snapshotok or force
            @snapshotok = false
            
            # actual work
            date = @_date_last_snapshot()
            

            # if something has changed since previous undo or snapshot
            if @model._date_last_modification > date
                @patch_redo = []
                
                @patch_undo.push
                    date: Model._counter
                    data: @model.get_state date
            

            # console.log "patch : ", JSON.stringify( @patch_undo, null, "\t" )
            if @patch_undo.length > @max_patchs
                lst_0 = @patch_undo[ 0 ].data.split "\n"
                lst_1 = @patch_undo[ 1 ].data.split "\n"
                mid_0 = lst_0.shift()
                mid_1 = lst_1.shift()
                if mid_0 != mid_1
                    console.log "weird"
                map = {}
                for l in lst_0 when l.length
                    s = l.split " "
                    map[ s[ 0 ] ] = 
                        type: s[ 1 ]
                        data: s[ 2 ]
                n_data = ""
                for l in lst_1 when l.length
                    s = l.split " "
                    delete map[ s[ 0 ] ]
                for mid, dma of map
                    @patch_undo[ 1 ].data += "\n" + mid + " " + dma.type + " " + dma.data
                @patch_undo.shift()

        # snapshot authorization after 250ms of inactivity
        if @_timer_snap?
            clearTimeout @_timer_snap
        @_timer_snap = setTimeout ( => @snapshotok = true ), 250
        
        
    #
    undo: ( num = 1 ) ->
        # we make a snapshot for eventual redos
        @snapshot true

        num = Math.min num, @patch_undo.length - 1
        if num > 0
            # last states go to redo
            for n in [ 0 ... num ]
                @patch_redo.push @patch_undo.pop()
                
            # modify state
            @_set_state_undo_list()
        
    #
    redo: ( num = 1 ) ->
        date = @_date_last_snapshot()
        if @model._date_last_modification > date
            @patch_redo = []
            
        num = Math.min num, @patch_redo.length
        if num > 0
            # last states go to redo
            for n in [ 0 ... num ]
                @patch_undo.push @patch_redo.pop()
        
            # modify state
            @_set_state_undo_list()

    # set model state according to all patches from @patch_undo
    _set_state_undo_list: ->
        # compute the state using patches from the beginning to the wanted date
        map = {}
#         console.log "---Set_state-----"
#         console.log "patch_undo : ", JSON.stringify(@patch_undo, null, "\t")
        for p in @patch_undo
            lst = p.data.split "\n"
            lst.shift() # model_id
            for l in lst when l.length
                s = l.split " "
                map[ s[ 0 ] ] = 
                    type: s[ 1 ]
                    data: s[ 2 ]
                    buff: undefined

#         console.log "map : ", JSON.stringify(map, null, "\t")
#         console.log "model_id : ", @model.model_id
        
        # change the model
        @model._set_state map[ @model.model_id ].data, map

        # 
        if @patch_undo.length
            @patch_undo[ @patch_undo.length - 1 ].date = Model._counter + 2

    _date_last_snapshot: ->
        if @patch_undo.length
            return @patch_undo[ @patch_undo.length - 1 ].date
        return -1

        
