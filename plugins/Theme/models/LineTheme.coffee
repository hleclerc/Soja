# 
class LineTheme extends Model
    constructor: ->
        super()
        
        @add_attr
            color: new Color 255, 255, 255, 255
            width: 1
            
    beg_ctx: ( info ) ->
        info.ctx.lineWidth   = @width.get()
        info.ctx.strokeStyle = @color.to_rgba()
        
    end_ctx: ( info ) ->
        
    # draw a straight line between two points expressed in screen coordinates
    draw_straight_proj: ( info, p0, p1 ) ->
        info.ctx.beginPath()
        @contour_straight_proj info, p0, p1
        info.ctx.stroke()
        
    contour_straight_proj: ( info, p0, p1, beg = true ) ->
        if beg
            info.ctx.moveTo p0[ 0 ], p0[ 1 ]
        info.ctx.lineTo p1[ 0 ], p1[ 1 ]
        
    draw_arc: ( info, P0, P1, P2 ) ->
        info.ctx.beginPath()
        @contour_arc info, P0, P1, P2
        info.ctx.stroke()

    contour_arc: ( info, P0, P1, P2, beg = true ) ->
    
        cr = @_get_center_radius P0, P1, P2
        n = Math.ceil( Math.abs( cr.a[ 2 ] - cr.a[ 0 ] ) / 0.1 )
        for ai in [ 1 - beg .. n ]
            a = cr.a[ 0 ] + ( cr.a[ 2 ] - cr.a[ 0 ] ) * ai / n
            rca = cr.R * Math.cos( a )
            rsa = cr.R * Math.sin( a )
            p = info.re_2_sc.proj [
                cr.C[ 0 ] + rca * cr.P01[ 0 ] + rsa * cr.P02[ 0 ],
                cr.C[ 1 ] + rca * cr.P01[ 1 ] + rsa * cr.P02[ 1 ],
                cr.C[ 2 ] + rca * cr.P01[ 2 ] + rsa * cr.P02[ 2 ]
            ]
            
            if ai
                info.ctx.lineTo p[ 0 ], p[ 1 ]
            else
                info.ctx.moveTo p[ 0 ], p[ 1 ]
        
    draw_interpolated_arcs: ( info, points ) ->
        # simplified case
        if points.length == 3
            return @draw_arc info, points[ 0 ], points[ 1 ], points[ 2 ]
    
        info.ctx.beginPath()
        @contour_interpolated_arcs info, points
        info.ctx.stroke()
    
    contour_interpolated_arcs: ( info, points, beg = true ) ->
        # simplified case
        if points.length == 3
            return @contour_arc info, points[ 0 ], points[ 1 ], points[ 2 ]
    
        # else, get center and radius for each intermediate arc
        res = for i in [ 0 ... points.length - 2 ]
            @_get_center_radius points[ i ], points[ i + 1 ], points[ i + 2 ]
                
        p = info.re_2_sc.proj points[ 0 ]
        if beg
            info.ctx.moveTo p[ 0 ], p[ 1 ]

        # beg
        for n in [ 1 .. 30 ]
            alpha = n / 30.0
            ar = res[ 0 ].a[ 0 ] + ( res[ 0 ].a[ 1 ] - res[ 0 ].a[ 0 ] ) * alpha
            pr = @_get_proj_arc info, res[ 0 ], ar
            info.ctx.lineTo pr[ 0 ], pr[ 1 ]
                
        # mid
        for i in [ 0 ... points.length - 3 ]
            for n in [ 0 ... 30 ]
                alpha = n / 30.0
                a0 = res[ i + 0 ].a[ 1 ] + ( res[ i + 0 ].a[ 2 ] - res[ i + 0 ].a[ 1 ] ) * alpha
                a1 = res[ i + 1 ].a[ 0 ] + ( res[ i + 1 ].a[ 1 ] - res[ i + 1 ].a[ 0 ] ) * alpha
                
                p0 = @_get_proj_arc info, res[ i + 0 ], a0
                p1 = @_get_proj_arc info, res[ i + 1 ], a1
                pr = Vec_3.add( Vec_3.mus( 1 - alpha, p0 ), Vec_3.mus( alpha, p1 ) )
                
                info.ctx.lineTo pr[ 0 ], pr[ 1 ]
        
        # end
        nr = res.length - 1
        for n in [ 0 .. 30 ]
            alpha = n / 30.0
            ar = res[ nr ].a[ 1 ] + ( res[ nr ].a[ 2 ] - res[ nr ].a[ 1 ] ) * alpha
            pr = @_get_proj_arc info, res[ nr ], ar
            info.ctx.lineTo pr[ 0 ], pr[ 1 ]
    
        
        
    _get_center_radius: ( P0, P1, P2 ) ->
        P01 = Vec_3.sub P1, P0
        P02 = Vec_3.sub P2, P0
        x1 = Vec_3.len P01
        P01 = Vec_3.mus 1 / x1, P01
        x2 = Vec_3.dot P02, P01
        P02 = Vec_3.sub( P02, Vec_3.mus( x2, P01 ) )
        y2 = Vec_3.len P02
        P02 = Vec_3.mus 1 / y2, P02
        xc = x1 * 0.5
        yc = ( x2 * x2 + y2 * y2 - x2 * x1 ) / ( 2.0 * y2 )
        C = Vec_3.add( Vec_3.add( P0, Vec_3.mus( xc, P01 ) ), Vec_3.mus( yc, P02 ) )
        R = Vec_3.len( Vec_3.sub( P0, C ) )
        
        a0 = Math.atan2 (  0 - yc ), (  0 - xc )
        a1 = Math.atan2 (  0 - yc ), ( x1 - xc )
        a2 = Math.atan2 ( y2 - yc ), ( x2 - xc )
        
        ma = 0.5 * ( a0 + a2 )
        if Math.abs( a1 - ma ) > Math.abs( a0 - ma ) # si a1 n'est pas compris dans l'intervalle
            if a2 < a0
                a2 += 2 * Math.PI
            else
                a0 += 2 * Math.PI
                
        ma = 0.5 * ( a0 + a2 )
        if Math.abs( a1 - ma ) > Math.abs( a0 - ma ) # si a1 n'est toujours pas compris dans l'intervalle
            a1 += 2 * Math.PI
                
        res =
            xc : xc
            yx : yc
            C  : C
            R  : R
            a  : [ a0, a1, a2 ]
            P01: P01
            P02: P02
        return res
        
    _get_proj_arc: ( info, arc_info, a ) ->
        rca = arc_info.R * Math.cos( a )
        rsa = arc_info.R * Math.sin( a )
        info.re_2_sc.proj [
            arc_info.C[ 0 ] + rca * arc_info.P01[ 0 ] + rsa * arc_info.P02[ 0 ],
            arc_info.C[ 1 ] + rca * arc_info.P01[ 1 ] + rsa * arc_info.P02[ 1 ],
            arc_info.C[ 2 ] + rca * arc_info.P01[ 2 ] + rsa * arc_info.P02[ 2 ]
        ]
