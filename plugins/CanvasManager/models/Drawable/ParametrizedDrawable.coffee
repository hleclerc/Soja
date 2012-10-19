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



# Interface to an object the contains 
#   - a method draw which takes ( info )
#   - a method get_drawing_parameters which permits  to complete the model attributes
class ParametrizedDrawable extends Drawable
    constructor: ( data ) ->
        super()
        
        @add_attr
            # drawing_parameters: ... -> filled after
            data: data

    draw: ( info, additionnal_parameters ) ->
        @_udpate_parameters_if_necessary()
        @data.draw info, @drawing_parameters, additionnal_parameters
        
    disp_only_in_model_editor: ->
        @drawing_parameters
        
    z_index: ->
        @data.z_index()
            
    _udpate_parameters_if_necessary: ->
        if not @drawing_parameters?
            @data.get_drawing_parameters this
    