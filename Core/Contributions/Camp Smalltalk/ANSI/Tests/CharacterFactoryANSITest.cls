"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #CharacterFactoryANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CharacterFactoryANSITest guid: (GUID fromString: '{64cb7eb5-008f-4c01-a8a3-e8c042e3c30d}')!
CharacterFactoryANSITest comment: ''!
!CharacterFactoryANSITest categoriesForClass!Unclassified! !
!CharacterFactoryANSITest methodsFor!

canonicalObject
	^Character!

protocol
	^#'Character factory'!

testXcodePointX
	" <Character factory>#codePoint: "
	#'Fundamental'.
	self value: [Character codePoint: ($a codePoint)] should: [:r | r = $a]
		conformTo: #'Character factory' selector: #'codePoint:'.

	self value: [Character codePoint: 16r10FFFF+1] shouldRaise: Error.!

testXcr
	" <Character factory>#cr "
	#'Fundamental'.
	self value: [Character cr]
		should: [:r | true "implementation defined "]
		conformTo: #'Character factory' selector: #'cr'.!

testXlf
	" <Character factory>#lf "
	#'Fundamental'.
	self value: [Character lf]
		should: [:r | true "implementation defined "]
		conformTo: #'Character factory' selector: #'lf'.!

testXspace
	" <Character factory>#space "
	#'Fundamental'.
	self value: [Character space]
		should: [:r | true "implementation defined "]
		conformTo: #'Character factory' selector: #'space'.!

testXtab
	" <Character factory>#tab "
	#'Fundamental'.
	self value: [Character tab]
		should: [:r | true "implementation defined "]
		conformTo: #'Character factory' selector: #'tab'.! !
!CharacterFactoryANSITest categoriesForMethods!
canonicalObject!public! !
protocol!public! !
testXcodePointX!public! !
testXcr!public! !
testXlf!public! !
testXspace!public! !
testXtab!public! !
!

