# Browsing and dnd
class ModelEditorItem_Directory extends ModelEditorItem
    # @see add_action
    @_action_list : 
        "Directory": [
            ( file, path, browser ) -> 
                browser.load_folder file
        ]
        # others type can be added by other files

    constructor: ( params ) ->
        super params
        
        @breadcrumb = new Lst
        @breadcrumb.push @model
        
        
        @selected_file = new Lst
        @clipboard     = new Lst # contain last 'copy' or 'cut' file
        
            
        @breadcrumb.bind this
        @selected_file.bind this
        @clipboard.bind this
        
        
        @allow_shortkey = true # allow the use of shortkey like Ctrl+C / Delete. Set to false when renaming
        
        @line_height = 30 # enough to contain the text
        
        
        @container = new_dom_element
                parentNode: @ed                
                nodeName  : "div"
                ondragover: ( evt ) =>
                    return false
                ondragleave: ( evt ) =>
                    return false
                ondrop: ( evt ) =>
                    evt.stopPropagation()
                    evt.preventDefault()
                    @handle_files evt.dataTransfer.files
                    return false
                        
        @icon_scene = new_dom_element
                parentNode: @container
                nodeName  : "div"
                className : "icon_scene"
                
        @icon_up = new_dom_element
                parentNode: @icon_scene
                nodeName  : "img"
                src       : "img/parent.png"
                alt       : "Parent"
                title     : "Parent"
                onclick: ( evt ) =>
                    # watching parent
                    @load_model_from_breadcrumb @breadcrumb.length - 2
                    
        @icon_new_folder = new_dom_element
                parentNode: @icon_scene
                nodeName  : "img"
                src       : "img/add_folder.png"
                alt       : "New folder"
                title     : "New folder"
                onclick: ( evt ) =>
                    n = new File "New folder", 0
                    n._info.add_attr
                        icon: "folder"
                        model_type: "Directory"
                        
                    @model.push n
#                     @refresh()
                    
        @icon_cut = new_dom_element
                parentNode: @icon_scene
                nodeName  : "img"
                src       : "img/cut.png"
                alt       : "cut"
                title     : "Cut"
                onclick: ( evt ) =>
                    @cut()
                    
        @icon_copy = new_dom_element
                parentNode: @icon_scene
                nodeName  : "img"
                src       : "img/copy.png"
                alt       : "copy"
                title     : "Copy"
                onclick: ( evt ) =>
                    @copy()
                    
        @icon_paste = new_dom_element
                parentNode: @icon_scene
                nodeName  : "img"
                src       : "img/paste.png"
                alt       : "paste"
                title     : "Paste"
                onclick: ( evt ) =>
                    @paste()

        @icon_del_folder = new_dom_element
                parentNode: @icon_scene
                nodeName  : "img"
                src       : "img/trash.png"
                alt       : "Delete"
                title     : "Delete"
                onclick: ( evt ) =>
                    @delete_file()
                ondragover: ( evt ) =>
                    return false
                ondrop: ( evt ) =>
                    @delete_file()
                    evt.stopPropagation()
                    return false
        
        @upload_form = new_dom_element
                parentNode: @icon_scene
                nodeName  : "form"
                
        @txt_upload = new_dom_element
                parentNode: @icon_scene
                nodeName  : "span"
                txt       : "Add new file(s) "
                
        @upload = new_dom_element
            parentNode: @icon_scene
            nodeName  : "input"
            type      : "file"
            multiple  : "true"
            onchange  : ( evt ) =>
                @handle_files @upload.files
                                
        
        @breadcrumb_dom = new_dom_element
                parentNode: @container                
                nodeName  : "div"
                    
        @all_file_container = new_dom_element
                parentNode: @container
                nodeName  : "div"

        
        key_map = {
            8 : ( evt ) => # backspace
                @load_model_from_breadcrumb @breadcrumb.length - 2
                        
            13 : ( evt ) => # enter
                if @selected_file.length > 0
                    for ind_sel_file in @selected_file.get()
                        index = @search_ord_index_from_id ind_sel_file
                        @open @model[ index ], @path()
                
            37 : ( evt ) => # left
                if @selected_file.length > 0
                    if evt.shiftKey
                        index_last_file_selected = @selected_file[ @selected_file.length - 1 ].get()
                        
                        if not @reference_file?
                            @selected_file.clear()
                            @selected_file.push index_last_file_selected
                            @reference_file = index_last_file_selected
                        
                        if index_last_file_selected > 0
                            if index_last_file_selected <= @reference_file
                                @selected_file.push index_last_file_selected - 1
                            else
                                @selected_file.pop()
                    else
                        ind = @selected_file[ @selected_file.length - 1 ].get()
                        if ind != 0
                            @selected_file.clear()
                            @selected_file.push ind - 1
                        else
                            @selected_file.clear()
                            @selected_file.push 0
                            
                        @reference_file = undefined
                
                # case no file is selected
                else
                    @selected_file.push 0 
                    @reference_file = undefined
                
            38 : ( evt ) => # up
                if evt.altKey
                    @load_model_from_breadcrumb @breadcrumb.length - 2
                
            39 : ( evt ) => # right
                if @selected_file.length > 0
                    if evt.shiftKey
                        index_last_file_selected = @selected_file[ @selected_file.length - 1 ].get()
                        if not @reference_file?
                            @selected_file.clear()
                            @selected_file.push index_last_file_selected
                            @reference_file = index_last_file_selected
                        
                        if index_last_file_selected < @model.length - 1
                            if index_last_file_selected >= @reference_file
                                @selected_file.push index_last_file_selected + 1
                            else
                                @selected_file.pop()
                    else
                        ind = @selected_file[ @selected_file.length - 1 ].get()
                        if ind < @model.length - 1
                            @selected_file.clear()
                            @selected_file.push ind + 1
                        else
                            @selected_file.clear()
                            @selected_file.push @model.length - 1
                        @reference_file = undefined
                # case no file is selected
                else
                    @selected_file.push 0 
                    
                
            40 : ( evt ) => # down
                if evt.altKey
                    if @selected_file.length > 0
                        for ind_sel_file in @selected_file.get()
                            index = @search_ord_index_from_id ind_sel_file
                            @open @model[ index ], @path()
                
            65 : ( evt ) => # A
                if evt.ctrlKey # select all
                    @selected_file.clear()
                    for child, i in @model
                        @selected_file.push i
                    
            88 : ( evt ) => # X
                if evt.ctrlKey # cut
                    @cut()
                
            67 : ( evt ) => # C
                if evt.ctrlKey # copy
                    @copy()
                
            86 : ( evt ) => # V
                if evt.ctrlKey # paste
                    @paste()
                
            46 : ( evt ) => # suppr
                @delete_file()
                
            113 : ( evt ) => # F2
                file_contain = document.getElementsByClassName('selected_file')[ 0 ]?.getElementsByClassName('linkDirectory')
                if file_contain? and file_contain.length > 0
                    @rename_file file_contain[ 0 ], @model[ @search_ord_index_from_id @selected_file[ 0 ].get() ]
                
#             116 : ( evt ) => # F5
#                 @refresh()
        }

        document.onkeydown = ( evt ) =>
            if @allow_shortkey == true
                if key_map[ evt.keyCode ]?
                    evt.stopPropagation()
                    evt.preventDefault()
                    key_map[ evt.keyCode ]( evt )
                    return true

    
    cut: ->
        if @selected_file.length > 0
            @clipboard.clear()
            for ind_children in @selected_file.get()
                real_ind = @search_ord_index_from_id ind_children
                @clipboard.push @model[ real_ind ]
            @cutroot = @model
            
    copy: ->
        if @selected_file.length > 0
            @clipboard.clear()
            for ind_children in @selected_file.get()
                real_ind = @search_ord_index_from_id ind_children
                @clipboard.push @model[ real_ind ]
            @cutroot = undefined
            
    paste: ->
        if @cutroot?
            for mod in @clipboard.get()
                pos = @cutroot.indexOf mod
                if pos != -1
                    @cutroot.splice pos, 1
        for file in @clipboard
            new_file = file.deep_copy()
            @model.push new_file
        
        
    rename_file: ( file, child_index ) ->
        # start rename file
        @allow_shortkey = false
        file.contentEditable = "true"
        file.focus()
        # stop rename file
        file.onblur = ( evt ) =>
            @allow_shortkey = true
            title = file.innerHTML
            child_index.name.set title
            file.contentEditable = "false"
    
    onchange: ->
        console.log @selected_file, this
        if @selected_file.has_been_directly_modified()
            @draw_selected_file()
        if @model.has_been_modified() or @breadcrumb.has_been_modified()
            @refresh()

    refresh: ->
        @empty_window()
        @init()
        @draw_selected_file()

    empty_window: ->
        @all_file_container.innerHTML = ""
    
    load_folder: ( file ) ->
        @model.unbind this
        file._ptr.load ( m, err ) =>
            @model = m
            @model.bind this
            
            @breadcrumb.push file
            @selected_file.clear()
            
    open: ( file, path ) ->
        if file._info.model_type?
            l = ModelEditorItem_Directory._action_list[ file._info.model_type ]
            if l? and l.length
                l[ 0 ] file, path, this
    
    handle_files: ( files ) ->
        if files.length > 0
            if FileSystem?
                fs = FileSystem.get_inst()
                for file in files
                    # TODO: make a model of the correct type (containing a Path)
                    @model.add_file file.name, new Path file

    
    
    draw_breadcrumb: ->
        @breadcrumb_dom.innerHTML = ""
        for folder, i in @breadcrumb
            do ( i ) =>
                if i == 0
                    f = new_dom_element
                        parentNode: @breadcrumb_dom
                        nodeName  : "span"
                        className : "breadcrumb"
                        txt       : "Root"
                        onclick   : ( evt ) =>
                            @load_model_from_breadcrumb 0
                        
                else
                    l = new_dom_element
                        parentNode: @breadcrumb_dom
                        nodeName  : "span"
                        txt       : " > "
                        
                    f = new_dom_element
                        parentNode: @breadcrumb_dom
                        nodeName  : "span"
                        className : "breadcrumb"
                        txt       : folder.name
                        onclick   : ( evt ) =>
                            @load_model_from_breadcrumb i

            
    load_model_from_breadcrumb: ( ind ) ->
        if ind != -1
            @delete_breadcrumb_from_index ind
            if ind == 0
                @model = @breadcrumb[ 0 ]
            else
                @breadcrumb[ ind ]._ptr.load ( m, err ) =>
                    @model = m
        
    delete_breadcrumb_from_index: ( index ) ->
        for i in [ @breadcrumb.length-1 ... index ]
            @breadcrumb.pop()
    
    search_ord_index_from_id: ( id ) ->
        sorted = @model.sorted sort_dir
        for i in @model
            pos = @model.indexOf sorted[ id ]
            if pos != -1
                return pos
        
    sort_numerically = ( a, b ) ->
        return (a - b)
    
    delete_file: ->
        if @selected_file.length
            index_array = []
            for i in @selected_file.get()
                index = @search_ord_index_from_id i
                index_array.push index
            index_array.sort @sort_numerically
            
            for i in [ index_array.length - 1 .. 0 ]
                @model.splice index_array[ i ], 1
                
            @selected_file.clear()
            
    draw_selected_file: ->
        file_contain = document.getElementsByClassName 'file_container'
        for file, j in file_contain
            if parseInt(@selected_file.indexOf j) != -1
                add_class file, 'selected_file'
            else
                rem_class file, 'selected_file'
                
    cancel_natural_hotkeys: ( evt ) ->
        if not evt
            evt = window.event
        evt.cancelBubble = true
        evt.stopPropagation?()
        evt.preventDefault?()
        return false
        
    sort_dir = ( a, b ) -> 
    # following is commented because it doesn't sort item that are pasted
#         c = 0
#         d = 0
#         if b.data instanceof Directory
#             c = 1
#         if a.data instanceof Directory
#             d = 1
#         if d - c != 0
#             return 1
        if a.name.get().toLowerCase() > b.name.get().toLowerCase() then 1 else -1
    
    init: ->
#         console.log "---"
        sorted = @model.sorted sort_dir
#         console.log "init ",@model
#         console.log "sorted ",sorted

#         if @breadcrumb.length > 1
#             parent = new File Directory, ".."
#             sorted.unshift parent
            
        for elem, i in sorted
            do ( elem, i ) =>
            
                file_container = new_dom_element
                    parentNode: @all_file_container
                    nodeName  : "div"
                    className : "file_container"
                    
                    ondragstart: ( evt ) =>
                        if document.getElementById('popup_closer')?
                            @popup_closer_zindex = document.getElementById('popup_closer').style.zIndex
                            document.getElementById('popup_closer').style.zIndex = -1
                        
                        @drag_source = []
                        @drag_source = @selected_file.slice 0
                        if parseInt(@selected_file.indexOf i) == -1
                            @drag_source.push i
                        
                        evt.dataTransfer.effectAllowed = if evt.ctrlKey then "copy" else "move"
                        
                    ondragover: ( evt ) =>
                        return false
                        
                    ondragend: ( evt ) =>
                        if document.getElementById('popup_closer')?
                            document.getElementById('popup_closer').style.zIndex = @popup_closer_zindex
                    
                    ondrop: ( evt ) =>
                        # drop file got index = i
                        if sorted[ i ]._info.model_type.get() == "Directory"
#                             if sorted[ i ].name == ".."
#                                 @breadcrumb[ @breadcrumb.length - 2 ].push sorted[ ind ]
#                             else
                                # add selected children to target directory
                            for ind in @drag_source.get()
                                # sorted[ ind ] is the drop file source
                                # sorted[ i ]   is the drop file target
                                if sorted[ ind ] == sorted[ i ]
                                    return false
                                    
                                sorted[ i ]._ptr.load ( m, err ) =>
                                    m.push sorted[ ind ]
                                        
                            # remove selected children from current directory
                            for sorted_ind in @drag_source.get()
                                index = @search_ord_index_from_id sorted_ind
                                @model.splice index, 1
    
                            @selected_file.clear()
                        
                        @cancel_natural_hotkeys evt
                        
                    onmousedown : ( evt ) =>
                        if evt.ctrlKey
                            ind = parseInt(@selected_file.indexOf i)
                            if ind != -1
                                @selected_file.splice ind, 1
                            else
                                @selected_file.push i
                                
                        else if evt.shiftKey
                            if @selected_file.length == 0
                                @selected_file.push i
                            else
                                index_last_file_selected = @selected_file[ @selected_file.length - 1 ].get()
                                @selected_file.clear()
                                for j in [ index_last_file_selected .. i ]
                                    @selected_file.push j
                                
                        else
                            @selected_file.clear()
                            @selected_file.push i
                
                            
                # show correct icon/preview
                if elem._info.img?
                    @picture = new_dom_element
                        parentNode: file_container
                        className : "picture"
                        nodeName  : "img"
                        src       : elem._info.img.get()
                        alt       : elem.name.get()
                        title     : elem.name.get()
                        ondblclick: ( evt ) =>
                            @open sorted[ i ], @path()
                            @cancel_natural_hotkeys evt
                        width     : 128
                        height    : 128
                            
                            
                else if elem._info.icon?
                    @picture = new_dom_element
                        parentNode: file_container
                        className : "picture" + " " + "icon_" + elem._info.icon.get() + "_128"
                        title     : elem.name.get()
                        ondblclick: ( evt ) =>
                            @open sorted[ i ], @path()
                            @cancel_natural_hotkeys evt
                        width     : 128
                        height    : 128
                            
                else
                    @picture = new_dom_element
                        parentNode: file_container
                        nodeName  : "img"
                        src       : "img/unknown.png"
                        alt       : ""
                        title     : "" 
                        
                # stext write percent uploading
                stext = ""
                if elem._info?.remaining?.get()
                    r = elem._info.remaining.get()
                    u = elem._info.to_upload.get()
                    stext += "(#{ ( 100 * ( u  - r ) / u ).toFixed( 0 ) }%)"
                
                #Show file name
                text = new_dom_element
                    parentNode: file_container
                    className : "linkDirectory"
                    nodeName  : "div"
                    txt       : elem.name.get() + stext
                    onclick: ( evt ) =>
                        @rename_file text, sorted[ i ]
                        
                    
#                 else if elem._info.model_type.get() == "Img"
#                     @picture = new_dom_element
#                         parentNode: file_container
#                         className : "picture"
#                         nodeName  : "img"
#                         src       : elem.data._name
#                         alt       : ""
#                         title     : elem.data._name
#                         ondblclick: ( evt ) =>
#                             @open sorted[ i ], @path()
#                             @cancel_natural_hotkeys evt
#                             
#                     text = new_dom_element
#                         parentNode: file_container
#                         className : "linkDirectory"
#                         nodeName  : "div"
#                         txt       : elem.name.get() + stext
#                         onclick: ( evt ) =>
#                             @rename_file text, sorted[ i ]
#                 
#                 else if elem._info.model_type.get() == "Mesh"
#                     @picture = new_dom_element
#                         parentNode: file_container
#                         nodeName  : "img"
#                         src       : "img/unknown.png"
#                         alt       : ""
#                         title     : ""
#                         ondblclick: ( evt ) =>
#                             @open sorted[ i ], @path()
#                             @cancel_natural_hotkeys evt
#                             
#                             
#                     text = new_dom_element
#                         parentNode: file_container
#                         className : "linkDirectory"
#                         nodeName  : "div"
#                         txt       : elem.name.get() + stext
#                         onclick: ( evt ) =>
#                             @rename_file text, sorted[ i ]
#                             
#                 else if elem._info.model_type.get() == "Directory"
#                     @picture = new_dom_element
#                         parentNode: file_container
#                         nodeName  : "img"
#                         src       : "img/orange_folder.png"
#                         alt       : elem.name
#                         title     : elem.name
#                         ondblclick: ( evt ) =>
#                             @open sorted[ i ], @path()
#                             @cancel_natural_hotkeys evt
#                             
#                     text = new_dom_element
#                         parentNode: file_container
#                         className : "linkDirectory"
#                         nodeName  : "div"
#                         txt       : elem.name.get() + stext
#                         onclick: ( evt ) =>
#                             @rename_file text, sorted[ i ]
                            
                
        @draw_breadcrumb()
        
        # use for dropable area
        bottom = new_dom_element
            parentNode: @all_file_container
            nodeName  : "div"
            style:
                clear: "both"

                
    path: ->
        "test_need_to_be_complete"
    
    @add_action: ( model_type, fun ) ->
        if not ModelEditorItem_Directory._action_list[ model_type ]?
            ModelEditorItem_Directory._action_list[ model_type ] = []
        ModelEditorItem_Directory._action_list[ model_type ].push fun

# registering
ModelEditor.default_types.unshift ( model ) -> ModelEditorItem_Directory if model instanceof Directory
