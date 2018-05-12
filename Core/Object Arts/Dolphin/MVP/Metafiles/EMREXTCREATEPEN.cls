"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMREXTCREATEPEN
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMREXTCREATEPEN guid: (GUID fromString: '{797b4380-74af-4163-8248-87bca7b9a3f4}')!
EMREXTCREATEPEN comment: '<EMREXTCREATEPEN> is an <ExternalStructure> class to wrap the struct ''Win32.EMREXTCREATEPEN'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(797B4380-74AF-4163-8248-87BCA7B9A3F4)]
struct tagEMREXTCREATEPEN {
	EMR EMR;
	[helpstring("Pen handle index")] DWORD ihPen;
	[helpstring("Offset to the BITMAPINFO structure if any")] DWORD offBmi;
	[helpstring("Size of the BITMAPINFO structure if any. The bitmap info is followed by the bitmap bits to form a packed DIB.")] DWORD cbBmi;
	[helpstring("Offset to the brush bitmap bits if any")] DWORD offBits;
	[helpstring("Size of the brush bitmap bits if any")] DWORD cbBits;
	[helpstring("The extended pen with the style array.")] EXTLOGPEN elp;
} EMREXTCREATEPEN;
'!
!EMREXTCREATEPEN categoriesForClass!Win32-Structs! !
!EMREXTCREATEPEN methodsFor!

cbBits
	"Answer the receiver's cbBits field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #cbBits)!

cbBits: anObject 
	"Set the receiver's cbBits field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #cbBits) put: anObject!

cbBmi
	"Answer the receiver's cbBmi field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #cbBmi)!

cbBmi: anObject 
	"Set the receiver's cbBmi field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #cbBmi) put: anObject!

elp
	"Answer the receiver's elp field as a Smalltalk object."

	^EXTLOGPEN fromAddress: bytes yourAddress + ##(self offsetOf: #elp)!

elp: anObject 
	"Set the receiver's elp field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #elp) + 1)
		to: ##((self offsetOf: #elp) + EXTLOGPEN basicByteSize)
		startingAt: 1!

ihPen
	"Answer the receiver's ihPen field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #ihPen)!

ihPen: anObject 
	"Set the receiver's ihPen field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #ihPen) put: anObject!

offBits
	"Answer the receiver's offBits field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #offBits)!

offBits: anObject 
	"Set the receiver's offBits field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #offBits) put: anObject!

offBmi
	"Answer the receiver's offBmi field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #offBmi)!

offBmi: anObject 
	"Set the receiver's offBmi field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #offBmi) put: anObject! !
!EMREXTCREATEPEN categoriesFor: #cbBits!**compiled accessors**!public! !
!EMREXTCREATEPEN categoriesFor: #cbBits:!**compiled accessors**!public! !
!EMREXTCREATEPEN categoriesFor: #cbBmi!**compiled accessors**!public! !
!EMREXTCREATEPEN categoriesFor: #cbBmi:!**compiled accessors**!public! !
!EMREXTCREATEPEN categoriesFor: #elp!**compiled accessors**!public! !
!EMREXTCREATEPEN categoriesFor: #elp:!**compiled accessors**!public! !
!EMREXTCREATEPEN categoriesFor: #ihPen!**compiled accessors**!public! !
!EMREXTCREATEPEN categoriesFor: #ihPen:!**compiled accessors**!public! !
!EMREXTCREATEPEN categoriesFor: #offBits!**compiled accessors**!public! !
!EMREXTCREATEPEN categoriesFor: #offBits:!**compiled accessors**!public! !
!EMREXTCREATEPEN categoriesFor: #offBmi!**compiled accessors**!public! !
!EMREXTCREATEPEN categoriesFor: #offBmi:!**compiled accessors**!public! !

!EMREXTCREATEPEN class methodsFor!

defineFields
	"Define the fields of the EMREXTCREATEPEN structure.

	EMREXTCREATEPEN  compileDefinition

		typedef [uuid(797B4380-74AF-4163-8248-87BCA7B9A3F4)]
		struct tagEMREXTCREATEPEN {
			EMR EMR;
			[helpstring('Pen handle index')] DWORD ihPen;
			[helpstring('Offset to the BITMAPINFO structure if any')] DWORD offBmi;
			[helpstring('Size of the BITMAPINFO structure if any. The bitmap info is followed by the bitmap bits to form a packed DIB.')] DWORD cbBmi;
			[helpstring('Offset to the brush bitmap bits if any')] DWORD offBits;
			[helpstring('Size of the brush bitmap bits if any')] DWORD cbBits;
			[helpstring('The extended pen with the style array.')] EXTLOGPEN elp;
		} EMREXTCREATEPEN;
"

	super defineFields.
	self
		defineField: #ihPen type: DWORDField new offset: 8;
		defineField: #offBmi type: DWORDField new offset: 12;
		defineField: #cbBmi type: DWORDField new offset: 16;
		defineField: #offBits type: DWORDField new offset: 20;
		defineField: #cbBits type: DWORDField new offset: 24;
		defineField: #elp type: (StructureField type: EXTLOGPEN) offset: 28.
	self byteSize: 56!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_EXTCREATEPEN! !
!EMREXTCREATEPEN class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMREXTCREATEPEN class categoriesFor: #iTypes!constants!public! !

