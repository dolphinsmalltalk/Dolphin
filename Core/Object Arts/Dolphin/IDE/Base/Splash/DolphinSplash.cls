"Filed out from Dolphin Smalltalk"!

Splash subclass: #DolphinSplash
	instanceVariableNames: 'objectsInside'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DolphinSplash guid: (GUID fromString: '{87b4c724-026e-11d3-9fd7-00a0cc3e4a32}')!

DolphinSplash comment: 'DolphinSplash is the Dolphin development system''s spash screen. It extends <Splash> to use a titleless dialog frame and to overlap the Dolphin version information and legal copyright notice onto the splash screen graphic.

To display the splash screen, evaluate:

self new show'!

!DolphinSplash categoriesForClass!MVP-Views! !

!DolphinSplash methodsFor!

animationDuration
	"Private - Answer the duration (in ms) of the splash animation"

	^3500!

creationExtent
	"Private - Answer extent in device pels at which the receiver should be created. This is typically the default design extent at 96 dpi (aka Dips, or device-independent pixels), scaled to the parent's DPI.
	This should only used for determining the creation size, and requires that the parent has been set in advance."

	^self objectsInside creationExtent!

defaultExtent
	"Private - Answer the default size of the receiver in device-independent pixels (96-dpi). This is used only to determine the size of a view when it is created (although after scaling DIPs to the display DPI - see #creationExtent). Thereafter preferredExtent is used when the desired size of a view is requested."
	
	"As we have pre-scaled the background bitmap not just for DPI, but to fit, it makes more sense to provide a scaled extent directly by overriding #creationExtent, in which case this should not be called."

	^self shouldNotImplement!

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

!DolphinSplash categoriesForMethods!
animationDuration!constants!private! !
creationExtent!geometry!private!realizing/unrealizing! !
defaultExtent!constants!public! !
defaultSplashDelay!constants!public! !
defaultWindowStyle!constants!private! !
give256ColorDisplayWarning!operations!private! !
objectsInside!accessing!private! !
onCreated:!event handling!private! !
onPaintRequired:!event handling!private! !
showWindow!operations!private! !
!

!DolphinSplash class methodsFor!

canDisplay
	"Answer true if an instance of the receiver can be correctly displayed"

	"Displays of less than 800x600 resolution or with a palette cannot correctly display the Dolphin
	splash bitmap. Also Win95/NT can't do the alpha blending thing."

	| desktopCanvas |
	desktopCanvas := Canvas forDesktop.
	^(desktopCanvas colorDepth > 8 and: [desktopCanvas extent >= (800 @ 600)]) 
		and: [SystemMetrics current supportsAlphaBlending]!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by instances of the receiver."

	^super publishedAspects
		add: (Aspect boolean: #splashPlayTheGame);
		yourself!

splashPlayTheGame
	^SeeingTheObjectsInside splashPlayTheGame!

splashPlayTheGame: aBoolean 
	SeeingTheObjectsInside splashPlayTheGame: aBoolean! !

!DolphinSplash class categoriesForMethods!
canDisplay!accessing!public! !
publishedAspects!public! !
splashPlayTheGame!accessing!public! !
splashPlayTheGame:!accessing!public! !
!

