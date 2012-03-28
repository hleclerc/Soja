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
        
        ninfo = 
            re_2_sc  : @cam.re_2_sc info.w, info.h
            sc_2_rw  : @cam.sc_2_rw info.w, info.h
        
        focal = info.re_2_sc.proj ninfo.sc_2_rw.focal_point()
        # console.log 'focal ' + focal, focal
        
        info.ctx.lineWidth = 1
        size_elem = 5
        
        #         info.ctx.strokeStyle = "white"
        #         info.ctx.beginPath()
        #         info.ctx.moveTo orig[ 0 ], orig[ 1 ]
        #         info.ctx.lineTo focal[ 0 ], focal[ 1 ]
        #         info.ctx.stroke()
        #         info.ctx.closePath()
        
        info.ctx.beginPath()
        info.ctx.fillStyle = "red"
        info.ctx.arc focal[ 0 ], focal[ 1 ], size_elem * 0.5, 0, Math.PI * 2, true
        info.ctx.fill()
        info.ctx.closePath()
        
        #         info.ctx.beginPath()
        #         info.ctx.fillStyle = "red"
        #         info.ctx.fillRect orig[ 0 ] - size_elem * 0.5, orig[ 1 ] - size_elem * 0.5, size_elem, size_elem
        #         info.ctx.fill()
        #         info.ctx.closePath()
        