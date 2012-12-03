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



""" 
    This file is used to generate .js/.css files for src, tools and lib
 
    Additionnaly, it generate the .html code for the different tests (with dependencies)
"""
from concat_js import *

# main lib
concat_js( "src", "gen/Soja.js" )

# ext tools
for plugins_dir in [ "plugins", "tools", "frameworks" ]:
    for p in os.listdir( plugins_dir ):
        concat_js( plugins_dir + "/" + p, "gen/" + p + ".js", "gen/" + p + ".css" )
        
        
# tests
make_tests()

# minify in "min"
# for o in os.listdir( "gen" ):
#     exec_cmd( "mkdir -p min; slimit -m < gen/" + o + " > min/" + o )
