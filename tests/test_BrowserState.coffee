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
# lib BrowserState.js

# simple view of a browser state which displays main values
test_BrowserState = ->
    b = new BrowserState

    bind b, ->
        document.body.innerHTML = "
            <H1>
                window_size = #{ b.window_size.toString()  } <br/>
                hash        = #{ b.location.hash    .get() } <br/>
                host        = #{ b.location.host    .get() } <br/>
                hostname    = #{ b.location.hostname.get() } <br/>
                href        = #{ b.location.href    .get() } <br/>
                pathname    = #{ b.location.pathname.get() } <br/>
                port        = #{ b.location.port    .get() } <br/>
                protocol    = #{ b.location.protocol.get() } <br/>
                search      = #{ b.location.search  .get() } <br/>
                
                <a href='#foo'>Jump to #foo</a> <br/>
                <a href='#bar'>Jump to #bar</a> <br/>
                <a href='?rezoi'>Add a ?rezoi</a> <br/>
            </H1>
        "
