"Filed out from Dolphin Smalltalk"!

UI.View
	subclass: #'Graphics.Gdiplus.DoubleBufferedView'
	instanceVariableNames: 'backSurface requiresRender graphics'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.DoubleBufferedView guid: (Core.GUID fromString: '{3c1e8025-eba8-41c4-bd23-e8ba0536f783}')!
Graphics.Gdiplus.DoubleBufferedView comment: ''!
!Graphics.Gdiplus.DoubleBufferedView methodsFor!

backSurface

	^backSurface 
		!

flip
	"Private - Flip the current back surface to the front and paint it"

	self isOpen
		ifTrue: 
			[| canvas |
			canvas := self canvas.
			backSurface
				drawOn: canvas
				at: 0 @ 0
				extent: backSurface extent.
			canvas free]!

graphics
	"Answer a <GdiplusGraphics> onto the back surface"

	^graphics ifNil: [graphics := backSurface graphics]!

initialize
	"Private - Initialise the receiver."

	super initialize.
	backcolor := Color white.
	requiresRender := false.
!

initializeSurfacesFor: aPointExtent
	"Private - Initialize the front and back surfaces for a view size of aPointExtent"

	backSurface notNil ifTrue: [backSurface free].
	backSurface := Gdiplus.Bitmap extent: aPointExtent.
	self invalidate!

invalidate
	"Flag the current rendition as being invalid. A repaint will cause a
	render to occur"

	requiresRender := true.
	super invalidate!

onCreated: anEvent
	"Private - Handler for view created "

	super onCreated: anEvent.
	self initializeSurfacesFor: self extent.
!

onEraseRequired: aColorEvent
	"Private - Handler for erase background"

	^true!

onPaintRequired: aPaintEvent
	"Private - Handler for paint event"

	requiresRender ifTrue: [ self render ].
	self flip.
!

onPositionChanged: aPositionEvent
	"Private - Handle a window position change event (move or resize)."

	aPositionEvent isResize ifTrue: [
		self initializeSurfacesFor: aPositionEvent extent.
		self repaint ].
	^super onPositionChanged: aPositionEvent!

refreshContents
	"The model held by the receiver has been changed so repaint" 

	self repaint
!

render
	"Private - Render the background image"

	requiresRender := false
!

repaint
	"Repaints the receiver"

	self render flip
!

wmNcHitTest: message wParam: wParam lParam: lParam 
	"Private - Default handler for a WM_NCHITTEST. 
	Answer nil to accept default window processing."

	self isTransparent ifTrue: [^HTTRANSPARENT].
	^super 
		wmNcHitTest: message
		wParam: wParam
		lParam: lParam! !
!Graphics.Gdiplus.DoubleBufferedView categoriesForMethods!
backSurface!accessing!public! !
flip!operations!public! !
graphics!accessing!public! !
initialize!initializing!private! !
initializeSurfacesFor:!initializing!private! !
invalidate!operations!public! !
onCreated:!event handling!private! !
onEraseRequired:!event handling!private! !
onPaintRequired:!event handling!private! !
onPositionChanged:!event handling!private! !
refreshContents!public!updating! !
render!operations!private! !
repaint!operations!public! !
wmNcHitTest:wParam:lParam:!event handling-win32!private! !
!

!Graphics.Gdiplus.DoubleBufferedView class methodsFor!

defaultModel
	^UI.ListModel new! !
!Graphics.Gdiplus.DoubleBufferedView class categoriesForMethods!
defaultModel!constants!public! !
!

