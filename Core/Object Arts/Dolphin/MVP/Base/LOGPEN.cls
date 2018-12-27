"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #LOGPEN
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LOGPEN guid: (GUID fromString: '{87b4c5fb-026e-11d3-9fd7-00a0cc3e4a32}')!
LOGPEN comment: '<LOGPEN> is an <ExternalStructure> class to wrap the struct ''Win32.LOGPEN'' from type information in the ''Win32 API'' library.

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
!LOGPEN categoriesForClass!Win32-Structs! !
!LOGPEN methodsFor!

color
	"Answer the <Color> of the pen described by the receiver."

	^Color fromInteger: self lopnColor!

color: aColor 
	"Set the <Color> of the pen described by the receiver."

	self lopnColor: aColor asParameter!

lopnColor
	"Answer the <Integer> value of the receiver's 'lopnColor' field."

	^bytes dwordAtOffset: ##(self offsetOf: #lopnColor)!

lopnColor: anInteger
	"Set the receiver's 'lopnColor' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #lopnColor) put: anInteger!

lopnStyle
	"Answer the <Integer> value of the receiver's 'lopnStyle' field."

	^bytes dwordAtOffset: 0!

lopnStyle: anInteger
	"Set the receiver's 'lopnStyle' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

style
	^self lopnStyle!

style: anInteger 
	self lopnStyle: anInteger!

width
	"Answer <integer> width of the pen described by the receiver."

	^bytes sdwordAtOffset: 4!

width: anInteger 
	"Set the <integer> width of the pen described by the receiver."

	bytes sdwordAtOffset: 4 put: anInteger! !
!LOGPEN categoriesFor: #color!accessing!public! !
!LOGPEN categoriesFor: #color:!accessing!public! !
!LOGPEN categoriesFor: #lopnColor!**compiled accessors**!public! !
!LOGPEN categoriesFor: #lopnColor:!**compiled accessors**!public! !
!LOGPEN categoriesFor: #lopnStyle!**compiled accessors**!public! !
!LOGPEN categoriesFor: #lopnStyle:!**compiled accessors**!public! !
!LOGPEN categoriesFor: #style!accessing!public! !
!LOGPEN categoriesFor: #style:!accessing!public! !
!LOGPEN categoriesFor: #width!accessing!public! !
!LOGPEN categoriesFor: #width:!accessing!public! !

!LOGPEN class methodsFor!

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
		defineField: #lopnStyle type: DWORDField new;
		defineField: #lopnWidth type: (StructureField type: POINTL) beFiller;
		defineField: #lopnColor type: DWORDField new!

getFieldNames
	^#(#lopnStyle #lopnColor)! !
!LOGPEN class categoriesFor: #defineFields!initializing!public! !
!LOGPEN class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

