"Filed out from Dolphin Smalltalk 7"!

Object variableSubclass: #Context
	instanceVariableNames: 'outer block'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Context guid: (GUID fromString: '{4fb74aa3-f021-4955-a690-e1a29440af80}')!
Context comment: ''!
!Context categoriesForClass!Kernel-Processes! !
!Context methodsFor!

at: index
	"Answer the receiver's indexed instance variable at the argument index.
	As basicAt:, but may be reimplemented.

	Primitive Failure Reasons:
		0	- aSmallInteger is not a SmallInteger
		1	- aSmallInteger out of bounds (not in the range 1..receiver's indexable size)."

	<primitive: 49>
	^self errorAt: index!

at: index put: value
	"Replace the receivers indexed instance variable at the argument,
	index, with the argument, value. Answer value.
	As basicAt:put: but may be reimplemented.

	Primitive Failure Reasons:
		0	- aSmallInteger is not a SmallInteger
		1	- aSmallInteger out of bounds (not in the range 1..receiver's indexable size) 
		2	- the argument, value, is not of a class which can be stored in the receiver
			(e.g. its a non-SmallInteger and the receiver is a ByteArray)."

	<primitive: 50>
	^self errorAt: index put: value!

block
	^block!

frameClass
	^block isNil ifTrue: [StackFrame] ifFalse: [BlockFrame]!

home
	^block isNil ifTrue: [self] ifFalse: [block home]!

outer
	^outer!

outer: anObject
	outer := anObject!

printOn: aStream 
	outer isInteger 
		ifTrue: 
			[outer isZero 
				ifTrue: [aStream nextPutAll: 'an expired ']
				ifFalse: [aStream nextPutAll: 'a method '].
			aStream display: self class name]
		ifFalse: 
			[aStream
				basicPrint: self;
				nextPutAll: ' for ';
				print: block]! !
!Context categoriesFor: #at:!accessing!public! !
!Context categoriesFor: #at:put:!accessing!public! !
!Context categoriesFor: #block!accessing!private! !
!Context categoriesFor: #frameClass!constants!public! !
!Context categoriesFor: #home!accessing!public! !
!Context categoriesFor: #outer!accessing!private! !
!Context categoriesFor: #outer:!accessing!private! !
!Context categoriesFor: #printOn:!printing!public! !

