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
class DisplaySettingsItem extends TreeItem
    constructor: ( layout_manager_data = {} ) ->
        super()

        # new attributes
        @add_attr
            theme: new Theme
            
            _layout: new LayoutManagerData layout_manager_data
            
            
        # default values
        @_name._set "Display settings"
        @_ico._set "img/view-multiple-objects.png"

        # watcher to see if some view_items has to be destroyed
        @_layout.bind =>
            l = @_layout.panel_id_of_term_panels()
            for view_item in @_children when view_item instanceof ViewItem
                if view_item._panel_id.get() not in l
                    @rem_child view_item

        @_layout.allow_destruction = ( data ) =>
            @_layout.panel_id_of_term_panels().length >= 4
            
            
    accept_child: ( ch ) ->
        ch instanceof ViewItem
        
    z_index: ->
        # do nothing
        
        

        

        
