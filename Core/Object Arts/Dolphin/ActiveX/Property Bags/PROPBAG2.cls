"Filed out from Dolphin Smalltalk 7"!

OLEStructure subclass: #PROPBAG2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cfType' -> 16r6.
		'_OffsetOf_clsid' -> 16r10.
		'_OffsetOf_dwHint' -> 16r8.
		'_OffsetOf_dwType' -> 16r0.
		'_OffsetOf_pstrName' -> 16rC.
		'_OffsetOf_vt' -> 16r4
	}!
PROPBAG2 guid: (GUID fromString: '{b5ebe54f-d5b4-4606-9447-90b11844193f}')!
PROPBAG2 comment: '<PROPBAG2> is an <ExternalStructure> class to wrap the struct ''OCIDL.PROPBAG2'' from type information in the ''OCIDL Library'' library.
'!
!PROPBAG2 categoriesForClass!OCIDL-Structs! !
!PROPBAG2 methodsFor!

cfType
	"Answer the <Integer> value of the receiver's 'cfType' field."

	^bytes wordAtOffset: _OffsetOf_cfType!

cfType: anInteger
	"Set the receiver's 'cfType' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_cfType put: anInteger!

clsid
	"Answer the <GUID> value of the receiver's 'clsid' field."

	^GUID fromAddress: bytes yourAddress + _OffsetOf_clsid!

clsid: aGUID
	"Set the receiver's 'clsid' field to the value of the argument, aGUID"

	aGUID
		replaceBytesOf: bytes
		from: ##(_OffsetOf_clsid + 1)
		to: ##(_OffsetOf_clsid + GUID basicByteSize)
		startingAt: 1!

dwHint
	"Answer the <Integer> value of the receiver's 'dwHint' field."

	^bytes dwordAtOffset: _OffsetOf_dwHint!

dwHint: anInteger
	"Set the receiver's 'dwHint' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwHint put: anInteger!

dwType
	"Answer the <Integer> value of the receiver's 'dwType' field."

	^bytes dwordAtOffset: _OffsetOf_dwType!

dwType: anInteger
	"Set the receiver's 'dwType' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwType put: anInteger!

pstrName
	"Answer the <Utf16String> value of the receiver's 'pstrName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pstrName)!

pstrName: anUtf16String
	"Set the receiver's 'pstrName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pstrName put: anUtf16String yourAddress!

vt
	"Answer the <Integer> value of the receiver's 'vt' field."

	^bytes wordAtOffset: _OffsetOf_vt!

vt: anInteger
	"Set the receiver's 'vt' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_vt put: anInteger! !
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
		defineField: #pstrName type: (PointerField type: Utf16String);
		defineField: #clsid type: (StructureField type: GUID)!

getFieldNames
	^#(#dwType #vt #cfType #dwHint #pstrName #clsid)! !
!PROPBAG2 class categoriesFor: #defineFields!public!template definition! !
!PROPBAG2 class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

