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
class ImgSetItem extends TreeItem
    constructor: ->
        super()
        
        @_name.set "Image collection"
        @_ico.set "img/krita_16.png"
        @_viewable.set true
        
    accept_child: ( ch ) ->
        ch instanceof ImgItem or
        ch instanceof RawVolume

    draw: ( info ) ->
        # TODO: use min max for that
        if info.time_ref._max? and info.time_ref._max.get() < @_children.length - 1
            info.time_ref._max.set @_children.length - 1
        if info.time_ref?
            info.time_ref._div.set Math.max info.time_ref._max.get(), 1
            
        #
        if @_children[ info.time ]?
            @_children[ info.time ].draw info
        else if @_children[ 0 ]?
            @_children[ 0 ].draw info
    
    z_index: ->
        if @_children.length
            return @_children[ 0 ].z_index()
        return 0
    
    update_min_max: ( x_min, x_max ) =>
        if @_children[ 0 ]?
            @_children[ 0 ].update_min_max x_min, x_max

    anim_min_max: ->
        return @_children.length
        