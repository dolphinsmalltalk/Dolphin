"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #LOGPEN
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_lopnColor _OffsetOf_lopnStyle _OffsetOf_lopnWidth'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

LOGPEN guid: (GUID fromString: '{87b4c5fb-026e-11d3-9fd7-00a0cc3e4a32}')!

LOGPEN addClassConstant: '_OffsetOf_lopnColor' value: 16rC!
LOGPEN addClassConstant: '_OffsetOf_lopnStyle' value: 16r0!
LOGPEN addClassConstant: '_OffsetOf_lopnWidth' value: 16r4!

LOGPEN comment: '<LOGPEN> is an <ExternalStructure> class to wrap the struct ''Win32.LOGPEN'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"The LOGPEN structure defines the style, width, and color of a pen. The CreatePenIndirect function uses the LOGPEN structure."

IDL definition follows:
```
typedef [uuid(87B4C5FB-026E-11D3-9FD7-00A0CC3E4A32), helpstring("The LOGPEN structure defines the style, width, and color of a pen. The CreatePenIndirect function uses the LOGPEN structure.")]
struct tagLOGPEN {
	unsigned int lopnStyle;
	POINTL lopnWidth;
	COLORREF lopnColor;
} LOGPEN;
```'!

!LOGPEN categoriesForClass!Win32-Structs! !

!LOGPEN methodsFor!

lopnColor
	"Answer the <Color> value of the receiver's 'lopnColor' field."

	^Color fromCOLORREF: (bytes dwordAtOffset: _OffsetOf_lopnColor)!

lopnColor: aColor
	"Set the receiver's 'lopnColor' field to the value of the argument, aColor"

	bytes dwordAtOffset: _OffsetOf_lopnColor put: aColor asCOLORREF!

lopnStyle
	"Answer the <Integer> value of the receiver's 'lopnStyle' field."

	^bytes dwordAtOffset: _OffsetOf_lopnStyle!

lopnStyle: anInteger
	"Set the receiver's 'lopnStyle' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_lopnStyle put: anInteger!

style
	^self lopnStyle!

style: anInteger 
	self lopnStyle: anInteger!

width
	"Answer <integer> width of the pen described by the receiver."

	"The [LOGPEN structure documentation](https://learn.microsoft.com/en-us/windows/win32/api/wingdi/ns-wingdi-logpen) states:
		
	lopnWidth
		The POINT structure that contains the pen width, in logical units. If the pointer [sic] member is NULL, the pen is one pixel wide on raster devices. The y member in the POINT structure for lopnWidth is not used.

	i.e lopnWidth.x value of 0 and 1 are equivalent. Slightly odd choice, but it does mean that a solid single-pixel black pen has a LOGPEN that is all zeros."

	| lopnWidthX |
	lopnWidthX := bytes sdwordAtOffset: _OffsetOf_lopnWidth.
	^lopnWidthX == 0 ifTrue: [1] ifFalse: [lopnWidthX]!

width: anInteger 
	"Set the <integer> width of the pen described by the receiver."

	bytes sdwordAtOffset: _OffsetOf_lopnWidth put: anInteger! !

!LOGPEN categoriesForMethods!
lopnColor!**compiled accessors**!public! !
lopnColor:!**compiled accessors**!public! !
lopnStyle!**compiled accessors**!public! !
lopnStyle:!**compiled accessors**!public! !
style!accessing!public! !
style:!accessing!public! !
width!accessing!public! !
width:!accessing!public! !
!

!LOGPEN class methodsFor!

defineFields
	"Define the fields of the LOGPEN structure.
		LOGPEN compileDefinition
	
		typedef [uuid(87B4C5FB-026E-11D3-9FD7-00A0CC3E4A32), helpstring('The LOGPEN structure defines the style, width, and color of a pen. The CreatePenIndirect function uses the LOGPEN structure.')]
		struct tagLOGPEN {
			unsigned int lopnStyle;
			POINTL lopnWidth;
			COLORREF lopnColor;
		} LOGPEN;
"

	self
		defineField: #lopnStyle type: DWORDField new;
		defineField: #lopnWidth type: (StructureField type: POINTL) beFiller;
		defineField: #lopnColor type: COLORREFField new!

getFieldNames
	^#(#lopnStyle #lopnColor)! !

!LOGPEN class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

