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



# return a child inst of ModelEditorItem, with type in adequation with $model
# @see ModelEditor.get_item_type_for
# Mandatory params:
#  - el
#  - model
# Optionnal params:
#  - name -> attribute name
#  - label -> attribute name used for the display
#  - parent
#  - call_onchange
#  - item_width
#  - label_ratio
#  - focus -> a Val representing the view_id of the focused view
#  - undo_manager
#  - closed_models (Lst)
#  - item_type
#  - class_name
new_model_editor = ( params ) ->
    # if we only want to display a sub item
    sub_model = params.model.disp_only_in_model_editor?()
    if sub_model?
        n_params = {}
        for key, val of params
            n_params[ key ] = val
        n_params.model = sub_model
        return new_model_editor n_params
        
    # find an item type
    TI = ModelEditorItem.get_item_type_for params
    return new TI params

    
    