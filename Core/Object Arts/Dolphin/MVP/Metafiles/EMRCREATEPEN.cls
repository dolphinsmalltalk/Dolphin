"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRCREATEPEN
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRCREATEPEN guid: (GUID fromString: '{f7e241d3-4c87-4409-a235-94cd95523c94}')!
EMRCREATEPEN comment: '<EMRCREATEPEN> is an <ExternalStructure> class to wrap the struct ''Win32.EMRCREATEPEN'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(F7E241D3-4C87-4409-A235-94CD95523C94)]
struct tagEMRCREATEPEN {
	EMR EMR;
	[helpstring("Pen handle index")] DWORD ihPen;
	LOGPEN lopn;
} EMRCREATEPEN;
'!
!EMRCREATEPEN categoriesForClass!Win32-Structs! !
!EMRCREATEPEN methodsFor!

ihPen
	"Answer the receiver's ihPen field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #ihPen)!

ihPen: anObject 
	"Set the receiver's ihPen field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #ihPen) put: anObject!

lopn
	"Answer the receiver's lopn field as a Smalltalk object."

	^LOGPEN fromAddress: bytes yourAddress + ##(self offsetOf: #lopn)!

lopn: anObject 
	"Set the receiver's lopn field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #lopn) + 1)
		to: ##((self offsetOf: #lopn) + LOGPEN basicByteSize)
		startingAt: 1! !
!EMRCREATEPEN categoriesFor: #ihPen!**compiled accessors**!public! !
!EMRCREATEPEN categoriesFor: #ihPen:!**compiled accessors**!public! !
!EMRCREATEPEN categoriesFor: #lopn!**compiled accessors**!public! !
!EMRCREATEPEN categoriesFor: #lopn:!**compiled accessors**!public! !

!EMRCREATEPEN class methodsFor!

defineFields
	"Define the fields of the EMRCREATEPEN structure.

	EMRCREATEPEN  compileDefinition

		typedef [uuid(F7E241D3-4C87-4409-A235-94CD95523C94)]
		struct tagEMRCREATEPEN {
			EMR EMR;
			[helpstring('Pen handle index')] DWORD ihPen;
			LOGPEN lopn;
		} EMRCREATEPEN;
"

	super defineFields.
	self
		defineField: #ihPen type: DWORDField new offset: 8;
		defineField: #lopn type: (StructureField type: LOGPEN) offset: 12.
	self byteSize: 28!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_CREATEPEN! !
!EMRCREATEPEN class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRCREATEPEN class categoriesFor: #iTypes!constants!public! !

