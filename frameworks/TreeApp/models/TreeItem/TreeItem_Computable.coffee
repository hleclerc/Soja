# -> creates a _can_be_computed attribute which can be used e.g. by the server to know if there's something to update
class TreeItem_Computable extends TreeItem
    constructor: ->
        super()
        
        # attributes
        @add_attr
            _can_be_computed : 3 # 0 / 1 / 2 / 3 respectively uncheck / manually computable / auto-computable which is calculated / auto-computable who needs to be calculated

        @bind =>
            if @real_change()
                if @_can_be_computed.has_been_modified()
                    return
                if @_can_be_computed.get() == 0
                    @_can_be_computed.set 1
                if @_can_be_computed.get() == 2
                    @_can_be_computed.set 3
