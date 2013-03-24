# something which has to be synchronized with one or several model(s)
#
# Each view has an uniquer id called "view_id"
class View
    @r__cur_view_id: 0
    
    # m can be a model or a list of models
    constructor: ( m, onchange_construction = true ) ->
        #
        @view_id = View.__cur_view_id
        View.__cur_view_id += 1
        
        # what this is observing
        @__models = []
        
        # bind
        if m instanceof Model
            m.bind this, onchange_construction
        else if m.length?
            for i in m
                i.bind this, onchange_construction
        else if m?
            console.error "View constructor doesn't know what to do with", m

    #
    destructor: ->
        for m in @__models
            i = m.__views.indexOf this
            if i >= 0
                m.__views.splice i, 1


    # called if at least one of the corresponding models has changed in the previous round
    onchange: ->



# bind model or list of model to function or view v
# (simply call the bind method of Model)
bind = ( m, v ) =>
    if m instanceof Model
        m.bind v
    else
        for i in m
            i.bind v
