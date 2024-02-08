"Filed out from Dolphin Smalltalk"!

UI.ValueConvertingControlView
	subclass: #'UI.StaticView'
	instanceVariableNames: 'unused'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.StaticView guid: (Core.GUID fromString: '{87b4c739-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.StaticView isNonInstantiable: true!

UI.StaticView comment: '`StaticView` is an abstract `<valueView>` class for implementing read-only (aka static) visual controls. The subclasses are intended to display model data but they do not allow it to be edited by the user.

##Instance Variables:
  unused	`<UndefinedObject>`. Reserved for future use.

'!

!UI.StaticView categoriesForClass!MVP-Views! !

!UI.StaticView methodsFor!

defaultBackcolor
	"Private - Answer the default colour for the receiver's background"

	^Color.Face3d!

defaultExtent
	"Private - Answer the default size of the receiver in device-independent pixels (96-dpi DIPs). This is used only to determine the size of a view when it is created (although after scaling DIPs to the monitor DPI). Thereafter #preferredExtent is used when the desired size of a view is requested."

	^##(100 @ 100)
!

defaultWindowStyle
	"Private - Answer a default style to use when creating a static control."

	^super defaultWindowStyle bitAnd: ##(WS_TABSTOP bitInvert)!

invalidateOnResize
	"Private - The Windows static controls do not normally expect to be resized so they do not redraw correctly. We therefore force them to redraw on resize."

	^true!

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
onLeftButtonDoubleClicked:!event handling!public! !
onPositionChanged:!event handling-win32!public! !
updateModel!public!updating! !
!

!UI.StaticView class methodsFor!

stbConvertFromVersion12: anArray 
	"Private - Perform an STB conversion from a version 12 <StaticView> to version 13."

	"Leave as is for static views - these should typically inherit the backcolor anyway"
	^anArray! !

!UI.StaticView class categoriesForMethods!
stbConvertFromVersion12:!binary filing!private! !
!

