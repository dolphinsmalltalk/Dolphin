"Filed out from Dolphin Smalltalk"!

OS.COM.CountedArrayOfHeapPointers
	subclass: #'OS.COM.CALPOLESTR'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_CALPOLESTR_Size' -> 16r8 }!

OS.COM.CALPOLESTR guid: (Core.GUID fromString: '{b4cb3d32-bc0e-4c28-8f52-10f224f37e2f}')!

OS.COM.CALPOLESTR comment: '`CALPOLESTR` is an `External.Structure` class to wrap the Win32/OLE structure of the same name.

CALPOLESTR represents a counted array of Unicode strings. For an example usage see IPerPropertyBrowsing.

The CALPWSTR structure defined in COM Property Storage is a duplicate definition, defined in PropIdlBase.idl as follows:

```
typedef 
struct tagCALPWSTR {
	ULONG cElems;
	[size_is("cElems")] LPWSTR* pElems;
} CALPWSTR;
```
'!

!OS.COM.CALPOLESTR categoriesForClass!External-Data-Structured-COM! !

!OS.COM.CALPOLESTR class methodsFor!

byteSize
	^_CALPOLESTR_Size!

defineFields
	"Define the fields of the CALPOLESTR structure.
		CALPOLESTR compileDefinition
	
		typedef 		struct tagCALPOLESTR {
			ULONG cElems;
			[size_is('cElems')] LPWSTR* pElems;
		} CALPOLESTR;

	"

	self
		defineField: #cElems type: UInt32Field new offset: 0;
		defineField: #pElems type: (ArrayPointerField type: LPWSTRArray lengthField: #cElems) offset: 4.
	self byteSize: 8!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^LPWSTR
! !

!OS.COM.CALPOLESTR class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
elementClass!constants!public! !
!

