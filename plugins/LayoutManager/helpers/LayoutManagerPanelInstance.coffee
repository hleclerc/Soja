# exemple
class LayoutManagerPanelInstance
    constructor: ( @el, data, elem_kind = "div" ) ->
        @div = document.createElement elem_kind
        @div.style.position = "absolute"

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
        
    hide: ->
        if @div.parentNode == @el
            @el.removeChild @div
