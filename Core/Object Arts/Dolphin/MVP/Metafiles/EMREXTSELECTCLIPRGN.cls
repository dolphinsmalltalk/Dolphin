"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMREXTSELECTCLIPRGN
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cbRgnData' -> 16r8.
		'_OffsetOf_iMode' -> 16rC.
		'_OffsetOf_RGNDATA' -> 16r10
	}!
EMREXTSELECTCLIPRGN guid: (GUID fromString: '{c49e357c-2207-4eea-b22f-1b9d456c35f8}')!
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
	"Answer the <Integer> value of the receiver's 'cbRgnData' field."

	^bytes dwordAtOffset: _OffsetOf_cbRgnData!

cbRgnData: anInteger
	"Set the receiver's 'cbRgnData' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cbRgnData put: anInteger!

iMode
	"Answer the <Integer> value of the receiver's 'iMode' field."

	^bytes dwordAtOffset: _OffsetOf_iMode!

iMode: anInteger
	"Set the receiver's 'iMode' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_iMode put: anInteger!

RGNDATA
	"Answer the <ExternalArray> value of the receiver's 'RGNDATA' field."

	^ExternalArray fromAddress: bytes yourAddress + _OffsetOf_RGNDATA length: self cbRgnData!

RGNDATA: anExternalArray
	"Set the receiver's 'RGNDATA' field to the value of the argument, anExternalArray"

	| size |
	size := anExternalArray byteSize.
	anExternalArray
		replaceBytesOf: bytes
		from: ##(_OffsetOf_RGNDATA + 1)
		to: _OffsetOf_RGNDATA + size
		startingAt: 1.
	self cbRgnData: anExternalArray size! !
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
			type: (ArrayField type: ExternalArray lengthField: #cbRgnData)
			offset: 16!

getFieldNames
	^#(#iType #nSize #cbRgnData #iMode #RGNDATA)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_EXTSELECTCLIPRGN}! !
!EMREXTSELECTCLIPRGN class categoriesFor: #defineFields!public!template definition! !
!EMREXTSELECTCLIPRGN class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMREXTSELECTCLIPRGN class categoriesFor: #iTypes!constants!public! !

