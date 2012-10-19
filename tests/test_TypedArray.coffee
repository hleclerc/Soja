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
# lib TypedArray.js
test_TypedArray = ->
    a = new TypedArray_Float64 [ 3, 2 ]
    
    a.set_val [ 1, 0 ], 2
    a.set_val [ 0, 1 ], 1
    
    #     console.log a.toString()
    #     console.log a.get()
    #     console.log a.get [ 1, 0 ]
    #     
    #     console.log a.get_state()
    #     
    #     a._set_state "2,2,3,0,1,2,3,4,5", {}
    #     console.log a.get_state()
    #     console.log a.toString()
    
    new_model_editor el: document.body, model: a
    new_model_editor el: document.body, model: a
    
    