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
                
                Loc.prototype.__defineGetter__ "length", ->
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
                
                Loc.prototype.__defineGetter__ "length", ->
                    @_size.val

                Loc.prototype.__defineSetter__ "length", ( l ) ->
                    if @_size.val < l
                        res = mmew type, l
                        del @_data.obj
                        @_data.ref res
                        @_size.set l

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
                    
                    
            __ptr_type_map[ n ] = Loc
        
    __ptr_type_map[ n ]

# vec type from size + '_' + base type
__vec_type_map = {}
