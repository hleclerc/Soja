#
class PointMesher extends Drawable
    constructor: ( pos = [ 0, 0, 0 ], density = 2, radius = 0.5 )->
        super()
        
        
        @add_attr
            point     : new Point pos
            density   : density
            radius    : radius
            # behavior
            _selected : new Lst # references of selected point
            _pre_sele : new Lst # references of selected point
            
            
    z_index: ->
        return 1000

    
    draw: ( info ) ->
        # preparation
        selected = {}
        for item in @_selected
            selected[ item.model_id ] = true
            
        _pre_sele = {}
        for item in @_pre_sele
            _pre_sele[ item.model_id ] = true
        proj = info.re_2_sc.proj @point.pos.get()
            
        # draw points
        info.ctx.lineWidth   = 1
        info.ctx.strokeStyle = "#993311"
        info.ctx.fillStyle = "#553311"
        if selected[ @point.model_id ]?
            info.ctx.strokeStyle = "#FF0000"
        else
            info.ctx.strokeStyle = "#FFFF00"
        
        info.ctx.beginPath()
        info.ctx.arc proj[ 0 ], proj[ 1 ], 4, 0, Math.PI * 2, true
        info.ctx.closePath()
        info.ctx.fill()
        info.ctx.stroke()
            
        if _pre_sele[ this.model_id ]?
            info.ctx.fillStyle = "#FFDD22"
            info.ctx.beginPath()
            info.ctx.lineWidth = 0.8
            info.ctx.arc proj[ 0 ], proj[ 1 ], 3, 0, Math.PI * 2, true
            info.ctx.fill()

            info.ctx.closePath()
    
    get_movable_entities: ( res, info, pos, phase ) ->
        x = pos[ 0 ]
        y = pos[ 1 ]
        if phase == 0
            proj = info.re_2_sc.proj @point.pos.get()
            dx = x - proj[ 0 ]
            dy = y - proj[ 1 ]
            d = Math.sqrt dx * dx + dy * dy
            if d <= 10
                res.push
                    item: @point
                    dist: d
                    type: "PointMesher"
                
                        
    on_mouse_down: ( cm, evt, pos, b ) ->
        delete @_movable_entity
        
        if b == "LEFT" or b == "RIGHT"
            # look if there's a movable point under mouse
            for phase in [ 0 ... 3 ]
                # closest entity under mouse
                res = []
                @get_movable_entities res, cm.cam_info, pos, phase
                if res.length
                    res.sort ( a, b ) -> b.dist - a.dist
                    @_movable_entity = res[ 0 ].item
                    
                    if evt.ctrlKey # add / rem selection
                        @_selected.toggle_ref @_movable_entity
                        if not @_selected.contains_ref @_movable_entity
                            delete @_movable_entity
                    else
                        @_selected.clear()
                        @_selected.push @_movable_entity
                        @_movable_entity.beg_click pos
                        
                    if b == "RIGHT"
                        return false
                        
                    return true
                    
        return false
                    
    on_mouse_move: ( cm, evt, pos, b, old ) ->
        if b == "LEFT" and @_movable_entity?
            cm.undo_manager?.snapshot()
                
            p_0 = cm.cam_info.sc_2_rw.pos pos[ 0 ], pos[ 1 ]
            d_0 = cm.cam_info.sc_2_rw.dir pos[ 0 ], pos[ 1 ]
            @_movable_entity.move @_selected, @_movable_entity.pos, p_0, d_0
            
            return true

        # pre selection
        res = []
        x = pos[ 0 ]
        y = pos[ 1 ]
        
        proj = cm.cam_info.re_2_sc.proj @point.pos.get()
        dx = x - proj[ 0 ]
        dy = y - proj[ 1 ]
        d = Math.sqrt dx * dx + dy * dy
        if d <= 10
            res.push
                item: this
                dist: d
                
        if res.length
            res.sort ( a, b ) -> b.dist - a.dist
            if @_pre_sele.length != 1 or @_pre_sele[ 0 ] != res[ 0 ].item
                @_pre_sele.clear()
                @_pre_sele.push res[ 0 ].item
                
        else if @_pre_sele.length
            @_pre_sele.clear()
        
        return false
        
    # onmousemove func
#         if @lock.get() != true
#             @old_points[ i ].set @cur_points[ i ].get()
#             res.push
#                 item: @old_points[ i ]
#                 dist: d
#                 type: "Transform"