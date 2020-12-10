"Filed out from Dolphin Smalltalk 7"!

UI.Splash subclass: #'Tools.DolphinSplash'
	instanceVariableNames: 'objectsInside'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.DolphinSplash guid: (Core.GUID fromString: '{87b4c724-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.DolphinSplash comment: 'DolphinSplash is the Dolphin development system''s spash screen. It extends <Splash> to use a titleless dialog frame and to overlap the Dolphin version information and legal copyright notice onto the splash screen graphic.

To display the splash screen, evaluate:

self new show'!
!Tools.DolphinSplash categoriesForClass!MVP-Views! !
!Tools.DolphinSplash methodsFor!

animationDuration
	"Private - Answer the duration (in ms) of the splash animation"

	^3500!

defaultExtent
	"Answer the default size of the receiver"

	^self objectsInside defaultExtent!

defaultSplashDelay
	"Answer the default delay that a splash should be displayed for"

	^Delay forMilliseconds: 60000!

defaultWindowStyle
	"Private - Answer the default basic window creation style"

	^##(WS_POPUP)!

give256ColorDisplayWarning
	(MessageBox new)
		isSuppressible: true;
		uniqueId: [self] method;
		caption: 'Performance Warning';
		warning: 'Dolphin Smalltalk has detected that your computer is configured for a display mode of 256 colors or fewer. 

We recommend that you exit Dolphin and change the display mode to High Color (16 bit) or True Color (24/32 bit). If your display adapter does not support these modes, you can continue to use the product with the existing configuration but you will find that the user interface appearance will be significantly impaired.'!

objectsInside
	^objectsInside ifNil: [objectsInside := SeeingTheObjectsInside new]!

onCreated: anEvent

	"Private - shell := ShellView new create; yourself.
	shell extent: (shell calcExtentFromClientExtent: self defaultExtent).
	shell layoutManager: GridLayout new."

	self addSubView: self objectsInside.
	super onCreated: anEvent

!

onPaintRequired: aPaintEvent
	"Private - Handler for paint event."!

showWindow
	"Private - Display the view (if the display has sufficient resolution and colour depth)."

	SessionManager current playStartupSound.
	self class canDisplay 
		ifTrue: [super showWindow]
		ifFalse: [Canvas forDesktop colorDepth < 16 ifTrue: [self give256ColorDisplayWarning]]! !
!Tools.DolphinSplash categoriesFor: #animationDuration!constants!private! !
!Tools.DolphinSplash categoriesFor: #defaultExtent!accessing!public! !
!Tools.DolphinSplash categoriesFor: #defaultSplashDelay!constants!public! !
!Tools.DolphinSplash categoriesFor: #defaultWindowStyle!constants!private! !
!Tools.DolphinSplash categoriesFor: #give256ColorDisplayWarning!operations!private! !
!Tools.DolphinSplash categoriesFor: #objectsInside!accessing!private! !
!Tools.DolphinSplash categoriesFor: #onCreated:!event handling!private! !
!Tools.DolphinSplash categoriesFor: #onPaintRequired:!event handling!private! !
!Tools.DolphinSplash categoriesFor: #showWindow!operations!private! !

!Tools.DolphinSplash class methodsFor!

canDisplay
	"Answer true if an instance of the receiver can be correctly displayed"

	"Displays of less than 800x600 resolution or with a palette cannot correctly display the Dolphin
	splash bitmap. Also Win95/NT can't do the alpha blending thing."

	| desktopCanvas |
	desktopCanvas := Canvas forDesktop.
	^(desktopCanvas colorDepth > 8 and: [desktopCanvas extent >= (800 @ 600)]) 
		and: [OS.SystemMetrics current supportsAlphaBlending]!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by instances of the receiver."

	^super publishedAspects
		add: (Aspect boolean: #splashPlayTheGame);
		yourself!

splashPlayTheGame
	^SeeingTheObjectsInside splashPlayTheGame!

splashPlayTheGame: aBoolean
	SeeingTheObjectsInside splashPlayTheGame: aBoolean! !
!Tools.DolphinSplash class categoriesFor: #canDisplay!accessing!public! !
!Tools.DolphinSplash class categoriesFor: #publishedAspects!public! !
!Tools.DolphinSplash class categoriesFor: #splashPlayTheGame!accessing!public! !
!Tools.DolphinSplash class categoriesFor: #splashPlayTheGame:!accessing!public! !

