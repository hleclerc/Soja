# lib Soja.js
# lib ModelEditor.js
# lib ModelEditor.css
# lib DomHelper.js
# lib Color.js
# lib Color.css
# lib Geometry.js
# lib BrowserState.js
# lib CanvasManager.js
# lib Animation.js
# lib Theme.js
# lib FileSystem.js
# lib TypedArray.js
test_Soca = ->
    fs = new FileSystem
    
    # load the root dir
    fs.load "/pouet", ( dir, err ) ->
        console.log dir.get 0
#         a = new Model
#         b = new Model
#         new_model_editor el: document.body, model: a, label: "existing models"
#         new_model_editor el: document.body, model: b, label: "new ones"
# 
#         # add if necessary
#         add_ifn = ( name, fun ) ->
#             f = dir.find name
#             if f?
#                 f.load ( obj, err ) ->
#                     console.log "err", err
#                     if not err
#                         a.add_attr name, obj
#             else
#                 obj = fun()
#                 dir.add_file name, obj
#                 b.add_attr name, obj
#                 
#         console.log dir.get()
#         
#         add_ifn "pouet", ->
#             res = new TypedArray_Float64 [ 2, 3 ]
#             res.set_val [ 0, 0 ], 1
#             res
