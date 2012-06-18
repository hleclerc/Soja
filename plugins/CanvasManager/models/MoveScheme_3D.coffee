# 
class MoveScheme_3D extends Model
    constructor: ->
        super()
        
        @add_attr
            _old_pos : new Vec_3
            _old_dir : new Vec_3
            _new_pos : new Vec_3
            _new_dir : new Vec_3
  
        @cos_for_move_old_new_dir = 0.7
  
    beg_click: ( pos )->
        d_0 = @_old_dir.get()
        d_1 = @_new_dir.get()
        if d_1[ 0 ] or d_1[ 1 ] or d_1[ 2 ] or Math.abs( Vec_3.dot d_0, d_1 ) < @cos_for_move_old_new_dir
            @_old_pos.set @_new_pos
            @_old_dir.set @_new_dir
            
    move: ( selected_entities, pos, p_0, d_0 ) ->
        # by default, projection of the point to line p_0, d_0
        l_0 = Vec_3.dot( Vec_3.sub( pos.get(), p_0 ), d_0 )
        
        # if old dir and pos from previous move, use point from ( p_0, d_0 ), closest to line ( p_1, d_1 )
        p_1 = @_old_pos.get()
        d_1 = @_old_dir.get()
        dok = d_1[ 0 ] or d_1[ 1 ] or d_1[ 2 ]
        if dok and Math.abs( Vec_3.dot d_0, d_1 ) < @cos_for_move_old_new_dir
            c_00 = d_0[ 0 ] * d_0[ 0 ] + d_0[ 1 ] * d_0[ 1 ] + d_0[ 2 ] * d_0[ 2 ]
            c_01 = d_0[ 0 ] * d_1[ 0 ] + d_0[ 1 ] * d_1[ 1 ] + d_0[ 2 ] * d_1[ 2 ]
            c_11 = d_1[ 0 ] * d_1[ 0 ] + d_1[ 1 ] * d_1[ 1 ] + d_1[ 2 ] * d_1[ 2 ]
            dete = c_00 * c_11 - c_01 * c_01
            
            ve_0 = d_0[ 0 ] * ( p_0[ 0 ] - p_1[ 0 ] ) + d_0[ 1 ] * ( p_0[ 1 ] - p_1[ 1 ] ) + d_0[ 2 ] * ( p_0[ 2 ] - p_1[ 2 ] )
            ve_1 = d_1[ 0 ] * ( p_0[ 0 ] - p_1[ 0 ] ) + d_1[ 1 ] * ( p_0[ 1 ] - p_1[ 1 ] ) + d_1[ 2 ] * ( p_0[ 2 ] - p_1[ 2 ] )
            
            l_0 = ( c_01 * ve_1 - c_11 * ve_0 ) / dete
            
        del = for d in [ 0 .. 2 ]
            p_0[ d ] + d_0[ d ] * l_0 - pos[ d ].get() 
            
        for m in selected_entities when m instanceof Point
            for d in [ 0 .. 2 ]
                m.pos[ d ].set m.pos[ d ].get() + del[ d ]
            
        @_new_pos.set p_0
        @_new_dir.set d_0
