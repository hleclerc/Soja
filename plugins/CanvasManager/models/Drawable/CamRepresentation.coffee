# This class is use to draw a cam representation
class CamRepresentation extends Drawable
    constructor: ( cam, params = {} ) ->
        super()
        
        @add_attr
            cam: cam

        for key, val of params
            this[ key ]?.set? val
            
    z_index: ->
        100
        
    draw: ( info ) ->
        d = @cam.d.get()
        e = d * Math.tan( @cam.get_a() * 0.017453292519943295 / 2 )
        X = Vec_3.mus e, @cam.get_X()
        Y = Vec_3.mus e, @cam.get_Y()
        Z = Vec_3.mus d, @cam.get_Z()
        
        F = @cam.focal_point()
        P = info.re_2_sc.proj F
        
        #         info.ctx.strokeStyle = "white"
        #         info.ctx.beginPath()
        #         info.ctx.moveTo proj_orig[ 0 ], proj_orig[ 1 ]
        #         info.ctx.lineTo P[ 0 ], P[ 1 ]
        #         info.ctx.stroke()
        #         info.ctx.closePath()

        #p1 = [ focal[ 0 ] - ( focal[ 0 ] - orig[ 0 ] ) * fac_dist, focal[ 1 ] - ( focal[ 1 ] - orig[ 1 ] ) * fac_dist, focal[ 2 ] - ( focal[ 2 ] - orig[ 2 ] ) * fac_dist ]
        #dist = Vec_3.dist focal, orig
        
        
        lt = info.re_2_sc.proj [ F[ 0 ] + Z[ 0 ] + X[ 0 ] + Y[ 0 ], F[ 1 ] + Z[ 1 ] + X[ 1 ] + Y[ 1 ], F[ 2 ] + Z[ 2 ] + X[ 2 ] + Y[ 2 ] ]
        rt = info.re_2_sc.proj [ F[ 0 ] + Z[ 0 ] - X[ 0 ] + Y[ 0 ], F[ 1 ] + Z[ 1 ] - X[ 1 ] + Y[ 1 ], F[ 2 ] + Z[ 2 ] - X[ 2 ] + Y[ 2 ] ]
        rb = info.re_2_sc.proj [ F[ 0 ] + Z[ 0 ] + X[ 0 ] - Y[ 0 ], F[ 1 ] + Z[ 1 ] + X[ 1 ] - Y[ 1 ], F[ 2 ] + Z[ 2 ] + X[ 2 ] - Y[ 2 ] ]
        lb = info.re_2_sc.proj [ F[ 0 ] + Z[ 0 ] - X[ 0 ] - Y[ 0 ], F[ 1 ] + Z[ 1 ] - X[ 1 ] - Y[ 1 ], F[ 2 ] + Z[ 2 ] - X[ 2 ] - Y[ 2 ] ]
        
        info.ctx.lineWidth = 2
        size_elem = 10
        info.ctx.beginPath()
        info.ctx.strokeStyle = "blue"
        info.ctx.moveTo P[ 0 ], P[ 1 ]
        info.ctx.lineTo lt[ 0 ], lt[ 1 ]
        
        info.ctx.moveTo P[ 0 ], P[ 1 ]
        info.ctx.lineTo rt[ 0 ], rt[ 1 ]
        
        info.ctx.moveTo P[ 0 ], P[ 1 ]
        info.ctx.lineTo rb[ 0 ], rb[ 1 ]
        
        info.ctx.moveTo P[ 0 ], P[ 1 ]
        info.ctx.lineTo lb[ 0 ], lb[ 1 ]
        info.ctx.stroke()
        
        # info.ctx.strokeRect lt[ 0 ], lt[ 1 ], dim, dim
        info.ctx.closePath()
        
        
        info.ctx.beginPath()
        info.ctx.fillStyle = "red"
        info.ctx.arc P[ 0 ], P[ 1 ], size_elem * 0.5, 0, Math.PI * 2, true
        info.ctx.fill()
        info.ctx.closePath()