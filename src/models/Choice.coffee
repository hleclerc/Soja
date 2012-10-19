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
            
    item: ->
        @_nlst()[ @num.get() ]
            
    get: ->
        @item()?.get()
            
    toString: ->
        @item()?.toString()

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
        