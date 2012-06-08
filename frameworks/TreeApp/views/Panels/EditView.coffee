class EditView extends View
    constructor: ( @div, @app_data, @undo_manager ) ->
        super @app_data
        
        @model_editors = {}
        @div_icobar = {}
        @old_divs = []
        
        
    onchange: ->
        if @app_data.selected_tree_items.has_been_modified
            # remove old panel
            for d in @old_divs
                @div.removeChild d
            @old_divs = []

                
            for path in @app_data.selected_tree_items
                s = path[ path.length - 1 ]
                o = @model_editors[ s.model_id ]
                if not o?
                    # generic div to contain the model editor and the informations
                    o = new_dom_element()
                            
                    if s._can_be_computed? and not @div_icobar[ s.model_id ]?
                        @div_icobar[ s.model_id ] = new_dom_element
                            parentNode: o
                        for v in @app_data._views when v instanceof TreeApp
                            icobar = new IcoBar @div_icobar[ s.model_id ], v, loc: true
                            break
                            
                    e = new_dom_element
                        parentNode: o
                        
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
                        
                    @model_editors[ s.model_id ] = o
                    
                @div.appendChild o
                @old_divs.push o
                
      