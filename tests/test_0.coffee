# lib Soja.js
test_0 = ->
    m = new Model a: 10, b: [ "yop", "yap" ]
    bind m, -> document.body.innerHTML = "<H1>#{m.a.get()} #{m.b[0].get()}</H1>"

    setTimeout ( -> m.a.set 13 ), 1000
 
