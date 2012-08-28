class ConstOrNotModel extends Model
    constructor: ( bool, model ) ->
        super()
        
        # default
        @add_attr
            bool : bool
            model: model
