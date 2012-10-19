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
class File extends Model
    constructor: ( name = "", ptr_or_model = 0, info = {} ) ->
        super()

        # 
        cp_info = {}
        for key, val of info
            cp_info[ key ] = val
        
        if ptr_or_model instanceof Model
            if not cp_info.model_type?
                cp_info.model_type = Model.get_object_class ptr_or_model
            ptr_or_model.get_file_info? cp_info

        #
        @add_attr
            name : name
            _ptr : new Ptr ptr_or_model
            _info: cp_info
                # -> img : "data/base64...."
                # -> icon: "toto"
                # -> model_type: "Directory"...
                # -> remaining
                # -> to_upload

    load: ( callback ) ->
        @_ptr.load callback
    
    
#     drop: ( evt, info ) ->
#         @handleFiles evt, info
#         evt.returnValue = false
#         evt.stopPropagation()
#         evt.preventDefault()
#         return false
#         
#     handleFiles: (event, info, files) -> 
#         if typeof files == "undefined" #Drag and drop
#             event.stopPropagation()
#             event.returnValue = false
#             event.preventDefault()
#             files = event.dataTransfer.files
#             
#         if event.dataTransfer.files.length > 0
#             for file in files 
#                 format = file.type.indexOf "image"
#                 if format isnt -1
#                     pic = new ImgItem file.name
#                     accept_child = info.item.accept_child pic
#                     if accept_child == true
#                         info.item.add_child pic
#                         info.item.img_collection.push pic
#                         
#             @sendFiles()
# TreeView.default_types.push ( evt, info ) -> 
#     d = new Directory
#     d.drop evt, info