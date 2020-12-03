"Filed out from Dolphin Smalltalk 7"!

Core.Object variableSubclass: #'Kernel.Context'
	instanceVariableNames: 'outer block'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Context guid: (Core.GUID fromString: '{4fb74aa3-f021-4955-a690-e1a29440af80}')!
Kernel.Context comment: ''!
!Kernel.Context categoriesForClass!Kernel-Processes! !
!Kernel.Context methodsFor!

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
!Kernel.Context categoriesFor: #block!accessing!private! !
!Kernel.Context categoriesFor: #frameClass!constants!public! !
!Kernel.Context categoriesFor: #home!accessing!public! !
!Kernel.Context categoriesFor: #outer!accessing!private! !
!Kernel.Context categoriesFor: #outer:!accessing!private! !
!Kernel.Context categoriesFor: #printOn:!printing!public! !

