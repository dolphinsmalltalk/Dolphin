"Filed out from Dolphin Smalltalk"!

UI.DesktopView
	subclass: #'Tools.DesignDesktopView'
	instanceVariableNames: 'dpiAwareness dpi'
	classVariableNames: 'Default System Unaware'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.DesignDesktopView guid: (Core.GUID fromString: '{d1d4168d-347d-4e4c-b816-a73730045f7b}')!

Tools.DesignDesktopView comment: ''!

!Tools.DesignDesktopView categoriesForClass!MVP-Views! !

!Tools.DesignDesktopView methodsFor!

addSubView: aView
	^dpiAwareness inContextDo: [super addSubView: aView]!

adjustPlacementOfShell: aShellView forResolution: aPoint
	"Private - The <ShellView> first argument is being restored from an STBViewProxy (e.g. instantiated from a view resource) on this desktop. Adjust the placement of the window to an appropriate position and/or extent on the target monitor, also scaling any internal measurments to the monitor's DPI from the original resolution specified by the <point> final argument."

	"Shell's are opened in a DesignDesktopView for design purposes, e.g. editing, so we to leave the placement saved in the resource as is. We scale to DPI if needed, although usually this won't be required as we will be operating at the design DPI in which view resources are edited and saved. Occassionally we may open a resource at a different DPI, e.g. for previewing at system DPI as this can be useful to check layout after scaling."

	aPoint = dpi ifTrue: [^self].
	aShellView resolutionScaledBy: dpi / aPoint!

assumeDesktopHandle
	handle := self class desktopHandle.
	dpi := dpiAwareness dpi!

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
	aShellView
		dpi: dpi;
		basicCreateWindow: aCreateWindow!

defaultWindowExtent
	^##(800 @ 600) * self dpi // USER_DEFAULT_SCREEN_DPI!

dpi
	^dpi!

dpiAwareness
	"Answer the <DpiAwareness> context of this design desktop."

	^dpiAwareness!

loadViewResource: aResourceArray forEdit: isLoadingForEdit
	^dpiAwareness inContextDo: [super loadViewResource: aResourceArray forEdit: isLoadingForEdit]!

metrics
	"Answer a <SytemMetrics> instance that can provide standard measurements scaled to the receiver's current DPI."

	^OS.SystemMetrics forDpi: dpi!

printOn: aStream
	aStream
		display: self class;
		space;
		display: self dpiAwareness name! !

!Tools.DesignDesktopView categoriesForMethods!
addSubView:!hierarchy!public!sub views! !
adjustPlacementOfShell:forResolution:!geometry!private! !
assumeDesktopHandle!initializing!private! !
awarenessContext:!initializing!private! !
createShellWindow:withFunction:!operations!public! !
defaultWindowExtent!constants!public! !
dpi!accessing!high DPI!public! !
dpiAwareness!accessing!high DPI!public! !
loadViewResource:forEdit:!binary filing!public! !
metrics!public! !
printOn:!development!printing!public! !
!

!Tools.DesignDesktopView class methodsFor!

default
	"Answer an instance of the receiver configured for device-independent pixels (aka DIPs, equivalent to 96-dpi). The GDI scaling context is used because this gives much better results, avoiding blurry text."

	^Default ifNil: [Default := self dpiAwareness: DpiAwareness gdiScaled]!

dpiAwareness: aDpiAwareness
	"Private - Answer an instance of the receiver configured for the specified DPI."

	^self basicNew
		awarenessContext: aDpiAwareness;
		yourself!

gdiScaled
	"Answer an instance of the receiver configured for device-independent pixels (aka DIPs, equivalent to 96-dpi) with GDI scaling."

	^self default!

icon
	"Answers an Icon that can be used to represent this class"

	^##(TextTileIcon text: $\xEB3C fontName: 'Segoe Fluent Icons')!

onStartup
	"As the receiver's instances are not registered windows, they won't receive onStartup from GuiInputState>>#guiStartup."

	{Default. System. Unaware} do: [:each | each ifNotNil: [each onStartup]]!

perMonitor
	^self current!

system
	"Answer an instance of the receiver configured for the current primary monitor DPI."

	^System ifNil: [System := self dpiAwareness: DpiAwareness system]!

unaware
	"Answer a DPI unaware instance of the receiver (96-dpi, bitmap scaling)."

	^Unaware ifNil: [Unaware := self dpiAwareness: DpiAwareness unaware]! !

!Tools.DesignDesktopView class categoriesForMethods!
default!instance creation!public! !
dpiAwareness:!instance creation!private! !
gdiScaled!instance creation!public! !
icon!constants!public! !
onStartup!event handling!public! !
perMonitor!instance creation!public! !
system!instance creation!public! !
unaware!instance creation!public! !
!

