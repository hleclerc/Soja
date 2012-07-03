# arc or succession of inerpolated arcs
# 
class Element_Arc extends Element_WithIndices
    constructor: ( indices ) ->
        super indices

    draw: ( info, mesh, proj, is_a_sub ) ->
        wf = mesh.visualization.display_style.get() in [ "Wireframe", "Surface with Edges" ]
        if wf or not is_a_sub
            info.theme.lines.beg_ctx info
            points = for p in @indices
                mesh.points[ p.get() ].pos.get()
            info.theme.lines.draw_interpolated_arcs info, points
            info.theme.lines.end_ctx info

    contour: ( info, mesh, proj, beg, inversion ) ->
        points = if inversion
            for p in [ @indices.length - 1 .. 0 ]
                mesh.points[ @indices[ p ].get() ].pos.get()
        else
            for p in @indices
                mesh.points[ p.get() ].pos.get()
        info.theme.lines.contour_interpolated_arcs info, points, beg
        