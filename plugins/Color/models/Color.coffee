#
class Color extends Model
    constructor: ( r = 0, g = 0, b = 0, a = 255 ) ->
        super()
        
        @add_attr
            r: new ConstrainedVal( r, { min: 0, max: 255, div: 255 } )
            g: new ConstrainedVal( g, { min: 0, max: 255, div: 255 } )
            b: new ConstrainedVal( b, { min: 0, max: 255, div: 255 } )
            a: new ConstrainedVal( a, { min: 0, max: 255, div: 255 } )
            
    to_hex: ->
        return "#" + Color._ts( @r ) + Color._ts( @g ) + Color._ts( @b )
        
    to_rgba: ->
        return "rgba(#{@r.get()}, #{@g.get()}, #{@b.get()}, #{@a.get()})"

    to_hsv: ->
        Color.rgb_to_hsv @r.get(), @g.get(), @b.get()

    # rbg between 0 and 255. hsv between 0 and 1
    @rgb_to_hsv: ( r, g, b ) ->
        r /= 255.0
        g /= 255.0
        b /= 255.0
    
        # v
        min = Math.min r, g, b
        max = Math.max r, g, b
        del = max - min
        
        # s
        if max
            s = del / max
        else
            return [ 0, 0, 0 ]

        # h
        del += not del
        if r == max
            h = ( g - b ) / del
        else if g == max
            h = 2 + ( b - r ) / del
        else
            h = 4 + ( r - g ) / del
        
        h *= 60.0 / 360.0
        if h < 0
            h += 1
            
        [ h, s, max ]

    # stolen from http://alvyray.com/Papers/CG/hsv2rgb.htm
    @hsv_to_rgb: ( h, s, v ) ->
        h *= 6
        i = Math.floor h
        f = h - i
        if not ( i & 1 )
            f = 1 - f
        m = Math.round 255 * v * ( 1 - s )
        n = Math.round 255 * v * ( 1 - s * f )
        v = Math.round 255 * v
        switch i
            when 1 then [ n, v, m ]
            when 2 then [ m, v, n ]
            when 3 then [ m, n, v ]
            when 4 then [ n, m, v ]
            when 5 then [ v, m, n ]
            else        [ v, n, m ]
            
    #
    @_ts: ( v ) ->
        r = v.get().toString( 16 )
        if r.length == 1
            r = "0" + r
        return r