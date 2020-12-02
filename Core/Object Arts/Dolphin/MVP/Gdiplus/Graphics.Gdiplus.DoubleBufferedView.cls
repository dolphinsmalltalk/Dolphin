"Filed out from Dolphin Smalltalk 7"!

View subclass: #GdiplusDoubleBufferedView
	instanceVariableNames: 'backSurface requiresRender'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusDoubleBufferedView guid: (GUID fromString: '{3c1e8025-eba8-41c4-bd23-e8ba0536f783}')!
GdiplusDoubleBufferedView comment: ''!
!GdiplusDoubleBufferedView categoriesForClass!Unclassified! !
!GdiplusDoubleBufferedView methodsFor!

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

	backSurface notNil ifTrue: [ backSurface free ].
	backSurface := GdiplusBitmap extent: aPointExtent.
	self invalidate.
!

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
!GdiplusDoubleBufferedView categoriesFor: #backSurface!accessing!public! !
!GdiplusDoubleBufferedView categoriesFor: #flip!operations!public! !
!GdiplusDoubleBufferedView categoriesFor: #graphics!accessing!public! !
!GdiplusDoubleBufferedView categoriesFor: #initialize!initializing!private! !
!GdiplusDoubleBufferedView categoriesFor: #initializeSurfacesFor:!initializing!private! !
!GdiplusDoubleBufferedView categoriesFor: #invalidate!operations!public! !
!GdiplusDoubleBufferedView categoriesFor: #onCreated:!event handling!private! !
!GdiplusDoubleBufferedView categoriesFor: #onEraseRequired:!event handling!private! !
!GdiplusDoubleBufferedView categoriesFor: #onPaintRequired:!event handling!private! !
!GdiplusDoubleBufferedView categoriesFor: #onPositionChanged:!event handling!private! !
!GdiplusDoubleBufferedView categoriesFor: #refreshContents!public!updating! !
!GdiplusDoubleBufferedView categoriesFor: #render!operations!private! !
!GdiplusDoubleBufferedView categoriesFor: #repaint!operations!public! !
!GdiplusDoubleBufferedView categoriesFor: #wmNcHitTest:wParam:lParam:!event handling-win32!private! !

!GdiplusDoubleBufferedView class methodsFor!

defaultModel	
	^ListModel new! !
!GdiplusDoubleBufferedView class categoriesFor: #defaultModel!public! !

