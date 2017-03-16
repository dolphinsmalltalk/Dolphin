"Filed out from Dolphin Smalltalk 7"!

GraphicsTool subclass: #AcceleratorTable
	instanceVariableNames: 'commands'
	classVariableNames: 'KeyNamesToModifiers NamesOfModifiers'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AcceleratorTable guid: (GUID fromString: '{87b4c632-026e-11d3-9fd7-00a0cc3e4a32}')!
AcceleratorTable comment: 'AcceleratorTable is the class used to represent the table of "accelerator" key sequences associated with a top-level view. These key-sequences provide keyboard shortcuts to commands on the menu or toolbar (or any other command sources).

Instance Variables:
	accelerators		<collection> of <Association>s between a key code <integer> and the associated <CommandDescription>

Class Variables:
	KeyNamesToModifiers	<LookupTable> mapping the names of the modifier keys (e.g. CTLR and SHIFT), to the key code mask for that modifier.
	NamesOfModifiers		<Array> of <Association> between <integer> modifier and corresponding <string> key name, in menu display order.'!
!AcceleratorTable categoriesForClass!Graphics-Tools! !
!AcceleratorTable methodsFor!

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

	UserLibrary default destroyAcceleratorTable: handle!

commands
	^commands!

commands: anArrayOfCommandDescription 
	commands := anArrayOfCommandDescription!

createHandle
	"Private - Realizes the handle for the accelerator table and registers all selectors.
	This does not usually happen until the first key press occurs in a new shell window."

	"NB: CreateAcceleratorTable requires a pointer to a variable sized array of ACCEL structures."

	| accels count cmds i |
	cmds := self commands.
	count := cmds size.
	accels := StructureArray length: count elementClass: ACCEL.
	accels beUnfinalizable.	"Nothing to free here"
	i := 1.
	cmds keysAndValuesDo: [:vkey :command ||struct |
		struct := accels at: i.
		struct
			fVirt: ((vkey bitShift: -9) bitOr: FVIRTKEY);
			key: (vkey bitAnd: 16rFF);
			cmd: command id	"Always add virtual key flag, or modifiers ignored".
		i := i + 1].
	^UserLibrary default createAcceleratorTable: accels cEntries: count!

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
!AcceleratorTable categoriesFor: #addCommand:!adding!public! !
!AcceleratorTable categoriesFor: #basicFree!private!realizing/unrealizing! !
!AcceleratorTable categoriesFor: #commands!accessing!public! !
!AcceleratorTable categoriesFor: #commands:!accessing!private! !
!AcceleratorTable categoriesFor: #createHandle!private!realizing/unrealizing! !
!AcceleratorTable categoriesFor: #includes:!public!searching! !
!AcceleratorTable categoriesFor: #initialize!initializing!private! !
!AcceleratorTable categoriesFor: #isEmpty!public!testing! !
!AcceleratorTable categoriesFor: #notEmpty!public!testing! !
!AcceleratorTable categoriesFor: #postCopy!copying!public! !

!AcceleratorTable class methodsFor!

accelPartFromString: aString 
	"Private - Answer a displayable key name string from the argument, aString.
	Used to format key names for display on menus, etc."

	^(aString asLowercase)
		at: 1 put: aString first asUppercase;
		yourself!

icon
	"Answers an Icon that can be used to represent this class"

	^Keyboard icon!

initialize 
        "Private - Initialize the receiver's class variables. 

        Evaluate me to initialize: 
                AcceleratorTable initialize 
        " 

        KeyNamesToModifiers := LookupTable new. 
        NamesOfModifiers := (Array 
                                with: 'CTRL' -> FCONTROL 
                                with: 'SHIFT' -> FSHIFT 
                                with: 'ALT' ->FALT) collect: 
                                                [:a | 
                                                | keyName | 
                                                keyName := a key. 
                                                KeyNamesToModifiers at: keyName put: a value. 
                                                a value -> (self accelPartFromString: keyName)]. 
        NamesOfModifiers isImmutable: true. 
        KeyNamesToModifiers 
                shrink; 
                isImmutable: true !

keyCode: virtualKey modifiers: modifierMask
	"Answer an accelerator key code (an <integer> packed with a virtual key code
	and accelerator modifiers) created from the 9-bit <integer> virtual key code (the high
	bit is used to mark extended keys), virtualKey, and the modifier flags <integer> (e.g. FALT), 
	modifierMask."

	^(virtualKey bitAnd: 16r1FF) bitOr: (modifierMask bitShift: 9)!

keyCodeFromString: aString
	"Answer an accelerator key code (an integer packed with a virtual key code
	and accelerator modifiers) created from the accelerator key description,
	aString."

	| keys |
	keys := self splitKeyString: aString.
	keys isEmpty ifTrue: [^0].
	^self keyCode: (Keyboard virtualKey: keys last) modifiers: (self keyModifiers: keys)!

keyModifierNames: anInteger 
	"Answer a <sequencedReadableCollection> of <String>s , being the names of the 
	virtual key modifiers in the <integer> mask, anInteger."

	| answer |
	answer := OrderedCollection new.
	self keyModifierNames: anInteger do: [:each | answer add: each value].
	^answer!

keyModifierNames: anInteger do: aMonadicValuable 
	NamesOfModifiers 
		do: [:each | (anInteger anyMask: each key) ifTrue: [aMonadicValuable value: each value]]!

keyModifiers: anArrayOfKeys 
	"Answer virtual key flags generated from anArrayOfKeys
		#(['CTRL' ]['SHIFT' ]['ALT' ]<key>)
		eg #('CTRL' 'SHIFT' 'H') or #('CTRL' 'S').
	The FVIRTKEY modifier flag is always set."

	^anArrayOfKeys inject: FVIRTKEY
		into: [:sum :each | sum bitOr: (KeyNamesToModifiers at: each asUppercase ifAbsent: [0])]!

keySeparator
	"Private - Answer the receivers keySeparator."

	^$+!

keyStringFromCode: keyCode
	"Private - Answer an accelerator string corresponding to the accelerator
	key code, keyCode, as described by the current keyboard layout."

	| split |
	split := self splitKeyCode: keyCode.
	^self keyStringFromCode: split first modifiers: split last!

keyStringFromCode: vkInteger modifiers: maskInteger 
	"Private - Answer an accelerator string constructed for the specified virtual key and
	modifiers."

	| keyString |
	keyString := String writeStream.
	self keyModifierNames: maskInteger
		do: 
			[:each | 
			keyString
				nextPutAll: each;
				nextPut: self keySeparator].
	keyString nextPutAll: (Keyboard 
				keyNameFromVKey: ((vkInteger bitAnd: 16r1FF) maskSet: (maskInteger maskClear: 16rFF))
				ifNone: ['']).
	^keyString contents!

splitKeyCode: keyCode
	"Answer a 2-element <Array> containing a virtual key code <integer>
	and accelerator table modifier flags <integer> from the <integer> accelerator 
	key code, keyCode."

	^Array
		with: (keyCode bitAnd: 16r1FF)
		with: (keyCode bitShift: -9)!

splitKeyString: aString
	"Answer an <Array> of <String>s containing the names of the keys specified 
	in the <readableString> accelerator key description, aString. Note that this
	must not contain any spaces."

	^aString subStrings: self keySeparator!

stbConvertFrom: anSTBClassFormat 
	"Version 1 changes format of the 'commands' (formerly 'accelerators') instance variable."

	^
	[:data | 
	| newInstance map |
	newInstance := self basicNew.
	1 to: data size do: [:i | newInstance instVarAt: i put: (data at: i)].
	map := IdentityDictionary new.
	newInstance commands do: [:each | map at: each key put: each value].
	newInstance commands: map.
	newInstance]!

stbVersion
	^1! !
!AcceleratorTable class categoriesFor: #accelPartFromString:!helpers!private! !
!AcceleratorTable class categoriesFor: #icon!constants!public! !
!AcceleratorTable class categoriesFor: #initialize!development!initializing!private! !
!AcceleratorTable class categoriesFor: #keyCode:modifiers:!helpers!public! !
!AcceleratorTable class categoriesFor: #keyCodeFromString:!enquiries!public! !
!AcceleratorTable class categoriesFor: #keyModifierNames:!enquiries!public! !
!AcceleratorTable class categoriesFor: #keyModifierNames:do:!enquiries!public! !
!AcceleratorTable class categoriesFor: #keyModifiers:!enquiries!public! !
!AcceleratorTable class categoriesFor: #keySeparator!constants!private! !
!AcceleratorTable class categoriesFor: #keyStringFromCode:!enquiries!private! !
!AcceleratorTable class categoriesFor: #keyStringFromCode:modifiers:!enquiries!private! !
!AcceleratorTable class categoriesFor: #splitKeyCode:!helpers!public! !
!AcceleratorTable class categoriesFor: #splitKeyString:!helpers!public! !
!AcceleratorTable class categoriesFor: #stbConvertFrom:!binary filing!private! !
!AcceleratorTable class categoriesFor: #stbVersion!binary filing!public! !

