"Filed out from Dolphin Smalltalk"!

OS.COM.CountedArray
	subclass: #'OS.COM.CAFILETIME'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_CAFILETIME_Size' -> 16r8 }!

OS.COM.CAFILETIME guid: (Core.GUID fromString: '{767cc74d-98ef-497f-8439-7d5f7dc0fd59}')!

OS.COM.CAFILETIME comment: '`CAFILETIME` is an `External.Structure` class to wrap the struct ''WIC.CAFILETIME'' from type information in the ''Windows Imaging Component API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef 
struct tagCAFILETIME {
	ULONG cElems;
	[size_is("cElems")] FILETIME* pElems;
} CAFILETIME;
```
'!

!OS.COM.CAFILETIME categoriesForClass!External-Data-Structured-COM! !

!OS.COM.CAFILETIME class methodsFor!

byteSize
	^_CAFILETIME_Size!

defineFields
	"Define the fields of the CAFILETIME structure.

	CAFILETIME compileDefinition

		typedef 
		struct tagCAFILETIME {
			ULONG cElems;
			[size_is('cElems')] FILETIME* pElems;
		} CAFILETIME;
"

	self
		defineField: #cElems type: UInt32Field new offset: 0;
		defineField: #pElems type: (ArrayPointerField type: FILETIMEArray lengthField: #cElems) offset: 4.
	self byteSize: 8!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^FILETIME
! !

!OS.COM.CAFILETIME class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
elementClass!constants!public! !
!

