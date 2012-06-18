# arc or succession of inerpolated arcs
# 
class Element_Arc extends Element_WithIndices
    constructor: ( indices ) ->
        super indices

    draw: ( info, mesh, proj, is_a_sub ) ->
        points = for p in @indices
            mesh.points[ p.get() ].pos.get()
        info.theme.lines.draw_interpolated_arcs info, points

    contour: ( info, mesh, proj, beg, inversion ) ->
        points = if inversion
            for p in [ @indices.length - 1 .. 0 ]
                mesh.points[ @indices[ p ].get() ].pos.get()
        else
            for p in @indices
                mesh.points[ p.get() ].pos.get()
        info.theme.lines.contour_interpolated_arcs info, points, beg
        