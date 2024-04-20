"Filed out from Dolphin Smalltalk"!

UI.CreateWindowApiCall
	subclass: #'UI.CreateWindow'
	instanceVariableNames: 'styles title'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!

UI.CreateWindow guid: (Core.GUID fromString: '{e9c7ec2d-9993-41b5-afb7-83f01de85380}')!

UI.CreateWindow comment: ''!

!UI.CreateWindow categoriesForClass!Kernel-Objects! !

!UI.CreateWindow methodsFor!

baseStyle
	"Answer the basic creation style flags for the new window."

	^styles at: 1!

baseStyle: anInteger
	"Set the receiver's basic creation style flags."

	styles at: 1 put: anInteger!

create: aView
	| dwStyle |
	dwStyle := styles at: 1.
	^User32
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
		hInstance: VM applicationHandle
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

styles
	"Answer a two-element <Array> containing the basic and extended window styles to be applied to the new window on creation."

	^styles!

title
	"Answer the text to be associated with the window on creation. The effect of this varies depending on the type of window being created. For a top-level window, this will be the title in the caption. For many other windows (although ironically not the text edit control) this will be the window text, e.g. the text on a button."

	^title! !

!UI.CreateWindow categoriesForMethods!
baseStyle!accessing!public! !
baseStyle:!accessing!public! !
create:!operations!public! !
extendedStyle!accessing!public! !
extendedStyle:!accessing!public! !
rectangle:dpi:styles:title:!initializing!private! !
styles!accessing!public! !
title!accessing!public! !
!

!UI.CreateWindow class methodsFor!

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

!UI.CreateWindow class categoriesForMethods!
rectangle:dpi:styles:!instance creation!public! !
rectangle:dpi:styles:title:!instance creation!public! !
!

