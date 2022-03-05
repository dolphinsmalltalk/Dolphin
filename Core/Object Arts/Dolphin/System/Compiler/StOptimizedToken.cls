"Filed out from Dolphin Smalltalk"!

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

stop: anInteger 
	stopPosition := anInteger! !
!StOptimizedToken categoriesForMethods!
acceptVisitor:!public!visitor! !
isOptimized!public!testing! !
length!accessing!private! !
stop:!accessing!public! !
!

!StOptimizedToken class methodsFor!

start: anInteger comments: aCollectionOrNil stop: stopInteger
	<primitive: 157>
	^self new
		start: anInteger;
		comments: aCollectionOrNil;
		stop: stopInteger;
		yourself! !
!StOptimizedToken class categoriesForMethods!
start:comments:stop:!instance creation!public! !
!

