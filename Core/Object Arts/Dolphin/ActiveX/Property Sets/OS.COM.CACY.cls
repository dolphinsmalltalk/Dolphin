"Filed out from Dolphin Smalltalk"!

OS.COM.CountedArray
	subclass: #'OS.COM.CACY'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_CACY_Size' -> 16r8 }!

OS.COM.CACY guid: (Core.GUID fromString: '{ba1e18cf-47ec-4a52-b6d8-fa88db2f80db}')!

OS.COM.CACY comment: '`CACY` is an `External.Structure` class to wrap the struct ''WIC.CACY'' from type information in the ''Windows Imaging Component API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef 
struct tagCACY {
	ULONG cElems;
	[size_is("cElems")] CURRENCY* pElems;
} CACY;
```
'!

!OS.COM.CACY categoriesForClass!External-Data-Structured-COM! !

!OS.COM.CACY class methodsFor!

byteSize
	^_CACY_Size!

defineFields
	"Define the fields of the CACY structure.

	CACY compileDefinition

		typedef 
		struct tagCACY {
			ULONG cElems;
			[size_is('cElems')] CY* pElems;
		} CACY;
"

	self
		defineField: #cElems type: UInt32Field new offset: 0;
		defineField: #pElems type: (ArrayPointerField type: CYArray lengthField: #cElems) offset: 4.
	self byteSize: 8!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^CY
! !

!OS.COM.CACY class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
elementClass!constants!public! !
!

