# dep Model.coffee

# vector of fixed size on a given type.
Vec = ( type, size, args ) ->
    Model.__make___type_info_and_protoype type
    n = size + '_' + type.__type_info.name
    if not __vec_type_map[ n ]?
        class Loc extends Model
            @attr = {}
            @type = type
            @size = size
            
            Model.prototype.__defineGetter__ "length", ->
                Loc.size

        for i in [ 0 ... size ]
            Loc.attr[ i ] = type
                
        __ptr_type_map[ n ] = Loc
        
    __ptr_type_map[ n ]

# vec type from size + '_' + base type
__vec_type_map = {}
