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
                