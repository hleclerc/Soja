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



# lib Soda.js
# lib DomHelper.js
# lib ModelEditor.js
# lib ModelEditor.css
test_1 = ->
    class Color extends Model
        constructor: ->
            super()
            
            @add_attr
                r: new ConstrainedVal( 150, { min: 0, max: 255 } )
                g: new ConstrainedVal( 100, { min: 0, max: 255 } )
                b: new ConstrainedVal( 100, { min: 0, max: 255 } )
                
        lum: -> 
            ( @r.get() + @g.get() + @b.get() ) / 3

    c = new Color
    
    # sliders
    new_model_editor el: new_dom_element( parentNode: document.body, style: {width:300,marginBottom:10} ), model: c
    
    # lum
    l = new_dom_element( parentNode: document.body )
    bind c, -> l.innerHTML = "Luminance = #{c.lum()}"
    