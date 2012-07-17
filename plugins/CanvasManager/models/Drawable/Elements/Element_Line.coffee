# straight line strip
class Element_Line extends Element_WithIndices
    constructor: ( indices = [] ) ->
        super indices
            
    draw: ( info, mesh, proj, is_a_sub, theme = info.theme.lines ) ->
        wf = mesh.visualization.display_style.get() in [ "Wireframe", "Surface with Edges" ]
        if wf or not is_a_sub
            theme.beg_ctx info
            
            # straight lines
            if @indices.length
                for i in [ 0 ... @indices.length - 1 ]
                    info.theme.lines.draw_straight_proj info, proj[ @indices[ i ].get() ], proj[ @indices[ i + 1 ].get() ]
            theme.end_ctx info

    contour: ( info, mesh, proj, beg, inversion ) ->
        if @indices.length >= 2
            if inversion
                for i in [ @indices.length - 2 .. 0 ]
                    info.theme.lines.contour_straight_proj info, proj[ @indices[ i + 1 ].get() ], proj[ @indices[ i ].get() ], beg and i == 0
            else
                for i in [ 0 ... @indices.length - 1 ]
                    info.theme.lines.contour_straight_proj info, proj[ @indices[ i ].get() ], proj[ @indices[ i + 1 ].get() ], beg and i == 0
            
    closest_point_closer_than: ( best, mesh, proj, info, pos ) ->
        if @indices.length
            for i in [ 0 ... @indices.length - 1 ]
                p0 = @indices[ i + 0 ].get()
                p1 = @indices[ i + 1 ].get()
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
                        if best.dist >= dist
                            P0 = mesh.points[ p0 ].pos.get()
                            P1 = mesh.points[ p1 ].pos.get()
                            best.dist = dist
                            best.inst = this
                            best.indi = i
                            best.curv = r
                            best.disp = [
                                P0[ 0 ] * ( 1 - r ) + P1[ 0 ] * r
                                P0[ 1 ] * ( 1 - r ) + P1[ 1 ] * r
                                P0[ 2 ] * ( 1 - r ) + P1[ 2 ] * r
                            ]
    
    # work after closest_point_closer_than. @see Mesh.on_mouse_down
    cut_with_point: ( divisions, data, mesh, np, ip ) ->
        if data.inst == this
            if not divisions[ @model_id ]?
                divisions[ @model_id ] = [
                    new Element_Line [ @indices[ 0 ].get(), np ]
                    new Element_Line [ np, @indices[ 1 ].get() ]
                ]
                
#             
#         # arcs
#         for l, j in @connectivity when l.length == 3
#             P0 = mesh.points[ l[ 0 ].get() ].pos.get()
#             P1 = mesh.points[ l[ 1 ].get() ].pos.get()
#             P2 = mesh.points[ l[ 2 ].get() ].pos.get()
#             info.theme.lines.draw_arc info, P0, P1, P2
# 
#         # draw interpolated arcs
#         for l in @connectivity when l.length > 3
#             points = for p in l
#                 mesh.points[ p.get() ].pos.get()
#             info.theme.lines.draw_interpolated_arcs info, points
#             
#         # draw point that are under the mouse pointer
#         if @_pelected_points.length
#             info.theme.highlighted_points.beg_ctx info
#             for p in @_pelected_points
#                 info.theme.highlighted_points.draw_proj info, p
# 
#     on_mouse_move_point_edition: ( mesh, proj, cm, evt, pos, b, old ) ->
#         res = @_lines_closer_than mesh, proj, cm.cam_info, evt, pos, 4
#         if res.length
#             res.sort ( a, b ) -> b.dist - a.dist
#             @_pelected_points.set [ res[ 0 ].proj ]
#             return true
#         @_pelected_points.clear()
#         return false
#             
#     on_mouse_down_point_edition: ( mesh, proj, cm, evt, pos, b, old ) ->
#         res = @_lines_closer_than mesh, proj, cm.cam_info, evt, pos, 4
#         if res.length
#             res.sort ( a, b ) -> b.dist - a.dist
#             res[ 0 ].func()
#             return true
#         return false
# 
#     rem_pelected: ->
#         @_pelected_points.clear()
# 
#     _lines_closer_than: ( mesh, proj, info, evt, pos, lim ) ->
#         res = []
#         for li, n in @connectivity when li.length == 2
#             do ( li, n ) =>
#                 p0 = li[ 0 ].get()
#                 p1 = li[ 1 ].get()
#                 a = proj[ p0 ]
#                 b = proj[ p1 ]
#                 
#                 if a[ 0 ] != b[ 0 ] or a[ 1 ] != b[ 1 ]
#                     dx = b[ 0 ] - a[ 0 ]
#                     dy = b[ 1 ] - a[ 1 ]
#                     dz = b[ 2 ] - a[ 2 ]
#                     px = pos[ 0 ] - a[ 0 ]
#                     py = pos[ 1 ] - a[ 1 ]
#                     l = dx * dx + dy * dy
#                     d = px * dx + py * dy
#                     if l and d >= 0 and d <= l
#                         r = d / l
#                         px = a[ 0 ] + dx * r
#                         py = a[ 1 ] + dy * r
#                         pz = a[ 2 ] + dz * r
#                         dist = Math.sqrt( Math.pow( px - pos[ 0 ], 2 ) + Math.pow( py - pos[ 1 ], 2 ) )
#                         if dist <= lim
#                             res.push
#                                 proj: [ px, py, pz ]
#                                 dist: dist
#                                 inst: li
#                                 num : n
#                                 r   : r
#                                 func: =>
#                                     # add new point + connectivity
#                                     P0 = mesh.points[ p0 ].pos.get()
#                                     P1 = mesh.points[ p1 ].pos.get()
#                                     NP = [
#                                         P0[ 0 ] * ( 1 - r ) + P1[ 0 ] * r
#                                         P0[ 1 ] * ( 1 - r ) + P1[ 1 ] * r
#                                         P0[ 2 ] * ( 1 - r ) + P1[ 2 ] * r
#                                     ]
#                                     mesh.add_point NP
#                                     
#                                     os = mesh.points.length - 1
#                                     ol = li[ 1 ].get()
#                                     li[ 1 ].set os
#                                     @connectivity.push [ os, ol ]
#                                     mesh.update_sub_elt()
#                                     
#                                     @_pelected_points.clear()
#                                     
#                                     # add new point to selected points
#                                     if evt.ctrlKey
#                                         mesh._selected_points.push os
#                                     else
#                                         mesh._selected_points.set [ os ]
#                                     mesh._moving_point = mesh.points[ os ]
#                                     mesh._moving_point.beg_click pos
#         
#         return res
#         
#                                 
        