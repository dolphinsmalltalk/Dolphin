"Filed out from Dolphin Smalltalk"!

OS.COM.CountedArray
	subclass: #'OS.COM.CAPROPVARIANT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_CAPROPVARIANT_Size' -> 16r8 }!

OS.COM.CAPROPVARIANT guid: (Core.GUID fromString: '{c4c3c39f-594a-4169-88d8-a16bd13bf618}')!

OS.COM.CAPROPVARIANT comment: '`CAPROPVARIANT` is an `External.Structure` class to wrap the Win32/COM Property Storage structure of the same name.

CAPROPVARIANT represents a counted array of `PROPVARIANT`s

Defined in PropIdlBase.idl as follows:
```
typedef 
struct tagCAPROPVARIANT {
	ULONG cElems;
	[size_is("cElems")] _inner_PROPVARIANT* pElems;
} CAPROPVARIANT;
```
'!

!OS.COM.CAPROPVARIANT categoriesForClass!External-Data-Structured-COM! !

!OS.COM.CAPROPVARIANT methodsFor!

basicFree
	"Private - Free external resources owned by the receiver.
	In this case we need to clear each PROPVARIANT element before free'ing the COM task memory block of the array."

	| pElems |
	pElems := bytes uintPtrAtOffset: _OffsetOf_pElems.
	pElems to: pElems + ((self length - 1) * self elementSize)
		by: PROPVARIANT._PROPVARIANT_Size
		do: [:ppropvar | Ole32 propVariantClear: ppropvar].
	super basicFree! !

!OS.COM.CAPROPVARIANT categoriesForMethods!
basicFree!private!realizing/unrealizing! !
!

!OS.COM.CAPROPVARIANT class methodsFor!

byteSize
	^_CAPROPVARIANT_Size!

defineFields
	"Define the fields of the CAPROPVARIANT structure.

	CAPROPVARIANT compileDefinition

		typedef 
		struct tagCAPROPVARIANT {
			ULONG cElems;
			[size_is('cElems')] PROPVARIANT* pElems;
		} CAPROPVARIANT;
"

	self
		defineField: #cElems type: UInt32Field new offset: 0;
		defineField: #pElems type: (StructureArrayPointerField type: PROPVARIANT lengthField: #cElems) offset: 4.
	self byteSize: 8!

elementClass
	^PROPVARIANT! !

!OS.COM.CAPROPVARIANT class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
elementClass!constants!public! !
!

