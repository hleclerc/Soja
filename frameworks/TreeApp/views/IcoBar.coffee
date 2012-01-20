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
            
            if m instanceof TreeAppModule_TreeView
                continue
            
            do ( m ) =>
    #             if c
    #                 new_dom_element
    #                     parentNode : @div
    #                     #nodeName   : "span"
    #                     className  : "IcoBarSepModules"
                        
                block = new_dom_element
                        parentNode : @div
                        nodeName   : "span"
                        className  : "module"
                        
                icon = new_dom_element
                        parentNode : block
                        nodeName   : "span"
                        
                i = 0
                for act in m.actions when act.ico? and act.siz == 1
                    i++
                
                for act, j in m.actions when act.ico?
                    do ( act ) =>
                        siz = act.siz or 1
    #                     siz = 1
                        
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
                            new_dom_element
                                parentNode : icon
                                nodeName   : "img"
                                alt        : act.txt
                                title      : act.txt + key
                                src        : act.ico
                                className  : "parent_hidden_icon"
                                style      :
                                    height     : @height_ico * (siz + 1 ) / 2
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
                                                        height     : @height_ico * (siz + 1 ) / 2
                                                    onmousedown: ( evt ) =>
                                                       c.fun evt, @tree_app
                                                        
                                                new_dom_element
                                                    parentNode : @container
                                                    nodeName   : "br"
                                    else
                                        @container.parentNode.removeChild @container
                                        @container = undefined
                            
                            #span that will contain hidden icon
                            child_container = new_dom_element
                                parentNode : icon
                                nodeName   : "span"
                                
                        else
                            s = new_dom_element
                                parentNode : icon
                                nodeName   : "img"
                                alt        : act.txt
                                title      : act.txt + key
                                src        : act.ico
                                style      :
                                    height     : @height_ico * (siz + 1 ) / 2
                                onmousedown: ( evt ) =>
                                    act.fun evt, @tree_app
            
                new_dom_element
                    parentNode : block
#                     nodeName   : "br"
                        
                module_title = new_dom_element
                        parentNode : block
                        nodeName   : "span"
                        className  : "module_title"
                        txt        : m.name
                        
