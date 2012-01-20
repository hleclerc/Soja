# value choosen from a list
# get() will give the value
# num is the number of the choosen value in the list
# lst contains the posible choices
class Button extends Model 
    constructor: ( label_off = "Submit", label_on = label_off, state = false, disabled = false ) ->
        super()
        
        # default
        @add_attr
            disabled: disabled
            state   : state
            label   : [ label_off, label_on ] # 

 
    get: ->
        @state.get()

    txt: ->
        @label[ @state.get() * 1 ]
        
    equals: ( a ) ->
        @state.equals a
    
    _set: ( state ) ->
        if @change_allowed state
            @state.set state

    toggle: ->
        @set not @get()
        
    change_allowed: ( state ) ->
        return 1
                