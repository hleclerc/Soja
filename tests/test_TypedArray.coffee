# lib Soja.js
# lib DomHelper.js
# lib ModelEditor.js
# lib ModelEditor.css
test_TypedArray = ->
    a = new TypedArray_Float64 [ 10, 5 ]
    
    a.set_val [ 1, 0 ], 2
    a.set_val [ 0, 1 ], 5
    
    console.log a.toString()
    console.log a.get()
    console.log a.get 0
    console.log a.get 1
    console.log a.get [ 1, 0 ]
    # new_model_editor el: document.body, model: a
    