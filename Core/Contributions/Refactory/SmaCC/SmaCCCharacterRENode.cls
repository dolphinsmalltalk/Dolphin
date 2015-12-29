"Filed out from Dolphin Smalltalk XP"!

SmaCCRegularExpressionNode subclass: #SmaCCCharacterRENode
	instanceVariableNames: 'characters'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCCharacterRENode guid: (GUID fromString: '{A8E6F156-E3F8-49D6-9909-25963D9DA21F}')!
SmaCCCharacterRENode comment: 'SmaCCCharacterRENode represents a regular expression that matches one of a set of characters.

Instance Variables:
	characters	<SortedCollection of: Character>	The characters that this node can accept. Note that there are no duplicates and all characters are sorted.

'!
!SmaCCCharacterRENode categoriesForClass!SmaCC Runtime! !
!SmaCCCharacterRENode methodsFor!

| aScannerNode 
	(self canMergeWith: aScannerNode) ifFalse: [^super | aScannerNode].
	characters := String 
				withAll: ((characters , aScannerNode characters) asSet 
						asSortedCollection: [:a :b | a asInteger < b asInteger]).
	^self!

asNFAStartingWith: startNode 
	| endNode |
	endNode := SmaCCNode new.
	endNode action: action.
	startNode addEdgeTo: endNode on: characters.
	^endNode!

canMergeWith: aScannerNode 
	^self class = aScannerNode class and: 
			[characters notNil 
				and: [aScannerNode characters notNil and: [self action = aScannerNode action]]]!

characters
	^characters!

characters: aString 
	characters := aString!

matchingCharacters
	^SmaCCGrammar ignoreCase 
		ifTrue: [characters reject: [:each | each isLowercase]]
		ifFalse: [characters]!

possibleMatchesDo: aBlock on: aStream 
	self matchingCharacters do: 
			[:each | 
			aStream nextPut: each.
			aBlock value.
			aStream skip: -1]!

possibleMatchesSize
	^self matchingCharacters size!

printCharacter: aCharacter on: aStream
	(aCharacter asInteger between: 32 and: 126) ifTrue: [^aStream nextPut: aCharacter].
	aStream nextPutAll: '\x'.
	aCharacter asInteger 
		printOn: aStream
		base: 16
		showRadix: false!

printOn: aStream 
	| allCharacters |
	characters size = 1 
		ifTrue: [^self printCharacter: characters first on: aStream].
	aStream nextPut: $[.
	allCharacters := characters.
	characters size > 128 
		ifTrue: 
			[aStream nextPut: $^.
			allCharacters := ((0 to: SmaCCGrammar maximumCharacterValue) 
						collect: [:each | Character value: each]) 
							reject: [:each | characters includes: each]].
	allCharacters do: [:each | self printCharacter: each on: aStream].
	aStream nextPut: $]! !
!SmaCCCharacterRENode categoriesFor: #|!accessing!public! !
!SmaCCCharacterRENode categoriesFor: #asNFAStartingWith:!private! !
!SmaCCCharacterRENode categoriesFor: #canMergeWith:!public!testing! !
!SmaCCCharacterRENode categoriesFor: #characters!private! !
!SmaCCCharacterRENode categoriesFor: #characters:!initialize-release!public! !
!SmaCCCharacterRENode categoriesFor: #matchingCharacters!private! !
!SmaCCCharacterRENode categoriesFor: #possibleMatchesDo:on:!private! !
!SmaCCCharacterRENode categoriesFor: #possibleMatchesSize!accessing!public! !
!SmaCCCharacterRENode categoriesFor: #printCharacter:on:!printing!public! !
!SmaCCCharacterRENode categoriesFor: #printOn:!printing!public! !

!SmaCCCharacterRENode class methodsFor!

characters: aString 
	^(self new)
		characters: (self sortedCharactersFor: aString);
		yourself!

sortedCharactersFor: aString 
	| characters stream |
	SmaCCGrammar ignoreCase 
		ifTrue: 
			[stream := WriteStream on: String new.
			aString do: 
					[:each | 
					stream
						nextPut: each asUppercase;
						nextPut: each asLowercase]]
		ifFalse: 
			[stream := WriteStream on: (String new: aString size).
			stream nextPutAll: aString].
	characters := stream contents 
				asSortedCollection: [:a :b | a asInteger < b asInteger].
	stream := WriteStream on: String new.
	characters inject: nil
		into: 
			[:sum :each | 
			sum = each ifFalse: [stream nextPut: each].
			each].
	^stream contents! !
!SmaCCCharacterRENode class categoriesFor: #characters:!instance creation!public! !
!SmaCCCharacterRENode class categoriesFor: #sortedCharactersFor:!private! !

