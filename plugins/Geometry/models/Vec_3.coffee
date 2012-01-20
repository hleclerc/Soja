# a Vec of fixed size = 3
class Vec_3 extends Vec
    static_length: ->
        3

    @sub: ( a, b ) ->
        return [ a[ 0 ] - b[ 0 ], a[ 1 ] - b[ 1 ], a[ 2 ] - b[ 2 ] ]

    @add: ( a, b ) ->
        return [ a[ 0 ] + b[ 0 ], a[ 1 ] + b[ 1 ], a[ 2 ] + b[ 2 ] ]
        
    @mul: ( a, b ) ->
        return [ a[ 0 ] * b[ 0 ], a[ 1 ] * b[ 1 ], a[ 2 ] * b[ 2 ] ]
        
    @div: ( a, b ) ->
        return [ a[ 0 ] / b[ 0 ], a[ 1 ] / b[ 1 ], a[ 2 ] / b[ 2 ] ]

    @mus: ( a, b ) -> # mul by scalar
        return [ a * b[ 0 ], a * b[ 1 ], a * b[ 2 ] ]

    @dis: ( a, b ) -> # div by scalar
        return [ a[ 0 ] / b, a[ 1 ] / b, a[ 2 ] / b ]
        
    @ads: ( a, b ) -> # add a scalar
        return [ a + b[ 0 ], a + b[ 1 ], a + b[ 2 ] ]

    @dot: ( a, b ) ->
        return a[ 0 ] * b[ 0 ] + a[ 1 ] * b[ 1 ] + a[ 2 ] * b[ 2 ]

    # vectorial product
    @cro: ( a, b ) ->
        return [ a[ 1 ] * b[ 2 ] - a[ 2 ] * b[ 1 ], a[ 2 ] * b[ 0 ] - a[ 0 ] * b[ 2 ], a[ 0 ] * b[ 1 ] - a[ 1 ] * b[ 0 ] ]

    @min: ( a ) ->
        return [ -a[ 0 ], -a[ 1 ], -a[ 2 ] ]

    # length
    @len: ( a ) ->
        return Math.sqrt( a[ 0 ] * a[ 0 ] + a[ 1 ] * a[ 1 ] + a[ 2 ] * a[ 2 ] )

    # normalized vector
    @nor: ( a ) ->
        l = Vec_3.len( a ) + 1e-40
        return [ a[ 0 ] / l, a[ 1 ] / l, a[ 2 ] / l ]
        
    @dist: ( a, b ) ->
        return Math.sqrt( ( Math.pow (a[ 0 ] - b[ 0 ]), 2 ) + ( Math.pow (a[ 1 ] - b[ 1 ]), 2 ) + ( Math.pow (a[ 2 ] - b[ 2 ]), 2 ) )
 
    # equal
    @equ: ( a, b ) ->
        return a[ 0 ] == b[ 0 ] and a[ 1 ] == b[ 1 ] and a[ 2 ] == b[ 2 ]

    @rot: ( V, R ) ->
        a = Vec_3.len( R ) + 1e-40
        x = R[ 0 ] / a
        y = R[ 1 ] / a
        z = R[ 2 ] / a
        c = Math.cos( a )
        s = Math.sin( a )
        return [
            ( x*x+(1-x*x)*c ) * V[ 0 ] + ( x*y*(1-c)-z*s ) * V[ 1 ] + ( x*z*(1-c)+y*s ) * V[ 2 ],
            ( y*x*(1-c)+z*s ) * V[ 0 ] + ( y*y+(1-y*y)*c ) * V[ 1 ] + ( y*z*(1-c)-x*s ) * V[ 2 ],
            ( z*x*(1-c)-y*s ) * V[ 0 ] + ( z*y*(1-c)+x*s ) * V[ 1 ] + ( z*z+(1-z*z)*c ) * V[ 2 ]
        ]

    # scalar multiplication
    @sm: ( x, t ) ->
        [ x[ 0 ] * t, x[ 1 ] * t, x[ 2 ] * t ] 
    
    
    #  Recursive definition of determinant using expansion by minors.
    # taken from http://mysite.verizon.net/res148h4j/javascript/script_determinant3.html
    @determinant: ( a, n = 3 ) ->
        d = parseFloat("0")
        m = [ [ d, d, d ], [ d, d, d ], [ d, d, d ] ]

        if (n == 2) # terminate recursion
            d = a[ 0 ][ 0 ] * a[ 1 ][ 1 ] - a[ 1 ][ 0 ] * a[ 0 ][ 1 ]
        else
            d = 0
            for j1 in [ 0...n ] # do each column
                for i in [ 1...n ] # create minor
                    j2 = 0
                    for j in [ 0...n ]
                        if j == j1
                            continue
                        m[ i - 1 ][ j2 ] = a[ i ][ j ]
                        j2++
                
                # sum (+/-)cofactor * minor  
                d = d + Math.pow( -1.0, j1 ) * a[ 0 ][ j1 ] * @determinant( m, n-1 )
                
        return d