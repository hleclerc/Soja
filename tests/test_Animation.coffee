# lib Soja.js
# lib DomHelper.js
# lib ModelEditor.js
# lib ModelEditor.css
# lib Animation.js
test_Animation = ->
    add_butt = ( txt, fun ) ->
        new_dom_element
            parentNode: document.body
            nodeName  : "input"
            type      : "button"
            value     : txt
            onclick   : fun

    m = new ConstrainedVal 0, min:0, max:100, div:100
    new_model_editor el: document.body, model: m
    
    for v in [ 0 .. 10 ]
        do ( v ) ->
            add_butt String( 10 * v ), ->
                Animation.set m, 10 * v
    