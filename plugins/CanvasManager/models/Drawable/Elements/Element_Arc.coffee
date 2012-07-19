# arc or succession of inerpolated arcs
# 
class Element_Arc extends Element_WithIndices
    constructor: ( indices ) ->
        super indices

    draw: ( info, mesh, proj, is_a_sub, theme = info.theme.lines ) ->
        wf = mesh.visualization.display_style.get() in [ "Wireframe", "Surface with Edges" ]
        if wf or not is_a_sub
            theme.beg_ctx info
            points = for p in @indices
                mesh.points[ p.get() ].pos.get()
            info.theme.lines.draw_interpolated_arcs info, points
            theme.end_ctx info

    contour: ( info, mesh, proj, beg, inversion ) ->
        points = if inversion
            for p in [ @indices.length - 1 .. 0 ]
                mesh.points[ @indices[ p ].get() ].pos.get()
        else
            for p in @indices
                mesh.points[ p.get() ].pos.get()
        info.theme.lines.contour_interpolated_arcs info, points, beg
        
        
    # TODO Only check as if it was an Element_Line and not as an Arc
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
                            best.curv = r # curvilinear abscissa
                            best.disp = [
                                P0[ 0 ] * ( 1 - r ) + P1[ 0 ] * r
                                P0[ 1 ] * ( 1 - r ) + P1[ 1 ] * r
                                P0[ 2 ] * ( 1 - r ) + P1[ 2 ] * r
                            ]