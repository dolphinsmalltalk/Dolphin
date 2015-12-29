"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #LOGPALETTE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LOGPALETTE guid: (GUID fromString: '{87B4C5FA-026E-11D3-9FD7-00A0CC3E4A32}')!
LOGPALETTE comment: 'LOGPALETTE is a <Win32Structure> representing the LOGPALETTE external Win32 API structure.'!
!LOGPALETTE categoriesForClass!Win32-Structs! !
!LOGPALETTE methodsFor!

palNumEntries
	"Answer the receiver's palNumEntries field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #palNumEntries)!

palNumEntries: anObject 
	"Set the receiver's palNumEntries field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #palNumEntries) put: anObject!

palPalEntry
	"Answer the receiver's palPalEntry field as a Smalltalk object."

	^StructureArray 
		fromAddress: bytes yourAddress + ##(self offsetOf: #palPalEntry)
		length: self palNumEntries
		elementClass: PALETTEENTRY!

palVersion
	"Answer the receiver's palVersion field as a Smalltalk object."

	^bytes wordAtOffset: 0!

palVersion: anObject 
	"Set the receiver's palVersion field to the value of anObject."

	bytes wordAtOffset: 0 put: anObject! !
!LOGPALETTE categoriesFor: #palNumEntries!**compiled accessors**!public! !
!LOGPALETTE categoriesFor: #palNumEntries:!**compiled accessors**!public! !
!LOGPALETTE categoriesFor: #palPalEntry!**compiled accessors**!public! !
!LOGPALETTE categoriesFor: #palVersion!**compiled accessors**!public! !
!LOGPALETTE categoriesFor: #palVersion:!**compiled accessors**!public! !

!LOGPALETTE class methodsFor!

defineFields
	"Define the fields of the LOGPALETTE structure.
		LOGPALETTE compileDefinition
	
		typedef 		struct tagLOGPALETTE {
			unsigned short palVersion;
			unsigned short palNumEntries;
			PALETTEENTRY* palPalEntry;
		} LOGPALETTE;

	"

	self
		defineField: #palVersion type: WORDField new;
		defineField: #palNumEntries type: WORDField new;
		defineField: #palPalEntry
			type: (ConformantStructureArrayField type: PALETTEENTRY length: #palNumEntries) beReadOnly!

new
	"Answer an instance of the receiver of sufficient size to hold 256 palette entries"

	^(self new: ##(4 + (256 * 4)))
		palNumEntries: 256;
		yourself! !
!LOGPALETTE class categoriesFor: #defineFields!initializing!public! !
!LOGPALETTE class categoriesFor: #new!instance creation!public! !

