This plugin permits to animate models

* in parallel
* with different kinds of curves
* with possibilities to ask for a new value even the preceding animations are not finished.


This is a example with a basic model and a basic slider:

```coffeescript
m = new ConstrainedVal 0, min:0, max:100
new_model_editor el: document.body, model: m

Animation.set m, 50
```

Arguments of the `set` procedure are

* `model`: the model that has to be changed
* `value`: the value we want at the end
* `delay`: number of milliseconds to do the job (500 vby default)
* `curve`: function used for the transition (Animation.linear by default). This function takes a ratio between 0 and 1 and should return a ratio between 0 and 1. `Animation` contains the following samples:
    * `Animation.linear`
    * `Animation.easing`
