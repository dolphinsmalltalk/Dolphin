"Filed out from Dolphin Smalltalk"!

UI.AbstractSplash
	subclass: #'UI.Splash'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Splash guid: (Core.GUID fromString: '{87b4c722-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.Splash comment: 'Splash is a class that implements a <topView> for displaying a modal splash screen style bitmap. 

A Splash window stays visible for a defined period of time indicated by the <Delay> passed to #showTimed:. If #showTimed is used, then a default delay period is automatically provided. If #show is used then the window remains visible for an indefinite period of time. One may choose to specify an overlay to be drawn on top of the bitmap using #overlayWith: and providing a suitable <monadicValuable> to perform the painting. 

Typically, one would choose to subclass Splash in order to override #onPaintRequired: 

Instance Variables:
	splashDelay	<Delay> indicating the period that the window remains visible.
	bitmap		<Bitmap> to display.
	overlayWith	<monadicValuable> or nil, specifying any paint actions to overlay the bitmap.

'!

!UI.Splash categoriesForClass!MVP-Views! !

!UI.Splash methodsFor!

creationFunction
	| extent d |
	extent := (bitmap isNil or: [bitmap handle isNull])
				ifTrue: 
					[d := USER_DEFAULT_SCREEN_DPI.
					200 @ 200]
				ifFalse: 
					[d := bitmap resolution x.
					bitmap extent * d // USER_DEFAULT_SCREEN_DPI + (self frameWidths * 2)].
	^CreateWindow
		rectangle: (self defaultPosition extent: extent)
		dpi: d
		styles: creationStyles!

defaultSplashDelay
	"Answer the default delay that a splash should be displayed for"

	^Delay forMilliseconds: 4000!

defaultWindowStyle
	"Private - Answer the default basic window creation style"

	^##(WS_POPUP | WS_DLGFRAME)
!

onPaintRequired: aPaintEvent
	"Handler for paint event. Show the bitmap and paint any overlay on top of it."

	| canvas |
	canvas := aPaintEvent canvas.
	bitmap notNil
		ifTrue: 
			[bitmap
				drawOn: canvas
				at: Point zero
				extent: self extent].
	self overlayWith ifNotNil: [:overlay | overlay value: canvas]! !

!UI.Splash categoriesForMethods!
creationFunction!geometry!private!realizing/unrealizing! !
defaultSplashDelay!constants!public! !
defaultWindowStyle!constants!private! !
onPaintRequired:!event handling!public! !
!

