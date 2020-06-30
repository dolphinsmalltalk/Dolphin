"Filed out from Dolphin Smalltalk 7"!

MainTestCase subclass: #DyadicValuableANSITest
	instanceVariableNames: 'blk2args'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DyadicValuableANSITest guid: (GUID fromString: '{8642c804-43a8-499e-86f1-1dc596623319}')!
DyadicValuableANSITest comment: ''!
!DyadicValuableANSITest categoriesForClass!Unclassified! !
!DyadicValuableANSITest methodsFor!

canonicalObject
	^blk2args!

protocol
	^#'dyadicValuable'!

setUp
	super setUp.
	blk2args := [ :arg1 :arg2 | Array with: arg1 with: arg2 ].!

testXargumentCount
	" <dyadicValuable>#argumentCount "
	#'Valuable'.
	self value: [blk2args argumentCount] should: [:r | r = 2]
		conformTo: #'dyadicValuable' selector: #'argumentCount'.!

testXvalueWithArgumentsX
	" <valuable>#valueWithArguments: "
	#'Valuable'.
	self value: [blk2args valueWithArguments: #(1 2)]
		should: [:r | r = #(1 2)]
		conformTo: #'valuable' selector: #'valueWithArguments:'.!

testXvalueXvalueX
	" <dyadicValuable>#value:value: "
	#'Valuable'.
	self value: [blk2args value: 1 value: 2] should: [:r | r = #(1 2)]
		conformTo: #'dyadicValuable' selector: #'value:value:'.! !
!DyadicValuableANSITest categoriesFor: #canonicalObject!public! !
!DyadicValuableANSITest categoriesFor: #protocol!public! !
!DyadicValuableANSITest categoriesFor: #setUp!public! !
!DyadicValuableANSITest categoriesFor: #testXargumentCount!public! !
!DyadicValuableANSITest categoriesFor: #testXvalueWithArgumentsX!public! !
!DyadicValuableANSITest categoriesFor: #testXvalueXvalueX!public! !

