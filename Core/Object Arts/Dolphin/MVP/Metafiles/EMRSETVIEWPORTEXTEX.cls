"Filed out from Dolphin Smalltalk"!

ENHMETARECORD subclass: #EMRSETVIEWPORTEXTEX
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_szlExtent'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

EMRSETVIEWPORTEXTEX guid: (GUID fromString: '{4f4dcf23-8e3c-4b18-8546-b833b55d3305}')!

EMRSETVIEWPORTEXTEX addClassConstant: '_OffsetOf_szlExtent' value: 16r8!

EMRSETVIEWPORTEXTEX comment: '<EMRSETVIEWPORTEXTEX> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSETVIEWPORTEXTEX'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(4F4DCF23-8E3C-4B18-8546-B833B55D3305)]
struct tagEMRSETVIEWPORTEXTEX {
	EMR EMR;
	SIZEL szlExtent;
} EMRSETVIEWPORTEXTEX;
'!

!EMRSETVIEWPORTEXTEX categoriesForClass!Win32-Structs! !

!EMRSETVIEWPORTEXTEX methodsFor!

szlExtent
	"Answer the <SIZE> value of the receiver's 'szlExtent' field."

	^SIZE fromAddress: bytes yourAddress + _OffsetOf_szlExtent!

szlExtent: aSIZE
	"Set the receiver's 'szlExtent' field to the value of the argument, aSIZE"

	aSIZE
		replaceBytesOf: bytes
		from: ##(_OffsetOf_szlExtent + 1)
		to: ##(_OffsetOf_szlExtent + SIZE basicByteSize)
		startingAt: 1! !

!EMRSETVIEWPORTEXTEX categoriesForMethods!
szlExtent!**compiled accessors**!public! !
szlExtent:!**compiled accessors**!public! !
!

!EMRSETVIEWPORTEXTEX class methodsFor!

defineFields
	"Define the fields of the EMRSETVIEWPORTEXTEX structure.

	EMRSETVIEWPORTEXTEX  compileDefinition

		typedef [uuid(4F4DCF23-8E3C-4B18-8546-B833B55D3305)]
		struct tagEMRSETVIEWPORTEXTEX {
			EMR EMR;
			SIZEL szlExtent;
		} EMRSETVIEWPORTEXTEX;
"

	super defineFields.
	self
		defineField: #szlExtent
			type: (StructureField type: SIZE)
			offset: 8.
	self byteSize: 16!

getFieldNames
	^#(#iType #nSize #szlExtent)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_SETVIEWPORTEXTEX with: EMR_SETWINDOWEXTEX! !

!EMRSETVIEWPORTEXTEX class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

