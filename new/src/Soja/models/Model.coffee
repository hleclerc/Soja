# dep ../views/FunctionBinder.coffee
# dep ../util/ModelIterator.coffee
# dep ../util/mew.coffee

#
#
# Technically Model are only views on binary data, meaning that most of the created models are "transient" (freed right after creation).
class Model
    # std attributes
    # __orig   -> parent object, that contains
    # __id     -> only if orig == this. Id of the model (used by pointers).
    # __data   -> only if orig == this. Binary buffer that contains the data
    # __numsub -> num sub attr from __orig (each object and sub object in __orig has a specific __numsub)
    # __offset -> offset in bytes from the beginning of __data
    # __views  -> connected views
    # _parents -> parent model (that may use this with a ptr) 
    # _date_last_modification ->
    
    # static arguments
    @_counter: 0  # nb "change rounds" since the beginning ( * 2 to differenciate direct and indirect changes )
    @_modlist: {} # changed models (current round)
    @_n_views: {} # new views (that will need a first onchange call in "force" mode)
    @_timeout: undefined # timer used to create a new "round" (to call View.on_change)
    @_force_m: false # if _force_m == true, every has_been_modified function will return true    
    @__id_map: {} # __id -> model
    @__cur_id: 1 # current model id (the one that will be used for the next created base model)
    
    @__conv_list: [
        ( val ) -> if typeof val == "function" then val
        ( val ) -> if val instanceof Model then val.constructor
    ]
    
    # model.val <-> get()
    Model::__defineGetter__ "val", ->
        @get()

    # model.val = x <-> set x
    Model::__defineSetter__ "val", ( v ) ->
        @set v
    
    # pointer data on this
    Model::__defineGetter__ "ptr", ->
        { model_id: @__orig.__id, num_attr: @__numsub, orig: this }


    # list with name of model attributes
    Model::__defineGetter__ "attr_names", ->
        for item in @constructor.__type_info.attr
            item.name

    # return true if this (or a child of this) has changed since the previous synchronisation
    Model::__defineGetter__ "has_been_modified", ->
        @_date_last_modification > Model._counter - 2 or Model._force_m
        
    # return true if this has changed since previous synchronisation due to a direct modification (not from a child one)
    Model::__defineGetter__ "has_been_directly_modified", ->
        @_date_last_modification > Model._counter - 1 or Model._force_m

    # if this has been modified during the preceding round, f will be called
    # If f is a view:
    #  view.onchange will be called each time this (or a child of this) will be modified.
    #  view.destructor will be called if this is destroyed.
    #  ...
    #  can be seen as a bind with an object
    # onchange_construction true means that onchange will be automatically called after the bind
    bind: ( f, onchange_construction = true ) ->
        if f instanceof View
            @__views.push f
            f.__models.push this

            if onchange_construction
                Model._n_views[ f.view_id ] = f
                Model._need_sync_views()
        else
            new FunctionBinder this, onchange_construction, f

    #  ...
    # 
    unbind: ( f ) ->
        if f instanceof View
            @__views.splice @__views.indexOf( f ), 1
            f.__models.splice f.__models.indexOf( this ), 1
        else
            for v in @__views when v instanceof FunctionBinder and v.f == f
                @unbind v

    #
    get: ( val ) -> 
        res = {}
        for name in @attr_names
            res[ name ] = @[ name ].get()
        return res
    # modify data, using another values, or Model instances. Should not be redefined (but _set should be)
    # returns true if object os modified
    set: ( value ) ->
        if @__set value # change internal data
            @_signal_change()
            true
        else
            false

    #
    __set: ( val ) -> 
        # TODO: remove this first case when JS 1.7 will appear :)
        res = false
        if val instanceof Model
            for name in @attr_names
                res |= @[ name ]?.__set val[ name ]
        else
            for n, v of val
                res |= @[ n ]?.__set v
        res

    # helper
    __set_view: ( view, val ) ->
        if view[ 0 ] == val
            return false
        view[ 0 ] = val
        return true

    #        
    __iterator__: ->
        new ModelIterator @constructor.__type_info.attr

    # true if ModelEditorInput works for this
    Model::__defineGetter__ "__input_edition", ->
        false
    
    # called by set. change_level should not be defined by the user (it permits to != change from child of from this)
    _signal_change: ( change_level = 2 ) ->
        # register this as a modified model
        Model._modlist[ @__orig.__id ] = this

        # do the same thing for the parents
        if @_date_last_modification <= Model._counter
            @_date_last_modification = Model._counter + change_level
            for p in @__orig._parents
                p._signal_change 1
                
        # start if not done a timer
        Model._need_sync_views()
        
    # get sub attr number n. Must be called from an __orig object
    __subn: ( n ) ->
        nsub = @constructor.__type_info.nsub
        size = @constructor.__type_info.size
        @__subn_rec n % nsub, Math.floor( n / nsub ) * size

    # get sub attr number n assuming n < nsub (inside a given item of a vector)
    __subn_rec: ( n, offset ) ->
        if n
            n--
            for item in @constructor.__type_info.attr
                s = item.type.__type_info.nsub
                if n < s
                    m = @[ item.name ]
                    return m.__subn_rec n, offset
                n -= s
        if offset
            __clone this, __offset: @__offset + offset
        else
            this


    # get array buffer (or corresponding slice) that stores the data of this
    __array_buffer: ( n = 1 ) ->
        @__orig.__data.slice @__offset, @__offset + n * @constructor.__type_info.size
    
    # allows for conversion from standard javascript objects (e.g. 10, "foo") to Model
    # if val is already a Model, returns val
    @__conv: ( val ) ->
        for f in Model.__conv_list
            res = f val
            if res?
                return res
        console.error "unknown type (#{val.constructor})"

    # if no __type_info, make it, and add getters in prototypes
    @__make___type_info_and_protoype: ( type ) ->
        if not type.__type_info?
            # basic data 
            type.__type_info = {}
            if type.__type_name?
                type.__type_info.name = type.__type_name
            else
                type.__type_info.name = type.toString().match( ///function\s*(\w+)/// )[ 1 ]
                
            # precomputations
            s = 0
            i = 1
            lst = []
            for n, v of type.attr
                t = Model.__conv v
                Model.__make___type_info_and_protoype t
                if typeof v == "function"
                    v = undefined

                lst.push
                    name         : n
                    type         : t
                    offset       : s
                    default_value: v

                do ( n, t, s, i ) ->
                    type::__defineGetter__ n, ->
                        res = new t
                        res.__orig   = @__orig
                        res.__offset = @__offset + s
                        res.__numsub = i
                        res
                        
                    type::__defineSetter__ n, ( val ) ->
                        @[ n ].set val
                
                s += t.__type_info.size
                i += t.__type_info.nsub
            
            # completion of __type_info
            type.__type_info.size = s
            type.__type_info.nsub = i
            type.__type_info.attr = lst

        
    # say that something will need a call to Model._sync_views during the next round
    @_need_sync_views: ->
        if not Model._timeout?
            Model._timeout = setTimeout Model._sync_views, 1

    # the function that is called after a very short timeout, when at least one object has been modified
    @_sync_views: ->
        views = {}
        for id, model of Model._modlist
            for view in model.__views
                views[ view.view_id ] = 
                    value: view
                    force: false

        for id, view of Model._n_views
            views[ id ] =
                value: view
                force: true

        Model._timeout = undefined
        Model._modlist = {}
        Model._n_views = {}
        Model._counter += 2
        
        for id, view of views
            Model._force_m = view.force
            view.value.onchange()
                
        Model._force_m = false

