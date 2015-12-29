"Filed out from Dolphin Smalltalk X6"!

Object subclass: #ViewState
	instanceVariableNames: 'view state placement subViewStates'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ViewState guid: (GUID fromString: '{87B4C4CD-026E-11D3-9FD7-00A0CC3E4A32}')!
ViewState comment: 'ViewState is capable of holding the relevant state of any <view> so that it may be restored to the same state at a later date. Normally, a ViewState is used during an image save to capture the state of all of the open views so that they may be restored when the image is restarted, but it is also used when dynamic recreation of a view is required such as when changing certainWindow styles that may only be applied when a Window is created.

Instance Variables
	view		<view> whose state has been saved.
	state		<monadicValuable> 
	placement
	subViewStates'!
!ViewState categoriesForClass!MVP-Views-Support! !
!ViewState methodsFor!

recordStateOf: aView forRecreate: aBoolean
	"Private - Initialize the receiver so that it is capable of restoring
	the <View>, aView, after it's handle has become invalid. The <boolean>
	argument, aBoolean, indicates whether the state will be used to
	immediately restore the receiver, in which case the state restoring
	flag is set on aView and all its sub-views as they are traversed.
	Note that the flag is set before the state is recorded, so it can be tested
	in the #state implementation, but this is not usually necessary."

	view := aView.
	aBoolean ifTrue: [view isStateRestoring: true].
	state := aView state.
	placement := aView placement.
	subViewStates := aView subViews collect: [:each |
		ViewState recordStateOf: each forRecreate: aBoolean]!

restore
	"Restore the receiver's view to its former glory"

	view isStateRestoring: true.
	view state: state.
	subViewStates do: [:each | each restore].
	view
		placement: placement;
		basicInvalidateLayout;
		isStateRestoring: false! !
!ViewState categoriesFor: #recordStateOf:forRecreate:!initializing!private! !
!ViewState categoriesFor: #restore!operations!public! !

!ViewState class methodsFor!

new
	"Private - Use #recordStateOf:"

	^self shouldNotImplement!

recordStateOf: aView forRecreate: aBoolean
	"Answer an instance of the receiver holding current state information about
	aView. This will allow aView's handle to be rebuilt when #restore is sent
	to this instance."

	^super new 
		recordStateOf: aView forRecreate: aBoolean! !
!ViewState class categoriesFor: #new!instance creation!private! !
!ViewState class categoriesFor: #recordStateOf:forRecreate:!instance creation!public! !

