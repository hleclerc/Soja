#
class Transform extends Drawable
    constructor: ->
        super()
        
        
        @add_attr
            cur_points: new Lst_Point
            old_points: new Lst_Point
            
            
    z_index: ->
        return 1000
        
    draw: ( info ) ->
        draw_point = info.sel_item[ @model_id ]
        if @cur_points.length && draw_point
            proj = for p in @cur_points
                info.re_2_sc.proj p.pos.get()
            # draw points
            for n in [ 0 ... proj.length ]
                info.ctx.lineWidth   = 1
                info.ctx.strokeStyle = "#333311"
                info.ctx.fillStyle = "#333311"
                p = proj[ n ]
                if info.selected[ @cur_points[ n ].model_id ]?
                    info.ctx.strokeStyle = "#FF0000"
                else
                    info.ctx.strokeStyle = "#FFFF00"
                
                info.ctx.beginPath()
                info.ctx.arc p[ 0 ], p[ 1 ], 4, 0, Math.PI * 2, true
                info.ctx.closePath()
                info.ctx.fill()
                info.ctx.stroke()
                
                if info.pre_sele[ @cur_points[ n ].model_id ]?
                    info.ctx.fillStyle = "#FFFF22"
                    info.ctx.beginPath()
                    info.ctx.lineWidth = 0.8
                    info.ctx.arc p[ 0 ], p[ 1 ], 3, 0, Math.PI * 2, true
                    info.ctx.fill()

                    info.ctx.closePath()
    
    
    get_movable_entities: ( res, info, pos, phase ) ->
        x = pos[ 0 ]
        y = pos[ 1 ]
        if phase == 0
            for p in @cur_points
                proj = info.re_2_sc.proj p.pos.get()
                dx = x - proj[ 0 ]
                dy = y - proj[ 1 ]
                d = Math.sqrt dx * dx + dy * dy
                if d <= 10
                    res.push
                        item: p
                        dist: d
                        type: "Transform"
                        
