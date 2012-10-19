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



class SessionItem extends TreeItem
    constructor: ( name, app_data ) ->
        super()

        @add_attr
            _selected_tree_items: new Lst # path list
            _visible_tree_items : new Model # panel_id: [ model_1, ... ]
            _closed_tree_items  : new Lst
            # canvas
            _selected_canvas_pan: new Lst # panel_id of selected panels
            _last_canvas_pan    : new Str #
            _modules            : new Lst
            time                : app_data?.time or new ConstrainedVal( 0, { min: 0, max: 20, div: 0 } )
        
        
        @_name._set name
        @_ico._set "img/document-open.png"

        #         bind this, =>
        #             max = 0
        #             for ch in this._children
        #                 m = ch.anim_min_max()
        #                 if m > max
        #                     max = m
        #                     
        #             if app_data?
        #                 app_data.time._max.set max - 1
        #                 app_data.time._div.set max - 1
            
    accept_child: ( ch ) ->
        true
        