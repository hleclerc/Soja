# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2012 Hugo Leclerc
#
# This file is part of Soda.
#
# Soda is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Soda is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with Soda. If not, see <http://www.gnu.org/licenses/>.



#
class ModelEditorItem_GradientPicker extends ModelEditorItem
    constructor: ( params ) ->
        super params
        
        @predef_grad = new Lst
        
        @popupWidth = 535
        
        @picker_pos = "right" #top / bottom or left / right
        
        if @picker_pos == 'right' || @picker_pos == 'left'
            @way = 'vertical'
            @canvasContainerWidth = "5%"
            @canvasWidth = 100
            @canvasHeight = 350 # px
        else
            @way = 'horizontal'
            @canvasWidth = 80 # %
            @canvasHeight = 20 # px
            @canvasContainerWidth = @ew - 1.5 + "%" # 0.5 represent fieldset padding
            
        
        @container = new_dom_element
            parentNode: @ed
            nodeName  : "div"
            className : "containerGradientPicker"
            style     :
                width  : @popupWidth
                minHeight : @canvasHeight + 3
                display: "inline-block"
        
        @rightContainer = new_dom_element
            parentNode: @container
            nodeName  : "div"
            className : "rightContainer"
        
        @colorPicker = new_dom_element
            parentNode: @rightContainer
            className : "inlineColorPicker"
            
        new ModelEditorItem_ColorPicker
            el    : @colorPicker
            model : @model.color_stop[0].color
#             parent: this

        new_dom_element
            parentNode: @rightContainer
            nodeName  : "hr"
            style     :
                marginRight : "12px"
            
        @containerPreDefinedGradient = new_dom_element
            parentNode: @rightContainer
            nodeName  : "div"
            className : "containerPreDefinedGradient"
            txt       : "Predefined gradient"
        new_dom_element
            parentNode: @containerPreDefinedGradient
            nodeName  : "br"

            
        @build_predefined_gradient()
                    
        @savePreDefinedGradient = new_dom_element
            parentNode: @rightContainer
            nodeName  : "a"
            href      : "javascript:void(0)"
            onclick   : (e) => @save_current_gradient e
            className : "savePredefinedGradient"
        
        @savePreDefinedGradientImg = new_dom_element
            parentNode: @savePreDefinedGradient
            nodeName  : "img"
            src       : "img/save_gradient.png"
            alt       : "Save Current Gradient"
            title     : "Save Current Gradient"
            
        @canvasContainer = new_dom_element
            parentNode: @container
            className : "canvasContainer"
            style     :
                width : @canvasContainerWidth
                position: "absolute"
            
        @canvas = new_dom_element
            parentNode: @canvasContainer
            nodeName  : "canvas"
            className : "gradientPicker"
            style     :
                display: "inline-block"
                width  : @canvasWidth + "%"
                height : @canvasHeight
            onclick   : (e) => @add_color_picker e

            
        @build_color_picker()

    onchange: ->
        ctx = @canvas.getContext('2d')
        if @way == 'vertical'
            lineargradient = ctx.createLinearGradient 0, 0, 0, @canvas.height
        else
            lineargradient = ctx.createLinearGradient 0, 0, @canvas.width, 0
            
        for c in @model.color_stop
            lineargradient.addColorStop c.position.get(), c.color.to_rgba()
        ctx.fillStyle = lineargradient
        ctx.fillRect 0, 0, @canvas.width, @canvas.height
    
    # apply the gradient in list at [index] to the current gradient (that user can modify)
    apply_predefined_gradient: ( index ) =>
        for col in @model.color_stop
            @model.remove_color col
        
        for col in @predef_grad[ index ].color_stop.get()
            @model.add_color [ col.color.r, col.color.g, col.color.b, col.color.a ], col.position
        @build_color_picker()
    
    # on init, it build model and use ModelEditorItem_Gradient as a view, because they are predefined gradient, we don't want this canvas to be modify by the user (forbid_picker is set to false)
    build_predefined_gradient: ->        
        m = new Gradient
        m.add_color [ 255, 255, 255, 255 ], 0
        m.add_color [ 0,  0, 0, 255 ], 1
        @predef_grad.push m
        
        m = new Gradient
        m.add_color [ 255,  0, 0, 255 ], 0
        m.add_color [ 255, 255, 255, 255 ], 0.5
        m.add_color [ 0,  0, 255, 255 ], 1
        @predef_grad.push m
        
        m = new Gradient
        m.add_color [ 255, 255, 255, 255 ], 0
        m.add_color [ 255, 255, 0, 255 ], 0.33
        m.add_color [ 255, 0, 0, 255 ], 0.67
        m.add_color [ 0,  0, 0, 255 ], 1
        @predef_grad.push m
        
        m = new Gradient
        m.add_color [ 255,  0, 0, 255 ], 0
        m.add_color [ 255,  255, 0, 255 ], 0.25
        m.add_color [ 0, 255, 0, 255 ], 0.5
        m.add_color [ 0, 255, 255, 255 ], 0.75
        m.add_color [ 0, 0, 255, 255 ], 1
        @predef_grad.push m
        
        j = 0
        for i in @predef_grad
            do ( j ) =>
                new ModelEditorItem_Gradient
                    el    : @containerPreDefinedGradient
                    model : i
                    forbid_picker: true
                    item_width: 48 
                    spec_click: ( evt ) =>
                        @apply_predefined_gradient j
            j++

    # save current gradient in the list of preDefinedGradient
    save_current_gradient: (e) =>
        m = new Gradient
        for col in @model.color_stop
            m.add_color [ col.color.r, col.color.g, col.color.b, col.color.a ], col.position
        index = @predef_grad.length
        new ModelEditorItem_Gradient
            el    : @containerPreDefinedGradient
            model : m
            forbid_picker: true
            item_width: 48
            spec_click: ( evt ) =>
                @apply_predefined_gradient index
        @predef_grad.push m
        @build_color_picker()
        
    #create color controler for each element of color_stop in the model
    build_color_picker: =>
        while(@canvasContainer.children.length > 1)
            elem = @canvasContainer.children[1]
            @canvasContainer.removeChild(elem)
        
        for i in [ 0 ... @model.color_stop.length ]
            @create_color_picker i
        @_focus_color 0

    #create a colorPicker from ModelEditorItem_Color view
    create_color_picker: ( index ) =>
        old_y = 0
        old_x = 0
        pos = 0
        del_picker = false
        dragging = false
        color_picker_width = 2
        color_picker_height = 10
        cPHeight  = parseInt getComputedStyle( @canvas ).height
        cPWidth  = parseInt getComputedStyle( @canvas ).width
        
        if @way == 'horizontal'
            pos_left = @model.color_stop[ index ].position.get() * @canvasWidth - color_picker_width/2 + "%"
            if @picker_pos == 'top'
                pos_top = "-9px"
            if @picker_pos == 'bottom'
                pos_top = (parseInt getComputedStyle( @canvas ).height) - 5 + "px"

        if @way == 'vertical'
            pos_top = @model.color_stop[ index ].position.get() * @canvasHeight - color_picker_height/2 + "px"
            if @picker_pos == 'left'
                pos_left = '-10px'
            if @picker_pos == 'right'
                pos_left = (parseInt getComputedStyle( @canvas ).width) - 4 + "px"
        @cp = new_dom_element
                parentNode: @canvasContainer
                nodeName  : "div"
                id        : "cp" + index
                style     :
                    position        : "absolute"
                    top             : pos_top
                    left            : pos_left
                    width           : color_picker_width + "%"
                    height          : color_picker_height + "px"
                    cursor          : "pointer"
                onmousedown: ( evt ) =>
                    old_x = evt.clientX
                    old_y = evt.clientY
                    if @way == 'vertical'
                        pos = @model.color_stop[ index ].position.get() * cPHeight
                    else
                        pos = @model.color_stop[ index ].position.get() * cPWidth
                    document.addEventListener "mousemove", _drag_evt_func, true
                    document.addEventListener "mouseup"  , _drag_end_func, true
                    evt.preventDefault?()
                    @cp.style.border
                    @_focus_color index
            new ColorPickerImg el: @cp, model: @model.color_stop[index].color, picker_pos: @picker_pos
                
        _drag_evt_func = ( evt ) =>
            currentControler = document.getElementById('cp' + index)
            
            if @way == 'vertical'
                decal = Math.abs(evt.clientX - old_x)
            else
                decal = Math.abs(evt.clientY - old_y)
                
            if decal > 50
                currentControler.style.opacity = 0.2
                currentControler.style.border = "medium solid red"
                del_picker = true
                
            else
                currentControler.style.opacity = 1
                currentControler.style.border = "none"
                del_picker = false
            
            
            if @way == 'vertical'
                pos += evt.clientY - old_y
                newPos = pos / cPHeight
            else
                pos += evt.clientX - old_x
                newPos = pos / cPWidth
                
            if newPos > 1
                newPos = 1
                if @way == 'vertical'
                    pos = cPHeight
                else
                    pos = cPWidth
                
            if newPos < 0
                newPos = 0
                pos = 0
            
            
            @model.color_stop[ index ].position.set newPos
            
            if @way == 'vertical'
                currentControler.style.top = pos - color_picker_height/2
                old_y = evt.clientY
            else
                ccWidth = parseInt getComputedStyle( currentControler ).width
                currentControler.style.left = pos - ccWidth / 2
                old_x = evt.clientX
            
            evt.preventDefault?()
                    
        _drag_end_func = ( evt ) =>
            currentControler = document.getElementById('cp' + index)
            document.detachEvent? "onmousemove", _drag_evt_func
            document.detachEvent? "onmouseup"  , _drag_end_func
            document.removeEventListener? "mousemove", _drag_evt_func, true
            document.removeEventListener? "mouseup"  , _drag_end_func, true
            if del_picker == true
                @remove_color_picker index
                @model.remove_color index
                
                #adjust index color and every call that had index as a params
                if index != @model.color_stop.length
                    for i in [index+1..@model.color_stop.length]
                        @remove_color_picker i
                    for i in [index..@model.color_stop.length]
                        @create_color_picker i
                
    remove_color_picker: ( index ) =>
        currentControler = document.getElementById('cp' + index)
        @canvasContainer.removeChild currentControler
        if document.getElementById('cp0') != "undefined"
            @_focus_color 0

    _focus_color : ( index ) =>
        @colorPicker.removeChild(@colorPicker.firstChild)
        new ModelEditorItem_ColorPicker
            el    : @colorPicker
            model : @model.color_stop[index].color

    # call when user click on canvas
    # add a color_stop in the model
    # add a colorPicker view for this color
    add_color_picker: (e) =>
        [ rgba, pos ] = @find_color_by_event(e)
     
        indexColorStop = @model.color_stop.length
        @model.add_color [rgba[0],rgba[1],rgba[2],rgba[3]], pos
        
        @create_color_picker indexColorStop
        @_focus_color indexColorStop

    # return the rgba of the point clicked, also return position for gradient (between 0 and 1)
    # the trick in this function is that canvas width is 300 but stretch to 100% so you can't really now by advance the size of canvas
    find_color_by_event: (e) ->
        ctxPicked = @canvas.getContext '2d'
        cPWidth  = parseInt getComputedStyle( @canvas ).width 
        cPHeight = parseInt getComputedStyle( @canvas ).height
        
        canvasDataPicked = ctxPicked.getImageData 0, 0, @canvas.width, @canvas.height
        coord = @get_cursor_position e

        if @way == 'vertical'
            idxPicked = Math.round( coord[ 1 ] * 45000 / cPHeight ) * 4 # 45000 is the default number element in canvas data (300 * 150 * 4
        else
            idxPicked = Math.round( 300 * coord[ 0 ] / cPWidth ) * 4 # 300 is the default width of canvas

        r = canvasDataPicked.data[ idxPicked + 0 ]
        g = canvasDataPicked.data[ idxPicked + 1 ]
        b = canvasDataPicked.data[ idxPicked + 2 ]
        a = canvasDataPicked.data[ idxPicked + 3 ]
        
        if @way == 'vertical'
            pos = coord[ 1 ] / cPHeight
        else
            pos = coord[ 0 ] / cPWidth
        return [ [ r, g, b, a ], pos ]
    
    #return x and y where origin is the canvas top left
    get_cursor_position: ( event ) ->
        canOffset = [ get_left( @canvas ), get_top( @canvas ) ]
        x = event.clientX + document.body.scrollLeft + document.documentElement.scrollLeft - Math.floor( canOffset[ 0 ] )
        y = event.clientY + document.body.scrollTop + document.documentElement.scrollTop - Math.floor( canOffset[ 1 ] ) - 1
        return [ x, y ]
        
