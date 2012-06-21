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
            b.update_indices? done, n_array

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
    
    # function check if unlinked_points is an array containing 2 array, if so it concatenate every array and return it as an element
    _link_elements: ( unlinked_points ) ->
        if unlinked_points.length == 2 
            unlinked_point_lst = []
            for points in unlinked_points
                for p in points
                    unlinked_point_lst.push p
            #TODO, it always should be lines between 2 unlinked_points array
            console.log unlinked_point_lst
            if unlinked_point_lst.length == 2
                res =
                    o: 1
                    e: new Element_Line unlinked_point_lst
                return res
            if unlinked_point_lst.length >= 3
                res =
                    o: 1
                    e: new Element_Arc unlinked_point_lst
                return res
        return false
    
    
    #    
    rem_sub_element: ( selected_points ) ->
        if selected_points?.length and @boundaries?
            res = []
            unlinked_points = []
            for b, i in @boundaries
                waiting_points  = []
                if b.e.points_inside selected_points
                    waiting_points = b.e.get_point_numbers()
                    pos = waiting_points.indexOf selected_points[ 0 ]
                    #console.log waiting_points, pos
                    if waiting_points.length == 2
                        unlinked_points.push [ b.e.indices[ 1 - pos ] ] #get the point which is alone
                        new_res = @_link_elements unlinked_points
                        if new_res != false
                            res.push new_res
                            unlinked_points = []
                    else if waiting_points.length >= 3
                        bef = b.e.indices.slice 0, pos
                        aft = b.e.indices.slice pos + 1, b.e.indices.length
                        
                        if pos == 0
                            unlinked_points.push aft
                        else if pos == b.e.indices.length - 1
                            unlinked_points.push bef
                        new_res = @_link_elements unlinked_points
                        if new_res != false
                            res.push new_res
                            unlinked_points = []
                        
                        #link eventual points that were around deleted points
                        if ( waiting_points.length - 1 ) == 2
                            res.push
                                o: 1
                                e: new Element_Line bef.concat aft
                            
                        else if ( waiting_points.length - 1 ) >= 3
                            res.push
                                o: 1
                                e: new Element_Arc bef.concat aft
                                
                    else
                        res.push b
                else
                    res.push b
                
            @boundaries.clear()
            @boundaries.set res
                
                        
    #                 else if @lines[i].length >= 3
    #                     pos = []
    #                     #search for multiple occurrence of index in current line
    #                     #return an array of index
    #                     for j, k in @lines[i]
    #                         if j.get() == index
    #                             pos.push k
    #                             
    #                     for ind in pos
    #                         if ind != 1
    #                             unlinkedPoint.push(@lines[i][1].get())
    #                         @lines[ i ].splice ind, 1
    #                         @polygons[ 0 ].splice ind, 1
    #                         @actualise_polygons -1, ind
    #                     
    #                     if @lines[i].length == 3
    #                         #check if it was a circle and the clicked point was not the point who appear twice
    #                         if @lines[ i ][ 0 ].get() == @lines[i][ 1 ].get() || @lines[i][ 0 ].get() == @lines[i][ 2 ].get()
    #                             @lines[ i ].splice 0, 1
    #                             @polygons[ 0 ].splice 0, 1
    #                             @actualise_polygons -1, 0
    #                         else if @lines[i][ 1 ].get() == @lines[i][ 2 ].get()
    #                             @lines[ i ].splice 1,1
    #                             @polygons[ 0 ].splice 1, 1
    #                             @actualise_polygons -1, 1
                    
    
    make_curve_line_from_selected: ( selected_points ) ->
        if selected_points?.length and @boundaries?
            res = []
            waiting_points = []
            for b in @boundaries
                if b.e.points_inside selected_points
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
        
    break_line_from_selected: ( selected_points  ) ->
        #console.log selected_points
        if selected_points?.length and @boundaries?
            waiting_points = []
            res = []
            for b in @boundaries
                if b.e.points_inside selected_points
                    waiting_points = b.e.get_point_numbers()
                    #console.log waiting_points
                    if waiting_points.length >= 3
                        for sel in selected_points
                            pos = waiting_points.indexOf sel
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