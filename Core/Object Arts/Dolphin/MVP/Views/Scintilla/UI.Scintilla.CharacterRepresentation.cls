"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'UI.Scintilla.CharacterRepresentation'
	instanceVariableNames: 'character representation appearance color'
	classVariableNames: 'DefaultRepresentations'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.CharacterRepresentation guid: (Core.GUID fromString: '{8dada09d-fef9-4496-99af-3b3493157558}')!
UI.Scintilla.CharacterRepresentation comment: ''!
!UI.Scintilla.CharacterRepresentation categoriesForClass!MVP-Views-Support! !
!UI.Scintilla.CharacterRepresentation methodsFor!

applyToView: aScintillaView initializing: aBoolean
	| ch |
	ch := self encodedCharacter.
	aBoolean ifFalse: [aScintillaView sciClearRepresentation: ch].
	aScintillaView sciSetRepresentation: ch representation: self representation.
	color ifNotNil: [aScintillaView sciSetRepresentationColour: ch colour: color].
	appearance == SC_REPRESENTATION_BLOB
		ifFalse: [aScintillaView sciSetRepresentationAppearance: ch appearance: appearance]!

character
	^character ifNil: [$\xE000]!

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
applyToView:initializing:!private!updating! !
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
		color: Color windowText;
		yourself!

icon
	^ScintillaView icon!

initialize
	"
	self initialize
	"

	| defaultRepresentations |
	defaultRepresentations := LookupTable new.
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

