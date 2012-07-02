#
class ModelEditorItem_TypedArray extends ModelEditorItem
    constructor: ( params ) ->
        super params
        
        @_ad = []
        @_size = []
        @_inputs = []
                
    onchange: ->
        # make the grid ?
        if not @_same_parms()
            @_size = @model.size()

            # remove the old model_editors
            for i in @_inputs
                @ed.removeChild i
            for i in @_ad
                @ed.removeChild i
            @_ad = []
                
            # if dim > 1 -> go to next line
            w = @ew / @model.size( 0 )
            if @model.dim() > 1
                w = 100 / @model.size( 0 )
                @_ad.push new_dom_element
                    parentNode: @ed
                    nodeName  : "span"
                    style     :
                        display: "inline-block"
                        width  : @ew + "%"
                
            #
            @_inputs = for i in [ 0 ... @model.nb_items() ]
                do ( i ) =>
                    input = new_dom_element
                        parentNode: @ed
                        type      : "text"
                        nodeName  : "input"
                        style     :
                            width: w + "%"
                        onchange  : =>
                            @snapshot()
                            @model.set_val i, input.value
                        onfocus   : =>
                            @get_focus()?.set @view_id
        
        # update data
        for input, i in @_inputs
            input.value = @model.get i
                            
            
    _same_parms: ->
        if @_size.length != @model.dim()
            return false
        for v, i in @_size
            if v != @model.size( i )
                return false
        return true
            

# 
ModelEditorItem.default_types.unshift ( model ) ->
    ModelEditorItem_TypedArray if model instanceof TypedArray
