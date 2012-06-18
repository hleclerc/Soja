# 
class Element_BoundedSurf extends Element
    constructor: ( boundaries = [] ) ->
        super()
        
        @add_attr
            boundaries: boundaries   # list of { e: element ref, o: orientation }
        
    draw: ( info, mesh, proj, is_a_sub ) ->
        info.theme.surfaces.beg_ctx info

        info.theme.surfaces.draw info, =>
            for b, n in @boundaries 
                b.e.contour info, mesh, proj, n == 0, b.o < 0
            

    closest_point_closer_than: ( best, mesh, proj, info, pos ) ->
        undefined
    
    # work after closest_point_closer_than. @see Mesh.on_mouse_down
    cut_with_point: ( divisions, data, mesh, np, ip ) ->
        res = []
        for b, n in @boundaries 
            b.e.cut_with_point? divisions, data, mesh, np, ip
            if divisions[ b.e.model_id ]?
                if b.o < 0
                    d = divisions[ b.e.model_id ]
                    if d.length
                        for nl in [ d.length - 1 .. 0 ]
                            res.push 
                                o: b.o
                                e: d[ nl ]
                else
                    for nl in divisions[ b.e.model_id ]
                        res.push 
                            o: b.o
                            e: nl
            else
                res.push b
    
        @boundaries.clear()
        @boundaries.set res
            

    #    
    add_sub_element: ( res ) ->
        for b in @boundaries
            if b.e not in res
                res.push b.e
    