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
	^aTokenVisitor acceptOptimizedToken: self!

isOptimized
	^true!

length
	^stopPosition - self start + 1!

start: startInteger stop: stopInteger 
	sourcePointer := startInteger.
	stopPosition := stopInteger! !
!StOptimizedToken categoriesFor: #acceptVisitor:!public!visitor! !
!StOptimizedToken categoriesFor: #isOptimized!public!testing! !
!StOptimizedToken categoriesFor: #length!accessing!private! !
!StOptimizedToken categoriesFor: #start:stop:!initializing!private! !

!StOptimizedToken class methodsFor!

start: anInteger 
	^self start: anInteger stop: anInteger + 2!

start: startInteger stop: stopInteger 
	^self new start: startInteger stop: stopInteger! !
!StOptimizedToken class categoriesFor: #start:!instance creation!public! !
!StOptimizedToken class categoriesFor: #start:stop:!instance creation!public! !

