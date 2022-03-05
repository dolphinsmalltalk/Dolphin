"Filed out from Dolphin Smalltalk"!

ToolbarItem subclass: #ToolbarSeparator
	instanceVariableNames: 'width'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ToolbarSeparator guid: (GUID fromString: '{87b4c701-026e-11d3-9fd7-00a0cc3e4a32}')!
ToolbarSeparator comment: '`ToolbarSeparator` represents a separator item within a `Toolbar`. A separator can assume a default width, or an explicit pixel width can be set using the `#width` aspect. Separators can be used as a cheap and cheerful way to reserve space in a toolbar for a child window, although the separator will be visible unless completely overlapped by the child.

## Instance Variables:
  `width`		`<integer>` specifying the pixel width of the separator. To use the default width specify 0.



'!
!ToolbarSeparator categoriesForClass!MVP-Views-Support! !
!ToolbarSeparator methodsFor!

imageIndexIn: aToolbar
	"Private - Answer the index of the image for the receiver. Note that in the case
	of separator toolbar items the image index is used for the separator's
	width."

	^self width!

isDivider
	"Answer whether the receiver is a toolbar separator (similar in function to a menu divider item)."

	^true!

setWidth: anInteger
	width := anInteger.
	^self!

style
	"Private - Answer the style of the receiver."

	^BTNS_SEP!

textIndexIn: aToolbar
	"Private - Answer the index of the String label for the receiver in aToolbar.
	Answer -1 as separators do not have a text label."

	^ -1!

width
	"Answer the width of the receiver in pixels. 0 indicates the default width."

	^width!

width: pixelWidth
	"Set the width of the receiever to pixelWidth. 0 indicates default width."

	width := pixelWidth! !
!ToolbarSeparator categoriesForMethods!
imageIndexIn:!operations!private! !
isDivider!public!testing! !
setWidth:!accessing!initializing!private! !
style!private!style! !
textIndexIn:!operations!private! !
width!accessing!public! !
width:!accessing!public! !
!

!ToolbarSeparator class methodsFor!

new
	^self width: 0!

stbConvertFrom: anSTBClassFormat
	"Version 0 inst var layout was:
		ToolbarItem
			1: commandId
			2: unused
			3: window (toolbar)
			4: style
			5: commandDescription
		ToolbarSeparator
			6: width

	Version 1 inst var layout is:
		ToolbarItem
			1: toolbar
		ToolbarSeparator
			2: width
	"

	^
	[:data |
	self basicNew
		instVarAt: 1 put: (data at: 3);
		instVarAt: 2 put: (data at: 6);
		yourself]!

width: pixelWidth
	"Answer a new instance of the receiver whose width is set to pixelWidth."

	^self basicNew setWidth: pixelWidth! !
!ToolbarSeparator class categoriesForMethods!
new!instance creation!public! !
stbConvertFrom:!binary filing!private! !
width:!instance creation!public! !
!

