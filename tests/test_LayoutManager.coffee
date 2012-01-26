# lib gen/Soja.js
# lib gen/DomHelper.js
# lib gen/BrowserState.js
# lib gen/LayoutManager.js
# lib gen/Animation.js
test_LayoutManager = ->
    # m = new LayoutManagerData panel_id: "main_view"
    m = new LayoutManagerData
        sep_norm: 0
        children: [ {
            panel_id: "main_view"
            strength: 3,
        }, {
            sep_norm: 1
            children: [ {
                panel_id: "tree_view"
                max_size: [ 1e5, 500 ]
                border_s: 6
            }, {
                panel_id: "edit_view"
            } ]
        } ]
    
    l = new LayoutManager document.body, m
    l.disp_top    = 20
    l.border_size = 16
    
    new_dom_element
        parentNode: document.body
        nodeName  : "input"
        type      : "button"
        value     : "Random strengths"
        style     : { position: "fixed", top: 5, right: 5 }
        onclick   : ->
            for i in m.panel_ids()
                p = m.find_item_with_panel_id i
                s = 0.1 + 0.8 * Math.random()
                Animation.set p.strength, s
            
                
                
