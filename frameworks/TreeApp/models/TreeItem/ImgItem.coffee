# wrapper Trre 
class ImgItem extends TreeItem
    constructor: ( file, app ) ->
        super()

        
        # attributes
        @add_attr
            show_legend: new Bool true
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
        if @show_legend.get()
            [ @img, @legend ]
        else
            [ @img ]
        
#     disp_only_in_model_editor: ->
#         [ @img, @legend ]

    z_index: ->
        return @img.z_index()
        
    update_min_max: ( x_min, x_max ) ->
        @img.update_min_max( x_min, x_max )
        
    information: ( div ) ->
        div.innerHTML = "Size = #{@img.data.rgba.width} x #{@img.data.rgba.height}"
        