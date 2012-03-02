#
class StrLanguage extends Model
    constructor: ( value = "" , language = "Text" ) ->
        super()
        
        @value = new Str value
        @language = language
        
    
    get: ->
        return @value
    
    get_language: ->
        return @language