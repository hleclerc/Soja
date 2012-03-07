# lib gen/Soja.js
# lib gen/DomHelper.js
# lib gen/ModelEditor.js
# lib gen/ModelEditor.css
# lib gen/Color.js
# lib gen/Color.css
test_ModelEditor = ->
    #     model = new Model
    #         bool          : true
    #         val           : 1
    #         choice        : new Choice( 0, [ "a", "b", "c" ] )
    #         constrainedVal: new ConstrainedVal( 7, { min: 0, max: 15 } )
    #         
    #     e = new_model_editor document.body, model, "test"
    #     e.item_width = 45
    # 
    #     e = new_model_editor document.body, model, "anot"
    #     e.default_types.push ( model ) -> ModelEditorItem_Choice_Roll if model instanceof Choice
    #     e.default_types.push ( model ) -> ModelEditorItem_Bool_Img    if model instanceof Bool

    focus = new Val -1
    
    docbod = new_dom_element
        parentNode: document.body, style: { width: 500 }
    
    #
    spacing = ->
        for i in [ 0 ... 2 ]
            new_dom_element parentNode: docbod, nodeName: "br"

    # model
    model = new Model
        simple_aggregate:
            bool     : true
            val      : 1
            str      : "toto"
            choice   : new Choice( 0, [ "a", "b", "c" ] )
            constrVal: new ConstrainedVal( 7, { min: 0, max: 15 } )
            vec      : new Vec [ 1, 2, 3 ]
            color    : new Color 150, 0, 0
            gradient : new Gradient
        simple_matrix: [ [ 1, 2, 3 ], [ 4, 5, 6 ] ]

    model.simple_aggregate.gradient.add_color [ 255,255,255, 255 ], 0
    model.simple_aggregate.gradient.add_color [   0,  0,  0, 255 ], 1
    
    # view with
    editor = new_model_editor el: docbod, model: model, focus: focus
    editor.label_ratio = 0.2
    spacing()

    new_model_editor el: docbod, model: focus

    # view with item which take 50%
    editor = new_model_editor el: docbod, model: model.simple_aggregate, label: "Simple aggregate model with item_width at 48", item_width: 48, focus: focus
    spacing()

    # with choice roll
    editor = new_model_editor el: docbod, model: model.simple_aggregate, label: "Some sample alternate editors", focus: focus
    editor.label_ratio = 0.2
    editor.default_types.push ( model ) -> ModelEditorItem_Choice_Roll    if model instanceof Choice
    editor.default_types.push ( model ) -> ModelEditorItem_Bool_Img       if model instanceof Bool

    # "Button to test attribute removing"
    #     div_name = new_dom_element
    #         parentNode: docbod
    #         nodeName  : "input"
    #         type      : "button"
    #         value     : "rem model.val"
    #         onclick   : ->
    #             model.simple_aggregate.val.rem_attr "truc"

