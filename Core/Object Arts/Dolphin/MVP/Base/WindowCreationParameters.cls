"Filed out from Dolphin Smalltalk"!

Object subclass: #WindowCreationParameters
	instanceVariableNames: 'position extent dpi styles title'
	classVariableNames: 'UseDefaultGeometry'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
WindowCreationParameters guid: (GUID fromString: '{e9c7ec2d-9993-41b5-afb7-83f01de85380}')!
WindowCreationParameters comment: ''!
!WindowCreationParameters categoriesForClass!Kernel-Objects! !
!WindowCreationParameters methodsFor!

baseStyle
	"Answer the basic creation style flags for the new window."

	^styles at: 1!

baseStyle: anInteger
	"Set the receiver's basic creation style flags."

	styles at: 1 put: anInteger!

dpi
	"Answer the <integer> logical dots-per-inch at which the <rectangle> stored in the receiver is measured."

	^dpi!

dpi: anInteger
	dpi := anInteger!

extendedStyle
	"Answer the extended creation style flags for the new window."

	^styles at: 2!

extendedStyle: anInteger
	"Set the extended creation style flags for the new window."

	styles at: 2 put: anInteger!

extent
	"Answer a <point> expressing the width and height of the window to be created. These are measured at the receiver's DPI."

	^extent!

extent: aPoint
	"Set the width and height of the window to be created to the x and y co-ordinates, respectively, of the <point> argument. These are assumed to be measured at the receiver's dpi."

	extent := aPoint!

position
	"Answer a <point> expressing the position (top-left corner) of the window to be created. The position is measured at the receiver's DPI."

	^position!

position: aPoint
	"Set the position (top-left corner) of the window to be created to the x and y co-ordinates, respectively, of the <point> argument. These are assumed to be measured at the receiver's dpi."

	position := aPoint!

position: posPoint extent: extPoint dpi: anInteger styles: anArray title: aString
	position := posPoint.
	extent := extPoint.
	dpi := anInteger.
	styles := anArray.
	title := aString!

styles
	"Answer a two-element <Array> containing the basic and extended window styles to be applied to the new window on creation."

	^styles!

title
	"Answer the text to be associated with the window on creation. The effect of this varies depending on the type of window being created. For a top-level window, this will be the title in the caption. For many other windows (although ironically not the text edit control) this will be the window text, e.g. the text on a button."

	^title! !
!WindowCreationParameters categoriesForMethods!
baseStyle!accessing!public! !
baseStyle:!accessing!public! !
dpi!accessing!public! !
dpi:!accessing!public! !
extendedStyle!accessing!public! !
extendedStyle:!accessing!public! !
extent!accessing!public! !
extent:!accessing!public! !
position!accessing!public! !
position:!accessing!public! !
position:extent:dpi:styles:title:!initializing!private! !
styles!accessing!public! !
title!accessing!public! !
!

!WindowCreationParameters class methodsFor!

initialize
	self addClassConstant: 'UseDefaultGeometry' value: CW_USEDEFAULT @ CW_USEDEFAULT!

position: posPoint extent: extPoint dpi: anInteger styles: anArray
	<primitive: 157>
	^self 
		position: posPoint
		extent: extPoint
		dpi: anInteger
		styles: anArray
		title: nil!

position: posPoint extent: extPoint dpi: anInteger styles: anArray title: aString
	<primitive: 157>
	^self new
		position: posPoint
		extent: extPoint
		dpi: anInteger
		styles: anArray
		title: aString! !
!WindowCreationParameters class categoriesForMethods!
initialize!public! !
position:extent:dpi:styles:!instance creation!public! !
position:extent:dpi:styles:title:!instance creation!public! !
!

