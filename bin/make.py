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
