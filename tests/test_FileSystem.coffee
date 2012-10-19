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
# lib ModelEditor.js
# lib ModelEditor.css
# lib DomHelper.js
# lib Color.js
# lib Color.css
# lib Geometry.js
# lib BrowserState.js
# lib CanvasManager.js
# lib Animation.js
# lib Theme.js
# lib FileSystem.js
# lib TypedArray.js
test_FileSystem = ->
    FileSystem._disp = true
    fs = new FileSystem
    
    # load the root dir
    fs.load "/", ( dir, err ) ->
        a = new Model
        b = new Model
        new_model_editor el: document.body, model: a, label: "existing models"
        new_model_editor el: document.body, model: b, label: "new ones"

        # add if necessary
        add_ifn = ( name, fun ) ->
            f = dir.find name
            if f?
                f.load ( obj, err ) ->
                    console.log "err", err
                    if not err
                        a.add_attr name, obj
            else
                obj = Model.conv fun()
                dir.add_file name, obj
                b.add_attr name, obj
                
        console.log dir.get()
        
        add_ifn "val", -> 10
        add_ifn "con", -> new ConstrainedVal 0, { min:0, max:100 }
        add_ifn "str", -> "txt"
        add_ifn "lst", -> [ 1, 2 ]
        add_ifn "col", -> new Color

        add_ifn "bol", -> new Bool
        
        add_ifn "arr", ->
            res = new TypedArray_Float64 [ 2, 3 ]
            res.set_val [ 0, 0 ], 1
            res

#     #
#     cpt = 0
#     new_dom_element
#         parentNode: document.body
#         nodeName: "button"
#         onclick: -> m.titi.push 127
#         txt: "push 127"
#     new_dom_element
#         parentNode: document.body
#         nodeName: "button"
#         onclick: -> m.mod.add_attr "attr_#{cpt += 1}", "toz"
#         txt: "add attr"
