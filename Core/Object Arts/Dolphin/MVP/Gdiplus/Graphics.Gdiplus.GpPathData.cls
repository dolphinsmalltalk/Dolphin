"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #GpPathData
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_Count' -> 16r0.
		'_OffsetOf_Points' -> 16r4.
		'_OffsetOf_Types' -> 16r8
	}!
GpPathData guid: (GUID fromString: '{411a9cb7-6abc-4f55-aa9a-82c7e0d44142}')!
GpPathData comment: '<GpPathData> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpPathData'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(411A9CB7-6ABC-4F55-AA9A-82C7E0D44142)]
struct tagGpPathData {
	int count;
	POINTF* points;
	BYTE* types;
} GpPathData;
'!
!GpPathData categoriesForClass!Unclassified! !
!GpPathData methodsFor!

Count
	"Answer the <Integer> value of the receiver's 'Count' field."

	^bytes sdwordAtOffset: _OffsetOf_Count!

Count: anInteger
	"Set the receiver's 'Count' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_Count put: anInteger!

Points
	"Answer the <POINTF> value of the receiver's 'Points' field."

	^POINTF fromAddress: (bytes intPtrAtOffset: _OffsetOf_Points)!

Points: aPOINTF
	"Set the receiver's 'Points' field to the value of the argument, aPOINTF"

	bytes uintPtrAtOffset: _OffsetOf_Points put: aPOINTF yourAddress!

Types
	"Answer the <BYTE> value of the receiver's 'Types' field."

	^BYTE fromAddress: (bytes intPtrAtOffset: _OffsetOf_Types)!

Types: aBYTE
	"Set the receiver's 'Types' field to the value of the argument, aBYTE"

	bytes uintPtrAtOffset: _OffsetOf_Types put: aBYTE yourAddress! !
!GpPathData categoriesFor: #Count!**compiled accessors**!public! !
!GpPathData categoriesFor: #Count:!**compiled accessors**!public! !
!GpPathData categoriesFor: #Points!**compiled accessors**!public! !
!GpPathData categoriesFor: #Points:!**compiled accessors**!public! !
!GpPathData categoriesFor: #Types!**compiled accessors**!public! !
!GpPathData categoriesFor: #Types:!**compiled accessors**!public! !

!GpPathData class methodsFor!

defineFields
	"Define the fields of the GpPathData structure.
		GpPathData compileDefinition
	
		typedef [uuid(411A9CB7-6ABC-4F55-AA9A-82C7E0D44142)]
		struct tagGpPathData {
			int Count;
			POINTF* Points;
			BYTE* Types;
		} GpPathData;
"

	self
		defineField: #Count type: SDWORDField new offset: 0;
		defineField: #Points type: (PointerField type: POINTF) offset: 4;
		defineField: #Types type: (PointerField type: BYTE) offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#Count #Points #Types)! !
!GpPathData class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!GpPathData class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

