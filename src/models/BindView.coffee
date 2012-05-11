# permits to bind a function to a model
class BindView extends View
    constructor: ( model ) ->
        super model, onchange_construction
        @f = f
    onchange: ->
        f()
