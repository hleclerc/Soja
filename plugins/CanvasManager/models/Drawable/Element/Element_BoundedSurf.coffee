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

    
    make_curve_line_from_selected: ( selected_points ) ->
        if selected_points?.length and @boundaries?
            res = []
            waiting_points = []
            for b in @boundaries
                if b.e.points_inside selected_points
                    np = b.e.get_point_numbers()
                    if b.o < 0
                        if np.length
                            for n in np[ np.length - 1 .. waiting_points.length > 0 ]
                                waiting_points.push n
                    else
                        # CASE first point is selected (and linked to last point in the shape)
                        if waiting_points.length and waiting_points[ 0 ] == np[ np.length - 1 ]
                            waiting_points.unshift np[ 0 ] 
                        else
                            for n in np[ waiting_points.length > 0 ... ]
                                waiting_points.push n
                else
                    if waiting_points.length >= 3
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
        
    break_line_from_selected: ( selected_points  ) ->
        if selected_points?.length and @boundaries?
            waiting_points = []
            res = []
            for b in @boundaries
                if b.e.points_inside selected_points
                    waiting_points = b.e.get_point_numbers()
                    if waiting_points.length >= 3
                        for sel in selected_points
                            pos = waiting_points.indexOf sel
                            if pos != -1
                                if pos == 1
                                    res.push
                                        o: 1
                                        e: new Element_Line waiting_points.slice 0, pos + 1

                                if pos >= 2
                                    res.push
                                        o: 1
                                        e: new Element_Arc waiting_points.slice 0 , pos + 1

                                l = waiting_points.length - 1
                                after = l - pos
                                if after == 1
                                    #after pos
                                    res.push
                                        o: 1
                                        e: new Element_Line waiting_points.slice pos, l + 1
                                if after >= 2
                                    res.push
                                        o: 1
                                        e: new Element_Arc waiting_points.slice pos, l + 1
                    else
                        res.push b
                else
                    res.push b
            @boundaries.clear()
            @boundaries.set res