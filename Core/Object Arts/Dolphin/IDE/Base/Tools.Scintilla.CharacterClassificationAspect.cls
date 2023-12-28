"Filed out from Dolphin Smalltalk"!

Tools.KeyedAspect
	subclass: #'Tools.Scintilla.CharacterClassificationAspect'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'ControlCodeNames'
				-> (IdentityDictionary withAll: {
								$\0 -> 'NUL'.
								$\x1 -> 'SOH'.
								$\x2 -> 'SOT'.
								$\x3 -> 'EOT'.
								$\x4 -> 'EOT'.
								$\x5 -> 'ENQ'.
								$\x6 -> 'ACK'.
								$\a -> 'BEL'.
								$\b -> 'BS'.
								$\t -> 'TAB'.
								$\n -> 'LF'.
								$\v -> 'VT'.
								$\f -> 'FF'.
								$\r -> 'CR'.
								$\xE -> 'SO'.
								$\xF -> 'SI'.
								$\x10 -> 'DLE'.
								$\x11 -> 'DC1'.
								$\x12 -> 'DC2'.
								$\x13 -> 'DC3'.
								$\x14 -> 'DC4'.
								$\x15 -> 'NAK'.
								$\x16 -> 'SYN'.
								$\x17 -> 'EOB'.
								$\x18 -> 'CAN'.
								$\x19 -> 'EM'.
								$\x1A -> 'SUB'.
								$\x1B -> 'ESC'.
								$\x1C -> 'FS'.
								$\x1D -> 'GS'.
								$\x1E -> 'RS'.
								$\x1F -> 'US'.
								$\x20 -> 'SP'.
								$\x7F -> 'DEL'
							})
		}!
Tools.Scintilla.CharacterClassificationAspect guid: (Core.GUID fromString: '{d1b88e5a-fcd4-4920-9ddf-86ae73d810b9}')!
Tools.Scintilla.CharacterClassificationAspect comment: ''!
!Tools.Scintilla.CharacterClassificationAspect methodsFor!

displayAspectNameOf: anObject on: aStream
	| ch |
	ch := self key.
	aStream display: ch.
	(ControlCodeNames lookup: ch)
		ifNotNil: 
			[:desc |
			aStream
				space;
				nextPutAll: desc]! !
!Tools.Scintilla.CharacterClassificationAspect categoriesForMethods!
displayAspectNameOf:on:!displaying!private! !
!

!Tools.Scintilla.CharacterClassificationAspect class methodsFor!

character: aCharacter
	^self
		choice: aCharacter
		from: #(#whitespace #word #punctuation)
		type: Character!

character: aCharacter classification: aSymbol
	^self
		choice: aCharacter
		from: { aSymbol }
		type: Character!

icon
	^UI.Scintilla.ScintillaView icon! !
!Tools.Scintilla.CharacterClassificationAspect class categoriesForMethods!
character:!instance creation!public! !
character:classification:!instance creation!public! !
icon!constants!development!public! !
!

