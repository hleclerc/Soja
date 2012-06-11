# Rolling view of a choice model
class ModelEditorItem_Choice_Roll extends ModelEditorItem
    constructor: ( params ) ->
        super params
        
        @line_height = 30 # enough to contain the text
        
        @container = new_dom_element
            parentNode: @ed
            nodeName  : "span"
            className : "ModelEditorChoiceRoll"
            onclick   : ( evt ) =>
                @snapshot()
                @model.set ( @model.num.get() + 1 ) % @model._nlst().length
                evt.stopPropagation?()
            style:
                color     : "rgba(0,0,0,0)"
                display   : "inline-block"
                width     : @ew + "%"

        @window = new_dom_element
            parentNode: @container
            className : "ModelEditorChoiceRollWindow"
            txt       : "."
                
        @_cl = []

    onchange: ->
        if @model.lst.has_been_modified() or @_cl.length == 0
            for i in @_cl
                i.parentNode.removeChild i
            @_cl = []
                
            cpt = 0
            for i in @model._nlst()
                @_cl.push new_dom_element
                    parentNode : @window
                    txt        : i.get()
                    value      : cpt
                    style      :
                        position : "absolute"
                        left     : 0
                        right    : 0
                        top      : @line_height * cpt + "px"
                    
                cpt += 1
        
        @window.style.top = - @line_height * @model.num.get() + "px" # this modify element.style and not ModelEditorChoiceRollWindow, so nice transition doesn't apply
 
            