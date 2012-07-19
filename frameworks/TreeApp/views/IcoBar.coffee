#
class IcoBar extends View
    constructor: ( @el, @tree_app, params = {} ) ->
        @modules = @tree_app.data.modules
        super @modules
                
        @tree_app.data.focus.bind this
        @loc        = false
        #TODO use the three next params
        #@allow_sub  = true
        #@sub_type   = "all" # which prf
        #@sub_lvl    = -1 # indicates lvl max of child (-1 mean show everything)
        
        for key, val of params
            this[ key ] = val
        
        if @loc == false
            @disp_top  = 0
            @disp_left = 0
            @height    = 0
            @height_ico = 24
            
            @div = new_dom_element
                className: "IcoBar"
                style:
                    position: "absolute"
                    right   : 0

        @icon_container = new_dom_element
                nodeName  : "div"
                className : "FooterTreeView"
                parentNode: @el
            
    onchange: ->
        @_render_loc_actions @tree_app
        if @loc == true
            return
            
        @el.appendChild @div
        
            
        @div.style.top    = @disp_top
        @div.style.left   = @disp_left
        
        @hidden_ico = false
       
        while @div.firstChild?
            @div.removeChild @div.firstChild

        for m in @modules
            if m.visible? and m.visible == false
                continue
            
            do ( m ) =>
                block = new_dom_element
                    parentNode : @div
                    nodeName   : "span"
                    className  : "module"
                
                parent = icon_top = icon_bot = big_icon = undefined
                
                for act, j in m.actions when act.vis != false and act.loc != true
                    do ( act ) =>
                        siz = act.siz or 1
                        
                        if act.siz == 1
                            if parent == undefined or parent == big_icon
                                container_icon = new_dom_element
                                    parentNode : block
                                    nodeName   : "span"
                                    className  : "container_icon"
                                    
                                icon_top = new_dom_element
                                    parentNode : container_icon
                                    nodeName   : "span"
                                    className  : "icon_top_span"
                            
                                new_dom_element
                                    parentNode : container_icon
                                    nodeName   : "br"
                                        
                                icon_bot = new_dom_element
                                    parentNode : container_icon
                                    nodeName   : "span"
                                    className  : "icon_bot_span"
                                    
                                parent = icon_top
                            
                        else
                            if parent == undefined
                                parent = big_icon
                            
                            if parent == icon_top or parent == icon_bot
                        
                                container_icon = new_dom_element
                                    parentNode : block
                                    nodeName   : "span"
                                    className  : "container_icon"
                                    
                                big_icon = new_dom_element
                                    parentNode : container_icon
                                    nodeName   : "span"
                                    className  : "big_icon_span"
                                parent = big_icon
                        
                        #create all icon recursively
                        @_select_icon_type_rec act, parent, siz

                        if act.siz == 1 and parent != big_icon and act.ord == undefined or act.ord == true
                            if parent == icon_top
                                parent = icon_bot
                            else
                                parent = icon_top
                            
                new_dom_element
                    parentNode : block
                    nodeName   : "br"
                
                module_title = new_dom_element
                        parentNode : block
                        nodeName   : "div"
                        className  : "module_title"
                        txt        : m.name
                        
    key_as_string: ( act ) ->
        key = ''
        if act.key?
            key = ' ('
            for k, i in act.key
                if i >= 1
                    key += ' or '
                key += k
            key += ')'
#             
        return key
    
    
    display_child_menu_container: ( evt, val ) ->
        if val == 1
            containers = document.getElementsByClassName("menu_container")
            menu_container = containers[ containers.length - 1 ]
            menu_container.classList.add "block"
        if val == 0
            containers = document.getElementsByClassName("menu_container")
            menu_container = containers[ containers.length - 1 ]
            menu_container.classList.remove "block"
        
    # create classic icon using image
    draw_item: ( act, parent, key, size, prf ) ->
        if act.vis != false
            if prf? and prf == "menu"
                if act.mod?
                    editor = new_model_editor el: parent, model: act.mod( @tree_app ), item_width: 85
                    s = parent
                else
                    # element who have child
                    if act.sub?.act?
                        c = new_dom_element
                            parentNode : parent
                            nodeName   : "div"
                            className  : "elem_container_parent"
                            txt        : act.txt
                            title      : act.txt + key
                            onmouseover: ( evt ) =>
                                @display_child_menu_container evt, 1
                            onmouseout: ( evt ) =>
                                @display_child_menu_container evt, 0
                                
                                
                        arr = new_dom_element
                            parentNode : c
                            nodeName   : "img"
                            className  : "menu_img_arrow"
                            src        : "img/down_arrow.png"
                            alt        : ""
                    # normal element
                    else
                        s = new_dom_element
                            parentNode : parent
                            nodeName   : "div"
                            className  : "elem_container"
                            title      : act.txt + key
                            onmousedown: ( evt ) =>
                                act.fun evt, @tree_app
                                parent.classList.toggle "block"
                                
                        t = new_dom_element
                            parentNode : s
                            nodeName   : "span"
                            txt        : act.txt
                                
                        hotkey = new_dom_element
                            parentNode : s
                            nodeName   : "span"
                            className  : "elem_container_key"
                            txt        : key
            
            else if prf? and prf == "list"
                    s = new_dom_element
                        parentNode : parent
                        nodeName   : "img"
                        alt        : act.txt
                        title      : act.txt + key
                        src        : act.ico
                        style      :
                            height     : @height_ico * size
                        onmousedown: ( evt ) =>
                            act.fun evt, @tree_app
                            parent.classList.toggle "inline"
                            
                    new_dom_element
                        parentNode : parent
                        nodeName   : "br"
                        
                        
            #* ( if act.ina?( @tree_app ) then 0.5 else 1.0 )
            else if act.ico? and act.ico.length > 0
                s = new_dom_element
                    parentNode : parent
                    nodeName   : "img"
                    alt        : act.txt
                    title      : act.txt + key
                    src        : act.ico
                    style      :
                        height     : @height_ico * size
                    onmousedown: ( evt ) =>
                        act.fun evt, @tree_app
            
            #icon who need a model_editor item
            else if act.mod?
                editor = new_model_editor el: parent, model: act.mod( @tree_app ), item_width: 85
                s = parent
                
            else if act.txt?
                s = new_dom_element
                    parentNode : parent
                    nodeName   : "span"
                    txt        : act.txt
                    title      : act.txt + key
                    style      :
                        height     : @height_ico * size
                    onmousedown: ( evt ) =>
                        act.fun evt, @tree_app
        return s

    # hierarchical menu is a classical menu that create a block containing icon
    create_hierarchical_menu: ( sub, parent, key ) ->
        if parent.className == "menu_container"
            menu_container = new_dom_element
                parentNode : parent
                nodeName   : "div"
                className  : "menu_container"
                style      :
                    left: "100%"
                onmouseover: ( evt ) =>
                    @display_child_menu_container evt, 1
                onmouseout: ( evt ) =>
                    @display_child_menu_container evt, 0
        else
            menu_container = new_dom_element
                parentNode : parent
                nodeName   : "div"
                className  : "menu_container"
                style      :
                    top: "70%"
                # @menu_container.parentNode.removeChild @menu_container

        return menu_container

    # side menu is an icon who have icon as children
    create_list_menu: ( act, parent, key, size ) =>
        click_container = new_dom_element
            parentNode : parent
            nodeName   : "span"
            className  : "click_container"
            
        
        if act.ico? and act.ico.length > 0
            new_dom_element
                parentNode : click_container
                nodeName   : "img"
                alt        : act.txt
                title      : act.txt + key
                src        : act.ico
                className  : "parent_list_icon"
                style      :
                    height     : @height_ico * size
                    
                onmousedown: ( evt ) =>
                    # assing first action to visible icon
                    act.sub.act[ 0 ]?.fun evt, @tree_app
        #icon who need a model_editor item
        else if act.mod?
            editor = new_model_editor el: click_container, model: act.mod( @tree_app ), item_width: 85
            
        else if act.txt?
            new_dom_element
                parentNode : click_container
                nodeName   : "span"
                txt        : act.txt
                title      : act.txt + key
                style      :
                    height     : @height_ico * size
                onmousedown: ( evt ) =>
                    act.fun evt, @tree_app
                            
        arrow_container = new_dom_element
            parentNode : click_container
            nodeName   : "span"
            className  : "arrow_container"
            onmousedown: ( evt ) =>
                child_container.classList.toggle "inline"
                     
        arrow = new_dom_element
            parentNode : arrow_container
            nodeName   : "img"
            src        : "img/down_arrow.png"
            alt        : ""
            className  : "arrow"
            
        #span that will contain hidden icon
        child_container = new_dom_element
            parentNode : parent
            nodeName   : "span"
            className  : "container_hidden_icon"
            id         : "id_hidden_icon"
            
        return child_container
            
    
    _select_icon_type_rec: ( act, parent, size, prf = '' ) ->
        key = @key_as_string act
#         console.log act.txt, parent
        if act.sub? and act.sub.prf? and act.sub.act?
            if act.sub.prf == "list" 
                must_draw_item = false
                act.fun = ( evt, app ) ->
                    act.sub.act[ 0 ].fun evt, app
                container = @create_list_menu act, parent, key, size
            else if act.sub.prf == "menu" 
                container = @create_hierarchical_menu act.sub, parent, key
                must_draw_item = false
                @draw_item act, parent, key, size, prf
                act.fun = ( evt, app ) ->
                    container.classList.toggle "block"
        
        else if act.vis != false and must_draw_item != false
            container = @draw_item act, parent, key, size, prf
            
        if act.sub?.act?
            for ac, i in act.sub.act
                @_select_icon_type_rec ac, container, size, act.sub.prf

            return true
        return false
        
    _render_loc_actions: ( @tree_app ) ->
        while @icon_container.firstChild?
            @icon_container.removeChild @icon_container.firstChild
        console.log 'loc'
        for m in @modules
            do ( m ) =>
                for act, j in m.actions when act.loc == true
                    do ( act ) =>
                        de = new_dom_element
                            nodeName  : "img"
                            src       : act.ico
                            className : "FooterTreeViewIcon"
                            parentNode: @icon_container
                            alt       : act.txt
                            title     : act.txt
                            onclick   : ( evt ) =>
                                act.fun evt, @tree_app
                        
                        if @bnd and act.bnd? and act.vis?
                            # TODO PERF
                            act.bnd( @tree_app.data ).bind =>
                                if act.vis @tree_app
                                    de.style.display = "none"
                                else
                                    de.style.display = "inline-block"
                        else if not @bnd and act.bnd?
                            de.style.display = "none"
                            
#                         if not act.ina?( @tree_app )
                            