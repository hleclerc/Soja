# dep Model.coffee

# pointer on a given type. 
Ptr = ( type, args ) ->
    Model.__make___type_info_and_protoype type
    n = type.__type_info.name
    if not __ptr_type_map[ n ]?
        class Loc extends Model
            @attr =
                model_id: 0
                num_attr: 0
            @type = type
            @__type_name = "Ptr( #{ n } )"
            
            set: ( obj ) ->
                if obj not instanceof Model and obj.orig not instanceof Loc.type
                    console.error "Bad ptr ('#{obj.orig.constructor.__type_info.name}' is not and instance of '#{Loc.type.__type_info.name}') !"
                super obj
             
            at: ( n ) ->
                if @model_id.val
                    Model.__id_map[ @model_id.val ].__subn @num_attr.val + n * Loc.type.__type_info.nsub
             
            Loc::__defineGetter__ "obj", ->
                if @model_id.val
                    Model.__id_map[ @model_id.val ].__subn @num_attr.val
                
            
                
        __ptr_type_map[ n ] = Loc
        
    __ptr_type_map[ n ]

# ptr type from base type
__ptr_type_map = {}
