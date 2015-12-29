"Filed out from Dolphin Smalltalk XP"!

Object subclass: #SmaCCLR1Item
	instanceVariableNames: 'rhs symbol location followers'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCLR1Item guid: (GUID fromString: '{36786A1D-F638-4245-AD58-ACA499B96B04}')!
SmaCCLR1Item comment: 'SmaCCLR1Item represents an item in a SmaCCItemSet.

Instance Variables:
	followers	<SmaCCSymbolSet>	all possible symbols that can follow this production in this state
	location	<Integer>	the position in the rhs of the production we are at
	rhs	<SmaCCRHS>	the rhs of the production
	symbol	<SmaCCSymbol>	the symbol for the production'!
!SmaCCLR1Item categoriesForClass!SmaCC Runtime! !
!SmaCCLR1Item methodsFor!

= anItem 
	^self class == anItem class and: 
			[location == anItem location 
				and: [rhs == anItem rhs and: [symbol == anItem symbol]]]!

action: aGrammarSymbol 
	location > rhs size 
		ifTrue: 
			[(symbol isStartingSymbol and: [aGrammarSymbol isEmptySymbol]) 
				ifTrue: [^SmaCCAcceptAction new].
			(followers includes: aGrammarSymbol) 
				ifTrue: [^SmaCCReduceAction symbol: symbol rhs: rhs]]
		ifFalse: [(rhs at: location) = aGrammarSymbol ifTrue: [^SmaCCShiftAction new]].
	^SmaCCRejectAction new!

followers
	^followers!

followers: aSymbolSet 
	followers := aSymbolSet!

hash
	^(symbol identityHash bitXor: (location bitShift: 14)) 
		bitXor: rhs identityHash!

isLR1EqualTo: aLRItem 
	^self followers size = aLRItem followers size 
		and: [self followers allSatisfy: [:each | aLRItem followers includes: each]]!

location
	^location!

location: anInteger 
	location := anInteger!

mergeWith: aLRItem 
	followers mergeWith: aLRItem followers!

moveNext
	^(self copy)
		followers: (followers class basedOn: followers);
		location: location + 1;
		yourself!

nextSymbol
	^location > rhs size 
		ifTrue: [SmaCCSymbol sentinel]
		ifFalse: [rhs at: location]!

precedence
	"If we don't have a precedence, then assume we are the lowest precedence (which will cause a shift action)."

	| max |
	max := -1.
	rhs do: [:each | max := max max: (each precedence ifNil: [max])].
	^max!

printOn: aStream 
	| i |
	aStream
		nextPut: $[;
		nextPutAll: symbol printString;
		nextPutAll: ' :'.
	i := 1.
	rhs do: 
			[:each | 
			i = location ifTrue: [aStream nextPutAll: ' . '].
			aStream
				space;
				nextPutAll: each printString.
			i := i + 1].
	location > rhs size ifTrue: [aStream nextPutAll: ' . '].
	aStream nextPut: $;.
	followers printOn: aStream.
	aStream nextPut: $]!

rest
	| newRHS |
	newRHS := SmaCCRHS new.
	location + 1 to: rhs size do: [:each | newRHS add: (rhs at: each)].
	^newRHS!

rhs
	^rhs!

symbol
	^symbol!

symbol: productionGrammarSymbol rhs: aRHS follow: aSymbolCollection 
	symbol := productionGrammarSymbol.
	rhs := aRHS.
	location := 1.
	followers := aSymbolCollection! !
!SmaCCLR1Item categoriesFor: #=!comparing!public! !
!SmaCCLR1Item categoriesFor: #action:!accessing!public! !
!SmaCCLR1Item categoriesFor: #followers!accessing!public! !
!SmaCCLR1Item categoriesFor: #followers:!initialize-release!public! !
!SmaCCLR1Item categoriesFor: #hash!comparing!public! !
!SmaCCLR1Item categoriesFor: #isLR1EqualTo:!public!testing! !
!SmaCCLR1Item categoriesFor: #location!private! !
!SmaCCLR1Item categoriesFor: #location:!initialize-release!public! !
!SmaCCLR1Item categoriesFor: #mergeWith:!accessing!public! !
!SmaCCLR1Item categoriesFor: #moveNext!accessing!public! !
!SmaCCLR1Item categoriesFor: #nextSymbol!accessing!public! !
!SmaCCLR1Item categoriesFor: #precedence!accessing!public! !
!SmaCCLR1Item categoriesFor: #printOn:!printing!public! !
!SmaCCLR1Item categoriesFor: #rest!accessing!public! !
!SmaCCLR1Item categoriesFor: #rhs!private! !
!SmaCCLR1Item categoriesFor: #symbol!private! !
!SmaCCLR1Item categoriesFor: #symbol:rhs:follow:!initialize-release!public! !

!SmaCCLR1Item class methodsFor!

symbol: productionGrammarSymbol rhs: aRHS follow: aGrammarSymbolCollection 
	^(self new)
		symbol: productionGrammarSymbol
			rhs: aRHS
			follow: aGrammarSymbolCollection;
		yourself! !
!SmaCCLR1Item class categoriesFor: #symbol:rhs:follow:!instance creation!public! !

