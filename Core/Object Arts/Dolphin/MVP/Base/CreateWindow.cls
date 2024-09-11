"Filed out from Dolphin Smalltalk"!

CreateWindowApiCall subclass: #CreateWindow
	instanceVariableNames: 'styles title'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!

CreateWindow guid: (GUID fromString: '{e9c7ec2d-9993-41b5-afb7-83f01de85380}')!

CreateWindow comment: ''!

!CreateWindow categoriesForClass!Kernel-Objects! !

!CreateWindow methodsFor!

baseStyle
	"Answer the basic creation style flags for the new window."

	^styles at: 1!

baseStyle: anInteger
	"Set the receiver's basic creation style flags."

	styles at: 1 put: anInteger!

create: aView
	| dwStyle |
	dwStyle := styles at: 1.
	^UserLibrary default
		createWindowEx: (styles at: 2)
		lpClassName: aView class winClassName asUtf16String
		lpWindowName: title
		dwStyle: dwStyle
		x: rectangle left
		y: rectangle top
		nWidth: rectangle width
		nHeight: rectangle height
		hWndParent: aView creationParentView asParameter
		hMenu: ((dwStyle anyMask: WS_CHILD) ifTrue: [aView defaultId])
		hInstance: VMLibrary default applicationHandle
		lpParam: nil!

extendedStyle
	"Answer the extended creation style flags for the new window."

	^styles at: 2!

extendedStyle: anInteger
	"Set the extended creation style flags for the new window."

	styles at: 2 put: anInteger!

rectangle: aRectangle dpi: anInteger styles: anArray title: aString
	rectangle := aRectangle.
	dpi := anInteger.
	styles := anArray.
	title := aString!

resolveShellGeometry: aShellView
	| targetDpi extent monitor position |
	position := self position.
	extent := self extent.
	"If the position is not specified, we will need to work out a suitable position on the active monitor"
	(aShellView isRestoringFromProxy or: [position = UseDefaultGeometry])
		ifTrue: 
			["Default position, so should go on the default monitor. This is usually the active monitor, but for a dialog it would be the monitor of the owner."
			monitor := DisplayMonitor active.
			targetDpi := monitor effectiveDpi.
			"Now work out the extent to use at the DPI of the active monitor, which is either the specified extent remapped to the active monitor DPI, or if unspecified the monitor default"
			extent := extent = UseDefaultGeometry
						ifTrue: [monitor defaultWindowExtent * targetDpi // monitor dpi]
						ifFalse: [extent * targetDpi // dpi].
			position := aShellView isInitiallyCentered
						ifTrue: [monitor centerExtent: extent]
						ifFalse: [monitor nextWindowPosition]]
		ifFalse: 
			["Position was specified. Determine the monitor from that."
			monitor := DisplayMonitor nearestPoint: position * SystemMetrics current dpi // dpi.
			targetDpi := monitor effectiveDpi.
			"Now we can calculate the extent as above"
			extent := extent = UseDefaultGeometry
						ifTrue: [monitor defaultWindowExtent * targetDpi // monitor dpi]
						ifFalse: [extent * targetDpi // dpi].
			"If should be initially centered, override the specified position, but keeping to the same monitor"
			position := aShellView isInitiallyCentered
						ifTrue: 
							["Position so as to centre the window at whatever its extent should be"
							monitor centerExtent: extent]
						ifFalse: [position * targetDpi // dpi]].


	"Adjust the position to fit on the monitor, if possible"
	rectangle := RECT origin: (monitor adjustPosition: position forExtent: extent) extent: extent.
	dpi := targetDpi!

styles
	"Answer a two-element <Array> containing the basic and extended window styles to be applied to the new window on creation."

	^styles!

title
	"Answer the text to be associated with the window on creation. The effect of this varies depending on the type of window being created. For a top-level window, this will be the title in the caption. For many other windows (although ironically not the text edit control) this will be the window text, e.g. the text on a button."

	^title! !

!CreateWindow categoriesForMethods!
baseStyle!accessing!public! !
baseStyle:!accessing!public! !
create:!operations!public! !
extendedStyle!accessing!public! !
extendedStyle:!accessing!public! !
rectangle:dpi:styles:title:!initializing!private! !
resolveShellGeometry:!operations!private! !
styles!accessing!public! !
title!accessing!public! !
!

!CreateWindow class methodsFor!

rectangle: aRectangle dpi: anInteger styles: anArray
	<primitive: 157>
	^self
		rectangle: aRectangle
		dpi: anInteger
		styles: anArray!

rectangle: aRectangle dpi: anInteger styles: anArray title: aString
	<primitive: 157>
	^self new
		rectangle: aRectangle
		dpi: anInteger
		styles: anArray
		title: aString! !

!CreateWindow class categoriesForMethods!
rectangle:dpi:styles:!instance creation!public! !
rectangle:dpi:styles:title:!instance creation!public! !
!

