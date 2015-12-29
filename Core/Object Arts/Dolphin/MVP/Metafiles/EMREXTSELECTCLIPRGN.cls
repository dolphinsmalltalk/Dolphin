"Filed out from Dolphin Smalltalk X6.1"!

ENHMETARECORD subclass: #EMREXTSELECTCLIPRGN
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMREXTSELECTCLIPRGN guid: (GUID fromString: '{C49E357C-2207-4EEA-B22F-1B9D456C35F8}')!
EMREXTSELECTCLIPRGN comment: '<EMREXTSELECTCLIPRGN> is an <ExternalStructure> class to wrap the struct ''Win32.EMREXTSELECTCLIPRGN'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(C49E357C-2207-4EEA-B22F-1B9D456C35F8)]
struct tagEMREXTSELECTCLIPRGN {
	EMR EMR;
	[helpstring("Size of region data in bytes")] DWORD cbRgnData;
	DWORD iMode;
	BYTE* RGNDATA;
} EMREXTSELECTCLIPRGN;
'!
!EMREXTSELECTCLIPRGN categoriesForClass!Win32-Structs! !
!EMREXTSELECTCLIPRGN methodsFor!

cbRgnData
	"Answer the receiver's cbRgnData field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #cbRgnData)!

cbRgnData: anObject 
	"Set the receiver's cbRgnData field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #cbRgnData) put: anObject!

iMode
	"Answer the receiver's iMode field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #iMode)!

iMode: anObject 
	"Set the receiver's iMode field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #iMode) put: anObject!

RGNDATA
	"Answer the receiver's RGNDATA field as a Smalltalk object."

	^ExternalArray fromAddress: bytes yourAddress + ##(self offsetOf: #RGNDATA) length: self cbRgnData!

RGNDATA: anObject 
	"Set the receiver's RGNDATA field to the value of anObject."

	| size |
	size := anObject byteSize min: self cbRgnData * ##(ExternalArray elementSize).
	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #RGNDATA) + 1)
		to: ##(self offsetOf: #RGNDATA) + size
		startingAt: 1! !
!EMREXTSELECTCLIPRGN categoriesFor: #cbRgnData!**compiled accessors**!public! !
!EMREXTSELECTCLIPRGN categoriesFor: #cbRgnData:!**compiled accessors**!public! !
!EMREXTSELECTCLIPRGN categoriesFor: #iMode!**compiled accessors**!public! !
!EMREXTSELECTCLIPRGN categoriesFor: #iMode:!**compiled accessors**!public! !
!EMREXTSELECTCLIPRGN categoriesFor: #RGNDATA!**compiled accessors**!public! !
!EMREXTSELECTCLIPRGN categoriesFor: #RGNDATA:!**compiled accessors**!public! !

!EMREXTSELECTCLIPRGN class methodsFor!

defineFields
	"Define the fields of the EMREXTSELECTCLIPRGN structure.

	EMREXTSELECTCLIPRGN  compileDefinition

		typedef [uuid(C49E357C-2207-4EEA-B22F-1B9D456C35F8)]
		struct tagEMREXTSELECTCLIPRGN {
			EMR EMR;
			[helpstring('Size of region data in bytes')] DWORD cbRgnData;
			DWORD iMode;
			BYTE RGNDATA[];
		} EMREXTSELECTCLIPRGN;
"

	super defineFields.
	self
		defineField: #cbRgnData
			type: DWORDField new
			offset: 8;
		defineField: #iMode
			type: DWORDField new
			offset: 12;
		defineField: #RGNDATA
			type: (ConformantArrayField type: ExternalArray length: #cbRgnData)
			offset: 16!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_EXTSELECTCLIPRGN! !
!EMREXTSELECTCLIPRGN class categoriesFor: #defineFields!initializing!public! !
!EMREXTSELECTCLIPRGN class categoriesFor: #iTypes!constants!public! !

