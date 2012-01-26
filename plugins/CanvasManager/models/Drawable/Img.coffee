#
class Img extends Drawable
    constructor: ( src, app = undefined, need_fit = true ) ->
        super()
        
        @add_attr
            src: src
        
        @data = 
            zmin: 0
            zmax: 0
            buff: undefined # buffer image, to manage onload asynchronous stuff
            rgba: undefined # image that will be actually drawed
            begl: true
            X   : [ 1, 0, 0 ]
            Y   : [ 0, 1, 0 ]

        onload = =>
            @_signal_change()
            @data.rgba = @data.buff
            @data.buff = new Image
            @data.buff.onload = onload
            
            if need_fit and app?
                need_fit = false
                app.fit()
            
        @data.buff = new Image
        @data.buff.onload = onload
        @data.buff.src = @src
        
    z_index: ->
        return 1
        
    draw: ( info ) ->
        if @src.has_been_modified() or @data.begl
            @data.begl = false
            @data.buff.src = @src.get()
        
        if not @data.rgba?
            return false
            
        # flat image
        if @data.zmin == @data.zmax
            # same z, aligned img
            if false and info.cam.X.equals( @data.X ) and info.cam.Y.equals( @data.Y )
                w = @data.rgba.width
                h = @data.rgba.height
                a = info.re_2_sc.proj [ 0, 0, @data.zmin ]
                b = info.re_2_sc.proj [ w, h, @data.zmin ]
                info.ctx.drawImage @data.rgba, a[ 0 ], a[ 1 ], b[ 0 ] - a[ 0 ], b[ 1 ] - a[ 1 ]
            else
                @_draw_persp_rec info


    _draw_persp_rec: ( info, xmin = 0, ymin = 0, xmax = 1, ymax = 1, rec = 0 ) ->
        w = @data.rgba.width
        h = @data.rgba.height
        
        a = info.re_2_sc.proj [ w * xmin, h * ymin, @data.zmin ]
        b = info.re_2_sc.proj [ w * xmax, h * ymax, @data.zmin ]
        c = info.re_2_sc.proj [ w * xmax, h * ymin, @data.zmin ]
        d = info.re_2_sc.proj [ w * xmin, h * ymax, @data.zmin ]
        
        if a[ 0 ] >= info.w and b[ 0 ] >= info.w and c[ 0 ] >= info.w and d[ 0 ] >= info.w
            return true
        if a[ 0 ] < 0 and b[ 0 ] < 0 and c[ 0 ] < 0 and d[ 0 ] < 0
            return true
        if a[ 1 ] >= info.h and b[ 1 ] >= info.h and c[ 1 ] >= info.h and d[ 1 ] >= info.h
            return true
        if a[ 1 ] < 0 and b[ 1 ] < 0 and c[ 1 ] < 0 and d[ 1 ] < 0
            return true
        
        r = [ c[ 0 ] + d[ 0 ] - a[ 0 ], c[ 1 ] + d[ 1 ] - a[ 1 ] ] # approximation in screen
        if rec < 6 and Math.pow( r[ 0 ] - b[ 0 ], 2 ) + Math.pow( r[ 1 ] - b[ 1 ], 2 ) > 1
            ca = 0.5 + 1e-2
            cb = 1 - ca
            xm_0 = cb * xmin + ca * xmax
            ym_0 = cb * ymin + ca * ymax
            xm_1 = ca * xmin + cb * xmax
            ym_1 = ca * ymin + cb * ymax
            @_draw_persp_rec info, xmin, ymin, xm_0, ym_0, rec + 1
            @_draw_persp_rec info, xm_1, ymin, xmax, ym_0, rec + 1
            @_draw_persp_rec info, xmin, ym_1, xm_0, ymax, rec + 1
            @_draw_persp_rec info, xm_1, ym_1, xmax, ymax, rec + 1
            return true
            
        # if xmin == 0 and ymin == 0
        # console.log rec, Math.sqrt( Math.pow( r[ 0 ] - b[ 0 ], 2 ) + Math.pow( r[ 1 ] - b[ 1 ], 2 ) )
        sx = Math.ceil w * xmin
        sy = Math.ceil h * ( 1 - ymax )
        dx = Math.ceil w * ( xmax - xmin )
        dy = Math.ceil h * ( ymax - ymin )
        dx = Math.min dx, w - sx
        dy = Math.min dy, h - sy

        x = [ ( c[ 0 ] - a[ 0 ] ) / dx, ( c[ 1 ] - a[ 1 ] ) / dx ]
        y = [ ( d[ 0 ] - a[ 0 ] ) / dy, ( d[ 1 ] - a[ 1 ] ) / dy ]

        info.ctx.save()
        info.ctx.setTransform x[ 0 ], x[ 1 ], y[ 0 ], y[ 1 ], d[ 0 ], d[ 1 ]
        info.ctx.transform 1, 0, 0, -1, 0, 0
        info.ctx.drawImage @data.rgba, sx, sy, dx, dy, 0, 0, dx, dy
        info.ctx.restore()
        
    update_min_max: ( x_min, x_max ) ->
        if @data.rgba?
            for d in [ 0 ... 3 ]
                x_min[ d ] = Math.min x_min[ d ], 0
            x_max[ 0 ] = Math.max x_max[ 0 ], @data.rgba.width
            x_max[ 1 ] = Math.max x_max[ 1 ], @data.rgba.height
            x_max[ 2 ] = Math.max x_max[ 2 ], 0
    