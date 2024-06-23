"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GpStructure
	subclass: #'Graphics.Gdiplus.PathData'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_Count' -> 16r0.
			'_OffsetOf_Points' -> 16r4.
			'_OffsetOf_Types' -> 16r8.
			'_PathData_Size' -> 16rC
		}!

Graphics.Gdiplus.PathData guid: (Core.GUID fromString: '{411a9cb7-6abc-4f55-aa9a-82c7e0d44142}')!

Graphics.Gdiplus.PathData comment: '<GpPathData> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpPathData'' from type information in the ''GDI+ Library 1.0'' library.

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

!Graphics.Gdiplus.PathData categoriesForClass!Gdiplus-Structs! !

!Graphics.Gdiplus.PathData methodsFor!

Count
	"Answer the <Integer> value of the receiver's 'Count' field."

	^bytes int32AtOffset: _OffsetOf_Count!

Count: anInteger
	"Set the receiver's 'Count' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_Count put: anInteger!

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

!Graphics.Gdiplus.PathData categoriesForMethods!
Count!**compiled accessors**!public! !
Count:!**compiled accessors**!public! !
Points!**compiled accessors**!public! !
Points:!**compiled accessors**!public! !
Types!**compiled accessors**!public! !
Types:!**compiled accessors**!public! !
!

!Graphics.Gdiplus.PathData class methodsFor!

byteSize
	^_PathData_Size!

defineFields
	"Define the fields of the PathData structure.

	PathData compileDefinition

		typedef [uuid(411a9cb7-6abc-4f55-aa9a-82c7e0d44142), helpstring('State-only definition of GDI+ PathData class.')]
		struct tagPathData {
			int Count;
			[size_is('Count')] POINTF* Points;
			[size_is('Count')] BYTE* Types;
		} PathData;
"

	self
		defineField: #Count type: Int32Field new offset: 0;
		defineField: #Points type: (ArrayPointerField type: POINTFArray lengthField: #Count) offset: 4;
		defineField: #Types type: (ArrayPointerField type: ExternalArray lengthField: #Count) offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#Count #Points #Types)! !

!Graphics.Gdiplus.PathData class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

