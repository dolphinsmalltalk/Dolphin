"Filed out from Dolphin Smalltalk"!

External.ExternalArray
	subclass: #'External.GenericExternalArray'
	instanceVariableNames: 'elementClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.GenericExternalArray guid: (Core.GUID fromString: '{a784c4d3-dd39-4844-b096-400529d9295c}')!

External.GenericExternalArray isNonInstantiable: true!

External.GenericExternalArray comment: '`GenericExternalArray` is an abstract class of  `ExternalArray`s that can be parameterised to represent external arrays of a chosen element type, rather than supporting only a fixed element type.

## Instance Variables:
  `elementClass`	`Class` of elements in the array, typically an `External.Structure` subclass'!

!External.GenericExternalArray categoriesForClass!External-Data-Structured! !

!External.GenericExternalArray methodsFor!

anySatisfy: discriminator
	"Answer whether the <monadicValuable>, discriminator, evaluates to true for
	any element of the receiver.
	Implementation Note: The argument is evaluated for every element of the
	receiver iff it evaluates to false for every element."

	self
		uncheckedFrom: 1
		to: self size
		keysAndValuesDo: [:i :elem | (discriminator value: elem) ifTrue: [^true]].
	^false!

asArray
	"Answer an <Array> containing the constituent elements of the receiver."

	^self collect: [:each | each asObject]!

base
	^self yourAddress!

elementClass
	"Answer the class of <ExternalStructure> used to represent the receiver's elements."

	^elementClass!

elementClass: aClass 
	"Private - Set the class of Smalltalk object used to represent the elements of the receiver."

	elementClass := aClass!

isSelfEvaluating
	^false!

needsFree
	"Private - Answer whether the receiver requires freeing of any external resources.
	In most cases we don't want to free if this object is a reference to an array of structures held elsewhere, since that that would be rather rude. Therefore we only free if the owner is not set."

	^owner isNil and: [self isNull not]!

newElementAt: anAddress
	"Answer a new reference instance of the receiver's element class, pointing at the element
	at the specified memory address."

	^self elementClass atAddress: anAddress owner: self fieldOwner!

uncheckedAt: anInteger 
	"Private - Answer an instance of the receiver's elementClass which is a reference to the
	element of the receiver at the specified <integer> index. No bounds checks are performed on
	the subscript."

	^self newElementAt: self base + ((anInteger - 1) * self packing)!

uncheckedFrom: startInteger to: stopInteger keysAndValuesDo: operation 
	"Private - Evaluate the <dyadicValuable>, operation, for each element of the receiver
	between the specified, inclusive, <integer> indices with the element and its index as
	respectively the second and first arguments. No bounds checking is performed. "

	"Implementation Note: Override for improved performance (reduction of address calculations).
	By overriding this one method, we improve the performance of all enumerators."

	| address spacing |
	spacing := self packing.
	address := self base + ((startInteger - 1) * spacing).
	startInteger to: stopInteger
		do: 
			[:i | 
			operation value: i value: (self newElementAt: address).
			address := address + spacing]!

with: aCollection do: aDyadicValuable
	"Evaluate the <dyadicValuable> argument with each of the receiver's element structures along with the corresponding element from the <collection> argument, aCollection. The collection is enumerated in its #do: order."

	self subclassResponsibility! !

!External.GenericExternalArray categoriesForMethods!
anySatisfy:!enumerating!public! !
asArray!converting!public! !
base!accessing!private! !
elementClass!accessing!public! !
elementClass:!accessing!private! !
isSelfEvaluating!public!testing! !
needsFree!initializing!private!realizing/unrealizing! !
newElementAt:!helpers!private! !
uncheckedAt:!accessing!private! !
uncheckedFrom:to:keysAndValuesDo:!enumerating!private! !
with:do:!public! !
!

!External.GenericExternalArray class methodsFor!

length: length elementClass: elementClass 
	"Answer a new vector (single dimensioned) array that contains <integer>, length, elements of type, elementClass. The unmanaged data is to be held in a buffer allocated by the class, bufferClass."

	^self length: length elementClass: elementClass bufferClass: self bufferClass!

length: length elementClass: elementClass bufferClass: bufferClass
	"Answer a new vector (single dimensioned) array that 
	contains <integer>, length, elements of type, elementClass."

	^self subclassResponsibility!

new: anInteger bufferClass: bufferClass
	"Answer a new instance of the receiver allocated at an immovable location.
	GenericExternalArrays will typically need to know the element class, so cannot implement this."

	^self shouldNotImplement!

with: anExternalStructure
	^(self length: 1 elementClass: anExternalStructure class)
		at: 1 put: anExternalStructure;
		yourself!

withAll: aCollection bufferClass: bufferClass elementClass: structClass 
	"Answer a new instance of the receiver containing all of the elements of the <collection> 
	argument, represented in the format of the <ExternalStructure> class argument.  An error 
	will be raised if any of the elements cannot be represented as instances of the element class."

	| answer |
	answer := self length: aCollection size elementClass: structClass bufferClass: bufferClass.
	aCollection inject: 1
		into: 
			[:i :elem | 
			answer uncheckedAt: i put: elem.
			i + 1].
	^answer!

withAll: aCollection elementClass: structClass 
	"Answer a new instance of the receiver containing all of the elements of the <collection> argument, represented in the format of the <ExternalStructure> class argument.  
	An error will be raised if any of the elements cannot be represented as instances of the element class."

	^self withAll: aCollection bufferClass: self bufferClass elementClass: structClass! !

!External.GenericExternalArray class categoriesForMethods!
length:elementClass:!instance creation!public! !
length:elementClass:bufferClass:!instance creation!public! !
new:bufferClass:!instance creation!public! !
with:!instance creation!public! !
withAll:bufferClass:elementClass:!instance creation!public! !
withAll:elementClass:!instance creation!public! !
!

