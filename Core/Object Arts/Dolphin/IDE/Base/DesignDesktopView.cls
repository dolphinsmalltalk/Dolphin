"Filed out from Dolphin Smalltalk"!

DesktopView subclass: #DesignDesktopView
	instanceVariableNames: 'dpi'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DesignDesktopView guid: (GUID fromString: '{d1d4168d-347d-4e4c-b816-a73730045f7b}')!
DesignDesktopView comment: ''!
!DesignDesktopView categoriesForClass!MVP-Views! !
!DesignDesktopView methodsFor!

adjustPlacement: aWINDOWPLACEMENT ofShell: aShellView withResolution: aPoint
	"Private - The <ShellView> first argument is being restored from an STBViewProxy (e.g. instantiated from a view resource) on this desktop. Adjust the <WINDOWPLACEMENT> 2nd argument to an appropriate position and/or extent, and scale the view to the target monitor's DPI from the original resolution specified by the <point> 3rd argument."

	"Shell's are opened in a DesignDesktopView for design purposes, e.g. editing, so we want to leave the placement, etc, saved in the resource as is, just scaling to DPI."

	| monitor scale |
	monitor := DisplayMonitor active.
	scale := monitor dpi / aPoint.
	scale = 1
		ifFalse: 
			[aWINDOWPLACEMENT scaleBy: scale.
			aShellView resolutionScaledBy: scale].
	^self!

createShellWindow: aShellView withParameters: aWindowCreationParameters
	aShellView
		createWindowAt: Point.Zero
		extent: (aWindowCreationParameters extent = WindowCreationParameters.UseDefaultGeometry
				ifTrue: [self defaultWindowExtent]
				ifFalse: [aWindowCreationParameters extent * dpi / aWindowCreationParameters dpi])
		styles: {aWindowCreationParameters baseStyle.
				aWindowCreationParameters extendedStyle bitOr: WS_EX_NOACTIVATE}
		name: aWindowCreationParameters title!

defaultWindowExtent
	^##(800 @ 600) * self dpi // USER_DEFAULT_SCREEN_DPI!

dpi
	^dpi!

dpi: anInteger
	dpi := anInteger! !
!DesignDesktopView categoriesForMethods!
adjustPlacement:ofShell:withResolution:!geometry!private! !
createShellWindow:withParameters:!public! !
defaultWindowExtent!public! !
dpi!accessing!public! !
dpi:!initializing!private! !
!

!DesignDesktopView class methodsFor!

forDefaultDpi
	"Answer an instance of the receiver configured for device-independent pixels (aka DIPs, equivalent to 96-dpi)."

	^self forDpi: USER_DEFAULT_SCREEN_DPI!

forDpi: anInteger
	"Answer an instance of the receiver configured for the specified DPI."

	^self new
		handle: self current handle;
		dpi: anInteger;
		yourself!

forSystemDpi
	"Answer an instance of the receiver configured for the current primary monitor DPI."

	^self forDpi: UserLibrary default getDpiForSystem! !
!DesignDesktopView class categoriesForMethods!
forDefaultDpi!instance creation!public! !
forDpi:!instance creation!public! !
forSystemDpi!instance creation!public! !
!

