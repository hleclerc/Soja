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
                max_size: [ 1e5, 500 ]
                border_s: 6
            }, {
                panel_id: "edit_view"
            } ]
        } ]
    
    l = new LayoutManager document.body, m
    l.disp_top    = 20
    l.border_size = 16

    # animation (for the fun)
    goal = []
    anim = ->
        rem = false
        for g in goal
            if g.n
                g.model.set g.model.get() + g.step
                g.n -= 1
                rem |= g.n
        if rem
            setTimeout anim, 25
    
    new_dom_element
        parentNode: document.body
        nodeName  : "input"
        type      : "button"
        value     : "Random strengths"
        style     : { position: "fixed", top: 5, right: 5 }
        onclick   : ->
            goal = for i in m.panel_id_of_term_panels()
                p = m.find_item_with_panel_id i
                s = Math.random() - p.strength
                model: p.strength, step: s / 10, n: 10
            setTimeout anim, 25
                
                
