#
class StrLanguage extends Model
    constructor: ( value = "" , language = "Text" ) ->
        super()
        
        @value = new Str value
        @language = language
        
    
    get: ->
        return @value.get()
        
    set: (val ) ->
        @value.set val
    
    get_language: ->
        return @language