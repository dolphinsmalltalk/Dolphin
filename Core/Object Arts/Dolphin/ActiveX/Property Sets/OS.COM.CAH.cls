"Filed out from Dolphin Smalltalk"!

OS.COM.CountedArray
	subclass: #'OS.COM.CAH'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_CAH_Size' -> 16r8 }!

OS.COM.CAH guid: (Core.GUID fromString: '{33932fc3-3d20-4e3e-8057-f3f6d31cdd6c}')!

OS.COM.CAH comment: '`CAH` is an `External.Structure` class to wrap the struct ''WIC.CAH'' from type information in the ''Windows Imaging Component API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef 
struct tagCAH {
	ULONG cElems;
	[size_is("cElems")] LARGE_INTEGER* pElems;
} CAH;
```
'!

!OS.COM.CAH categoriesForClass!External-Data-Structured-COM! !

!OS.COM.CAH class methodsFor!

byteSize
	^_CAH_Size!

defineFields
	"Define the fields of the CAH structure.

	CAH compileDefinition

		typedef 
		struct tagCAH {
			ULONG cElems;
			[size_is('cElems')] LARGE_INTEGER* pElems;
		} CAH;
"

	self
		defineField: #cElems type: UInt32Field new offset: 0;
		defineField: #pElems type: (ArrayPointerField type: Int64Array lengthField: #cElems) offset: 4.
	self byteSize: 8!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^Int64
! !

!OS.COM.CAH class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
elementClass!constants!public! !
!

