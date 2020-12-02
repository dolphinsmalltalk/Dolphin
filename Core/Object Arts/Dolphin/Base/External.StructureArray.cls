"Filed out from Dolphin Smalltalk 7"!

GenericExternalArray subclass: #StructureArray
	instanceVariableNames: 'elementSpacing'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StructureArray guid: (GUID fromString: '{87b4c5a5-026e-11d3-9fd7-00a0cc3e4a32}')!
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
	^anObject! !
!StructureArray categoriesFor: #alignment!constants!public! !
!StructureArray categoriesFor: #basicFree!private!realizing/unrealizing! !
!StructureArray categoriesFor: #elementClass:!accessing!private! !
!StructureArray categoriesFor: #initialize!initializing!private! !
!StructureArray categoriesFor: #initializePointer!initializing!private! !
!StructureArray categoriesFor: #packing!constants!private! !
!StructureArray categoriesFor: #uncheckedAt:put:!accessing!private! !

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

length: anInteger elementClass: anExternalStructureClass initializer: aDyadicValuable
	| answer |
	answer := self length: anInteger elementClass: anExternalStructureClass.
	answer with: (1 to: anInteger) do: aDyadicValuable.
	^answer!

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

	^1!

with: anExternalStructure
	^(self length: 1 elementClass: anExternalStructure class)
		at: 1 put: anExternalStructure;
		yourself!

withAll: aCollection elementClass: anExternalStructureClass initializer: aDyadicValuable
	"Answer a new <StructureArray> containing all of the elements of the <collection> argument, converted to the format of the <ExternalStructure> class argument by the <dyadicValuable> initializer block, aDyadicValuable."

	| answer |
	answer := self length: aCollection size elementClass: anExternalStructureClass.
	answer with: aCollection do: aDyadicValuable.
	^answer! !
!StructureArray class categoriesFor: #fromAddress:length:elementClass:!instance creation!public! !
!StructureArray class categoriesFor: #length:elementClass:!instance creation!public! !
!StructureArray class categoriesFor: #length:elementClass:initializer:!instance creation!public! !
!StructureArray class categoriesFor: #stbConvertFrom:!binary filing!public! !
!StructureArray class categoriesFor: #stbVersion!binary filing!public! !
!StructureArray class categoriesFor: #with:!instance creation!public! !
!StructureArray class categoriesFor: #withAll:elementClass:initializer:!instance creation!public! !

