# dep Model.coffee

# pointer on a given type. 
Ptr = ( type, args ) ->
    Model.__make___type_info_and_protoype type
    n = type.__type_info.name
    if not __ptr_type_map[ n ]?
        class Loc extends Model
            @attr =
                model_id: 0
                offset  : 0
            @type = type
            
            ref: ( obj ) ->
                if obj not instanceof Loc.type
                    console.error "Bad ptr"
                @model_id.set obj.__orig.__id
                @offset.set obj.__offset
                
            Model.prototype.__defineGetter__ "obj", ->
                Model.__id_map[ @model_id.val ]
            
        __ptr_type_map[ n ] = Loc
        
    __ptr_type_map[ n ]

__ptr_type_map = {}
