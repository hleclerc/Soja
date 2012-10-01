# 
class MoveScheme_2D extends Model
    constructor: ->
        super()
        
        @add_attr
            _O : new Vec_3 [ 0, 0, 0 ]
            _N : new Vec_3 [ 0, 0, 1 ]
    
            
    beg_click: ( pos ) ->
        # nothing to do
        
    move: ( selected_entities, pos, P, D ) ->
        top = Vec_3.dot Vec_3.sub( @_O, P ), @_N
        bot = Vec_3.dot D, @_N
        I = Vec_3.add P, Vec_3.mus( top / bot, D )
        dec = Vec_3.sub I, pos
        for m in selected_entities when m instanceof Point
            m.pos.set Vec_3.add m.pos.get(), dec
            