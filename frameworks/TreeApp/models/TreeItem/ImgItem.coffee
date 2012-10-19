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



# wrapper Trre 
class ImgItem extends TreeItem
    constructor: ( file, app ) ->
        super()
        # attributes
        #@add_attr
        #    legend: new Legend( "Displacement X", false )
            
        @add_attr
            img: new Img file, app

        if file instanceof Str
            @_name.set file.replace( /// ^.*/ ///, "" )
            
        @_ico.set "img/krita_16.png"
        @_viewable.set true
    
    accept_child: ( ch ) ->
        false
        
    sub_canvas_items: ->
        [ @img ] # , @legend
        
    # disp_only_in_model_editor: ->
    #     [ @img, @legend ]

    z_index: ->
        return @img.z_index()
        
    update_min_max: ( x_min, x_max ) ->
        @img.update_min_max x_min, x_max
        
    # use on directory when browsing
    get_file_info: ( info ) ->
        info.model_type = "Img"
        info.icon = "picture"
        