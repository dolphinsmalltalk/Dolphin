"Filed out from Dolphin Smalltalk"!

UI.MenuItem
	subclass: #'UI.DividerMenuItem'
	instanceVariableNames: ''
	classVariableNames: 'BarBreak Break Separator'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'DividerLookup'
				-> (IdentityDictionary withAll: { 16r20 -> #barBreak. 16r40 -> #break. 16r800 -> #separator })
		}!

UI.DividerMenuItem guid: (Core.GUID fromString: '{87b4c661-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.DividerMenuItem comment: 'DividerMenuItem represents a divider that can be placed between other items in a <Menu>. Separate singleton instances for the various styles are held in class variables and answered by the #separator, #break and #barBreak [instance creation] methods.

Class Variables:
	Separator		<DividerMenuItem> singleton instance for the standard separator style.
	DividerLookup	<LookupTable> mapping <integer> style flags to their <Symbol> style names.
	BarBreak		<DividerMenuItem> singleton instance for the bar-break separater style.
	Break		<DividerMenuItem> singleton instance for the break separater style

'!

!UI.DividerMenuItem categoriesForClass!MVP-Views-Support! !

!UI.DividerMenuItem methodsFor!

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

	aPuttableStream nextPutAll: self displayString!

displayString
	^##(IdentityDictionary
		withAll: { MFT_MENUBARBREAK -> '||'. MFT_MENUBREAK -> '|'. MFT_SEPARATOR -> '-' })
			at: self styleFlags!

id
	"Answers the menu item identifier for the receiver"

	^0!

isDivider
	"Answer whether the receiver is actually just a divider."

	^true!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^true!

populateItemInfo: aMENUITEMINFO metrics: aSystemMetrics
	"Private - Copy the receiver's item information into the <MENUITEMINFOW> argument."

	aMENUITEMINFO type: self styleFlags!

printOn: aStream
	"Appends the receiver to aStream as a representation that a 
	developer would want to see"

	aStream
		print: self class;
		space;
		display: self styleName!

queryAlong: aCommandPolicy
	^nil!

styleName
	"Answer a Symbol description of the style of the receiver"

	^DividerLookup at: self styleFlags!

styleName: aSymbol
	"Private - Set the receiver's style from the description in aSymbol. 
	This can be one of #separator, #break or #barBreak."

	self styleFlags: (DividerLookup keyAtValue: aSymbol)!

text
	"Private - Answer the menu text (i.e. the text that appears in the menu) for the receiver."

	^''!

toStrings
	^self displayString! !

!UI.DividerMenuItem categoriesForMethods!
acceleratorKey!accessing!private! !
acceleratorKey:!accessing!private! !
command!accessing!private! !
commandDescription!accessing!private! !
displayOn:!displaying!public! !
displayString!displaying!public! !
id!accessing!public! !
isDivider!public!testing! !
isSelfEvaluating!public!testing! !
populateItemInfo:metrics:!private!realizing/unrealizing! !
printOn:!printing!public! !
queryAlong:!operations!public! !
styleName!accessing!public! !
styleName:!accessing!private! !
text!accessing!private! !
toStrings!public! !
!

UI.DividerMenuItem methodProtocol: #menuItem attributes: #(#readOnly) selectors: #(#acceleratorKey #command #hasSubmenu #id #image #insertIntoMenu:at:info: #items #menuFromHandle: #queryAlong: #registerAcceleratorKeyIn: #text)!

!UI.DividerMenuItem class methodsFor!

barBreak
	"Answer unique DividerMenuItem which splits places following menu items in
	a new column. Vertical line splits the old and new column of menu items."

	^BarBreak ifNil: [BarBreak := self dividers at: '||']!

break
	"Answer unique DividerMenuItem which splits places following menu items in
	a new column."

	^Break ifNil: [Break := self dividers at: '|']!

initialize
	self addClassConstant: 'DividerLookup'
		value: (IdentityDictionary
				withAll: { MFT_MENUBARBREAK -> #barBreak. MFT_MENUBREAK -> #break. MFT_SEPARATOR -> #separator })!

new
	"Answers an instance of the receiver"

	^self separator !

onPreStripImage
	"Private - The image is about to be stripped. Nil the lazily initialized class variables."

	self uninitialize!

separator
	"Answer unique DividerMenuItem which draws a horizontal dividing line in menu."

	^Separator ifNil: [Separator := self dividers at: '-']!

stbConvertFrom: anSTBClassFormat
	"Convert from earlier version models.
	1: 'flags' inst var pushed up - doesn't really require a conversion because the inst size and format remains the same."

	anSTBClassFormat version == 0 ifTrue: [^[:data | data becomeA: DividerMenuItem]].
	^super stbConvertFrom: anSTBClassFormat!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^1!

styleNameChoices
	"Answer an Array of available style names for instances of the receiver."

	^DividerLookup values asArray!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	BarBreak := Break := Separator := nil! !

!UI.DividerMenuItem class categoriesForMethods!
barBreak!instance creation!public! !
break!instance creation!public! !
initialize!class initialization!private! !
new!instance creation!public! !
onPreStripImage!class hierarchy-removing!private! !
separator!instance creation!public! !
stbConvertFrom:!binary filing!public! !
stbVersion!binary filing!public! !
styleNameChoices!constants!public! !
uninitialize!class hierarchy-removing!private! !
!

