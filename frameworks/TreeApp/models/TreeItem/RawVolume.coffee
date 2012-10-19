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
class RawVolume extends TreeItem
    constructor: ->
        super()
        
        @add_attr
            scalar_type: new Choice( 0, [ "PI8", "SI8", "PI16", "SI16", "PI32", "SI32" ] )
            endianness : new Choice( 0, [ "LittleEndian", "BigEndian" ] )
            img_size   : [ 0, 0, 0 ]
            min_val    : new ConstrainedVal(   0, { min: 0, max: 255, div: 255 } )
            max_val    : new ConstrainedVal( 255, { min: 0, max: 255, div: 255 } )
            
        @_name.set "Raw volume"
        @_ico.set "img/krita_16.png"
        @_viewable.set true

    update_min_max: ( x_min, x_max ) ->
        for d in [ 0 ... 3 ]
            x_min[ d ] = Math.min x_min[ d ], 0
            x_max[ d ] = Math.max x_max[ d ], @img_size[ d ].get()
            