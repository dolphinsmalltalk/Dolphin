"Filed out from Dolphin Smalltalk"!

TestCaseHelper subclass: #SequencedStreamHelper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SequencedStreamHelper guid: (GUID fromString: '{3feae730-232c-4723-a408-dba6827c7b33}')!

SequencedStreamHelper comment: ''!

!SequencedStreamHelper categoriesForClass!Unclassified! !

!SequencedStreamHelper methodsFor!

canonicalObject

	^testCase canonicalObject!

object
	^testCase canonicalObject!

object: anObject!

testXclose

#todo."Don't know how to check this:
If the receiver is a write-back stream update its stream backing store as if the message #flush was sent to the receiver. Then eliminate any association between the receiver and its stream backing store. Any system resources associated with the association should be released. The effect of sending any message to the receiver subsequent to this message is undefined.
"
	self assertSend: #close!

testXcontents
	#todo.	"Don't know how to check this:"
	self
		value: [self canonicalObject contents]
		should: [:r | r = 'this is a string' & (r size = self canonicalObject size)]
		conformTo: self protocol
		selector: #contents!

testXisEmpty

	self value: [self canonicalObject isEmpty]
		shouldnt: [:r | r]
		conformTo: self protocol selector: #'isEmpty'.!

testXposition

	self canonicalObject reset.
	self value: [self canonicalObject position]
		should: [:r | r = 0]
		conformTo: self protocol selector: #'position'.!

testXpositionX

	"Errors: If the receiver has any sequence values and amount
			is greater than or equal to the total number
			of sequence values of the receiver."
	self value: [self canonicalObject position: 99]
		shouldRaise: Error.

	self canonicalObject position: 4.

	"past sequence values smaller than amount:"
	self value: [self canonicalObject position: 6]
		should: [:r | true "UNSPECIFIED"]
		conformTo: self protocol selector: #'position:'.

	"past sequence values greater than amount:"
	self value: [self canonicalObject position: 2]
		should: [:r | true "UNSPECIFIED"]
		conformTo: self protocol selector: #'position:'.

	"receiver's past sequence values is equal to amount:"
	self value: [self canonicalObject position: 2]
		should: [:r | true "UNSPECIFIED"]
		conformTo: self protocol selector: #'position:'.

	"Errors: If amount is negative."
	self value: [self canonicalObject position: -1]
		shouldRaise: Error.!

testXreset

	self value: [self canonicalObject reset]
		should: [:r | "r UNSPECIFIED"  self canonicalObject position = 0]
		conformTo: self protocol selector: #'reset'.

	self value: [self canonicalObject reset]
		should: [:r | "r UNSPECIFIED"  self canonicalObject position = 0]
		conformTo: self protocol selector: #'reset'.!

testXsetToEnd

	self value: [self canonicalObject setToEnd]
		should: [:r | "r UNSPECIFIED"  self canonicalObject position
								= self canonicalObject contents size]
		conformTo: self protocol selector: #'setToEnd'.! !

!SequencedStreamHelper categoriesForMethods!
canonicalObject!public! !
object!public! !
object:!public! !
testXclose!public! !
testXcontents!public! !
testXisEmpty!public! !
testXposition!public! !
testXpositionX!public! !
testXreset!public! !
testXsetToEnd!public! !
!

!SequencedStreamHelper class methodsFor!

initialize
	"SequencedStreamHelper  initialize"
	super initialize! !

!SequencedStreamHelper class categoriesForMethods!
initialize!public! !
!

