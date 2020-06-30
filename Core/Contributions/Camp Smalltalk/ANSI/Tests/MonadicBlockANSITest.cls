"Filed out from Dolphin Smalltalk 7"!

MainTestCase subclass: #MonadicBlockANSITest
	instanceVariableNames: 'blk1args'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
MonadicBlockANSITest guid: (GUID fromString: '{13d65db6-1141-4cc4-adc4-90b57ad5ff87}')!
MonadicBlockANSITest comment: ''!
!MonadicBlockANSITest categoriesForClass!Unclassified! !
!MonadicBlockANSITest methodsFor!

canonicalObject
	^blk1args!

protocol
	^#'monadicBlock'!

setUp
	super setUp.
	blk1args := [ :arg1 | Array with: arg1 ].!

testXargumentCount
	" <monadicValuable>#argumentCount "
	#'Valuable'.
	self value: [blk1args argumentCount] should: [:r | r = 1]
		conformTo: #'monadicValuable' selector: #'argumentCount'.!

testXvalueWithArgumentsX
	" <valuable>#valueWithArguments: "
	#'Valuable'.
	self value: [blk1args valueWithArguments: #(1)]
		should: [:r | r = #(1)]
		conformTo: #'valuable' selector: #'valueWithArguments:'.!

testXvalueX
	" <monadicValuable>#value: "
	#'Valuable'.
	self value: [blk1args value: 1] should: [:r | r = #(1)]
		conformTo: #'monadicValuable' selector: #'value:'.! !
!MonadicBlockANSITest categoriesFor: #canonicalObject!public! !
!MonadicBlockANSITest categoriesFor: #protocol!public! !
!MonadicBlockANSITest categoriesFor: #setUp!public! !
!MonadicBlockANSITest categoriesFor: #testXargumentCount!public! !
!MonadicBlockANSITest categoriesFor: #testXvalueWithArgumentsX!public! !
!MonadicBlockANSITest categoriesFor: #testXvalueX!public! !

