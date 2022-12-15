"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GpStructure subclass: #'Graphics.Gdiplus.WMFRect16'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_bottom' -> 16r6.
		'_OffsetOf_left' -> 16r0.
		'_OffsetOf_right' -> 16r4.
		'_OffsetOf_top' -> 16r2.
		'_WMFRect16_Size' -> 16r8
	}!
Graphics.Gdiplus.WMFRect16 guid: (Core.GUID fromString: '{1713ca90-9e3e-465b-9c3d-3c7b201f00ee}')!
Graphics.Gdiplus.WMFRect16 comment: '<GpWMFRect16> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpWMFRect16'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(1713CA90-9E3E-465B-9C3D-3C7B201F00EE)]
struct tagGpWMFRect16 {
	short left;
	short top;
	short right;
	short bottom;
} GpWMFRect16;
'!
!Graphics.Gdiplus.WMFRect16 methodsFor!

bottom
	"Answer the <Integer> value of the receiver's 'bottom' field."

	^bytes swordAtOffset: _OffsetOf_bottom!

bottom: anInteger
	"Set the receiver's 'bottom' field to the value of the argument, anInteger"

	bytes swordAtOffset: _OffsetOf_bottom put: anInteger!

left
	"Answer the <Integer> value of the receiver's 'left' field."

	^bytes swordAtOffset: _OffsetOf_left!

left: anInteger
	"Set the receiver's 'left' field to the value of the argument, anInteger"

	bytes swordAtOffset: _OffsetOf_left put: anInteger!

right
	"Answer the <Integer> value of the receiver's 'right' field."

	^bytes swordAtOffset: _OffsetOf_right!

right: anInteger
	"Set the receiver's 'right' field to the value of the argument, anInteger"

	bytes swordAtOffset: _OffsetOf_right put: anInteger!

top
	"Answer the <Integer> value of the receiver's 'top' field."

	^bytes swordAtOffset: _OffsetOf_top!

top: anInteger
	"Set the receiver's 'top' field to the value of the argument, anInteger"

	bytes swordAtOffset: _OffsetOf_top put: anInteger! !
!Graphics.Gdiplus.WMFRect16 categoriesForMethods!
bottom!**compiled accessors**!public! !
bottom:!**compiled accessors**!public! !
left!**compiled accessors**!public! !
left:!**compiled accessors**!public! !
right!**compiled accessors**!public! !
right:!**compiled accessors**!public! !
top!**compiled accessors**!public! !
top:!**compiled accessors**!public! !
!

!Graphics.Gdiplus.WMFRect16 class methodsFor!

byteSize
	^_WMFRect16_Size!

defineFields
	"Define the fields of the GpWMFRect16 structure.
		GpWMFRect16 compileDefinition
	
		typedef [uuid(1713CA90-9E3E-465B-9C3D-3C7B201F00EE)]
		struct tagGpWMFRect16 {
			short left;
			short top;
			short right;
			short bottom;
		} GpWMFRect16;
"

	self
		defineField: #left
			type: SWORDField new
			offset: 0;
		defineField: #top
			type: SWORDField new
			offset: 2;
		defineField: #right
			type: SWORDField new
			offset: 4;
		defineField: #bottom
			type: SWORDField new
			offset: 6.
	self byteSize: 8!

getFieldNames
	^#(#left #top #right #bottom)! !
!Graphics.Gdiplus.WMFRect16 class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

