class EditView extends View
    constructor: ( @div, @app_data, @undo_manager ) ->
        super @app_data
        
        @model_editors = {}
        @old_divs = []
        
        
    onchange: ->
        if @app_data.selected_tree_items.has_been_modified
            # remove old panel
            for d in @old_divs
                @div.removeChild d
            @old_divs = []

                
            for path in @app_data.selected_tree_items
                s = path[ path.length - 1 ]
                e = @model_editors[ s.model_id ]
                if not e?
                        
                    # generic div to contain the model editor and the informations
                    e = new_dom_element()
                    
                    if s._can_be_computed? and not g?
                        g = new_dom_element
                            parentNode: e
                            nodeName  : "span"
                        for v in @app_data._views when v instanceof TreeApp
                            icobar = new IcoBar g, v, loc: true
                            break
                    m = new_model_editor
                        el          : e
                        model       : s
                        undo_manager: @undo_manager
                        focus       : @app_data.focus

                    # information div
                    if s.information?
                        f = new_dom_element
                            nodeName  : "fieldset"
                            parentNode: e
                                
                        legend = new_dom_element
                            nodeName  : "legend"
                            parentNode: f
                            txt       : "Informations"
                            
                        d = new_dom_element parentNode: f
                        s.bind ->
                            s.information d
                        
                    @model_editors[ s.model_id ] = e
                    
                @div.appendChild e
                @old_divs.push e
      