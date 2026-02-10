"Filed out from Dolphin Smalltalk"!

OS.COM.CountedArray
	subclass: #'OS.COM.CACLSID'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_CACLSID_Size' -> 16r8 }!

OS.COM.CACLSID guid: (Core.GUID fromString: '{f2be4881-1a19-44d3-87ed-e86045f75273}')!

OS.COM.CACLSID comment: '`CACLSID` is an `External.Structure` class to wrap the struct ''WIC.CACLSID'' from type information in the ''Windows Imaging Component API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef 
struct tagCACLSID {
	ULONG cElems;
	[size_is("cElems")] GUID* pElems;
} CACLSID;
```
'!

!OS.COM.CACLSID categoriesForClass!External-Data-Structured-COM! !

!OS.COM.CACLSID class methodsFor!

byteSize
	^_CACLSID_Size!

defineFields
	"Define the fields of the CACLSID structure.

	CACLSID compileDefinition

		typedef 
		struct tagCACLSID {
			ULONG cElems;
			[size_is('cElems')] CLSID* pElems;
		} CACLSID;
"

	self
		defineField: #cElems type: UInt32Field new offset: 0;
		defineField: #pElems type: (ArrayPointerField type: CLSIDArray lengthField: #cElems) offset: 4.
	self byteSize: 8!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^CLSID
! !

!OS.COM.CACLSID class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
elementClass!constants!public! !
!

