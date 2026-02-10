"Filed out from Dolphin Smalltalk"!

OS.COM.CountedArray
	subclass: #'OS.COM.CADATE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_CADATE_Size' -> 16r8 }!

OS.COM.CADATE guid: (Core.GUID fromString: '{0ead85a6-7b73-4323-a012-4505121ba2f3}')!

OS.COM.CADATE comment: '`CADATE` is an `External.Structure` class to wrap the struct ''WIC.CADATE'' from type information in the ''Windows Imaging Component API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef 
struct tagCADATE {
	ULONG cElems;
	[size_is("cElems")] DATE* pElems;
} CADATE;
```
'!

!OS.COM.CADATE categoriesForClass!External-Data-Structured-COM! !

!OS.COM.CADATE class methodsFor!

byteSize
	^_CADATE_Size!

defineFields
	"Define the fields of the CADATE structure.

	CADATE compileDefinition

		typedef 
		struct tagCADATE {
			ULONG cElems;
			[size_is('cElems')] DATE* pElems;
		} CADATE;
"

	self
		defineField: #cElems type: UInt32Field new offset: 0;
		defineField: #pElems type: (ArrayPointerField type: DATEArray lengthField: #cElems) offset: 4.
	self byteSize: 8!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^DATE
! !

!OS.COM.CADATE class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
elementClass!constants!public! !
!

