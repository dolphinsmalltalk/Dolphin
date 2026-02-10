"Filed out from Dolphin Smalltalk"!

OS.COM.CountedArray
	subclass: #'OS.COM.CAL'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_CAL_Size' -> 16r8 }!

OS.COM.CAL guid: (Core.GUID fromString: '{dfb528e0-98da-4063-a18b-3fd61164703d}')!

OS.COM.CAL comment: '`CAL` is an `External.Structure` class to wrap the struct ''WIC.CAL'' from type information in the ''Windows Imaging Component API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef 
struct tagCAL {
	ULONG cElems;
	[size_is("cElems")] long* pElems;
} CAL;
```
'!

!OS.COM.CAL categoriesForClass!External-Data-Structured-COM! !

!OS.COM.CAL class methodsFor!

byteSize
	^_CAL_Size!

defineFields
	"Define the fields of the CAL structure.

	CAL compileDefinition

		typedef 
		struct tagCAL {
			ULONG cElems;
			[size_is('cElems')] long* pElems;
		} CAL;
"

	self
		defineField: #cElems type: UInt32Field new offset: 0;
		defineField: #pElems type: (ArrayPointerField type: Int32Array lengthField: #cElems) offset: 4.
	self byteSize: 8!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^Int32
! !

!OS.COM.CAL class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
elementClass!constants!public! !
!

