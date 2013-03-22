# dep $Soja/models/all.coffee

class MonSousModel extends Model
    @attr =
        a: 11
        b: 12


class MonModel extends Model
    @attr =
        tata: 100
        # toto: mew MonSousModel
        p   : mew Ptr( Int )
        d   : mew Ptr( MonSousModel )
    
    init: ( val ) ->
        @tata.set val

# test_0 = ->
s = mew MonSousModel
m = mew MonModel, 15
# m.toto.set { a: 157 }
m.p.ref s.a
console.log m.val
console.log m.p.obj.val
# console.log Boolean m.tata
# console.log String m.tata


