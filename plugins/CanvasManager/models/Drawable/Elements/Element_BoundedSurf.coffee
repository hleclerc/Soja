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
            
    update_indices: ( done, n_array ) ->
        for b in @boundaries
            b.e.update_indices? done, n_array

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
            
            
    #     closest_point_closer_than: ( best, mesh, proj, info, pos ) ->
    #         # find 
    #     
    #         if @indices.length
    #             for i in [ 0 ... @indices.length - 1 ]
    #                 p0 = @indices[ i + 0 ].get()
    #                 p1 = @indices[ i + 1 ].get()
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
    #                         if best.dist >= dist
    #                             P0 = mesh.points[ p0 ].pos.get()
    #                             P1 = mesh.points[ p1 ].pos.get()
    #                             best.dist = dist
    #                             best.inst = this
    #                             best.indi = i
    #                             best.curv = r # curvilinear abscissa
    #                             best.disp = [
    #                                 P0[ 0 ] * ( 1 - r ) + P1[ 0 ] * r
    #                                 P0[ 1 ] * ( 1 - r ) + P1[ 1 ] * r
    #                                 P0[ 2 ] * ( 1 - r ) + P1[ 2 ] * r
    #                             ]

    #    
    add_sub_element: ( res ) ->
        for b in @boundaries
            if b.e not in res
                res.push b.e


    #    
    rem_sub_element: ( sel_point ) ->
        if @boundaries?
            res = []
            unlinked_points = []
            for b, i in @boundaries
                waiting_points  = []
                if sel_point in b.e.get_point_numbers()
                    waiting_points = b.e.get_point_numbers()
                    pos = waiting_points.indexOf sel_point
                    #console.log waiting_points, pos
                    if waiting_points.length == 2
                        unlinked_points.push b.e.indices[ 1 - pos ] #get the point which is alone
                        new_res = @_link_elements unlinked_points
                        if new_res != false
                            res.push new_res
                            unlinked_points = []
                    else if waiting_points.length >= 3
                        bef = b.e.indices.slice 0, pos
                        aft = b.e.indices.slice pos + 1, b.e.indices.length
                        
                        if pos == 0
                            unlinked_points.push aft[ 0 ].get()
                        else if pos == b.e.indices.length - 1
                            unlinked_points.push bef[ bef.length - 1 ].get()
                        new_res = @_link_elements unlinked_points
                        if new_res != false
                            res.push new_res
                            unlinked_points = []
                        
                        
                        #link eventual points that were around deleted points
                        if ( waiting_points.length - 1 ) == 2
                            res.push
                                o: 1
                                e: new Element_Line bef.get().concat aft.get()
                            
                        else if ( waiting_points.length - 1 ) >= 3
                            res.push
                                o: 1
                                e: new Element_Arc bef.get().concat aft.get()
                                
                    else
                        res.push b
                else
                    res.push b
            @boundaries.clear()
            @boundaries.set res
            
            
            
    make_curve_line_from_selected: ( sel_point ) ->
        if sel_point? and @boundaries?
            res = []
            waiting_points = []
            for b in @boundaries
                if sel_point in b.e.get_point_numbers()
                    np = b.e.get_point_numbers()
                    #console.log "np ", np
                    if b.o < 0
                        if np.length
                            for n in np[ np.length - 1 .. waiting_points.length > 0 ]
                                waiting_points.push n
                    else
                        # CASE first point is selected (and linked to last point in the shape)
                        if waiting_points.length and waiting_points[ 0 ] == np[ np.length - 1 ]
                            tmp_array = []
                            for n, i in np[ 0 ... np.length - 1 ]
                                tmp_array.push n
                            waiting_points = tmp_array.concat waiting_points
                            
                        else
                            for n in np[ waiting_points.length > 0 ... ]
                                waiting_points.push n
                        
                    #console.log "wait ", waiting_points
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
                
            #console.log res
            @boundaries.clear()
            @boundaries.set res
        
    break_line_from_selected: ( sel_point  ) ->
        if sel_point? and @boundaries?
            waiting_points = []
            res = []
            for b in @boundaries
                if sel_point in b.e.get_point_numbers()
                    waiting_points = b.e.get_point_numbers()
                    #console.log waiting_points
                    if waiting_points.length >= 3
                        pos = waiting_points.indexOf sel_point
                        #console.log pos
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
            #console.log res
            @boundaries.clear()
            @boundaries.set res
            

    # this function checks if unlinked_points is an array containing 2 array, if so it concatenate every array and return it as an element
    _link_elements: ( unlinked_points ) ->
        if unlinked_points.length == 2
            res =
                o: 1
                e: new Element_Line unlinked_points
            return res
        return false
            