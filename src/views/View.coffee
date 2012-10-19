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



# something which has to be synchronized with one or several model(s)
#
# Each view has an uniquer id called "view_id"
class View
    @_cur_view_id: 0
    
    # m can be a model or a list of models
    constructor: ( m, onchange_construction = true ) ->
        #
        @view_id = View._cur_view_id
        View._cur_view_id += 1
        
        # what this is observing
        @_models = []
        
        # bind
        if m instanceof Model
            m.bind this, onchange_construction
        else if m.length?
            for i in m
                i.bind this, onchange_construction
        else if m?
            console.error "View constructor doesn't know what to do with", m

    #
    destructor: ->
        for m in @_models
            i = m._views.indexOf this
            if i >= 0
                m._views.splice i, 1


    # called if at least one of the corresponding models has changed in the previous round
    onchange: ->


# bind model or list of model to function or view f
# (simply call the bind method of Model)
bind = ( m, f ) =>
    if m instanceof Model
        m.bind f
    else
        for i in m
            i.bind f
    