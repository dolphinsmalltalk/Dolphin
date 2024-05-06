"Filed out from Dolphin Smalltalk"!

TestCaseHelper subclass: #PuttableStreamHelper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PuttableStreamHelper guid: (GUID fromString: '{0b17278e-6bd2-4297-a410-303ae984bd14}')!

PuttableStreamHelper comment: ''!

!PuttableStreamHelper categoriesForClass!Unclassified! !

!PuttableStreamHelper methodsFor!

canonicalObject

	^testCase canonicalObject!

object: anObject!

protocol
	^#'puttableStream'!

testXcr

"Very little can be checked at this level as puttableStream provides no access to the backing store and the return value is undefined:
5.9.4.1 A sequence of character objects that constitute the implementation-defined end-of-line sequence is added to the receiver in the same manner as if the message #nextPutAll: was sent to the receiver with an argument string whose elements are the sequence of characters.
Errors
It is erroneous if any element of the end-of-line sequence is an object that does not conform to the receiver's sequence value type.
"
	self assertSend: #cr!

testXflush

#todo."Don't know how to check this:
Upon return, if the receiver is a write-back stream, the state of the stream backing store must be consistent with the current state of the receiver.
If the receiver is not a write-back stream, the effect of this message is unspecified.
"
	self assertSend: #flush!

testXnextPutAllX

"Very little can be checked at this level as puttableStream provides no access to the backing store and the return value is undefined:
Has the effect of enumerating the aCollection with the message #do: and adding each element to the receiver with #nextPut:. That is,
aCollection do: [:each | receiver nextPut: each]
"
	self value: [self canonicalObject nextPutAll: 'abc1%ABC']
		should: [:r | true "UNSPECIFIED" ]
		conformTo: self protocol selector: #'nextPutAll:'.

	"Errors: It is erroneous if any element of aCollection is an object
		that does not conform to the receiver's sequence value type."
	self value: [self canonicalObject nextPutAll: #($a 9 $X)]
		shouldRaise: Error.!

testXnextPutX

"Very little can be checked at this level as puttableStream provides no access to the backing store and the return value is undefined:
Appends anObject to the receiver's past sequence values. If the receiver's future sequence values is not empty, removes its first object.
"
	self value: [self canonicalObject nextPut: $a]
		should: [:r | true "UNSPECIFIED" ]
		conformTo: self protocol selector: #'nextPut:'.

	"Errors: It is erroneous if anObject is an object that does not
			conform to the receiver's sequence value type."
	self value: [self canonicalObject nextPut: 9]
		shouldRaise: Error.!

testXspace

"Very little can be checked at this level as puttableStream provides no access to the backing store and the return value is undefined:
5.9.4.5 The effect is the same as sending the message #nextPut: to the receiver with an argument that is the object that is the value returned when the message #space is sent to the standard global Character.
"
	self assertSend: #space!

testXtab

"Very little can be checked at this level as puttableStream provides no access to the backing store and the return value is undefined:
5.9.4.6 The effect is the same as sending the message #nextPut: to the receiver with an argument that is the object that is the value returned when the message #tab is sent to the standard global Character.
"
	self assertSend: #tab! !

!PuttableStreamHelper categoriesForMethods!
canonicalObject!public! !
object:!public! !
protocol!public! !
testXcr!public! !
testXflush!public! !
testXnextPutAllX!public! !
testXnextPutX!public! !
testXspace!public! !
testXtab!public! !
!

!PuttableStreamHelper class methodsFor!

initialize
	"PuttableStreamHelper  initialize"
	super initialize! !

!PuttableStreamHelper class categoriesForMethods!
initialize!public! !
!

