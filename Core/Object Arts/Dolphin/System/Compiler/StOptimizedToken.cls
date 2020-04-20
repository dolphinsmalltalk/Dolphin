"Filed out from Dolphin Smalltalk 7"!

StToken subclass: #StOptimizedToken
	instanceVariableNames: 'stopPosition'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StOptimizedToken guid: (GUID fromString: '{6fd2c057-1eef-416c-99a2-60958de98eb1}')!
StOptimizedToken comment: ''!
!StOptimizedToken categoriesForClass!System-Compiler! !
!StOptimizedToken methodsFor!

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
!StOptimizedToken categoriesFor: #acceptVisitor:!public!visitor! !
!StOptimizedToken categoriesFor: #isOptimized!public!testing! !
!StOptimizedToken categoriesFor: #length!accessing!private! !
!StOptimizedToken categoriesFor: #stop!accessing!public! !
!StOptimizedToken categoriesFor: #stop:!initializing!private! !

!StOptimizedToken class methodsFor!

start: anInteger comments: aCollectionOrNil stop: stopInteger
	<primitive: 157>
	^self new
		start: anInteger;
		comments: aCollectionOrNil;
		stop: stopInteger;
		yourself! !
!StOptimizedToken class categoriesFor: #start:comments:stop:!instance creation!public! !

