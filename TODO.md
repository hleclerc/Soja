UI

API changes
* only one inst of FileSystem (use of FileSystem.static_method)
* ModelEditorList supporting dim changes
* 

* test orientation for elements (it bug sometimes)
* Allow user to use different format extension like tif, tiff bmp, cr2, raw ...
* Solve residual bug on intersection
* Add in notice textarea point position and connectivity table like it is done in Session module

* Allow user to save a png of his current window
* Add a function cut_with_point in element_arc
* Prevent Mask and discretization item from being removed
* Make flush to work to get real time informations
* Correlation eye is not working well on first click or maybe icon is not refresh
* We often loose visualization when something is changed in the tree (like moving a point in mesh)
* Bind time to image collection children.length
* Use complete path for modeleditoritem_directory in breadcrumb (probably need a regex on "/")
* Make a stop computation button or / and stop computation when a new one is launched from the same session
* Use mesh in mask item as exclusion mask
* Dialog popup to save treeitem
* Warp_by could be automatically be set to 1 when Displacement is drawn (and in a general way when Arrow are drawn)
* Drag and drop must be done in current folder and not on root folder

* Zoom mousemove seems to not be call when mouse is over a point
* Show to user if an item is empty (on Mask Discretization and maybe others items ) "Mask (empty)" as the name of item when he does not have any children (it also help user to know what step to follow) )
* Redo as some strange behavior
* On picked boundary item, when we want to delete a border by reclicking on it, it sometimes not refresh and not delete correctly the picked zone item
* Set manual compute can sometimes relaunch calculation
* Change build icon
* We can not write more than one letter without loosing focus in textarea language on small editor (fullscreen editor works)
* Displacement boundary should only allow selecting mesh in brotherhood item (for eg if Displacement boundary item is a child of correlation it should only access to boundary which are child of correlation item)


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
* watch_item removed from TreeItem (should be a method of TreeAppData)
* display notice
* Bug (probably from blur event) on Choice (came from selected which was not set)
* return the type of clicked point for contextual menu
* Allow user to get uncertainty