"Filed out from Dolphin Smalltalk"!

OS.COM.CountedArray
	subclass: #'OS.COM.CADWORD'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_CADWORD_Size' -> 16r8 }!

OS.COM.CADWORD guid: (Core.GUID fromString: '{60f684dc-b3e2-4700-8e9c-d1a18764ed84}')!

OS.COM.CADWORD comment: '`CADWORD` is an `External.Structure` class to wrap the OLE structure of the same name.

CADWORD represents a counted array of 32-bit unsigned integers. For an example usage see IPerPropertyBrowsing.

The CAUL structure defined in COM Property Storage is a duplicate definition, defined in PropIdlBase.idl as follows:

```
typedef 
struct tagCAUL {
	ULONG cElems;
	[size_is("cElems")] ULONG* pElems;
} CAUL;
```'!

!OS.COM.CADWORD categoriesForClass!External-Data-Structured-COM! !

!OS.COM.CADWORD class methodsFor!

byteSize
	^_CADWORD_Size!

defineFields
	"Define the fields of the CADWORD structure.
		CADWORD compileDefinition
	
		typedef 		struct tagCADWORD {
			ULONG cElems;
			[size_is('cElems')] ULONG* pElems;
		} CADWORD;

	"

	self
		defineField: #cElems type: UInt32Field new offset: 0;
		defineField: #pElems type: (ArrayPointerField type: UInt32Array lengthField: #cElems) offset: 4.
	self byteSize: 8

!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^UInt32
! !

!OS.COM.CADWORD class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
elementClass!constants!public! !
!

