# This class is use to draw a cam representation
class CamRepresentation extends Drawable
    constructor: ( cam, params = {} ) ->
        super()
        
        @add_attr
            cam: cam

        for key, val of params
            this[ key ]?.set? val
            
    z_index: ->
        10
        
    draw: ( info ) ->
        d = @cam.d.get()
        e = d * Math.tan( @cam.get_a() * 0.017453292519943295 / 2 )
        X = Vec_3.mus e, @cam.get_X()
        Y = Vec_3.mus e, @cam.get_Y()
        Z = Vec_3.mus d, @cam.get_Z()
        
        F = @cam.focal_point()
        P = info.re_2_sc.proj F
                
        
        lt = info.re_2_sc.proj [ F[ 0 ] + Z[ 0 ] - X[ 0 ] + Y[ 0 ], F[ 1 ] + Z[ 1 ] - X[ 1 ] + Y[ 1 ], F[ 2 ] + Z[ 2 ] - X[ 2 ] + Y[ 2 ] ]
        rt = info.re_2_sc.proj [ F[ 0 ] + Z[ 0 ] + X[ 0 ] + Y[ 0 ], F[ 1 ] + Z[ 1 ] + X[ 1 ] + Y[ 1 ], F[ 2 ] + Z[ 2 ] + X[ 2 ] + Y[ 2 ] ]
        rb = info.re_2_sc.proj [ F[ 0 ] + Z[ 0 ] + X[ 0 ] - Y[ 0 ], F[ 1 ] + Z[ 1 ] + X[ 1 ] - Y[ 1 ], F[ 2 ] + Z[ 2 ] + X[ 2 ] - Y[ 2 ] ]
        lb = info.re_2_sc.proj [ F[ 0 ] + Z[ 0 ] - X[ 0 ] - Y[ 0 ], F[ 1 ] + Z[ 1 ] - X[ 1 ] - Y[ 1 ], F[ 2 ] + Z[ 2 ] - X[ 2 ] - Y[ 2 ] ]
        
        info.ctx.lineWidth = 2
        size_elem = 10
        info.ctx.beginPath()
        info.ctx.strokeStyle = "lightBlue"
        info.ctx.moveTo P[ 0 ], P[ 1 ]
        info.ctx.lineTo lt[ 0 ], lt[ 1 ]
        
        info.ctx.moveTo P[ 0 ], P[ 1 ]
        info.ctx.lineTo rt[ 0 ], rt[ 1 ]
        
        info.ctx.moveTo P[ 0 ], P[ 1 ]
        info.ctx.lineTo rb[ 0 ], rb[ 1 ]
        
        info.ctx.moveTo P[ 0 ], P[ 1 ]
        info.ctx.lineTo lb[ 0 ], lb[ 1 ]
        
        info.ctx.moveTo lt[ 0 ], lt[ 1 ]
        info.ctx.lineTo rt[ 0 ], rt[ 1 ]
        info.ctx.lineTo rb[ 0 ], rb[ 1 ]
        info.ctx.lineTo lb[ 0 ], lb[ 1 ]
        info.ctx.lineTo lt[ 0 ], lt[ 1 ]
        
        info.ctx.stroke()
        info.ctx.closePath()
        
        
        info.ctx.beginPath()
        info.ctx.fillStyle = "navy"
        info.ctx.arc P[ 0 ], P[ 1 ], size_elem * 0.5, 0, Math.PI * 2, true
        info.ctx.fill()
        if @cam? and @cam.model_id?
            info.ctx.fillStyle = "white"
            info.ctx.font = "10px Arial"
            info.ctx.fillText("Cam " + @cam.model_id, P[ 0 ] + 10, P[ 1 ] - 10)
        info.ctx.closePath()