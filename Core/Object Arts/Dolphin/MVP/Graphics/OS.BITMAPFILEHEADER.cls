"Filed out from Dolphin Smalltalk"!

OS.Win32Structure
	subclass: #'OS.BITMAPFILEHEADER'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_BITMAPFILEHEADER_Size' -> 16rE.
			'_OffsetOf_bfOffBits' -> 16rA.
			'_OffsetOf_bfReserved1' -> 16r6.
			'_OffsetOf_bfReserved2' -> 16r8.
			'_OffsetOf_bfSize' -> 16r2.
			'_OffsetOf_bfType' -> 16r0
		}!
OS.BITMAPFILEHEADER guid: (Core.GUID fromString: '{48f23680-5426-11d3-998b-bca753d3b065}')!
OS.BITMAPFILEHEADER comment: '`BITMAPFILEHEADER` is an `External.Structure` class to wrap the struct ''Win32.BITMAPFILEHEADER'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(48f23680-5426-11d3-998b-bca753d3b065)]
struct tagBITMAPFILEHEADER {
	WORD bfType;
	DWORD bfSize;
	[hidden] WORD bfReserved1;
	[hidden] WORD bfReserved2;
	DWORD bfOffBits;
} BITMAPFILEHEADER;
```
'!
!OS.BITMAPFILEHEADER categoriesForClass!Win32-Structs! !
!OS.BITMAPFILEHEADER methodsFor!

bfOffBits
	"Answer the <Integer> value of the receiver's 'bfOffBits' field."

	^bytes uint32AtOffset: _OffsetOf_bfOffBits!

bfOffBits: anInteger
	"Set the receiver's 'bfOffBits' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_bfOffBits put: anInteger!

bfSize
	"Answer the <Integer> value of the receiver's 'bfSize' field."

	^bytes uint32AtOffset: _OffsetOf_bfSize!

bfSize: anInteger
	"Set the receiver's 'bfSize' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_bfSize put: anInteger!

bfType
	"Answer the <Integer> value of the receiver's 'bfType' field."

	^bytes uint16AtOffset: _OffsetOf_bfType!

bfType: anInteger
	"Set the receiver's 'bfType' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_bfType put: anInteger! !
!OS.BITMAPFILEHEADER categoriesForMethods!
bfOffBits!**compiled accessors**!public! !
bfOffBits:!**compiled accessors**!public! !
bfSize!**compiled accessors**!public! !
bfSize:!**compiled accessors**!public! !
bfType!**compiled accessors**!public! !
bfType:!**compiled accessors**!public! !
!

!OS.BITMAPFILEHEADER class methodsFor!

byteSize
	^_BITMAPFILEHEADER_Size!

defineFields
	"Define the fields of the BITMAPFILEHEADER structure.

	BITMAPFILEHEADER compileDefinition

		typedef [uuid(48f23680-5426-11d3-998b-bca753d3b065)]
		struct tagBITMAPFILEHEADER {
			WORD bfType;
			DWORD bfSize;
			[hidden] WORD bfReserved1;
			[hidden] WORD bfReserved2;
			DWORD bfOffBits;
		} BITMAPFILEHEADER;
"

	self
		defineField: #bfType type: UInt16Field new offset: 0;
		defineField: #bfSize type: UInt32Field new offset: 2;
		defineField: #bfReserved1 type: UInt16Field new beFiller offset: 6;
		defineField: #bfReserved2 type: UInt16Field new beFiller offset: 8;
		defineField: #bfOffBits type: UInt32Field new offset: 10.
	self byteSize: 14!

getFieldNames
	^#(#bfType #bfSize #bfOffBits)!

packing
	"Answer the default packing for instances of the receiver. 
	BITMAPFILEHEADER is unusual for a Windows structure in being packed to 
	2-byte boundaries - probably a 16-bit inheritance."

	^2! !
!OS.BITMAPFILEHEADER class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
packing!constants!public! !
!

