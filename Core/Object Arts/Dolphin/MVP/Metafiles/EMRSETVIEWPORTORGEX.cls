"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRSETVIEWPORTORGEX
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRSETVIEWPORTORGEX guid: (GUID fromString: '{69136774-602e-4324-aff6-a261d792e0ff}')!
EMRSETVIEWPORTORGEX comment: '<EMRSETVIEWPORTORGEX> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSETVIEWPORTORGEX'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(69136774-602E-4324-AFF6-A261D792E0FF)]
struct tagEMRSETVIEWPORTORGEX {
	EMR EMR;
	POINTL ptlOrigin;
} EMRSETVIEWPORTORGEX;
'!
!EMRSETVIEWPORTORGEX categoriesForClass!Win32-Structs! !
!EMRSETVIEWPORTORGEX methodsFor!

ptlOrigin
	"Answer the receiver's ptlOrigin field as a Smalltalk object."

	^POINTL fromAddress: bytes yourAddress + ##(self offsetOf: #ptlOrigin)!

ptlOrigin: anObject 
	"Set the receiver's ptlOrigin field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #ptlOrigin) + 1)
		to: ##((self offsetOf: #ptlOrigin) + POINTL basicByteSize)
		startingAt: 1! !
!EMRSETVIEWPORTORGEX categoriesFor: #ptlOrigin!**compiled accessors**!public! !
!EMRSETVIEWPORTORGEX categoriesFor: #ptlOrigin:!**compiled accessors**!public! !

!EMRSETVIEWPORTORGEX class methodsFor!

defineFields
	"Define the fields of the EMRSETVIEWPORTORGEX structure.

	EMRSETVIEWPORTORGEX  compileDefinition

		typedef [uuid(69136774-602E-4324-AFF6-A261D792E0FF)]
		struct tagEMRSETVIEWPORTORGEX {
			EMR EMR;
			POINTL ptlOrigin;
		} EMRSETVIEWPORTORGEX;
"

	super defineFields.
	self
		defineField: #ptlOrigin
			type: (StructureField type: POINTL)
			offset: 8.
	self byteSize: 16!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array 
		with: EMR_SETVIEWPORTORGEX
		with: EMR_SETWINDOWORGEX
		with: EMR_SETBRUSHORGEX! !
!EMRSETVIEWPORTORGEX class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRSETVIEWPORTORGEX class categoriesFor: #iTypes!constants!public! !

