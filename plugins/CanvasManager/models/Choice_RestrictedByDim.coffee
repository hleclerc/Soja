#
class Choice_RestrictedByDim extends Choice
    constructor: ( data, initial_list = [] ) ->
        super data, initial_list

        @add_attr
            wanted_dim: [ 2, 3 ]

    filter: ( obj ) ->
        @wanted_dim.contains obj.dim()
