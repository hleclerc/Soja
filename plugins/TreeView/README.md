# Goal of the Tree plugin 

It permits to get a tree representation of a model. It contains optionnal functionnalities for:

* drag and drop
* (multiple) selection
* icons at different positions

By default, a `TreeView` use the following attributes of a tree model:

* `_children`: children in the tree
* `_name`: name appearing in the tree
* `_ico`: src file of icon in the left
* `_viewable`: boolean to define if a tree item can have a *visible* icon on the right

Thus, the following example will simply display a tree with 1 root and 2 children

```coffeescript
d = new Lst [
    _name: "root"
    _children: [ {
        _name: "child_0"
        _ico : "img/cross.png"
    }, {
        _name: "child_1"
        _viewable: true
    } ]
    accept_child: ( ch ) ->
        ch._name.equals "child_1"
]

new TreeView document.body, d
```

Additionnaly, due to the `accept_child` method, the root item will accept new children (from e.g. drag and drop).

# Selection / closing / ...

This is the definition of the `TreeView` constructor:

```coffeescript
class TreeView
    constructor: ( @el, @roots, @selected = new Lst, @visible = new Lst, @closed = new Lst ) ->
```

`@el` is the base dom element where the tree will be drawed.

`@roots` must be a `Lst` or behave like a `Lst`. It describes the leftmost items in the tree.

`@selected`, `@visible` and `@closed` are or will be (if not specified) `Lst` models which describes respectively:

* selected entities, as a list of path of references
* items where the visible icon is checked (a list of models)
* visually closed items in the tree (same format than `@selected`).


... but this describes mostly the default behavior which can be changed.

If user wants to use different attributes and / or to obtain different kinds of displays, they may redefine

* `get_children_of: ( item )`
* `insert_child: ( par, pos, chi )`
* `get_viewable_of: ( item )` (used by the default `make_line` method)
* `get_name_of: ( item )`
* `get_ico_of: ( item )`
* `make_line: ( div, info, pos_x, sel_func )` procedure to add dom element for a tree line

# Drag and drop

To accept a child, a tree item must have the method `accept_child: ( ch )` and this method has to return true.


