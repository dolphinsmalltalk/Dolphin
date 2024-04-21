"Filed out from Dolphin Smalltalk"!

Object subclass: #LayoutPlacement
	instanceVariableNames: 'view rectangle show'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!

LayoutPlacement guid: (GUID fromString: '{a6d52cfe-6403-4ec9-881b-ea5faa78ea9b}')!

LayoutPlacement comment: ''!

!LayoutPlacement categoriesForClass!Kernel-Objects! !

!LayoutPlacement methodsFor!

hasDeferredChange
	"Does the receiver describe a deferred change of view rectangle or visibility?"

	^(rectangle notNil and: [view getRect ~= rectangle])
		or: [show notNil and: [view hasVisibleStyle ~~ show]]!

isVisible
	^show ifNil: [view hasVisibleStyle]!

rectangle
	^rectangle!

rectangle: aRectangle
	rectangle := aRectangle!

show: aBoolean
	show := aBoolean!

showFlag
	^show ifNil: [0] ifNotNil: [show ifTrue: [SWP_SHOWWINDOW] ifFalse: [SWP_HIDEWINDOW]]!

view
	^view!

view: aView
	view := aView!

visibleExtent
	"Answer a <point> representing the extent of the associated view that is expected to be visible after the placement has been applied. This doesn't take into account partial visibility; if the view is to be visible it is assumed the whole extent will be visible. This is intended for use in determining the amount of space that should be reserved for a view as part of a layout calculation."

	self isVisible ifFalse: [^Point.Zero].
	rectangle ifNotNil: [:rect | ^rect extent].
	^view getWindowRect extent! !

!LayoutPlacement categoriesForMethods!
hasDeferredChange!operations!public!testing! !
isVisible!accessing!public! !
rectangle!accessing!public! !
rectangle:!accessing!public! !
show:!accessing!public! !
showFlag!operations!public! !
view!accessing!public! !
view:!initializing!private! !
visibleExtent!operations!public!testing! !
!

!LayoutPlacement class methodsFor!

view: aView
	^self new
		view: aView;
		yourself! !

!LayoutPlacement class categoriesForMethods!
view:!public! !
!

