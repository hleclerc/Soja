"""
Contains the function
  def concat_js( root_dir, output_js, output_cs = "", tmp_dir = ".gen" ):
  
which permits to compile and concatenate coffescript, js and css files present in root_dir or sub directories in output_...

It looks for dependencies in order to include files in the right order.

By default, if a .coffee or a .css contains "img/*.png" or "img/*.png", the string is replaced by an online representation (meaning that the files in img won't be needed)

It returns a list of dependencies if expressed as "# lib ..." or "# dep ..." in the source files. It is used to look which file is needed by which file but is not used to look for external files or to add files in the package.
"""
import os, re, sys, string

#
class File:
    def __init__( self, name, base ):
        self.name = name
        self.base = base
        self.prof = -1
        self.depe = []
        self.libs = []
        for l in file( name ).readlines():
            r = re.search( r'[#/] dep[ ]*(.*)[ ]*$', l )
            if r:
                self.depe.append( r.group( 1 ) )
            i = re.search( r'[#/] lib[ ]*(.*)[ ]*$', l )
            if i:
                self.libs.append( i.group( 1 ) )
            if name.endswith( ".coffee" ):
                r = re.search( r'extends (.*)', l )
                if r:
                    self.depe.append( r.group( 1 ).strip() + ".coffee" )
    def update_prof_rec( self, files, prof = 0 ):
        if self.prof < prof:
            self.prof = prof
            for d in self.depe:
                if d == self.base:
                    continue
                c = find_file( files, d )
                if c:
                    c.update_prof_rec( files, prof + 1 )

#
def find_file( files, base ):
    for c in files:
        if c.base == base:
            return c
    return 0

#    
def get_files( root ):            
    res = []
    if os.path.isdir( root ):
        for root, dirs, files in os.walk( root ):
            for f in files:
                if f[ 0 ] == ".":
                    continue
                res.append( File( root + "/" + f, f ) )
    else:
        res.append( File( root, os.path.basename( root ) ) )

    for f in res:
        f.update_prof_rec( res )
    return sorted( res, key = lambda x : -x.prof )

#
def app_code( out, inp, root_dir ):
    for l in file( inp ).readlines():
        # inline base64
        r = re.search(r'^(.*)(["\'])(img/.*\.png)["\'](.*)$', l ) # (img_src_[^ ]+).*# ([^ ]+)
        if r:
            beg = r.group( 1 )
            gui = r.group( 2 )
            img = r.group( 3 )
            end = r.group( 4 )
            
            # base64 data
            b = os.popen( "base64 -w 0 " + root_dir + "/" + img ).read()
            
            # mimetype
            kin = "png"
            if img.endswith( ".jpg" ) or img.endswith( ".jpeg" ):
                kin = "jpeg"
                
            out.write( beg + gui + "data:image/" + kin + ";base64," + b + gui + end + "\n" )
        else:
            out.write( l )
 
#
def exec_cmd( cmd ):
    print cmd
    if os.system( cmd ):
        sys.exit( 1 )
 
#
def mkdir_for( name ):
    l = string.split( name, "/" )
    for n in range( 1, len( l ) ):
        newdir = string.join( l[ 0 : n ], "/" )
        if not os.path.exists( newdir ):
            os.mkdir( newdir )

# see header description
def concat_js( root_dir, output_js, output_cs = "", tmp_dir = ".gen" ):
    out_js = None
    out_cs = None

    # concatenation
    if not os.path.exists( tmp_dir ):
        os.mkdir( tmp_dir )

    libs = []
    for r in get_files( root_dir ):
        if output_js:
            if r.name.endswith( ".coffee" ):
                if out_js == None:
                    mkdir_for( output_js )
                    out_js = file( output_js, "w" )
                    
                js_src = tmp_dir + "/" + r.base.replace( ".coffee", ".js" )
                if os.path.exists( js_src ) == False or os.path.getmtime( r.name ) > os.path.getmtime( js_src ):
                    exec_cmd( "coffee -o " + tmp_dir + " -b --compile " + r.name )
                app_code( out_js, js_src, root_dir )
                
            #if r.name.endswith( ".js" ):
            #    app_code( out_js, r.name, root_dir )
                
        if output_cs:
            if r.name.endswith( ".css" ):
                if out_cs == None:
                    mkdir_for( output_cs )
                    out_cs = file( output_cs, "w" )
                    
                app_code( out_cs, r.name, root_dir )
                
        for l in r.libs:
            if not ( l in libs ):
                libs.append( l )

    if out_js != None:
        print "js output ->", output_js
    if out_cs != None:
        print "css output ->", output_cs

    return libs
    