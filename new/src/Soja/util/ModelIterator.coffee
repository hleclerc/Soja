
# permits to iterate through Model attributes (needs javascript 1.7)
class ModelIterator
    constructor: ( @attr ) ->
        @current = 0
        
    next: ->
        if @current >= @attr.length
            throw StopIteration
        @attr[ @current++ ].name
