# 
class Element_BoundedSurf extends Element
    constructor: ( boundaries = [] ) ->
        super()
        
        @add_attr
            boundaries: boundaries   # list of { e: element ref, o: orientation }
        
    draw: ( info, mesh, proj, is_a_sub ) ->
        if mesh.visualization.display_style.get() in [ "Surface", "Surface with Edges" ]
            info.theme.surfaces.beg_ctx info

            info.theme.surfaces.draw info, =>
                for b, n in @boundaries 
                    b.e.contour info, mesh, proj, n == 0, b.o < 0
                    
            info.theme.surfaces.end_ctx info
            

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
    
    make_curve_line_from_selected: ( mesh, selected_points ) ->
        res = []
        waiting_points = []
        for b in @boundaries
            if b.e.point_in mesh, selected_points
                np = b.e.get_point_numbers()
                if b.o < 0
                    if np.length
                        for n in np[ np.length - 1 .. waiting_points.length > 0 ]
                            waiting_points.push n
                else
                    for n in np[ waiting_points.length > 0 ... ]
                        waiting_points.push n
            else
                if waiting_points.length >= 3
                    console.log waiting_points
                    res.push
                        o: 1
                        e: new Element_Arc waiting_points
                    waiting_points = []
                res.push b
    
        if waiting_points.length >= 3
            res.push
                o: 1
                e: new Element_Arc waiting_points
            waiting_points = []
            
        @boundaries.clear()
        @boundaries.set res
            