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



# 
class TreeView_ModuleView extends View
    constructor: ( @el, @roots, @selected = new Lst, @visible = new Model, @closed = new Lst, @visibility_context, @tree_app ) ->
        
        super [ @roots, @selected, @visible, @closed, @visibility_context ]
        
        @treeview = new TreeView @el, @roots, @selected, @visible, @closed, @visibility_context
#         icobar = new IcoBar @el, @tree_app

#         @modules = @tree_app.data.modules
#         
#         @icon_container = new_dom_element
#                 nodeName  : "div"
#                 className : "FooterTreeView"
#                 parentNode: @el
#                 style:
#                     position: "absolute"
#                     top  : 19
#                     zIndex : 100
#         
#         @_render_loc_actions @el, @tree_app
#         
#     _render_loc_actions: ( @el, @tree_app ) ->
#         @el.appendChild @icon_container
#     
#         while @icon_container.firstChild?
#             @icon_container.removeChild @icon_container.firstChild
# 
#         for m in @modules
#             do ( m ) =>
#                 for act, j in m.actions when act.vis != false and act.loc == true
#                     do ( act ) =>
#                     
# #                         if act.ico
# #                             img/krita_24.png
#                         
#                         delet = new_dom_element
#                             nodeName  : "img"
#                             src       : act.ico
#                             className : "FooterTreeViewIcon"
#                             parentNode: @icon_container
#                             alt       : act.txt
#                             title     : act.txt
#                             onclick   : ( evt ) =>
#                                 act.fun evt, @tree_app

#             save = new_dom_element
#                 nodeName  : "img"
#                 src       : "img/save_24.png"
#                 className : "FooterTreeViewIcon"
#                 parentNode: footer
#                 alt       : "Save"
#                 title     : "Save"
#                 onclick   : =>
#                     for selected_tree_item_path in @selected
#                         selected_tree_item = selected_tree_item_path[ selected_tree_item_path.length - 1 ]
#                         console.log "saving : ", selected_tree_item
#                         if FileSystem?
#                             fs = FileSystem.get_inst()
#                             # we should ask for filename and path
#                             name = "my-item"
#                             fs.load "/tree_items", ( m, err ) ->
#                                 m.add_file name, new Path selected_tree_item, info.model_type "TreeItem"
                                