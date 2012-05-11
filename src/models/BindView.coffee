# permits to bind a function to a model
# f is the function which is binded
# onchange_construction is a boolean who call onchange function when model is created
class BindView extends View
    constructor: ( model, onchange_construction, @f ) ->
        super model, onchange_construction
    onchange: ->
        @f()
