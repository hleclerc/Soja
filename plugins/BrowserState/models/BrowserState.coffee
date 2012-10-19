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



# Model to follow the browser state
class BrowserState extends Model
    @inst: []
    @init: false

    constructor: ->
        super()

        @add_attr
            window_size: [ 0, 0 ]
            location:
                hash       : "" # after the #
                host       : "" # the host name and port number.	[www.google.com]:80
                hostname   : "" # the host name (without the port number or square brackets).	www.google.com
                href       : "" # the entire URL.	http://[www.google.com]:80/search?q=devmo#test
                pathname   : "" # the path (relative to the host).	/search
                port       : "" # the port number of the URL.	80
                protocol   : "" # the protocol of the URL.	http:
                search     : "" # the part of the URL that follows the ? symbol, including the ? symbol.   ?q=devmo

        # event management
        BrowserState.inst.push this

        if not BrowserState.init
            BrowserState.init   = true
            window.onresize     = BrowserState.onresize
            window.onhashchange = BrowserState.onhashchange

        window.onresize()
        window.onhashchange()

    @onresize: ->
       for inst in BrowserState.inst
            inst.window_size.set [ window.innerWidth, window.innerHeight ]

    @onhashchange: ->
        for inst in BrowserState.inst
            inst.location.hash    .set location.hash      
            inst.location.host    .set location.host      
            inst.location.hostname.set location.hostname  
            inst.location.href    .set location.href      
            inst.location.pathname.set location.pathname  
            inst.location.port    .set location.port      
            inst.location.protocol.set location.protocol  
            inst.location.search  .set location.search  

            