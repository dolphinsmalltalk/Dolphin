"Filed out from Dolphin Smalltalk"!

UI.ShellView
	subclass: #'UI.Splash'
	instanceVariableNames: 'splashDelay bitmap overlayWith'
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

bitmap: aBitmap
	"Private - Set the bitmap to display in the receiver"

	bitmap := aBitmap.
	self isOpen ifTrue: [self normalizedExtent: self defaultExtent]!

close
	"Closes the receiver by cancelling the Delay the splash is waiting on"

	splashDelay signal!

defaultExtent
	"Answer the default size of the receiver"

	(bitmap isNil or: [bitmap handle isNull]) ifTrue: [^200@200].
	^bitmap extent + (self frameWidths * 2)!

defaultSplashDelay
	"Answer the default delay that a splash should be displayed for"

	^Delay forMilliseconds: 4000!

defaultWindowExStyle
	"Private - Answer the default extended window creation style.
	We use the WS_EX_TOOLWINDOW style to prevent splashes from appearing in the
	desktop tray."

	^super defaultWindowExStyle bitOr: WS_EX_TOOLWINDOW
!

defaultWindowStyle
	"Private - Answer the default basic window creation style"

	^##(WS_POPUP | WS_DLGFRAME)
!

forceClose
	"Private - Handler for image save. Insist that the splash is forcefully closed before any image save."

	splashDelay terminateProcess.
	self destroy!

initialize
	"Private - Initialize the receiver. Create centered by default."

	super initialize.
	self isInitiallyCentered: true.
!

onLeftButtonPressed: aMouseEvent
	"Splash shells go away when clicked"

	self close.
	^0!

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
	self overlayWith ifNotNil: [:overlay | overlay value: canvas]!

overlayWith
	"Answer the <monadicValuable> that can be used to paint an overlay over the 
	basic splash bitmap. A canvas is passed as the single parameter."
	
	^overlayWith!

overlayWith: aMonadicValuable
	"Sets the <monadicValuable> that can be used to paint an overlay over the 
	basic splash bitmap. A canvas is passed as the single parameter."
	
	overlayWith := aMonadicValuable!

show
	"Shows the receiver for an indefinite time"

	self showTimed: Semaphore new!

showTimed
	"Shows the receiver and forks a process that will close it after the default delay"

	^self showTimed: self defaultSplashDelay	!

showTimed: aDelay
	"Shows the receiver and forks a process that will close it after aDelay"

	SessionManager current
		when: #imageSaveStarting
			send: #forceClose
			to: self;
		when: #quitSessionRequested
			send: #forceClose
			to: self.
	splashDelay := aDelay.
	self showWindow.
	
	[splashDelay wait.
	super close] fork.
	^true!

showWindow
	"Private - Display the view."

	super show.
	self beTopMost; update! !

!UI.Splash categoriesForMethods!
bitmap:!accessing!initializing!private! !
close!operations!public! !
defaultExtent!constants!public! !
defaultSplashDelay!constants!public! !
defaultWindowExStyle!constants!private! !
defaultWindowStyle!constants!private! !
forceClose!event handling!private! !
initialize!initializing!private! !
onLeftButtonPressed:!event handling!public! !
onPaintRequired:!event handling!public! !
overlayWith!accessing!public! !
overlayWith:!accessing!public! !
show!operations!public! !
showTimed!operations!public! !
showTimed:!operations!public! !
showWindow!operations!private! !
!

!UI.Splash class methodsFor!

bitmap: aBitmap
	"Creates an instance of the receiver that will display aBitmap"
 
	^self bitmap: aBitmap overlayWith: nil

	!

bitmap: aBitmap overlayWith: aBlock
	"Creates an instance of the receiver that will display aBitmap and then
	overlay this with some further painting specified in aBlock."

	^super new
		bitmap: aBitmap;
		overlayWith: aBlock;
		create;
		yourself
	! !

!UI.Splash class categoriesForMethods!
bitmap:!instance creation!public! !
bitmap:overlayWith:!instance creation!public! !
!

