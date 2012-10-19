# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2012 Hugo Leclerc
#
# This file is part of Soda.
#
# Soda is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Soda is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with Soda. If not, see <http://www.gnu.org/licenses/>.



#
class Animation
    @period_ms = 2 # updates every ... ms
    
    @_curan = {} # current animations model_id -> mod, cur, tot
    @_timer = undefined
    
    # linear curve (return a ratio)
    @linear: ( rat )-> rat
    
    # easing curve (return a ratio)
    @easing: ( rat )-> Math.pow rat, 0.33
    
    @set: ( model, value, delay = 300, curve = Animation.linear ) ->
        value = Model.conv value
        ms = model.size()
        vs = value.size()
        if ms.length
            if ms.length == 1 and vs.length == 1 and ms[ 0 ] == vs[ 0 ]
                for m, i in model
                    Animation.set m, value[ i ], delay, curve
            else # ->no animation
                model.set value
        else
            dt = (new Date).getTime()
            Animation._curan[ model.model_id ] = 
                mod: model
                old: model.get()
                val: value
                beg: dt
                end: dt + delay
                crv: curve

            if delay <= 0
                Animation._timeout_func()
            else if not Animation._timer?
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
