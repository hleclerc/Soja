#
class TreeItem extends Model
    constructor: ->
        super()

        @add_attr
            _ico       : ""
            _name      : ""
            _children  : []
            _output    : []
            _viewable  : 0 # eye
            _allow_vmod: true # autorise check/uncheck view
            _name_class: ""

    # child must be an instance of TreeItem
    add_child: ( child ) ->
        @_children.push child

    # remove child, by ref or by num
    rem_child: ( child ) ->
        if child instanceof TreeItem
            for num_c in [ 0 ... @_children.length ]
                if @_children[ num_c ] == child
                    @_children.splice num_c, 1
                    return
        else
            @_children.splice child, 1
        
    # child must be an instance of TreeItem
    add_output: ( child ) ->
        @_output.push child

    # remove child, by ref or by num
    rem_output: ( child ) ->
        if child instanceof TreeItem
            for num_c in [ 0 ... @_output.length ]
                if @_output[ num_c ] == child
                    @_output.splice num_c, 1
                    return
        else
            @_output.splice child, 1
        
    draw: ( info ) ->
        if @sub_canvas_items?
            for s in @sub_canvas_items()
                s.draw info
            
    anim_min_max: ->
 
    z_index: ->
