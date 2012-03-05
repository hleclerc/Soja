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
        false
        
    sub_canvas_items: ->
        [ @img, @legend ]
        
    # disp_only_in_model_editor: ->
    #     [ @img, @legend ]

    z_index: ->
        return @img.z_index()
        
    update_min_max: ( x_min, x_max ) ->
        @img.update_min_max( x_min, x_max )
        
    information: ( div ) ->
        if not @cm?
            @txt = new_dom_element
                parentNode: div
                
            d = new_dom_element
                parentNode: div
                # style     : { position: "absolute", top: 0, left: 0, width: "70%", bottom: 0 }

            bg = new Background
#             bg.gradient.remove_color 1
            bg.gradient.remove_color 0

            m = new Graph 'bar'
            for p, i in @img._histo
                m.points.push [ i , p, 0 ]
            m.build_w2b_legend()
            
            @cm = new CanvasManager el: d, want_aspect_ratio: true, padding_ratio: 1.2
            @cm.items.push bg
            @cm.items.push m
            @cm.selected_items.push [ m ]
            
            @cm.fit()

        @txt.innerHTML = "
            #{@img.src} <br>
            Height : #{@img.data.rgba.height}px <br>
            Width  : #{@img.data.rgba.width}px <br>
        "

        @cm.draw()


            
            