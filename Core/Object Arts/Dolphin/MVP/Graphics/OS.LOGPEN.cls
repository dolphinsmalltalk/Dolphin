"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.LOGPEN'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_LOGPEN_Size' -> 16r10.
			'_OffsetOf_lopnColor' -> 16rC.
			'_OffsetOf_lopnStyle' -> 16r0.
			'_OffsetOf_lopnWidth' -> 16r4
		}!

OS.LOGPEN guid: (Core.GUID fromString: '{87b4c5fb-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.LOGPEN comment: '<LOGPEN> is an <ExternalStructure> class to wrap the struct ''Win32.LOGPEN'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"The LOGPEN structure defines the style, width, and color of a pen. The CreatePenIndirect function uses the LOGPEN structure."

IDL definition follows:

typedef [uuid(87B4C5FB-026E-11D3-9FD7-00A0CC3E4A32), helpstring("The LOGPEN structure defines the style, width, and color of a pen. The CreatePenIndirect function uses the LOGPEN structure.")]
struct tagLOGPEN {
	unsigned int lopnStyle;
	POINTL lopnWidth;
	unsigned long lopnColor;
} LOGPEN;
'!

!OS.LOGPEN categoriesForClass!Win32-Structs! !

!OS.LOGPEN methodsFor!

color
	"Answer the <Color> of the pen described by the receiver."

	^Graphics.Color fromCOLORREF: self lopnColor!

color: aColor 
	"Set the <Color> of the pen described by the receiver."

	self lopnColor: aColor asCOLORREF!

lopnColor
	"Answer the <Integer> value of the receiver's 'lopnColor' field."

	^bytes uint32AtOffset: _OffsetOf_lopnColor!

lopnColor: anInteger
	"Set the receiver's 'lopnColor' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_lopnColor put: anInteger!

lopnStyle
	"Answer the <Integer> value of the receiver's 'lopnStyle' field."

	^bytes uint32AtOffset: _OffsetOf_lopnStyle!

lopnStyle: anInteger
	"Set the receiver's 'lopnStyle' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_lopnStyle put: anInteger!

width
	"Answer <integer> width of the pen described by the receiver."

	"The [LOGPEN structure documentation](https://learn.microsoft.com/en-us/windows/win32/api/wingdi/ns-wingdi-logpen) states:
		
	lopnWidth
		The POINT structure that contains the pen width, in logical units. If the pointer [sic] member is NULL, the pen is one pixel wide on raster devices. The y member in the POINT structure for lopnWidth is not used.

	i.e lopnWidth.x value of 0 and 1 are equivalent. Slightly odd choice, but it does mean that a solid single-pixel black pen has a LOGPEN that is all zeros."

	| lopnWidthX |
	lopnWidthX := bytes int32AtOffset: _OffsetOf_lopnWidth.
	^lopnWidthX == 0 ifTrue: [1] ifFalse: [lopnWidthX]!

width: anInteger 
	"Set the <integer> width of the pen described by the receiver."

	bytes int32AtOffset: _OffsetOf_lopnWidth put: anInteger! !

!OS.LOGPEN categoriesForMethods!
color!accessing!public! !
color:!accessing!public! !
lopnColor!**compiled accessors**!public! !
lopnColor:!**compiled accessors**!public! !
lopnStyle!**compiled accessors**!public! !
lopnStyle:!**compiled accessors**!public! !
width!accessing!public! !
width:!accessing!public! !
!

!OS.LOGPEN class methodsFor!

byteSize
	^_LOGPEN_Size!

defineFields
	"Define the fields of the LOGPEN structure.
		LOGPEN compileDefinition
	
		typedef [uuid(87B4C5FB-026E-11D3-9FD7-00A0CC3E4A32), helpstring('The LOGPEN structure defines the style, width, and color of a pen. The CreatePenIndirect function uses the LOGPEN structure.')]
		struct tagLOGPEN {
			unsigned int lopnStyle;
			POINTL lopnWidth;
			unsigned long lopnColor;
		} LOGPEN;
"

	self
		defineField: #lopnStyle type: UInt32Field new;
		defineField: #lopnWidth type: (StructureField type: POINTL) beFiller;
		defineField: #lopnColor type: UInt32Field new!

getFieldNames
	^#(#lopnStyle #lopnColor)! !

!OS.LOGPEN class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

