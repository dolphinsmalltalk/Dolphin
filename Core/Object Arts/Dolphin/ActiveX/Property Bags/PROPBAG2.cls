"Filed out from Dolphin Smalltalk X6.1"!

OLEStructure subclass: #PROPBAG2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PROPBAG2 guid: (GUID fromString: '{B5EBE54F-D5B4-4606-9447-90B11844193F}')!
PROPBAG2 comment: '<PROPBAG2> is an <ExternalStructure> class to wrap the struct ''OCIDL.PROPBAG2'' from type information in the ''OCIDL Library'' library.
'!
!PROPBAG2 categoriesForClass!OCIDL-Structs! !
!PROPBAG2 methodsFor!

cfType
	"Answer the receiver's cfType field as a Smalltalk object."

	^(bytes wordAtOffset: 6)!

cfType: anObject
	"Set the receiver's cfType field to the value of anObject."

	bytes wordAtOffset: 6 put: anObject!

clsid
	"Answer the receiver's clsid field as a Smalltalk object."

	^GUID fromAddress: (bytes yourAddress + 16)!

clsid: anObject
	"Set the receiver's clsid field to the value of anObject."

	anObject replaceBytesOf: bytes from: 17 to: 32 startingAt: 1!

dwHint
	"Answer the receiver's dwHint field as a Smalltalk object."

	^(bytes dwordAtOffset: 8)!

dwHint: anObject
	"Set the receiver's dwHint field to the value of anObject."

	bytes dwordAtOffset: 8 put: anObject!

dwType
	"Answer the receiver's dwType field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

dwType: anObject
	"Set the receiver's dwType field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

pstrName
	"Answer the receiver's pstrName field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: 12)!

pstrName: anObject 
	"Set the receiver's pstrName field to the value of anObject."

	bytes uintPtrAtOffset: 12 put: anObject yourAddress!

vt
	"Answer the receiver's vt field as a Smalltalk object."

	^(bytes wordAtOffset: 4)!

vt: anObject
	"Set the receiver's vt field to the value of anObject."

	bytes wordAtOffset: 4 put: anObject! !
!PROPBAG2 categoriesFor: #cfType!**compiled accessors**!public! !
!PROPBAG2 categoriesFor: #cfType:!**compiled accessors**!public! !
!PROPBAG2 categoriesFor: #clsid!**compiled accessors**!public! !
!PROPBAG2 categoriesFor: #clsid:!**compiled accessors**!public! !
!PROPBAG2 categoriesFor: #dwHint!**compiled accessors**!public! !
!PROPBAG2 categoriesFor: #dwHint:!**compiled accessors**!public! !
!PROPBAG2 categoriesFor: #dwType!**compiled accessors**!public! !
!PROPBAG2 categoriesFor: #dwType:!**compiled accessors**!public! !
!PROPBAG2 categoriesFor: #pstrName!**compiled accessors**!public! !
!PROPBAG2 categoriesFor: #pstrName:!**compiled accessors**!public! !
!PROPBAG2 categoriesFor: #vt!**compiled accessors**!public! !
!PROPBAG2 categoriesFor: #vt:!**compiled accessors**!public! !

!PROPBAG2 class methodsFor!

defineFields
	"Define the fields of the PROPBAG2 structure.
		PROPBAG2 compileDefinition
	
		typedef 		struct tagPROPBAG2 {
			unsigned long dwType;
			unsigned short vt;
			CLIPFORMAT cfType;
			unsigned long dwHint;
			LPWSTR pstrName;
			GUID clsid;
		} PROPBAG2;

	"

	self
		defineField: #dwType type: DWORDField new;
		defineField: #vt type: WORDField new;
		defineField: #cfType type: WORDField new;
		defineField: #dwHint type: DWORDField new;
		defineField: #pstrName type: (PointerField type: UnicodeString);
		defineField: #clsid type: (StructureField type: GUID)! !
!PROPBAG2 class categoriesFor: #defineFields!initializing!public! !

