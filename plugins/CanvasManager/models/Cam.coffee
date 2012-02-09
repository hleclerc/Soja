# camera
class Cam extends Model 
    constructor: ( want_aspect_ratio = false ) ->
        super()

        # default values
        @add_attr
            threeD: true # if false, only 2D movements are allowed
            O: [ 0, 0, 0 ]
            X: [ 1, 0, 0 ]
            Y: [ 0, 1, 0 ]
            C: [ 0, 0, 0 ] # rotation center
            d: 1  # viewable diameter
            a: new ConstrainedVal( 20,
                min: 0
                max: 80
            ) # perspective angle
        if want_aspect_ratio
            @add_attr
               r: 1
               
    # translate screen
    pan: ( x, y, w, h ) ->
        c = @d.get() / Math.min( w, h )
        x *= c
        y *= c
        for d in [ 0 .. 2 ]
            @O[ d ].set @O[ d ].get() - x * @X[ d ].get() - y * @Y[ d ].get()

    #
    zoom: ( x, y, c, w, h ) ->
        # get position of the click in the real world
        mwh = Math.min w, h
        x = ( x - w / 2 ) * @d.get() / mwh
        y = ( h / 2 - y ) * @d.get() / mwh
        O = @O.get()
        X = @X.get()
        Y = @Y.get()
        P = [ O[ 0 ] + x * X[ 0 ] + y * Y[ 0 ], O[ 1 ] + x * X[ 1 ] + y * Y[ 1 ], O[ 2 ] + x * X[ 2 ] + y * Y[ 2 ] ]

        # update cam_data
        @d.set @d.get() / c
        for d in [ 0 ... 3 ]
            @O[ d ].set P[ d ] + ( O[ d ] - P[ d ] ) / c

    # 
    rotate: ( x, y, z ) ->
        if @threeD.get()
            R = @s_to_w_vec [ x, y, z ]
            @X.set Vec_3.rot @X.get(), R
            @Y.set Vec_3.rot @Y.get(), R
            @O.set Vec_3.add( @C.get(), Vec_3.rot( Vec_3.sub( @O.get(), @C.get() ), R ) )
            
    re_2_sc: ( w, h ) -> # real to screen coordinates
        new TransBuf @get(), w, h
    
    sc_2_rw: ( w, h ) -> # screen to real coordinates
        new TransEye @get(), w, h

    equal: ( l ) ->
        ap_3 = ( a, b, e = 1e-3 ) -> 
            Math.abs( a[ 0 ] - b[ 0 ] ) < e and Math.abs( a[ 1 ] - b[ 1 ] ) < e and Math.abs( a[ 2 ] - b[ 2 ] ) < e
            
        if @r? and l.r? and l.r.get() != @r.get()
            return false
        return l.w == @w and l.h == @h and ap_3( l.O, @O ) and ap_3( l.X, @X ) and ap_3( l.Y, @Y ) and Math.abs( l.a - @a ) < 1e-3 and Math.abs( l.d - @d ) / @d < 1e-3

    s_to_w_vec: ( V ) -> # screen orientation to real world.
        
        X = Vec_3.nor @X.get()
        Y = Vec_3.nor @Y.get()
        Z = Vec_3.nor Vec_3.cro X, Y
        return [
            V[ 0 ] * @X[ 0 ] + V[ 1 ] * @Y[ 0 ] + V[ 2 ] * Z[ 0 ],
            V[ 0 ] * @X[ 1 ] + V[ 1 ] * @Y[ 1 ] + V[ 2 ] * Z[ 1 ],
            V[ 0 ] * @X[ 2 ] + V[ 1 ] * @Y[ 2 ] + V[ 2 ] * Z[ 2 ]
        ]

    get_Z: () ->
        Vec_3.nor Vec_3.cro @X.get(), @Y.get()
        
    # return coordinates depending the current cam state from real coordinates
    get_screen_coord : ( coord ) ->
        O = @O.get()
        X = @X.get()
        Y = @Y.get()
        d = @d
        Cx = Vec_3.mus ( d * coord[0] ), X
        Cy = Vec_3.mus ( d * coord[1] ), Y
        return Vec_3.add O, Vec_3.add(Cx, Cy)
    
    class TransEye # screen -> eye dir and pos
        constructor: ( d, w, h ) ->
            r = d.r or 1
            mwh = Math.min w, h
            c = d.d / mwh
            @X = Vec_3.sm Vec_3.nor( d.X ), c * r
            @Y = Vec_3.sm Vec_3.nor( d.Y ), - c
            @Z = Vec_3.sm Vec_3.nor( Vec_3.cro( d.X, d.Y ) ), c
            @p = Math.tan( d.a / 2 * 3.14159265358979323846 / 180 ) / ( mwh / 2 )
            # center
            @O = d.O
            @o_x = - w / 2
            @o_y = - h / 2
            
        dir: ( x, y ) ->
            Vec_3.nor [
                ( ( x + @o_x ) * @X[ 0 ] + ( y + @o_y ) * @Y[ 0 ] ) * @p + @Z[ 0 ],
                ( ( x + @o_x ) * @X[ 1 ] + ( y + @o_y ) * @Y[ 1 ] ) * @p + @Z[ 1 ],
                ( ( x + @o_x ) * @X[ 2 ] + ( y + @o_y ) * @Y[ 2 ] ) * @p + @Z[ 2 ]
            ]
            
        pos: ( x, y ) -> [
            @O[ 0 ] + ( x + @o_x ) * @X[ 0 ] + ( y + @o_y ) * @Y[ 0 ],
            @O[ 1 ] + ( x + @o_x ) * @X[ 1 ] + ( y + @o_y ) * @Y[ 1 ],
            @O[ 2 ] + ( x + @o_x ) * @X[ 2 ] + ( y + @o_y ) * @Y[ 2 ]
        ]

    class TransBuf # real pos -> screen
        constructor: ( d, w, h ) ->
            r = d.r or 1
            mwh = Math.min w, h
            c = mwh / d.d
            @X = Vec_3.sm Vec_3.nor( d.X ), c / r
            @Y = Vec_3.sm Vec_3.nor( d.Y ), - c
            @Z = Vec_3.sm Vec_3.nor( Vec_3.cro( d.X, d.Y ) ), c
            @p = Math.tan( d.a / 2 * 3.14159265358979323846 / 180 ) / ( mwh / 2 )
            # center
            @O = d.O
            @o_x = w / 2
            @o_y = h / 2
            
        proj: ( P ) ->
            d = Vec_3.sub P, @O
            x = Vec_3.dot d, @X
            y = Vec_3.dot d, @Y
            z = Vec_3.dot d, @Z
            d = 1 / ( 1 + @p * z )
            return [ @o_x + d * x, @o_y + d * y, z ]
