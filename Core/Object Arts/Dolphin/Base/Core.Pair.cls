"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Core.Pair'
	instanceVariableNames: 'first second'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Pair guid: (Core.GUID fromString: '{d4c8987c-438d-404d-9af0-ebfb791b8fe0}')!
Core.Pair comment: '<Core.Pair> is a simple 2-element tuple.'!
!Core.Pair categoriesForClass!Kernel-Objects! !
!Core.Pair methodsFor!

= anObject
	"Answer whether the receiver and anObject are considered equivalent. 
	A `Pair` can only be equal to another `Pair` with the equal values."

	^self == anObject
		or: [anObject species == self species and: [first = anObject first and: [second = anObject second]]]!

first
	"Answer the 1st element of the pair."

	^first!

first: anObject
	"Set the 1st element of the pair."

	first := anObject!

hash
	"Answer the <integer> hash value for the receiver."

	^first hash hashMultiply + second hash!

last
	"Answer the 2nd element of the pair. Useful when replacing uses of 2-element Arrays."

	^second!

printOn: aStream
	self basicPrintOn: aStream.
	aStream
		nextPut: $(;
		print: first;
		nextPutAll: ', ';
		print: second;
		nextPut: $)!

second
	"Answer the 2nd element of the pair."

	^second!

second: anObject
	"Set the 2nd element of the pair."

	second := anObject! !
!Core.Pair categoriesForMethods!
=!comparing!public! !
first!accessing!public! !
first:!accessing!public! !
hash!comparing!public! !
last!accessing!public! !
printOn:!public! !
second!accessing!public! !
second:!accessing!public! !
!

!Core.Pair class methodsFor!

first: firstObject second: secondObject
	<primitive: 157>
	^self new
		first: firstObject;
		second: secondObject;
		yourself! !
!Core.Pair class categoriesForMethods!
first:second:!instance creation!public! !
!

