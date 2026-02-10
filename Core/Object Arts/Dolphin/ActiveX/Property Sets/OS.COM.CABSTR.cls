"Filed out from Dolphin Smalltalk"!

OS.COM.CountedArrayOfHeapPointers
	subclass: #'OS.COM.CABSTR'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_CABSTR_Size' -> 16r8 }!

OS.COM.CABSTR guid: (Core.GUID fromString: '{e0bccf01-564a-45c9-a4cc-e11fe2aa2f48}')!

OS.COM.CABSTR comment: '`CABSTR` is an `External.Structure` class to wrap the Win32/COM Property Storage structure of the same name.

CABSTR represents a counted array of BSTRs (OLE Automation strings).

Defined in PropIdlBase.idl as follows:
```
typedef 
struct tagCABSTR {
	ULONG cElems;
	[size_is("cElems")] BSTR* pElems;
} CABSTR;
```
'!

!OS.COM.CABSTR categoriesForClass!External-Data-Structured-COM! !

!OS.COM.CABSTR class methodsFor!

byteSize
	^_CABSTR_Size!

defineFields
	"Define the fields of the CABSTR structure.

	CABSTR compileDefinition

		typedef 
		struct tagCABSTR {
			ULONG cElems;
			[size_is('cElems')] BSTR* pElems;
		} CABSTR;
"

	self
		defineField: #cElems type: UInt32Field new offset: 0;
		defineField: #pElems type: (PointerField type: BSTR) offset: 4.
	self byteSize: 8!

elementClass
	^BSTR! !

!OS.COM.CABSTR class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
elementClass!constants!public! !
!

