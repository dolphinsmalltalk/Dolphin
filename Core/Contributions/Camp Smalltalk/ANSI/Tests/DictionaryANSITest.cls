"Filed out from Dolphin Smalltalk 7"!

CollectionTest subclass: #DictionaryANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DictionaryANSITest guid: (GUID fromString: '{98945f32-e6d5-4ec3-b98b-8a6806ee7a34}')!
DictionaryANSITest comment: ''!
!DictionaryANSITest categoriesForClass!Unclassified! !
!DictionaryANSITest methodsFor!

canonicalElement

	^self canonicalObject at: 2!

canonicalObject
	^Dictionary new at: 1 put: 11; at: 2 put: 22; at:3 put: 33; at:4 put: 44; yourself!

emptyCanonicalObject
	^Dictionary new!

emptyCollection

	^self canonicalObject class new!

protocol
	^#'Dictionary'!

testXaddAllX
	" <abstractDictionary>#addAll: "
	#'Collection'.!

testXatX
	" <abstractDictionary>#at: "
	#'Collection'.!

testXatXifAbsentPutX
	" <abstractDictionary>#at:ifAbsentPut: "
	#'Collection'.!

testXatXifAbsentX
	" <abstractDictionary>#at:ifAbsent: "
	#'Collection'.!

testXatXputX
	" <abstractDictionary>#at:put: "
	#'Collection'.!

testXincludesKeyX
	" <abstractDictionary>#includesKey: "
	#'Collection'.! !
!DictionaryANSITest categoriesFor: #canonicalElement!public! !
!DictionaryANSITest categoriesFor: #canonicalObject!public! !
!DictionaryANSITest categoriesFor: #emptyCanonicalObject!public! !
!DictionaryANSITest categoriesFor: #emptyCollection!public! !
!DictionaryANSITest categoriesFor: #protocol!public! !
!DictionaryANSITest categoriesFor: #testXaddAllX!public! !
!DictionaryANSITest categoriesFor: #testXatX!public! !
!DictionaryANSITest categoriesFor: #testXatXifAbsentPutX!public! !
!DictionaryANSITest categoriesFor: #testXatXifAbsentX!public! !
!DictionaryANSITest categoriesFor: #testXatXputX!public! !
!DictionaryANSITest categoriesFor: #testXincludesKeyX!public! !

!DictionaryANSITest class methodsFor!

helperClassesDo: aBlock 
	"refinements must execute before the rest of the helpers"

	aBlock value: AbstractDictionaryHelper.
	super helperClassesDo: aBlock! !
!DictionaryANSITest class categoriesFor: #helperClassesDo:!public! !

