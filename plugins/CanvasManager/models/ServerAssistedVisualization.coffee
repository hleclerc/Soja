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



class ServerAssistedVisualization extends Model
    constructor: ( app, bs ) ->
        super()
        
        @add_attr
            data  : app.data
            layout: {}
        
        ds = app.data.selected_display_settings()
        bind [ bs, ds._layout ], =>
            used_lid = {}
            for mid, lm of app.layouts
                for lid, lay of lm._pan_vs_id when lay.cm?
                    if not @layout[ lid ]?
                        @layout.add_attr lid,
                            width : 0
                            height: 0
                    @layout[ lid ].width .set lay.cm.canvas.width
                    @layout[ lid ].height.set lay.cm.canvas.height
                    used_lid[ lid ] = true
                    
            for d in ( lid for lid in @layout._attribute_names when not used_lid[ lid ]? )
                @layout.rem_attr d
                    
    