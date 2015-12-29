"Filed out from Dolphin Smalltalk XP"!

Object subclass: #SmaCCEdge
	instanceVariableNames: 'toNode characters'
	classVariableNames: 'IsExpressions'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCEdge guid: (GUID fromString: '{BB560E2A-0186-4A5C-A98C-7468AF7E4602}')!
SmaCCEdge comment: 'SmaCCEdge represents a transition in a Finite Automata (directed graph). It is labeled with the characters (possibly none, indicating an epsilon transition) that cause the transition.

Instance Variables:
	characters	<SortedCollection of: Character>	The characters that cause the transition. Note that there are no duplicates and all characters are sorted.
	toNode	<SmaCCNode>	The node that this is transitioning to.'!
!SmaCCEdge categoriesForClass!SmaCC Runtime! !
!SmaCCEdge methodsFor!

<= anEdge 
	^self to id <= anEdge to id!

= anEdge 
	self class = anEdge class ifFalse: [^false].
	^self to = anEdge to and: [self characters = anEdge characters]!

characters
	^characters!

closestIsExpression
	"Attempts to find the #is selector that most closely matches the character set that this edge transitions on."

	| expressions closest |
	expressions := IsExpressions keys 
				select: [:each | (each reject: [:ch | self includesCharacter: ch]) isEmpty].
	expressions isEmpty ifTrue: [^nil].
	closest := IsExpressions 
				at: (expressions asSortedCollection: [:a :b | a size > b size]) first.
	(self minMaxPairsWithout: closest) size 
		<= (self minMaxPairsWithout: nil) size ifFalse: [^nil].
	^closest!

conflictsWith: anEdge 
	^characters anySatisfy: [:each | anEdge characters includes: each]!

does: aString includeCharacter: aCharacter 
	| start stop mid |
	start := 1.
	stop := aString size.
	stop = 0 ifTrue: [^false].
	
	[mid := (start + stop) // 2.
	mid == start] whileFalse: 
				[(aString at: mid) asInteger < aCharacter asInteger 
					ifTrue: [start := mid]
					ifFalse: [stop := mid]].
	^(aString at: start) == aCharacter or: [(aString at: stop) == aCharacter]!

expression
	| stream isSelector |
	stream := WriteStream on: (String new: 128).
	stream nextPut: $(.
	characters size = SmaCCGrammar maximumCharacterValue 
		ifTrue: [self outputInvertedMatchOn: stream]
		ifFalse: 
			[isSelector := self outputClosestIsMethodOn: stream.
			self outputExpressionOn: stream without: isSelector].
	stream nextPut: $).
	^stream contents!

hash
	^(self to hash bitShift: 14) bitXor: characters hash!

includesCharacter: aCharacter 
	^self does: characters includeCharacter: aCharacter!

isEmpty
	^characters isEmpty!

isEpsilonTransition
	^characters isNil!

mergeWith: anEdge 
	characters := String withAll: ((characters , anEdge characters) asSet 
						asSortedCollection: [:a :b | a asInteger < b asInteger])!

minMaxPairsWithout: aSelector 
	"Converts a list of characters into a collection of pairs representing the minimum and maximum of each sequence.
	The list is first filtered to include only those characters that fail aSelector."

	| start last pairs charsLeft |
	charsLeft := aSelector isNil 
				ifTrue: [characters]
				ifFalse: [characters reject: [:ch | ch perform: aSelector]].
	pairs := OrderedCollection new.
	charsLeft isEmpty ifTrue: [^pairs].
	last := charsLeft first.
	start := nil.
	charsLeft do: 
			[:each | 
			last asInteger + 1 = each asInteger 
				ifFalse: 
					[start notNil ifTrue: [pairs add: (Array with: start with: last)].
					start := each].
			last := each].
	pairs add: (Array with: start with: last).
	^pairs!

outputClosestIsMethodOn: stream 
	| expr |
	expr := self closestIsExpression.
	expr isNil ifFalse: [stream nextPutAll: 'currentCharacter ' , expr].
	^expr!

outputExpressionFor: aPair on: stream 
	aPair first == aPair last 
		ifTrue: [^self outputMatchSingleCharacter: aPair first on: stream].
	aPair first = (Character value: 0) 
		ifTrue: [^self outputMatchLessThan: aPair last on: stream].
	aPair last = (Character value: SmaCCGrammar maximumCharacterValue) 
		ifTrue: [^self outputMatchGreaterThan: aPair first on: stream].
	self outputMatchRange: aPair on: stream!

outputExpressionOn: aStream without: aSelector 
	| pairs |
	pairs := self minMaxPairsWithout: aSelector.
	pairs isEmpty ifTrue: [^self].
	aSelector notNil ifTrue: [aStream nextPutAll: ' or: ['].
	pairs do: [:each | self outputExpressionFor: each on: aStream]
		separatedBy: [aStream nextPutAll: ' or: ['].
	aStream next: pairs size - 1 put: $].
	aSelector notNil ifTrue: [aStream nextPut: $]]!

outputInvertedMatchOn: aStream 
	| char |
	char := Character value: ((0 to: SmaCCGrammar maximumCharacterValue) 
						detect: [:each | (characters includes: (Character value: each)) not]).
	aStream
		nextPutAll: 'currentCharacter ~~ ';
		nextPutAll: char storeString!

outputMatchGreaterThan: aCharacter on: stream 
	stream
		nextPutAll: 'currentCharacter >= ';
		nextPutAll: aCharacter storeString!

outputMatchLessThan: aCharacter on: stream 
	stream
		nextPutAll: 'currentCharacter <= ';
		nextPutAll: aCharacter storeString!

outputMatchRange: aPair on: stream 
	stream
		nextPutAll: '(currentCharacter between: ';
		nextPutAll: aPair first storeString;
		nextPutAll: ' and: ';
		nextPutAll: aPair last storeString;
		nextPutAll: ')'!

outputMatchSingleCharacter: aCharacter on: stream 
	stream
		nextPutAll: 'currentCharacter == ';
		nextPutAll: aCharacter storeString!

printOn: aStream 
	aStream
		nextPutAll: '---';
		nextPutAll: (characters ifNil: ['""']);
		nextPutAll: '--->';
		nextPutAll: toNode printString!

removeCharacters: aCollection 
	characters := characters 
				reject: [:each | self does: aCollection includeCharacter: each]!

to
	^toNode!

to: aNode on: aStringOrNil 
	toNode := aNode.
	characters := aStringOrNil! !
!SmaCCEdge categoriesFor: #<=!comparing!public! !
!SmaCCEdge categoriesFor: #=!comparing!public! !
!SmaCCEdge categoriesFor: #characters!private! !
!SmaCCEdge categoriesFor: #closestIsExpression!compiling!public! !
!SmaCCEdge categoriesFor: #conflictsWith:!public!testing! !
!SmaCCEdge categoriesFor: #does:includeCharacter:!public!testing! !
!SmaCCEdge categoriesFor: #expression!compiling!public! !
!SmaCCEdge categoriesFor: #hash!comparing!public! !
!SmaCCEdge categoriesFor: #includesCharacter:!public!testing! !
!SmaCCEdge categoriesFor: #isEmpty!public!testing! !
!SmaCCEdge categoriesFor: #isEpsilonTransition!public!testing! !
!SmaCCEdge categoriesFor: #mergeWith:!accessing!public! !
!SmaCCEdge categoriesFor: #minMaxPairsWithout:!compiling!public! !
!SmaCCEdge categoriesFor: #outputClosestIsMethodOn:!compiling!public! !
!SmaCCEdge categoriesFor: #outputExpressionFor:on:!compiling!public! !
!SmaCCEdge categoriesFor: #outputExpressionOn:without:!compiling!public! !
!SmaCCEdge categoriesFor: #outputInvertedMatchOn:!compiling!public! !
!SmaCCEdge categoriesFor: #outputMatchGreaterThan:on:!compiling!public! !
!SmaCCEdge categoriesFor: #outputMatchLessThan:on:!compiling!public! !
!SmaCCEdge categoriesFor: #outputMatchRange:on:!compiling!public! !
!SmaCCEdge categoriesFor: #outputMatchSingleCharacter:on:!compiling!public! !
!SmaCCEdge categoriesFor: #printOn:!printing!public! !
!SmaCCEdge categoriesFor: #removeCharacters:!private! !
!SmaCCEdge categoriesFor: #to!accessing!public! !
!SmaCCEdge categoriesFor: #to:on:!initialize-release!public! !

!SmaCCEdge class methodsFor!

generateCharacterSetFor: aSelector 
	| stream |
	stream := WriteStream on: String new.
	0 to: SmaCCGrammar maximumCharacterValue
		do: 
			[:i | 
			| ch |
			ch := Character value: i.
			(ch perform: aSelector) ifTrue: [stream nextPut: ch]].
	^stream contents!

initializeIsExpressions
	"Creates a map from sets of characters to selectors that start with 'is' on Character. This allows generated scanners to take
	full advantage of selectors that are already implemented on Character"

	| selectors |
	IsExpressions := Dictionary new.
	selectors := Character selectors 
				select: [:each | ('is*' match: each) and: [each argumentCount = 0 and: [(each at: 3) isUppercase]]].
	selectors do: 
			[:sel | 
			| string |
			string := self generateCharacterSetFor: sel.
			string isEmpty ifFalse: [IsExpressions at: string put: sel]]!

to: aNode on: aStringOrNil 
	| edge |
	edge := self new.
	edge to: aNode on: aStringOrNil.
	^edge! !
!SmaCCEdge class categoriesFor: #generateCharacterSetFor:!class initialization!public! !
!SmaCCEdge class categoriesFor: #initializeIsExpressions!class initialization!public! !
!SmaCCEdge class categoriesFor: #to:on:!instance creation!public! !

