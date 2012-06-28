# This class is use to draw line/dot graph or bar chart
class Mesh extends Drawable
    constructor: ( params = {} ) ->
        super()
        
        @add_attr

            #
            visualization:
                display_style: new Choice( 0, [ "Points", "Wireframe", "Surface", "Surface with Edges" ] )
                point_edition: ( if not params.no_edition then true )
            
            # geometry
            points   : new Lst_Point # "add_point" can be used to fill the list
            _elements: [] # list of Element_Triangle, Element_Line, ...
            
            # helpers
            _selected_points: [] # point refs
            _pelected_points: [] # point refs
                
        # default move scheme
        @move_scheme = new MoveScheme_3D
        
        # cache
        @_sub_elements = [] # list of { sub_level: , elem_list: , on_skin: , parent }
        @_sub_date = -1
        
    # add a new node
    add_point: ( pos = [ 0, 0, 0 ] ) ->
        res = new Point pos, @move_scheme
        @points.push res
        return res
        
    # 
    add_element: ( element ) ->
        @_elements.push element

    nb_points: ->
        @points.length
        
    real_change: ->
        for a in [ @points, @_elements ]
            if a.real_change()
                return true
        false
        
    z_index: ->
        #         if @visualisation.display_field.lst?[ @visualisation.display_field.num.get() ]
        #             return @visualisation.display_field.lst[ @visualisation.display_field.num.get() ].z_index()
        #         else
        return 100

    draw: ( info ) ->
        # 2d screen projection
        proj = for p, i in @points
            info.re_2_sc.proj p.pos.get()

        # elements
        for el in @_elements
            el.draw info, this, proj

        # draw points if necessary
        if @visualization.display_style.equals( "Points" ) or @visualization.point_edition.get()
            info.theme.points.beg_ctx info
            for p in proj
                info.theme.points.draw_proj info, p

        # sub elements
        @_update_sub_elements()
        for el in @_sub_elements
            el.draw info, this, proj, true
            
        # selected items
        if @_selected_points.length
            info.theme.selected_points.beg_ctx info
            for p in @_selected_points
                n = info.re_2_sc.proj p.pos.get()
                info.theme.selected_points.draw_proj info, n
        
        # preselected items
        if @_pelected_points.length
            info.theme.highlighted_points.beg_ctx info
            for p in @_pelected_points
                n = info.re_2_sc.proj p.pos.get()
                info.theme.highlighted_points.draw_proj info, n
            
    
    on_mouse_down: ( cm, evt, pos, b, old, points_allowed = true ) ->
        delete @_moving_point
        if @visualization.point_edition.get()
            if b == "LEFT" or b == "RIGHT"
                if points_allowed
                    # preparation
                    proj = for p in @points
                        cm.cam_info.re_2_sc.proj p.pos.get()
                        
                    # closest point with dist < 10
                    best = @_closest_point_closer_than proj, pos, 10
                    if best >= 0
                        if evt.ctrlKey # add / rem selection
                            @_ctrlKey = true
                            if @_selected_points.toggle_ref @points[ best ]
                                @_moving_point = @points[ best ]
                                @_moving_point.beg_click pos
                        else
                            @_ctrlKey = false
                            if not @_selected_points.contains_ref @points[ best ]
                                @_selected_points.clear()
                                @_selected_points.set [ @points[ best ] ]
                            @_moving_point = @points[ best ]
                            @_moving_point.beg_click pos
                            
                        if b == "RIGHT"
                            return false
                        return true
                    else
                        @_pelected_points.clear()
                        
                    # something with elements ?
                    best = dist: 4
                    for el in @_elements
                        el.closest_point_closer_than? best, this, proj, cm.cam_info, pos
                    for el in @_sub_elements
                        el.closest_point_closer_than? best, this, proj, cm.cam_info, pos
                    if best.disp?
                        # _selected_points
                        np = @points.length
                        ip = @add_point best.disp
                        @_selected_points.clear()
                        @_selected_points.set [ ip ]
                        @_moving_point = ip
                        @_moving_point.beg_click pos
                        
                        # element div
                        res = []
                        divisions = {}
                        for el in @_elements
                            el.cut_with_point? divisions, best, this, np, ip
                            if divisions[ el.model_id ]?
                                for nl in divisions[ el.model_id ]
                                    res.push nl
                            else
                                res.push el
                        @_elements.clear()
                        @_elements.set res
                            
                        
                    
        return false
        
    on_mouse_up_wo_move: ( cm, evt, pos, b, points_allowed = true ) ->
        if @_moving_point? and not @_ctrlKey and @_selected_points.length > 1
            p = @_selected_points.back()
            @_selected_points.clear()
            @_selected_points.set [ p ]
            return true                    
            
    on_mouse_move: ( cm, evt, pos, b, old ) ->
        if @visualization.point_edition.get()
            # currently moving something ?
            if @_moving_point? and b == "LEFT"
                cm.undo_manager?.snapshot()
                    
                p_0 = cm.cam_info.sc_2_rw.pos pos[ 0 ], pos[ 1 ]
                d_0 = cm.cam_info.sc_2_rw.dir pos[ 0 ], pos[ 1 ]
                @_moving_point.move @_selected_points, @_moving_point.pos, p_0, d_0
                return true

            # preparation
            proj = for p in @points
                cm.cam_info.re_2_sc.proj p.pos.get()
                
            # pre selection of a particular point ?
            best = @_closest_point_closer_than proj, pos, 10
            if best >= 0
                @_pelected_points.clear()
                @_pelected_points.set [ @points[ best ] ]
                return true
                    
            # else, look in element lists
            best = dist: 4
            for el in @_elements
                el.closest_point_closer_than? best, this, proj, cm.cam_info, pos
            for el in @_sub_elements
                el.closest_point_closer_than? best, this, proj, cm.cam_info, pos
            if best.disp?
                @_pelected_points.clear()
                @_pelected_points.set [ new Point best.disp ]
                return true
                
        
        # nothing to pelect :P
        @_pelected_points.clear()
        return false
    
    
    update_min_max: ( x_min, x_max ) ->
        for m in @points
            p = m.pos.get()
            for d in [ 0 ... 3 ]
                x_min[ d ] = Math.min x_min[ d ], p[ d ]
                x_max[ d ] = Math.max x_max[ d ], p[ d ]
    
    make_curve_line_from_selected: ->
        index_selected_points = @_get_indices_of_selected_points()
        if index_selected_points != false
            for el in @_elements
                el.make_curve_line_from_selected index_selected_points

    break_line_from_selected: ->
        index_selected_points = @_get_indices_of_selected_points()
        if index_selected_points != false
            for el in @_elements
                el.break_line_from_selected index_selected_points
    
    delete_selected_point: ->
        index_selected_points = @_get_indices_of_selected_points()
    
        if index_selected_points.length
            # old indices -> new indices
            n_array = ( i for i in [ 0 ...  @points.length ] )
            for i in index_selected_points
                n_array[ i ] = -1
                for j in [ i + 1 ... @points.length ]
                    n_array[ j ] -= 1

            for ind_sel_point in index_selected_points
                # new elements
                for el in @_elements
                    el.rem_sub_element? ind_sel_point

            for ind in index_selected_points[ index_selected_points.length - 1 .. 0 ]
                p = @points[ ind ]
                @_selected_points.remove_ref p
                @_pelected_points.remove_ref p
                @points.splice ind, 1
            
            # new indices
            done = {}
            for el in @_elements
                el.update_indices? done, n_array

    #add "val" to all value in the array started at index "index" (use for ex when a point is deleted)
    _actualise_indices: ( array, val, index = 0 ) ->
        if array.length and val != 0 and index >= 0 and index <= array.length - 1
            for ind in array[ index ... array.length ]
                array[ ind ].set array[ ind ].get() + val
    
    _get_indices_of_selected_points: ->
        index_selected_points = []
        for point, j in @points
            for sel_point in @_selected_points
                if point == sel_point
                    index_selected_points.push j
        return index_selected_points
        
    _update_sub_elements: ->
        if @_sub_date < @_elements._date_last_modification
            @_sub_date = @_elements._date_last_modification
    
            @_sub_elements = []
            for el in @_elements
                el.add_sub_element? @_sub_elements
    
    _closest_point_closer_than: ( proj, pos, dist ) ->
        best = -1
        for p, n in proj
            d = Math.sqrt Math.pow( pos[ 0 ] - p[ 0 ], 2 ) + Math.pow( pos[ 1 ] - p[ 1 ], 2 )
            if dist > d
                dist = d
                best = n
        return best
        
    #     delete_selected_point: ( info ) ->
    #         for i in [ 0 ... @points.length ]
    #             if @_selected.contains_ref @points[ i ]
    #                 @delete_point i
    #     
    #     delete_point: ( index ) ->
    #         if typeof index == "undefined"
    #             return false
    #         unlinkedPoint = []
    #         #delete every line linked to the point
    #         if @lines.length > 0
    #             for i in [@lines.length-1..0]
    #                 if @lines[ i ].indexOf( index ) != -1
    #                     pos = @lines[ i ].indexOf( index )
    #                     if @lines[ i ].length == 2
    #                         unlinkedPoint.push(@lines[ i ][ 1 - pos ].get()) #get the point which is alone
    #                         @lines.splice i, 1
    #                         @polygons[ 0 ].splice i, 1
    #                         @actualise_polygons -1, i
    #                         
    #                     else if @lines[i].length >= 3
    #                         pos = []
    #                         #search for multiple occurrence of index in current line
    #                         #return an array of index
    #                         for j, k in @lines[i]
    #                             if j.get() == index
    #                                 pos.push k
    #                                 
    #                         for ind in pos
    #                             if ind != 1
    #                                 unlinkedPoint.push(@lines[i][1].get())
    #                             @lines[ i ].splice ind, 1
    #                             @polygons[ 0 ].splice ind, 1
    #                             @actualise_polygons -1, ind
    #                         
    #                         if @lines[i].length == 3
    #                             #check if it was a circle and the clicked point was not the point who appear twice
    #                             if @lines[ i ][ 0 ].get() == @lines[i][ 1 ].get() || @lines[i][ 0 ].get() == @lines[i][ 2 ].get()
    #                                 @lines[ i ].splice 0, 1
    #                                 @polygons[ 0 ].splice 0, 1
    #                                 @actualise_polygons -1, 0
    #                             else if @lines[i][ 1 ].get() == @lines[i][ 2 ].get()
    #                                 @lines[ i ].splice 1,1
    #                                 @polygons[ 0 ].splice 1, 1
    #                                 @actualise_polygons -1, 1
    # 
    #             #relink lonely point
    #             if unlinkedPoint.length > 0
    #                 for i in [0...unlinkedPoint.length-1]
    #                     #                 for j in [0...@lines.length]
    #                     #                     if @lines[j].indexOf(unlinkedPoint[i]) == -1 || @lines[j].indexOf(unlinkedPoint[i+1]) == -1 #  check if this line already exist or not
    #                     @lines.push [ unlinkedPoint[ i ], unlinkedPoint[ i + 1 ] ]
    #                     @polygons[ 0 ].push @lines.length-1
    #         
    #         #delete the point and change index of every line definition
    #         @points.splice index, 1
    #         for i in [ 0...@lines.length ]
    #             for j in [ 0...@lines[ i ].length ]
    #                 if @lines[ i ][ j ].get() >= index
    #                     @lines[ i ][ j ]._set( @lines[ i ][ j ].get() - 1 )

    #     break_line_from_selected: ( info ) ->
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

    #     make_curve_line_from_selected: ( info ) ->
    #         for i in [ 0 ... @points.length ]
    #             if @_selected.contains_ref @points[ i ]
    #                 @make_curve_line i
    
    #add "value" to all polygons data started at index "index" (use for ex when a line is deleted)
    #     actualise_polygons: ( val, index ) ->
    #         for polyg in @polygons
    #             for i in [ index ... polyg.length ]
    #                 polyg[ i ].set polyg[ i ].get() + val

    #     make_curve_line: ( index ) ->
    #         if typeof index == "undefined"
    #             return false
    #         if @lines.length > 0
    #             pointToJoin = []
    #             lineWithCurve = []
    #             for i in [ @lines.length-1..0 ]
    #                 if @lines[ i ].indexOf(index) != -1
    #                     pos = @lines[ i ].indexOf index
    #                     if @lines[ i ].length == 2
    #                         pointToJoin.push [ i, @lines[ i ][ 1 - pos ].get() ]
    #                     else
    #                         lineWithCurve.push [ i, pos ]
    #                         
    #             # case two segment
    #             if pointToJoin.length == 2
    #                 # delete two segment
    #                 for ind in [0...pointToJoin.length]
    #                     @lines.splice(pointToJoin[ ind ][ 0 ], 1)
    #                     @polygons[ 0 ].splice pointToJoin[ ind ][ 0 ], 1
    #                     @actualise_polygons -1, pointToJoin[ ind ][ 0 ]
    #                     
    #                 # make an arc with selectionned point on middle
    #                 @lines.push [ pointToJoin[ 0 ][ 1 ], index, pointToJoin[ 1 ][ 1 ] ]
    #                 @polygons[ 0 ].push @lines.length-1
    #                 
    #             # case one segment and one arc
    #             else if lineWithCurve.length == 1 && pointToJoin.length == 1
    #                     
    #                 # we need to know if the new point is on the begining of arc or at the end
    #                 pos = lineWithCurve[ 0 ][ 1 ]
    #                 lineNumber = lineWithCurve[ 0 ][ 0 ]
    #                 indexDel = pointToJoin[ 0 ][ 0 ]
    #             
    #                 if pos == 0
    #                     @lines[ lineNumber ].unshift pointToJoin[ 0 ][ 1 ]
    #                     @polygons[ 0 ].unshift 0
    #                     @actualise_polygons 1, 1
    #                 else
    #                     @lines[ lineNumber ].push pointToJoin[ 0 ][ 1 ]
    #                     @polygons[ 0 ].push @lines.length-1
    #                 
    #                 # delete segment
    #                 @lines.splice( indexDel, 1)
    #                 @polygons[ 0 ].splice indexDel, 1
    #                 @actualise_polygons -1, indexDel
    #                 #deletion is not actualised
    #                 
    #             # case two arc
    #             else if lineWithCurve.length == 2
    #                 newLine = []
    #                 #concat two arc
    #                 
    #                 lineNumber = lineWithCurve[ 0 ][ 0 ]
    #                 l = @lines[ lineNumber ].length
    #                 pos = lineWithCurve[ 0 ][ 1 ]
    #                 #check if we need to inverse array, for first line default is yes
    #                 if pos == (l-1)
    #                     for el, i in @lines[ lineNumber ]
    #                         newLine[ i ] = el
    #                     
    #                 else
    #                     for i in [0...@lines[ lineNumber ].length]
    #                         newLine[ (l-1)-i ] = @lines[ lineNumber ][ i ]
    #                 
    #                  #check if we need to inverse array, for first line default is no
    #                 lineNumber = lineWithCurve[ 1 ][ 0 ]
    #                 l = @lines[ lineNumber ].length
    #                 pos = lineWithCurve[ 1 ][ 1 ]
    #                 k = newLine.length - 1 # -1 prevent selected point to be in doublon
    #                 if pos == (l-1)
    #                     for i in [0...@lines[ lineNumber ].length]
    #                         newLine[ k + (l-1)-i ] = @lines[ lineNumber ][ i ]
    #                 else
    #                     for el, i in @lines[ lineNumber ]
    #                         newLine[ k + i ] = el
    #                 
    #                 #delete old arc
    #                 for ind, i in lineWithCurve[0]
    #                     @lines.splice(lineWithCurve[0][ ind ] - i, 1)
    #                     @polygons[ 0 ].splice lineWithCurve[0][ ind ] - i, 1
    #                     @actualise_polygons -1, lineWithCurve[0][ ind ] - i
    #                 @lines.push newLine
    #                 @polygons[ 0 ].push @lines.length-1
    #                 
            
    #     _draw_polygons: ( info, proj ) ->
    #         for polyg in @polygons.get()
    #             if polyg.length > 0
    #                 info.ctx.beginPath()
    #                 info.ctx.strokeStyle = "red"#info.theme.line_color.to_hex()
    #                 info.ctx.fillStyle   = "rgba(200,200,125,100)"#info.theme.line_color.to_hex()
    #                 
    #                 
    #                 first_point = @lines[ polyg[ 0 ] ][ 0 ]
    #                 
    #                 pos_first_point = proj[ first_point ]
    #                 info.ctx.moveTo( pos_first_point[ 0 ], pos_first_point[ 1 ] )
    #                 
    #                 for index_line in polyg
    #                     for i in [ 1 ...@lines[ index_line ].length ] # don't draw first point (because he is the same as the last line points)
    #                         p = @lines[ index_line ][ i ]
    #                         pos_p = proj[ p ]
    #                         if pos_p?
    #                             info.ctx.lineTo( pos_p[ 0 ], pos_p[ 1 ] )
    #                 # come back to first point
    #                 info.ctx.lineTo( pos_first_point[ 0 ], pos_first_point[ 1 ] )
    #                 
    #                 if @visualization.display_style.get() == "Wireframe"
    #                     info.ctx.fill()#only for debug
    #                     info.ctx.stroke()
    #                 else
    #                     info.ctx.fill()
    #                 info.ctx.closePath()

