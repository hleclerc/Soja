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



class EditView extends View
    constructor: ( @div, @app_data, @undo_manager ) ->
        super @app_data
        
        @model_editors = {}
        @div_icobar = {}
        @old_divs = []
        
        
    onchange: ->
        if @app_data.selected_tree_items.has_been_modified
            # remove old panel
            for d in @old_divs
                @div.removeChild d
            @old_divs = []
            for path in @app_data.selected_tree_items
                s = path[ path.length - 1 ]
                o = @model_editors[ s.model_id ]
                if not o?
                    # generic div to contain the model editor and the informations
                    o = new_dom_element()
                            
                    if not @div_icobar[ s.model_id ]?
                        @div_icobar[ s.model_id ] = new_dom_element
                            parentNode: o
                        for v in @app_data._views when v instanceof TreeApp
                            if s instanceof TreeItem_Computable
                                icobar = new IcoBar @div_icobar[ s.model_id ], v, bnd: true, loc: true
                            else
                                icobar = new IcoBar @div_icobar[ s.model_id ], v, bnd: false, loc: true
                            break
                    e = new_dom_element
                        parentNode: o
                        
                    m = new_model_editor
                        el          : e
                        model       : s
                        undo_manager: @undo_manager
                        focus       : @app_data.focus
                    
                    # information div
                    #if s.img?.information? #bad, should remove img and use sub_canvas_item
                    if s.information? #bad, should remove img and use sub_canvas_item
                        f = new_dom_element
                            nodeName  : "fieldset"
                            parentNode: e
                                
                        legend = new_dom_element
                            nodeName  : "legend"
                            parentNode: f
                            txt       : "Informations"
                            
                        d = new_dom_element parentNode: f
                        s.bind ->
                            #s.img?.information d
                            s.information d
                            
                    if s.img?.information? #bad, should remove img and use sub_canvas_item
                    #if s.information? #bad, should remove img and use sub_canvas_item
                        f = new_dom_element
                            nodeName  : "fieldset"
                            parentNode: e
                                
                        legend = new_dom_element
                            nodeName  : "legend"
                            parentNode: f
                            txt       : "Informations"
                            
                        d = new_dom_element parentNode: f
                        s.bind ->
                            s.img?.information d
                            #s.information d
                     
                    # information div
                    #if s._tfunc?.information? #bad, should remove img and use sub_canvas_item
                    #    f = new_dom_element
                    #        nodeName  : "fieldset"
                    #        parentNode: e
                    #            
                    #    legend = new_dom_element
                    #        nodeName  : "legend"
                    #        parentNode: f
                    #        txt       : "Informations"
                    #        
                    #    d = new_dom_element parentNode: f
                    #    s.bind ->
                    #        if s._tfunc.has_been_modified()
                    #          s._tfunc.information d
                        
                    @model_editors[ s.model_id ] = o
                    
                @div.appendChild o
                @old_divs.push o
                
      