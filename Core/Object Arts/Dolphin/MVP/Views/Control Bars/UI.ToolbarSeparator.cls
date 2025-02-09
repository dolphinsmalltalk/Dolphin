"Filed out from Dolphin Smalltalk"!

UI.ToolbarItem
	subclass: #'UI.ToolbarSeparator'
	instanceVariableNames: 'width'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.ToolbarSeparator guid: (Core.GUID fromString: '{87b4c701-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.ToolbarSeparator comment: '`ToolbarSeparator` represents a separator item within a `Toolbar`. A separator can assume a default width, or an explicit pixel width can be set using the `#width` aspect. Separators can be used as a cheap and cheerful way to reserve space in a toolbar for a child window, although the separator will be visible unless completely overlapped by the child.

## Instance Variables:
  `width`		`<integer>` specifying the pixel width of the separator. To use the default width specify 0.



'!

!UI.ToolbarSeparator categoriesForClass!MVP-Views-Support! !

!UI.ToolbarSeparator methodsFor!

isDivider
	"Answer whether the receiver is a toolbar separator (similar in function to a menu divider item)."

	^true!

populateTbButton: aTBBUTTON for: aToolbar withLabels: aBoolean
	^aTBBUTTON
		idCommand: 0
		iBitmap: width
		iString: -1
		fsStyle: BTNS_SEP!

setWidth: anInteger
	width := anInteger.
	^self!

style
	"Private - Answer the style of the receiver."

	^BTNS_SEP!

width
	"Answer the width of the receiver in pixels. 0 indicates the default width."

	^width!

width: pixelWidth
	"Set the width of the receiever to pixelWidth. 0 indicates default width."

	width := pixelWidth! !

!UI.ToolbarSeparator categoriesForMethods!
isDivider!public!testing! !
populateTbButton:for:withLabels:!adding!private! !
setWidth:!accessing!initializing!private! !
style!private!style! !
width!accessing!public! !
width:!accessing!public! !
!

!UI.ToolbarSeparator class methodsFor!

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

	anSTBClassFormat version == 0 ifTrue: [^[:data | { data at: 3. data at: 6 } becomeA: self]].
	^super stbConvertFrom: anSTBClassFormat!

width: pixelWidth
	"Answer a new instance of the receiver whose width is set to pixelWidth."

	^self basicNew setWidth: pixelWidth! !

!UI.ToolbarSeparator class categoriesForMethods!
new!instance creation!public! !
stbConvertFrom:!binary filing!private! !
width:!instance creation!public! !
!

