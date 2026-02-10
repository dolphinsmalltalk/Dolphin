"Filed out from Dolphin Smalltalk"!

OS.COM.CountedArray
	subclass: #'OS.COM.CAUH'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_CAUH_Size' -> 16r8 }!

OS.COM.CAUH guid: (Core.GUID fromString: '{8616c5ef-682a-4de5-b644-3a569751b285}')!

OS.COM.CAUH comment: '`CAUH` is an `External.Structure` class to wrap the struct ''WIC.CAUH'' from type information in the ''Windows Imaging Component API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef 
struct tagCAUH {
	ULONG cElems;
	[size_is("cElems")] ULARGE_INTEGER* pElems;
} CAUH;
```
'!

!OS.COM.CAUH categoriesForClass!External-Data-Structured-COM! !

!OS.COM.CAUH class methodsFor!

byteSize
	^_CAUH_Size!

defineFields
	"Define the fields of the CAUH structure.

	CAUH compileDefinition

		typedef 
		struct tagCAUH {
			ULONG cElems;
			[size_is('cElems')] ULARGE_INTEGER* pElems;
		} CAUH;
"

	self
		defineField: #cElems type: UInt32Field new offset: 0;
		defineField: #pElems type: (ArrayPointerField type: UInt64Array lengthField: #cElems) offset: 4.
	self byteSize: 8!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^UInt64! !

!OS.COM.CAUH class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
elementClass!constants!public! !
!

