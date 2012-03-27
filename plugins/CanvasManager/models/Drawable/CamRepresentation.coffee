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
#         orig = info.re_2_sc.pos @cam.O[ 0 ].get(), @cam.O[ 1 ].get(), @cam.O[ 2 ].get() - @cam.d.get()
#         dir = info.re_2_sc.dir @cam.C.get()
        orig = info.re_2_sc.proj [ 0, 0,  0 - @cam.d.get() ]
        dir = info.re_2_sc.proj [ 0, 0,  0 ]

        info.ctx.lineWidth = 1
        size_elem = 5
        
        info.ctx.strokeStyle = "white"
        info.ctx.beginPath()
        info.ctx.moveTo orig[ 0 ], orig[ 1 ]
        info.ctx.lineTo dir[ 0 ], dir[ 1 ]
        info.ctx.stroke()
        info.ctx.closePath()
        
        info.ctx.beginPath()
        info.ctx.fillStyle = "blue"
        info.ctx.arc dir[ 0 ], dir[ 1 ], size_elem * 0.5, 0, Math.PI * 2, true
        info.ctx.fill()
        info.ctx.closePath()
        
        info.ctx.beginPath()
        info.ctx.fillStyle = "red"
        info.ctx.fillRect orig[ 0 ] - size_elem * 0.5, orig[ 1 ] - size_elem * 0.5, size_elem, size_elem
        info.ctx.fill()
        info.ctx.closePath()
        