# value choosen from a list
# get() will give the value
# num is the number of the choosen value in the list
# lst contains the posible choices
class Choice extends Model 
    constructor: ( data, initial_list = [] ) ->
        super()
        
        # default
        @add_attr
            num: 0
            lst: initial_list
        
        # init
        if data?
            @num.set data

    filter: ( obj ) ->
        true
            
    get: ->
        @_nlst()[ @num.get() ]?.get()
            
    toString: ->
        @_nlst()[ @num.get() ]?.toString()

    equals: ( a ) ->
        if a instanceof Choice
            super a
        else
            @_nlst()[ @num.get() ].equals a
    
    _set: ( value ) ->
        for i, j in @_nlst()
            if i.equals value
                return @num.set j
        @num.set value

    _nlst: ->
        l for l in @lst when @filter l
        