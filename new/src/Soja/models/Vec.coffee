# dep Model.coffee

# vector of fixed size on a given type.
Vec = ( type, size = -1, args ) ->
    Model.__make___type_info_and_protoype type
    n = size + '_' + type.__type_info.name
    if not __vec_type_map[ n ]?
        if size >= 0
            # static size
            class Loc extends Model
                @attr = {}
                @type = type
                @size = size
                @__type_name = "Vec( #{ type.__type_info.name }, #{ size } )"
                
                Loc::__defineGetter__ "length", ->
                    Loc.size

            for i in [ 0 ... size ]
                Loc.attr[ i ] = type
                    
            __ptr_type_map[ n ] = Loc
        else
            # dynamic size
            class Loc extends Model
                @attr =
                    _data: Ptr type
                    _size: 0
                @type = type
                @size = size
                @__type_name = "Vec( #{ type.__type_info.name } )"
                
                Loc::__defineGetter__ "length", ->
                    @_size.val

                Loc::__defineSetter__ "length", ( l ) ->
                    @resize l

                at: ( n ) ->
                    @_data.at n

                get: ( n ) -> 
                    if n?
                        obj = @_data.at n
                        obj.val
                    else
                        for i in [ 0 ... @length ]
                            @_data.at( i ).val
                    
                set: ( val ) ->
                    @resize val.length
                    if val instanceof Model # TODO rm this specific case when js > 1.7
                        for i in [ 0 ... @length ]
                            @at( i ).set val.at iS
                    else
                        for i in [ 0 ... @length ]
                            @at( i ).set val[ i ]
                    
                    
                resize: ( l, default_value ) ->
                    if @_size.val < l
                        old = if @_data.obj? then @_data.obj.__array_buffer l
                        res = mmew type, l,
                            default_value: default_value
                            array_buffer : old
                            beg_init     : @length
                        del @_data.obj
                        @_data.set res.ptr
                    @_size.set l
                    
            __ptr_type_map[ n ] = Loc
        
    __ptr_type_map[ n ]

# vec type from size + '_' + base type
__vec_type_map = {}
