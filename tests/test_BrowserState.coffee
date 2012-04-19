# lib Soja.js
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
