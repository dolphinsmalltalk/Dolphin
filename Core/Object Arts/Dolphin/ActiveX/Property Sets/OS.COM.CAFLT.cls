"Filed out from Dolphin Smalltalk"!

OS.COM.CountedArray
	subclass: #'OS.COM.CAFLT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_CAFLT_Size' -> 16r8 }!

OS.COM.CAFLT guid: (Core.GUID fromString: '{7c59d51f-32ec-4630-a15a-032f1cf324ee}')!

OS.COM.CAFLT comment: '`CAFLT` is an `External.Structure` class to wrap the struct ''WIC.CAFLT'' from type information in the ''Windows Imaging Component API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef 
struct tagCAFLT {
	ULONG cElems;
	[size_is("cElems")] float* pElems;
} CAFLT;
```
'!

!OS.COM.CAFLT categoriesForClass!External-Data-Structured-COM! !

!OS.COM.CAFLT class methodsFor!

byteSize
	^_CAFLT_Size!

defineFields
	"Define the fields of the CAFLT structure.

	CAFLT compileDefinition

		typedef 
		struct tagCAFLT {
			ULONG cElems;
			[size_is('cElems')] float* pElems;
		} CAFLT;
"

	self
		defineField: #cElems type: UInt32Field new offset: 0;
		defineField: #pElems type: (ArrayPointerField type: FLOATArray lengthField: #cElems) offset: 4.
	self byteSize: 8!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^FLOAT
! !

!OS.COM.CAFLT class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
elementClass!constants!public! !
!

