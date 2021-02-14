"Filed out from Dolphin Smalltalk 7"!

OS.COM.CountedArray subclass: #'OS.COM.CALPOLESTR'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.CALPOLESTR guid: (Core.GUID fromString: '{b4cb3d32-bc0e-4c28-8f52-10f224f37e2f}')!
OS.COM.CALPOLESTR comment: '<CALPOLESTR> is an <ExternalStructure> class to wrap the struct ''OCIDL.CALPOLESTR'' from type information in the ''OCIDL Library'' library.

CALPOLESTR is a counted array of Unicode strings. For an example usage see IPerPropertyBrowsing.'!
!OS.COM.CALPOLESTR categoriesForClass!OCIDL-Structs! !
!OS.COM.CALPOLESTR methodsFor!

basicFree
	"Private - Free external resources owned by the receiver.
	Not only is the array allocated from the task heap, but also each of the individual strings in it."

	| allocator pElems |
	allocator := TaskMemory allocator.
	pElems := self pElems.
	0 to: self length - 1
		do: [:i | allocator Free: (pElems uintPtrAtOffset: i * VMConstants.IntPtrSize)].
	super basicFree!

getElements
	"Private - Answer the receiver's <ExternalArray> of elements."

	^StructureArray 
		fromAddress: self pElems
		length: self cElems
		elementClass: self elementClass! !
!OS.COM.CALPOLESTR categoriesFor: #basicFree!private!realizing/unrealizing! !
!OS.COM.CALPOLESTR categoriesFor: #getElements!accessing!private! !

!OS.COM.CALPOLESTR class methodsFor!

defineFields
	"Define the fields of the CALPOLESTR structure.
		CALPOLESTR compileDefinition
	
		typedef 		struct tagCALPOLESTR {
			unsigned long cElems;
			LPWSTR* pElems;
		} CALPOLESTR;

	"

	"Element type is different, but override with hand-coded accessor"
	super defineFields.!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^LPWSTR
! !
!OS.COM.CALPOLESTR class categoriesFor: #defineFields!public!template definition! !
!OS.COM.CALPOLESTR class categoriesFor: #elementClass!constants!public! !

