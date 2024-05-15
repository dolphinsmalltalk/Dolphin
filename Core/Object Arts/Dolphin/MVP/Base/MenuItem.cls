"Filed out from Dolphin Smalltalk"!

Object subclass: #MenuItem
	instanceVariableNames: 'flags'
	classVariableNames: 'Dividers StringSeparator StylesMask'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!

MenuItem guid: (GUID fromString: '{87b4c49d-026e-11d3-9fd7-00a0cc3e4a32}')!

MenuItem isAbstract: true!

MenuItem addClassConstant: 'StringSeparator' value: $/!
MenuItem addClassConstant: 'StylesMask' value: 16rFFFFF!

MenuItem comment: 'MenuItem is an abstract class whose subclasses represent the items held by a <Menu>.

Instance Variables:
	flags		<integer>

Class Variables:
	StringSeparator	<Character> separator to use when parsing menu definitions using #fromString:
	StylesMask		<integer> mask used to extract the style flags from the flags instance variable.
	StringSeparator	<Character> separator to use when parsing menu definitions using #fromString:

'!

!MenuItem categoriesForClass!MVP-Views-Support! !

!MenuItem methodsFor!

acceleratorKey
	"Answer the accelerator key code for the receiver."

	^self subclassResponsibility!

acceleratorKey: anInteger
	"Private - Set the receiver's accelerator key code to the argument, anInteger."

	^self subclassResponsibility!

allItems
	^{self}!

allItemsDo: aMonadicValuable 
	aMonadicValuable value: self!

allMenusDo: aMonadicValuable 
!

command
	"Answer the command to action when this menu item is selected."

	^self commandDescription command!

commandDescription
	"Private - Answer the <commandDescription> for the receiver"

	^self subclassResponsibility!

edit
	"Private - Edit the receiver in a dialog box. By default you can't edit
	a MenuItem."

	^self!

flags
	^flags!

flags: anInteger 
	flags := anInteger!

hasSubmenu
	"Answer whether the receiver has a submenu connected to it."

	^false!

id
	"Answers the menu item identifier for the receiver"

	^self subclassResponsibility!

image
	"Answer the <Image> currently associated with this menu item."

	^nil!

insertIntoMenu: aMenu at: position info: aMENUITEMINFO
	"Append the receiver to the menu, aMenu."

	self populateItemInfo: aMENUITEMINFO metrics: aMenu metrics.
	(UserLibrary default
		insertMenuItem: aMenu asParameter
		uItem: position
		fByPosition: true
		lpmii: aMENUITEMINFO) ifFalse: [Win32Error signal: 'Unable to realize ' , self printString]!

isDefault
	"Answer whether the receiver is expecting to be the default item on a menu."

	^false!

isDefault: aBoolean
	"Set whether the receiver is expecting to be the default item on a menu."

	"Do nothing at this level"!

isDivider
	"Answer whether the receiver is actually just a divider."

	^false!

items
	"Answer a collection of sub-items immediately under the receiver.
	Implemented for polymorphism with Menu (Composite pattern)."

	^#()!

itemsDo: aMonadicValuable 
	"Private - Implemented for polymorphism with Menu."

	!

itemWithId: anInteger 
	"Find and return the command in the menu associated with the specified id, or nil if not found."

	^nil!

menuFromHandle: menuHandle
	"Return the Menu associated with this handle.
	Implemented for polymorphism with Menu (Composite pattern)."

	^nil!

name
	"Answer the menu name of the receiver. Implemented here since Menus and MenuItems share the same protocol"

	^nil!

populateItemInfo: aMENUITEMINFO metrics: aSystemMetrics
	"Private - Copy the receiver's item information into the <MENUITEMINFOW> argument."

	^self subclassResponsibility!

printOn: aStream
	"Appends the receiver to aStream as a representation that a 
	developer would want to see"

	aStream
		basicPrint: self;
		nextPut: $(;
		display: self;
		nextPut: $)!

queryAlong: aCommandPolicy 
	"Answer a <CommandQuery> reflecting the current state of the receiver's command for the
	specified <commandPolicy>."

	^aCommandPolicy query: self commandDescription!

registerAcceleratorKeyIn: anAcceleratorTable
	"Register the accelerator key associated with this menu item, if
	there is one, in anAcceleratorTable."!

styleFlags
	"Private - Answer the MENUITEMINFO style flags of the receiver (see
	Win32 SDK docs for fType field)."

	^flags bitAnd: StylesMask
!

styleFlags: flagsInteger
	"Private - Set the MENUITEMINFO style flags of the receiver (see
	Win32 SDK docs for fType field)."

	flags := (flags maskClear: StylesMask) maskSet: (flagsInteger bitAnd: StylesMask)!

text
	"Answer the menu text (i.e. the text that appears in the menu) for the receiver."

	^self subclassResponsibility!

toStrings
	^String writeStream
		nextPutAll: self description;
		nextPut: $/;
		nextPutAll: self commandDescription acceleratorKeyDisplayString;
		nextPut: $/;
		nextPutAll: self command;
		contents! !

!MenuItem categoriesForMethods!
acceleratorKey!accessing!public! !
acceleratorKey:!accessing!private! !
allItems!accessing!public! !
allItemsDo:!enumerating!public! !
allMenusDo:!accessing!enumerating!public! !
command!commands!public! !
commandDescription!accessing!private! !
edit!accessing!operations!private! !
flags!accessing!private! !
flags:!accessing!private! !
hasSubmenu!menus!private! !
id!accessing!private! !
image!accessing!public! !
insertIntoMenu:at:info:!public!realizing/unrealizing! !
isDefault!public!testing! !
isDefault:!accessing!public! !
isDivider!public!testing! !
items!accessing!public! !
itemsDo:!accessing!private! !
itemWithId:!accessing!public! !
menuFromHandle:!accessing!public! !
name!accessing!public! !
populateItemInfo:metrics:!private!realizing/unrealizing! !
printOn:!printing!public! !
queryAlong:!operations!public! !
registerAcceleratorKeyIn:!menus!public! !
styleFlags!accessing!private! !
styleFlags:!accessing!not an aspect!private! !
text!accessing!public! !
toStrings!converting!public! !
!

MenuItem methodProtocol: #menuItem attributes: #(#readOnly) selectors: #(#acceleratorKey #command #hasSubmenu #id #image #insertIntoMenu:at:info: #items #menuFromHandle: #queryAlong: #registerAcceleratorKeyIn: #text)!

!MenuItem class methodsFor!

dividers
	^Dividers
		ifNil: 
			[Dividers := LookupTable new
						at: '-'
							put: (DividerMenuItem basicNew
									flags: MFT_SEPARATOR;
									isImmutable: true ;
									yourself);
						at: '||'
							put: (DividerMenuItem basicNew
									flags: MFT_MENUBARBREAK;
									isImmutable: true;
									yourself);
						at: '|'
							put: (DividerMenuItem basicNew
									flags: MFT_MENUBREAK;
									isImmutable: true;
									yourself);
						yourself]!

errorIllegalMenuString: illegalString
	"Private - Raise an error to inform that illegalString can not be
	used to generate a MenuItem because it is of the incorrect format."

	self error: 'Illegal menu string: ', illegalString!

fromString: aString
	"Answer a new sub-instance of the receiver generated from menuString."

	^(self dividers lookup: aString)
		ifNil: 
			[| subStrings |
			(subStrings := StringSeparator split: aString) size == 3
				ifTrue: 
					[| commandDescription accel |
					commandDescription := CommandDescription command: (subStrings at: 3) asSymbol.
					commandDescription description: (subStrings at: 1).
					(accel := subStrings at: 2) notEmpty ifTrue: [commandDescription acceleratorKeyString: accel].
					CommandMenuItem commandDescription: commandDescription]
				ifFalse: [self errorIllegalMenuString: aString]]!

initialize
	"Private - Initialize the class variables of the receiver:
		MenuItem initialize
	"

	self addClassConstant: 'StringSeparator' value: $/.
	self addClassConstant: 'StylesMask' value: 16rFFFFF	"Allows a lot of space for more Microsoft flags"!

new
	"Private - MenuItem is abstract"

	^self subclassResponsibility
!

onPreStripImage
	"Private - The image is about to be stripped. Nil the lazily initialized class variables."

	self uninitialize!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	Dividers := nil! !

!MenuItem class categoriesForMethods!
dividers!accessing!private! !
errorIllegalMenuString:!exceptions!private! !
fromString:!instance creation!public! !
initialize!development!initializing!private! !
new!instance creation!private! !
onPreStripImage!class hierarchy-removing!private! !
uninitialize!class hierarchy-removing!private! !
!

