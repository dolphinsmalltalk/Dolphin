"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Core.Pair'
	instanceVariableNames: 'first second'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Pair guid: (Core.GUID fromString: '{d4c8987c-438d-404d-9af0-ebfb791b8fe0}')!
Core.Pair comment: '<Core.Pair> is a simple 2-element tuple.'!
!Core.Pair categoriesForClass!Kernel-Objects! !
!Core.Pair methodsFor!

first
	"Answer the 1st element of the pair."

	^first!

first: anObject
	"Set the 1st element of the pair."

	first := anObject!

last
	"Answer the 2nd element of the pair. Useful when replacing uses of 2-element Arrays."

	^second!

second
	"Answer the 2nd element of the pair."

	^second!

second: anObject
	"Set the 2nd element of the pair."

	second := anObject! !
!Core.Pair categoriesFor: #first!accessing!public! !
!Core.Pair categoriesFor: #first:!accessing!public! !
!Core.Pair categoriesFor: #last!accessing!public! !
!Core.Pair categoriesFor: #second!accessing!public! !
!Core.Pair categoriesFor: #second:!accessing!public! !

!Core.Pair class methodsFor!

first: firstObject second: secondObject
	<primitive: 157>
	^self new
		first: firstObject;
		second: secondObject;
		yourself! !
!Core.Pair class categoriesFor: #first:second:!instance creation!public! !

