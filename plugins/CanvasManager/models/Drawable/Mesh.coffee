# This class is use to draw line/dot graph or bar chart
class Mesh extends Drawable
    constructor: ( params = {} ) ->
        super()
        
        @add_attr
            #
            visualization:
                display_style: new Choice( 0, [ "Points", "Wireframe", "Surface", "Surface with Edges" ] )
                point_edition: true
            
            # geometry
            points  : new Lst_Point # "add_point" can be used to fill the list
            elements: [] # list of ElementList
            _sub_elt: [] # list of { sub_level: , elem_list: , on_skin: , parent }
            
            # helpers
            _selected_points: [] # indices of selected points / lines / ...
            _pelected_points: [] # indices of selected points / lines / ...
                
        # default move scheme
        @move_scheme = new MoveScheme_3D
        
        
    # add a new node
    add_point: ( pos = [ 0, 0, 0 ] ) ->
        @points.push new Point pos, @move_scheme
        
    # e.g. "Triangle", [ 0, 10, 1 ] ( "ElementList_#{type}" must be a valid object type
    # BEWARE: update_sub_elt() must be called after each element addition / removal
    add_element: ( type, con ) ->
        l = undefined
        for el in @elements
            if el.element_type() == type
                return el.add_element con
        eval "var el = new ElementList_#{type};"
        @elements.push el
        el.add_element con
        
    update_sub_elt: ->
    
    
    real_change: ->
        for a in [ @points, @elements ]
            if a.real_change()
                return true
        false
        
    z_index: ->
        return 100

    draw: ( info, params = {} ) ->
        if @points.length == 0
            return
        
        # apply warp_factor deformation to points
        proj = for p, i in @points
                info.re_2_sc.proj p.pos.get()

        #
        if @visualization.display_style.equals( "Points" ) or @visualization.point_edition.get()
            @_draw_points info, proj
                
        for el in @elements
            el.draw info, this, proj
                
        #         info.ctx.lineWidth = 1
        #         info.ctx.fillStyle = "#FFFFFF"
        #         info.ctx.strokeStyle = info.theme.line_color.to_hex()
        #         
        #         display = @visualization.displayed_style.get()
        #         
        #         #@_draw_polygons info, proj
        #         
        #         # call adapted draw function for color and using gradient
        #         if @visualization.displayed_field.lst.length
        #             selected_field = @visualization.displayed_field.lst[ @visualization.displayed_field.num.get() ]
        #             
        #             if selected_field instanceof VectorialField
        #                 # Preparation of value field by selecting each value of fields at an index
        #                 value = []
        #                 for p, ind in @points
        #                     element = selected_field.get_value_of_fields_at_index ind
        #                     val = 0
        #                     for el in element.get()
        #                         val += el * el
        #                     
        #                     value.push Math.sqrt val
        #                 
        #                 # Warp is use to multiply
        #                 if @visualization.warp_by.lst[ @visualization.warp_by.num ] != undefined and @visualization.warp_factor.get() != 0
        #                     field_data = @visualization.warp_by.get()
        #                     warp_factor = @visualization.warp_factor.get()
        #                 else
        #                     warp_factor = 1
        #                     
        #                 @actualise_value_legend value
        #                 selected_field.draw info, @visualization.displayed_style.get(), @points, value, warp_factor, @visualization.legend
        #             else # nodal and elementary fields
        #                 @actualise_value_legend selected_field.get()
        #                 selected_field.draw info, @visualization.displayed_style.get(), @triangles, proj, @visualization.legend
        #         
        #         # when mesh is not an element fields nor a nodal fields
        #         else
        #             if display == "Wireframe" or display == "Surface with Edges" or display == "Edges"
        #                 @_draw_edges info, proj
        #                 
        #         if display == "Points" or @editable_points.get() == true
        #             @_draw_points info, proj, selected
    
    anim_min_max: ->
        f = @visualization.displayed_field.get() 
        if f?
            f.anim_min_max()
        else
            0
    
    on_mouse_down: ( cm, evt, pos, b, old, points_allowed = true ) ->
        delete @_moving_point
        if @visualization.point_edition.get()
            if b == "LEFT" or b == "RIGHT"
                if points_allowed
                    # we will need proj
                    proj = for p in @points
                        cm.cam_info.re_2_sc.proj p.pos.get()
                        
                    # a point that can be moved ?
                    res = @_points_closer_than proj, pos, 10
                    if res.length
                        res.sort ( a, b ) -> b.dist - a.dist
                        
                        if evt.ctrlKey # add / rem selection
                            @_ctrlKey = true
                            if @_selected_points.toggle res[ 0 ].num
                                @_moving_point = res[ 0 ].inst
                                @_moving_point.beg_click pos
                        else
                            @_ctrlKey = false
                            if not @_selected_points.contains res[ 0 ].num
                                @_selected_points.push res[ 0 ].num
                            @_moving_point = res[ 0 ].inst
                            @_moving_point.beg_click pos
                            
                        if b == "RIGHT"
                            return false
                        return true
                    else
                        @_pelected_points.clear()
                        
                    # something with elements ?
                    for el in @elements
                        if el.on_mouse_down_point_edition? this, proj, cm, evt, pos, b, old
                            return true
                    
                    
        return false
        
    on_mouse_up_wo_move: ( cm, evt, pos, b, points_allowed = true ) ->
        if @_moving_point? and not @_ctrlKey
            @_selected_points.set [ @_selected_points.back() ]
            return true
                    
    on_mouse_move: ( cm, evt, pos, b, old ) ->
        if @visualization.point_edition.get()
            # currently moving something ?
            if @_moving_point? and b == "LEFT"
                cm.undo_manager?.snapshot()
                    
                p_0 = cm.cam_info.sc_2_rw.pos pos[ 0 ], pos[ 1 ]
                d_0 = cm.cam_info.sc_2_rw.dir pos[ 0 ], pos[ 1 ]
                selected_points = ( @points[ i.get() ] for i in @_selected_points )
                @_moving_point.move selected_points, @_moving_point.pos, p_0, d_0
                return true

            # else, we will need proj
            proj = for p in @points
                cm.cam_info.re_2_sc.proj p.pos.get()
                
            # pre selection of a particular point ?
            res = @_points_closer_than proj, pos, 10
            if res.length
                for el in @elements
                    el.rem_pelected?()
                res.sort ( a, b ) -> b.dist - a.dist
                @_pelected_points.set [ res[ 0 ].num ]
                return true
            else
                @_pelected_points.clear()
                
            # else, look in element lists
            for el in @elements
                if el.on_mouse_move_point_edition? this, proj, cm, evt, pos, b, old
                    return true
        
        return false
    

    delete_selected_point: ( info ) ->
        for i in [ 0 ... @points.length ]
            if @_selected.contains_ref @points[ i ]
                @delete_point i
    
    delete_point: ( index ) ->
        if typeof index == "undefined"
            return false
        unlinkedPoint = []
        #delete every line linked to the point
        if @lines.length > 0
            for i in [@lines.length-1..0]
                if @lines[ i ].indexOf( index ) != -1
                    pos = @lines[ i ].indexOf( index )
                    if @lines[ i ].length == 2
                        unlinkedPoint.push(@lines[ i ][ 1 - pos ].get()) #get the point which is alone
                        @lines.splice i, 1
                        @polygons[ 0 ].splice i, 1
                        @actualise_polygons -1, i
                        
                    else if @lines[i].length >= 3
                        pos = []
                        #search for multiple occurrence of index in current line
                        #return an array of index
                        for j, k in @lines[i]
                            if j.get() == index
                                pos.push k
                                
                        for ind in pos
                            if ind != 1
                                unlinkedPoint.push(@lines[i][1].get())
                            @lines[ i ].splice ind, 1
                            @polygons[ 0 ].splice ind, 1
                            @actualise_polygons -1, ind
                        
                        if @lines[i].length == 3
                            #check if it was a circle and the clicked point was not the point who appear twice
                            if @lines[ i ][ 0 ].get() == @lines[i][ 1 ].get() || @lines[i][ 0 ].get() == @lines[i][ 2 ].get()
                                @lines[ i ].splice 0, 1
                                @polygons[ 0 ].splice 0, 1
                                @actualise_polygons -1, 0
                            else if @lines[i][ 1 ].get() == @lines[i][ 2 ].get()
                                @lines[ i ].splice 1,1
                                @polygons[ 0 ].splice 1, 1
                                @actualise_polygons -1, 1

            #relink lonely point
            if unlinkedPoint.length > 0
                for i in [0...unlinkedPoint.length-1]
                    #                 for j in [0...@lines.length]
                    #                     if @lines[j].indexOf(unlinkedPoint[i]) == -1 || @lines[j].indexOf(unlinkedPoint[i+1]) == -1 #  check if this line already exist or not
                    @lines.push [ unlinkedPoint[ i ], unlinkedPoint[ i + 1 ] ]
                    @polygons[ 0 ].push @lines.length-1
        
        #delete the point and change index of every line definition
        @points.splice index, 1
        for i in [ 0...@lines.length ]
            for j in [ 0...@lines[ i ].length ]
                if @lines[ i ][ j ].get() >= index
                    @lines[ i ][ j ]._set( @lines[ i ][ j ].get() - 1 )

    break_line_from_selected: ( info ) ->
        for i in [ 0 ... @points.length ]
            if @_selected.contains_ref @points[ i ]
                @break_line i
    
    break_line: ( index ) ->
        if typeof index == "undefined"
            return false
        if @lines.length > 0
            for i in [ @lines.length-1..0 ]
                if @lines[ i ].indexOf(index) != -1
                    if @lines[ i ].length >= 3
                        pos = @lines[ i ].indexOf index
                        if pos > 0
                            tmpLines = @lines[ i ].slice( 0, pos + 1 )
                            @lines.push tmpLines
                            @polygons[ 0 ].push @lines.length-1

                        l = @lines[ i ].length
                        after = l - pos
                        if after > 0
                            #after pos
                            tmpLines = @lines[ i ].slice( pos, l )
                            @lines.push tmpLines
                            @polygons[ 0 ].push @lines.length-1
                         
                        @lines.splice i, 1
                        @polygons[ 0 ].splice i, 1
                        @actualise_polygons -1, i

    make_curve_line_from_selected: ( info ) ->
        for i in [ 0 ... @points.length ]
            if @_selected.contains_ref @points[ i ]
                @make_curve_line i
    
    #add "value" to all polygons data started at index "index" (use for ex when a line is deleted)
    actualise_polygons: ( val, index ) ->
        for polyg in @polygons
            for i in [ index ... polyg.length ]
                polyg[ i ].set polyg[ i ].get() + val

    make_curve_line: ( index ) ->
        if typeof index == "undefined"
            return false
        if @lines.length > 0
            pointToJoin = []
            lineWithCurve = []
            for i in [ @lines.length-1..0 ]
                if @lines[ i ].indexOf(index) != -1
                    pos = @lines[ i ].indexOf index
                    if @lines[ i ].length == 2
                        pointToJoin.push [ i, @lines[ i ][ 1 - pos ].get() ]
                    else
                        lineWithCurve.push [ i, pos ]
                        
            # case two segment
            if pointToJoin.length == 2
                # delete two segment
                for ind in [0...pointToJoin.length]
                    @lines.splice(pointToJoin[ ind ][ 0 ], 1)
                    @polygons[ 0 ].splice pointToJoin[ ind ][ 0 ], 1
                    @actualise_polygons -1, pointToJoin[ ind ][ 0 ]
                    
                # make an arc with selectionned point on middle
                @lines.push [ pointToJoin[ 0 ][ 1 ], index, pointToJoin[ 1 ][ 1 ] ]
                @polygons[ 0 ].push @lines.length-1
                
            # case one segment and one arc
            else if lineWithCurve.length == 1 && pointToJoin.length == 1
                    
                # we need to know if the new point is on the begining of arc or at the end
                pos = lineWithCurve[ 0 ][ 1 ]
                lineNumber = lineWithCurve[ 0 ][ 0 ]
                indexDel = pointToJoin[ 0 ][ 0 ]
            
                if pos == 0
                    @lines[ lineNumber ].unshift pointToJoin[ 0 ][ 1 ]
                    @polygons[ 0 ].unshift 0
                    @actualise_polygons 1, 1
                else
                    @lines[ lineNumber ].push pointToJoin[ 0 ][ 1 ]
                    @polygons[ 0 ].push @lines.length-1
                
                # delete segment
                @lines.splice( indexDel, 1)
                @polygons[ 0 ].splice indexDel, 1
                @actualise_polygons -1, indexDel
                #deletion is not actualised
                
            # case two arc
            else if lineWithCurve.length == 2
                newLine = []
                #concat two arc
                
                lineNumber = lineWithCurve[ 0 ][ 0 ]
                l = @lines[ lineNumber ].length
                pos = lineWithCurve[ 0 ][ 1 ]
                #check if we need to inverse array, for first line default is yes
                if pos == (l-1)
                    for el, i in @lines[ lineNumber ]
                        newLine[ i ] = el
                    
                else
                    for i in [0...@lines[ lineNumber ].length]
                        newLine[ (l-1)-i ] = @lines[ lineNumber ][ i ]
                
                 #check if we need to inverse array, for first line default is no
                lineNumber = lineWithCurve[ 1 ][ 0 ]
                l = @lines[ lineNumber ].length
                pos = lineWithCurve[ 1 ][ 1 ]
                k = newLine.length - 1 # -1 prevent selected point to be in doublon
                if pos == (l-1)
                    for i in [0...@lines[ lineNumber ].length]
                        newLine[ k + (l-1)-i ] = @lines[ lineNumber ][ i ]
                else
                    for el, i in @lines[ lineNumber ]
                        newLine[ k + i ] = el
                
                #delete old arc
                for ind, i in lineWithCurve[0]
                    @lines.splice(lineWithCurve[0][ ind ] - i, 1)
                    @polygons[ 0 ].splice lineWithCurve[0][ ind ] - i, 1
                    @actualise_polygons -1, lineWithCurve[0][ ind ] - i
                @lines.push newLine
                @polygons[ 0 ].push @lines.length-1
                
    update_min_max: ( x_min, x_max ) ->
        for m in @points
            p = m.pos.get()
            for d in [ 0 ... 3 ]
                x_min[ d ] = Math.min x_min[ d ], p[ d ]
                x_max[ d ] = Math.max x_max[ d ], p[ d ]


    _points_closer_than: ( proj, pos, m ) ->
        res = []
        for p, n in proj
            dx = pos[ 0 ] - p[ 0 ]
            dy = pos[ 1 ] - p[ 1 ]
            d = Math.sqrt dx * dx + dy * dy
            if d <= m
                res.push
                    inst: @points[ n ]
                    dist: d
                    num : n
        return res
                
    _draw_points: ( info, proj ) ->
        # draw all the points
        info.theme.points.prep_ctx info
        for p in proj
            info.theme.points.draw_proj info, p
        
        # draw point that are under the mouse pointer
        if @_selected_points.length
            info.theme.selected_points.prep_ctx info
            for i in @_selected_points
                info.theme.selected_points.draw_proj info, proj[ i.get() ]
        
        # draw point that are under the mouse pointer
        if @_pelected_points.length
            info.theme.highlighted_points.prep_ctx info
            for i in @_pelected_points
                info.theme.highlighted_points.draw_proj info, proj[ i.get() ]
            
    _draw_polygons: ( info, proj ) ->
        for polyg in @polygons.get()
            if polyg.length > 0
                info.ctx.beginPath()
                info.ctx.strokeStyle = "red"#info.theme.line_color.to_hex()
                info.ctx.fillStyle   = "rgba(200,200,125,100)"#info.theme.line_color.to_hex()
                
                
                first_point = @lines[ polyg[ 0 ] ][ 0 ]
                
                pos_first_point = proj[ first_point ]
                info.ctx.moveTo( pos_first_point[ 0 ], pos_first_point[ 1 ] )
                
                for index_line in polyg
                    for i in [ 1 ...@lines[ index_line ].length ] # don't draw first point (because he is the same as the last line points)
                        p = @lines[ index_line ][ i ]
                        pos_p = proj[ p ]
                        if pos_p?
                            info.ctx.lineTo( pos_p[ 0 ], pos_p[ 1 ] )
                # come back to first point
                info.ctx.lineTo( pos_first_point[ 0 ], pos_first_point[ 1 ] )
                
                if @visualization.displayed_style.get() == "Wireframe"
                    info.ctx.fill()#only for debug
                    info.ctx.stroke()
                else
                    info.ctx.fill()
                info.ctx.closePath()

