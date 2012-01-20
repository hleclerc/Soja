# lib gen/Soja.js
# lib gen/DomHelper.js
# lib gen/TreeView.js
# lib gen/TreeView.css
test_TreeView = ->
    d = new Lst [
        _name: "root"
        _children: [ {
            _name: "child_0 which accepts child_1 as child"
            _viewable: true
            _ico : "../plugins/ModelEditor/img/cross.png"
            accept_child: ( ch ) ->
                ch._name.equals "child_1"
        }, {
            _name: "child_1"
            _viewable: true
        }, {
            _name: "child_2"
            _viewable: true
        }, {
            _name: "child_3"
            _viewable: true
        } ]
        accept_child: ( ch ) ->
            true
    ]

    v = new TreeView document.body, d
    v.visibility_context.set "a"
    
    new_dom_element
        parentNode: document.body
        nodeName  : "input"
        type      : "button"
        value     : "vc a"
        onclick   : -> v.visibility_context.set "a"
        style:
            marginTop: 100
            
    
    new_dom_element
        parentNode: document.body
        nodeName  : "input"
        type      : "button"
        value     : "vc b"
        onclick   : -> v.visibility_context.set "b"
        
        
        