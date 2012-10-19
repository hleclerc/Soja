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



class TreeAppModule extends Model
    constructor: ->
        super()
        
        @name    = ''      # indicate the module name
        @visible = true # all module can be hidden from menu by setting this to false
        @actions = []   # list of actions depending of the module

        # actions is assumed to be formatted like this :
        #     ico: path to a picture
        #     siz: a number that indicates the icon size
        #     txt: contain a string with the text of the action
        #     key: [ "Ctrl+Z" ] # example of how to assign hotkeys to an action
        #     ina: function that returns true if actions is inactive, false if active
        #     vis: boolean that indicates if action is shown in menu or not
        #     fun: function that is executed when icon is pressed or hotkey detected ( except if action is inactive or got sub actions (function is reassigned ) )
        #     mod: a model
        #     ord: boolean true by default that indicates if icon must be alternated on top and bottom
        #     sub:
        #        prf: prefered views ( 'menu' or 'list' )
        #        act: an array that can contain another actions


    select_item: ( app_data, item, parent ) ->
        if !parent
            path = []
            path.push app_data.selected_session()
        else
            path = app_data.get_root_path_in_selected parent
        path.push item
        @unselect_all_item app_data
        app_data.selected_tree_items.push path

    unselect_all_item: ( app_data ) ->
        app_data.selected_tree_items.clear()

    watch_item: ( app_data, item ) ->
        app_data.watch_item item
            
    get_animation_module: ( app ) ->
        for child in app.data.modules
            if child instanceof TreeAppModule_Animation
                return child
        
    get_display_settings_item: ( app ) ->
        for child in app.data.tree_items[ 0 ]._children
            if child instanceof DisplaySettingsItem
                return child


#     #search for typeItem in selected_tree return item if find
#     is_item_in_selected_tree: ( app, typeItem ) ->
#         items = app.data.get_selected_tree_items()
#         for it in items
#             if it instanceof typeItem
#                 return it
#                 
#         return false
    
    
    # this function is used to create item on the right tree place
    # typeItem represent the type of item you want to use
    add_item_depending_selected_tree: ( app_data, typeItem ) ->
        items = app_data.get_selected_tree_items()
        # search for typeItem in tree
        find_object = false
        #         for it in items
        #             if it instanceof typeItem
        #                 object = it
        # #                 console.log '1'
        #                 find_object = true
        
        # search if typeItem can be a child of the selected item in tree
        if find_object == false
            for it in items
                item = new typeItem
                if it.accept_child? item
                    # If he already have a typeItem child
                    #                     for child_item in it._children
                    #                         if child_item instanceof typeItem
                    #                             object = child_item
                    #                             @select_item app_data, object, it
                    # #                             console.log '2'
                    #                             find_object = true
                            
                    # Else create a child
                    if find_object == false
                        object = item
                        it.add_child object
                        
                        @select_item app_data, object, it
                        @watch_item app_data, object
                        
#                         app.undo_manager.snapshot()
#                         console.log '3'
                        find_object = true

        #search if typeItem can be a child of the parent of selected item in tree        
        if find_object == false
            for items in app_data.selected_tree_items
                parent = items[ items.length - 2 ]
                item = new typeItem
                if parent instanceof typeItem
                    object = parent
                    find_object = true
        
        #If selection didn't help to find a typeItem child
        if find_object == false
            object = new typeItem
            session = app_data.selected_session()
            session.add_child object
            
            @select_item app_data, object
            @watch_item app_data, object
#             console.log '4'
#             app.undo_manager.snapshot()
            
        return object
        
                                
    # typeItem represent the type of current item
    child_in_selected: ( app, typeItem, sel_item, item ) ->
        current = new typeItem
    
        for it in sel_item
            if current.accept_child it
                app.data.selected_tree_items[ 0 ][ app.data.selected_tree_items[ 0 ].length - 2 ].rem_child it
                item.add_child it
                id = it.model_id
                for p in app.data.panel_id_list()
                    for c, i in app.data.visible_tree_items[ p ]
                        if c.model_id == id
                            app.data.visible_tree_items[ p ].splice i, 1
                            break

        