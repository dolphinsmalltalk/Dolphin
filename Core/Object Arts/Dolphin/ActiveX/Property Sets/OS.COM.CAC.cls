"Filed out from Dolphin Smalltalk"!

OS.COM.CountedArray
	subclass: #'OS.COM.CAC'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_CAC_Size' -> 16r8 }!

OS.COM.CAC guid: (Core.GUID fromString: '{9374d3d3-c1ee-40d5-9d84-532e8c0e66a6}')!

OS.COM.CAC comment: '`CAC` is an `External.Structure` class to wrap the struct ''WIC.CAC'' from type information in the ''Windows Imaging Component API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef 
struct tagCAC {
	ULONG cElems;
	[size_is("cElems")] BYTE* pElems;
} CAC;
```
'!

!OS.COM.CAC categoriesForClass!External-Data-Structured-COM! !

!OS.COM.CAC class methodsFor!

byteSize
	^_CAC_Size!

defineFields
	"Define the fields of the CAC structure.

	CAC compileDefinition

		typedef 
		struct tagCAC {
			ULONG cElems;
			[size_is('cElems')] BYTE* pElems;
		} CAC;
"

	self
		defineField: #cElems type: UInt32Field new offset: 0;
		defineField: #pElems type: (ArrayPointerField type: Int8Array lengthField: #cElems) offset: 4.
	self byteSize: 8!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^Int8
! !

!OS.COM.CAC class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
elementClass!constants!public! !
!

