# -> creates a _can_be_computed attribute which can be used e.g. by the server to know if there's something to update
class TreeItem_Computable extends TreeItem
    constructor: ->
        super()
        
        # attributes
        @add_attr
            _computation_req_date: 1 # request date (updated by the @bind hereafter)
            _computation_rep_date: 0 # response date (updated by the server after each computation)
            _computation_mode    : 2 # 2 -> auto. 1 -> do it. 0 -> stop
            _messages            : []

        # incrementation of _computation_req_date each time there's a "real" change
        @bind =>
            if @real_change()
                if @_computation_req_date.has_been_modified() # in this round
                    return
                if @_computation_rep_date.has_been_modified() # in this round
                    return
                @_computation_req_date.add 1

    cosmetic_attribute: ( name ) ->
        name in [ "_computation_req_date", "_computation_rep_date", "_messages" ]

    nothing_to_do: ->
        @_computation_req_date.get() == @_computation_rep_date.get()

    manual_mode: ->
        @_computation_mode.get() in [ 0, 1 ]
        