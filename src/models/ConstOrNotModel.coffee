class ConstOrNotModel extends Model
    constructor: ( bool, model, check_disabled = true ) ->
        super()
                
        # default
        @add_attr
            bool : bool
            model: model
            check_disabled : check_disabled
                
    get: ->
        @model?.get()
        
    set: ( value ) ->
        @model?.set value
            
    toString: ->
        @model?.toString()