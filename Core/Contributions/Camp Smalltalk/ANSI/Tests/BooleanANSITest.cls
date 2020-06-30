"Filed out from Dolphin Smalltalk 7"!

MainTestCase subclass: #BooleanANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
BooleanANSITest guid: (GUID fromString: '{99ac2aab-17ae-4622-a4d9-cbb929a4d3f0}')!
BooleanANSITest comment: ''!
!BooleanANSITest categoriesForClass!Unclassified! !
!BooleanANSITest methodsFor!

canonicalObject
	^true!

protocol
	^#boolean!

testXandOp
	" <boolean>#& "
	#'Fundamental'.
	self value: [true & true] should: [:r | r]
		conformTo: #'boolean' selector: #'&'.
	self value: [true & false] shouldnt: [:r | r]
		conformTo: #'boolean' selector: #'&'.
	self value: [false & true] shouldnt: [:r | r]
		conformTo: #'boolean' selector: #'&'.
	self value: [false & false] shouldnt: [:r | r]
		conformTo: #'boolean' selector: #'&'.!

testXandX
	" <boolean>#and: "
	#'Fundamental'.
	self value: [ true and: [true] ] should: [:r | r]
		conformTo: #'boolean' selector: #'and:'.
	self value: [ true and: [nil isNil] ] should: [:r | r]
		conformTo: #'boolean' selector: #'and:'.
	self value: [ true and: [false] ] shouldnt: [:r | r]
		conformTo: #'boolean' selector: #'and:'.
	self value: [ true and: [nil notNil] ] shouldnt: [:r | r]
		conformTo: #'boolean' selector: #'and:'.
	self value: [ true and: [nil selector] ]
		shouldRaise: MessageNotUnderstood.

	self value: [ false and: [true] ] shouldnt: [:r | r]
		conformTo: #'boolean' selector: #'and:'.
	self value: [ false and: [nil isNil] ] shouldnt: [:r | r]
		conformTo: #'boolean' selector: #'and:'.
	self value: [ false and: [false] ] shouldnt: [:r | r]
		conformTo: #'boolean' selector: #'and:'.
	self value: [ false and: [nil notNil] ] shouldnt: [:r | r]
		conformTo: #'boolean' selector: #'and:'.
	"No error:"
	self value: [ false and: [nil selector] ] shouldnt: [:r | r]
		conformTo: #'boolean' selector: #'and:'.!

testXeqvX
	" <boolean>#eqv: "
	#'Fundamental'.
	self value: [true eqv: true] should: [:r | r]
		conformTo: #'boolean' selector: #'eqv:'.
	self value: [true eqv: false] shouldnt: [:r | r]
		conformTo: #'boolean' selector: #'eqv:'.
	self value: [false eqv: true] shouldnt: [:r | r]
		conformTo: #'boolean' selector: #'eqv:'.
	self value: [false eqv: false] should: [:r | r]
		conformTo: #'boolean' selector: #'eqv:'.!

testXifFalseX
	" <boolean>#ifFalse: "
	#'Fundamental'.
	self value: [ false ifFalse: [0] ] should: [:r | r = 0]
		conformTo: #'boolean' selector: #'ifFalse:'.
	self value: [ true ifFalse: [0] ] should: [:r | true "unspecified"]
		conformTo: #'boolean' selector: #'ifFalse:'.!

testXifFalseXifTrueX
	" <boolean>#ifFalse:ifTrue: "
	#'Fundamental'.
	self value: [ false
				ifFalse: [0]
				ifTrue: [nil selector] ]
		should: [:r | r = 0]
		conformTo: #'boolean' selector: #'ifFalse:ifTrue:'.
	self value: [ true
				ifFalse: [nil selector]
				ifTrue: [1] ]
		should: [:r | r = 1]
		conformTo: #'boolean' selector: #'ifFalse:ifTrue:'.!

testXifTrueX
	" <boolean>#ifTrue: "
	#'Fundamental'.
	self value: [ true ifTrue: [1] ] should: [:r | r = 1]
		conformTo: #'boolean' selector: #'ifTrue:'.
	self value: [ false ifTrue: [1] ] should: [:r | true "unspecified"]
		conformTo: #'boolean' selector: #'ifTrue:'.!

testXifTrueXifFalseX
	" <boolean>#ifTrue:ifFalse: "
	#'Fundamental'.
	self value: [ true
				ifTrue: [ 1 ]
				ifFalse: [ nil selector ] ]
		should: [:r | r = 1]
		conformTo: #'boolean' selector: #'ifTrue:ifFalse:'.
	self value: [ false
				ifTrue: [ nil selector ]
				ifFalse: [ 0 ] ]
		should: [:r | r = 0]
		conformTo: #'boolean' selector: #'ifTrue:ifFalse:'.!

testXnot
	" <boolean>#not "
	#'Fundamental'.
	self value: [true not] should: [:r | r = false]
		conformTo: #'boolean' selector: #'not'.
	self value: [false not] should: [:r | r = true]
		conformTo: #'boolean' selector: #'not'.!

testXorOp
	" <boolean>#| "
	#'Fundamental'.
	self value: [true | true] should: [:r | r]
		conformTo: #'boolean' selector: #'|'.
	self value: [true | false] should: [:r | r]
		conformTo: #'boolean' selector: #'|'.
	self value: [false | true] should: [:r | r]
		conformTo: #'boolean' selector: #'|'.
	self value: [false | false] shouldnt: [:r | r]
		conformTo: #'boolean' selector: #'|'.!

testXorX
	" <boolean>#or: "
	#'Fundamental'.
	self value: [ true or: [true] ] should: [:r | r]
		conformTo: #'boolean' selector: #'or:'.
	self value: [ true or: [false] ] should: [:r | r]
		conformTo: #'boolean' selector: #'or:'.
	"No error:"
	self value: [ true or: [nil selector] ] should: [:r | r]
		conformTo: #'boolean' selector: #'or:'.

	self value: [ false or: [true] ] should: [:r | r]
		conformTo: #'boolean' selector: #'or:'.
	self value: [ false or: [nil isNil] ] should: [:r | r]
		conformTo: #'boolean' selector: #'or:'.
	self value: [ false or: [false] ] shouldnt: [:r | r]
		conformTo: #'boolean' selector: #'or:'.
	self value: [ false or: [nil notNil] ] shouldnt: [:r | r]
		conformTo: #'boolean' selector: #'or:'.

	self value: [ false or: [nil selector] ]
		shouldRaise: MessageNotUnderstood.!

testXprintString
	" <boolean>#printString "
	#'Fundamental'.
	self value: [true printString] should: [:r | r = 'true']
		conformTo: #'boolean' selector: #'printString'.
	self value: [false printString] should: [:r | r = 'false']
		conformTo: #'boolean' selector: #'printString'.!

testXxorX
	" <boolean>#xor: "
	#'Fundamental'.
	self value: [true xor: true] shouldnt: [:r | r]
		conformTo: #'boolean' selector: #'xor:'.
	self value: [true xor: false] should: [:r | r]
		conformTo: #'boolean' selector: #'xor:'.
	self value: [false xor: true] should: [:r | r]
		conformTo: #'boolean' selector: #'xor:'.
	self value: [false xor: false] shouldnt: [:r | r]
		conformTo: #'boolean' selector: #'xor:'.! !
!BooleanANSITest categoriesFor: #canonicalObject!public! !
!BooleanANSITest categoriesFor: #protocol!public! !
!BooleanANSITest categoriesFor: #testXandOp!public! !
!BooleanANSITest categoriesFor: #testXandX!public! !
!BooleanANSITest categoriesFor: #testXeqvX!public! !
!BooleanANSITest categoriesFor: #testXifFalseX!public! !
!BooleanANSITest categoriesFor: #testXifFalseXifTrueX!public! !
!BooleanANSITest categoriesFor: #testXifTrueX!public! !
!BooleanANSITest categoriesFor: #testXifTrueXifFalseX!public! !
!BooleanANSITest categoriesFor: #testXnot!public! !
!BooleanANSITest categoriesFor: #testXorOp!public! !
!BooleanANSITest categoriesFor: #testXorX!public! !
!BooleanANSITest categoriesFor: #testXprintString!public! !
!BooleanANSITest categoriesFor: #testXxorX!public! !

