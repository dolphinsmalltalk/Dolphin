"Filed out from Dolphin Smalltalk"!

OLEStructure subclass: #PROPBAG2
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cfType _OffsetOf_clsid _OffsetOf_dwHint _OffsetOf_dwType _OffsetOf_pstrName _OffsetOf_vt'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PROPBAG2 guid: (GUID fromString: '{b5ebe54f-d5b4-4606-9447-90b11844193f}')!

PROPBAG2 addClassConstant: '_OffsetOf_cfType' value: 16r6!
PROPBAG2 addClassConstant: '_OffsetOf_clsid' value: 16r10!
PROPBAG2 addClassConstant: '_OffsetOf_dwHint' value: 16r8!
PROPBAG2 addClassConstant: '_OffsetOf_dwType' value: 16r0!
PROPBAG2 addClassConstant: '_OffsetOf_pstrName' value: 16rC!
PROPBAG2 addClassConstant: '_OffsetOf_vt' value: 16r4!

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

!PROPBAG2 categoriesForMethods!
cfType!**compiled accessors**!public! !
cfType:!**compiled accessors**!public! !
clsid!**compiled accessors**!public! !
clsid:!**compiled accessors**!public! !
dwHint!**compiled accessors**!public! !
dwHint:!**compiled accessors**!public! !
dwType!**compiled accessors**!public! !
dwType:!**compiled accessors**!public! !
pstrName!**compiled accessors**!public! !
pstrName:!**compiled accessors**!public! !
vt!**compiled accessors**!public! !
vt:!**compiled accessors**!public! !
!

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

!PROPBAG2 class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

