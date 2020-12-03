"Filed out from Dolphin Smalltalk 7"!

OS.ENHMETARECORD subclass: #'OS.EMRSETVIEWPORTEXTEX'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_szlExtent' -> 16r8
	}!
OS.EMRSETVIEWPORTEXTEX guid: (Core.GUID fromString: '{4f4dcf23-8e3c-4b18-8546-b833b55d3305}')!
OS.EMRSETVIEWPORTEXTEX comment: '<EMRSETVIEWPORTEXTEX> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSETVIEWPORTEXTEX'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(4F4DCF23-8E3C-4B18-8546-B833B55D3305)]
struct tagEMRSETVIEWPORTEXTEX {
	EMR EMR;
	SIZEL szlExtent;
} EMRSETVIEWPORTEXTEX;
'!
!OS.EMRSETVIEWPORTEXTEX categoriesForClass!Win32-Structs! !
!OS.EMRSETVIEWPORTEXTEX methodsFor!

szlExtent
	"Answer the <SIZE> value of the receiver's 'szlExtent' field."

	^SIZEL fromAddress: bytes yourAddress + _OffsetOf_szlExtent!

szlExtent: aSIZE
	"Set the receiver's 'szlExtent' field to the value of the argument, aSIZE"

	aSIZE
		replaceBytesOf: bytes
		from: ##(_OffsetOf_szlExtent + 1)
		to: ##(_OffsetOf_szlExtent + SIZEL basicByteSize)
		startingAt: 1! !
!OS.EMRSETVIEWPORTEXTEX categoriesFor: #szlExtent!**compiled accessors**!public! !
!OS.EMRSETVIEWPORTEXTEX categoriesFor: #szlExtent:!**compiled accessors**!public! !

!OS.EMRSETVIEWPORTEXTEX class methodsFor!

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
		type: (StructureField type: SIZEL)
		offset: 8.
	self byteSize: 16!

getFieldNames
	^#(#iType #nSize #szlExtent)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_SETVIEWPORTEXTEX. EMR_SETWINDOWEXTEX}! !
!OS.EMRSETVIEWPORTEXTEX class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!OS.EMRSETVIEWPORTEXTEX class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!OS.EMRSETVIEWPORTEXTEX class categoriesFor: #iTypes!constants!public! !

