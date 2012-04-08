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
tests_dir = "tests"
for p in os.listdir( tests_dir ):
    if p[ 0 ] == ".":
        continue
    if not p.endswith( ".coffee" ):
        continue
    ra = p.replace( ".coffee", "" )
    ba = "gen/" + ra
    js = ba + ".js"
    ht = ba + ".html"
    libs = concat_js( tests_dir + "/" + p, js )
    libs.append( js )
    html = file( ht, "w" )
    print 'html ouput ->', ht
    
    print >> html, '<html> '
    print >> html, '  <head> '
    print >> html, '    <title>__' + ba + '__</title>'
    print >> html, '    '
    for l in libs:
        l = l[ 4: ] # we remove gen/
        if l.endswith( ".css" ):
            print >> html, '    <link type="text/css" href="' + l + '" rel="stylesheet"/>'
        if l.endswith( ".js" ):
            print >> html, '    <script type="text/javascript" src="' + l + '"></script>'
    print >> html, '    '
    print >> html, '  <body onload="' + ra + '()"> '
    print >> html, '  </body> '
    print >> html, '</html>'


# minify in "min"
# for o in os.listdir( "gen" ):
#     exec_cmd( "mkdir -p min; slimit -m < gen/" + o + " > min/" + o )
