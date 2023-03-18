"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.Scintilla.CharacterRepresentation'
	instanceVariableNames: 'character representation appearance color'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'DefaultRepresentations'
				-> (LookupTable withAll: {
								$\0 -> $\x2400.
								$\x1 -> $\x2401.
								$\x2 -> $\x2402.
								$\x3 -> $\x2403.
								$\x4 -> $\x2404.
								$\x5 -> $\x2405.
								$\x6 -> $\x2406.
								$\a -> $\x2407.
								$\b -> $\x2408.
								$\t -> $\x2409.
								$\n -> $\x240A.
								$\v -> $\x240B.
								$\f -> $\x240C.
								$\r -> $\x240D.
								$\xE -> $\x240E.
								$\xF -> $\x240F.
								$\x10 -> $\x2410.
								$\x11 -> $\x2411.
								$\x12 -> $\x2412.
								$\x13 -> $\x2413.
								$\x14 -> $\x2414.
								$\x15 -> $\x2415.
								$\x16 -> $\x2416.
								$\x17 -> $\x2417.
								$\x18 -> $\x2418.
								$\x19 -> $\x2419.
								$\x1A -> $\x241A.
								$\x1B -> $\x241B.
								$\x1C -> $\x241C.
								$\x1D -> $\x241D.
								$\x1E -> $\x241E.
								$\x1F -> $\x241F.
								$\x7F -> $\x2421.
								$\x80 -> 'PAD'.
								$\x81 -> 'HOP'.
								$\x82 -> 'BPH'.
								$\x83 -> 'NBH'.
								$\x84 -> 'IND'.
								$\x85 -> 'NEL'.
								$\x86 -> 'SSA'.
								$\x87 -> 'ESA'.
								$\x88 -> 'HTS'.
								$\x89 -> 'HTJ'.
								$\x8A -> 'VTS'.
								$\x8B -> 'PLD'.
								$\x8C -> 'PLU'.
								$\x8D -> 'RI'.
								$\x8E -> 'SS2'.
								$\x8F -> 'SS3'.
								$\x90 -> 'DCS'.
								$\x91 -> 'PU1'.
								$\x92 -> 'PU2'.
								$\x93 -> 'STS'.
								$\x94 -> 'CCH'.
								$\x95 -> 'MW'.
								$\x96 -> 'SPA'.
								$\x97 -> 'EPA'.
								$\x98 -> 'SOS'.
								$\x99 -> 'SGCI'.
								$\x9A -> 'SCI'.
								$\x9B -> 'CSI'.
								$\x9C -> 'ST'.
								$\x9D -> 'OSC'.
								$\x9E -> 'PM'.
								$\x9F -> 'APC'.
								$\x2028 -> $\x21B2.
								$\x2029 -> $¶
							})
		}!
UI.Scintilla.CharacterRepresentation guid: (Core.GUID fromString: '{8dada09d-fef9-4496-99af-3b3493157558}')!
UI.Scintilla.CharacterRepresentation comment: ''!
!UI.Scintilla.CharacterRepresentation categoriesForClass!MVP-Views-Support! !
!UI.Scintilla.CharacterRepresentation methodsFor!

applyToView: aScintillaView
	| ch |
	ch := self encodedCharacter.
	aScintillaView sciSetRepresentation: ch representation: self representation.
	color ifNotNil: [aScintillaView sciSetRepresentationColour: ch colour: color].
	appearance == SC_REPRESENTATION_BLOB
		ifFalse: [aScintillaView sciSetRepresentationAppearance: ch appearance: appearance]!

character
	^character ?? $\xE000!

character: aCharacter
	character := aCharacter!

color
	^color!

color: aColor
	color = aColor ifTrue: [^self].
	color := aColor.
	appearance := appearance mask: SC_REPRESENTATION_COLOUR set: color notNil!

encodedCharacter
	| ch |
	ch := self character.
	^ch = $\x2028 ifTrue: [String lineDelimiter] ifFalse: [ch asUtf8String]!

initialize
	appearance := SC_REPRESENTATION_BLOB!

isBlob
	^appearance allMask: SC_REPRESENTATION_BLOB!

isBlob: aBoolean
	appearance := appearance mask: SC_REPRESENTATION_BLOB set: aBoolean!

printOn: aStream
	"Append a short textual description of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: self character;
		nextPutAll: ' => ';
		print: self representation;
		nextPut: $)!

representation
	^representation
		ifNil: 
			[| ch |
			ch := self character.
			((DefaultRepresentations lookup: ch) ?? ch) asUtf8String]!

representation: aString
	representation := aString ifNotNil: [aString asUtf8String]! !
!UI.Scintilla.CharacterRepresentation categoriesForMethods!
applyToView:!private!updating! !
character!accessing!public! !
character:!public! !
color!accessing!public! !
color:!accessing!public! !
encodedCharacter!accessing!private! !
initialize!initializing!private! !
isBlob!public!testing! !
isBlob:!accessing!public! !
printOn:!development!printing!public! !
representation!accessing!public! !
representation:!accessing!public! !
!

!UI.Scintilla.CharacterRepresentation class methodsFor!

forCharacter: aCharacter
	^self new
		character: aCharacter;
		yourself!

forLineEnding
	^(self forCharacter: $\x2028)
		isBlob: false;
		color: Color.WindowText;
		yourself!

icon
	^ScintillaView icon!

initialize
	"
	self initialize
	"

	| defaultRepresentations |
	defaultRepresentations := LookupTable new: 127.
	0 to: 31
		do: [:i | defaultRepresentations at: (Character codePoint: i) put: (Character codePoint: 16r2400 + i)].
	defaultRepresentations at: $\x7F put: $\x2421.
	#('PAD' 'HOP' 'BPH' 'NBH' 'IND' 'NEL' 'SSA' 'ESA' 'HTS' 'HTJ' 'VTS' 'PLD' 'PLU' 'RI' 'SS2' 'SS3' 'DCS' 'PU1' 'PU2' 'STS' 'CCH' 'MW' 'SPA' 'EPA' 'SOS' 'SGCI' 'SCI' 'CSI' 'ST' 'OSC' 'PM' 'APC')
		keysAndValuesDo: [:key :value | defaultRepresentations at: (Character codePoint: 16r7F + key) put: value].
	defaultRepresentations at: $\x2028 put: $\x21B2.
	defaultRepresentations at: $\x2029 put: $¶.
	self addClassConstant: 'DefaultRepresentations' value: defaultRepresentations
!

new
	^self basicNew initialize! !
!UI.Scintilla.CharacterRepresentation class categoriesForMethods!
forCharacter:!instance creation!public! !
forLineEnding!instance creation!public! !
icon!constants!development!public! !
initialize!public! !
new!instance creation!public! !
!

