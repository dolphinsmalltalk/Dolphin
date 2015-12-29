"Filed out from Dolphin Smalltalk XP"!

SmaCCParser subclass: #SmaCCScannerParser
	instanceVariableNames: 'tokens'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCScannerParser guid: (GUID fromString: '{5DD70C97-A7B6-4709-ACCE-654CB9241AEB}')!
SmaCCScannerParser comment: 'SmaCCScannerParser is the parser for the scanner definition.

Instance Variables:
	tokens	<Dictionary key: String value: SmaCCRegularExpressionNode>	the tokens that are parsed

'!
!SmaCCScannerParser categoriesForClass!SmaCC Runtime! !
!SmaCCScannerParser methodsFor!

allCharacters
	^String withAll: ((0 to: SmaCCGrammar maximumCharacterValue) 
				collect: [:each | Character value: each])!

charactersFor: aStream in: aToken 
	| characters char endCharacters |
	aStream atEnd ifTrue: [self reportCharacterBlockErrorForToken: aToken].
	char := aStream next.
	characters := char == $\ 
				ifTrue: [(self nodeFor: aStream) characters]
				ifFalse: [OrderedCollection with: char].
	(characters size = 1 and: [aStream peekFor: $-]) ifFalse: [^characters].
	endCharacters := self charactersFor: aStream in: aToken.
	endCharacters size > 1 
		ifTrue: [self reportCharacterBlockErrorForToken: aToken].
	^(characters first asInteger to: endCharacters first asInteger) 
		collect: [:each | Character value: each]!

initialize
	super initialize.
	tokens := Dictionary new!

nodeFor: aStream 
	| block char value count |
	char := aStream next.
	char == $f 
		ifTrue: 
			[^SmaCCCharacterRENode characters: (String with: (Character value: 12))].
	char == $n 
		ifTrue: 
			[^SmaCCCharacterRENode characters: (String with: (Character value: 10))].
	char == $r 
		ifTrue: 
			[^SmaCCCharacterRENode characters: (String with: (Character value: 13))].
	char == $t ifTrue: [^SmaCCCharacterRENode characters: '	'].
	char == $v 
		ifTrue: 
			[^SmaCCCharacterRENode characters: (String with: (Character value: 11))].
	char == $c 
		ifTrue: 
			[^SmaCCCharacterRENode characters: (String 
						with: (Character value: aStream next asInteger - $A asInteger))].
	char == $x 
		ifTrue: 
			[count := value := 0.
			
			[aStream atEnd not and: 
					[count < 4 and: 
							[char := aStream peek.
							(char between: $0 and: $9) 
								or: [(char between: $A and: $F) or: [char between: $a and: $f]]]]] 
					whileTrue: 
						[count := count + 1.
						value := value * 16 + aStream next digitValue].
			^SmaCCCharacterRENode characters: (String with: (Character value: value))].
	char == $d ifTrue: [block := [:each | each between: $0 and: $9]].
	char == $D ifTrue: [block := [:each | (each between: $0 and: $9) not]].
	char == $s 
		ifTrue: [block := [:each | #[9 10 11 12 13 32] includes: each asInteger]].
	char == $S 
		ifTrue: 
			[block := [:each | (#[9 10 11 12 13 32] includes: each asInteger) not]].
	char == $w 
		ifTrue: 
			[block := 
					[:each | 
					(each between: $a and: $z) or: 
							[(each between: $A and: $Z) 
								or: [(each between: $0 and: $9) or: [each == $_]]]]].
	char == $W 
		ifTrue: 
			[block := 
					[:each | 
					((each between: $a and: $z) or: 
							[(each between: $A and: $Z) 
								or: [(each between: $0 and: $9) or: [each == $_]]]) 
						not]].
	block isNil 
		ifTrue: [^SmaCCCharacterRENode characters: (String with: char)].
	^SmaCCCharacterRENode 
		characters: (String withAll: (self allCharacters select: block))!

parseCharacterBlock: aToken 
	| characters aStream invert |
	aStream := ReadStream 
				on: (aToken value copyFrom: 2 to: aToken value size - 1).
	characters := OrderedCollection new.
	invert := aStream peekFor: $^.
	[aStream atEnd] 
		whileFalse: [characters addAll: (self charactersFor: aStream in: aToken)].
	^String withAll: (invert 
				ifTrue: [self allCharacters reject: [:each | characters includes: each]]
				ifFalse: [characters])!

reduceActionForFile1: nodes
	^tokens!

reduceActionForFile2: nodes
	^tokens!

reduceActionForRegex1: nodes
	^nodes at: 1!

reduceActionForRegex2: nodes
	^(nodes at: 1) | (nodes at: 3)!

reduceActionForRegex3: nodes
	^(nodes at: 1) , (nodes at: 2)!

reduceActionForRegexTerm1: nodes
	^SmaCCCharacterRENode characters: (nodes at: 1) value!

reduceActionForRegexTerm10: nodes
	| readStream start stop |
	readStream := ReadStream 
				on: ((nodes at: 2) value copyFrom: 2 to: (nodes at: 2) value size - 1).
	start := readStream upTo: $,.
	stop := readStream upToEnd.
	^(nodes at: 1) repeatFor: (start isEmpty ifTrue: [0] ifFalse: [start asNumber])
		to: (stop isEmpty ifTrue: [1 bitShift: 31] ifFalse: [stop asNumber])!

reduceActionForRegexTerm2: nodes
	^SmaCCCharacterRENode characters: self allCharacters!

reduceActionForRegexTerm3: nodes
	^self 
		nodeFor: (ReadStream on: ((nodes at: 1) value copyFrom: 2 to: (nodes at: 1) value size))!

reduceActionForRegexTerm4: nodes
	^nodes at: 2!

reduceActionForRegexTerm5: nodes
	^SmaCCCharacterRENode characters: (self parseCharacterBlock: (nodes at: 1))!

reduceActionForRegexTerm6: nodes
	^(tokens at: (nodes at: 1) value) copy!

reduceActionForRegexTerm7: nodes
	^(nodes at: 1) repeat!

reduceActionForRegexTerm8: nodes
	^(nodes at: 1) repeatForAtLeast: 1!

reduceActionForRegexTerm9: nodes
	^(nodes at: 1) repeatFor: 0 to: 1!

reduceActionForRule1: nodes
	(nodes at: 3) position: (nodes at: 1) startPosition.
	tokens at: (nodes at: 1) value put: (nodes at: 3).
	^nil!

reduceTable
	^#(
#(19 3 #reduceActionForRule1:)
#(20 2 #reduceFor:)
#(20 3 #reduceFor:)
#(21 1 #reduceActionForRegexTerm1:)
#(21 1 #reduceActionForRegexTerm2:)
#(21 1 #reduceActionForRegexTerm3:)
#(21 3 #reduceActionForRegexTerm4:)
#(21 1 #reduceActionForRegexTerm5:)
#(21 1 #reduceActionForRegexTerm6:)
#(21 2 #reduceActionForRegexTerm7:)
#(21 2 #reduceActionForRegexTerm8:)
#(21 2 #reduceActionForRegexTerm9:)
#(21 2 #reduceActionForRegexTerm10:)
#(22 1 #reduceActionForFile1:)
#(22 0 #reduceActionForFile2:)
#(23 1 #reduceActionForRegex1:)
#(23 3 #reduceActionForRegex2:)
#(23 2 #reduceActionForRegex3:)
#(24 1 #reduceFor:)
)!

reportCharacterBlockErrorForToken: aToken 
	currentToken := aToken.
	self reportErrorMessage: 'Invalid character block'!

transitionTable
	^#(
#[1 0 9 0 12 0 62 0 18 0 13 0 19 0 17 0 20 0 21 0 22]
#[0 0 25 0 5]
#[0 0 29 0 7]
#[1 0 9 0 12 0 58 0 18 0 33 0 19]
#[0 0 0 0 18]
#[1 0 37 0 4 0 41 0 9 0 45 0 10 0 49 0 12 0 53 0 15 0 57 0 16 0 61 0 21 0 65 0 23]
#[0 0 10 0 12 0 18]
#[0 0 69 0 7]
#[1 0 37 0 4 0 41 0 9 0 45 0 10 0 49 0 12 0 53 0 15 0 57 0 16 0 61 0 21 0 73 0 23]
#[0 0 26 0 1 0 2 0 3 0 4 0 6 0 7 0 8 0 9 0 10 0 12 0 14 0 15 0 16]
#[0 0 34 0 1 0 2 0 3 0 4 0 6 0 7 0 8 0 9 0 10 0 12 0 14 0 15 0 16]
#[0 0 38 0 1 0 2 0 3 0 4 0 6 0 7 0 8 0 9 0 10 0 12 0 14 0 15 0 16]
#[0 0 18 0 1 0 2 0 3 0 4 0 6 0 7 0 8 0 9 0 10 0 12 0 14 0 15 0 16]
#[0 0 22 0 1 0 2 0 3 0 4 0 6 0 7 0 8 0 9 0 10 0 12 0 14 0 15 0 16]
#[1 0 66 0 1 0 77 0 2 0 66 0 3 0 66 0 4 0 81 0 6 0 66 0 7 0 85 0 8 0 66 0 9 0 66 0 10 0 66 0 12 0 89 0 14 0 66 0 15 0 66 0 16]
#[1 0 93 0 3 0 37 0 4 0 6 0 7 0 41 0 9 0 45 0 10 0 49 0 12 0 53 0 15 0 57 0 16 0 97 0 21]
#[0 0 14 0 12 0 18]
#[1 0 101 0 1 0 93 0 3 0 37 0 4 0 41 0 9 0 45 0 10 0 49 0 12 0 53 0 15 0 57 0 16 0 97 0 21]
#[0 0 42 0 1 0 2 0 3 0 4 0 6 0 7 0 8 0 9 0 10 0 12 0 14 0 15 0 16]
#[0 0 46 0 1 0 2 0 3 0 4 0 6 0 7 0 8 0 9 0 10 0 12 0 14 0 15 0 16]
#[0 0 50 0 1 0 2 0 3 0 4 0 6 0 7 0 8 0 9 0 10 0 12 0 14 0 15 0 16]
#[0 0 54 0 1 0 2 0 3 0 4 0 6 0 7 0 8 0 9 0 10 0 12 0 14 0 15 0 16]
#[1 0 37 0 4 0 41 0 9 0 45 0 10 0 49 0 12 0 53 0 15 0 57 0 16 0 61 0 21 0 105 0 23]
#[1 0 74 0 1 0 77 0 2 0 74 0 3 0 74 0 4 0 81 0 6 0 74 0 7 0 85 0 8 0 74 0 9 0 74 0 10 0 74 0 12 0 89 0 14 0 74 0 15 0 74 0 16]
#[0 0 30 0 1 0 2 0 3 0 4 0 6 0 7 0 8 0 9 0 10 0 12 0 14 0 15 0 16]
#[1 0 70 0 1 0 70 0 3 0 37 0 4 0 70 0 7 0 41 0 9 0 45 0 10 0 49 0 12 0 53 0 15 0 57 0 16 0 97 0 21]
)! !
!SmaCCScannerParser categoriesFor: #allCharacters!private! !
!SmaCCScannerParser categoriesFor: #charactersFor:in:!private! !
!SmaCCScannerParser categoriesFor: #initialize!initialize-release!public! !
!SmaCCScannerParser categoriesFor: #nodeFor:!private! !
!SmaCCScannerParser categoriesFor: #parseCharacterBlock:!private! !
!SmaCCScannerParser categoriesFor: #reduceActionForFile1:!generated-reduction actions!public! !
!SmaCCScannerParser categoriesFor: #reduceActionForFile2:!generated-reduction actions!public! !
!SmaCCScannerParser categoriesFor: #reduceActionForRegex1:!generated-reduction actions!public! !
!SmaCCScannerParser categoriesFor: #reduceActionForRegex2:!generated-reduction actions!public! !
!SmaCCScannerParser categoriesFor: #reduceActionForRegex3:!generated-reduction actions!public! !
!SmaCCScannerParser categoriesFor: #reduceActionForRegexTerm1:!generated-reduction actions!public! !
!SmaCCScannerParser categoriesFor: #reduceActionForRegexTerm10:!generated-reduction actions!public! !
!SmaCCScannerParser categoriesFor: #reduceActionForRegexTerm2:!generated-reduction actions!public! !
!SmaCCScannerParser categoriesFor: #reduceActionForRegexTerm3:!generated-reduction actions!public! !
!SmaCCScannerParser categoriesFor: #reduceActionForRegexTerm4:!generated-reduction actions!public! !
!SmaCCScannerParser categoriesFor: #reduceActionForRegexTerm5:!generated-reduction actions!public! !
!SmaCCScannerParser categoriesFor: #reduceActionForRegexTerm6:!generated-reduction actions!public! !
!SmaCCScannerParser categoriesFor: #reduceActionForRegexTerm7:!generated-reduction actions!public! !
!SmaCCScannerParser categoriesFor: #reduceActionForRegexTerm8:!generated-reduction actions!public! !
!SmaCCScannerParser categoriesFor: #reduceActionForRegexTerm9:!generated-reduction actions!public! !
!SmaCCScannerParser categoriesFor: #reduceActionForRule1:!generated-reduction actions!public! !
!SmaCCScannerParser categoriesFor: #reduceTable!generated-tables!public! !
!SmaCCScannerParser categoriesFor: #reportCharacterBlockErrorForToken:!private! !
!SmaCCScannerParser categoriesFor: #transitionTable!generated-tables!public! !

!SmaCCScannerParser class methodsFor!

parserDefinitionComment

	"%left	""|"";
%left ""("" <character> <backslashcharacter> <characterblock> <anycharacter> <tokenname>;
%left ""*"" ""+"" ""?"" <repeat> ;

File: Rules	 {tokens} 
	|  {tokens};

Rules: Rule "";""
	| Rules Rule "";"" ;

Rule: <tokenname> "":"" Regex {'3' position: '1' startPosition. tokens at: '1' value put: '3'. nil};

Regex: RegexTerm {'1'}
	| Regex ""|"" Regex {'1' | '3'}
	| Regex RegexTerm {'1' , '2'};

RegexTerm:	<character> {SmaCCCharacterRENode characters: '1' value}
	| <anycharacter> {SmaCCCharacterRENode characters: self allCharacters}
	| <backslashcharacter> {self nodeFor: (ReadStream on: ('1' value copyFrom: 2 to: '1' value size))} 
	| ""("" Regex "")"" {'2'}
	| <characterblock> {SmaCCCharacterRENode characters: (self parseCharacterBlock: '1')}
	| <tokenname> {(tokens at: '1' value) copy}
	| RegexTerm ""*""	{'1' repeat}
	| RegexTerm ""+"" {'1' repeatForAtLeast: 1}
	| RegexTerm ""?"" {'1' repeatFor: 0 to: 1}
	| RegexTerm <repeat> {| readStream start stop | 
					readStream := ReadStream on: ('2' value copyFrom: 2 to: '2' value size - 1). 
					start := readStream upTo: $,. 
					stop := readStream upToEnd.
					'1' repeatFor: (start isEmpty ifTrue: [0] ifFalse: [start asNumber]) to: (stop isEmpty ifTrue: [(1 bitShift: 31)] ifFalse: [stop asNumber])} ;"!

scannerClass
	^SmaCCScannerScanner!

startingStateForFile
	^1! !
!SmaCCScannerParser class categoriesFor: #parserDefinitionComment!generated-comments!public! !
!SmaCCScannerParser class categoriesFor: #scannerClass!generated-accessing!public! !
!SmaCCScannerParser class categoriesFor: #startingStateForFile!generated-starting states!public! !

