"Filed out from Dolphin Smalltalk"!

MenuItem subclass: #CommandMenuItem
	instanceVariableNames: 'commandDescription image _reserved'
	classVariableNames: 'IsDefaultMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CommandMenuItem guid: (GUID fromString: '{87b4c660-026e-11d3-9fd7-00a0cc3e4a32}')!
CommandMenuItem comment: 'CommandMenuItem represents a <commandSource> menu item held by a <Menu>. The item is configured with a <CommandDescription> to be fired when the item is chosen.. 

Instance Variables:
	commandDescription	<CommandDescription> indicating the command to be fired for the item.
	image			<Image> currently associated with the menu item, if any. #queryCommand: routing can change this from the image statically associated with the command.
	_reserved		<UndefinedObject> reserved for future use.

Class Variables:
	IsDefaultMask	<integer>


'!
!CommandMenuItem categoriesForClass!MVP-Views-Support! !
!CommandMenuItem methodsFor!

acceleratorKey
	"Answer the accelerator key code for the receiver."

	^self commandDescription acceleratorKey!

acceleratorKey: key
	"Sets the accelerator key to the <Integer> accelerator key description, key."

	self commandDescription acceleratorKey: key!

acceleratorKeyDisplayString
	"Answer the accelerator key string for the receiver using the key names from the default Keyboard."

	^self commandDescription acceleratorKeyDisplayString!

acceleratorKeyString
	"Answer the accelerator key string for the receiver using the key names from the invariant Keyboard."

	^self commandDescription acceleratorKeyString!

acceleratorKeyString: aString
	"Sets the accelerator key to the chord determined by parsing the accelerator key <String> argument."

	self commandDescription acceleratorKeyString: aString!

command: aCommandSelectorOrMessage
	"Sets the command symbol or message held by the receiver"

	self commandDescription command: aCommandSelectorOrMessage!

commandDescription
	"Private - Answer the CommandDescription for the receiver"

	^commandDescription!

commandDescription: aCommandDescription
	"Private - Set the CommandDescription for the receiver"

	commandDescription := aCommandDescription!

commandString
	"Answer a String representation of the receiver's command."

	^self commandDescription commandString!

commandString: commandText
	"Sets the receiver's command from the <readableString> representation, commandText."

	self commandDescription commandString: commandText!

description
	"Answers a short <readableString> description of the receiver's command."

	^self commandDescription description!

description: aString
	"Sets the String description of the receiver's command."

	^self commandDescription description: aString!

displayOn: aStream
	"Appends the receiver to aStream as a representation that a 
	user would want to see"

	aStream display: self description!

id
	"Answers the menu item identifier for the receiver. This is the command
	id that Windows uses to identify the command."

	^self commandDescription id!

image
	"Answer the <Image> currently associated with this menu item."

	^image ifNil: [self commandDescription image]!

image: anImageOrNil 
	"Sets the image associoated with the receiver's command to anImageOrNil."

	image := nil.
	^self commandDescription image: anImageOrNil!

isDefault
	"Answer whether the receiver is expecting to be the default item on a menu.
	Note that if other items on the same menu are also set up with the default
	style, then the behaviour is undefined (only one will get to be the default),
	also this static configuration may be overridden dynamically by the 
	command query mechanism."

	^self flags allMask: IsDefaultMask!

isDefault: aBoolean
	"Set whether the receiver is expecting to be the default item on a menu."

	self flags: (self flags mask: IsDefaultMask set: aBoolean)!

isModalCommand
	^self commandDescription isModalCommand!

isModalCommand: aBoolean
	self commandDescription isModalCommand: aBoolean!

isRadioButtonStyle
	"Answer whether the receiver is a radio button style checked item."

	^self flags allMask: MFT_RADIOCHECK!

isRadioButtonStyle: aBoolean
	"Set whether the receiver is a radio button style checked item."

	self flags: (self flags mask: MFT_RADIOCHECK set: aBoolean)!

itemWithId: anInteger 
	"Find and return the command in the menu associated with the specified id, or nil if not found."

	^anInteger = self id ifTrue: [self]!

populateItemInfo: aMENUITEMINFO 
	"Private - Copy the receiver's item information into the <MENUITEMINFOW> argument."

	aMENUITEMINFO commandMenuItem: self!

postCopy
	"Apply any final flourish to the copy that may be required."
	
	commandDescription := commandDescription copy.
	^self!

queryAlong: aCommandPolicy 
	"Answer a <CommandQuery> reflecting the current state of the receiver's command for the
	specified <commandPolicy>. In this case we want to preconfigure the query with some static
	settings (actually only whether the command is the default at this time)."

	| query |
	query := aCommandPolicy newCommandQuery: self commandDescription.
	query isDefault: self isDefault.
	aCommandPolicy queryCommand: query.
	image := query image.
	^query!

registerAcceleratorKeyIn: anAcceleratorTable
	"Register the accelerator key associated with this menu item, if
	there is one, in anAcceleratorTable."

	self commandDescription registerAcceleratorKeyIn: anAcceleratorTable.
!

stbSaveOn: anSTBOutFiler 
	"Output the receiver to anSTBOutFiler. We don't want the cached images to be saved."

	anSTBOutFiler override: image with: nil.
	super stbSaveOn: anSTBOutFiler!

text
	"Answer the menu text (i.e. the text that appears in the menu) for the receiver."

	^self commandDescription menuText! !
!CommandMenuItem categoriesForMethods!
acceleratorKey!accessing!public! !
acceleratorKey:!accessing!public! !
acceleratorKeyDisplayString!accessing!public! !
acceleratorKeyString!accessing!public! !
acceleratorKeyString:!accessing!public! !
command:!accessing!public! !
commandDescription!accessing!private! !
commandDescription:!accessing!private! !
commandString!accessing!public! !
commandString:!accessing!public! !
description!accessing!public! !
description:!accessing!public! !
displayOn:!displaying!public! !
id!accessing!public! !
image!accessing!public! !
image:!accessing!public! !
isDefault!accessing!public! !
isDefault:!accessing!public! !
isModalCommand!public!testing! !
isModalCommand:!accessing!public! !
isRadioButtonStyle!accessing!public! !
isRadioButtonStyle:!accessing!public! !
itemWithId:!accessing!public! !
populateItemInfo:!private!realizing/unrealizing! !
postCopy!copying!public! !
queryAlong:!operations!public! !
registerAcceleratorKeyIn:!menus!public! !
stbSaveOn:!binary filing!public! !
text!accessing!public! !
!

CommandMenuItem methodProtocol: #commandSource attributes: #(#readOnly) selectors: #(#commandDescription)!

!CommandMenuItem class methodsFor!

command: action description: text
	"Answer a new instance of the receiver containing a <CommandDescription> composed
	from the niladicValuable>, action, and the <readableString> description, text."

	^self commandDescription: (CommandDescription command: action description: text)!

command: action description: text image: image
	"Answer a new instance of the receiver containing a <CommandDescription> composed
	from the niladicValuable>, action, the <readableString> description, text and the <Image>, image."

	^self commandDescription: (CommandDescription command: action description: text image: image)!

commandDescription: aCommandDescription
	"Answers a new instance of the receiver for the specified command."

	^self basicNew
		flags: MFT_STRING;
		commandDescription: aCommandDescription!

initialize
	"Private - Initialize the class variables of the receiver:
		self initialize
	"

	IsDefaultMask := 16r100000.
	!

new
	"Answers an instance of the receiver"

	^self commandDescription: CommandDescription new!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^2! !
!CommandMenuItem class categoriesForMethods!
command:description:!instance creation!public! !
command:description:image:!instance creation!public! !
commandDescription:!instance creation!public! !
initialize!development!initializing!private! !
new!instance creation!public! !
stbVersion!binary filing!public! !
!

