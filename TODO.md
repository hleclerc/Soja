UI

API changes
* only one inst of FileSystem (use of FileSystem.static_method)
* ModelEditorList supporting dim changes
* watch_item removed from TreeItem (should be a method of TreeAppData)
* 

* return the type of clicked point for contextual menu
* test orientation for elements
* Allow user to save a png of his current window
* Allow user to get uncertainty
* Bug (probably from blur event) on Choice
* display notice

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
* add a way to launch computable in the treeview
* save tree item
* add a picture to tree from browser no matter which way ( drag and drop or copy cut etc.)
* use same legend for every interpolated fields
* legend should be fittable manually by users
* organize compute icon in editview to be visualizable and usable
* bug boundary picking no more work since introduction of element (because it still use mesh.lines to pick)
* Y is in the wrong side for correlation result
* Color map is reset after each correlation, it should not change
* Add arrow on vectorial field
* Test Elementary_field
* Add a close button to popup
* Bug in input, return, arrow and others keyboard touch don't work
* Fix bug on delete point (it delete selected treeitem)
* Add and modify Picked zone item when mesh is cut by a new point
* Delete Picked zone item when a point in pzi is deleted
* Reclick on Border does not delete clicked border and pzi anymore (probably coming from the use of _parents in treeappdata)
* Remove viewitem does not perfectly work, on some case user can lost visualization
* Rename from "gradient" to "color map"