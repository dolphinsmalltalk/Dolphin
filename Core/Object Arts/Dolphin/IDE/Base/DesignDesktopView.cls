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

adjustCreationParameters: aWindowCreationState forShell: aShellView
	"Private - The <ShellView> first argument is being created for the first time for design purposes (e.g. in the view composer). Answer a WindowCreationState based on that provided as the 2nd argument with any adjustments to position, extent, or styles, that are appropriate. This would typically involve determining the correct monitor on which to position the window, and either providing a default extent or scaling that specified to the monitor DPI."

	"Shell's are created in a DesignDesktopView for design purposes, e.g. editing a new view resource the view composer, so we want to create them at a suitable default extent that is not too large and without the normal cascading behaviour and ensure they do not have a taskbar icon."

	| extent |
	extent := aWindowCreationState extent.
	extent := extent = WindowCreationParameters.UseDefaultGeometry
				ifTrue: [self defaultWindowExtent]
				ifFalse: [extent * self dpi / aWindowCreationState dpi].
	^aWindowCreationState shallowCopy
		position: Point.Zero;
		extent: extent;
		dpi: self dpi;
		extendedStyle: (aWindowCreationState extendedStyle bitOr: WS_EX_NOACTIVATE);
		yourself!

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

defaultWindowExtent
	^##(800 @ 600) * self dpi // USER_DEFAULT_SCREEN_DPI!

dpi
	^dpi!

dpi: anInteger
	dpi := anInteger! !
!DesignDesktopView categoriesForMethods!
adjustCreationParameters:forShell:!geometry!private! !
adjustPlacement:ofShell:withResolution:!geometry!private! !
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

	^self forDpi: User32 getDpiForSystem! !
!DesignDesktopView class categoriesForMethods!
forDefaultDpi!instance creation!public! !
forDpi:!instance creation!public! !
forSystemDpi!instance creation!public! !
!

