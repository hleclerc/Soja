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



class TreeAppModule_ImageSet extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'Image'
        @visible = true # must be set to false after test
        @numpic = 1
        
        @actions.push
            ico: "img/shooting_32.png"
            siz: 1
            txt: "New Shooting"
            fun: ( evt, app ) =>
                #
                app.undo_manager.snapshot()
                @collection = new ShootingItem app
                
                session = app.data.selected_session()
                session._children.push @collection
                @unselect_all_item app.data
                @select_item app.data, @collection
                @watch_item app.data, @collection
                
                
        @actions.push
            ico: "img/add_pic_24.png"
            siz: 1
            txt: "Add Image"
            fun: ( evt, app, img ) =>
                app.undo_manager.snapshot()
                @collection = @add_item_depending_selected_tree app.data, ImgSetItem
                if not img?
                    #                     tab = [ "explo_dz.png", "explo_in.png", "explo_re.png" ]
                    #                     console.log @numpic
                    #                     console.log tab[ @numpic ]
                    #                     img = new ImgItem tab[ @numpic ], app
                    #                                         if @numpic%2 == 1
                    #                                             img = new ImgItem "left.png", app
                    #                                         else
                    #                                             img = new ImgItem "right.png", app
#                     FileSystem.get_inst().load "/home/monkey/sessions/spirale.jpg", ( m, err ) =>
#                         img = new ImgItem "/sceen/_?u=" + m._server_id, app
#                         @collection.add_child img
                
                    if @numpic < 10
                        img = new ImgItem "composite0" + @numpic + ".png", app
                    else
                        img = new ImgItem "composite" + @numpic + ".png", app
                    @numpic += 2
                    
                @collection.add_child img
                
                app.data.time._max.set (if @collection._children.length - 1 > 0 then @collection._children.length - 1 else 0 )
                app.data.time._div.set app.data.time._max.get()
                
                #by default, show only the first
                if @collection._children.length == 1
                    app.data.time.set 0
                    
                @watch_item app.data, @collection
                app.fit()
                
            key: [ "Shift+A" ]

        @actions.push
            ico: "img/krita_24.png"
            siz: 1
            txt: "New Collection"
            fun: ( evt, app ) =>
                #
                app.undo_manager.snapshot()
                @collection = new ImgSetItem
                
                session = app.data.selected_session()
                session._children.push @collection
                
                @unselect_all_item app.data
                @select_item app.data, @collection