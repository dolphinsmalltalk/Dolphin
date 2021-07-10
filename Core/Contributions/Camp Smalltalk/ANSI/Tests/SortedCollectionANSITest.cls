"Filed out from Dolphin Smalltalk"!

SequencedReadableCollectionTest subclass: #SortedCollectionANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SortedCollectionANSITest guid: (GUID fromString: '{3ea31051-f64e-43f6-b7f3-71c10e7e803c}')!
SortedCollectionANSITest comment: ''!
!SortedCollectionANSITest categoriesForClass!Unclassified! !
!SortedCollectionANSITest methodsFor!

canonicalElement

	^self canonicalObject at: 2!

canonicalObject
	^SortedCollection with: 1 with: 2 with: 3 with: 4!

emptyCollection

	^self canonicalObject class new!

protocol
	^#SortedCollection!

testXaddAllX
	" Not found in spec; but SortedCollection needs to refine it."

	| cos |
	cos := self canonicalObjects.
	self 
		value: 
			[(cos at: #d)
				addAll: (cos at: #abc);
				yourself]
		should: [:r | r = (cos at: #abcd)]
		conformTo: #SortedCollection
		selector: #addAll:!

testXaddX
	" <SortedCollection>#add: "
	| cos |
	cos := self canonicalObjects.
	self
		value: [(cos at: #bcd) add: ((cos at: #a) at: 1); yourself]
		should: [:r | r = (cos at: #abcd)]
		conformTo: #SortedCollection
		selector: #add:!

testXasSortedCollection
	" <SortedCollection>#asSortedCollection "
	#'Collection'.!

testXcollectX
	" <SortedCollection>#collect: "
	#'Collection'.!

testXcomma
	" <SortedCollection>#, "
	#'Collection'.!

testXconcatenateOp
	| cos |
	cos := self canonicalObjects.
	self 
		value: [(cos at: #d) , (cos at: #abc)]
		should: [:r | r = (cos at: #abcd)]
		conformTo: #SortedCollection
		selector: #,!

testXcopyReplaceAllXwithX
	" <SortedCollection>#copyReplaceAll:with: "
	#'Collection'.!

testXcopyReplaceFromXtoXwithObjectX
	" <SortedCollection>#copyReplaceFrom:to:withObject: "
	#'Collection'.!

testXcopyReplaceFromXtoXwithX
	" <SortedCollection>#copyReplaceFrom:to:with: "
	#'Collection'.!

testXcopyReplacingXwithObjectX
	" <SortedCollection>#copyReplacing:withObject: "
	#'Collection'.!

testXreverse
	" <SortedCollection>#reverse "
	#'Collection'.!

testXsortBlock
	" <SortedCollection>#sortBlock "
"	self halt assertSend: #sortBlock"
	self
		value: [self canonicalObject sortBlock]
		should: [:result | true]
		conformTo: #SortedCollection
		selector: #sortBlock!

testXsortBlockX
	" <SortedCollection>#sortBlock: "
	| co |
	co := self canonicalObject.
	self
		value: [co sortBlock:[:a :b | a > b]]
		should: [:r | co first = 4]
		conformTo: #SortedCollection
		selector: #sortBlock:! !
!SortedCollectionANSITest categoriesForMethods!
canonicalElement!public! !
canonicalObject!public! !
emptyCollection!public! !
protocol!public! !
testXaddAllX!public! !
testXaddX!public! !
testXasSortedCollection!public! !
testXcollectX!public! !
testXcomma!public! !
testXconcatenateOp!public! !
testXcopyReplaceAllXwithX!public! !
testXcopyReplaceFromXtoXwithObjectX!public! !
testXcopyReplaceFromXtoXwithX!public! !
testXcopyReplacingXwithObjectX!public! !
testXreverse!public! !
testXsortBlock!public! !
testXsortBlockX!public! !
!

!SortedCollectionANSITest class methodsFor!

helperClassesDo: aBlock
	super helperClassesDo: aBlock.
	aBlock value: ExtensibleCollectionHelper.
	aBlock value: SequencedContractibleCollectionHelper.
	aBlock value: SequencedReadableCollectionHelper.! !
!SortedCollectionANSITest class categoriesForMethods!
helperClassesDo:!public! !
!

