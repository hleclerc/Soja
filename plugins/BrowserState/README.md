`BrowserState` can be seen as a *model of your browser*.

An instanciation `BrowserState` contains variables, that can be observed by views, and which describe the global state as:

* `hash` i.e. what you can find after the `#` in urls
* `window_size`
* ...

One of the first applications is to integrate the "previous/next" actions of the browser to your application.

