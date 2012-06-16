class Point extends Drawable
    constructor: ( pos, move_scheme = new MoveScheme_3D ) ->
        super()
        
        @add_attr
            pos: new Vec_3 pos
            
        @_mv = move_scheme

    disp_only_in_model_editor: ->
        @pos
        
    beg_click: ( pos ) ->
        @_mv.beg_click pos
    
    mov_click: ( selected_entities, pos, p_0, d_0 ) ->
        @_mv.mov_click selected_entities, pos, p_0, d_0
    
    z_index: ->
        100
        
    size: ( for_display = false ) ->
        [ 3 ]
        