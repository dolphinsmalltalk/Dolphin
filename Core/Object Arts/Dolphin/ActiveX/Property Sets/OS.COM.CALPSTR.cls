"Filed out from Dolphin Smalltalk"!

OS.COM.CountedArrayOfHeapPointers
	subclass: #'OS.COM.CALPSTR'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_CALPSTR_Size' -> 16r8 }!

OS.COM.CALPSTR guid: (Core.GUID fromString: '{914a78eb-eec0-4e36-8e2c-f82fd27fad5e}')!

OS.COM.CALPSTR comment: '`CALPSTR` is an `External.Structure` class to wrap the Win32/COM Property Storage structure of the same name.

CALPOLESTR represents a counted array of Ansi strings.

Defined in PropIdlBase.idl as follows:
```
typedef 
struct tagCALPSTR {
	ULONG cElems;
	[size_is("cElems")] LPSTR* pElems;
} CALPSTR;
```
'!

!OS.COM.CALPSTR categoriesForClass!External-Data-Structured-COM! !

!OS.COM.CALPSTR class methodsFor!

byteSize
	^_CALPSTR_Size!

defineFields
	"Define the fields of the CALPSTR structure.

	CALPSTR compileDefinition

		typedef 
		struct tagCALPSTR {
			ULONG cElems;
			[size_is('cElems')] LPSTR* pElems;
		} CALPSTR;
"

	self
		defineField: #cElems type: UInt32Field new offset: 0;
		defineField: #pElems type: (ArrayPointerField type: AnsiString lengthField: #cElems) offset: 4.
	self byteSize: 8!

elementClass
	^LPSTR! !

!OS.COM.CALPSTR class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
elementClass!constants!public! !
!

