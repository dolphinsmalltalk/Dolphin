"Filed out from Dolphin Smalltalk"!

Graphics.GraphicsTool
	subclass: #'UI.AcceleratorTable'
	instanceVariableNames: 'commands'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'KeySeparator' -> $+ }!

UI.AcceleratorTable guid: (Core.GUID fromString: '{87b4c632-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.AcceleratorTable comment: '`AcceleratorTable` is the class used to represent the table of "accelerator" key sequences associated with a top-level view. These key-sequences provide keyboard shortcuts to commands on the menu or toolbar (or any other command sources).

## Instance Variables:
  `commands`		`IdentityDictionary` mapping between a key code `<integer>` and the associated `CommandDescription`
'!

!UI.AcceleratorTable categoriesForClass!Graphics-Tools! !

!UI.AcceleratorTable methodsFor!

addCommand: aCommandDescription 
	"Add a new accelerator to the table. The argument, vKeyCode, is an integer with the
	following bit format:
		0-8	virtual key code
		1	extended key bit
		9-16 accelerator key modifier flags (e.g. FALT).
	Note that if the same accelerator key combination is added more then once, then the latest
	addition will take precedence."

	commands at: aCommandDescription acceleratorKey put: aCommandDescription!

basicFree
	"Private - Free up the Accelerator resource handle.
	Ignore any error return (e.g. due to an invalid handle)."

	User32 destroyAcceleratorTable: handle!

commands
	^commands!

commands: anArrayOfCommandDescription 
	commands := anArrayOfCommandDescription!

createHandle
	"Private - Realizes the handle for the accelerator table and registers all selectors.
	This does not usually happen until the first key press occurs in a new shell window."

	"NB: CreateAcceleratorTable requires a pointer to a variable sized array of ACCEL structures."

	| accels count cmds struct |
	cmds := self commands.
	count := cmds size.
	accels := StructureArray length: count elementClass: ACCEL.
	accels beUnfinalizable.	"Nothing to free here"
	struct := accels uncheckedAt: 1.
	cmds keysAndValuesDo: 
			[:vkey :command |
			struct
				fVirt: ((vkey bitShift: -9) bitOr: FVIRTKEY);
				key: (vkey bitAnd: 16rFF);
				cmd: command id.	"Always add virtual key flag, or modifiers ignored"
			struct initializeAtAddress: struct yourAddress + ACCEL._ACCEL_Size].
	^User32 createAcceleratorTable: accels cEntries: count!

includes: commandSymbol 
	"Answer whether there is an entry in the accelerator table for commandSymbol."

	^self commands anySatisfy: [:each | each commandSymbol == commandSymbol]!

initialize
	"Private - Initialize the receiver."

	super initialize.
	commands := IdentityDictionary new!

isEmpty
	"Answer whether any accelerator keys have been set."

	^commands isEmpty!

notEmpty
	"Answer whether any accelerator keys have been set."

	^self isEmpty not!

postCopy
	"Apply any final flourish to the copy that may be required in order to ensure that the copy
	does not share non-shareable  state with the original. Answer the receiver."

	super postCopy.
	commands := commands copy.
	^self! !

!UI.AcceleratorTable categoriesForMethods!
addCommand:!adding!public! !
basicFree!private!realizing/unrealizing! !
commands!accessing!public! !
commands:!initializing!private! !
createHandle!private!realizing/unrealizing! !
includes:!public!searching! !
initialize!initializing!private! !
isEmpty!public!testing! !
notEmpty!public!testing! !
postCopy!copying!public! !
!

!UI.AcceleratorTable class methodsFor!

canonicalizeKeyString: aString
	| keyboard |
	keyboard := Keyboard invariant.
	^self keyStringFromCode: (self keyCodeFromString: aString keyboard: keyboard) keyboard: keyboard!

icon
	"Answers an Icon that can be used to represent this class"

	^Keyboard icon!

invariantKeyStringFromCode: anInteger
	"Answer a localised accelerator string corresponding to the <integer> accelerator key code, anInteger, as described by the invariant keyboard layout."

	^self keyStringFromCode: anInteger keyboard: Keyboard invariant!

keyCode: vkInteger modifiers: maskInteger
	"Answer an accelerator key code (a <SmallInteger> packed with a virtual key code and accelerator modifiers) created from the 9-bit <integer> virtual key code (the high bit is used to mark extended keys), vkInteger, and the modifier flags <integer> (e.g. FALT), maskInteger. The value will be < 16r4000"

	^(vkInteger bitAnd: 16r1FF) bitOr: (maskInteger bitShift: 9)!

keyCodeFromInvariantString: aString
	"Answer an <integer> accelerator key code (a value packed with a virtual key code and accelerator modifiers) created from the invariant (English) accelerator key description,
	aString."

	^self keyCodeFromString: aString keyboard: Keyboard invariant!

keyCodeFromString: aString
	"Answer an <integer> accelerator key code (a packed value containing the virtual key code and accelerator modifiers) created from the localised accelerator key description, aString."

	^self keyCodeFromString: aString keyboard: Keyboard default!

keyCodeFromString: aString keyboard: aKeyboard
	"Answer an accelerator key code (a <SmallInteger> packed with a virtual key code and accelerator modifiers) created from the key descriptions of the specified <Keyboard>."

	| keys count modifierKeys modifierFlags |
	keys := KeySeparator split: aString.
	count := keys size.
	count == 0 ifTrue: [^0].
	modifierKeys := aKeyboard modifierKeys.
	"The FVIRTKEY modifier flag is always set."
	modifierFlags := FVIRTKEY.
	1 to: count - 1
		do: [:i | modifierFlags := modifierFlags bitOr: (modifierKeys at: (keys at: i) ifAbsent: 0)].
	^self keyCode: (aKeyboard virtualKeyFromString: (keys at: count)) modifiers: modifierFlags!

keyStringFromCode: anInteger
	"Answer a localised accelerator string corresponding to the <integer> accelerator key code, anInteger, as described by the current keyboard layout."

	^self keyStringFromCode: anInteger keyboard: Keyboard default!

keyStringFromCode: anInteger keyboard: aKeyboard
	"Answer a localised accelerator string corresponding to the accelerator key code, anInteger, as described by the specified Keyboard layout."

	| stream |
	stream := WriteStream on: (Utf8String new: 12).
	self
		printKeyboard: aKeyboard
		code: anInteger
		on: stream.
	^stream contents!

printKeyboard: aKeyboard code: anInteger on: aPuttableStream
	| keys modifiers |
	keys := aKeyboard keyNames.
	modifiers := anInteger bitShift: -9.
	(modifiers allMask: FCONTROL)
		ifTrue: 
			[aPuttableStream
				nextPutAll: (keys at: VK_CONTROL);
				nextPut: KeySeparator].
	(modifiers allMask: FSHIFT)
		ifTrue: 
			[aPuttableStream
				nextPutAll: (keys at: VK_SHIFT);
				nextPut: KeySeparator].
	(modifiers allMask: FALT)
		ifTrue: 
			[aPuttableStream
				nextPutAll: (keys at: VK_MENU);
				nextPut: KeySeparator].
	(keys lookup: (anInteger bitAnd: 16r1FF)) ifNotNil: [:keyName | aPuttableStream nextPutAll: keyName]!

printKeyCode: anInteger on: aPuttableStream
	self
		printKeyboard: Keyboard default
		code: anInteger
		on: aPuttableStream!

splitKeyCode: anInteger
	"Answer a 2-element <Array> containing a virtual key code <integer> and accelerator table modifier flags <integer> from the <integer> accelerator key code argument."

	^{anInteger bitAnd: 16r1FF. anInteger bitShift: -9}!

splitKeyString: aString
	"Answer an <Array> of <String>s containing the names of the keys specified in the <readableString> accelerator key chord, aString. Note that this must not contain any spaces."

	^KeySeparator split: aString!

stbConvertFrom: anSTBClassFormat
	"Version 1 changes format of the 'commands' (formerly 'accelerators') instance variable."

	anSTBClassFormat version == 0
		ifTrue: 
			[^
			[:data |
			data becomeA: self.
			data commands: (IdentityDictionary withAll: data commands).
			data]].
	^super stbConvertFrom: anSTBClassFormat!

stbVersion
	^1! !

!UI.AcceleratorTable class categoriesForMethods!
canonicalizeKeyString:!enquiries!public!utilities! !
icon!constants!public! !
invariantKeyStringFromCode:!enquiries!public! !
keyCode:modifiers:!helpers!public! !
keyCodeFromInvariantString:!enquiries!public! !
keyCodeFromString:!enquiries!public! !
keyCodeFromString:keyboard:!enquiries!public! !
keyStringFromCode:!enquiries!public! !
keyStringFromCode:keyboard:!enquiries!public! !
printKeyboard:code:on:!enquiries!public! !
printKeyCode:on:!enquiries!public! !
splitKeyCode:!helpers!public! !
splitKeyString:!helpers!public! !
stbConvertFrom:!binary filing!private! !
stbVersion!binary filing!public! !
!

