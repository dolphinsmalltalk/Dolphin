﻿"Filed out from Dolphin Smalltalk"!

UI.View
	subclass: #'UI.DoubleBufferedView'
	instanceVariableNames: 'backSurface requiresRender'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.DoubleBufferedView guid: (Core.GUID fromString: '{f0757e5d-e398-4ede-9e0f-8c6ccb3699fc}')!

UI.DoubleBufferedView comment: ''!

!UI.DoubleBufferedView categoriesForClass!MVP-Views! !

!UI.DoubleBufferedView methodsFor!

canvas
	"Answer a <Canvas> onto the back surface"

	^backSurface canvas
		backcolor: self backcolor;
		yourself
		!

filerProxyIn: anSTxOutFiler
	| proxy |
	proxy := super filerProxyIn: anSTxOutFiler.
	proxy instVars at: ##(self indexOfInstVar: 'backSurface') put: nil.
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
	backSurface notNil ifTrue: [backSurface free].
	canvas := super canvas.
	backSurface := Bitmap compatible: canvas extent: aPointExtent.
	canvas free.
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

!UI.DoubleBufferedView categoriesForMethods!
canvas!accessing!public! !
filerProxyIn:!binary filing!private! !
flip!operations!public! !
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

