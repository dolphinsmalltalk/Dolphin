"Filed out from Dolphin Smalltalk"!

SequencedReadableCollectionTest subclass: #ByteArrayANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ByteArrayANSITest guid: (GUID fromString: '{43131ce9-7dec-461f-bf8c-be28f0977145}')!
ByteArrayANSITest comment: ''!
!ByteArrayANSITest categoriesForClass!Unclassified! !
!ByteArrayANSITest methodsFor!

canonicalElement

	^self canonicalObject at: 2!

canonicalObject
	^ByteArray with: 1 with: 2 with: 3 with: 4!

conformanceOfPutElementOnXatAllPutX: aString
	self 
		should: [ self canonicalObject atAllPut: aString]
		raise: TestResult error!

conformanceOfPutElementOnXatAllXputX: aString
	self 
		should: [ self canonicalObject atAll: #(1 2) put: aString]
		raise: TestResult error!

conformanceOfPutElementOnXatXputX: aString
	self 
		should: [ self canonicalObject at: 1 put: aString]
		raise: TestResult error!

emptyCollection

	^self canonicalObject class new!

protocol
	^#'ByteArray'! !
!ByteArrayANSITest categoriesForMethods!
canonicalElement!public! !
canonicalObject!public! !
conformanceOfPutElementOnXatAllPutX:!public! !
conformanceOfPutElementOnXatAllXputX:!public! !
conformanceOfPutElementOnXatXputX:!public! !
emptyCollection!public! !
protocol!public! !
!

!ByteArrayANSITest class methodsFor!

helperClassesDo: aBlock
	super helperClassesDo: aBlock.
	aBlock value: SequencedCollectionHelper.
	aBlock value: SequencedReadableCollectionHelper! !
!ByteArrayANSITest class categoriesForMethods!
helperClassesDo:!public! !
!

