# lib Soja.js
# lib DomHelper.js
# lib ModelEditor.js
# lib ModelEditor.css
test_1 = ->
    class Color extends Model
        constructor: ->
            super()
            
            @add_attr
                r: new ConstrainedVal( 150, { min: 0, max: 255 } )
                g: new ConstrainedVal( 100, { min: 0, max: 255 } )
                b: new ConstrainedVal( 100, { min: 0, max: 255 } )
                
        lum: -> 
            ( @r.get() + @g.get() + @b.get() ) / 3

    c = new Color
    
    # sliders
    new_model_editor el: new_dom_element( parentNode: document.body, style: {width:300,marginBottom:10} ), model: c
    
    # lum
    l = new_dom_element( parentNode: document.body )
    bind c, -> l.innerHTML = "Luminance = #{c.lum()}"
    