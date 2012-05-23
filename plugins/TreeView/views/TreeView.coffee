#
# @selected is a list of paths
#
class TreeView extends View
    constructor: ( @el, @roots, @selected = new Lst, @visible = new Model, @closed = new Lst, @visibility_context ) ->
        if not @visibility_context?
            @visibility_context = new Str "default_visibility_context"
        if not @visible[ @visibility_context.get() ]?
            @visible.add_attr @visibility_context.get(), new Lst
            
        super [ @roots, @closed, @selected, @visible, @visibility_context ]

        # prefix for class names
        @css_prefix = ""
        
        # used by the default make_line method
        @icon_width = 16
        
        #
        @line_height = 16
        
        # use when there is multiple instance of the same object in the tree
        @index_color_for_tree = 0
        
        # kind of tab space for indentation of tree items
        @sep_x = @line_height * 4 / 4
        
        # div to show where items are inserted (drag and drop / ...)
        @_line_div = new_dom_element
            className: @css_prefix + "TreeLine"
            style    :
                position: "absolute"
                height  : 2
                right   : 0

        # used to destroy elements from previous rendering
        @_created_elements = []
        
        # used to link model_id of tree item to dom
        @linked_id_dom = {}
        
    @default_types: [
        # 0 is in directory
    ]
        
    # may be redefined depending on how the user want to construct the graph. Return the children of item
    get_children_of: ( item ) ->
        item._children
        
    # may be redefined depending on how the user want to construct the graph. Return the children of item
    get_output_of: ( item ) ->
        item._output
        
        #         tab = new Lst
        #         for output in item._output
        #             tab.push output
        #         for ch in item._children
        #             tab.push ch
        #         return tab

    # may be redefined
    insert_child: ( par, pos, chi ) ->
        if not par._children?
            par.add_attr _children: []
        par._children.insert pos, [ chi ]

    # may be redefined depending on how the user want to construct the graph. Return the children of item
    get_viewable_of: ( item ) ->
        return item._viewable

    # may be redefined depending on how the user want to display items. Return the children of item
    get_name_of: ( item ) ->
        return item._name

    # may be redefined depending on how the user want to display items. Return the children of item
    get_name_class_of: ( item ) ->
        return item._name_class

    # may be redefined depending on how the user want to display items.
    get_ico_of: ( item ) ->
        return item._ico

    # called each time there's a change in the tree
    onchange: ->
        if @_need_render()
            @_update_repr()
            @_render()
            
        for el in @flat
            model = el.item
            if @linked_id_dom[ model.model_id ]?
                if @get_children_of( model )?.has_been_directly_modified()
                    dom_elem = @linked_id_dom[ model.model_id ]
                    dom_elem.classList.add "TreeJustModified"
                if @get_output_of( model )?.has_been_directly_modified()
                    dom_elem = @linked_id_dom[ model.model_id ]
                    dom_elem.classList.add "TreeJustModified"
                        
    #looking for duplication in tree
    _get_color_element: ( info ) ->
        col = "black"
        c = 0
        for elem, i in @flat
            if elem.item.equals info.item
                c++
            if c >= 2
                col = @_get_next_color_element()
                #TODO need to know if color of duplicate item is already choosen or not
        return col
        
        
    _get_next_color_element: ->
        tab = [ "lightSeaGreen" ] #, "orange", "lightGreen", "yellow", "lightPink"
        if @index_color_for_tree == tab.length - 1
            @index_color_for_tree = 0
        else
            @index_color_for_tree++
        return tab[ @index_color_for_tree ]
        
        
    _render: ->
            
        # remove old elements
        for c in @_created_elements
            @el.removeChild c
        @_created_elements = []
        @linked_id_dom = {}
        pos_y = 0
        
        # draw header
        @height_header = @line_height + 3
        inspector = new_dom_element
            nodeName  : "div"
            className : "HeaderTreeView"
            parentNode: @el
            txt       : "Scene"
            style     :
                height  : @height_header
        pos_y += @height_header
        @_created_elements.push inspector
        
        @treeContainer = new_dom_element
            nodeName  : "div"
            id        : "ContainerTreeView"
            parentNode: @el
        @_created_elements.push @treeContainer
        
        
        for info in @flat
            do ( info ) =>
                div = new_dom_element
                    parentNode: @treeContainer
                    className : @css_prefix + "TreeView"
                    my_item   : info # this is really bad, but necessary for external drag and drop
                    style     :
                        position: "absolute"
                        top     : pos_y
                        height  : @line_height
                        left    : 0
                        right   : 0
                        overflow: "hidden"
                        color   : @_get_color_element info
                    
                    #                     onmousedown: ( evt ) =>
                    #                         evt = window.event if not evt?
                    # 
                    #                         mouse_b = if evt.which?
                    #                             if evt.which > 2
                    #                                 "LEFT"
                    #                             else if evt.which == 2 
                    #                                 "MIDDLE"
                    #                             else
                    #                                 "RIGHT"
                    #                         else
                    #                             if evt.button < 2
                    #                                 "LEFT"
                    #                             else if evt.button == 4 
                    #                                 "MIDDLE"
                    #                             else
                    #                                 "RIGHT"
                    #                         
                    #                         if mouse_b == "RIGHT"
                    #                             evt.stopPropagation()
                    #                             evt.cancelBubble = true
                    #                             # ... rien ne marche sous chrome sauf document.oncontextmenu = => return false 
                    #                             document.oncontextmenu = => return false
                    
                    onclick: ( evt ) =>
                        if evt.ctrlKey
                            @selected.toggle info.item_path
                        else
                            @selected.clear()
                            @selected.push info.item_path
                        return true
                            
                    draggable: true
                
                    ondragstart: ( evt ) =>
                        @drag_info = info
                        @drag_kind = if evt.ctrlKey then "copy" else "move"
                        evt.dataTransfer.effectAllowed = @drag_kind
                        evt.dataTransfer.setData('text/plain', '') #mozilla need data to allow drag
        
                    ondragend: ( evt ) =>
                        if @_line_div.parentNode == @el
                            @el.removeChild @_line_div
                        evt.returnValue = false
                        return false
                        
                    ondragover: ( evt ) =>
                        for num in [ info.path.length - 1 .. 0 ]
                            par = info.path[ num ]
                            if @_accept_child par, @drag_info
                                # by default, add after the first parent that accepts @drag_info
                                n = par.num_in_flat
                                # but if tries to insert into th the children of par if possible
                                if num + 1 < info.path.length
                                    bar = info.path[ num + 1 ]
                                    n = bar.num_in_flat + @_nb_displayed_children( bar )
                                @_line_div.style.top  = @line_height * ( n + 1 ) + @height_header
                                @_line_div.style.left = @sep_x * ( num + 1 )
                                @el.appendChild @_line_div
                                break
                        evt.returnValue = false
                        return false
                        
                    ondragleave : ( evt ) =>
                        if @_line_div.parentNode == @el
                            @el.removeChild @_line_div
                        evt.returnValue = false
                        return false
        
                    ondrop : ( evt ) =>
                        #TODO how to not put 0
#                         r = TreeView.default_types[ 0 ]
#                         r evt, info
                        
                        for num in [ info.path.length - 1 .. 0 ]
                            par = info.path[ num ]
                            if @_accept_child par, @drag_info
                                if @drag_kind == "move" and @drag_info.parents.length
                                    p = @drag_info.parents[ @drag_info.parents.length - 1 ]
                                    @get_children_of( p.item )?.remove_ref @drag_info.item

                                n = 0
                                if num + 1 < info.path.length
                                    n = info.path[ num + 1 ].num_in_parent + 1
                                
                                @insert_child par.item, n, @drag_info.item
                                break
                            
                        evt.returnValue = false
                        evt.stopPropagation()
                        evt.preventDefault()
                        return false

                
                @linked_id_dom[ info.item.model_id ] = div
                
                
                if @selected.contains info.item_path
                    div.className += " #{@css_prefix}TreeSelected"
                else if @closed.contains( info.item_path ) and @_has_a_selected_child( info.item, info.item_path )
                    div.className += " #{@css_prefix}TreePartiallySelected"
                    
#                 @_created_elements.push div
                pos_y += @line_height
                
                @_add_tree_signs div, info
                @_make_line      div, info
                

    #
    _add_tree_signs: ( div, info ) ->
        pos_x = 0
        
        for p in info.parents
            if p.num_in_parent < p.len_sibling - 1
                new_dom_element
                    parentNode: div
                    nodeName  : 'span'
                    className : @css_prefix + "TreeIcon_tree_cnt"
                    style:
                        position: "absolute"
                        top     : 0
                        left    : pos_x
                        width   : @sep_x
                        height  : @line_height
            pos_x += @sep_x
        
        tc = @css_prefix + "TreeIcon_tree"
        num_i = info.num_in_parent
        len_i = info.len_sibling
        if len_i == 1
            tc += "_end"
        else if num_i == 0 and info.path.length == 1
            tc += "_beg"
        else if num_i < len_i - 1
            tc += "_mid"
        else
            tc += "_end"
        if @get_children_of( info.item )?.length
            if @closed.contains info.item_path
                tc += "_add"
            else
                tc += "_sub"
        
        # the * - | sign
        new_dom_element
            parentNode : div
            className  : tc
            nodeName   : 'span'
            onmousedown: ( evt ) =>
                @closed.toggle info.item_path
            style:
                position: "absolute"
                top     : 0
                left    : pos_x
                width   : @sep_x
                height  : @line_height

    #
    _make_line: ( div, info ) ->
        pos_x = @sep_x * info.path.length
        
        # icon
        ico = @get_ico_of( info.item )?.get()
        if ico?.length
            new_dom_element
                parentNode : div
                nodeName   : 'img'
                src        : ico
                alt        : ""
                style      :
                    position : "absolute"
                    top      : 0
                    left     : pos_x
                    height   : @line_height
            
            pos_x += @line_height # * 12 / 16
            
        name = new_dom_element
            parentNode: div
            txt       : info.name
            className : info.name_class
            style     :
                position: "absolute"
                top     : 0
                height  : @line_height
                left    : pos_x
                right   : 0
#             onclick: =>
#                 name.contentEditable = true

        if info.is_an_output
            name.style.textAlign = "right"
            name.style.right = "20px"
                
                
        # visibility
        if @get_viewable_of( info.item )?.toBoolean()
            new_dom_element
                parentNode : div
                className  : if info.item in @visible[ @visibility_context.get() ] then @css_prefix + "TreeVisibleItem" else @css_prefix + "TreeHiddenItem"
                onmousedown: ( evt ) =>
                    #if not info.get "user_cannot_change_visibility"
                    if info.item._allow_vmod? == false or info.item._allow_vmod.get()
                        @visible[ @visibility_context.get() ].toggle_ref info.item
                style      :
                    position: "absolute"
                    top     : 0
                    right   : 0
                
                
    #        
    _update_repr: ->
        @flat = []
        @repr = for num_item in [ 0 ... @roots.length ]
            @_update_repr_rec @roots[ num_item ], num_item, @roots.length, []
        
    _update_repr_rec: ( item, number, length, parents, output = false ) ->
        info =
            item         : item
            name         : @get_name_of( item ).get()
            name_class   : @get_name_class_of( item )?.get() or ""
            num_in_parent: number
            len_sibling  : length
            children     : []
            outputs      : []
            parents      : parents
            path         : ( p for p in parents )
            item_path    : ( p.item for p in parents )
            num_in_flat  : @flat.length
            is_an_output : output

        info.path.push info
        info.item_path.push item
        
        @flat.push info

        if not @closed.contains( info.item_path )
            ch = @get_output_of( item )
            if ch?
                info.outputs = for num_ch in [ 0 ... ch.length ]
                    par = ( p for p in parents )
                    par.push info
                    @_update_repr_rec ch[ num_ch ], num_ch, ch.length, par, true

            ch = @get_children_of( item )
            if ch?
                info.children = for num_ch in [ 0 ... ch.length ]
                    par = ( p for p in parents )
                    par.push info
                    @_update_repr_rec ch[ num_ch ], num_ch, ch.length, par, false
                    
        return info
                
            
    # return true if need rendering after an onchange
    _need_render: ->
        if not @visible[ @visibility_context.get() ]?
            @visible.add_attr @visibility_context.get(), new Lst
            
        for i in [ @closed, @selected, @visible[ @visibility_context.get() ], @visibility_context ]
            if i.has_been_directly_modified()
                return true
        for item in @_flat_item_list()
            if item.has_been_directly_modified()
                return true
            if @get_children_of( item )?.has_been_directly_modified()
                return true
            if @get_output_of( item )?.has_been_directly_modified()
                return true
            if @get_viewable_of( item )?.has_been_directly_modified()
                return true
            if @get_name_class_of( item )?.has_been_modified()
                return true
        return false
    
    _has_a_selected_child: ( item, item_path ) ->
        if @get_children_of( item )?
            for c in @get_children_of( item )
                cp = ( p for p in item_path )
                cp.push c
                if @selected.contains cp
                    return true
                if @_has_a_selected_child c, cp
                    return true
        return false

    _nb_displayed_children: ( info ) ->
        res = 0
        for c in info.children
            res += 1 + @_nb_displayed_children( c )
        return res
        
    _accept_child: ( parent, source ) ->
        return source? and ( source not in parent.parents ) and parent.item.accept_child?( source.item )

    _flat_item_list: ->
        res = []
        for item in @roots
            @_flat_item_list_rec res, item
        return res
        
    _flat_item_list_rec: ( res, item ) ->
        res.push item
        if @get_output_of( item )?
            for c in @get_output_of( item )
                @_flat_item_list_rec res, c
        if @get_children_of( item )?
            for c in @get_children_of( item )
                @_flat_item_list_rec res, c
        