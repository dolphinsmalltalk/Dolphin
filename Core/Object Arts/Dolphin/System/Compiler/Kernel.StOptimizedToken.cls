"Filed out from Dolphin Smalltalk 7"!

Kernel.StToken subclass: #'Kernel.StOptimizedToken'
	instanceVariableNames: 'stopPosition'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StOptimizedToken guid: (Core.GUID fromString: '{6fd2c057-1eef-416c-99a2-60958de98eb1}')!
Kernel.StOptimizedToken comment: ''!
!Kernel.StOptimizedToken categoriesForClass!System-Compiler! !
!Kernel.StOptimizedToken methodsFor!

acceptVisitor: aTokenVisitor
	^aTokenVisitor visitOptimizedToken: self!

isOptimized
	^true!

length
	^stopPosition - self start + 1!

stop
	^stopPosition!

stop: anInteger
	stopPosition := anInteger! !
!Kernel.StOptimizedToken categoriesFor: #acceptVisitor:!public!visitor! !
!Kernel.StOptimizedToken categoriesFor: #isOptimized!public!testing! !
!Kernel.StOptimizedToken categoriesFor: #length!accessing!private! !
!Kernel.StOptimizedToken categoriesFor: #stop!accessing!public! !
!Kernel.StOptimizedToken categoriesFor: #stop:!initializing!private! !

!Kernel.StOptimizedToken class methodsFor!

start: anInteger comments: aCollectionOrNil stop: stopInteger
	<primitive: 157>
	^self new
		start: anInteger;
		comments: aCollectionOrNil;
		stop: stopInteger;
		yourself! !
!Kernel.StOptimizedToken class categoriesFor: #start:comments:stop:!instance creation!public! !

