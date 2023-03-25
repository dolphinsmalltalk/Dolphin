"Filed out from Dolphin Smalltalk"!

Kernel.StValueToken
	subclass: #'Kernel.StIllegalCharacterToken'
	instanceVariableNames: 'stopPosition'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StIllegalCharacterToken guid: (Core.GUID fromString: '{3aa6518c-788d-479b-b7c3-2988a870dde6}')!
Kernel.StIllegalCharacterToken comment: ''!
!Kernel.StIllegalCharacterToken categoriesForClass!System-Compiler! !
!Kernel.StIllegalCharacterToken methodsFor!

acceptVisitor: aTokenVisitor
	^aTokenVisitor visitIllegalCharacterToken: self!

length
	^stopPosition - self start + 1!

stop
	^stopPosition!

stop: anInteger
	stopPosition := anInteger! !
!Kernel.StIllegalCharacterToken categoriesForMethods!
acceptVisitor:!public!visitor! !
length!accessing!private! !
stop!accessing!public! !
stop:!initializing!private! !
!

!Kernel.StIllegalCharacterToken class methodsFor!

start: startInteger comments: aCollectionOrNil value: aString stop: stopInteger
	<primitive: 157>
	^self new
		start: startInteger;
		comments: aCollectionOrNil;
		value: aString;
		stop: stopInteger;
		yourself
! !
!Kernel.StIllegalCharacterToken class categoriesForMethods!
start:comments:value:stop:!instance creation!public! !
!

