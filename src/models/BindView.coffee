# permits to bind a function to a model
class BindView extends View
    constructor: ( model, onchange_construction ) ->
        super model, onchange_construction
        @f = f
    onchange: ->
        f()
