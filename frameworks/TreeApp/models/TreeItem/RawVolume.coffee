#
class RawVolume extends TreeItem
    constructor: ->
        super()
        
        @add_attr
            scalar_type: new Choice( 0, [ "PI8", "SI8", "PI16", "SI16", "PI32", "SI32" ] )
            endianness : new Choice( 0, [ "LittleEndian", "BigEndian" ] )
            img_size   : [ 0, 0, 0 ]
            min_val    : new ConstrainedVal(   0, { min: 0, max: 255, div: 255 } )
            max_val    : new ConstrainedVal( 255, { min: 0, max: 255, div: 255 } )
            
        @_name.set "Raw volume"
        @_ico.set "img/krita_16.png"
        @_viewable.set true

    update_min_max: ( x_min, x_max ) ->
        for d in [ 0 ... 3 ]
            x_min[ d ] = Math.min x_min[ d ], 0
            x_max[ d ] = Math.max x_max[ d ], @img_size[ d ].get()
            