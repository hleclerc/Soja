# dep View.coffee

# permits to bind a function to a model
# f is the function which has to be binded
# onchange_construction true means that onchange will be automatically called after after the bind
class FunctionBinder extends View
    constructor: ( model, onchange_construction, @f ) ->
        super model, onchange_construction
    onchange: ->
        @f()
