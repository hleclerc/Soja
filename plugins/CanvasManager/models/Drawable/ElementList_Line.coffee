# 2 points -> straight line
# 3 points -> arc circle
# n > 3 points -> succession of interpolated arc circle
class ElementList_Line extends ElementList
    constructor: () ->
        super()
        
        @add_attr
            connectivity    : [] # list of list of point numbers
            _pelected_points: [] # list of projected coordinates

    add_element: ( lst ) ->
        @connectivity.push lst
    
    element_type: ->
        "Line"
        
    draw: ( info, mesh, proj ) ->
        info.theme.lines.prep_ctx info
        
        # straight lines
        for l, j in @connectivity when l.length == 2
            info.theme.lines.draw_straight_proj info, proj[ l[ 0 ].get() ], proj[ l[ 1 ].get() ]
            
        # arcs
        for l, j in @connectivity when l.length == 3
            P0 = mesh.points[ l[ 0 ].get() ].pos.get()
            P1 = mesh.points[ l[ 1 ].get() ].pos.get()
            P2 = mesh.points[ l[ 2 ].get() ].pos.get()
            info.theme.lines.draw_arc info, P0, P1, P2

        # draw interpolated arcs
        for l in @connectivity when l.length > 3
            points = for p in l
                mesh.points[ p.get() ].pos.get()
            info.theme.lines.draw_interpolated_arcs info, points
            
        # draw point that are under the mouse pointer
        if @_pelected_points.length
            info.theme.highlighted_points.prep_ctx info
            for p in @_pelected_points
                info.theme.highlighted_points.draw_proj info, p

        # draw lines that are under mouse
        #         if @_pre_sele.length
        #             info.ctx.strokeStyle = @_pre_sele_color.to_hex()
        #             for l in @_pre_sele when l not instanceof Point
        #                 if l.length == 2
        #                     info.ctx.lineWidth = 2
        #                     info.ctx.beginPath()
        #                     info.ctx.moveTo proj[ l[ 0 ].get() ][ 0 ], proj[ l[ 0 ].get() ][ 1 ]
        #                     info.ctx.lineTo proj[ l[ 1 ].get() ][ 0 ], proj[ l[ 1 ].get() ][ 1 ]
        #                     info.ctx.stroke()
        #                     info.ctx.lineWidth = 1
        #             info.ctx.strokeStyle = "#FFFFFF"

    on_mouse_move_point_edition: ( mesh, proj, cm, evt, pos, b, old ) ->
        res = @_lines_closer_than mesh, proj, cm.cam_info, evt, pos, 4
        if res.length
            res.sort ( a, b ) -> b.dist - a.dist
            @_pelected_points.set [ res[ 0 ].proj ]
            return true
        @_pelected_points.clear()
        return false
            
    on_mouse_down_point_edition: ( mesh, proj, cm, evt, pos, b, old ) ->
        res = @_lines_closer_than mesh, proj, cm.cam_info, evt, pos, 4
        if res.length
            res.sort ( a, b ) -> b.dist - a.dist
            res[ 0 ].func()
            return true
        return false
        
            #             P0 = proj[ li[ 0 ].get() ]
            #             P1 = proj[ li[ 1 ].get() ]
            #             
            #             point = @_get_line_inter , P0, P1, pos
            #             if point?
            #                 P = [
            #                     mesh[ P0 ].pos[ 0 ].get() + point[ 0 ] * point[ 3 ],
            #                     mesh[ P0 ].pos[ 1 ].get() + point[ 1 ] * point[ 3 ],
            #                     mesh[ P0 ].pos[ 2 ].get() + point[ 2 ] * point[ 3 ]
            #                 ]
            #             
            #                         
            #                     n = @points[ @points.length-1 ]
            #                     ol = P1
            #                     li[ 1 ].set os
            #                     
            #                     current_line = @lines.length
            #                     @lines.push [ os, ol ]
            #                     @polygons[ 0 ].insert ol, [ current_line ]
            #                     res.push
            #                         prov: this
            #                         item: n
            #                         dist: 0
            #                         type: "Mesh"
            #                         
            #                     break
        false

    rem_pelected: ->
        @_pelected_points.clear()

    _lines_closer_than: ( mesh, proj, info, evt, pos, lim ) ->
        res = []
        for li, n in @connectivity when li.length == 2
            do ( li, n ) =>
                p0 = li[ 0 ].get()
                p1 = li[ 1 ].get()
                a = proj[ p0 ]
                b = proj[ p1 ]
                
                if a[ 0 ] != b[ 0 ] or a[ 1 ] != b[ 1 ]
                    dx = b[ 0 ] - a[ 0 ]
                    dy = b[ 1 ] - a[ 1 ]
                    dz = b[ 2 ] - a[ 2 ]
                    px = pos[ 0 ] - a[ 0 ]
                    py = pos[ 1 ] - a[ 1 ]
                    l = dx * dx + dy * dy
                    d = px * dx + py * dy
                    if l and d >= 0 and d <= l
                        r = d / l
                        px = a[ 0 ] + dx * r
                        py = a[ 1 ] + dy * r
                        pz = a[ 2 ] + dz * r
                        dist = Math.sqrt( Math.pow( px - pos[ 0 ], 2 ) + Math.pow( py - pos[ 1 ], 2 ) )
                        if dist <= lim
                            res.push
                                proj: [ px, py, pz ]
                                dist: dist
                                inst: li
                                num : n
                                r   : r
                                func: =>
                                    # add new point + connectivity
                                    P0 = mesh.points[ p0 ].pos.get()
                                    P1 = mesh.points[ p1 ].pos.get()
                                    NP = [
                                        P0[ 0 ] * ( 1 - r ) + P1[ 0 ] * r
                                        P0[ 1 ] * ( 1 - r ) + P1[ 1 ] * r
                                        P0[ 2 ] * ( 1 - r ) + P1[ 2 ] * r
                                    ]
                                    mesh.add_point NP
                                    
                                    os = mesh.points.length - 1
                                    ol = li[ 1 ].get()
                                    li[ 1 ].set os
                                    @connectivity.push [ os, ol ]
                                    mesh.update_sub_elt()
                                    
                                    @_pelected_points.clear()
                                    
                                    # add new point to selected points
                                    if evt.ctrlKey
                                        mesh._selected_points.push os
                                    else
                                        mesh._selected_points.set [ os ]
                                    mesh._moving_point = mesh.points[ os ]
                                    mesh._moving_point.beg_click pos
        
        return res
        
                                
        