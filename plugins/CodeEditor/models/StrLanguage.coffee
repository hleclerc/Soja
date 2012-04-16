#
class StrLanguage extends Model
    constructor: ( value = "" , language = "text", callback = undefined ) ->
        super()
        
        @add_attr
            value    : new Str value
            language : language
            callback : callback
        
    get: ->
        return @value.get()
        
    set: (val ) ->
        @value.set val
    
    get_language: ->
        return @language.get()