"Filed out from Dolphin Smalltalk"!

UI.ValueConvertingControlView
	subclass: #'UI.StaticView'
	instanceVariableNames: 'unused'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.StaticView guid: (Core.GUID fromString: '{87b4c739-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.StaticView comment: 'StaticView is an abstract <valueView> class for implementing the Windows ''STATIC'' control class. The subclasses are intended to display model data but they do not allow it to be edited by the user.

Instance Variables:
	unused	<UndefinedObject> reserved for future use.

'!
!UI.StaticView categoriesForClass!MVP-Views! !
!UI.StaticView methodsFor!

defaultBackcolor
	"Private - Answer the default colour for the receiver's background"

	^Color.Face3d!

defaultExtent
	"Private - Answer the default size of the receiver
	to be used when it is created."

	^##(100 @ 100)
!

defaultWindowStyle
	"Private - Answer a default style to use when creating a static control. We specify the
	SS_NOTIFY style to ensure that we are notified of mouse clicks."

	^(super defaultWindowStyle maskClear: WS_TABSTOP) bitOr: SS_NOTIFY
!

invalidateOnResize
	"Private - The Windows static controls do not normally expect to be resized so they do not redraw correctly. We therefore force them to redraw on resize."

	^true!

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
		recreateIfChanged: true	"Recreate required for this change to take effect"!

onLeftButtonDoubleClicked: aMouseEvent
	"Default handler for a mouse left button double-click event."

	| answer |
	answer := super onLeftButtonDoubleClicked: aMouseEvent.
	self presenter performAction.
	^answer!

onPositionChanged: aPositionEvent
	"Handle a window position change event (move or resize).
	Implementation Note:  The Windows static controls do not normally expect to be resized
	so they do not redraw correctly. We therefore force a redraw here."

	(self invalidateOnResize and: [aPositionEvent isResize]) ifTrue: [self invalidate].
	^super onPositionChanged: aPositionEvent!

updateModel
	"Flush changes in the view back to the associated model.
	Static views don't allow such changes"! !
!UI.StaticView categoriesForMethods!
defaultBackcolor!colors!constants!private! !
defaultExtent!constants!private! !
defaultWindowStyle!constants!private! !
invalidateOnResize!private!testing! !
invalidateRect:erase:!drawing!public! !
isSunken!accessing-styles!public!testing! !
isSunken:!accessing-styles!public! !
onLeftButtonDoubleClicked:!event handling!public! !
onPositionChanged:!event handling-win32!public! !
updateModel!public!updating! !
!

!UI.StaticView class methodsFor!

stbConvertFromVersion12: anArray 
	"Private - Perform an STB conversion from a version 12 <StaticView> to version 13."

	"Leave as is for static views - these should typically inherit the backcolor anyway"
	^anArray!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'STATIC'
! !
!UI.StaticView class categoriesForMethods!
stbConvertFromVersion12:!binary filing!private! !
winClassName!constants!private! !
!

