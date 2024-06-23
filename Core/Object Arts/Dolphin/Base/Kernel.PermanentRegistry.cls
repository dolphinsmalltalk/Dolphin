"Filed out from Dolphin Smalltalk"!

Kernel.ObjectRegistry
	subclass: #'Kernel.PermanentRegistry'
	instanceVariableNames: 'freeHead'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.PermanentRegistry guid: (Core.GUID fromString: '{87b4c67e-026e-11d3-9fd7-00a0cc3e4a32}')!

Kernel.PermanentRegistry comment: 'PermanentRegistry is a specialized class of <ObjectRegistry>s which maintain a strong reference to registered objects, preventing them from being garbage collected. They are useful where the objects may only be referenced ''externally'' (e.g. COM server objects).

The superclass instance variable ''registry'' is initialized to an <Array> in instances of this class. The slots of the array are populated either with registered objects, or linked onto a free list by index (the content of the slot being the next free entry). The last element of the <Array> is always zero to mark the end of the free list. When a new object is registered the first slot on the free list is used, unless there are no free slots in which case the array is resized to increase its capacity.

Note: The implementation of the free list in this class using integer indices means that PermanentRegistry instances are not suitable for registries of <Integer>s.

Instance Variables:
	freeHead		<integer> index of the first free slot in the registry.'!

!Kernel.PermanentRegistry categoriesForClass!System-Support! !

!Kernel.PermanentRegistry methodsFor!

addAnsweringIndex: anObject
	"Register the argument, anObject, answering a unique SmallInteger id which can be used
	subsequently to retrieve that object.
	Implementation Note: Permanent object registries cannot reliably locate registered
	integers by value, though they can hold them."

	| id |
	freeHead == 0 ifTrue: [self grow].
	id := freeHead.
	freeHead := registry basicAt: freeHead.
	registry basicAt: id put: anObject.
	^id!

grow
	"Private - Increase the capacity of the receiver. We do this by increasing
	the size of the registry, and building a free list."

	| capacity |
	capacity := registry size.
	registry := registry , (capacity + 2 to: capacity * 2) , {freeHead}.
	freeHead := capacity + 1!

initialize: anInteger
	"Private - Initialize the receiver with the specified initial capacity."

	registry := (2 to: anInteger) , ##({0}).
	freeHead := 1!

removeAtIndex: anInteger
	"Remove, and answer, the registered object with <integer> id, anInteger, in the receiver. 
	Raise an error if there is no element indexed by anInteger."

	(registry basicAt: anInteger) isInteger ifFalse: [
		registry basicAt: anInteger put: freeHead.
		freeHead := anInteger]! !

!Kernel.PermanentRegistry categoriesForMethods!
addAnsweringIndex:!adding!public! !
grow!mutating!private! !
initialize:!initializing!private! !
removeAtIndex:!public!removing! !
!

