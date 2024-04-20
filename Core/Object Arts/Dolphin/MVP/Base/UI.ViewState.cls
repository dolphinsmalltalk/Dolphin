"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.ViewState'
	instanceVariableNames: 'view state showCmd dpi dpiAwareness subViewStates'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.ViewState guid: (Core.GUID fromString: '{87b4c4cd-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.ViewState comment: '`ViewState` is capable of holding the relevant state of any `View` so that it may be restored to the same state at a later date. Normally, a `ViewState` is used during an image save to capture the state of all of the open views so that they may be restored when the image is restarted, but it is also used when dynamic recreation of a view is required such as when changing certain window styles that may only be applied when a window is created.

## Instance Variables:
  `view`			`View` whose state has been saved.
  `state`			`MessageSequence` to replay to restore extrinsic state of the view, e.g. creating the associated window
  `showCmd`		`<integer>` from the SW_xxx enumeration to restore the visible state of the view via a call to the [ShowWindow](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-showwindow) api
  `dpi`			`<integer>` logical DPI of the View when saved
  `subViewStates`	`<sequencedReadableCollection>` of `ViewState`s for any child `View`s'!

!UI.ViewState categoriesForClass!MVP-Views-Support! !

!UI.ViewState methodsFor!

dpiAwareness
	"Answer the symbolic name of the DPI awareness mode of the View when saved."

	^User32 awarenessFromDpiAwarenessContext: dpiAwareness!

dpiAwarenessContext
	^dpiAwareness!

dpiAwarenessContext: anInteger
	dpiAwareness := anInteger!

recordStateOf: aView forRecreate: aBoolean
	"Private - Initialize the receiver so that it is capable of restoring the <View>, aView, after it's handle has become invalid. The <boolean> argument, aBoolean, indicates whether the state will be used to immediately restore the receiver, in which case the state restoring flag is set on aView and all its sub-views as they are traversed.
	Note that the flag is set before the state is recorded, so it can be tested in the #state implementation, but this is not usually necessary."

	view := aView.
	aBoolean ifTrue: [view setStateRestoring].
	dpiAwareness := User32 getWindowDpiAwarenessContext: aView handle.
	"We need to capture state in the correct DPI awareness context so the measurements are in the correct (possibly virtual) co-ordinate system."
	state := User32 inDpiAwarenessContext: dpiAwareness do: [aView state].
	state freeze.
	showCmd := aView placement showCmd.
	dpi := aView dpi.
	subViewStates := aView subViews
				collect: [:each | ViewState recordStateOf: each forRecreate: aBoolean]!

restore
	"Restore the receiver's view to its former glory"

	| scale |
	view
		setStateRestoring.
	User32 inDpiAwarenessContext: dpiAwareness do: [view state: state].
	subViewStates do: [:each | each restore].
	scale := view resolution / dpi.
	scale = 1
		ifFalse: 
			["Make adjustments required for a change of resolution"
			view resolutionScaledBy: scale].
	view
		basicInvalidateLayout;
		basicShowWithStyle: showCmd;
		resetStateRestoring! !

!UI.ViewState categoriesForMethods!
dpiAwareness!accessing!public! !
dpiAwarenessContext!accessing!public! !
dpiAwarenessContext:!accessing!public! !
recordStateOf:forRecreate:!initializing!private! !
restore!operations!public! !
!

!UI.ViewState class methodsFor!

new
	"Private - Use #recordStateOf:"

	^self shouldNotImplement!

recordStateOf: aView forRecreate: aBoolean
	"Answer an instance of the receiver holding current state information about
	aView. This will allow aView's handle to be rebuilt when #restore is sent
	to this instance."

	^super new 
		recordStateOf: aView forRecreate: aBoolean! !

!UI.ViewState class categoriesForMethods!
new!instance creation!private! !
recordStateOf:forRecreate:!instance creation!public! !
!

