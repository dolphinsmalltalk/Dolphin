"Filed out from Dolphin Smalltalk 7"!

Object subclass: #MenuItem
	instanceVariableNames: 'flags'
	classVariableNames: 'Dividers'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''
	classConstants: {
		'StringSeparator' -> $/.
		'StylesMask' -> 16rFFFFF
	}!
MenuItem guid: (GUID fromString: '{87b4c49d-026e-11d3-9fd7-00a0cc3e4a32}')!
MenuItem isAbstract: true!
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

	self populateItemInfo: aMENUITEMINFO.
	(UserLibrary default 
		insertMenuItem: aMenu asParameter
		uItem: position
		fByPosition: true
		lpmii: aMENUITEMINFO)
			ifFalse: [Win32Error signal: 'Unable to realize ', self printString]!

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

populateItemInfo: aMENUITEMINFO
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

	^self subclassResponsibility! !
!MenuItem categoriesFor: #acceleratorKey!accessing!public! !
!MenuItem categoriesFor: #acceleratorKey:!accessing!private! !
!MenuItem categoriesFor: #allItems!accessing!public! !
!MenuItem categoriesFor: #command!commands!public! !
!MenuItem categoriesFor: #commandDescription!accessing!private! !
!MenuItem categoriesFor: #edit!accessing!operations!private! !
!MenuItem categoriesFor: #flags!accessing!private! !
!MenuItem categoriesFor: #flags:!accessing!private! !
!MenuItem categoriesFor: #hasSubmenu!menus!private! !
!MenuItem categoriesFor: #id!accessing!private! !
!MenuItem categoriesFor: #image!accessing!public! !
!MenuItem categoriesFor: #insertIntoMenu:at:info:!public!realizing/unrealizing! !
!MenuItem categoriesFor: #isDefault!public!testing! !
!MenuItem categoriesFor: #isDefault:!accessing!public! !
!MenuItem categoriesFor: #isDivider!public!testing! !
!MenuItem categoriesFor: #items!accessing!public! !
!MenuItem categoriesFor: #itemsDo:!accessing!private! !
!MenuItem categoriesFor: #itemWithId:!accessing!public! !
!MenuItem categoriesFor: #menuFromHandle:!accessing!public! !
!MenuItem categoriesFor: #name!public! !
!MenuItem categoriesFor: #populateItemInfo:!private!realizing/unrealizing! !
!MenuItem categoriesFor: #printOn:!printing!public! !
!MenuItem categoriesFor: #queryAlong:!operations!public! !
!MenuItem categoriesFor: #registerAcceleratorKeyIn:!menus!public! !
!MenuItem categoriesFor: #styleFlags!accessing!private! !
!MenuItem categoriesFor: #styleFlags:!accessing!not an aspect!private! !
!MenuItem categoriesFor: #text!accessing!public! !

MenuItem methodProtocol: #menuItem attributes: #(#readOnly) selectors: #(#acceleratorKey #command #hasSubmenu #id #image #insertIntoMenu:at:info: #items #menuFromHandle: #queryAlong: #registerAcceleratorKeyIn: #text)!

!MenuItem class methodsFor!

errorIllegalMenuString: illegalString
	"Private - Raise an error to inform that illegalString can not be
	used to generate a MenuItem because it is of the incorrect format."

	self error: 'Illegal menu string: ', illegalString!

fromString: menuString
	"Answer a new sub-instance of the receiver generated from menuString."

	| divider |
	divider := Dividers lookup: menuString.
	divider notNil
		ifTrue: [^DividerMenuItem perform: divider]
		ifFalse: 
			[| subStrings |
			(subStrings := StringSeparator split: menuString) size == 3
				ifTrue: 
					[| commandDescription accel |
					commandDescription := CommandDescription command: (subStrings at: 3) asSymbol.
					commandDescription description: (subStrings at: 1).
					(accel := subStrings at: 2) notEmpty ifTrue: [commandDescription acceleratorKeyString: accel].
					^CommandMenuItem new commandDescription: commandDescription]
				ifFalse: [self errorIllegalMenuString: menuString]]!

initialize
	"Private - Initialize the class variables of the receiver:
		MenuItem initialize
	"

	self addClassConstant: 'Dividers'
		value: ##(LookupTable new
				at: '-' put: #separator;
				at: '|' put: #break;
				at: '||' put: #barBreak;
				shrink;
				yourself)!

new
	"Private - MenuItem is abstract"

	^self subclassResponsibility
!

stbConvertFrom: anSTBClassFormat 
	"Convert from earlier version models.
		1: Added 'typeFlags' instance variable.
		2: 'image' instance variable added to CommandMenuItem subclass"

	^anSTBClassFormat version < 1 
		ifTrue: 
			[
			[:data | 
			| newInst |
			newInst := self basicNew.
			data keysAndValuesDo: [:i :v | newInst instVarAt: i + 1 put: v].
			newInst flags: MFT_STRING.
			newInst]]
		ifFalse: 
			[
			[:data | 
			| newInst |
			newInst := self basicNew.
			1 to: data size do: [:i | newInst instVarAt: i put: (data at: i)].
			newInst]]!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^1! !
!MenuItem class categoriesFor: #errorIllegalMenuString:!exceptions!private! !
!MenuItem class categoriesFor: #fromString:!instance creation!public! !
!MenuItem class categoriesFor: #initialize!development!initializing!private! !
!MenuItem class categoriesFor: #new!instance creation!private! !
!MenuItem class categoriesFor: #stbConvertFrom:!binary filing!public! !
!MenuItem class categoriesFor: #stbVersion!binary filing!public! !

