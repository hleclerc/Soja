UI

API changes
* only one inst of FileSystem (use of FileSystem.static_method)
* ModelEditorList supporting dim changes
* watch_item removed from TreeItem (should be a method of TreeAppData)
* 


* return the type of clicked point for contextual menu
* bug boundary picking no more work since introduction of element (because it still use mesh.lines to pick)
* display notice
* save tree item
* add a picture to tree from browser no matter which way ( drag and drop or copy cut etc.)
* organize compute icon in editview to be visualizable and usable
* add a way to launch computable in the treeview (apply on every child)
* legend should be fittable manually by users
* use same legend for every interpolated fields
* test orientation for elements


---Fixed---
* Global messages (see TreeItem_Computable)
* surface mode working even if no available field (e.g. without dep, ...)
* displayed_style -> display_style (english)
* in sketch module, remove the @sketch from global variables
* problem : transformable points are no longer movable
* Point Mesher infinite loop when moving
* continue work on time_steps to display every correlation results
* preview thumbnail of pictures in browser
* use treeAppModule_Computable to launch computable on every item (also use hotkeys like ctrl+B to build or something like that)
* fix ambiguous open and import in tree browser