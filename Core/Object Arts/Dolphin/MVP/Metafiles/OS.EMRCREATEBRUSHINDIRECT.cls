"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRCREATEBRUSHINDIRECT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_ihBrush' -> 16r8.
		'_OffsetOf_lb' -> 16rC
	}!
EMRCREATEBRUSHINDIRECT guid: (GUID fromString: '{491c3d56-fbf6-4cd9-8ea2-30cdf342f656}')!
EMRCREATEBRUSHINDIRECT comment: '<EMRCREATEBRUSHINDIRECT> is an <ExternalStructure> class to wrap the struct ''Win32.EMRCREATEBRUSHINDIRECT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(491C3D56-FBF6-4CD9-8EA2-30CDF342F656)]
struct tagEMRCREATEBRUSHINDIRECT {
	EMR EMR;
	[helpstring("Brush handle index")] DWORD ihBrush;
	[helpstring("The style must be BS_SOLID, BS_HOLLOW,")] LOGBRUSH lb;
} EMRCREATEBRUSHINDIRECT;
'!
!EMRCREATEBRUSHINDIRECT categoriesForClass!Win32-Structs! !
!EMRCREATEBRUSHINDIRECT methodsFor!

ihBrush
	"Answer the <Integer> value of the receiver's 'ihBrush' field."

	^bytes dwordAtOffset: _OffsetOf_ihBrush!

ihBrush: anInteger
	"Set the receiver's 'ihBrush' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_ihBrush put: anInteger!

lb
	"Answer the <LOGBRUSH> value of the receiver's 'lb' field."

	^LOGBRUSH fromAddress: bytes yourAddress + _OffsetOf_lb!

lb: aLOGBRUSH
	"Set the receiver's 'lb' field to the value of the argument, aLOGBRUSH"

	aLOGBRUSH
		replaceBytesOf: bytes
		from: ##(_OffsetOf_lb + 1)
		to: ##(_OffsetOf_lb + LOGBRUSH basicByteSize)
		startingAt: 1! !
!EMRCREATEBRUSHINDIRECT categoriesFor: #ihBrush!**compiled accessors**!public! !
!EMRCREATEBRUSHINDIRECT categoriesFor: #ihBrush:!**compiled accessors**!public! !
!EMRCREATEBRUSHINDIRECT categoriesFor: #lb!**compiled accessors**!public! !
!EMRCREATEBRUSHINDIRECT categoriesFor: #lb:!**compiled accessors**!public! !

!EMRCREATEBRUSHINDIRECT class methodsFor!

defineFields
	"Define the fields of the EMRCREATEBRUSHINDIRECT structure.

	EMRCREATEBRUSHINDIRECT  compileDefinition

		typedef [uuid(491C3D56-FBF6-4CD9-8EA2-30CDF342F656)]
		struct tagEMRCREATEBRUSHINDIRECT {
			EMR EMR;
			[helpstring('Brush handle index')] DWORD ihBrush;
			[helpstring('The style must be BS_SOLID, BS_HOLLOW,')] LOGBRUSH lb;
		} EMRCREATEBRUSHINDIRECT;
"

	super defineFields.
	self
		defineField: #ihBrush type: DWORDField new offset: 8;
		defineField: #lb type: (StructureField type: LOGBRUSH) offset: 12.
	self byteSize: 24!

getFieldNames
	^#(#iType #nSize #ihBrush #lb)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_CREATEBRUSHINDIRECT}! !
!EMRCREATEBRUSHINDIRECT class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!EMRCREATEBRUSHINDIRECT class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRCREATEBRUSHINDIRECT class categoriesFor: #iTypes!constants!public! !

