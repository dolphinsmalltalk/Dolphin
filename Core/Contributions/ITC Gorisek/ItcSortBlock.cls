"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #ItcSortBlock
	instanceVariableNames: 'sortSelectors'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ItcSortBlock guid: (GUID fromString: '{44C30491-9056-4142-870D-0F48F98F023B}')!
ItcSortBlock comment: ''!
!ItcSortBlock categoriesForClass!Unclassified! !
!ItcSortBlock methodsFor!

addAscending: aSelectorOrBlock 
	self addLast: aSelectorOrBlock -> true!

addDescending: aSelectorOrBlock 
	self addLast: aSelectorOrBlock -> false!

addFirst: aSelectorSortAssoc 
	self sortSelectors addFirst: aSelectorSortAssoc!

addLast: aSelectorSortAssoc 
	self sortSelectors addLast: aSelectorSortAssoc!

compare: a with: b using: eachSelector 
	"If 'a' is less then 'b' return <true>, if 'a' greater then 'b' return <false>, if equal return <nil>."

	| aValue bValue |
	a isNil 
		ifTrue: 
			["If booth are <nil> return <nil>, if equal return <true>"
			^b isNil ifFalse: [true]].
	b isNil 
		ifTrue: 
			["'a' is not less or equal"
			^false].
	eachSelector isBlockClosure 
		ifTrue: 
			[aValue := eachSelector value: a.
			bValue := eachSelector value: b]
		ifFalse: 
			[aValue := a perform: eachSelector.
			bValue := b perform: eachSelector].
	aValue isNil ifTrue: [^bValue isNil ifFalse: [true]].
	bValue isNil ifTrue: [^false].
	aValue = bValue ifTrue: [^nil].
	^aValue isString ifTrue: [aValue isAlphabeticalyBefore: bValue] ifFalse: [aValue < bValue]!

compare: a with: b using: eachSelector ascending: ascendingBool 
	^ascendingBool = false 
		ifFalse: 
			[self 
				compare: a
				with: b
				using: eachSelector]
		ifTrue: 
			[self 
				compare: b
				with: a
				using: eachSelector]!

invertAscendingDescending
	sortSelectors first value: sortSelectors first value ~= true!

invertAscendingDescendingFor: aSelector 
	| criteria |
	criteria := sortSelectors detect: [:each | each key = aSelector] ifNone: [^self].
	criteria value: criteria value ~= true!

invertAscendingDescendingForIndex: criteriaIndex 
	| criteria |
	criteria := sortSelectors at: criteriaIndex.
	criteria value: criteria value ~= true!

sortSelectors
	sortSelectors isNil ifTrue: [sortSelectors := OrderedCollection new].
	^sortSelectors!

value: a value: b 
	"Compare 'a' to 'b' using all sorting criteria available."

	| result |
	sortSelectors do: 
			[:eachCriteria | 
			result := self 
						compare: a
						with: b
						using: eachCriteria key
						ascending: eachCriteria value.
			"if found return result"
			result notNil ifTrue: [^result]
			"else compare by another criteria"].
	"if nothing found return <false>"
	^false!

with: aSelector1 
	sortSelectors := OrderedCollection with: aSelector1 -> true!

with: aSelector1 with: aSelector2 
	sortSelectors := OrderedCollection with: aSelector1 -> true with: aSelector2 -> true!

with: aSelector1 with: aSelector2 with: aSelector3 
	sortSelectors := OrderedCollection 
				with: aSelector1 -> true
				with: aSelector2 -> true
				with: aSelector3 -> true!

with: aSymbol1 with: aSymbol2 with: aSymbol3 with: aSymbol4 
	sortSelectors := OrderedCollection 
				with: aSymbol1 -> true
				with: aSymbol2 -> true
				with: aSymbol3 -> true
				with: aSymbol4 -> true! !
!ItcSortBlock categoriesFor: #addAscending:!public! !
!ItcSortBlock categoriesFor: #addDescending:!public! !
!ItcSortBlock categoriesFor: #addFirst:!public! !
!ItcSortBlock categoriesFor: #addLast:!public! !
!ItcSortBlock categoriesFor: #compare:with:using:!private! !
!ItcSortBlock categoriesFor: #compare:with:using:ascending:!private! !
!ItcSortBlock categoriesFor: #invertAscendingDescending!public! !
!ItcSortBlock categoriesFor: #invertAscendingDescendingFor:!public! !
!ItcSortBlock categoriesFor: #invertAscendingDescendingForIndex:!public! !
!ItcSortBlock categoriesFor: #sortSelectors!public! !
!ItcSortBlock categoriesFor: #value:value:!public! !
!ItcSortBlock categoriesFor: #with:!public! !
!ItcSortBlock categoriesFor: #with:with:!public! !
!ItcSortBlock categoriesFor: #with:with:with:!public! !
!ItcSortBlock categoriesFor: #with:with:with:with:!public! !

!ItcSortBlock class methodsFor!

with: aSymbol1 
	^self new with: aSymbol1!

with: aSymbol1 with: aSymbol2 
	^self new with: aSymbol1 with: aSymbol2!

with: aSymbol1 with: aSymbol2 with: aSymbol3 
	^self new 
		with: aSymbol1
		with: aSymbol2
		with: aSymbol3!

with: aSymbol1 with: aSymbol2 with: aSymbol3 with: aSymbol4 
	^self new 
		with: aSymbol1
		with: aSymbol2
		with: aSymbol3
		with: aSymbol4! !
!ItcSortBlock class categoriesFor: #with:!public! !
!ItcSortBlock class categoriesFor: #with:with:!public! !
!ItcSortBlock class categoriesFor: #with:with:with:!public! !
!ItcSortBlock class categoriesFor: #with:with:with:with:!public! !

