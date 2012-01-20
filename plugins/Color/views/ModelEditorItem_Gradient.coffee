#
class ModelEditorItem_Gradient extends ModelEditorItem
    constructor: ( params ) ->
        super params
        
        @canvas = new_dom_element
            parentNode: @ed
            nodeName  : "canvas"
            style     :
                width  : @ew + "%"
                height : 20 # !!!
            onclick: ( evt ) =>
                if @spec_click?
                    @spec_click evt 
                else if not @forbid_picker
                    p = new_popup @label or "Gradient picker", event : evt
                    p.appendChild @d
                    @gp.build_color_picker()
                         
        if not @forbid_picker
            # popup preparation
            @d = new_dom_element()
            @gp = new ModelEditorItem_GradientPicker
                el    : @d
                model : @model
                parent: this
            
        if @forbid_picker
            add_class @canvas, "predefinedGradient"
        
    onchange: ->
        ctx = @canvas.getContext '2d'
        lineargradient = ctx.createLinearGradient 0, 0, @canvas.width, 0
        for c in @model.color_stop
            lineargradient.addColorStop c.position.get(), 'rgba(' + c.color.r.get() + ',' + c.color.g.get() + ',' + c.color.b.get() + ',' + c.color.a.get() + ')'
        ctx.fillStyle = lineargradient
        ctx.fillRect 0, 0, @canvas.width, @canvas.height
        
# 
ModelEditor.default_types.push ( model ) -> ModelEditorItem_Gradient if model instanceof Gradient
        