"Filed out from Dolphin Smalltalk"!

OS.COM.CountedArray
	subclass: #'OS.COM.CADBL'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_CADBL_Size' -> 16r8 }!

OS.COM.CADBL guid: (Core.GUID fromString: '{86dbcc86-3b93-44ae-a118-fc4ebd7587d9}')!

OS.COM.CADBL comment: '`CADBL` is an `External.Structure` class to wrap the struct ''WIC.CADBL'' from type information in the ''Windows Imaging Component API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef 
struct tagCADBL {
	ULONG cElems;
	[size_is("cElems")] double* pElems;
} CADBL;
```
'!

!OS.COM.CADBL categoriesForClass!External-Data-Structured-COM! !

!OS.COM.CADBL class methodsFor!

byteSize
	^_CADBL_Size!

defineFields
	"Define the fields of the CADBL structure.

	CADBL compileDefinition

		typedef 
		struct tagCADBL {
			ULONG cElems;
			[size_is('cElems')] double* pElems;
		} CADBL;
"

	self
		defineField: #cElems type: UInt32Field new offset: 0;
		defineField: #pElems type: (ArrayPointerField type: DOUBLEArray lengthField: #cElems) offset: 4.
	self byteSize: 8!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^DOUBLE
! !

!OS.COM.CADBL class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
elementClass!constants!public! !
!

