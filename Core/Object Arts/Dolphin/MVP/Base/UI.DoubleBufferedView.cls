"Filed out from Dolphin Smalltalk 7"!

View subclass: #DoubleBufferedView
	instanceVariableNames: 'backSurface requiresRender'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DoubleBufferedView guid: (GUID fromString: '{f0757e5d-e398-4ede-9e0f-8c6ccb3699fc}')!
DoubleBufferedView comment: ''!
!DoubleBufferedView categoriesForClass!Unclassified! !
!DoubleBufferedView methodsFor!

canvas
	"Answer a <Canvas> onto the back surface"

	^backSurface canvas
		backcolor: self backcolor;
		yourself
		!

filerProxy
	| saved proxy |
	saved := backSurface.
	backSurface := nil.
	proxy := super filerProxy.
	backSurface := saved.
	^proxy!

flip
	"Private - Flip the current back surface to the front and paint it"

	| canvas |
	canvas := super canvas.
	backSurface
		drawOn: canvas
		at: 0 @ 0
		extent: backSurface extent.
	canvas free!

initialize
	"Private - Initialise the receiver."

	super initialize.
	backcolor := Color white.
	requiresRender := false.
!

initializeSurfacesFor: aPointExtent
	"Private - Initialize the front and back surfaces for a view size of aPointExtent"

	| canvas |

	backSurface notNil ifTrue: [ backSurface free ].
	canvas := super canvas.
	backSurface := Bitmap compatible: canvas extent: aPointExtent.
	canvas free.
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
!DoubleBufferedView categoriesFor: #canvas!accessing!public! !
!DoubleBufferedView categoriesFor: #filerProxy!binary filing!private! !
!DoubleBufferedView categoriesFor: #flip!operations!public! !
!DoubleBufferedView categoriesFor: #initialize!initializing!private! !
!DoubleBufferedView categoriesFor: #initializeSurfacesFor:!initializing!private! !
!DoubleBufferedView categoriesFor: #invalidate!operations!public! !
!DoubleBufferedView categoriesFor: #onCreated:!event handling!private! !
!DoubleBufferedView categoriesFor: #onEraseRequired:!event handling!private! !
!DoubleBufferedView categoriesFor: #onPaintRequired:!event handling!private! !
!DoubleBufferedView categoriesFor: #onPositionChanged:!event handling!private! !
!DoubleBufferedView categoriesFor: #refreshContents!public!updating! !
!DoubleBufferedView categoriesFor: #render!operations!private! !
!DoubleBufferedView categoriesFor: #repaint!operations!public! !
!DoubleBufferedView categoriesFor: #wmNcHitTest:wParam:lParam:!event handling-win32!private! !

