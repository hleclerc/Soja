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

#     #TODO 
#     _check_continuity: ( index ) ->
#         console.log index
#         return index
    
    make_curve_line_from_selected: ( mesh, selected_points ) ->
#         if selected_points?.length and mesh? and @boundaries?
#             np = []
#             for point in selected_points
#                 for b in @boundaries
#                     if b.e.point_in mesh, point
#                         np.push b.e.get_point_numbers()
#                         
#                 if np.length >= 2
#                     @make_curve_line np
#                 np = []
#                 
#                 
#     make_curve_line: ( index ) ->
#         console.log "-----"
#         console.log index
#         index = @_check_continuity index
#         res = []
#         waiting_points = []
#         
#         if index.length
#             for ind in index
#                 for i in ind
#                     waiting_points.push i
#             console.log waiting_points
#             
#             
#         if waiting_points.length >= 3
#             console.log waiting_points
#             res.push
#                 o: 1
#                 e: new Element_Arc waiting_points
#             waiting_points = []
#     
#         console.log @boundaries
#         @boundaries.push res
        
        
        res = []
        waiting_points = []
        for b in @boundaries
            if b.e.points_in mesh, selected_points
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
            
#         console.log res
        @boundaries.clear()
        @boundaries.set res
        
    break_line_from_selected: ( mesh, selected_points  ) ->
        waiting_points = []
        res = []
        for b in @boundaries
            if b.e.points_in mesh, selected_points
                waiting_points = b.e.get_point_numbers()
                console.log waiting_points
                if waiting_points.length >= 3
                    for ind in [ 0 ... waiting_points.length - 1 ]
                        res.push
                            o: 1
                            e: new Element_Line [ waiting_points[ ind ], waiting_points[ ind + 1 ] ]
                        console.log 'new line between : ', [ waiting_points[ ind ], waiting_points[ ind + 1 ] ]
                else
                    res.push b
            else
                res.push b
        console.log res
        @boundaries.clear()
        @boundaries.set res
    
#         for i in [ 0 ... @points.length ]
#             if @_selected.contains_ref @points[ i ]
#                 @break_line i
#     
#     break_line: ( index ) ->
#         if typeof index == "undefined"
#             return false
#         if @lines.length > 0
#             for i in [ @lines.length-1..0 ]
#                 if @lines[ i ].indexOf(index) != -1
#                     if @lines[ i ].length >= 3
#                         pos = @lines[ i ].indexOf index
#                         if pos > 0
#                             tmpLines = @lines[ i ].slice( 0, pos + 1 )
#                             @lines.push tmpLines
#                             @polygons[ 0 ].push @lines.length-1
# 
#                         l = @lines[ i ].length
#                         after = l - pos
#                         if after > 0
#                             #after pos
#                             tmpLines = @lines[ i ].slice( pos, l )
#                             @lines.push tmpLines
#                             @polygons[ 0 ].push @lines.length-1
#                          
#                         @lines.splice i, 1
#                         @polygons[ 0 ].splice i, 1
#                         @actualise_polygons -1, i