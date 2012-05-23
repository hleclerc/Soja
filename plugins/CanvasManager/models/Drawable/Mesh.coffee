# This class is use to draw line/dot graph or bar chart
# params available :
# _pre_sele_color
# _selected_color
class Mesh extends Drawable
    constructor: ( legend = null, params = {} ) ->
        super()
        
        
        @add_attr
            _field           : new Lst
            displayed_field  : new Choice( 0, [] )
            displayed_style  : new Choice( 0, [] )
            warp_by          : new Choice( 0, [] )
            # display parms
            #             displayed_field  : new Choice( 0, [ "elementary", "nodal" ] )
            #             display_style    : new Choice( 0, [ "wireframe", "surface" ] )
            #             warp_by          : new Choice( 0, [ "none" ] )
            warp_factor      : 1
            
            # geometry
            points           : new Lst_Point # "add_point" can be used to fill the list
            lines            : new Lst
            triangles        : new Lst
            polygons         : new Lst
            
            # fields
            elementary_fields: new Model # { field_name: values, ... }
            nodal_fields     : new Model # { field_name: values, ... }
            
            # behavior
            _selected        : new Lst # references of selected points / lines / ...
            _pre_sele        : new Lst # references of selected points / lines / ...
            _selected_color  : new Color 255,   0,   0
            _pre_sele_color  : new Color 255, 255, 100
            
        
            
        for key, val of params
            this[ key ]?.set? val
            
        if legend? and legend instanceof Legend
            @add_attr
                _legend: legend
        else
            @add_attr
                _legend: new Legend ""
                
        # default move scheme
        @move_scheme = MoveScheme_3D
            
    
    #
    add_point: ( pos = [ 0, 0, 0 ] ) ->
        @points.push new Point pos, @move_scheme
    
    z_index: ->
        return 100

    points_have_to_be_drawn: ( info ) ->
        info.sel_item[ @model_id ]

    draw: ( info, params = {} ) ->
        if @points.length == 0
            return
            
        # preparation
        selected = {}
        for item in @_selected
            selected[ item.model_id ] = true
        
        proj = for p, i in @points
#             if @warp_by.get()
                #TODO @warp_by.get() must be use to choose between nodal_fields or elementary_fields
#                 v = Vec_3.add @nodal_fields[ @displayed_field.get() ][ i ].get(), @warp_factor.get() * @nodal_fields[ @displayed_field.get() ][ i ].get()
            info.re_2_sc.proj p.pos.get()
        
        # 
        color_line = info.theme.line.to_hex()
        
        info.ctx.lineWidth = 1
        info.ctx.fillStyle = "#FFFFFF"
        info.ctx.strokeStyle = color_line

        # draw points
        if @points_have_to_be_drawn info
            color_selected_dot = info.theme.selected_dot.to_hex()
            color_dot          = info.theme.dot.to_hex()
            for n in [ 0 ... proj.length ]
                if selected[ @points[ n ].model_id ]?
                    info.ctx.fillStyle = color_selected_dot
                else
                    info.ctx.fillStyle = color_dot
                
                p = proj[ n ]
                info.ctx.beginPath()
                info.ctx.arc p[ 0 ], p[ 1 ], 4, 0, Math.PI * 2, true
                info.ctx.fill()
                info.ctx.stroke()
            
        # draw lines
        for l, j in @lines when l.length == 2
            info.ctx.beginPath()
            info.ctx.moveTo proj[ l[ 0 ].get() ][ 0 ], proj[ l[ 0 ].get() ][ 1 ]
            info.ctx.lineTo proj[ l[ 1 ].get() ][ 0 ], proj[ l[ 1 ].get() ][ 1 ]
            info.ctx.stroke()

        # draw arcs
        for l in @lines when l.length == 3
            P0 = @points[ l[ 0 ].get() ].pos.get()
            P1 = @points[ l[ 1 ].get() ].pos.get()
            P2 = @points[ l[ 2 ].get() ].pos.get()
            @_disp_arc info, P0, P1, P2
            
        # draw arcs n points
        for l in @lines when l.length > 3
            point =  for p in l
                @points[ p.get() ].pos.get()
            @_disp_arc_n_points info, point
            
#         for polyg in @polygons
#             @_draw_polygon info, polyg.get(), proj
        
        # call adapted draw function for color and using gradient
        if @nodal_fields[ @displayed_field.get() ]?
            values = @nodal_fields[ @displayed_field.get() ].get()
            @actualise_value_legend values
            
            for tri in @triangles
                @_draw_nodal_triangle info, tri.get(), proj, values
                
        else if @elementary_fields[ @displayed_field.get() ]?
            values = @elementary_fields[ @displayed_field.get() ].get()
            @actualise_value_legend values
            
            for tri, i in @triangles
                @_draw_elementary_triangle info, tri.get(), proj, values[ i ]

        # pre selected items
        if @_pre_sele.length
            info.ctx.strokeStyle = @_pre_sele_color.to_hex()
            info.ctx.lineWidth = 1.5
            for item in @_pre_sele when item instanceof Point
                p = info.re_2_sc.proj item.pos.get()
                
                info.ctx.beginPath()
                info.ctx.arc p[ 0 ], p[ 1 ], 5, 0, Math.PI * 2, true
                info.ctx.stroke()
            for l in @_pre_sele when item not instanceof Point
                if l.length == 2
                    info.ctx.lineWidth = 2
                    info.ctx.beginPath()
                    info.ctx.moveTo proj[ l[ 0 ].get() ][ 0 ], proj[ l[ 0 ].get() ][ 1 ]
                    info.ctx.lineTo proj[ l[ 1 ].get() ][ 0 ], proj[ l[ 1 ].get() ][ 1 ]
                    info.ctx.stroke()
                
    _draw_polygon: ( info, polyg, proj ) ->
        if polyg.length > 0
            info.ctx.beginPath()
            info.ctx.strokeStyle = info.theme.line.to_hex()
            info.ctx.fillStyle   = info.theme.line.to_hex()
            
            first_point = polyg[ 0 ]
            pos_first_point = proj[ first_point ]
            info.ctx.moveTo( pos_first_point[ 0 ], pos_first_point[ 1 ] )
            
            for line in polyg
                pos_p = proj[ line ]
                if pos_p?
                    info.ctx.lineTo( pos_p[ 0 ], pos_p[ 1 ] )
            # come back to first point
            info.ctx.lineTo( pos_first_point[ 0 ], pos_first_point[ 1 ] )
            
            if @display_style.get() == "wireframe"
                info.ctx.stroke()
            else
                info.ctx.fill()
            info.ctx.closePath()
    
    
    on_mouse_down: ( cm, evt, pos, b ) ->
        delete @_movable_entity
        
        if b == "LEFT" or b == "RIGHT"
            # look if there's a movable point under mouse
            for phase in [ 0 ... 3 ]
                # closest entity under mouse
                res = []
                @get_movable_entities res, cm.cam_info, pos, phase
                if res.length
                    res.sort ( a, b ) -> b.dist - a.dist
                    @_movable_entity = res[ 0 ].item
                    @_may_need_snapshot = true
                    @_pre_sele.clear()
                    
                    if evt.ctrlKey # add / rem selection
                        @_selected.toggle_ref @_movable_entity
                        if not @_selected.contains_ref @_movable_entity
                            delete @_movable_entity
                    else
                        @_selected.clear()
                        @_selected.push @_movable_entity
                        @_movable_entity.beg_click pos
                        
                    if b == "RIGHT"
                        return false
                        
                    return true
                    
        return false
                    
    on_mouse_move: ( cm, evt, pos, b, old ) ->
        if b == "LEFT" and @_movable_entity?
            if @_may_need_snapshot
                cm.undo_manager?.snapshot()
                delete @_may_need_snapshot
                
            p_0 = cm.cam_info.sc_2_rw.pos pos[ 0 ], pos[ 1 ]
            d_0 = cm.cam_info.sc_2_rw.dir pos[ 0 ], pos[ 1 ]
            @_movable_entity.mov_click @_selected, @_movable_entity.pos, p_0, d_0
            
            return true

        # pre selection
        for phase in [ 0 ... 3 ]
            res = []
            @get_movable_entities res, cm.cam_info, pos, phase, true
            if res.length
                res.sort ( a, b ) -> b.dist - a.dist
                if @_pre_sele.length != 1 or @_pre_sele[ 0 ] != res[ 0 ].item
                    @_pre_sele.clear()
                    @_pre_sele.push res[ 0 ].item
                break
            else if @_pre_sele.length
                @_pre_sele.clear()
    
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
                if @lines[i].indexOf(index) != -1
                    pos = @lines[i].indexOf(index)
                    if @lines[i].length == 2
                        unlinkedPoint.push(@lines[i][1-pos].get()) #get the point which is alone
                        @lines.splice(i,1)
                        
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
                            @lines[i].splice(ind,1)
                        
                        if @lines[i].length == 3
                            #check if it was a circle and the clicked point was not the point who appear twice
                            if @lines[i][ 0 ].get() == @lines[i][ 1 ].get() || @lines[i][ 0 ].get() == @lines[i][ 2 ].get()
                                @lines[i].splice(0,1)
                            else if @lines[i][ 1 ].get() == @lines[i][ 2 ].get()
                                @lines[i].splice(1,1)

            #relink lonely point
            if unlinkedPoint.length > 0
                for i in [0...unlinkedPoint.length-1]
                    #                 for j in [0...@lines.length]
                    #                     if @lines[j].indexOf(unlinkedPoint[i]) == -1 || @lines[j].indexOf(unlinkedPoint[i+1]) == -1 #  check if this line already exist or not
                    @lines.push [ unlinkedPoint[ i ], unlinkedPoint[ i + 1 ] ]
        
        #delete the point and change index of every line definition
        @points.splice( index, 1 )
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

                        l = @lines[ i ].length
                        after = l - pos
                        if after > 0
                            #after pos
                            tmpLines = @lines[ i ].slice( pos, l )
                            @lines.push tmpLines
                         
                        @lines.splice( i , 1 )

    make_curve_line_from_selected: ( info ) ->
        for i in [ 0 ... @points.length ]
            if @_selected.contains_ref @points[ i ]
                @make_curve_line i

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
                    
                # make an arc with selectionned point on middle
                @lines.push [ pointToJoin[ 0 ][ 1 ], index, pointToJoin[ 1 ][ 1 ] ]

            # case one segment and one arc
            else if lineWithCurve.length == 1 && pointToJoin.length == 1
                    
                # we need to know if the new point is on the begining of arc or at the end
                pos = lineWithCurve[ 0 ][ 1 ]
                lineNumber = lineWithCurve[ 0 ][ 0 ]
                indexDel = pointToJoin[ 0 ][ 0 ]
            
                if pos == 0
                    @lines[ lineNumber ].unshift pointToJoin[ 0 ][ 1 ]
                else
                    @lines[ lineNumber ].push pointToJoin[ 0 ][ 1 ]
                
                # delete segment
                @lines.splice( indexDel, 1)
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
                @lines.push newLine


    get_movable_entities: ( res, info, pos, phase, dry = false ) ->
        x = pos[ 0 ]
        y = pos[ 1 ]
        
        if phase == 0
            for p in @points
                proj = info.re_2_sc.proj p.pos.get()
                dx = x - proj[ 0 ]
                dy = y - proj[ 1 ]
                d = Math.sqrt dx * dx + dy * dy
                if d <= 10
                    res.push
                        prov: this
                        item: p
                        dist: d

        if phase == 1
            proj = for p in @points
                info.re_2_sc.proj p.pos.get()
                
            for li in @lines when li.length == 2
                P0 = li[ 0 ].get()
                P1 = li[ 1 ].get()
                
                point = @_get_line_inter proj, P0, P1, x, y
                if point?
                    P = [
                        @points[ P0 ].pos[ 0 ].get() + point[ 0 ] * point[ 3 ],
                        @points[ P0 ].pos[ 1 ].get() + point[ 1 ] * point[ 3 ],
                        @points[ P0 ].pos[ 2 ].get() + point[ 2 ] * point[ 3 ]
                    ]
                
                    if dry
                        res.push 
                            prov: this
#                             item: new Point P
                            item: [ li, @points[ P0 ], @points[ P1 ] ]
                            dist: 0
                    else
                        os = @points.length

                        @add_point P
                            
                        n = @points[ @points.length-1 ]
                        ol = P1
                        li[ 1 ].set os
                        @lines.push [ os, ol ]
                        
                        res.push
                            prov: this
                            item: n
                            dist: 0
                            type: "Mesh"
                            
                        break

        #         if phase == 2
        #             proj = for p in @points
        #                 info.re_2_sc.proj p.pos.get()
        #             for li in @lines 
        #                 if li.length > 2
        #                     # TODO P0 and P1 should be indices and not value
        #                     #                     res = for i in [ 0 ... li.length - 2 ]
        #                     #                         @_get_center_radius proj[ li[ i ] ], proj[ li[ i + 1 ] ], proj[ li[ i + 2 ] ]
        #                     #                             
        #                     #                     p = info.re_2_sc.proj li[ 0 ]
        #                     # #                     console.log p
        #                     # #                     info.ctx.moveTo p[ 0 ], p[ 1 ]
        #                     #                     
        #                     #                     for n in [ 1 .. 30 ]
        #                     #                         alpha = n / 30.0
        #                     #                         ar = res[ 0 ].a[ 0 ] + ( res[ 0 ].a[ 1 ] - res[ 0 ].a[ 0 ] ) * alpha
        #                     #                         pr = @_get_proj_arc info, res[ 0 ], ar
        #                     #                         P0 =  pr[ 0 ]
        #                     #                         P1 =  pr[ 1 ]
        #                     #                         
        #                     #                         console.log "----"
        #                     #                         console.log ar
        #                     #                         console.log pr
        #                     #                         console.log res
        # 
        #                 
        #                     for l,i in li[ 0 ...li.length - 1]
        #                         P0 = li[ i ].get()
        #                         P1 = li[ i + 1 ].get()
        #                         
        #                         point = @_get_line_inter proj, P0, P1, x, y
        #                         
        #                         if point?
        #                             os = @points.length
        #                             
        #                             @add_point [@points[ P0 ].pos[ 0 ].get() + point[ 0 ] * point[ 3 ],
        #                                 @points[ P0 ].pos[ 1 ].get() + point[ 1 ] * point[ 3 ],
        #                                 @points[ P0 ].pos[ 2 ].get() + point[ 2 ] * point[ 3 ]]
        #                                 
        #                             n = @points[ @points.length-1 ]
        #                             
        #                             index = i + 1 #first position is  at i 0
        #                             
        #                             tmp = li.slice(0)
        #                             for list, j in li
        #                                 if j == index
        #                                     li[ j ]._set os
        #                                 if j > index
        #                                     li[ j ]._set tmp[j - 1].get()
        #                             li.push tmp[tmp.length - 1].get()
        #                             
        #                             res.push
        #                                 prov: this
        #                                 item: n
        #                                 dist: 0
        #                                 type: "Mesh"
        #                             
        #                             break
                    

    update_min_max: ( x_min, x_max ) ->
        for m in @points
            p = m.pos.get()
            for d in [ 0 ... 3 ]
                x_min[ d ] = Math.min x_min[ d ], p[ d ]
                x_max[ d ] = Math.max x_max[ d ], p[ d ]

    get_max: ( l ) ->
        if l.length > 0
            max = l[ 0 ]
        for val, i in l[ 1 ... l.length]
            if val > max
                max = val
        return max
        
    get_min: ( l ) ->
        if l.length > 0
            min = l[ 0 ]
        for val, i in l[ 1 ... l.length]
            if val < min
                min = val
        return min
        
    actualise_value_legend: ( values ) ->
        max = @get_max values
        @_legend.max_val.set max
        
        min = @get_min values
        @_legend.min_val.set min


    _draw_elementary_triangle: ( info, tri, proj, value ) ->
        position = for i in [ 0 ... 3 ]
                proj[ tri[ i ] ]
        
        pos = ( @_legend.max_val.get() - value ) / ( @_legend.max_val.get() - @_legend.min_val.get() )
        col = @_legend.gradient.get_color_from_pos pos
        
        if @display_style.get() == "wireframe"
            @_draw_elementary_stroke_triangle info, position, col
        else
            @_draw_elementary_fill_triangle info, position, col
            
    _draw_elementary_stroke_triangle: ( info, position, col ) ->
        info.ctx.beginPath()        
        info.ctx.strokeStyle = "rgba( " + col[ 0 ] + ", " + col[ 1 ] + ", " + col[ 2 ] + ", " + col[ 3 ] + " ) "
        info.ctx.moveTo( position[ 0 ][ 0 ], position[ 0 ][ 1 ] )
        info.ctx.lineTo( position[ 1 ][ 0 ], position[ 1 ][ 1 ] )
        info.ctx.lineTo( position[ 2 ][ 0 ], position[ 2 ][ 1 ] )
        info.ctx.lineTo( position[ 0 ][ 0 ], position[ 0 ][ 1 ] )
        info.ctx.stroke()        
        info.ctx.closePath()                

    _draw_elementary_fill_triangle: ( info, position, col ) ->
        info.ctx.beginPath()
        info.ctx.fillStyle = "rgba( " + col[ 0 ] + ", " + col[ 1 ] + ", " + col[ 2 ] + ", " + col[ 3 ] + " ) "
        info.ctx.moveTo( position[ 0 ][ 0 ], position[ 0 ][ 1 ] )
        info.ctx.lineTo( position[ 1 ][ 0 ], position[ 1 ][ 1 ] )
        info.ctx.lineTo( position[ 2 ][ 0 ], position[ 2 ][ 1 ] )
        info.ctx.lineTo( position[ 0 ][ 0 ], position[ 0 ][ 1 ] )
        info.ctx.fill()
        info.ctx.closePath()   
                
    # the trick of this function is that it use only one linear gradient calculate using point value and position
    _draw_nodal_triangle: ( info, tri, proj, field ) ->
        posit = for i in [ 0 ... 3 ]
            proj[ tri[ i ] ]
                
        value = for i in [ 0 ... 3 ]
            field[ tri[ i ] ]
                
        max_legend = @_legend.max_val.get()
        min_legend = @_legend.min_val.get()
        
        for val, i in value
            value[ i ] = ( max_legend - val ) / ( max_legend - min_legend )
            
        # position of every point
        x0 = posit[ 0 ][ 0 ]
        y0 = posit[ 0 ][ 1 ]
        
        x1 = posit[ 1 ][ 0 ]
        y1 = posit[ 1 ][ 1 ]
        
        x2 = posit[ 2 ][ 0 ]
        y2 = posit[ 2 ][ 1 ]
        
        mat_pos = [ [ 1, x0, y0 ], [ 1, x1, y1 ], [ 1, x2, y2 ] ]
        det = Vec_3.determinant mat_pos
        
        mat_a = [ [ value[ 0 ], x0, y0 ], [ value[ 1 ], x1, y1 ], [ value[ 2 ], x2, y2 ] ]
        det_a = Vec_3.determinant mat_a
        a = det_a / det
                    
        mat_b = [ [ 1, value[ 0 ], y0 ], [ 1, value[ 1 ], y1 ], [ 1, value[ 2 ], y2 ] ]
        det_b = Vec_3.determinant mat_b
        b = det_b / det
        
        mat_c = [ [ 1, x0, value[ 0 ] ], [ 1, x1, value[ 1 ] ], [ 1, x2, value[ 2 ] ] ]
        det_c = Vec_3.determinant mat_c
        c = det_c / det
        
        # getting p0
        if b != 0
            p0x0 = - a / b
            p0y0 = 0
        else if c != 0
            p0x0 = 0
            p0y0 = - a / c
        else
            p0x0 = 0
            p0y0 = 0
            
        p0 = [ p0x0, p0y0, 0 ]
        
        # getting p1
        p1ieqz = ( x ) -> x + ( x == 0 )
        alpha = 1 / p1ieqz( b * b + c * c )
        p1 = Vec_3.add( p0, Vec_3.mus( alpha, [ b, c, 0 ] ) )
        
        if @display_style.get() == "wireframe"
            @_draw_gradient_stroke_triangle info, p0, p1, posit
        else
            @_draw_gradient_fill_triangle info, p0, p1, posit
        
    # drawing gradient depending p0 and p1 in the correct triangle
    _draw_gradient_fill_triangle: ( info, p0, p1, posit ) ->
        info.ctx.beginPath()
        lineargradient = info.ctx.createLinearGradient p0[ 0 ], p0[ 1 ],  p1[ 0 ], p1[ 1 ]
        for col in @_legend.gradient.color_stop
            lineargradient.addColorStop col.position.get(), col.color.to_rgba()
        info.ctx.fillStyle = lineargradient
        info.ctx.moveTo( posit[ 0 ][ 0 ], posit[ 0 ][ 1 ] )
        info.ctx.lineTo( posit[ 1 ][ 0 ], posit[ 1 ][ 1 ] )
        info.ctx.lineTo( posit[ 2 ][ 0 ], posit[ 2 ][ 1 ] )
        info.ctx.lineTo( posit[ 0 ][ 0 ], posit[ 0 ][ 1 ] )
        info.ctx.fill()
        
    # drawing gradient depending p0 and p1 in the correct triangle
    _draw_gradient_stroke_triangle: ( info, p0, p1, posit ) ->
        info.ctx.beginPath()
        lineargradient = info.ctx.createLinearGradient p0[ 0 ], p0[ 1 ],  p1[ 0 ], p1[ 1 ]
        for col in @_legend.gradient.color_stop
            lineargradient.addColorStop col.position.get(), col.color.to_rgba()
        info.ctx.strokeStyle = lineargradient
        info.ctx.moveTo( posit[ 0 ][ 0 ], posit[ 0 ][ 1 ] )
        info.ctx.lineTo( posit[ 1 ][ 0 ], posit[ 1 ][ 1 ] )
        info.ctx.lineTo( posit[ 2 ][ 0 ], posit[ 2 ][ 1 ] )
        info.ctx.lineTo( posit[ 0 ][ 0 ], posit[ 0 ][ 1 ] )
        info.ctx.stroke()
        
    _get_center_radius: ( P0, P1, P2) ->
        P01 = Vec_3.sub P1, P0
        P02 = Vec_3.sub P2, P0
        x1 = Vec_3.len P01
        P01 = Vec_3.mus 1 / x1, P01
        x2 = Vec_3.dot P02, P01
        P02 = Vec_3.sub( P02, Vec_3.mus( x2, P01 ) )
        y2 = Vec_3.len P02
        P02 = Vec_3.mus 1 / y2, P02
        xc = x1 * 0.5
        yc = ( x2 * x2 + y2 * y2 - x2 * x1 ) / ( 2.0 * y2 )
        C = Vec_3.add( Vec_3.add( P0, Vec_3.mus( xc, P01 ) ), Vec_3.mus( yc, P02 ) )
        R = Vec_3.len( Vec_3.sub( P0, C ) )
        
        a0 = Math.atan2 (  0 - yc ), (  0 - xc )
        a1 = Math.atan2 (  0 - yc ), ( x1 - xc )
        a2 = Math.atan2 ( y2 - yc ), ( x2 - xc )
        
        ma = 0.5 * ( a0 + a2 )
        if Math.abs( a1 - ma ) > Math.abs( a0 - ma ) # si a1 n'est pas compris dans l'intervalle
            if a2 < a0
                a2 += 2 * Math.PI
            else
                a0 += 2 * Math.PI
                
        ma = 0.5 * ( a0 + a2 )
        if Math.abs( a1 - ma ) > Math.abs( a0 - ma ) # si a1 n'est toujours pas compris dans l'intervalle
            a1 += 2 * Math.PI
                
        res =
            C  : C
            R  : R
            a  : [ a0, a1, a2 ]
            P01: P01
            P02: P02
        return res


    _get_line_inter: ( proj, P0, P1, x, y ) ->
        lg_0 = P0
        lg_1 = P1
        
        a = proj[ lg_0 ]
        b = proj[ lg_1 ]
        
        if a[ 0 ] != b[ 0 ] or a[ 1 ] != b[ 1 ]
            dx = b[ 0 ] - a[ 0 ]
            dy = b[ 1 ] - a[ 1 ]
            px = x - a[ 0 ]
            py = y - a[ 1 ]
            l = dx * dx + dy * dy
            d = px * dx + py * dy
            if d >= 0 and d <= l
                px = a[ 0 ] + dx * d / l
                py = a[ 1 ] + dy * d / l
                if Math.pow( px - x, 2 ) + Math.pow( py - y, 2 ) <= 4 * 4
                    dx = @points[ lg_1 ].pos[ 0 ].get() - @points[ lg_0 ].pos[ 0 ].get()
                    dy = @points[ lg_1 ].pos[ 1 ].get() - @points[ lg_0 ].pos[ 1 ].get()
                    dz = @points[ lg_1 ].pos[ 2 ].get() - @points[ lg_0 ].pos[ 2 ].get()
                    
                    return [ dx, dy, dz, d / l ]
        
    _get_proj_arc: ( info, arc_info, a ) ->
        rca = arc_info.R * Math.cos( a )
        rsa = arc_info.R * Math.sin( a )
        info.re_2_sc.proj [
            arc_info.C[ 0 ] + rca * arc_info.P01[ 0 ] + rsa * arc_info.P02[ 0 ],
            arc_info.C[ 1 ] + rca * arc_info.P01[ 1 ] + rsa * arc_info.P02[ 1 ],
            arc_info.C[ 2 ] + rca * arc_info.P01[ 2 ] + rsa * arc_info.P02[ 2 ]
        ]
       
    _disp_arc_n_points: ( info, point ) ->
        res = for i in [ 0 ... point.length - 2 ]
            @_get_center_radius point[ i ], point[ i + 1 ], point[ i + 2 ]
                
        info.ctx.beginPath()
        p = info.re_2_sc.proj point[ 0 ]
        info.ctx.moveTo p[ 0 ], p[ 1 ]

        # beg
        for n in [ 1 .. 30 ]
            alpha = n / 30.0
            ar = res[ 0 ].a[ 0 ] + ( res[ 0 ].a[ 1 ] - res[ 0 ].a[ 0 ] ) * alpha
            pr = @_get_proj_arc info, res[ 0 ], ar
            info.ctx.lineTo pr[ 0 ], pr[ 1 ]
                
        # mid
        for i in [ 0 ... point.length - 3 ]
            for n in [ 0 ... 30 ]
                alpha = n / 30.0
                a0 = res[ i + 0 ].a[ 1 ] + ( res[ i + 0 ].a[ 2 ] - res[ i + 0 ].a[ 1 ] ) * alpha
                a1 = res[ i + 1 ].a[ 0 ] + ( res[ i + 1 ].a[ 1 ] - res[ i + 1 ].a[ 0 ] ) * alpha
                
                p0 = @_get_proj_arc info, res[ i + 0 ], a0
                p1 = @_get_proj_arc info, res[ i + 1 ], a1
                pr = Vec_3.add( Vec_3.mus( 1 - alpha, p0 ), Vec_3.mus( alpha, p1 ) )
                
                info.ctx.lineTo pr[ 0 ], pr[ 1 ]
        
        # end
        nr = res.length - 1
        for n in [ 0 .. 30 ]
            alpha = n / 30.0
            ar = res[ nr ].a[ 1 ] + ( res[ nr ].a[ 2 ] - res[ nr ].a[ 1 ] ) * alpha
            pr = @_get_proj_arc info, res[ nr ], ar
            info.ctx.lineTo pr[ 0 ], pr[ 1 ]
        
        
        #info.ctx.closePath()
        info.ctx.stroke()

    _disp_arc: ( info, P0, P1, P2 ) ->
        # 3D center and radius
        P01 = Vec_3.sub P1, P0
        P02 = Vec_3.sub P2, P0
        x1 = Vec_3.len P01
        P01 = Vec_3.mus 1 / x1, P01
        x2 = Vec_3.dot P02, P01
        P02 = Vec_3.sub( P02, Vec_3.mus( x2, P01 ) )
        y2 = Vec_3.len P02
        P02 = Vec_3.mus 1 / y2, P02
        xc = x1 * 0.5
        yc = ( x2 * x2 + y2 * y2 - x2 * x1 ) / ( 2.0 * y2 )
        C = Vec_3.add( Vec_3.add( P0, Vec_3.mus( xc, P01 ) ), Vec_3.mus( yc, P02 ) )
        R = Vec_3.len( Vec_3.sub( P0, C ) )

        a0 = Math.atan2 (  0 - yc ), (  0 - xc )
        a1 = Math.atan2 (  0 - yc ), ( x1 - xc )
        a2 = Math.atan2 ( y2 - yc ), ( x2 - xc )
        
        ma = 0.5 * ( a0 + a2 )
        if Math.abs( a1 - ma ) > Math.abs( a0 - ma )
            if a2 < a0
                a2 += 2 * Math.PI
            else
                a0 += 2 * Math.PI
        
        # projection
        info.ctx.beginPath()
        n = Math.ceil( Math.abs( a2 - a0 ) / 0.1 )
        for ai in [ 0 .. n ]
            a = a0 + ( a2 - a0 ) * ai / n
            rca = R * Math.cos( a )
            rsa = R * Math.sin( a )
            p = info.re_2_sc.proj [
                C[ 0 ] + rca * P01[ 0 ] + rsa * P02[ 0 ],
                C[ 1 ] + rca * P01[ 1 ] + rsa * P02[ 1 ],
                C[ 2 ] + rca * P01[ 2 ] + rsa * P02[ 2 ]
            ]
            
            if ai 
                info.ctx.lineTo p[ 0 ], p[ 1 ]
            else
                info.ctx.moveTo p[ 0 ], p[ 1 ]
        #info.ctx.closePath()
        info.ctx.stroke()
        