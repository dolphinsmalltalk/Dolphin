"Filed out from Dolphin Smalltalk X6.1"!

GenericExternalArray subclass: #StructureArray
	instanceVariableNames: 'elementSpacing'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StructureArray guid: (GUID fromString: '{87B4C5A5-026E-11D3-9FD7-00A0CC3E4A32}')!
StructureArray comment: 'Generic <ExternalArray> class which can represent single-dimensioned arrays of any class of <ExternalStructure>. Packing and alignment rules are respected.

Note that although StructureArray is capable of fulfilling the tasks of other more specialized <ExternalArray> classes such as <DWORDArray> and <FLOATArray>, it is far less efficient and marginally more inconvenient as indexed access always yields an <ExternalStructure> rather than a fundamental Smalltalk object.

Instance Variables:
	elementSpacing	<integer>. Distance (in bytes) between adjacent elements, there may be padding.

'!
!StructureArray categoriesForClass!External-Data-Structured! !
!StructureArray methodsFor!

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

copyFrom: start to: stop 
	"Private - Answer an object of the same species as the receiver
	containing a copy of the elements of the receiver starting at index start, 
	until index stop, inclusive."

	| len |
	len := stop - start + 1.
	^(self species length: len elementClass: elementClass) 
		replaceFrom: 1
		to: len
		with: self
		startingAt: start!

elementClass: elemClass 
	"Private - Set the class to be used for accessing elements of the receiver.
	Answer the receiver."

	super elementClass: elemClass.
	elementSpacing := self elementSize roundUpTo: self alignment!

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

packing
	"Private - Answer the number of bytes between individual elements of the receiver.
	This is the receiver's elementSize plus any padding necessary."

	^elementSpacing!

rawDo: operation 
	"Private - Evaluate the <dyadicValuable>, operation, for each element of the receiver
	between the specified, inclusive, <integer> indices with the element and its index as
	respectively the second and first arguments. No bounds checking is performed. "

	"Implementation Note: Override for improved performance (reduction of address calculations).
	By overriding this one method, we improve the performance of all enumerators."

	| address spacing elem |
	spacing := self packing.
	address := self base.
	elem := elementClass newPointer.
	self length timesRepeat: 
			[elem initializeAtAddress: address.
			operation value: elem.
			address := address + spacing]!

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

with: otherCollection do: operation
	"Private - Evaluate the <dyadicValuable> argument, operation, with each of 
	the receiver's elements along with the corresponding element from the 
	<sequencedReadableCollection> argument, otherCollection.
	N.B. This is private because the element passed to the operation must
	not be captured since it is shared. StructureArrays are often initialized
	from Smalltalk arrays, and the elements passed are only transient references
	anyway."

	| elem addr spacing |
	addr := self yourAddress.
	spacing := self packing.
	elem := elementClass newPointer.
	1 to: self size do: [:i |
		elem initializeAtAddress: addr.
		operation
			value: elem
			value: (otherCollection at: i).
		addr := addr + spacing]! !
!StructureArray categoriesFor: #alignment!constants!public! !
!StructureArray categoriesFor: #basicFree!private!realizing/unrealizing! !
!StructureArray categoriesFor: #copyFrom:to:!copying!private! !
!StructureArray categoriesFor: #elementClass:!accessing!private! !
!StructureArray categoriesFor: #initialize!initializing!private! !
!StructureArray categoriesFor: #initializePointer!initializing!private! !
!StructureArray categoriesFor: #packing!constants!private! !
!StructureArray categoriesFor: #rawDo:!enumerating!private! !
!StructureArray categoriesFor: #uncheckedAt:put:!accessing!private! !
!StructureArray categoriesFor: #with:do:!enumerating!private! !

!StructureArray class methodsFor!

fromAddress: anAddress length: anInteger elementClass: elementClass
	"Answer a new instance of the receiver that points at an
	array of anInteger elements of type elementClass at anAddress.
	Implementation Note: If the length is zero, then we ignore the address (even if invalid).
	If the length is non-zero then we answer nil if the address is the Null pointer."

	^anInteger == 0 
		ifTrue: [self basicNew basicLength: 0; elementClass: elementClass]
		ifFalse: [
			anAddress isNull ifFalse: [
				self basicNew
					initializeAtAddress: anAddress;
					elementClass: elementClass;
					basicLength: anInteger]]!

length: anInteger elementClass: elementClass
	"Answer a new instance of the receiver that contains a buffer
	of sufficient size to contain anInteger elements of type, elementClass."

	^(self length: anInteger elementSize: elementClass elementSize)
		elementClass: elementClass!

stbConvertFrom: anSTBClassFormat
	"Convert from earlier version models.
		1: Added 'owner' instance variable, default to nil."

	^[:data | | newInstance |
		newInstance := self basicNew.
		1 to: data size do: [:i | newInstance instVarAt: i put: (data at: i)].
		"Ensure the elementSpacing is set correctly in case importing data from 2.1"
		newInstance elementClass: newInstance elementClass.
		newInstance]!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^1! !
!StructureArray class categoriesFor: #fromAddress:length:elementClass:!instance creation!public! !
!StructureArray class categoriesFor: #length:elementClass:!instance creation!public! !
!StructureArray class categoriesFor: #stbConvertFrom:!binary filing!public! !
!StructureArray class categoriesFor: #stbVersion!binary filing!public! !

