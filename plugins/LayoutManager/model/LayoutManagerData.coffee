#
class LayoutManagerData extends Model
    @_used_panel_id: []
    
    constructor: ( data = { panel_id: "id_0" } ) ->
        super()
        
        @add_attr
            root: data
    
        @_assign_default_values @root
    
    # get a flat list of panels with info, including size to fit in ( p_min, p_max )
    make_info: ( p_min, p_max, border_size ) ->
        lst = []
        obj = @_make_graph_rec lst, @root.get(), border_size
        @_make_sizes obj, p_min, p_max
        return lst
        
    # May be redefined to avoid destruction of particular panels (not by using undended). cf. "can_be_destroyed"
    allow_destruction: ( data ) ->
        return true

    #
    find_item_with_panel_id: ( id, data = @root ) ->
        if data.panel_id?.equals id
            return data
        if data.children?
            for c in data.children
                r = @find_item_with_panel_id id, c
                if r?
                    return r
        
    # find parent of the item with panel_id == id
    find_parent_of_panel_id: ( id, data = @root ) ->
        if data.children?
            for c in data.children
                if c.panel_id?.equals id
                    return data
                r = @find_parent_of_panel_id id, c
                if r?
                    return r
        
        
    # split. d = direction, s = up or down, id = panel_id, c = coeff
    # returns the new panel_id
    mk_split: ( d, s, id, c, new_panel_id = @_find_new_panel_id [] ) ->
        # @set_data @_remake_data_with_cut @repr, d, s, p, c, new_panel_id
        ch = @find_item_with_panel_id id
        
        od = ch.get() # JSON repr
        os = od.strength or 1
        nc = panel_id: new_panel_id
        lc = [ od, nc ]
        if not s
            lc.reverse()
        
        lc[ 0 ].strength = 0 + c
        lc[ 1 ].strength = 1 - c

        # ch will become a split
        ch.set
            sep_norm: d
            strength: os
            children: lc
            panel_id: @_find_new_panel_id [ new_panel_id ]

        return new_panel_id

    # p may be the panel_id or a point
    rm_panel: ( id ) ->
        if not @allow_destruction( id )
            return false
            
        ch = @find_item_with_panel_id id
        pa = @find_parent_of_panel_id id
        
        if pa.children.length == 2
            nn = 1 * ( pa.children[ 0 ] == ch )
            
            ci = pa.children[ nn ].get()
            ci.strength = pa.strength.get()
            
            pa.set ci
        else
            alert "TODO"
            
        return true

    # get a list with panel_id of visible panels
    panel_id_of_term_panels: ->
        res = []
        @_get_panel_id_of_term_panels res, @root
        return res

    # get a list with panel_id
    panel_ids: ->
        res = []
        @_get_panel_ids res, @root
        return res

    # make a graph
    _make_graph_rec: ( lst, data, border_size, orig = data ) ->
        # basic info
        repr =
            data    : data
            pan_mana: this
            sep_norm: data.sep_norm or 0
            border_s: if data.border_s? then data.border_s else border_size
            min_size: data.min_size or [ 0  , 0   ]
            max_size: data.max_size or [ 1e5, 1e5 ]
            selected: data.selected
            immortal: data.immortal
            strength: data.strength or 1
            panel_id: data.panel_id
            children: []
            parent  : undefined
            num_in_p: undefined # num in parent
            p_min   : undefined
            p_max   : undefined
            d_border: undefined # direction of associated internal border if any
            
            min_by: ( d ) ->
                l = @min_size[ d ]
                for c in @children
                   l = Math.max l, c.min_by d
                return l
            
            max_by: ( d ) ->
                l = @max_size[ d ]
                for c in @children
                   l = Math.min l, c.max_by d
                return l
                
            contains: ( p ) ->
                return p? and p[ 0 ] >= @p_min[ 0 ] and p[ 0 ] < @p_max[ 0 ] and p[ 1 ] >= @p_min[ 1 ] and p[ 1 ] < @p_max[ 1 ]
            
            can_be_destroyed: () ->
                if @immortal
                    return false
                for c in @children
                    if not c.can_be_destroyed()
                        return false
                if not @pan_mana.allow_destruction( data )
                    return false
                return true
        
        # recursion
        if data.children?.length
            for num_ci in [ 0 ... data.children.length ]
                ch = @_make_graph_rec lst, data.children[ num_ci ], border_size, orig
                repr.children.push ch
                ch.parent = repr
                ch.num_in_p = num_ci
                
            # d_border
            if repr.children.length
                for n in [ 0 ... repr.children.length - 1 ]
                    repr.children[ n ].d_border = repr.sep_norm

        lst.push repr
        return repr

    _make_sizes: ( repr, p_min, p_max ) ->
        repr.p_min = p_min
        repr.p_max = p_max
        
        if repr.children.length
            # get panel size / repr.sep_norm
            tot = p_max[ repr.sep_norm ] - p_min[ repr.sep_norm ]
            for num_ci in [ 0 ... repr.children.length - 1 ]
                tot -= repr.children[ num_ci ].border_s # total size[ repr.sep_norm ]
            
            sum = 0 # sum strength
            for c in repr.children
                sum += c.strength
            con = ( 0 for i in repr.children ) # constraints
            sep = ( 0 for i in repr.children ) # size[ repr.sep_norm ]
            
            # update sep
            while true
                end = true

                # get sizes / repr.sep_norm
                for n in [ 0 ... repr.children.length ]
                    if con[ n ]
                        continue
                    child = repr.children[ n ]
                    s = child.strength
                    if not repr.sep_norm?
                        alert "sep_norm is not defined"
                    d = Math.round tot * s / sum
                    
                    # min size ?
                    m = child.min_by repr.sep_norm
                    if d < m
                        d = m
                        tot -= m
                        end = false
                        con[ n ] = 1
                        sum -= s
                        
                    # max size ?
                    m = child.max_by repr.sep_norm
                    if d > m
                        d = m
                        tot -= m
                        end = false
                        con[ n ] = 1
                        sum -= s
                        
                    sep[ n ] = d
                
                # assign p_min, p_max
                if end
                    break

            # update p_... rec
            pos = p_min[ repr.sep_norm ]
            for num_ci in [ 0 ... repr.children.length ]
                n_min = [ p_min[ 0 ], p_min[ 1 ] ]
                n_max = [ p_max[ 0 ], p_max[ 1 ] ]
                n_min[ repr.sep_norm ] = pos
                n_max[ repr.sep_norm ] = pos + sep[ num_ci ]
            
                @_make_sizes repr.children[ num_ci ], n_min, n_max
                
                pos += sep[ num_ci ] + repr.children[ num_ci ].border_s
    
    # return true if id is in a panel_id of a panel or a sub panel
    _id_in_data_rec: ( cur, id ) ->
        if cur.panel_id?.equals id
            return true
        if cur.children?
            for chi in cur.children
                if @_id_in_data_rec chi, id
                    return true
        return false
        
    # find an new id for a (new) panel
    _find_new_panel_id: ( lst = [] ) ->
        trial = 0
        while true
            txt = "id_" + trial
            if lst.indexOf( txt ) < 0 and LayoutManagerData._used_panel_id.indexOf( txt ) < 0 and not @_id_in_data_rec( @root, txt )
                LayoutManagerData._used_panel_id.push txt
                return txt
            trial += 1

    # assign a panel_id in panels if not done
    _assign_default_values: ( cur ) ->
        # values
        if not cur.panel_id?
            cur.add_attr panel_id: new Str @_find_new_panel_id []
        if not cur.strength?
            cur.add_attr strength: 1
            
        # recursion
        if cur.children?
            for chi in cur.children
                @_assign_default_values chi
    
    _get_panel_id_of_term_panels: ( res, data ) ->
        if data.children?.length
            for c in data.children
                @_get_panel_id_of_term_panels res, c
        else
            res.push data.panel_id.get()
    
    _get_panel_ids: ( res, data ) ->
        res.push data.panel_id.get()
        if data.children?.length
            for c in data.children
                @_get_panel_ids res, c
            