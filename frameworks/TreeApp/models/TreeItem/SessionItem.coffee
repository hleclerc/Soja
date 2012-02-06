class SessionItem extends TreeItem
    constructor: ( name ) ->
        super()
        
        @_name._set name
        @_ico._set "img/document-open.png"
        
#         bind this, =>
#             max = 0
#             for ch in this._children
#                 m = ch.anim_min_max()
#                 if m > max
#                     max = m
#             
#             ds = undefined
#             for child in this._children
#                 if child instanceof DisplaySettingsItem
#                     ds = child
#             if ds?
#                 ds.anim_time._max.set max - 1
#                 ds.anim_time._div.set max - 1
        bind this, =>
            max = 0
            for ch in this._children
                m = ch.anim_min_max()
                if m > max
                    max = m
            
#             anim_module = TreeAppModule_Animation
#             console.log anim_module.get_anim_time()
            if anim_module?
                anim_time = anim_module.get_anim_time()
                anim_time._max.set max - 1
                anim_time._div.set max - 1
            
    accept_child: ( ch ) ->
        true
        
    