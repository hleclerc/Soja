# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2012 Hugo Leclerc
#
# This file is part of Soda.
#
# Soda is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Soda is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with Soda. If not, see <http://www.gnu.org/licenses/>.



class ZoomArea extends Drawable
    constructor: ( @canvas_manager, params = {} ) ->
        super()
        
        @add_attr
            zoom_factor: [  5,  5, 1 ]
            zoom_pos   : [ -1, -1, 0 ]
        
        for key, val of params
            this[ key ]?.set? val
        
    z_index: ->
        1000

    always_active: ->
        true
        
    on_mouse_move: ( cm, evt, pos, b ) ->
        @zoom_pos[ 0 ].set pos[ 0 ]
        @zoom_pos[ 1 ].set pos[ 1 ]
        false
    
    on_mouse_wheel: ( cm, evt, pos, b, delta ) ->
        n = Math.pow 1.2, delta
        @zoom_factor[ 0 ].set @zoom_factor[ 0 ] * n
        @zoom_factor[ 1 ].set @zoom_factor[ 1 ] * n
        true

    draw: ( info ) ->
        clientX = @zoom_pos[ 0 ].get()
        clientY = @zoom_pos[ 1 ].get()
        zx = @zoom_factor[ 0 ].get()
        zy = @zoom_factor[ 1 ].get()
        
        n_info = {}
        for key, val of info
            n_info[ key ] = val
        
        n_info.re_2_sc =
            proj: ( p ) ->
                np = info.re_2_sc.proj p
                [
                    zx * ( np[ 0 ] - clientX ) + clientX,
                    zy * ( np[ 1 ] - clientY ) + clientY,
                    p[ 2 ]
                ]
        
        # Create a circular clipping path
        info.ctx.save()
        info.ctx.beginPath()
        
        info.ctx.strokeStyle = 'rgba(170,170,200,0.8)'
        info.ctx.shadowBlur  = 5
        info.ctx.shadowColor = "lightBlue"
        info.ctx.lineWidth   = 4
        info.ctx.arc clientX, clientY, 100, 0, Math.PI*2, true
        info.ctx.stroke()
        
        info.ctx.shadowBlur    = 0
        info.ctx.shadowColor   = "transparent black"
        
        info.ctx.fillStyle = "lightBlue"
        info.ctx.font = "10px Arial"
        info.ctx.textBaseline = 'bottom'
        info.ctx.textAlign = 'left'
        info.ctx.fillText "X " + @zoom_factor[ 0 ].get().toFixed(1), clientX + 75 , clientY - 75
        
        info.ctx.closePath()
        info.ctx.clip()
        
        
        
        for it in @canvas_manager._flat when it != this and it not instanceof Axes
            it.draw n_info
            
        info.ctx.restore()

