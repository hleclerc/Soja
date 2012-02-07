#
class IcoBar extends View
    constructor: ( @el, @tree_app ) ->
        @modules = @tree_app.data.modules
        super @modules
        
        @disp_top  = 0
        @disp_left = 0
        @height    = 0
        @height_ico = 24
        
        @div = new_dom_element
            className: "IcoBar"
            style:
                position: "absolute"
                right   : 0

    onchange: ->
        @el.appendChild @div
        
        @div.style.top    = @disp_top
        @div.style.left   = @disp_left
        
        @hidden_ico = false
       
        while @div.firstChild?
            @div.removeChild @div.firstChild

        for c in [ 0 ... @modules.length ]
            m = @modules[ c ]
            
            if m instanceof TreeAppModule_TreeView or m instanceof TreeAppModule_ImageSet
                continue
            
            do ( m ) =>                
#                 number_of_small_icon = []
#                 number_of_icon = 0
#                 for act in m.actions when act.ico?
#                     if act.siz == undefined or act.siz == 1
#                         number_of_icon++
#                     else
#                         if number_of_icon > 0
#                             number_of_small_icon.push number_of_icon
#                             number_of_icon = 0
#                         
#                 number_of_small_icon.push number_of_icon
#                     
#                 console.log number_of_small_icon
                
                block = new_dom_element
                    parentNode : @div
                    nodeName   : "span"
                    className  : "module"
                
                
                parent = icon_top = icon_bot = big_icon = undefined
                
                for act, j in m.actions when act.ico? or act.mod?
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
                        
                        
                        key = ''
                        if act.key?
                            key = ' ('
                            for k, i in act.key
                                if i >= 1
                                    key += ' or '
                                key += k
                            key += ')'
                        
                        # for icon who have children
                        if act.sub? and act.sub.length > 0
                        
                            click_container = new_dom_element
                                parentNode : parent
                                nodeName   : "span"
                                className  : "click_container"
                                
                            parent_hidden_icon = new_dom_element
                                parentNode : click_container
                                nodeName   : "img"
                                alt        : act.txt
                                title      : act.txt + key
                                src        : act.ico
                                className  : "parent_hidden_icon"
                                style      :
                                    height     : @height_ico * siz
                                    
                                onmousedown: ( evt ) =>
                                    # assing first hidden action to icon
                                    act.sub[ 0 ].fun evt, @tree_app
                                    
                            arrow_container = new_dom_element
                                parentNode : click_container
                                nodeName   : "span"
                                className  : "arrow_container"
                                # children are created on mousedown event
                                onmousedown: ( evt ) =>
                                    if not @container?
                                        @container = new_dom_element
                                            parentNode : child_container
                                            nodeName   : "span"
                                            className  : "container_hidden_icon"
                                            id         : "id_hidden_icon"
                                        
                                        for c in act.sub
                                            do ( c ) =>
                                                s = new_dom_element
                                                    parentNode : @container
                                                    nodeName   : "img"
                                                    alt        : c.txt
                                                    title      : c.txt + key
                                                    src        : c.ico
                                                    style      :
                                                        height     : @height_ico *siz
                                                    onmousedown: ( evt ) =>
                                                        c.fun evt, @tree_app
                                                        @container.parentNode.removeChild @container
                                                        @container = undefined
                                                        
                                                new_dom_element
                                                    parentNode : @container
                                                    nodeName   : "br"
                                    else
                                        @container.parentNode.removeChild @container
                                        @container = undefined
                                        
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
                                
                        else if act.ico?
                            s = new_dom_element
                                parentNode : parent
                                nodeName   : "img"
                                alt        : act.txt
                                title      : act.txt + key
                                src        : act.ico
                                style      :
                                    height     : @height_ico * siz
                                onmousedown: ( evt ) =>
                                    act.fun evt, @tree_app
                        else if act.mod?
                            editor = new_model_editor el: parent, model: act.mod, item_width: 85
                       
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
                        
