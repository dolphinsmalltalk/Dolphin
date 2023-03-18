"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GpStructure
	subclass: #'Graphics.Gdiplus.ColorMap'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_ColorMap_Size' -> 16r8.
			'_OffsetOf_newColor' -> 16r4.
			'_OffsetOf_oldColor' -> 16r0
		}!
Graphics.Gdiplus.ColorMap guid: (Core.GUID fromString: '{16b02cc4-3683-4fdc-8bdc-c450ef3137b2}')!
Graphics.Gdiplus.ColorMap comment: '<GpColorMap> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpColorMap'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(16B02CC4-3683-4FDC-8BDC-C450EF3137B2)]
struct tagGpColorMap {
	unsigned long oldColor;
	unsigned long newColor;
} GpColorMap;
'!
!Graphics.Gdiplus.ColorMap categoriesForClass!Gdiplus-Structs! !
!Graphics.Gdiplus.ColorMap methodsFor!

newColor
	"Answer the <Integer> value of the receiver's 'newColor' field."

	^bytes uint32AtOffset: _OffsetOf_newColor!

newColor: anInteger
	"Set the receiver's 'newColor' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_newColor put: anInteger!

oldColor
	"Answer the <Integer> value of the receiver's 'oldColor' field."

	^bytes uint32AtOffset: _OffsetOf_oldColor!

oldColor: anInteger
	"Set the receiver's 'oldColor' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_oldColor put: anInteger! !
!Graphics.Gdiplus.ColorMap categoriesForMethods!
newColor!**compiled accessors**!public! !
newColor:!**compiled accessors**!public! !
oldColor!**compiled accessors**!public! !
oldColor:!**compiled accessors**!public! !
!

!Graphics.Gdiplus.ColorMap class methodsFor!

byteSize
	^_ColorMap_Size!

defineFields
	"Define the fields of the ColorMap structure.

	ColorMap compileDefinition

		typedef [uuid(16b02cc4-3683-4fdc-8bdc-c450ef3137b2)]
		struct tagColorMap {
			Color oldColor;
			Color newColor;
		} ColorMap;
"

	self
		defineField: #oldColor type: UInt32Field new offset: 0;
		defineField: #newColor type: UInt32Field new offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#oldColor #newColor)! !
!Graphics.Gdiplus.ColorMap class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

