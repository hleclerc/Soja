# lib gen/Soja.js
# lib gen/DomHelper.js
# lib gen/BrowserState.js
# lib gen/LayoutManager.js
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
                max_size: [ 1e5, 30 ]
                border_s: 6
            }, {
                panel_id: "edit_view"
            } ]
        } ]
    
    l = new LayoutManager document.body, m
    l.border_size = 16
