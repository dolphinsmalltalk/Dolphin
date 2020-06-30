"Filed out from Dolphin Smalltalk 7"!

MainTestCase subclass: #IdentityDictionaryFactoryANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IdentityDictionaryFactoryANSITest guid: (GUID fromString: '{94d00b2f-5833-4101-92e3-01600879ef05}')!
IdentityDictionaryFactoryANSITest comment: ''!
!IdentityDictionaryFactoryANSITest categoriesForClass!Unclassified! !
!IdentityDictionaryFactoryANSITest methodsFor!

canonicalObject
	^IdentityDictionary!

protocol
	^#'IdentityDictionary factory'!

testXnew
	" <IdentityDictionary factory>#new "
	#'Collection'.!

testXnewX
	" <IdentityDictionary factory>#new: "
	#'Collection'.!

testXwithAllX
	" <IdentityDictionary factory>#withAll: "
	#'Collection'.! !
!IdentityDictionaryFactoryANSITest categoriesFor: #canonicalObject!public! !
!IdentityDictionaryFactoryANSITest categoriesFor: #protocol!public! !
!IdentityDictionaryFactoryANSITest categoriesFor: #testXnew!public! !
!IdentityDictionaryFactoryANSITest categoriesFor: #testXnewX!public! !
!IdentityDictionaryFactoryANSITest categoriesFor: #testXwithAllX!public! !

