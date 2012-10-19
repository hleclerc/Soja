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



#
class Legend extends Drawable
    constructor: ( title = "", show_legend = true, auto_fit = true )->
        super()
        
        @add_attr
            show_legend: show_legend
            color_map  : new Gradient
            auto_fit   : auto_fit
            _title     : title
            _width     : 30
            _height    : 300
            _min_val    : 0
            _max_val    : -1
            
        @add_attr
            max_val    : new ConstOrNotModel( @auto_fit, @_max_val, false )
            min_val    : new ConstOrNotModel( @auto_fit, @_min_val, false )
        
        @color_map.add_color [ 255,255,255, 255 ], 0
        @color_map.add_color [   0,  0,  0, 255 ], 1
        
    z_index: ->
        return 1000

    is_correct: ->
        @max_val.get() >= @min_val.get()
        
    get_ratio: ( info ) ->
        info.h / ( @_height.get() * 1.7 )
    
    draw_text_legend: ( info ) ->
        ratio = @get_ratio info
        height = @_height.get() * ratio
        width = @_width.get() * ratio
        
        pos_y = info.h * 0.5 - height * 0.5
        pos_x = info.w - width - width * 2.5
        font_size = 13 * ratio 
        info.ctx.font = font_size + "pt Arial"
        info.ctx.fillStyle = "White"
        info.ctx.textAlign = "right"
        for c_s in @color_map.color_stop
            pos = c_s.position.get()
            val = ( @max_val.get() - @min_val.get() ) * ( 1 - c_s.position.get() ) + @min_val.get()
            info.ctx.fillText( val.toFixed( 4 ), pos_x - 8, pos_y + 7 + pos * height )
    
    draw: ( info ) ->
        if @show_legend.get() == true
            @color_map = info.theme.gradient_legend
            
            ratio = @get_ratio info
            height = @_height.get() * ratio
            width = @_width.get() * ratio
            
            pos_y = info.h * 0.5 - height * 0.5
            pos_x = info.w - width - width * 2.5
            lineargradient = info.ctx.createLinearGradient( 0, pos_y, 0, pos_y + height )
            for col in @color_map.color_stop
                lineargradient.addColorStop( col.position.get(), "rgba(#{col.color.r.get()}, #{col.color.g.get()}, #{col.color.b.get()}, #{col.color.a.get()})" )
            info.ctx.fillStyle = lineargradient
            info.ctx.fillRect( pos_x, pos_y, width, height )
            
            @draw_text_legend info
            
            font_size = 18 * ratio 
            
            info.ctx.font = font_size + "pt Arial"
            info.ctx.textAlign = "center"
            t = @_title?.toString()
            if t?
                info.ctx.fillText( t, pos_x + width * 0.5, pos_y + height + height * 0.2 )
    