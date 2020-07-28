"Filed out from Dolphin Smalltalk 7"!

MenuItem subclass: #DividerMenuItem
	instanceVariableNames: ''
	classVariableNames: 'BarBreak Break DividerLookup Separator'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DividerMenuItem guid: (GUID fromString: '{87b4c661-026e-11d3-9fd7-00a0cc3e4a32}')!
DividerMenuItem comment: 'DividerMenuItem represents a divider that can be placed between other items in a <Menu>. Separate singleton instances for the various styles are held in class variables and answered by the #separator, #break and #barBreak [instance creation] methods.

Class Variables:
	Separator		<DividerMenuItem> singleton instance for the standard separator style.
	DividerLookup	<LookupTable> mapping <integer> style flags to their <Symbol> style names.
	BarBreak		<DividerMenuItem> singleton instance for the bar-break separater style.
	Break		<DividerMenuItem> singleton instance for the break separater style

'!
!DividerMenuItem categoriesForClass!MVP-Views-Support! !
!DividerMenuItem methodsFor!

acceleratorKey
	"Private - Answer the accelerator key code for the receiver.
	Dividers are of course inactive."

	^0!

acceleratorKey: anInteger
	"Private - Set the receiver's accelerator key code to the argument, anInteger."

	!

command
	"Private - Answer the command selector for the receiver.
	There is of course no command associated with dividers."

	^nil!

commandDescription
	"Private - Answer the <commandDescription> for the receiver"

	^CommandDescription command: nil description: '|'!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPut: $|!

id
	"Answers the menu item identifier for the receiver"

	^0!

isDivider
	"Answer whether the receiver is actually just a divider."

	^true!

populateItemInfo: aMENUITEMINFO 
	"Private - Copy the receiver's item information into the <MENUITEMINFOW> argument."

	aMENUITEMINFO type: self styleFlags!

queryAlong: aCommandPolicy 
	"Answer an enabled <CommandQuery> as dividers must always be enabled."

	^CommandQuery new beEnabled!

styleName
	"Answer a Symbol description of the style of the reciver"

	^DividerLookup at: self styleFlags!

styleName: aSymbol
	"Private - Set the receiver's style from the description in aSymbol. 
	This can be one of #separator, #break or #barBreak."

	self styleFlags: (DividerLookup keyAtValue: aSymbol)!

text
	"Private - Answer the menu text (i.e. the text that appears in the menu) for the receiver."

	^''! !
!DividerMenuItem categoriesFor: #acceleratorKey!accessing!private! !
!DividerMenuItem categoriesFor: #acceleratorKey:!accessing!private! !
!DividerMenuItem categoriesFor: #command!accessing!private! !
!DividerMenuItem categoriesFor: #commandDescription!accessing!private! !
!DividerMenuItem categoriesFor: #displayOn:!displaying!public! !
!DividerMenuItem categoriesFor: #id!accessing!public! !
!DividerMenuItem categoriesFor: #isDivider!public!testing! !
!DividerMenuItem categoriesFor: #populateItemInfo:!private!realizing/unrealizing! !
!DividerMenuItem categoriesFor: #queryAlong:!operations!public! !
!DividerMenuItem categoriesFor: #styleName!accessing!public! !
!DividerMenuItem categoriesFor: #styleName:!accessing!private! !
!DividerMenuItem categoriesFor: #text!accessing!private! !

!DividerMenuItem class methodsFor!

barBreak
	"Answer unique DividerMenuItem which splits places following menu items in
	a new column. Vertical line splits the old and new column of menu items."

	BarBreak isNil ifTrue: [BarBreak := self basicNew flags: MFT_MENUBARBREAK; yourself].
	^BarBreak
!

break
	"Answer unique DividerMenuItem which splits places following menu items in
	a new column."

	Break isNil ifTrue: [Break := self basicNew flags: MFT_MENUBREAK; yourself].
	^Break
!

initialize
	"Private - Initialize the receiver's class variables.

		DividerMenuItem initialize
	"

	DividerLookup := LookupTable new
		at: MFT_SEPARATOR put: #separator;
		at: MFT_MENUBREAK put: #break;
		at: MFT_MENUBARBREAK put: #barBreak;
		yourself!

new
	"Answers an instance of the receiver"

	^self separator !

onPreStripImage
	"Private - The image is about to be stripped. Nil the lazily initialized class variables."

	self uninitialize!

separator
	"Answer unique DividerMenuItem which draws a horizontal dividing line in menu."

	Separator isNil ifTrue: [Separator := self basicNew flags: MFT_SEPARATOR; yourself].
	^Separator
!

stbConvertFrom: anSTBClassFormat 
	"Convert from earlier version models.
	1: Added 'typeFlags' inst var to MenuItem and removed own 'flags' inst var."

	^
	[:data | 
	| newInst |
	newInst := self basicNew.
	data keysAndValuesDo: [:i :v | newInst instVarAt: i put: v].
	newInst]!

styleNameChoices
	"Answer an Array of available style names for instances of the receiver."

	^DividerLookup values asArray!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	BarBreak := Break := Separator := nil! !
!DividerMenuItem class categoriesFor: #barBreak!instance creation!public! !
!DividerMenuItem class categoriesFor: #break!instance creation!public! !
!DividerMenuItem class categoriesFor: #initialize!development!initializing!private! !
!DividerMenuItem class categoriesFor: #new!instance creation!public! !
!DividerMenuItem class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!DividerMenuItem class categoriesFor: #separator!instance creation!public! !
!DividerMenuItem class categoriesFor: #stbConvertFrom:!binary filing!public! !
!DividerMenuItem class categoriesFor: #styleNameChoices!constants!public! !
!DividerMenuItem class categoriesFor: #uninitialize!class hierarchy-removing!private! !

