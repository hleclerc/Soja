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
# lib Theme.js
# lib FileSystem.js
# lib FileSystem.css
test_Browser = ->
    fs = new FileSystem
    FileSystem._disp = false

    fs.load "/test_browser", ( m, err ) ->
        if err
            fs.load "/", ( d, err ) ->
                m = new Directory
                d.add_file "test_browser", m
                t = new Directory
                m.add_file "Result", t
                t.add_file "Steel", ( new Directory )
                t.add_file "Steel", ( new Lst [ 1, 2 ] )
                m.add_file "Mesh", ( new Lst [ 1, 2 ] )
                m.add_file "Work", ( new Lst [ 1, 2 ] )
                
                new_model_editor el: document.body, model: m
                
        #                     
        else
            new_model_editor el: document.body, model: m
