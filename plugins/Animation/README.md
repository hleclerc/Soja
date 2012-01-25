This plugin permits to animate models

* in parallel
* with different kinds of curves
* with possibilities to ask for a new value even the preceding animations are not finished.


This is a example with a basic model and a basic slider:

```coffeescript
m = new ConstrainedVal 0, min:0, max:100
new_model_editor el: document.body, model: m

Animation.add m, 50
```
