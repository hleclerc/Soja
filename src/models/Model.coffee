# scalar
class Model
    @_counter: 0  # nb "change rounds" since the beginning ( * 2 to differenciate direct and indirect changes )
    @_modlist: {} # changed models (current round)
    @_n_views: {} # new views (that will need a first onchange call in "force" mode)
    @_cur_mid: 0 # current model id (used to create new ids)
    @_timeout: undefined # timer used to create a new "round"
    @_force_m: false # if _force_m == true, every has_been_modified function will return true
    @_synchro: undefined # synchronizer (link to the server that will store files)

    constructor: ( attr ) ->
        # registered attribute names (in declaration order)
        @attribute_names = []

        # id of the model
        @model_id = Model._cur_mid
        Model._cur_mid += 1

        # synchronized views
        @_views = [] 
        
        # parent models (depending on this)
        @_parents = [] 
        
        # "date" of previous change. We start at + 2 because we consider that an initialisation is a modification.
        @_date_last_modification = Model._counter + 2

        # init
        if attr?
            @_set attr

    destructor: ->
    
    # return true if this (or a child of this) has changed since previous synchronisation
    has_been_modified: ->
        @_date_last_modification > Model._counter - 2 or Model._force_m
        
    # return true if this has changed since previous synchronisation due to a direct modification (not from a child one)
    has_been_directly_modified: ->
        @_date_last_modification > Model._counter - 1 or Model._force_m

    # if this has been modified during the preceding round, f will be called
    # If f is a view:
    #  view.onchange will be called each time this (or a child of this) will be modified.
    #  view.destructor will be called if this is destroyed.
    #  ...
    #  can be seen as a bind with an object
    bind: ( f, onchange_construction = true ) ->
        if f instanceof View
            @_views.push f
            f._models.push this

            if onchange_construction
                Model._n_views[ f.view_id ] = f
                Model._need_sync_views()
        else
            class BindView extends View
                constructor: ( model ) -> super model, onchange_construction
                onchange: -> f()
            new BindView this


    # return a copy of data in a "standard" representation (e.g. string, number, objects, ...)
    # users are encouraged to use Models as much as possible (meaning that get should not be called for every manipulation),
    # adding methods for manipulation of data if necessary (e.g. toggle, find, ... in Lst, Str, ...).
    #
    # May be redefined for specific types (e.g. Str, Lst, ...)
    get: ->
        res = {}
        for name in @attribute_names
            res[ name ] = this[ name ].get()
        return res

    # modify data, using another values, or Model instances. Should not be redefined (but _set should be)
    # returns true if object os modified
    set: ( value ) ->
        if @_set value # change internal data
            @_signal_change()
            return true
        return false
        
    # modify state according to str. str can be the result of a previous @get_state
    set_state: ( str ) ->
        map = {}
        lst = str.split "\n"
        mid = lst.shift()
        for l in lst when l.length
            s = l.split " "
            map[ s[ 0 ] ] =
                type: s[ 1 ]
                data: s[ 2 ]
                buff: undefined
                
        # fill / update this with data in map[ mid ]
        map[ mid ].buff = this
        @_set_state map[ mid ].data, map

    # return a string which describes the changes in this and children since date
    get_state: ( date = -1 ) ->
        # get sub models
        fmm = {}
        @_get_flat_model_map fmm, date
            
        res = @model_id.toString()
        if @_date_last_modification > date
            for id, obj of fmm
                res += "\n" + obj.model_id + " " + Model.get_object_class( obj ) + " " + obj._get_state()
        return res
            
        
    # modify state according to str. str can be the result of a previous @get_state
    @new_from_state: ( str ) ->
        map = {}
        lst = str.split "\n"
        mid = lst.shift()
        for l in lst when l.length
            s = l.split " "
            map[ s[ 0 ] ] =
                type: s[ 1 ]
                data: s[ 2 ]
                buff: undefined
                
        # fill / update this with data in map[ mid ]
        eval "var __new__ = new #{map[ mid ].type};"
        __new__._set_state map[ mid ].data, map
        return __new__

    # add attribute (p.values must contain models)
    # can be called with
    #  - name, instance of Model (two arguments)
    #  - { name_1: instance_1, name_2: instance_2, ... } (only one argument)
    add_attr: ( n, p, signal_change = true ) ->
        # name, model
        if p?
            if typeof( p ) == "function"
                this[ n ] = p
            else
                if this[ n ]?
                    console.log "attribute #{n} already exists"
                p = Model.conv p
                
                if this not in p._parents
                    p._parents.push this
                @attribute_names.push n
                this[ n ] = p
                
                if signal_change
                    @_signal_change()
            
        # else, asuming { name_1: instance_1, name_2: instance_2, ... }
        else
            for key, val of n
                @add_attr key, val, signal_change
            

    # remove attribute named name
    rem_attr: ( name, signal_change = true ) ->
        c = this[ name ]
        if c
            i = c._parents.indexOf this
            if i >= 0
                c._parents.splice i, 1
                if c._parents.length == 0
                    c.destructor()
                    
            delete this[ name ]
            
            i = @attribute_names.indexOf name
            if i >= 0
                @attribute_names.splice i, 1
            
            if signal_change
                @_signal_change()

    # change attribute named n to p
    mod_attr: ( n, p ) ->
        @rem_attr n
        @add_attr n, p

    # dimension of the object -> [] for a scalar, [ length ] for a vector, ...
    size: ->
        []

    # dimensionnality of the object -> 0 for a scalar, 1 for a vector, ...
    dim: ->
        @size().length

    #
    equals: ( m ) ->
        if this == m
            return true
        u = {}
        for key, val of m when val instanceof Model
            if not this[ key ]?
                return false
            if not this[ key ].equals( val )
                return false
            u[ key ] = true
        for key, val of this when val instanceof Model
            if not u[ key ]?
                return false
        return false

    #
    @load: ( filename, func ) ->
        if not Model.synchronizer
            Model._synchro = new Synchronizer
        Model._synchro.load filename, func
        
        
    # If v is a Model, return v. Else, return a Model of guessed right type
    @conv: ( v ) ->
        if v instanceof Model
            return v
        if v instanceof Array
            return new Lst v
        if typeof v == "string"
            return new Str v
        if typeof v == "number"
            return new Val v
        if typeof v == "boolean"
            return new Bool v
        if v instanceof Object
            return new Model v
        return new Obj v

    # return the type of obj
    @get_object_class: ( obj ) ->
        if obj and obj.constructor and obj.constructor.toString
            arr = obj.constructor.toString().match ///function\s*(\w+)///
            if arr and arr.length == 2
                return arr[ 1 ]


    # may be redefined
    _get_state: ->
        str = for name, obj of this when obj instanceof Model
            name + ":" + obj.model_id
        return str.join ","
        
    # send data to server
    _get_fs_data: ( out, pre = "C", suf = "" ) ->
        console.log "TODO"

    # may be redefined
    # make instructions to go from $o to $this
    _get_patch: ( o, path ) ->
        res = ""

        # REM_ATTR
        ohis = {}
        for spl in o.split ","
            inr = spl.split ":"
            attr = inr[ 0 ]
            ohis[ attr ] = parseInt inr[ 1 ]
            if not @[ attr ]?
                res += "REM_ATTR " + path + " " + attr + "\n"
        
        # ADD_ATTR
        for attr, obj of this when obj instanceof Model
            if not ohis[ attr ]?
                res += "ADD_ATTR " + path + " " + attr + " " + obj.model_id + "\n"
            else if ohis[ attr ] != obj.model_id
                console.log ohis[ attr ], obj.model_id
                res += "MOD_ATTR " + path + " " + attr + " " + obj.model_id + "\n"
                
        return res
        
    # may be redefined.
    # by default, add attributes using keys and values (and remove old unused values)
    # must return true if data is changed
    _set: ( value ) ->
        change = false
        
        used = {}
        for key, val of value
            used[ key ] = true
            if this[ key ]?
                if this[ key ].constructor == val.constructor
                    change |= this[ key ].set( val )
                else
                    change = true
                    @mod_attr key, val, false
            else
                @add_attr key, val, false
            
        for key, val of this when val instanceof Model
            if not used[ key ]
                change = true
                @rem_attr key, false

        return change

    # called by set. change_level should not be defined by the user (it permits to != change from child of from this)
    _signal_change: ( change_level = 2 ) ->
        #
        if @_server_id?
            FileSystem.signal_change this
        
        # register this as a modified model
        Model._modlist[ @model_id ] = this

        # do the same thing for the parents
        if @_date_last_modification <= Model._counter
            @_date_last_modification = Model._counter + change_level
            for p in @_parents
                p._signal_change 1
                
        # start if not done a timer
        Model._need_sync_views()

    # generic definition of _set_state. ( called by _use_state )
    _set_state: ( str, map ) ->
        u = {} # used attributes. Permits to know what to destroy
        if str.length
            for spl in str.split ","
                inr = spl.split ":"
                attr = inr[ 0 ] # attribute name
                k_id = inr[ 1 ] # key in map of the corresponding object
                u[ attr ] = true
                
                # if already defined in the map
                if map[ k_id ].buff?
                    if not this[ attr ]?
                        @add_attr attr, map[ k_id ].buff
                    else if map[ k_id ].buff != this[ attr ]
                        @mod_attr attr, map[ k_id ].buff
                # else, if the attribute does not exist, we create if 
                else if not this[ attr ]?
                    @add_attr attr, Model._new_model_from_state k_id, map
                # else, we already have an attribute and map has not been already explored
                else if not this[ attr ]._set_state_if_same_type k_id, map
                    @mod_attr attr, Model._new_model_from_state k_id, map

        for attr, obj of this when obj instanceof Model
            if not u[ attr ]
                @rem_attr attr


    # return true if info from map[ mid ] if compatible with this.
    # If it's the case, use this information to update data
    _set_state_if_same_type: ( mid, map ) ->
        dat = map[ mid ]
        if Model.get_object_class( this ) == dat.type
            dat.buff = this
            @_set_state dat.data, map
            return true
        return false
    

    # map[ id ] = obj for each objects starting from this recursively
    _get_flat_model_map: ( map, date ) ->
        map[ @model_id ] = this
        
        for name, obj of this when obj instanceof Model
            if not map[ obj.model_id ]?
                if obj._date_last_modification > date
                    obj._get_flat_model_map map, date

    # create a Model using a line of get_state (using .type, .data, ...)
    @_new_model_from_state: ( mid, map ) ->
        info = map[ mid ]
        eval "info.buff = new #{info.type};"
        info.buff._set_state info.data, map
        return info.buff
        
    # say that something will need a call to Model._sync_views during the next round
    @_need_sync_views: ->
        if not Model._timeout?
            Model._timeout = setTimeout Model._sync_views, 1

    # the function that is called after a very short timeout, when at least one object has been modified
    @_sync_views: ->
        views = {}
        for id, model of Model._modlist
            for view in model._views
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
