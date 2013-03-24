# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2012 Hugo Leclerc
#
# This file is part of Soja.
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
    This file is used to generate .js and .css files and optionnaly a .html file to run a given .coffee (assumed to be the "main" one). Additionnaly, it can generate the .html to make the glue
    
    The needed files are given by lines like
    # dep foo.coffee  # -> lookup for a file named foo.coffee in the current directory
    # dep $DomHelper/foo.coffee  # -> lookup for a file named foo.coffee in the library DomHelper that should be installed in Soja/lib. If not present in this directory,
         the script will try to download it...
    # dep foo.css
    
    and of course foo.coffee may contain additionnal dependencies...
   
"""
import os, re, sys, string, argparse

#
class File:
    def __init__( self, full_name ):
        self.dependencies = []
        self.full_name = full_name
        for l in file( full_name ).readlines():
            r = re.search( r'[#/] dep[ ]*(.*)[ ]*$', l )
            if r:
                self.dependencies.append( r.group( 1 ) )
            #if name.endswith( ".coffee" ):
                #r = re.search( r'extends (.*)', l )
                #if r:
                    #self.dependencies.append( r.group( 1 ).strip() + ".coffee" )


#
class FileSet:
    def __init__( self, include_dirs = [] ):
        self.include_dirs = []
        self.file_list = []
        self.proc_list = []
        
        for i in include_dirs:
            self.add_include_dir( i )

    def add_include_dir( self, directory ):
        d = os.path.abspath( directory )
        if not( d in self.include_dirs ):
            self.include_dirs.append( d )

    def parse( self, name, orig = '' ):
        full_name = os.path.abspath( self._find_file( name, orig ) )
        for f in self.proc_list:
            if f.full_name == full_name:
                return f
            
        f = File( full_name )
        self.proc_list.append( f )
        
        for dep in f.dependencies:
            self.parse( dep, full_name )
            
        self.file_list.append( f )
        
        return f

    # replace things like "toto.png" of "$Soja/css/tata.png" to base64 equivalent
    def copy_with_inline_images( self, out, inp, orig ):
        for l in inp.readlines():
            # inline base64
            r = re.search( r'^(.*)(["\'])(img/.*\.png)["\'](.*)$', l )
            if r:
                img = self._find_file( r.group( 3 ), orig, False )
                if len( img ):
                    beg = r.group( 1 )
                    gui = r.group( 2 )
                    end = r.group( 4 )

                    # base64 data
                    b = os.popen( "base64 -w 0 " + img ).read()
                    
                    # mimetype
                    kin = ""
                    cmime = [
                        ( 'jpeg', [ '.jpg', '.jpeg' ] ),
                        ( 'png' , [ '.png' ] ),
                        ( 'gif' , [ '.gif' ] ),
                    ]
                    for mime, ext in cmime:
                        for e in ext:
                            if img.endswith( e ) or img.endswith( string.uppercase( e ) ):
                                kin = mime
                                break
                    if len( kin ):
                        out.write( beg + gui + "data:image/" + kin + ";base64," + b + gui + end + "\n" )
                        continue
                    else:
                        print 'Unknown extension for ' + r.group( 3 )
                else:
                    print r.group( 3 ) + ' not found.'
                
            out.write( l )
        
    # orig is the originating file
    def _find_file( self, name, orig = '', exit_if_err = True ):
        # $repository/path
        if len( name ) and name[ 0 ] == '$':
            p = name.find( '/' )
            lib_name = name[ 1 : p ]
            inc_name = name[ p + 1 : ]
            for inc_dir in self.include_dirs:
                d = os.path.join( inc_dir, lib_name )
                if os.path.isdir( d ):
                    trial = os.path.join( d, inc_name )
                    if os.path.exists( trial ):
                        return trial
            
        # orig
        if len( orig ):
            trial = os.path.join( os.path.dirname( orig ), name )
            if os.path.exists( trial ):
                return trial
            
        # current_dir/path
        if os.path.exists( name ):
            return name
    
        if exit_if_err:
            print "Impossible to find file " + name
            sys.exit( 3 )
        return ''
        
#
def exec_cmd( cmd ):
    print cmd
    if os.system( cmd ):
        sys.exit( 1 )

    
#
def main():
    soja_dir = os.path.abspath( sys.argv[ 0 ] )
    soja_dir = os.path.dirname( soja_dir )
    soja_dir = os.path.dirname( soja_dir )
    
    blib_dir = [ os.path.join( soja_dir, d ) for d in [ "src", "ext" ] ]
    
    parser = argparse.ArgumentParser( description = 'Generation of .js, .css and .html files to run a .coffee.' )
    parser.add_argument( 'input_file', metavar = 'foo.coffee', help = 'input file' )
    parser.add_argument( '-d', metavar = 'output directory', default = 'gen', help = 'output directory (for e.g. js, css or html file)' )
    parser.add_argument( '-I', action = 'append', metavar = 'directory', default = blib_dir, help = 'add a repository directory' )
    parser.add_argument( '-e', action = 'store_true', help = 'execute file' )

    args = parser.parse_args()

    # gen directory
    if not os.path.exists( args.d ):
        os.mkdir( args.d )

    # parse
    fs = FileSet( include_dirs = args.I )
    fs.parse( args.input_file )
    
    # js and css compilation
    js_files = []
    css_files = []
    for f in fs.file_list:
        if f.full_name.endswith( '.coffee' ):
            bout = re.sub( '.coffee$' , '.js', os.path.basename( f.full_name ) )
            fout = os.path.join( args.d, bout )
            if os.path.exists( fout ) == False or os.path.getmtime( f.full_name ) > os.path.getmtime( fout ):
                exec_cmd( "coffee -o " + args.d + " -b --compile " + f.full_name )
            js_files.append( bout )
        elif f.full_name.endswith( '.css' ):
            out = os.path.join( args.d, os.path.basename( f.full_name ) )
            inp = file( f.full_name )
            fs.copy_with_inline_images( out, inp )
            
            
    # html
    if not args.e:
        nout = os.path.join( args.d, re.sub( ".coffee$", ".html", os.path.basename( args.input_file ) ) )
        func = re.sub( ".coffee$", "", os.path.basename( args.input_file ) )
        print 'html output:', nout
        hout = file( nout, 'w' )
        print >> hout, "<html>"
        print >> hout, "  <head> "
        print >> hout, "  <title>__" + nout + "__</title>"
        for css in css_files:
            print >> hout, '    <link type="text/css" href="' + css + '" rel="stylesheet"/>'
        for js in js_files:
            print >> hout, "    <script type='text/javascript' src='" + js + "'></script>"
        print >> hout, "  <body onload='if ( " + func + " != null ) { " + func + "(); }'>"
        print >> hout, "  </body>"
        print >> hout, "</html>"
    
    
    # execute
    if args.e:
        if len( js_files ) > 1:
            out = os.path.join( args.d, "out.js" )
            exec_cmd( "cat " + string.join( [ os.path.join( args.d, j ) for j in js_files ] ) + " > " + out )
            exec_cmd( "nodejs " + out )
        else:
            exec_cmd( "nodejs " + os.path.join( args.d, js_files[ 0 ] ) )
    
    
    

    #l = os.path.commonprefix( [ f.full_name for f in fs.file_list ] )
    #print l
            


if __name__ == "__main__":
    main()
    
