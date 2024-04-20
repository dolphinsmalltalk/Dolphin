"Filed out from Dolphin Smalltalk"!

UI.DesktopView
	subclass: #'Tools.DesignDesktopView'
	instanceVariableNames: 'dpiAwareness dpi'
	classVariableNames: 'Default System'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.DesignDesktopView guid: (Core.GUID fromString: '{d1d4168d-347d-4e4c-b816-a73730045f7b}')!

Tools.DesignDesktopView comment: ''!

!Tools.DesignDesktopView categoriesForClass!MVP-Views! !

!Tools.DesignDesktopView methodsFor!

adjustPlacementOfShell: aShellView forResolution: aPoint
	"Private - The <ShellView> first argument is being restored from an STBViewProxy (e.g. instantiated from a view resource) on this desktop. Adjust the placement of the window to an appropriate position and/or extent on the target monitor, also scaling any internal measurments to the monitor's DPI from the original resolution specified by the <point> final argument."

	"Shell's are opened in a DesignDesktopView for design purposes, e.g. editing, so we to leave the placement saved in the resource as is. We scale to DPI if needed, although usually this won't be required as we will be operating at the design DPI in which view resources are edited and saved. Occassionally we may open a resource at a different DPI, e.g. for previewing at system DPI."

	aPoint = dpi ifTrue: [^self].
	aShellView resolutionScaledBy: dpi / aPoint!

awarenessContext: awarenessInteger
	dpiAwareness := awarenessInteger.
	self initialize.
	^self!

createShellWindow: aShellView withFunction: aCreateWindow
	aCreateWindow
		position: Point.Zero
		extent: (aCreateWindow hasDefaultExtent
				ifTrue: [self defaultWindowExtent]
				ifFalse: [aCreateWindow extent * dpi // aCreateWindow dpi])
		dpi: dpi.
	aShellView basicCreateWindow: aCreateWindow!

defaultWindowExtent
	^##(800 @ 600) * self dpi // USER_DEFAULT_SCREEN_DPI!

dpi
	^dpi!

dpiAwareness
	"Answer the symbolic name of the DPI awareness mode for this design desktop."

	^OS.UserLibrary.DpiAwarenessContexts at: dpiAwareness negated!

dpiAwarenessContext
	^dpiAwareness!

initialize
	handle := self class desktopHandle.
	dpi := OS.User32 getDpiFromDpiAwarenessContext: dpiAwareness!

loadViewResource: aResourceArray forEdit: isLoadingForEdit
	^OS.User32 inDpiAwarenessContext: dpiAwareness
		do: [super loadViewResource: aResourceArray forEdit: isLoadingForEdit]!

printOn: aStream
	aStream
		display: self class;
		space;
		nextPutAll: self dpiAwareness! !

!Tools.DesignDesktopView categoriesForMethods!
adjustPlacementOfShell:forResolution:!geometry!private! !
awarenessContext:!initializing!private! !
createShellWindow:withFunction:!operations!public! !
defaultWindowExtent!constants!public! !
dpi!accessing!high DPI!public! !
dpiAwareness!accessing!high DPI!public! !
dpiAwarenessContext!accessing!high DPI!public! !
initialize!initializing!private! !
loadViewResource:forEdit:!binary filing!public! !
printOn:!development!printing!public! !
!

!Tools.DesignDesktopView class methodsFor!

awarenessContext: awarenessInteger
	"Private - Answer an instance of the receiver configured for the specified DPI."

	^self basicNew
		awarenessContext: awarenessInteger;
		yourself!

default
	"Answer an instance of the receiver configured for device-independent pixels (aka DIPs, equivalent to 96-dpi). The GDI scaling context is used because this gives much better results, avoiding blurry text."

	^Default ifNil: [Default := self awarenessContext: DPI_AWARENESS_CONTEXT_UNAWARE_GDISCALED]!

gdiScaled
	"Answer an instance of the receiver configured for device-independent pixels (aka DIPs, equivalent to 96-dpi) with GDI scaling."

	^self default!

onStartup
	Default ifNotNil: [Default initialize].
	System ifNotNil: [System initialize]!

perMonitor
	^self current!

system
	"Answer an instance of the receiver configured for the current primary monitor DPI."

	^System ifNil: [System := self awarenessContext: DPI_AWARENESS_CONTEXT_SYSTEM_AWARE]!

unaware
	"Answer a DPI unaware instance of the receiver (96-dpi, bitmap scaling)."

	^self awarenessContext: DPI_AWARENESS_CONTEXT_UNAWARE! !

!Tools.DesignDesktopView class categoriesForMethods!
awarenessContext:!instance creation!private! !
default!instance creation!public! !
gdiScaled!instance creation!public! !
onStartup!event handling!public! !
perMonitor!instance creation!public! !
system!instance creation!public! !
unaware!instance creation!public! !
!

