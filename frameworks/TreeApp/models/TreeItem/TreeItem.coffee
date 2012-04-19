#
class TreeItem extends Model
    constructor: ->
        super()

        @add_attr
            _ico       : ""
            _name      : ""
            _children  : []
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
        

        
    # default draw method
    draw: ( info ) ->
        for i in @sub_canvas_items()
            i.draw info
            
    # should be redefine in some child
    anim_min_max: ->
        # do nothing
        
 
    z_index: ->
        # do nothing