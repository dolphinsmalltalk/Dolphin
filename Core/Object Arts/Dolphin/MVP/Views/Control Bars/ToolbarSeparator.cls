"Filed out from Dolphin Smalltalk X6"!

ToolbarItem subclass: #ToolbarSeparator
	instanceVariableNames: 'width'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ToolbarSeparator guid: (GUID fromString: '{87B4C701-026E-11D3-9FD7-00A0CC3E4A32}')!
ToolbarSeparator comment: 'ToolbarSeparator represents a separator item within a <Toolbar>. A separator can assume a default width, or an explicit pixel width can be set using the #width aspect.

Instance Variables:
	width	<integer> specifying the pixel width of the separator. To use the default width specify 0.

'!
!ToolbarSeparator categoriesForClass!MVP-Views-Support! !
!ToolbarSeparator methodsFor!

beDefaultWidth
	"Private - Set the width of the receiever to the default."

	self width: 0!

beSeparatorStyle
	"Private - Set sthe receiver to be a separator item"

	self style: BTNS_SEP
!

imageIndexIn: aToolbar
	"Private - Answer the index of the image for the receiever. Note that in the case
	of separator toolbar items the image index is used for the separator's
	width."

	^self width!

initialize
	"Private - Initialize the state of the receiver."

	super initialize.
	self beSeparatorStyle; beDefaultWidth.
!

isDivider
	"Answer whether the receiver is a toolbar separator (similar in function to a menu divider item)."

	^true!

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
!ToolbarSeparator categoriesFor: #beDefaultWidth!accessing!private! !
!ToolbarSeparator categoriesFor: #beSeparatorStyle!private!style! !
!ToolbarSeparator categoriesFor: #imageIndexIn:!operations!private! !
!ToolbarSeparator categoriesFor: #initialize!initializing!private! !
!ToolbarSeparator categoriesFor: #isDivider!public!testing! !
!ToolbarSeparator categoriesFor: #textIndexIn:!operations!private! !
!ToolbarSeparator categoriesFor: #width!accessing!public! !
!ToolbarSeparator categoriesFor: #width:!accessing!public! !

!ToolbarSeparator class methodsFor!

width: pixelWidth
	"Answer a new instance of the receiever whose width is set to pixelWidth."

	^self new	width: pixelWidth;	yourself! !
!ToolbarSeparator class categoriesFor: #width:!instance creation!public! !

