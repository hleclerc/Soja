#
class Animation
    @period_ms = 25 # updates every ... ms
    
    @_curan = {} # current animations model_id -> mod, cur, tot
    @_timer = undefined
    
    # linear curve (return a ratio)
    @linear: ( rat )-> rat
    
    # easing curve (return a ratio)
    @easing: ( rat )-> Math.pow rat, 0.33
    
    @set: ( model, value, delay = 500, curve = Animation.linear ) ->
        dt = (new Date).getTime()
        Animation._curan[ model.model_id ] = 
            mod: model
            old: model.get()
            val: value
            beg: dt
            end: dt + delay
            crv: curve

        if not Animation._timer?
            Animation._timer = setTimeout Animation._timeout_func, Animation.period_ms
            
    @_timeout_func: ->
        dt = (new Date).getTime()
        rm = []
        remaining_anim = false
        for key, obj of Animation._curan
            rat = ( dt - obj.beg ) / ( obj.end - obj.beg )
            if rat >= 1
                obj.mod.set obj.val
                rm.push key
            else
                obj.mod.set obj.old + ( obj.val - obj.old ) * obj.crv( rat )
                remaining_anim = true
                
        for key in rm
            delete Animation._curan[ key ]

        if remaining_anim
            Animation._timer = setTimeout Animation._timeout_func, Animation.period_ms
        else
            Animation._timer = undefined
