# What is SOJA ?

SOJA is an event oriented Model / View library for Javascript applications. Basically, a model is a typed representation of the data. One of the main purpose is to help users create Object Oriented structures for their GUIs, with *headache-free* automatic synchronization between models and views.

SOJA is associated with several fundamental plugins:
* `UndoManager`, to make **snapshots of your application** and to navigate through them (e.g. with Ctrl-Z)
* `BrowserState`, to get a model of the browser, including window size, current url parameters (e.g. to ease navigation), ...
* `Synchronizer` allows several clients or servers to ease (RESTful) **patches and bidirectionnal communications**. It permits e.g. to **share models** between several distant users, to communicate with databases, etc...

The repository contains also plugin to help building GUIs:
* `ModelEditor`, to **automatically** create a form view / controler of a Model
* `CanvasManager` to describe 2D or a 3D objects (`Cam`, `Mesh`, `Image`, `Point`...), and draw or edit them in a 2D or WebGl canvas .
* `LayoutManager` to split / resize / join div elements in a dynamic way (think of a standard desktop application where a panel can be splitted, resized, ... and the proportions are maintained if the window is resized).
* `TreeView` to draw / control a hierarchical tree representation.

There is also a "basic" application framework, based on the preceding tools:
* `TreeApp` permits to define modular applications based with one or several canvas, a construction tree and an icon bar. 

# How SOJA works ?

SOJA stands for *Synchronized Objects in JAvascript*. It was designed with the following principles:

* Models can de defined **recursively**, and are typed (e.g. Val, Vec, Color, Layout, ConstrainedVal, ...) meaning for example that
  * you can use models to define another models (a very very basic need for Object Oriented Programming)
  * if you write `myModel.myProperty.mySubProperty.set(10)` views on `myModel` will be updated automatically in the next update round (unless if you choose to update a view only if the corresponding model(s) has *direct* modifications).
  * tests are done on values, not on references, and with the pertinent kind of comparison
* Views are changed **by rounds** (in a lazy fashion). It means for example that
  * **views are updated only once** if it's not necessary to update them several times.
  * you dont have to write things like "make_silent_modification()" because you want to change several models that may cause several updates of the same view (would be a real headache for real applications)
  * you can make **atomic model changes** (if e.g. you don't want an update until all your data are changed)
* prototypes of basic javascript or dom objects are unmodified (meaning that you can associate Soja with any kind of other javascript library)


# Starting guide

Soja is written in the great [coffee-script](http://jashkenas.github.com/coffee-script/ "coffee-script") language, so you need to install the coffeescript compiler. To ease the compilation, you will also need working make and python installations.

After that, a `make` in the root directory should permit to compile the main sources, the plugins and the tests.

You can then try some tests directly using your favorite browser (e.g. by launching `gen/test_ModelEditor.html`), or through the Makefile (typing e.g. `make test_ModelEditor`)

# Tutorial

## Basic Model binding

This is an example of a basic model creation, followed by a function binding.

```coffeescript
m = new Model a: 10, b: [ "yop", "yap" ]
bind m, -> document.body.innerHTML = "<H1>#{m.a.get()} #{m.b[0].get()}</H1>"

setTimeout ( -> m.a.set 13 ), 1000
```

or, in javascript:

```javascript
var m = new Model({ a: 10, b: [ "yop", "yap" ] });
bind( m, function() { document.body.innerHTML = "<H1>"+ m.a.get() + " " + m.b[ 0 ].get() + "</H1>"; } );

setTimeout( function() { m.a.set( 13 ); }, 1000 );
```

In this example, we first create a generic Model from the anonymous object `{ a: 10, ... }`. It recursively creates sub-models, so that `m.a`, `m.b` or `m.b[1]` are also models that can be observed, saved, restored, ...

The second line registers a function that will be called if the data of `m` have been changed in a preceding "round". A "round" can be defined as a contiguous set of instructions, so that in this example, the function will be called two times:
* one time at the beginning (due to the creation of `m`),
* one time and after the timeout.

Updating by rounds permits to optimize updates. As example, if the timeout function were `{ m.a.set( 13 ); m.b[ 0 ].set( "top" ); }`, the number of function calls would be the same.

Additionnaly, values are compared to determine if models are *really* changed. As `{ m.a.set( 10 ); }` would not really change the value of `m.a`, SOJA in this case won't call the binded function.


## Model classes

It can be helpfull to create class prototypes to describe what kind of models we are dealing with (instead of using anonymous aggregates).

This example illustrates how to create a simple Color model:

```coffeescript
class Color extends Model
    constructor: ->
        super()
        
        @add_attr
            r: new ConstrainedVal( 150, { min: 0, max: 255 } )
            g: new ConstrainedVal( 100, { min: 0, max: 255 } )
            b: new ConstrainedVal( 100, { min: 0, max: 255 } )
            
    lum: -> 
        ( @r.get() + @g.get() + @b.get() ) / 3
```
```javascript
var Color = ( function() {
    __extends( Color, Model );
    function Color() {
        Color.__super__.constructor.call( this );
        this.add_attr({
            r: new ConstrainedVal( 150, { min: 0, max: 255 } ),
            g: new ConstrainedVal( 100, { min: 0, max: 255 } ),
            b: new ConstrainedVal( 100, { min: 0, max: 255 } )
        });
    }
    Color.prototype.lum = function() {
        return ( this.r.get() + this.g.get() + this.b.get() ) / 3;
    };
    return Color;
} )();
```

`add_attr` permit children models to know the parent ones. `ConstrainedVal` is basically a numeric value, with constraints like bounds, divisions, ...

Once created, this model can be binded to functions or views, as in:

```coffeescript
c = new Color

# sliders
new_model_editor el: new_dom_element( parentNode: document.body, style: {width:300} ), model: c

# lum
l = new_dom_element parentNode: document.body
bind c, -> l.innerHTML = "Luminance = #{c.lum()}"
```
```javascript
var c = new Color;

// sliders
new_model_editor({ el: new_dom_element({ parentNode: document.body, style: { width: 300, marginBottom: 10 } }), model: c });

// lum
var l = new_dom_element({ parentNode: document.body });
bind( c, function() { return l.innerHTML = "Luminance = " + (c.lum()); });
```

where we created two views of `c`, an instance of `Color`. The first view is created using the `ModelEditor` plugin (and consists mainly in sliders). The second is a `div` element (created by `new_dom_element` which is defined in the plugin `DomHelper`) that will contain the text `"Luminance = #{c.lum()}"`, computed according to the values in `c`.

## View classes

In most of the real cases, views are instances of classes defined by the users. Binding a view object means that 
* the `onchange` method will be called if the observed model (or a child of) has been changed during the preceding round
* the `destructor` method will be called if the observed model has been destroyed.

This is an example where we create two checkboxes in `document.body`, synchronized with a sub-model

```coffeescript
class MyView extends View
    constructor: ( @model, parent ) ->
        super model

        @input = new_dom_element
            parentNode: parent
            type      : "checkbox"
            nodeName  : "input"
            # onchange of the dom element
            onchange  : => @model.set @input.checked
            
    # surdefinition of View.onchange, called for the view creation
    onchange: ->
        @input.checked = @model.toBoolean()

m = new Model
    a: true
    b: [ "yop" ]

new MyView m.a, document.body # instance 1
new MyView m.a, document.body # instance 2
```

Or in javascript

```javascript
```

`new_dom_element` comes from the `DomHelper` library.

## get / set / get_state / ...

### set

If you want to change the value of a model, you have to call the `set` method.

In most of the cases, `set` can take other models as argument, or standard javascript objects. It deeply compares the argument and stored values. If different, the stored value is changed, the model is marked as directly changed, and the parent models are marked as changed. If no new round is planned, we create a timeout with a 1 ms delay to prepare a new round.

### get

`get` permits to obtain the values in standard javascript / JSON representation.

For example `Val.get()` will give you a number. If you make an aggregate, `get()` will give you a JSON representation.

### get_state

JSON is a very simple kind of representation but is limited for several reasons :
  * objects are not typed (JSON support only basic types and anonymous aggregates)
  * JSON permits to represents trees but not graphs, e.g. in presence of cyclic references or if an object is references by several parents.

Due to theses limitations, Soja uses an alternative but very simple representation. For example,

```coffeescript
m = new Model a: [ 8 ]
console.log m.get_state()
```
```javascript
var m = new Model({ a: [ 8 ] });
console.log( m.get_state() );
```

will give the following string

```
2
0 Val 8
1 Lst 0
2 Model a:1
```

The first column represents the model id, the second represents the type and the third is type dependant.

It permits for example to get the full state of an application, but also to get changes since a given *model date* as get_state can take a *model date* as first parameter. The current model date is given by `Model._counter`.

### set_state

Symmetrically, the string obtained by `get_state` can be used to update or construct a model, using `set_state`.

This procedure is used for example in the `Synchronizer` or the `UndoManager` plugins.

## Usual methods

`equals` permits to compare models with other models or objects.

`toString` and `toBoolean` permits to make some conversions...

`size` permits to get an array representing tensorial size. For a scalar, it returns []. For an array, it returns [length], ...

## Basic model objects

From Soja.js :
  * Model -> ancestor class, used for anonymous aggregates
  * Lst -> a list of models. It contains some usual methods for list manipulation :
    * push: ( value ) -> appends value at the end of the list
    * pop: -> remove and return the last element
    * shift: -> remove and return the first element
    * remove: ( item ) -> remove `item` from the list if present
    * filter: ( f ) -> return a list with items such as `f( item )` is true
    * detect: ( f ) -> return the first item such as `f( item )` is true. If not, return undefined
    * has: ( f ) -> return true if there is an item that checks `f( item )`
    * indexOf: ( v ) -> returns index of `v` if `v` is present in the list. Else, return -1
    * contains: ( v ) -> returns true if `v` is contained in the list
    * toggle: ( v ) -> toggle presence of `v`
    * splice: ( index, n = 1 ) -> remove `n` items starting from `index`
    * join: ( sep ) -> return a string with representation of items, separated by `sep`
  * Str -> a string
    * toggle: ( str, space = " " ) -> toggle presence of str in this
    * contains: ( str ) -> true if str is contained in this
  * Val -> a number
  * Bool -> a Boolean
    * toggle: -> self not
  * Vec -> a list of number
  * Choice -> a choice of a value inside a list
  * ConstrainedVal -> a value with potentially a miniminum, a maximum, ticks, ...

From plugins :
  * Color (Color) -> set of constrained rgba values
  * Gradient (Color) -> color gradient
  * BrowserState (BrowserState) -> a model representing browser state (window size, current url, ...)
  * Layout (LayoutManager) -> a (dynamic) page layout description
  * Cam (CanvasManager) -> a 3D / 2D camera
  * Mesh / Point / ... (CanvasManager) -> drawable objects
  * ...

It is worth mentionning that Lst can be extended to change its basic behavior:
  * by default, length is dynamic, but it can be fixed by surdefining `static_length`. In this case, surdefining `default_value` can be usefull (e.g. for construction).
  * by default, Lst can accept any kind of model but if `base_type` is surdefined, one can force conversions during operations like `push`, `set`, `[ n ].set`, ...

## And now, what ?

Feel free to explore the plugins listed at the beginning.

... here a list of awesome applications which use Soja (among tons of other libraries but we won't speak about that) ...
