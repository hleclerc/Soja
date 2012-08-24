class Timeline extends View
    constructor: ( @el, @tree_app, params = {} ) ->
        @modules = @tree_app.data.modules
        super @modules
                
        @tree_app.data.focus.bind this
        
        for key, val of params
            this[ key ] = val
        
            
        @div = new_dom_element
            id: "timeline"
            
    onchange: ->
#         @_render_loc_actions @tree_app

        @el.appendChild @div
        
        while @div.firstChild?
            @div.removeChild @div.firstChild

        for m in @modules when m.timeline? and m.timeline == true
            if m.visible? and m.visible == false
                continue
            
            do ( m ) =>
                            
                speed_container = new_dom_element
                    parentNode : @div
                    nodeName   : "span"
                    className  : "timeline_speed"
                    
                speed = new_model_editor
                    el        : speed_container
                    model     : m.img_per_sec
                    item_type : ModelEditorItem_Input
                    item_width: ''
                
                speed_txt = new_dom_element
                    parentNode : speed_container
                    nodeName  : "span"
                    className : "timeline_speed_txt"
                    txt       : "img/s"
                    
                current_picture_name = new_dom_element
                    parentNode: @div
                    nodeName  : "span"
                    className : "timeline_current_picture_name"
                    txt       : "Picture " + @tree_app.data.time.get()
                    
                player_button = new_dom_element
                    parentNode : @div
                    id         : "timeline_player_button"
#                 
                for act, j in m.actions when act.vis != false
                    do ( act ) =>
                        if act.mod?
                            scroll_pane = new_dom_element
                                parentNode : @div
                                className  : "timeline_scroll_pane"
                            editor = new_model_editor el: scroll_pane, model: act.mod( @tree_app )
                            
                        else
                            key = @key_as_string act
                            
                            span_container = new_dom_element
                                parentNode : player_button
                                nodeName   : "span"
                                
                            span_container = new_dom_element
                                parentNode : span_container
                                nodeName   : "img"
                                src        : act.ico
                                alt        : act.txt
                                title      : act.txt + key
                                onmousedown: ( evt ) =>
                                    act.fun evt, @tree_app

                
    key_as_string: ( act ) ->
        key = ''
        if act.key?
            key = ' ('
            for k, i in act.key
                if i >= 1
                    key += ' or '
                key += k
            key += ')'
        return key
        