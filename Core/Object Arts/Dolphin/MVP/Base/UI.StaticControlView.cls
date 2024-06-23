"Filed out from Dolphin Smalltalk"!

UI.StaticView
	subclass: #'UI.StaticControlView'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.StaticControlView guid: (Core.GUID fromString: '{bb272e98-57bb-428c-a745-4377f02d2ba2}')!

UI.StaticControlView isNonInstantiable: true!

UI.StaticControlView comment: ''!

!UI.StaticControlView methodsFor!

defaultWindowStyle
	"Private - Answer a default style to use when creating a static control. We specify the
	SS_NOTIFY style to ensure that we are notified of mouse clicks."

	^super defaultWindowStyle bitOr: SS_NOTIFY!

invalidateRect: rectangle erase: eraseBoolean 
	"Invalidates the specified client rectangle (a RECTL, Rectangle, or nil for the whole client window).
	Set whether to erase the receiver's background before repainting. Answer whether the function succeeds.
	Static views appear to behave in an odd way that requires us to perform the invalidation in the
	parent rectangle"

	| rect |
	rect := rectangle ifNil: [self clientRectangle].
	^self parentView invalidateRect: (self mapRectangle: rect to: self parentView) erase: eraseBoolean!

isSunken
	"Answer whether the receiver has the SS_SUNKEN edge style (a half-sunken border)."

	^self baseStyleAllMask: SS_SUNKEN!

isSunken: aBoolean 
	"Set whether the receiver has the SS_SUNKEN edge style (a half-sunken border). This appears
	to be very similar to the static edge style."

	self 
		baseStyleMask: SS_SUNKEN
		set: aBoolean
		recreateIfChanged: true	"Recreate required for this change to take effect"! !

!UI.StaticControlView categoriesForMethods!
defaultWindowStyle!constants!private! !
invalidateRect:erase:!drawing!public! !
isSunken!accessing-styles!public!testing! !
isSunken:!accessing-styles!public! !
!

!UI.StaticControlView class methodsFor!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'STATIC'
! !

!UI.StaticControlView class categoriesForMethods!
winClassName!constants!private! !
!

