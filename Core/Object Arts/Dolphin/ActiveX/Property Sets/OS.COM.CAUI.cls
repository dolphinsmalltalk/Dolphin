"Filed out from Dolphin Smalltalk"!

OS.COM.CountedArray
	subclass: #'OS.COM.CAUI'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_CAUI_Size' -> 16r8 }!

OS.COM.CAUI guid: (Core.GUID fromString: '{2bbe0a85-b3a1-4e5a-a7b9-e42a89bd3a35}')!

OS.COM.CAUI comment: '`CAUI` is an `External.Structure` class to wrap the struct ''WIC.CAUI'' from type information in the ''Windows Imaging Component API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef 
struct tagCAUI {
	ULONG cElems;
	[size_is("cElems")] USHORT* pElems;
} CAUI;
```
'!

!OS.COM.CAUI categoriesForClass!External-Data-Structured-COM! !

!OS.COM.CAUI class methodsFor!

byteSize
	^_CAUI_Size!

defineFields
	"Define the fields of the CAUI structure.

	CAUI compileDefinition

		typedef 
		struct tagCAUI {
			ULONG cElems;
			[size_is('cElems')] USHORT* pElems;
		} CAUI;
"

	self
		defineField: #cElems type: UInt32Field new offset: 0;
		defineField: #pElems type: (ArrayPointerField type: UInt16Array lengthField: #cElems) offset: 4.
	self byteSize: 8!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^UInt16
! !

!OS.COM.CAUI class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
elementClass!constants!public! !
!

