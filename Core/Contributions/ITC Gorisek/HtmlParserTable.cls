"Filed out from Dolphin Smalltalk X6.2"!

HtmlParserElement subclass: #HtmlParserTable
	instanceVariableNames: 'rows parseImage collectedString colIndex rowIndex'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlParserTable guid: (GUID fromString: '{1EEC22E0-AC6B-4A13-9CB4-A190CDEAD611}')!
HtmlParserTable comment: ''!
!HtmlParserTable categoriesForClass!Unclassified! !
!HtmlParserTable methodsFor!

cellAtRow: rowIdx col: colIdx 
	| row |
	[rows size >= rowIdx] whileFalse: [rows add: OrderedCollection new].
	row := rows at: rowIdx.
	[row size >= colIdx] whileFalse: [row add: OrderedCollection new].
	^row at: colIdx!

findFirstRowWithCellContainingString: aString 
	| result |
	self numberOfRows = 0 ifTrue: [^nil].
	1 to: self numberOfRows
		do: 
			[:rowIdx | 
			(self rowAt: rowIdx) do: 
					[:eachCell | 
					eachCell do: 
							[:eachElement | 
							eachElement class == HtmlParserTable 
								ifTrue: 
									[(result := eachElement findFirstRowWithCellContainingString: aString) isNil ifFalse: [^result]]
								ifFalse: [eachElement = aString ifTrue: [^self rowAt: rowIdx]]]]].
	^nil!

findFirstRowWithCellMatchingString: aString 
	| result |
	self numberOfRows = 0 ifTrue: [^nil].
	1 to: self numberOfRows
		do: 
			[:rowIdx | 
			(self rowAt: rowIdx) do: 
					[:eachCell | 
					eachCell do: 
							[:eachElement | 
							eachElement class == HtmlParserTable 
								ifTrue: [(result := eachElement findFirstRowWithCellMatchingString: aString) isNil ifFalse: [^result]]
								ifFalse: [(aString match: eachElement) ifTrue: [^self rowAt: rowIdx]]]]].
	^nil!

findTableContainingString: aString 
	| result |
	self numberOfRows = 0 ifTrue: [^nil].
	1 to: self numberOfRows
		do: 
			[:rowIdx | 
			(self rowAt: rowIdx) do: 
					[:eachCell | 
					eachCell do: 
							[:eachElement | 
							eachElement isString 
								ifTrue: [(eachElement indexOfSubCollection: aString startingAt: 1) > 0 ifTrue: [^self]]]]].
	1 to: self numberOfRows
		do: 
			[:rowIdx | 
			(self rowAt: rowIdx) do: 
					[:eachCell | 
					eachCell do: 
							[:eachElement | 
							eachElement class == HtmlParserTable 
								ifTrue: [(result := eachElement findTableContainingString: aString) isNil ifFalse: [^result]]]]].
	^nil!

findTableWithHeaderIncludingStrings: aCollectionOfStrings 
	| result remainingStrings |
	self numberOfRows = 0 ifTrue: [^nil].
	remainingStrings := aCollectionOfStrings asOrderedCollection copy.
	(self rowAt: 1) do: 
			[:eachCell | 
			eachCell 
				do: [:eachElement | (remainingStrings includes: eachElement) ifTrue: [remainingStrings remove: eachElement]]].
	remainingStrings isEmpty ifTrue: [^self].
	1 to: self numberOfRows
		do: 
			[:rowIdx | 
			(self rowAt: rowIdx) do: 
					[:eachCell | 
					eachCell do: 
							[:eachElement | 
							eachElement class == HtmlParserTable 
								ifTrue: 
									[(result := eachElement findTableWithHeaderIncludingStrings: aCollectionOfStrings) isNil 
										ifFalse: [^result]]]]].
	^nil!

findTableWithRowIncludingStrings: aCollectionOfStrings 
	"metoda je podobna metodi #findTableWithHeaderIncludingStrings:aCollectionOfStrings, vendar za razliko ne gleda samo 1. vrstice, ampak vse"

	| result remainingStrings |
	self numberOfRows = 0 ifTrue: [^nil].
	1 to: self numberOfRows
		do: 
			[:rowIdx | 
			remainingStrings := aCollectionOfStrings asOrderedCollection copy.
			(self rowAt: rowIdx) do: 
					[:eachCell | 
					eachCell 
						do: [:eachElement | (remainingStrings includes: eachElement) ifTrue: [remainingStrings remove: eachElement]]].
			remainingStrings isEmpty ifTrue: [^self]].
	1 to: self numberOfRows
		do: 
			[:rowIdx | 
			(self rowAt: rowIdx) do: 
					[:eachCell | 
					eachCell do: 
							[:eachElement | 
							eachElement class == HtmlParserTable 
								ifTrue: 
									[(result := eachElement findTableWithRowIncludingStrings: aCollectionOfStrings) isNil 
										ifFalse: [^result]]]]].
	^nil!

numberOfRows
	^rows size!

parseFrom: htmlParserStream 
	| token |
	colIndex := 1.
	rowIndex := 1.
	rows := OrderedCollection new.
	token := htmlParserStream nextToken.
	[token isNil] whileFalse: 
			[token := (token isString 
						ifTrue: 
							[collectedString := collectedString add: token withDelimiter: ' '.
							true]
						ifFalse: [(self parseToken: token from: htmlParserStream) notNil]) 
							ifTrue: [htmlParserStream nextToken]].
	collectedString isNilOrEmpty 
		ifFalse: [(self cellAtRow: rowIndex col: colIndex) add: collectedString]!

parseToken: token from: htmlParserStream 
	| tagName token2 |
	tagName := token first.
	tagName = 'IMG' 
		ifTrue: 
			[collectedString isNilOrEmpty 
				ifFalse: [(self cellAtRow: rowIndex col: colIndex) add: collectedString].
			collectedString := nil.
			(self cellAtRow: rowIndex col: colIndex) 
				add: (HtmlParserImage new parseFrom: (token at: 2)).
			^self].
	tagName = 'TABLE' 
		ifTrue: 
			[token last = false 
				ifTrue: 
					["start tag"
					collectedString isNilOrEmpty 
						ifFalse: [(self cellAtRow: rowIndex col: colIndex) add: collectedString].
					collectedString := nil.
					(self cellAtRow: rowIndex col: colIndex) 
						add: (HtmlParserTable new parseFrom: htmlParserStream).
					^self]
				ifFalse: 
					["end tag"
					^nil]].
	tagName = 'SELECT' 
		ifTrue: 
			[
			[token2 := htmlParserStream nextToken.
			token2 isNil ifTrue: [^nil].
			token2 first = 'SELECT' and: [token2 last = true]] 
					whileFalse: [].
			^self].
	((tagName = 'TH' or: [tagName = 'TD']) and: [token last = true]) 
		ifTrue: 
			[collectedString isNilOrEmpty 
				ifFalse: 
					[(self cellAtRow: rowIndex col: colIndex) add: collectedString.
					collectedString := nil].
			colIndex := colIndex + 1.
			^self].
	(tagName = 'TR' and: [token last = true]) 
		ifTrue: 
			[collectedString isNilOrEmpty 
				ifFalse: 
					[(self cellAtRow: rowIndex col: colIndex) add: collectedString.
					collectedString := nil].
			colIndex := 1.
			rowIndex := rowIndex + 1.
			^self].
	tagName = 'BR' ifTrue: [collectedString := collectedString asWebString , '
']!

plainTextContents
	| ws |
	ws := WriteStream on: String new.
	self plainTextContentsOn: ws.
	^ws contents!

plainTextContentsOn: aStream 
	rows do: 
			[:eachRow | 
			aStream cr.
			eachRow do: 
					[:eachCell | 
					eachCell do: 
							[:eachElement | 
							eachElement isString 
								ifTrue: [aStream nextPutAll: eachElement]
								ifFalse: [eachElement plainTextContentsOn: aStream].
							aStream space]]].
	aStream cr!

printOn: aStream 
	aStream nextPutAll: 'TABLE:['.
	rows doWithIndex: 
			[:each :rowIdx | 
			aStream cr.
			each doWithIndex: 
					[:eachCell :cellIdx | 
					aStream nextPutAll: ' ' , rowIdx printString , ',' , cellIdx printString , '['.
					eachCell do: 
							[:eachElement | 
							eachElement printOn: aStream.
							aStream space].
					aStream nextPut: $]]].
	aStream
		cr;
		nextPutAll: '*>>>]'!

rowAt: rowIdx 
	^rows at: rowIdx!

rows
	^rows!

stringAtRow: rwIndex col: columnIndex 
	| cell |
	cell := self cellAtRow: rwIndex col: columnIndex.
	^(cell size >= 1 and: [cell first isString]) ifTrue: [cell first] ifFalse: ['']!

tableAtRow: rowIdx col: columnIndex 
	| cell |
	cell := self cellAtRow: rowIdx col: columnIndex.
	^(cell size >= 1 and: [cell first class == HtmlParserTable]) ifTrue: [cell first]! !
!HtmlParserTable categoriesFor: #cellAtRow:col:!public! !
!HtmlParserTable categoriesFor: #findFirstRowWithCellContainingString:!public! !
!HtmlParserTable categoriesFor: #findFirstRowWithCellMatchingString:!public! !
!HtmlParserTable categoriesFor: #findTableContainingString:!public! !
!HtmlParserTable categoriesFor: #findTableWithHeaderIncludingStrings:!public! !
!HtmlParserTable categoriesFor: #findTableWithRowIncludingStrings:!public! !
!HtmlParserTable categoriesFor: #numberOfRows!public! !
!HtmlParserTable categoriesFor: #parseFrom:!private! !
!HtmlParserTable categoriesFor: #parseToken:from:!private! !
!HtmlParserTable categoriesFor: #plainTextContents!public! !
!HtmlParserTable categoriesFor: #plainTextContentsOn:!public! !
!HtmlParserTable categoriesFor: #printOn:!public! !
!HtmlParserTable categoriesFor: #rowAt:!public! !
!HtmlParserTable categoriesFor: #rows!public! !
!HtmlParserTable categoriesFor: #stringAtRow:col:!public! !
!HtmlParserTable categoriesFor: #tableAtRow:col:!public! !

