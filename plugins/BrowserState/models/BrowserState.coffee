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
                host       : "" # # the host name and port number.	[www.google.com]:80
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

            