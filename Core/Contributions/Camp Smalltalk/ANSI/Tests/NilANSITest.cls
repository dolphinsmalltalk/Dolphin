"Filed out from Dolphin Smalltalk 7"!

MainTestCase subclass: #NilANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
NilANSITest guid: (GUID fromString: '{83421a20-4acd-4ba3-be38-71b4ed2a0d87}')!
NilANSITest comment: ''!
!NilANSITest categoriesForClass!Unclassified! !
!NilANSITest methodsFor!

canonicalObject
	^nil!

protocol
	^#'nil'!

testXprintString
	" <nil>#printString "
	#'Fundamental'.
	self value: [nil printString] should: [:r | r = 'nil']
		conformTo: #'nil' selector: #'printString'.! !
!NilANSITest categoriesFor: #canonicalObject!public! !
!NilANSITest categoriesFor: #protocol!public! !
!NilANSITest categoriesFor: #testXprintString!public! !

