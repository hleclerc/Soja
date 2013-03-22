# dep Char.coffee
# dep Ptr.coffee

class Str extends Model
    @attr =
        data: Ptr Char
        size: 0
        
    Model.__conv_list.push ( val ) ->
        if typeof val == "string" then Str

    Str.prototype.__defineGetter__ "length", ->
        @size.val
        
    get: -> 
        res = ""
        obj = @data.obj
        
        view = new Int32Array obj.__orig.__data, obj.__offset, @length
        for i in view
            res += String.fromCharCode i
        res
        
    set: ( val ) -> 
        res = mmew Char, val.length
        @size.set val.length
        @data.ref res
        
        if val instanceof Str
            todo()
        else if typeof val == "string"
            view = new Int32Array res.__data, res.__offset, val.length
            for i in [ 0 ... val.length ]
                view[ i ] = val.charCodeAt( i )
        res
        
        
        

#   /**
#    * @constructor
#    * @param {{fatal: boolean}} options
#    */
#   function UTF8Encoder(options) {
#     var fatal = options.fatal;
#     /**
#      * @param {ByteOutputStream} output_byte_stream Output byte stream.
#      * @param {CodePointInputStream} code_point_pointer Input stream.
#      * @return {number} The last byte emitted.
#      */
#     this.encode = function(output_byte_stream, code_point_pointer) {
#       var code_point = code_point_pointer.get();
#       if (code_point === EOF_code_point) {
#         return EOF_byte;
#       }
#       code_point_pointer.offset(1);
#       if (inRange(code_point, 0xD800, 0xDFFF)) {
#         return encoderError(code_point);
#       }
#       if (inRange(code_point, 0x0000, 0x007f)) {
#         return output_byte_stream.emit(code_point);
#       }
#       var count, offset;
#       if (inRange(code_point, 0x0080, 0x07FF)) {
#         count = 1;
#         offset = 0xC0;
#       } else if (inRange(code_point, 0x0800, 0xFFFF)) {
#         count = 2;
#         offset = 0xE0;
#       } else if (inRange(code_point, 0x10000, 0x10FFFF)) {
#         count = 3;
#         offset = 0xF0;
#       }
#       var result = output_byte_stream.emit(
#           div(code_point, Math.pow(64, count)) + offset);
#       while (count > 0) {
#         var temp = div(code_point, Math.pow(64, count - 1));
#         result = output_byte_stream.emit(0x80 + (temp % 64));
#         count -= 1;
#       }
#       return result;
#     };
#     
#     
# function CodePointInputStream(string) {
#     /**
#      * @param {string} string Input string of UTF-16 code units.
#      * @return {Array.<number>} Code points.
#      */
#     function stringToCodePoints(string) {
#       /** @type {Array.<number>} */
#       var cps = [];
#       // Based on http://www.w3.org/TR/WebIDL/#idl-DOMString
#       var i = 0, n = string.length;
#       while (i < string.length) {
#         var c = string.charCodeAt(i);
#         if (!inRange(c, 0xD800, 0xDFFF)) {
#           cps.push(c);
#         } else if (inRange(c, 0xDC00, 0xDFFF)) {
#           cps.push(0xFFFD);
#         } else { // (inRange(cu, 0xD800, 0xDBFF))
#           if (i === n - 1) {
#             cps.push(0xFFFD);
#           } else {
#             var d = string.charCodeAt(i + 1);
#             if (inRange(d, 0xDC00, 0xDFFF)) {
#               var a = c & 0x3FF;
#               var b = d & 0x3FF;
#               i += 1;
#               cps.push(0x10000 + (a << 10) + b);
#             } else {
#               cps.push(0xFFFD);
#             }
#           }
#         }
#         i += 1;
#       }
#       return cps;
#     }
# 
#     /** @type {number} */
#     var pos = 0;
#     /** @type {Array.<number>} */
#     var cps = stringToCodePoints(string);
# 
#     /** @param {number} n The number of bytes (positive or negative)
#      *      to advance the code point pointer by.*/
#     this.offset = function(n) {
#       pos += n;
#       if (pos < 0) {
#         throw new Error('Seeking past start of the buffer');
#       }
#       if (pos > cps.length) {
#         throw new Error('Seeking past EOF');
#       }
#     };
# 
# 
#     /** @return {number} Get the next code point from the stream. */
#     this.get = function() {
#       if (pos >= cps.length) {
#         return EOF_code_point;
#       }
#       return cps[pos];
#     };
#   }    