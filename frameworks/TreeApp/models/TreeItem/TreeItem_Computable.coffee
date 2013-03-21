# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2012 Hugo Leclerc
#
# This file is part of Soda.
#
# Soda is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Soda is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with Soda. If not, see <http://www.gnu.org/licenses/>.



# -> creates a _can_be_computed attribute which can be used e.g. by the server to know if there's something to update
class TreeItem_Computable extends TreeItem
    constructor: ->
        super()
        
        # attributes
        @add_attr
            _computation_req_date: 1 # request date (updated by the @bind hereafter)
            _computation_rep_date: 0 # response date (updated by the server after each computation)
            _computation_mode    : false # true -> auto. false -> manual
            
            
            _ready_state         : true  # true -> nothing to compute, ready to be used in browser false -> server side is working
            _computation_state   : false # true -> do it. false -> dont do anything
            _pending_state       : false # true -> in queue for server updater
            _processing_state    : false # true -> server updater is runnning. false -> server updater is not runnnings
            _finish_state        : false # true -> server updater is finish. false -> server updater is not finish
            _stop_state          : false # true -> kill server updater false -> dont do anything
            
            
            
            _messages            : []
        @add_attr
            auto_compute         : @_computation_mode

        # incrementation of _computation_req_date each time there's a "real" change
        @bind =>
            #             if @auto_compute.has_been_modified()
            #                 @_computation_mode.set @auto_compute.get() * 2
            #             else if @_computation_mode.has_been_modified()
            #                 @auto_compute.set @_computation_mode.get()                
            #                 
            if @real_change()
                if @_computation_req_date.has_been_modified() # in this round
                    return
                if @_computation_rep_date.has_been_modified() # in this round
                    return
                @_computation_req_date.add 1

    cosmetic_attribute: ( name ) ->
        name in [ "_computation_req_date", "_computation_rep_date", "_computation_mode", "_computation_state", "_messages", "auto_compute" ]

    nothing_to_do: ->
        @_computation_req_date.get() == @_computation_rep_date.get()

    manual_mode: ->
        @_computation_mode.get()

    do_it: ->
        TreeItem_Computable._do_it_rec this

    @_do_it_rec: ( obj ) ->
        if obj instanceof TreeItem_Computable
            obj._computation_state.set true
        for c in obj._children
           TreeItem_Computable._do_it_rec c
            
            