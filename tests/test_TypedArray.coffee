# lib Soja.js
# lib DomHelper.js
# lib ModelEditor.js
# lib ModelEditor.css
# lib TypedArray.js
test_TypedArray = ->
    a = new TypedArray_Float64 [ 3, 2 ]
    
    a.set_val [ 1, 0 ], 2
    a.set_val [ 0, 1 ], 1
    
    #     console.log a.toString()
    #     console.log a.get()
    #     console.log a.get [ 1, 0 ]
    #     
    #     console.log a.get_state()
    #     
    #     a._set_state "2,2,3,0,1,2,3,4,5", {}
    #     console.log a.get_state()
    #     console.log a.toString()
    
    new_model_editor el: document.body, model: a
    new_model_editor el: document.body, model: a
    
    