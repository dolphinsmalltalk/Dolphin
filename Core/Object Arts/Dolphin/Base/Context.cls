"Filed out from Dolphin Smalltalk"!

Object variableSubclass: #Context
	instanceVariableNames: 'outer block'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Context guid: (GUID fromString: '{4fb74aa3-f021-4955-a690-e1a29440af80}')!
Context comment: ''!
!Context categoriesForClass!Kernel-Processes! !
!Context methodsFor!

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
!Context categoriesForMethods!
block!accessing!private! !
frameClass!constants!public! !
home!accessing!public! !
outer!accessing!private! !
outer:!accessing!private! !
printOn:!printing!public! !
!

