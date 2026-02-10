"Filed out from Dolphin Smalltalk"!

OS.COM.CountedArray
	subclass: #'OS.COM.CAI'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_CAI_Size' -> 16r8 }!

OS.COM.CAI guid: (Core.GUID fromString: '{4453fd7d-a0aa-4a93-b54e-bd2dc514cb05}')!

OS.COM.CAI comment: '`CAI` is an `External.Structure` class to wrap the struct ''WIC.CAI'' from type information in the ''Windows Imaging Component API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef 
struct tagCAI {
	ULONG cElems;
	[size_is("cElems")] short* pElems;
} CAI;
```
'!

!OS.COM.CAI categoriesForClass!External-Data-Structured-COM! !

!OS.COM.CAI class methodsFor!

byteSize
	^_CAI_Size!

defineFields
	"Define the fields of the CAI structure.

	CAI compileDefinition

		typedef 
		struct tagCAI {
			ULONG cElems;
			[size_is('cElems')] short* pElems;
		} CAI;
"

	self
		defineField: #cElems type: UInt32Field new offset: 0;
		defineField: #pElems type: (ArrayPointerField type: Int16Array lengthField: #cElems) offset: 4.
	self byteSize: 8!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^Int16
! !

!OS.COM.CAI class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
elementClass!constants!public! !
!

