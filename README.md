# InteractiveTransitions

## Creating an interactive transition

(1) use one of Apple’s built-in interactive animator classes: **UIPercentDrivenInteractiveTransition**

(2) add the following delegate method to provide an interaction controller to presenting view controller

```swift
func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
```

[commit](https://github.com/htaiwan/InteractiveTransitions/commit/6fd4b862ae3fb7136214943ca8136981eb280adb)

(3) Calculating your animation’s progress.

```swift
func updateInteractiveTransition(percentComplete: CGFloat)
func cancelInteractiveTransition()
func finishInteractiveTransition()
```

[commit](https://github.com/htaiwan/InteractiveTransitions/commit/683b4d47ba7dbefd7a95f33c97d8ecd1766dbefc)

