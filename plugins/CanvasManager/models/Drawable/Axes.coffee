# #
class Axes extends Drawable
    constructor: ->
        super()
        
        @add_attr
            p: new Choice( 0, [ "lb", "lt", "rb", "rt", "mm" ] ) # position in the screen. lb = left bottom...
            r: new ConstrainedVal( 0.05, { min: 0, max: 1 } ) # size of the box, expressed as ratio of the screen size 
            d: 1 # "real" diameter of axes. Used only if @p == "mm" (middle middle)
            l: new ConstrainedVal( 2, { min: 0, max: 10, div: 10 } ) # line width
            
    z_index: ->
        return 10000
        
    draw: ( info ) ->
        [ o, x, y, z ] = @_coords info

        info.ctx.lineWidth   = 1
        @_draw info, o, x, "#FF0000"
        @_draw info, o, y, "#00FF00"
        @_draw info, o, z, "#0000FF"

    _draw: ( info, o, p, c ) ->
        info.ctx.strokeStyle = c

        info.ctx.beginPath()
        info.ctx.moveTo o[ 0 ], o[ 1 ]
        info.ctx.lineTo p[ 0 ], p[ 1 ]
        info.ctx.closePath()
        info.ctx.stroke()

    _coords: ( info ) ->
        d = @d.get()
        if d < 0 or not @p.equals( "mm" )
            d = info.cam.d.get() / 10
        
        l = @r.get() * ( if @_fixed() then d else info.cam.d.get() )
        s = 0.3 * info.mwh * @r.get()
        c = info.cam.O.get()
        
        o = info.re_2_sc.proj Vec_3.add c, [ 0, 0, 0 ]
        x = info.re_2_sc.proj Vec_3.add c, [ l, 0, 0 ]
        y = info.re_2_sc.proj Vec_3.add c, [ 0, l, 0 ]
        z = info.re_2_sc.proj Vec_3.add c, [ 0, 0, l ]
        
        mi_x = Math.min o[ 0 ], x[ 0 ], y[ 0 ], z[ 0 ]
        ma_x = Math.max o[ 0 ], x[ 0 ], y[ 0 ], z[ 0 ]
        mi_y = Math.min o[ 1 ], x[ 1 ], y[ 1 ], z[ 1 ]
        ma_y = Math.max o[ 1 ], x[ 1 ], y[ 1 ], z[ 1 ]

        #
        p = @p.get()
        
        if p[ 0 ] == "l" or p[ 0 ] == "r"
            dec = if p[ 0 ] == "r" then info.w - ma_x - s else s - mi_x
            x[ 0 ] += dec
            y[ 0 ] += dec
            z[ 0 ] += dec
            o[ 0 ] += dec
            
        if p[ 1 ] == "b" or p[ 1 ] == "t"
            dec = if p[ 1 ] == "b" then info.h - ma_y - s else s - mi_y
            x[ 1 ] += dec
            y[ 1 ] += dec
            z[ 1 ] += dec
            o[ 1 ] += dec
        
        return [ o, x, y, z ]

    _fixed: () ->
        @p.equals "mm"
