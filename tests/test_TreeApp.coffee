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
# lib BrowserState.js
# lib LayoutManager.js
# lib ModelEditor.js
# lib ModelEditor.css
# lib Color.js
# lib Color.css
# lib Geometry.js
# lib UndoManager.js
# lib CanvasManager.js
# lib TreeApp.js
# lib TreeApp.css

test_TreeApp = ->
    m = new TreeAppData
    m.modules.push new TreeAppModule_PanelManager
    m.modules.push new TreeAppModule_UndoManager 
    m.modules.push new TreeAppModule_Sketch
    
    v = new TreeApp document.body, m

    
    m.new_session "Session 1"
