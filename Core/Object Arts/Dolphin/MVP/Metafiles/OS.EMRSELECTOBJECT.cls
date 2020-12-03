"Filed out from Dolphin Smalltalk 7"!

OS.ENHMETARECORD subclass: #'OS.EMRSELECTOBJECT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_ihObject' -> 16r8
	}!
OS.EMRSELECTOBJECT guid: (Core.GUID fromString: '{7a1bcb22-ae68-4f89-8318-06efd07dfcdb}')!
OS.EMRSELECTOBJECT comment: '<EMRSELECTOBJECT> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSELECTOBJECT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(7A1BCB22-AE68-4F89-8318-06EFD07DFCDB)]
struct tagEMRSELECTOBJECT {
	EMR EMR;
	[helpstring("Object handle index")] DWORD ihObject;
} EMRSELECTOBJECT;
'!
!OS.EMRSELECTOBJECT categoriesForClass!Win32-Structs! !
!OS.EMRSELECTOBJECT methodsFor!

ihObject
	"Answer the <Integer> value of the receiver's 'ihObject' field."

	^bytes dwordAtOffset: _OffsetOf_ihObject!

ihObject: anInteger
	"Set the receiver's 'ihObject' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_ihObject put: anInteger! !
!OS.EMRSELECTOBJECT categoriesFor: #ihObject!**compiled accessors**!public! !
!OS.EMRSELECTOBJECT categoriesFor: #ihObject:!**compiled accessors**!public! !

!OS.EMRSELECTOBJECT class methodsFor!

defineFields
	"Define the fields of the EMRSELECTOBJECT structure.

	EMRSELECTOBJECT  compileDefinition

		typedef [uuid(7A1BCB22-AE68-4F89-8318-06EFD07DFCDB)]
		struct tagEMRSELECTOBJECT {
			EMR EMR;
			[helpstring('Object handle index')] DWORD ihObject;
		} EMRSELECTOBJECT;
"

	super defineFields.
	self
		defineField: #ihObject
		type: DWORDField new
		offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#iType #nSize #ihObject)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_SELECTOBJECT. EMR_DELETEOBJECT}! !
!OS.EMRSELECTOBJECT class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!OS.EMRSELECTOBJECT class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!OS.EMRSELECTOBJECT class categoriesFor: #iTypes!constants!public! !

