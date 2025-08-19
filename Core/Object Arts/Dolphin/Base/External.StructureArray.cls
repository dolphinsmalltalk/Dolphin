"Filed out from Dolphin Smalltalk"!

External.GenericExternalArray
	subclass: #'External.StructureArray'
	instanceVariableNames: 'elementSpacing'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.StructureArray guid: (Core.GUID fromString: '{87b4c5a5-026e-11d3-9fd7-00a0cc3e4a32}')!

External.StructureArray comment: 'Generic `ExternalArray` class which can represent single-dimensioned arrays of any class of `External.Structure`. Packing and alignment rules are respected.

Note that although `StructureArray` is capable of fulfilling the tasks of other more specialized `ExternalArray` classes such as `Uint32Array` and `FLOATArray`, it is far less efficient and marginally more inconvenient as indexed access always yields an `External.Structure` rather than a fundamental Smalltalk object.

## Instance Variables:
  `elementSpacing`	`<integer>`. Distance (in bytes) between adjacent elements, there may be padding.

'!

!External.StructureArray categoriesForClass!External-Data-Structured! !

!External.StructureArray methodsFor!

alignment
	"Answer the alignment required for instances of the receiver when 
	embedded in arrays or other structures. For an array this is the 
	alignment requirement of the elements."

	^elementClass alignment!

basicFree
	"Private - Free external resources owned by the receiver.
	We must ask the elementClass to free each of the structures
	embedded in the receiver (should only be invoked for value instances
	not reference (pointer) instances."

	| elemClass addr spacing |
	elemClass := self elementClass.
	addr := self yourAddress.
	spacing := self packing.
	self size timesRepeat: 
			[elemClass clear: addr asExternalAddress.
			addr := addr + spacing]!

elementClass: elemClass 
	"Private - Set the class to be used for accessing elements of the receiver.
	Answer the receiver."

	super elementClass: elemClass.
	elementSpacing := self elementSize roundUpTo: self alignment.
	^self!

initialize
	"Private - Perform any initialization required for the receiver
	which is specific to the value form. Answer the receiver.
	To perform reference specific initialization, override #initializePointer."

	self owner: nil!

initializePointer
	"Private - Perform any initialization required for the receiver
	which is specific to the reference form. Answer the receiver.
	Implementation Note: Set up the address object as the owner (even
	if it isn't) to suppress the receiver's desire to free its elements
	on finalization."

	self owner: bytes!

length: anInteger elementClass: aStructureClass
	length := anInteger.
	elementSpacing := (elementClass := aStructureClass) elementSize roundUpTo: aStructureClass alignment!

packing
	"Private - Answer the number of bytes between individual elements of the receiver.
	This is the receiver's elementSize plus any padding necessary."

	^elementSpacing!

uncheckedAt: anInteger put: anObject 
	"Private - Replace the element of the receiver at the specified <integer> index
	with the <Object> argument. No bounds checks are performed on the subscript."

	| offset |
	offset := (anInteger - 1) * self packing.
	anObject 
		replaceBytesOf: bytes
		from: 1 + offset
		to: offset + self elementSize
		startingAt: 1.
	^anObject!

with: aCollection do: aDyadicValuable
	"Evaluate the <dyadicValuable> argument with each of the receiver's element structures along with the corresponding element from the <collection> argument, aCollection. The collection is enumerated in its #do: order."

	"This should be used with care. In particular the element passed to the operation must not be captured since it is re-used for subsequent elements. In any case it will be a reference to the actual memory occupied by 
	the array, which would be invalidated when the StructureArray is deallocated. If you do need to capture the elements, then you should make a copy of them."

	| elem spacing |
	self size = aCollection size ifFalse: [^self error: 'collections are of different sizes'].
	spacing := self packing.
	elem := self elementClass newPointer.
	aCollection inject: self yourAddress
		into: 
			[:addr :each |
			elem initializeAtAddress: addr.
			aDyadicValuable value: elem value: each.
			addr + spacing]! !

!External.StructureArray categoriesForMethods!
alignment!constants!public! !
basicFree!private!realizing/unrealizing! !
elementClass:!initializing!private! !
initialize!initializing!private! !
initializePointer!initializing!private! !
length:elementClass:!initializing!private! !
packing!constants!private! !
uncheckedAt:put:!accessing!private! !
with:do:!enumerating!public! !
!

!External.StructureArray class methodsFor!

fromAddress: anAddress length: anInteger elementClass: elementClass
	"Answer a new instance of the receiver that points at an
	array of anInteger elements of type elementClass at anAddress.
	Implementation Note: If the length is zero, then we ignore the address (even if invalid).
	If the length is non-zero then we answer nil if the address is the Null pointer."

	^anInteger == 0
		ifTrue: [self basicNew length: 0 elementClass: elementClass]
		ifFalse: 
			[anAddress isNull
				ifFalse: 
					[self basicNew
						initializeAtAddress: anAddress;
						length: anInteger elementClass: elementClass]]!

length: anInteger elementClass: elementClass
	"Answer a new instance of the receiver that contains a buffer	of sufficient size to contain anInteger elements of type, elementClass."

	^self basicNew
		initialize: anInteger * elementClass elementSize;
		length: anInteger elementClass: elementClass!

length: anInteger elementClass: anExternalStructureClass initializer: aDyadicValuable
	^self
		withAll: (1 to: anInteger)
		elementClass: anExternalStructureClass
		initializer: aDyadicValuable!

length: countInteger elementSize: sizeInteger
	"StructureArrays must know the element class."

	^self shouldNotImplement!

with: anExternalStructure
	^(self length: 1 elementClass: anExternalStructure class)
		at: 1 put: anExternalStructure;
		yourself!

withAll: newElements
	"Answer a new instance of the receiver containing all of the elements of the <collection> newElements."

	"We need to know the class of structured element - use #withAll:elementClass:"

	^self shouldNotImplement!

withAll: aCollection elementClass: anExternalStructureClass initializer: aDyadicValuable
	"Answer a new <StructureArray> containing all of the elements of the <collection> argument, converted to the format of the <ExternalStructure> class argument by the <dyadicValuable> initializer block, aDyadicValuable."

	^(self length: aCollection size elementClass: anExternalStructureClass)
		with: aCollection do: aDyadicValuable;
		yourself! !

!External.StructureArray class categoriesForMethods!
fromAddress:length:elementClass:!instance creation!public! !
length:elementClass:!instance creation!public! !
length:elementClass:initializer:!instance creation!public! !
length:elementSize:!public! !
with:!instance creation!public! !
withAll:!instance creation!public! !
withAll:elementClass:initializer:!instance creation!public! !
!

