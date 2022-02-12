"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD subclass: #'OS.EMRCREATEBRUSHINDIRECT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_EMRCREATEBRUSHINDIRECT_Size' -> 16r18.
		'_OffsetOf_ihBrush' -> 16r8.
		'_OffsetOf_lb' -> 16rC
	}!
OS.EMRCREATEBRUSHINDIRECT guid: (Core.GUID fromString: '{491c3d56-fbf6-4cd9-8ea2-30cdf342f656}')!
OS.EMRCREATEBRUSHINDIRECT comment: '<EMRCREATEBRUSHINDIRECT> is an <ExternalStructure> class to wrap the struct ''Win32.EMRCREATEBRUSHINDIRECT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!OS.EMRCREATEBRUSHINDIRECT categoriesForClass!Win32-Structs! !
!OS.EMRCREATEBRUSHINDIRECT methodsFor!

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
		to: ##(_OffsetOf_lb + LOGBRUSH._LOGBRUSH_Size)
		startingAt: 1! !
!OS.EMRCREATEBRUSHINDIRECT categoriesForMethods!
ihBrush!**compiled accessors**!public! !
ihBrush:!**compiled accessors**!public! !
lb!**compiled accessors**!public! !
lb:!**compiled accessors**!public! !
!

!OS.EMRCREATEBRUSHINDIRECT class methodsFor!

byteSize
	^_EMRCREATEBRUSHINDIRECT_Size!

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
		defineField: #ihBrush
			type: DWORDField new
			offset: 8;
		defineField: #lb
			type: (StructureField type: LOGBRUSH)
			offset: 12.
	self byteSize: 24!

getFieldNames
	^#(#iType #nSize #ihBrush #lb)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_CREATEBRUSHINDIRECT}! !
!OS.EMRCREATEBRUSHINDIRECT class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

