"Filed out from Dolphin Smalltalk"!

UI.ShellView
	subclass: #'UI.AbstractSplash'
	instanceVariableNames: 'splashDelay bitmap overlayWith'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!

UI.AbstractSplash guid: (Core.GUID fromString: '{18050c55-3f9f-40ff-8c3d-974a8250700e}')!

UI.AbstractSplash isNonInstantiable: true!

UI.AbstractSplash comment: ''!

!UI.AbstractSplash categoriesForClass!MVP-Views! !

!UI.AbstractSplash methodsFor!

bitmap: aBitmap
	"Private - Set the bitmap to display in the receiver"

	bitmap := aBitmap.
	self isOpen ifTrue: [self designExtent: self defaultExtent]!

close
	"Closes the receiver by cancelling the Delay the splash is waiting on"

	splashDelay signal!

defaultSplashDelay
	^self subclassResponsibility!

defaultWindowExStyle
	"Private - Answer the default extended window creation style.
	We use the WS_EX_TOOLWINDOW style to prevent splashes from appearing in the
	desktop tray."

	^super defaultWindowExStyle bitOr: WS_EX_TOOLWINDOW
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

	self showTimed: Semaphore new	!

showTimed
	"Shows the receiver and forks a process that will close it after the default delay"

	^self showTimed: self defaultSplashDelay	!

showTimed: aDelay 
	"Shows the receiver and forks a process that will close it after aDelay"

	(SessionManager current)
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

!UI.AbstractSplash categoriesForMethods!
bitmap:!accessing!initializing!private! !
close!operations!public! !
defaultSplashDelay!constants!public! !
defaultWindowExStyle!constants!private! !
forceClose!event handling!private! !
initialize!initializing!private! !
onLeftButtonPressed:!event handling!public! !
overlayWith!accessing!public! !
overlayWith:!accessing!public! !
show!operations!public! !
showTimed!operations!public! !
showTimed:!operations!public! !
showWindow!operations!private! !
!

!UI.AbstractSplash class methodsFor!

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

!UI.AbstractSplash class categoriesForMethods!
bitmap:!instance creation!public! !
bitmap:overlayWith:!instance creation!public! !
!

