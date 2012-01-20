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
                    e = new_dom_element()
                    m = new_model_editor
                        el          : e
                        model       : s
                        undo_manager: @undo_manager
                    @model_editors[ s.model_id ] = e
                    
                @div.appendChild e
                @old_divs.push e
      