#
class ModelEditorItem extends View
    @default_types: [
        ( model ) -> ModelEditorItem_CheckBox       if model instanceof Bool
        ( model ) -> ModelEditorItem_Choice         if model instanceof Choice
        ( model ) -> ModelEditorItem_Button         if model instanceof Button
        ( model ) -> ModelEditorItem_ConstrainedVal if model instanceof ConstrainedVal
        ( model ) -> ModelEditorItem_Input          if model instanceof Obj
        ( model ) -> ModelEditorItem_Lst            if model.dim() # Tensor
    ]
    
    # el is a div, specific for this
    constructor: ( params ) ->
        super params.model

        @default_types = []
        for key, val of params
            this[ key ] = val

        if not @focus? and not @parent?
            @focus = new Val -1
            
        if not @closed_models and not @parent?
            @closed_models = new Lst

        @get_focus()?.bind this

        @make_ed()

    destructor: ->
        if @ce?.parentNode?
            @ce.parentNode.removeChild @ce
        super()

    # get property in this or in parents if not defined
    get_property: ( name, default_value ) ->
        if @[ name ]?
            return @[ name ]
        if @parent?
            return @parent.get_property name, default_value
        return default_value
        
    # in percent
    get_focus: ->
        @get_property "focus"
        
    # in percent
    get_item_width: ->
        @get_property "item_width", 100
        
    # in percent
    get_className: ->
        @get_property "className", ''
        
    # 
    get_closed_models: ->
        @get_property "closed_models"
        
    # [ 0, 1 ]
    get_label_ratio: ->
        @get_property "label_ratio", 0.35

    #
    get_justification: ->
        if @justification?
            return @justification
        if @parent?
            return @parent.get_justification()
        return true

    # helper
    snapshot: ->
        if @undo_manager?
            @undo_manager.snapshot()
        else if @parent?
            @parent.snapshot()

    # call trans_name unless there is a specification in model.get_model_editor_parameters
    get_display_name: ( model, name ) ->
        if model.get_model_editor_parameters?
            res = ModelEditorItem._get_model_editor_parameters model
            if res.display_name[ name ]?
                return res.display_name[ name ]
        return @trans_name name
    
    # attribute name -> display name (defaulting to ModelEditor.trans_name if no parent). May be redefined
    trans_name: ( name ) ->
        if @parent?
            return @parent.trans_name name
        #
        r = /\_/g
        res = name.replace r, " "
        return res[ 0 ].toUpperCase() + res[ 1... ]
        
    # updates
    #  @ce -> main created element (used for destructor)
    #  @ew -> edit width (width in percent of edit div avec the label)
    #  @ed -> edit div (where to append elements for edition)
    make_ed: ->
        if @label?
            # inline label ?
            if @ok_for_label()
                @ce = new_dom_element
                    parentNode : @el
                    nodeName   : "span"

                @ev = new_dom_element
                    parentNode : @ce
                    nodeName   : "span"
                    innerHTML  : @label
                    style      :
                        display : "inline-block"
                        width   : @get_item_width() * @get_label_ratio() + "%"
    
                @ew = @get_item_width() * ( 1.0 - @get_label_ratio() )
                @ed = @ce
                
            else
                # else, create a fieldset
                @ce = new_dom_element
                    parentNode: @el
                    nodeName  : "fieldset"
                    
                # hiddable, part 1
                closed_models = @get_closed_models()
                        
                # container with name and sub editor
                legend = new_dom_element
                    parentNode: @ce
                    nodeName  : "legend"
                    innerHTML : @label
                    onclick: =>
                        closed_models = @get_closed_models()
                        closed_models.toggle_ref @model

                # 
                el = new_dom_element
                    parentNode: @ce

                # hiddable, part 2
                closed_models.bind =>
                    if @model in closed_models
                        el.style.display = "none"
                        add_class @ce     , "ModelEditor_closed"
                        add_class legend  , "ModelEditor_closed"
                    else
                        el.style.display = "block"
                        rem_class @ce     , "ModelEditor_closed"
                        rem_class legend  , "ModelEditor_closed"
                        
                @ew = @get_item_width()
                @ed = el
                        
        else
            @ce = new_dom_element
                parentNode : @el
                nodeName   : "span"
                className  : @get_className()
            
            @ew = @get_item_width()
            @ed = @ce
    
    
    ok_for_label: ->
        true
    
    @_get_model_editor_parameters: ( model ) ->
        res =
            display_name: {}
            model_editor: {}
        model.get_model_editor_parameters res    
        return res    

    #
    @get_item_type_for: ( params ) ->
        #
        it = params.item_type
        if it?
            return it
            
        #
        if params.name? and params.parent?.model.get_model_editor_parameters?
            res = ModelEditorItem._get_model_editor_parameters params.parent.model
            if res.model_editor[ params.name ]?
                return res.model_editor[ params.name ]
            
        # global default types
        for t in ModelEditorItem.default_types
            r = t params.model
            if r?
                return r
                
        # default type
        return ModelEditorItem_Aggregate
    
    