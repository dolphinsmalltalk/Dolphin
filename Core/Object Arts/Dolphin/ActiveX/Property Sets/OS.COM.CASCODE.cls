"Filed out from Dolphin Smalltalk"!

OS.COM.CountedArray
	subclass: #'OS.COM.CASCODE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_CASCODE_Size' -> 16r8 }!

OS.COM.CASCODE guid: (Core.GUID fromString: '{dc7b004e-8e0b-4138-858d-12680ba92fa2}')!

OS.COM.CASCODE comment: '`CASCODE` is an `External.Structure` class to wrap the struct ''WIC.CASCODE'' from type information in the ''Windows Imaging Component API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef 
struct tagCASCODE {
	ULONG cElems;
	[size_is("cElems")] SCODE* pElems;
} CASCODE;
```
'!

!OS.COM.CASCODE categoriesForClass!External-Data-Structured-COM! !

!OS.COM.CASCODE class methodsFor!

byteSize
	^_CASCODE_Size!

defineFields
	"Define the fields of the CASCODE structure.

	CASCODE compileDefinition

		typedef 
		struct tagCASCODE {
			ULONG cElems;
			[size_is('cElems')] SCODE* pElems;
		} CASCODE;
"

	self
		defineField: #cElems type: UInt32Field new offset: 0;
		defineField: #pElems type: (ArrayPointerField type: HRESULTArray lengthField: #cElems) offset: 4.
	self byteSize: 8!

elementClass
	^HRESULT! !

!OS.COM.CASCODE class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
elementClass!constants!public! !
!

