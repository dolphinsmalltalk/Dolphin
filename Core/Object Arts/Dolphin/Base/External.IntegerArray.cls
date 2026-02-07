"Filed out from Dolphin Smalltalk"!

External.ExternalArray
	subclass: #'External.IntegerArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.IntegerArray guid: (Core.GUID fromString: '{06f3fa78-588a-43c1-b1f8-89aad492d916}')!

External.IntegerArray isNonInstantiable: true!

External.IntegerArray comment: ''!

!External.IntegerArray methodsFor!

uncheckedAt: indexInteger put: anObject
	"Private - Replace the value at the index specified by the `<integer>` 1st argument with value of the 2nd argument. The types of object acceptable as the 2nd argument vary by subclass, but at this base level `SmallInteger` values in the range 0..255 are expected (i.e. octets). No bounds checks are performed on the subscript. "

	self basicUncheckedAt: indexInteger put: anObject asInteger.
	^anObject! !

!External.IntegerArray categoriesForMethods!
uncheckedAt:put:!accessing!private! !
!

