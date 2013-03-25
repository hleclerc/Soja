# dep $ModelEditor/views/ModelEditor.coffee
# dep $Soja/models/all.coffee

class MySubModel extends Model
    @attr =
        a: 11
        b: 12
        c: Bool


class MyModel extends Model
    @attr =
        # tata: Vec( Int, 5 )
        # toto: mew MySubModel
        p   : mew Ptr( Int )
        # d   : mew Ptr( MySubModel )
    
    #     init: ( val ) ->
    #         @tata.set val

# test_0 = ->
# i = mew Int, 4
# m = mew MyModel
# m.p.set i.ptr
# console.log i.val
# console.log m.val

# console.log m.tata[ 1 ].val
# m = mew Vec( Int )
# m.val = [ 1, 2, 3 ]
# console.log m.val
# m.resize 5, 17
# console.log m.val

# s = mmew MySubModel, 2
# # m.toto.set { a: 157 }
# m.p.set s.b.ptr
# console.log m.val
# console.log m.p.obj.val
# m.p.num_attr.val = 4
# console.log m.p.obj.val
# m.p.num_attr.val = 5
# console.log m.p.obj.val
# console.log Boolean m.tata
# console.log String m.tata
# test_0 = ->
#     m = mew Str # MySubModel
#     v = new ModelEditor el: document.body, model: m
#     w = new ModelEditor el: document.body, model: m
m = mew Vec( Bool )
m.length = 3
m.at( 1 ).val = true
console.log m.val
m.at( 1 ).val = false
console.log m.val
# console.log m.constructor.__type_info
