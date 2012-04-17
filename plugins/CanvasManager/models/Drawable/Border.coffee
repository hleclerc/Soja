#
class Border extends Drawable
    constructor: ( _border_type = "#FFFFFF" ) ->
        super()
        
        @add_attr
            _border_type     : _border_type
            
            # geometry
            points           : new Lst_Point # "add_point" can be used to fill the list
            lines            : new Lst
            # behavior
            _selected        : new Lst # references of selected points / lines / ...
            _pre_sele        : new Lst # references of selected points / lines / ...
                    
    z_index: ->
        return 1
        
    draw: ( info ) ->
        if @points.length == 0
            return
            
        # preparation
        selected = {}
        for item in @_selected
            selected[ item.model_id ] = true
            
        _pre_sele = {}
        for item in @_pre_sele
            _pre_sele[ item.model_id ] = true
        
        proj = for p in @points
            info.re_2_sc.proj p.pos.get()
        
        # 
        if @_border_type.get() == 'constrain_displacement'
            color_line = info.theme.constrain_boundary_displacement.to_hex()
        if @_border_type.get() == 'constrain_strain'
            color_line = info.theme.constrain_boundary_strain.to_hex()
        if @_border_type.get() == 'constrain_pressure'
            color_line = info.theme.constrain_boundary_pressure.to_hex()
        if @_border_type.get() == 'free'
            color_line = info.theme.free_boundary.to_hex()
            
        info.ctx.fillStyle = "#FFFFFF"
        info.ctx.strokeStyle = color_line

            
        # draw lines
        for l, j in @lines when l.length == 2
            if l in @_pre_sele
                info.ctx.lineWidth = 2
            else
                info.ctx.lineWidth = 1
            info.ctx.beginPath()
            info.ctx.moveTo proj[ l[ 0 ].get() ][ 0 ], proj[ l[ 0 ].get() ][ 1 ]
            info.ctx.lineTo proj[ l[ 1 ].get() ][ 0 ], proj[ l[ 1 ].get() ][ 1 ]
            info.ctx.stroke()
            
    update_min_max: ( x_min, x_max ) ->
        for m in @points
            p = m.pos.get()
            for d in [ 0 ... 3 ]
                x_min[ d ] = Math.min x_min[ d ], p[ d ]
                x_max[ d ] = Math.max x_max[ d ], p[ d ]
                
                
    on_mouse_down: ( cm, evt, pos, b ) ->
        if b == "LEFT"
            if cm._flat?
                res = []
                for el in cm._flat when el instanceof Mesh or el instanceof Border
                    if el.lines?
                        # closest entity under mouse
                        @get_movable_entities res, cm.cam_info, pos, el
                if res.length
                    res.sort ( a, b ) -> b.dist - a.dist
                    @_may_need_snapshot = true
                    line = res[ 0 ].item[ 0 ]
                    if line not in @_selected
                        console.log "line founded"
                        @_selected.push line
                        l = @points.length
                        
                        #We could bind P0 pos to actual mesh (so if mesh move, P0 will move too)
                        P0   = res[ 0 ].item[ 1 ]
                        P1   = res[ 0 ].item[ 2 ]
                        
                        @points.push P0
                        @points.push P1
                        @lines.push [ l, l + 1 ]
                    else
                        console.log "line deleted"
                        ind = @_selected.indexOf line
                        @_selected.splice ind, 1
                        #TODO delete line (code is in mesh.coffee)
                    
                    return true
                    
        return false
        
    on_mouse_move: ( cm, evt, pos, b ) ->
        @_pre_sele.clear()
        if cm._flat?
            res = []
            for el in cm._flat when el instanceof Mesh or el instanceof Border
                if el.lines?
                    # closest entity under mouse
                    @get_movable_entities res, cm.cam_info, pos, el
        if res.length
            res.sort ( a, b ) -> b.dist - a.dist
            @_may_need_snapshot = false
            line = res[ 0 ].item[ 0 ]
            P0   = res[ 0 ].item[ 1 ]
            P1   = res[ 0 ].item[ 2 ]
            if line not in @_pre_sele
                @_pre_sele.push line
                # should call onchange method
            
    get_movable_entities: ( res, info, pos, el ) ->
        x = pos[ 0 ]
        y = pos[ 1 ]
        proj = for p in el.points
            info.re_2_sc.proj p.pos.get()
            
        for li, i in el.lines when li.length == 2
            P0 = el.lines[ i ][ 0 ].get()
            P1 = el.lines[ i ][ 1 ].get()
            
            point = @_get_line_inter proj, P0, P1, x, y, el
            if point?
                res.push
                    item: [ el.lines[ i ], el.points[ P0 ], el.points[ P1 ] ]
                    dist: 0
                    type: "Mesh"
                break
    
    _get_line_inter: ( proj, P0, P1, x, y, el ) ->
        lg_0 = P0
        lg_1 = P1
        
        a = proj[ lg_0 ]
        b = proj[ lg_1 ]
        
        if a[ 0 ] != b[ 0 ] or a[ 1 ] != b[ 1 ]
            dx = b[ 0 ] - a[ 0 ]
            dy = b[ 1 ] - a[ 1 ]
            px = x - a[ 0 ]
            py = y - a[ 1 ]
            l = dx * dx + dy * dy
            d = px * dx + py * dy
            if d >= 0 and d <= l
                px = a[ 0 ] + dx * d / l
                py = a[ 1 ] + dy * d / l
                if Math.pow( px - x, 2 ) + Math.pow( py - y, 2 ) <= 4 * 4
                    dx = el.points[ lg_1 ].pos[ 0 ].get() - el.points[ lg_0 ].pos[ 0 ].get()
                    dy = el.points[ lg_1 ].pos[ 1 ].get() - el.points[ lg_0 ].pos[ 1 ].get()
                    dz = el.points[ lg_1 ].pos[ 2 ].get() - el.points[ lg_0 ].pos[ 2 ].get()
                    
                    return [ dx, dy, dz, d / l ]