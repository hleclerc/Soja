# wrapper Trre 
class ImgItem extends TreeItem
    constructor: ( file, app ) ->
        super()
        # attributes
        @add_attr
            legend: new Legend "Displacement X"
            
        @add_attr
            img: new Img file, app, @legend

        # default values
        @_name.set file.replace( /// ^.*/ ///, "" )
        @_ico.set "img/krita_16.png"
        @_viewable.set true
        
    
    
    accept_child: ( ch ) ->
        #
        
    sub_canvas_items: ->
        [ @img, @legend ]
        
#     disp_only_in_model_editor: ->
#         [ @img, @legend ]

    z_index: ->
        return @img.z_index()
        
    update_min_max: ( x_min, x_max ) ->
        @img.update_min_max( x_min, x_max )
        
    information: ( div ) ->
        if not @cm?
            d = new_dom_element
                parentNode: div
                #                 style     : { position: "absolute", top: 0, left: 0, width: "70%", bottom: 0 }

            bg = new Background
            bg.gradient.remove_color 0

            m = new Mesh
            m.points.push [ 0, 0, 0 ]
            m.points.push [ 1, 0, 0 ]
            m.points.push [ 0, 1, 0 ]
            m.lines.push [ 0, 1, 2 ]
            
            @cm = new CanvasManager el: d
            @cm.items.push bg
            @cm.items.push m
            @cm.items.push new Axes
            @cm.selected_items.push [ m ]
            
            @cm.fit()
            @cm.draw()

            #  - items:
        
            #             txt = "
            #                 #{@img.src} <br>
            #                 Height : #{@img.data.rgba.height} px <br>
            #                 Width  : #{@img.data.rgba.width} px <br>
            #                 #{@img.histo}
            #                 "
            #             div.innerHTML = txt
            
            