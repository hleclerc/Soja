#
class CuttingPlan extends Drawable
    constructor: ( pos = [ 0, 0, 0 ], dir = [ 0, 0, -0.2 ] ) ->
        super()
        
        @add_attr
            pos: new Point pos
            dir: new Point dir
            
            
    z_index: ->
        return 1

    
    draw: ( info ) ->
    
        proj_pos = info.re_2_sc.proj @pos.pos.get()
        proj_dir = info.re_2_sc.proj @dir.pos.get()
        
        # draw plan
        #TODO width and height must be calculated from the cutting plan item childrens dimensions
        width = 0.3
        height = 0.3
        half_width = width / 2
        half_height = height / 2
        
        lt = info.re_2_sc.proj [ @pos.pos[ 0 ] - half_width, @pos.pos[ 1 ] + half_height, @pos.pos[ 2 ] ]
        rt = info.re_2_sc.proj [ @pos.pos[ 0 ] + half_width, @pos.pos[ 1 ] + half_height, @pos.pos[ 2 ] ]
        rb = info.re_2_sc.proj [ @pos.pos[ 0 ] + half_width, @pos.pos[ 1 ] - half_height, @pos.pos[ 2 ] ]
        lb = info.re_2_sc.proj [ @pos.pos[ 0 ] - half_width, @pos.pos[ 1 ] - half_height, @pos.pos[ 2 ] ]

        info.ctx.beginPath()
        info.ctx.fillStyle = "lightBlue"
        info.ctx.moveTo lt[ 0 ], lt[ 1 ]
        info.ctx.lineTo rt[ 0 ], rt[ 1 ]
        info.ctx.lineTo rb[ 0 ], rb[ 1 ]
        info.ctx.lineTo lb[ 0 ], lb[ 1 ]
        info.ctx.lineTo lt[ 0 ], lt[ 1 ]
        
        info.ctx.fill()
        info.ctx.stroke()
        info.ctx.closePath()
        
        
        # draw points
        info.ctx.lineWidth   = 1
        info.ctx.strokeStyle = "#333311"
        info.ctx.fillStyle = "#333311"
        
        info.ctx.beginPath()
        info.ctx.arc proj_pos[ 0 ], proj_pos[ 1 ], 4, 0, Math.PI * 2, true
        info.ctx.fill()
        info.ctx.stroke()
        info.ctx.closePath()
        
        # draw line indicating direction
        info.ctx.beginPath()
        info.ctx.strokeStyle = "orange"
        info.ctx.moveTo proj_pos[ 0 ], proj_pos[ 1 ]
        info.ctx.lineTo proj_dir[ 0 ], proj_dir[ 1 ]
        info.ctx.fill()
        info.ctx.stroke()
        

    
#     get_movable_entities: ( res, info, pos, phase ) ->
#         x = pos[ 0 ]
#         y = pos[ 1 ]
#         if phase == 0
#             for p, i in @cur_points
#                 proj = info.re_2_sc.proj p.pos.get()
#                 dx = x - proj[ 0 ]
#                 dy = y - proj[ 1 ]
#                 d = Math.sqrt dx * dx + dy * dy
#                 if d <= 10
#                     res.push
#                         item: p
#                         dist: d
#                         type: "CuttingPlan"