# value choosen from a list
# get() will give the value
# num is the number of the choosen value in the list
# lst contains the posible choices
class Choice extends Model 
    constructor: ( data, initial_list ) ->
        super()
        
        # default
        @add_attr
            num: 0
            lst: []
        
        # init
        if data?
            @num.set data
            
        if initial_list?
            for i in initial_list
                @lst.push i

    get: ->
        @lst[ @num.get() ].get()

    equals: ( a ) ->
        @lst[ @num.get() ].equals a
    
    _set: ( value ) ->
        @num.set value
