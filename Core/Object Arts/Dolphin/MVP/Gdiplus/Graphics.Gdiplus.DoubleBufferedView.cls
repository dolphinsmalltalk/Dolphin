"Filed out from Dolphin Smalltalk 7"!

UI.View subclass: #'Graphics.Gdiplus.DoubleBufferedView'
	instanceVariableNames: 'backSurface requiresRender'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.DoubleBufferedView guid: (Core.GUID fromString: '{3c1e8025-eba8-41c4-bd23-e8ba0536f783}')!
Graphics.Gdiplus.DoubleBufferedView comment: ''!
!Graphics.Gdiplus.DoubleBufferedView categoriesForClass!Unclassified! !
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

	^backSurface graphics
		!

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
!Graphics.Gdiplus.DoubleBufferedView categoriesFor: #backSurface!accessing!public! !
!Graphics.Gdiplus.DoubleBufferedView categoriesFor: #flip!operations!public! !
!Graphics.Gdiplus.DoubleBufferedView categoriesFor: #graphics!accessing!public! !
!Graphics.Gdiplus.DoubleBufferedView categoriesFor: #initialize!initializing!private! !
!Graphics.Gdiplus.DoubleBufferedView categoriesFor: #initializeSurfacesFor:!initializing!private! !
!Graphics.Gdiplus.DoubleBufferedView categoriesFor: #invalidate!operations!public! !
!Graphics.Gdiplus.DoubleBufferedView categoriesFor: #onCreated:!event handling!private! !
!Graphics.Gdiplus.DoubleBufferedView categoriesFor: #onEraseRequired:!event handling!private! !
!Graphics.Gdiplus.DoubleBufferedView categoriesFor: #onPaintRequired:!event handling!private! !
!Graphics.Gdiplus.DoubleBufferedView categoriesFor: #onPositionChanged:!event handling!private! !
!Graphics.Gdiplus.DoubleBufferedView categoriesFor: #refreshContents!public!updating! !
!Graphics.Gdiplus.DoubleBufferedView categoriesFor: #render!operations!private! !
!Graphics.Gdiplus.DoubleBufferedView categoriesFor: #repaint!operations!public! !
!Graphics.Gdiplus.DoubleBufferedView categoriesFor: #wmNcHitTest:wParam:lParam:!event handling-win32!private! !

!Graphics.Gdiplus.DoubleBufferedView class methodsFor!

defaultModel
	^UI.ListModel new! !
!Graphics.Gdiplus.DoubleBufferedView class categoriesFor: #defaultModel!public! !

