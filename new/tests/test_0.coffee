# dep $Soja/models/all.coffee

class MySubModel extends Model
    @attr =
        a: 11
        b: 12


class MyModel extends Model
    @attr =
        tata: Vec( Int, 5 )
        # toto: mew MySubModel
        # p   : mew Ptr( Int )
        # d   : mew Ptr( MySubModel )
    
    init: ( val ) ->
        @tata.set val

# test_0 = ->
# m = mew MyModel, 15
# m.tata[ 1 ].val = 10
# console.log m.val
# console.log m.tata[ 1 ].val
m = mew Vec( Int )
m.length = 2
console.log m.length
m.at( 1 ).set 20
console.log m.val
console.log m.get 0
console.log m.get 1

# s = mmew MySubModel, 2
# # m.toto.set { a: 157 }
# m.p.ref s.b
# console.log m.val
# console.log m.p.obj.val
# m.p.num_attr.val = 4
# console.log m.p.obj.val
# m.p.num_attr.val = 5
# console.log m.p.obj.val
# console.log Boolean m.tata
# console.log String m.tata


