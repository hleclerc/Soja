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
        orig = info.re_2_sc.proj [ @cam.O[ 0 ].get(), @cam.O[ 1 ].get(), @cam.O[ 2 ].get() ]
        
        ninfo = 
            re_2_sc  : @cam.re_2_sc info.w, info.h
            sc_2_rw  : @cam.sc_2_rw info.w, info.h
        
        focal = info.re_2_sc.proj ninfo.sc_2_rw.focal_point()
        # console.log 'focal ', focal
        
        
        info.ctx.lineWidth = 2
        size_elem = 10
        
        info.ctx.strokeStyle = "white"
        info.ctx.beginPath()
        info.ctx.moveTo orig[ 0 ], orig[ 1 ]
        info.ctx.lineTo focal[ 0 ], focal[ 1 ]
        info.ctx.stroke()
        info.ctx.closePath()
        
        
        fac_dist = 4 / 10
        p1 = [ focal[ 0 ] - ( focal[ 0 ] - orig[ 0 ] ) * fac_dist, focal[ 1 ] - ( focal[ 1 ] - orig[ 1 ] ) * fac_dist, focal[ 2 ] - ( focal[ 2 ] - orig[ 2 ] ) * fac_dist ]

        dist = Vec_3.dist focal, orig
        
        d = @cam.d.get()
        dim = fac_dist * dist
        
#         console.log "------------"
#         console.log focal
#         console.log orig
#         console.log p1, d
        
        lt = [ p1[ 0 ] - (dim * 0.5 ), p1[ 1 ] - (dim * 0.5 ) ]
        rt = [ p1[ 0 ] + (dim * 0.5 ), p1[ 1 ] - (dim * 0.5 ) ]
        rb = [ p1[ 0 ] + (dim * 0.5 ), p1[ 1 ] + (dim * 0.5 ) ]
        lb = [ p1[ 0 ] - (dim * 0.5 ), p1[ 1 ] + (dim * 0.5 ) ]
        
        info.ctx.beginPath()
        info.ctx.strokeStyle = "blue"
        info.ctx.moveTo focal[ 0 ], focal[ 1 ]
        info.ctx.lineTo lt[ 0 ], lt[ 1 ]
        
        info.ctx.moveTo focal[ 0 ], focal[ 1 ]
        info.ctx.lineTo rt[ 0 ], rt[ 1 ]
        
        info.ctx.moveTo focal[ 0 ], focal[ 1 ]
        info.ctx.lineTo rb[ 0 ], rb[ 1 ]
        
        info.ctx.moveTo focal[ 0 ], focal[ 1 ]
        info.ctx.lineTo lb[ 0 ], lb[ 1 ]
        info.ctx.stroke()
        
        info.ctx.strokeRect lt[ 0 ], lt[ 1 ], dim, dim
        info.ctx.closePath()
        
        
        info.ctx.beginPath()
        info.ctx.fillStyle = "red"
        info.ctx.arc focal[ 0 ], focal[ 1 ], size_elem * 0.5, 0, Math.PI * 2, true
        info.ctx.fill()
        info.ctx.closePath()