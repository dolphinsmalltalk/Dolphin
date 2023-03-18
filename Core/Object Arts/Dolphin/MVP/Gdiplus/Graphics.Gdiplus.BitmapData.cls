"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GpStructure subclass: #'Graphics.Gdiplus.BitmapData'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_BitmapData_Size' -> 16r18.
		'_OffsetOf_Height' -> 16r4.
		'_OffsetOf_PixelFormat' -> 16rC.
		'_OffsetOf_Reserved' -> 16r14.
		'_OffsetOf_Scan0' -> 16r10.
		'_OffsetOf_Stride' -> 16r8.
		'_OffsetOf_Width' -> 16r0
	}!
Graphics.Gdiplus.BitmapData guid: (Core.GUID fromString: '{8b358d63-cec7-4ae5-87c2-72d86f11e109}')!
Graphics.Gdiplus.BitmapData comment: '<GpBitmapData> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpBitmapData'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(8B358D63-CEC7-4AE5-87C2-72D86F11E109)]
struct tagGpBitmapData {
	unsigned int width;
	unsigned int height;
	int stride;
	int PixelFormat;
	void* scan0;
	unsigned int Reserved;
} GpBitmapData;
'!
!Graphics.Gdiplus.BitmapData categoriesForClass!Gdiplus-Structs! !
!Graphics.Gdiplus.BitmapData methodsFor!

Height
	"Answer the <Integer> value of the receiver's 'Height' field."

	^bytes uint32AtOffset: _OffsetOf_Height!

Height: anInteger
	"Set the receiver's 'Height' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_Height put: anInteger!

PixelFormat
	"Answer the <Integer> value of the receiver's 'PixelFormat' field."

	^bytes int32AtOffset: _OffsetOf_PixelFormat!

PixelFormat: anInteger
	"Set the receiver's 'PixelFormat' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_PixelFormat put: anInteger!

Scan0
	"Answer the <Address> value of the receiver's 'Scan0' field."

	^(bytes uintPtrAtOffset: _OffsetOf_Scan0) asExternalAddress!

Scan0: anAddress
	"Set the receiver's 'Scan0' field to the value of the argument, anAddress"

	bytes uintPtrAtOffset: _OffsetOf_Scan0 put: anAddress!

Stride
	"Answer the <Integer> value of the receiver's 'Stride' field."

	^bytes int32AtOffset: _OffsetOf_Stride!

Stride: anInteger
	"Set the receiver's 'Stride' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_Stride put: anInteger!

Width
	"Answer the <Integer> value of the receiver's 'Width' field."

	^bytes uint32AtOffset: _OffsetOf_Width!

Width: anInteger
	"Set the receiver's 'Width' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_Width put: anInteger! !
!Graphics.Gdiplus.BitmapData categoriesForMethods!
Height!**compiled accessors**!public! !
Height:!**compiled accessors**!public! !
PixelFormat!**compiled accessors**!public! !
PixelFormat:!**compiled accessors**!public! !
Scan0!**compiled accessors**!public! !
Scan0:!**compiled accessors**!public! !
Stride!**compiled accessors**!public! !
Stride:!**compiled accessors**!public! !
Width!**compiled accessors**!public! !
Width:!**compiled accessors**!public! !
!

!Graphics.Gdiplus.BitmapData class methodsFor!

byteSize
	^_BitmapData_Size!

defineFields
	"Define the fields of the GpBitmapData structure.
		GpBitmapData compileDefinition
	
		typedef [uuid(8B358D63-CEC7-4AE5-87C2-72D86F11E109)]
		struct tagGpBitmapData {
			unsigned int Width;
			unsigned int Height;
			int Stride;
			PixelFormat PixelFormat;
			void* Scan0;
			unsigned int Reserved;
		} GpBitmapData;
"

	self
		defineField: #Width
			type: UInt32Field new
			offset: 0;
		defineField: #Height
			type: UInt32Field new
			offset: 4;
		defineField: #Stride
			type: Int32Field new
			offset: 8;
		defineField: #PixelFormat
			type: Int32Field new
			offset: 12;
		defineField: #Scan0
			type: LPVOIDField new
			offset: 16;
		defineField: #Reserved
			type: UInt32Field filler
			offset: 20.
	self byteSize: 24!

getFieldNames
	^#(#Width #Height #Stride #PixelFormat #Scan0)! !
!Graphics.Gdiplus.BitmapData class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

