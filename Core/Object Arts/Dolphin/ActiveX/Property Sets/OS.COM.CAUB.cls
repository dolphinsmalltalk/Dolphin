"Filed out from Dolphin Smalltalk"!

OS.COM.CountedArray
	subclass: #'OS.COM.CAUB'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_CAUB_Size' -> 16r8 }!

OS.COM.CAUB guid: (Core.GUID fromString: '{114bef6d-73a2-4aa7-85a7-082831a15710}')!

OS.COM.CAUB comment: '`CAUB` is an `External.Structure` class to wrap the struct ''WIC.CAUB'' from type information in the ''Windows Imaging Component API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef 
struct tagCAUB {
	ULONG cElems;
	[size_is("cElems")] UCHAR* pElems;
} CAUB;
```
'!

!OS.COM.CAUB categoriesForClass!External-Data-Structured-COM! !

!OS.COM.CAUB class methodsFor!

byteSize
	^_CAUB_Size!

defineFields
	"Define the fields of the CAUB structure.

	CAUB compileDefinition

		typedef 
		struct tagCAUB {
			ULONG cElems;
			[size_is('cElems')] UCHAR* pElems;
		} CAUB;
"

	self
		defineField: #cElems type: UInt32Field new offset: 0;
		defineField: #pElems type: (ArrayPointerField type: UInt8Array lengthField: #cElems) offset: 4.
	self byteSize: 8!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^UInt8
! !

!OS.COM.CAUB class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
elementClass!constants!public! !
!

