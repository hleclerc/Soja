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



# link cam and picture
class ShootingItem extends TreeItem
    constructor: ( @app, @panel_id ) ->
        super()
        
        # attributes
        
                
        lst_view = new Lst
            
        @add_attr
            view : new Choice( 0, lst_view )
            cam  : new Cam
        @add_attr
            _cam_representation: new CamRepresentation @cam
            
            #
        
#         for el in @app.treeview.flat
#             if el.item instanceof DisplaySettingsItem
#                 bind el.item, =>
#                     @view.lst.clear()
#                     for el in @app.treeview.flat
#                         if el.item instanceof ViewItem
#                             @view.lst.push @view.lst.length
#         
#         bind @view, =>
#             i = 0
#             for el in @app.treeview.flat
#                 if el.item instanceof ViewItem
#                     console.log @view.get()
#                     if i == @view.get()
#                         new_cam = el.cam
#                         @mod_attr @cam, new_cam
#                     i++
            
        
        # default values
        @_name.set "Shooting informations"
        @_ico.set "img/shooting_16.png"
        @_viewable.set true
        
#         @add_child new ViewItem app_data, panel_id
        @add_child new ImgSetItem

        
    accept_child: ( ch ) ->
        ch instanceof ImgItem or
        ch instanceof ImgSetItem or
        ch instanceof SketchItem or
        ch instanceof TransformItem
        
    sub_canvas_items: ->
        [ @_cam_representation ]

    z_index: ->
        0.1
        
    draw: ( info ) ->
        info.shoot_cam = @cam
        for c in @_children
            c.draw info
            
        if @cam == info.cam
            info.ctx.beginPath()
            info.ctx.fillStyle = "white"
            info.ctx.font = "10px Arial"
            info.ctx.textBaseline = 'top'
            info.ctx.textAlign = 'right'
            info.ctx.fillText "Shooting Cam " + @cam.model_id, info.w - 10 , 10
        delete info.shoot_cam