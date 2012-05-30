# example
class LayoutManagerPanelInstance
    constructor: ( @el, data, title = "", elem_kind = "div" ) ->
        @div = document.createElement elem_kind
        @div.style.position = "absolute"
        @title = title
        
    destructor: ->
        @hide()

    render: ( info, offset = 0 ) ->
        @el.appendChild @div
        
        p_min = info.p_min
        p_max = info.p_max
        
        @div.style.left   = p_min[ 0 ] - offset
        @div.style.top    = p_min[ 1 ] - offset
        @div.style.width  = p_max[ 0 ] - p_min[ 0 ]
        @div.style.height = p_max[ 1 ] - p_min[ 1 ]
        
        
        if @title != "" and not @title_elem?
            @title_elem = new_dom_element
                nodeName  : "div"
                className : "Title"
                parentNode: @div
                txt       : @title
        
    hide: ->
        if @title_elem?.parentNode == @div
            @div.removeChild @title_elem
        if @div.parentNode == @el
            @el.removeChild @div
