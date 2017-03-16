"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRCREATEBRUSHINDIRECT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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
	"Answer the receiver's ihBrush field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #ihBrush)!

ihBrush: anObject 
	"Set the receiver's ihBrush field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #ihBrush) put: anObject!

lb
	"Answer the receiver's lb field as a Smalltalk object."

	^LOGBRUSH fromAddress: bytes yourAddress + ##(self offsetOf: #lb)!

lb: anObject 
	"Set the receiver's lb field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #lb) + 1)
		to: ##((self offsetOf: #lb) + LOGBRUSH basicByteSize)
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

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_CREATEBRUSHINDIRECT! !
!EMRCREATEBRUSHINDIRECT class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRCREATEBRUSHINDIRECT class categoriesFor: #iTypes!constants!public! !

