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
# lib Animation.js
test_Animation = ->
    add_butt = ( txt, fun ) ->
        new_dom_element
            parentNode: document.body
            nodeName  : "input"
            type      : "button"
            value     : txt
            onclick   : fun

    m = new ConstrainedVal 0, min:0, max:100, div:100
    new_model_editor el: document.body, model: m
    
    for v in [ 0 .. 10 ]
        do ( v ) ->
            add_butt String( 10 * v ), ->
                Animation.set m, 10 * v
    