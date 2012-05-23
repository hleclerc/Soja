# value choosen from a list
# get() will give the value
# num is the number of the choosen value in the list
# lst contains the posible choices
class Choice extends Model 
    constructor: ( data, initial_list = [], @filter = ( ( obj ) -> true ) ) ->
        super()
        
        # default
        @add_attr
            num: 0
            lst: initial_list
        
        # init
        if data?
            @num.set data

    get: ->
        @_nlst()[ @num.get() ].get()

    equals: ( a ) ->
        @_nlst()[ @num.get() ].equals a
    
    _set: ( value ) ->
        for i, j in @_nlst()
            if value == i
                return @num.set j
        @num.set value

    _nlst: ->
        l for l in @lst when @filter l
        