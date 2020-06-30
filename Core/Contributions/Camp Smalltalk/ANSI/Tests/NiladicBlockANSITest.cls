"Filed out from Dolphin Smalltalk 7"!

MainTestCase subclass: #NiladicBlockANSITest
	instanceVariableNames: 'blk0args canonicalObject'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
NiladicBlockANSITest guid: (GUID fromString: '{5addab96-83a8-41f0-9d14-cfe47f372b9c}')!
NiladicBlockANSITest comment: ''!
!NiladicBlockANSITest categoriesForClass!Unclassified! !
!NiladicBlockANSITest methodsFor!

canonicalObject
	^canonicalObject!

protocol
	^#'niladicBlock'!

setUp
	super setUp.
	blk0args := [ Array new ].
	canonicalObject := [3+4]!

testXargumentCount
	" <niladicValuable>#argumentCount "
	#'Valuable'.
	self value: [blk0args argumentCount] should: [:r | r = 0]
		conformTo: #'niladicValuable' selector: #'argumentCount'.!

testXensureX
	" <niladicBlock>#ensure: "
	| flag tmp |
	#'Valuable'.
	flag := 0.
	self value: [	[#( 1 2 ) size] ensure: [flag := 1] ]
		should: [:r | r = 2 & (flag = 1)]
		conformTo: #'niladicBlock' selector: #'ensure:'.

#'todo'."I don't think this is a good test."
	flag := 0.
	[tmp := [#( 1 2 ) siz] ensure: [ flag := 1 ].
	] on: MessageNotUnderstood do: [ :mnu | mnu return ].
	self value: [tmp] should: [:r | flag = 1]
		conformTo: #'niladicBlock' selector: #'ensure:'.

	self value: [ [#( 1 2 ) siz] ensure: [ flag := 1 ] ]
		shouldRaise: MessageNotUnderstood.

#'todo'."or this ."
	flag := 0.

	[tmp := [Error signal] ensure: [ flag := 1 ].
	] on: Error do: [ :error | error return ].
	self value: [ tmp ] should: [:r | flag = 1]
		conformTo: #'niladicBlock' selector: #'ensure:'.
	self value: [ [Error signal] ensure: [ flag := 1 ] ]
		shouldRaise: Error.

#'testAnom'. "??? I think the ensure block should not be evaluated as per:
	Activation of an exception handler from within the receiver is not in and of itself an abnormal termination.  However, if the exception handler for an exception that is not resumable results in termination of the receiver or if its handler block contains a return statement that results in abnormal termination of the receiver, then terminationBlock will be evaluated after evaluation of the exception handler.
 
	flag := 0.
	[tmp := [Notification signal] ensure: [ flag := 1 ].
	] on: Notification do: [ :notification | notification resume ].
	self value: [ tmp ] should: [:r | flag = 0]
		conformTo: #'niladicBlock' selector: #'ensure:'.
???"
	self value: [ [Notification signal] ensure: [] ]
		shouldRaise: Notification.!

testXifCurtailedX
	" <niladicBlock>#ifCurtailed: "
	| flag tmp |
	#'Valuable'.
	self value: [ [flag := 0] ifCurtailed: [flag := 1] ]
		should: [:r | r = 0 & (flag = 0)]
		conformTo: #'niladicBlock' selector: #'ifCurtailed:'.

	[tmp := [Notification signal. 0] ifCurtailed: [flag := 1].
	] on: Notification do: [ :notification | notification resume ].
	self value: [ tmp ] should: [:r | r = 0 & (flag = 0)]
		conformTo: #'niladicBlock' selector: #'ifCurtailed:'.!

testXonXdoX
	" <niladicBlock>#on:do: "
	#'Valuable'.
	self value: [ [#( 1 2 ) size] on: Error do: [ :error | error return: -1] ]
		should: [:r | r = 2]
		conformTo: #'niladicBlock' selector: #'on:do:'.

	self value: [[Error signal. 0] on: Error do: [:error | error return: -1]]
		should: [:r | r = -1]
		conformTo: #'niladicBlock' selector: #'on:do:'.!

testXvalue
	" <niladicValuable>#value "
	#'Valuable'.
	self value: [blk0args value] should: [:r | r = #()]
		conformTo: #'niladicValuable' selector: #'value'.!

testXvalueWithArgumentsX
	" <valuable>#valueWithArguments: "
	#'Valuable'.
	self value: [blk0args valueWithArguments: #()] should: [:r | r = #()]
		conformTo: #'valuable' selector: #'valueWithArguments:'.!

testXwhileFalse
	" <niladicValuable>#whileFalse "
	| sum |
	#'Valuable'.
	sum := 0.
	self value: [ [(sum := sum + 1) >= 3] whileFalse]
		should: [:r | sum = 3]
		conformTo: #'niladicValuable' selector: #'whileFalse'.!

testXwhileFalseX
	" <niladicValuable>#whileFalse: "
	| element aReadStream |
	#'Valuable'.
	aReadStream := ReadStream on: (Array with: 1 with: 2 with: 3).
	self value: [[aReadStream atEnd] whileFalse: [
					element := aReadStream next]]
		should: [:r | element = 3]
		conformTo: #'niladicValuable' selector: #'whileFalse:'.

	element := 0.
	self value: [ [element = 0] whileFalse: [element := 1] ]
		should: [:r | element =  0]
		conformTo: #'niladicValuable' selector: #'whileFalse:'.!

testXwhileTrue
	" <niladicValuable>#whileTrue "
	| sum |
	#'Valuable'.
	sum := 0.
	self value: [ [(sum := sum + 1) < 4 ] whileTrue ]
		should: [:r | sum = 4]
		conformTo: #'niladicValuable' selector: #'whileTrue'.!

testXwhileTrueX
	" <niladicValuable>#whileTrue: "
	| sum |
	#'Valuable'.
	sum := 0.
	self value: [ [sum < 4 ] whileTrue: [sum := sum + 1] ]
		should: [:r | sum = 4]
		conformTo: #'niladicValuable' selector: #'whileTrue:'.

	sum := 0.
	self value: [ [sum < 0 ] whileTrue: [sum := sum + 1] ]
		should: [:r | sum = 0]
		conformTo: #'niladicValuable' selector: #'whileTrue:'.! !
!NiladicBlockANSITest categoriesFor: #canonicalObject!public! !
!NiladicBlockANSITest categoriesFor: #protocol!public! !
!NiladicBlockANSITest categoriesFor: #setUp!public! !
!NiladicBlockANSITest categoriesFor: #testXargumentCount!public! !
!NiladicBlockANSITest categoriesFor: #testXensureX!public! !
!NiladicBlockANSITest categoriesFor: #testXifCurtailedX!public! !
!NiladicBlockANSITest categoriesFor: #testXonXdoX!public! !
!NiladicBlockANSITest categoriesFor: #testXvalue!public! !
!NiladicBlockANSITest categoriesFor: #testXvalueWithArgumentsX!public! !
!NiladicBlockANSITest categoriesFor: #testXwhileFalse!public! !
!NiladicBlockANSITest categoriesFor: #testXwhileFalseX!public! !
!NiladicBlockANSITest categoriesFor: #testXwhileTrue!public! !
!NiladicBlockANSITest categoriesFor: #testXwhileTrueX!public! !

