"Filed out from Dolphin Smalltalk 7"!

ShellView subclass: #DesktopDoubleBufferedView
	instanceVariableNames: 'backSurface frontSurface graphics'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DesktopDoubleBufferedView guid: (GUID fromString: '{f9bcfadc-355d-4b3d-be76-3e8481c0511f}')!
DesktopDoubleBufferedView comment: ''!
!DesktopDoubleBufferedView categoriesForClass!Unclassified! !
!DesktopDoubleBufferedView methodsFor!

alphaPercentage
	^100!

backSurface
	"Private - Answer the GdiplusGraphics back surface"

	^backSurface!

defaultWindowExStyle
	"Private - Answer the default extended window creation style.
	We use the WS_EX_TOOLWINDOW style to prevent splashes from appearing in the
	desktop tray."

	^super defaultWindowExStyle bitOr: WS_EX_TOOLWINDOW | WS_EX_LAYERED
!

defaultWindowStyle
	"Private - Answer the default basic window creation style"

	^##(WS_POPUP)!

flip
	"Private - Flip the current back surface to the front and paint it"

	| temp |
	graphics free.
	temp := frontSurface.
	frontSurface := backSurface.
	backSurface := temp.
	graphics := backSurface graphics.
	self graphics clear: self backcolor!

frontSurface
	"Private - Answer the GdiplusGraphics front surface"

	^frontSurface!

graphics
	^graphics!

initializeSurfacesFor: aPointExtent 
	"Private - Initialize the front and back surfaces for a view size of aPointExtent"

	backSurface notNil ifTrue: [backSurface free].
	backSurface := GdiplusBitmap extent: aPointExtent.
	graphics := backSurface graphics.
	frontSurface notNil ifTrue: [frontSurface free].
	frontSurface := GdiplusBitmap extent: aPointExtent!

onCreated: anEvent
	"Private - Handler for view created "

	super onCreated: anEvent.
	self initializeSurfacesFor: self extent.
	User32 
		setLayeredWindowAttributes: self handle
		lcrKey: 0
		bAlpha: self alphaPercentage*255//100
		dwFlags: LWA_ALPHA
!

onEraseRequired: aColorEvent 
	^false!

onPaintRequired: aPaintEvent 
	"Private - Handler for paint event"

	| graphics canvas |
	canvas := aPaintEvent canvas.
	graphics := GdiplusGraphics fromCanvas: canvas.
	graphics drawImage: self frontSurface.
	graphics free.
	canvas free!

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

repaint
	"Repaints the receiver"

	self flip invalidate update!

wmNcHitTest: message wParam: wParam lParam: lParam 
	"Private - Default handler for a WM_NCHITTEST. 
	Answer nil to accept default window processing."

	self isTransparent ifTrue: [^HTTRANSPARENT].
	^super 
		wmNcHitTest: message
		wParam: wParam
		lParam: lParam! !
!DesktopDoubleBufferedView categoriesFor: #alphaPercentage!public! !
!DesktopDoubleBufferedView categoriesFor: #backSurface!private! !
!DesktopDoubleBufferedView categoriesFor: #defaultWindowExStyle!private! !
!DesktopDoubleBufferedView categoriesFor: #defaultWindowStyle!private! !
!DesktopDoubleBufferedView categoriesFor: #flip!private! !
!DesktopDoubleBufferedView categoriesFor: #frontSurface!private! !
!DesktopDoubleBufferedView categoriesFor: #graphics!public! !
!DesktopDoubleBufferedView categoriesFor: #initializeSurfacesFor:!private! !
!DesktopDoubleBufferedView categoriesFor: #onCreated:!private! !
!DesktopDoubleBufferedView categoriesFor: #onEraseRequired:!event handling!private! !
!DesktopDoubleBufferedView categoriesFor: #onPaintRequired:!private! !
!DesktopDoubleBufferedView categoriesFor: #onPositionChanged:!private! !
!DesktopDoubleBufferedView categoriesFor: #refreshContents!public! !
!DesktopDoubleBufferedView categoriesFor: #repaint!public! !
!DesktopDoubleBufferedView categoriesFor: #wmNcHitTest:wParam:lParam:!private! !

