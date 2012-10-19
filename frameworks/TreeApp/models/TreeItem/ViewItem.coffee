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
class ViewItem extends TreeItem
    constructor: ( @app_data, panel_id, cam = new( Cam ) ) ->
        super()
        
        # attributes
        @add_attr
            background: new Background
            cam       : cam
            axes      : new Axes
            _panel_id : panel_id
            _repr     : ""
            
        @_buff = new Image
        @_buff.onload = =>
            @_signal_change()
            
        @bind =>
            if @_repr? and @_repr.has_been_modified()
                @_buff.src = @_repr.get()
        
        # default values
        @_name.set "View"
        @_ico.set "img/view-presentation.png"
        
        
    accept_child: ( ch ) ->
        #

    z_index: ->
        1
        
    draw: ( info ) ->
        info.ctx.drawImage @_buff, 0, 0
        
    sub_canvas_items: ->
        [ @background, @axes ]

    #     has_nothing_to_draw: ->
    #         true
