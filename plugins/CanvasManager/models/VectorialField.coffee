# Vectorial fields is a list containing differents field
class VectorialField extends Model
    constructor: ( name = "", vector = new Lst, params = {} ) ->
        super()
        
        @add_attr
            name        : name
            _vector     : vector
    
    
    get: () ->
        return @_vector.get()
    
    toString: ->
        @name.get()

    dim: ->
        @_vector.length
        
    add_child: ( child ) ->
        @_vector.push child
        
    rem_child: ( child ) ->
        ind = @_vector.indexOf child
        if ind > 0
            @_vector.splice ind, 1