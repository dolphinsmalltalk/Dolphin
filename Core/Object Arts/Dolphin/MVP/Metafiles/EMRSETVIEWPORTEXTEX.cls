"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRSETVIEWPORTEXTEX
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRSETVIEWPORTEXTEX guid: (GUID fromString: '{4f4dcf23-8e3c-4b18-8546-b833b55d3305}')!
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
	"Answer the receiver's szlExtent field as a Smalltalk object."

	^SIZE fromAddress: bytes yourAddress + ##(self offsetOf: #szlExtent)!

szlExtent: anObject 
	"Set the receiver's szlExtent field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #szlExtent) + 1)
		to: ##((self offsetOf: #szlExtent) + SIZE basicByteSize)
		startingAt: 1! !
!EMRSETVIEWPORTEXTEX categoriesFor: #szlExtent!**compiled accessors**!public! !
!EMRSETVIEWPORTEXTEX categoriesFor: #szlExtent:!**compiled accessors**!public! !

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

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_SETVIEWPORTEXTEX with: EMR_SETWINDOWEXTEX! !
!EMRSETVIEWPORTEXTEX class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRSETVIEWPORTEXTEX class categoriesFor: #iTypes!constants!public! !

