"Filed out from Dolphin Smalltalk 7"!

Object variableSubclass: #Context
	instanceVariableNames: 'outer block'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!Context categoriesFor: #block!accessing!private! !
!Context categoriesFor: #frameClass!constants!public! !
!Context categoriesFor: #home!accessing!public! !
!Context categoriesFor: #outer!accessing!private! !
!Context categoriesFor: #outer:!accessing!private! !
!Context categoriesFor: #printOn:!printing!public! !

