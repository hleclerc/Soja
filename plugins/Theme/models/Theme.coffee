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
class Theme extends Model
    constructor: ->
        super()
        
        @add_attr
            lines               : new LineTheme( new Color( 255, 255, 255, 255 ), 1 )
            selected_lines      : new LineTheme( new Color( 200, 200, 100, 255 ), 1.5 )
            points              : new PointTheme( new Color( 255, 255, 255, 255 ), 4, new Color( 255, 255, 255, 255 ), 1 )
            editable_points     : new PointTheme( new Color(   0, 255,   0, 255 ), 4, new Color( 255, 255, 255, 255 ), 1 )
            surfaces            : new SurfaceTheme( new Color( 150, 150, 150, 255 ) )
            
            selected_points     : new PointTheme( new Color( 255,   0,   0, 255 ), 4, new Color( 255, 255, 255, 255 ), 1 )
            highlighted_points  : new PointTheme( new Color(   0,   0,   0,   0 ), 5, new Color( 255, 255,   0, 255 ), 1 )
            
            selected_elements   : new LineTheme( new Color( 255,   0,   0, 255 ), 1 )
            highlighted_elements: new LineTheme( new Color( 255, 255,   0, 255 ), 1.5 )
            
            constrain_boundary_displacement       : new LineTheme( new Color( 122,   0,   0, 255 ), 2 )
            constrain_boundary_displacement_hover : new LineTheme( new Color( 122,   0,   0, 255 ), 3 )
            
            constrain_boundary_strain             : new LineTheme( new Color( 200, 100, 100, 255 ), 2 )
            constrain_boundary_strain_hover       : new LineTheme( new Color( 200, 100, 100, 255 ), 3 )
            
            constrain_boundary_pressure           : new LineTheme( new Color(  50,   0,   0, 255 ), 2 )
            constrain_boundary_pressure_hover     : new LineTheme( new Color(  50,   0,   0, 255 ), 3 )
            
            free_boundary                         : new LineTheme( new Color(   0, 122,   0, 255 ), 2 )
            free_boundary_hover                   : new LineTheme( new Color(   0, 122,   0, 255 ), 3 )
            
            
            gradient_legend  : new Gradient
            
            anim_delay        : 300
            zoom_factor       : 5
            
        @gradient_legend.add_color [ 255,255,255, 255 ], 0
        @gradient_legend.add_color [   0,  0,  0, 255 ], 1