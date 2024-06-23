"Filed out from Dolphin Smalltalk"!

Kernel.ObjectRegistry
	subclass: #'Kernel.WeakRegistry'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.WeakRegistry guid: (Core.GUID fromString: '{87b4c67f-026e-11d3-9fd7-00a0cc3e4a32}')!

Kernel.WeakRegistry comment: 'WeakRegistry comment: ''WeakRegistry is the class of <ObjectRegistry>s which maintain only a weak reference to registered objects. Thus registration in a WeakRegistry will not prevent the registrant from being garbage collected, which makes it useful where a unique identifier is needed for an object only for as long as it is still referred to from elsewhere in the image. An example usage is the register of extant <ExternalCallback> objects.

The superclass instance variable ''''registry'''' is initialized to an <WeakArray> in instances of this class. The slots of the array are populated either with registered objects, or with the corpse object (i.e. the DeadObject singleton instance). When a new object is registered the first slot currently occupied by a corpse is used, unless there are no ''''dead'''' entries, in which case the weak array is resized to increase its capacity. The integer key associated with a registered object is its index in the array.
'!

!Kernel.WeakRegistry categoriesForClass!System-Support! !

!Kernel.WeakRegistry methodsFor!

addAnsweringIndex: anObject
	"Register the argument, anObject, answering a unique SmallInteger id which can be used
	subsequently to retrieve that object."

	^registry addAnsweringIndex: anObject!

initialize: anInteger
	"Private - Initialize the receiver with the specified initial capacity."

	registry := WeakArray new: anInteger withAll: DeadObject.Current!

removeAtIndex: anInteger
	"Remove, and answer, the registered object with id anInteger in the receiver. 
	Raise an error if there is no element indexed by anInteger."

	| object |
	object := registry basicAt: anInteger.
	registry basicAt: anInteger put: DeadObject.Current.
	^object! !

!Kernel.WeakRegistry categoriesForMethods!
addAnsweringIndex:!adding!public! !
initialize:!initializing!private! !
removeAtIndex:!public!removing! !
!

