"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #GpPathData
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_Count _OffsetOf_Points _OffsetOf_Types'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GpPathData guid: (GUID fromString: '{411a9cb7-6abc-4f55-aa9a-82c7e0d44142}')!

GpPathData addClassConstant: '_OffsetOf_Count' value: 16r0!
GpPathData addClassConstant: '_OffsetOf_Points' value: 16r4!
GpPathData addClassConstant: '_OffsetOf_Types' value: 16r8!

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
	"Answer the <POINTFArray> value of the receiver's 'Points' field."

	^POINTFArray fromAddress: (bytes intPtrAtOffset: _OffsetOf_Points) length: self Count!

Points: aPOINTFArray
	"Set the receiver's 'Points' field to the value of the argument, aPOINTFArray"

	bytes uintPtrAtOffset: _OffsetOf_Points put: aPOINTFArray yourAddress.
	self Count: aPOINTFArray size!

Types
	"Answer the <ExternalArray> value of the receiver's 'Types' field."

	^ExternalArray fromAddress: (bytes intPtrAtOffset: _OffsetOf_Types) length: self Count!

Types: anExternalArray
	"Set the receiver's 'Types' field to the value of the argument, anExternalArray"

	bytes uintPtrAtOffset: _OffsetOf_Types put: anExternalArray yourAddress.
	self Count: anExternalArray size! !

!GpPathData categoriesForMethods!
Count!**compiled accessors**!public! !
Count:!**compiled accessors**!public! !
Points!**compiled accessors**!public! !
Points:!**compiled accessors**!public! !
Types!**compiled accessors**!public! !
Types:!**compiled accessors**!public! !
!

!GpPathData class methodsFor!

defineFields
	"Define the fields of the PathData structure.

	GpPathData compileDefinition

		typedef [uuid(411a9cb7-6abc-4f55-aa9a-82c7e0d44142), helpstring('State-only definition of GDI+ PathData class.')]
		struct tagPathData {
			int Count;
			[size_is('Count')] POINTF* Points;
			[size_is('Count')] BYTE* Types;
		} PathData;
"

	self
		defineField: #Count type: SDWORDField new offset: 0;
		defineField: #Points type: (ArrayPointerField type: POINTFArray lengthField: #Count) offset: 4;
		defineField: #Types type: (ArrayPointerField type: ExternalArray lengthField: #Count) offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#Count #Points #Types)! !

!GpPathData class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

