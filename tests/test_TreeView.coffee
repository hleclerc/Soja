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
# lib TreeView.js
# lib TreeView.css
test_TreeView = ->
    d = new Lst [
        _name: "root"
        _children: [ {
            _name: "child_0 which accepts child_1 as child"
            _viewable: true
            _ico : "../plugins/ModelEditor/img/cross.png"
            accept_child: ( ch ) ->
                ch._name.equals "child_1"
        }, {
            _name: "child_1"
            _viewable: true
        }, {
            _name: "child_2"
            _viewable: true
        }, {
            _name: "child_3"
            _viewable: true
        } ]
        accept_child: ( ch ) ->
            true
    ]

    v = new TreeView document.body, d
    v.visibility_context.set "a"
    
    new_dom_element
        parentNode: document.body
        nodeName  : "input"
        type      : "button"
        value     : "vc a"
        onclick   : -> v.visibility_context.set "a"
        style:
            marginTop: 100
            
    
    new_dom_element
        parentNode: document.body
        nodeName  : "input"
        type      : "button"
        value     : "vc b"
        onclick   : -> v.visibility_context.set "b"
        
        
        