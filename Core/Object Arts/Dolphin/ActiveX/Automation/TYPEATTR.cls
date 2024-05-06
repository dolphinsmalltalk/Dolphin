"Filed out from Dolphin Smalltalk"!

AXTypeInfoStructure subclass: #TYPEATTR
	instanceVariableNames: 'piTypeInfo'
	classVariableNames: '_OffsetOf_cbAlignment _OffsetOf_cbSizeInstance _OffsetOf_cbSizeVft _OffsetOf_cFuncs _OffsetOf_cImplTypes _OffsetOf_cVars _OffsetOf_dwReserved _OffsetOf_guid _OffsetOf_idldescType _OffsetOf_lcid _OffsetOf_lpstrSchema _OffsetOf_memidConstructor _OffsetOf_memidDestructor _OffsetOf_tdescAlias _OffsetOf_typekind _OffsetOf_wMajorVerNum _OffsetOf_wMinorVerNum _OffsetOf_wTypeFlags'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

TYPEATTR guid: (GUID fromString: '{c06f3b69-0868-11d3-93af-00a024ca708a}')!

TYPEATTR addClassConstant: '_OffsetOf_cbAlignment' value: 16r34!
TYPEATTR addClassConstant: '_OffsetOf_cbSizeInstance' value: 16r24!
TYPEATTR addClassConstant: '_OffsetOf_cbSizeVft' value: 16r32!
TYPEATTR addClassConstant: '_OffsetOf_cFuncs' value: 16r2C!
TYPEATTR addClassConstant: '_OffsetOf_cImplTypes' value: 16r30!
TYPEATTR addClassConstant: '_OffsetOf_cVars' value: 16r2E!
TYPEATTR addClassConstant: '_OffsetOf_dwReserved' value: 16r14!
TYPEATTR addClassConstant: '_OffsetOf_guid' value: 16r0!
TYPEATTR addClassConstant: '_OffsetOf_idldescType' value: 16r44!
TYPEATTR addClassConstant: '_OffsetOf_lcid' value: 16r10!
TYPEATTR addClassConstant: '_OffsetOf_lpstrSchema' value: 16r20!
TYPEATTR addClassConstant: '_OffsetOf_memidConstructor' value: 16r18!
TYPEATTR addClassConstant: '_OffsetOf_memidDestructor' value: 16r1C!
TYPEATTR addClassConstant: '_OffsetOf_tdescAlias' value: 16r3C!
TYPEATTR addClassConstant: '_OffsetOf_typekind' value: 16r28!
TYPEATTR addClassConstant: '_OffsetOf_wMajorVerNum' value: 16r38!
TYPEATTR addClassConstant: '_OffsetOf_wMinorVerNum' value: 16r3A!
TYPEATTR addClassConstant: '_OffsetOf_wTypeFlags' value: 16r36!

TYPEATTR comment: 'TYPEATTR is an <ExternalStructure> class to represent the Active-X Automation TYPEATTR structure.

TYPEATTR contains a number of attributes describing a particular type info. element of a type library. Unfortunately it is overloaded (like its originator ITypeInfo) with the job of describing all of the different types of object for which type information may be present in the library (i.e. interfaces, typedefs, enums, coclasses, dispinterfaces, unions, structs, and modules). This means that some of the members may not be relevant to the programming element described. In general we access the members of this structure through the relevant subclass of AXTypeInfoAnalyzer, thus benefitting from the correct factoring of that hierarchy.

Fields:
	guid		<GUID> Unique id of the programming element.
	lcid		<DWORD> Locale identifier. Type information can be locale specific.
	dwReserved	<DWORD>
	memidConstructor	<SDWORD> Unique id of the constructor method (not used).
	memidDestructor	<SDWORD> Unique id of the destructor method (not used)
	lpstrSchema	<LPWSTR>. Not used.
	cbSizeInstance	<DWORD> Size in bytes of instances of the programming element, if relevant.
	typekind		<SDWORD> from the TYPEKIND enum. Type of the programming element, e.g. interface.
	cFuncs		<WORD> Number of functions/methods in the programming element.
	cVars		<WORD> Number of properties/variables/fields in the programming element.
	cImplTypes	<WORD>
	cbSizeVft		<WORD> Size of the virtual table in bytes. N.B. Implies max. 16398 vfns, but see FUNCDESC.
	cbAlignment	<WORD> Alignment requirement of the programming element when embedded in a structure.
	wTypeFlags	<WORD> Various flags, set varies by typekind.
	wMajorVerNum	<WORD> Major version number.
	wMinorVerNum	<WORD> Minor version number
	tdescAlias		<TYPEDESC> for which this is an alias (typedef).
	idldescType	<IDLDESC> providing information about the originating IDL.
'!

!TYPEATTR categoriesForClass!External-Data-Structured-COM! !

!TYPEATTR methodsFor!

basicFree
	"Private - Free external resources owned by the receiver."

	| interface |
	interface := piTypeInfo asParameter.
	interface isNull ifFalse: [interface ReleaseTypeAttr: self]!

cbAlignment
	"Answer the <Integer> value of the receiver's 'cbAlignment' field."

	^bytes wordAtOffset: _OffsetOf_cbAlignment!

cbSizeInstance
	"Answer the <Integer> value of the receiver's 'cbSizeInstance' field."

	^bytes dwordAtOffset: _OffsetOf_cbSizeInstance!

cbSizeVft
	"Answer the <Integer> value of the receiver's 'cbSizeVft' field."

	^bytes wordAtOffset: _OffsetOf_cbSizeVft!

cFuncs
	"Answer the <Integer> value of the receiver's 'cFuncs' field."

	^bytes wordAtOffset: _OffsetOf_cFuncs!

cImplTypes
	"Answer the <Integer> value of the receiver's 'cImplTypes' field."

	^bytes wordAtOffset: _OffsetOf_cImplTypes!

classDesc
	"Private - Answer an <Association> between a Dolphin class suitable for representing
	the external type described by the receiver, and the number of indirections
	to the type."

	^self tdesc classDesc!

cVars
	"Answer the <Integer> value of the receiver's 'cVars' field."

	^bytes wordAtOffset: _OffsetOf_cVars!

guid
	"Answer the <GUID> value of the receiver's 'guid' field."

	^GUID fromAddress: bytes yourAddress!

idldescType
	"Answer the <IDLDESC> value of the receiver's 'idldescType' field."

	^IDLDESC fromAddress: bytes yourAddress + _OffsetOf_idldescType!

isAggregatable
	"Answer whether the receiver is describing a coclass which
	supports aggregation."

	^self wTypeFlags allMask: TYPEFLAG_FAGGREGATABLE!

isAppObject
	"Answer whether the receiver is describing a coclass which
	is an Application level object."

	^self wTypeFlags allMask: TYPEFLAG_FAPPOBJECT!

isAutomationCompatible
	"Answer whether the receiver is describing an interface which 
	is OLE Automation compatible. This doesn't mean that the class
	must be derived from IDispatch, just that only uses automation
	compatible types."

	^self wTypeFlags allMask: TYPEFLAG_FOLEAUTOMATION
!

isControl
	"Answer whether the receiver is describing a control."

	^self wTypeFlags allMask: TYPEFLAG_FCONTROL!

isDispatchable
	"Answer whether the receiver is derived directly or indirectly from IDispatch."

	^self wTypeFlags allMask: TYPEFLAG_FDISPATCHABLE

!

isExtensible
	"Answer whether the receiver is describing a dynamically extensible interface
	(i.e. one which may add new methods and properties at run-time)."

	^self wTypeFlags noMask: TYPEFLAG_FNONEXTENSIBLE!

isInstantiable
	"Answer whether the receiver is describing a coclass which can be
	instantiated with CoCreateInstance."

	^self wTypeFlags allMask: TYPEFLAG_FCANCREATE!

isLicensed
	"Answer whether the receiver is describing a licensed coclass."

	^self wTypeFlags allMask: TYPEFLAG_FLICENSED!

isRestricted
	"Answer whether the receiver is describing a restricted type (i.e. one not
	intended to be used from macro/scripting languages).
	Applicable to all typekinds."

	^self wTypeFlags allMask: TYPEFLAG_FRESTRICTED!

lcid
	"Answer the <Integer> value of the receiver's 'lcid' field."

	^bytes dwordAtOffset: _OffsetOf_lcid!

memidConstructor
	"Answer the <Integer> value of the receiver's 'memidConstructor' field."

	^bytes sdwordAtOffset: _OffsetOf_memidConstructor!

memidDestructor
	"Answer the <Integer> value of the receiver's 'memidDestructor' field."

	^bytes sdwordAtOffset: _OffsetOf_memidDestructor!

name
	"Answer the name of the variable described by the receiver."

	^self shouldNotImplement!

piTypeInfo: anITypeInfo
	piTypeInfo := anITypeInfo!

tdesc
	"Answer a TYPEDESC describing the type for which the receiver describes an alias (typedef)."

	^self tdescAlias
		owner: self!

tdescAlias
	"Answer the <TYPEDESC> value of the receiver's 'tdescAlias' field."

	^TYPEDESC fromAddress: bytes yourAddress + _OffsetOf_tdescAlias!

typekind
	"Answer the <Integer> value of the receiver's 'typekind' field."

	^bytes sdwordAtOffset: _OffsetOf_typekind!

wMajorVerNum
	"Answer the <Integer> value of the receiver's 'wMajorVerNum' field."

	^bytes wordAtOffset: _OffsetOf_wMajorVerNum!

wMinorVerNum
	"Answer the <Integer> value of the receiver's 'wMinorVerNum' field."

	^bytes wordAtOffset: _OffsetOf_wMinorVerNum!

wTypeFlags
	"Answer the <Integer> value of the receiver's 'wTypeFlags' field."

	^bytes wordAtOffset: _OffsetOf_wTypeFlags! !

!TYPEATTR categoriesForMethods!
basicFree!private!realizing/unrealizing! !
cbAlignment!**compiled accessors**!public! !
cbSizeInstance!**compiled accessors**!public! !
cbSizeVft!**compiled accessors**!public! !
cFuncs!**compiled accessors**!public! !
cImplTypes!**compiled accessors**!public! !
classDesc!accessing!private! !
cVars!**compiled accessors**!public! !
guid!**compiled accessors**!public! !
idldescType!**compiled accessors**!public! !
isAggregatable!public!testing! !
isAppObject!public!testing! !
isAutomationCompatible!public!testing! !
isControl!public!testing! !
isDispatchable!public!testing! !
isExtensible!public!testing! !
isInstantiable!public!testing! !
isLicensed!public!testing! !
isRestricted!public!testing! !
lcid!**compiled accessors**!public! !
memidConstructor!**compiled accessors**!public! !
memidDestructor!**compiled accessors**!public! !
name!accessing!public! !
piTypeInfo:!accessing!private! !
tdesc!accessing!public! !
tdescAlias!**compiled accessors**!public! !
typekind!**compiled accessors**!public! !
wMajorVerNum!**compiled accessors**!public! !
wMinorVerNum!**compiled accessors**!public! !
wTypeFlags!**compiled accessors**!public! !
!

!TYPEATTR class methodsFor!

defineFields
	"Define the fields of the TYPEATTR structure.

		TYPEATTR compileDefinition.

		typedef struct  tagTYPEATTR
		{
			GUID guid;
			LCID lcid;
			DWORD dwReserved;
			MEMBERID memidConstructor;
			MEMBERID memidDestructor;
			LPOLESTR lpstrSchema;
			ULONG cbSizeInstance;
			TYPEKIND typekind;
			WORD cFuncs;
			WORD cVars;
			WORD cImplTypes;
			WORD cbSizeVft;
			WORD cbAlignment;
			WORD wTypeFlags;
			WORD wMajorVerNum;
			WORD wMinorVerNum;
			TYPEDESC tdescAlias;
			IDLDESC idldescType;
		}	TYPEATTR;
	"

	self
		defineField: #guid			type: (StructureField type: GUID) beReadOnly;
		defineField: #lcid				type: DWORDField readOnly;
		defineField: #dwReserved		type: DWORDField filler;
		defineField: #memidConstructor	type: SDWORDField readOnly;	"MEMBERID = DISPID = LONG"
		defineField: #memidDestructor	type: SDWORDField readOnly;	"MEMBERID"
		defineField: #lpstrSchema		type: (PointerField type: Utf16String) beFiller;
		defineField: #cbSizeInstance	type: DWORDField readOnly;
		defineField: #typekind			type: SDWORDField readOnly;	"enumerated type TYPEKIND"
		defineField: #cFuncs			type: WORDField readOnly;
		defineField: #cVars			type: WORDField readOnly;
		defineField: #cImplTypes		type: WORDField readOnly;
		defineField: #cbSizeVft		type: WORDField readOnly;
		defineField: #cbAlignment		type: WORDField readOnly;
		defineField: #wTypeFlags		type: WORDField readOnly;
		defineField: #wMajorVerNum	type: WORDField readOnly;
		defineField: #wMinorVerNum	type: WORDField readOnly;
		defineField: #tdescAlias		type: (StructureField type: TYPEDESC) beReadOnly;
		defineField: #idldescType		type: (StructureField type: IDLDESC) beReadOnly!

getFieldNames
	^#(#guid #lcid #memidConstructor #memidDestructor #cbSizeInstance #typekind #cFuncs #cVars #cImplTypes #cbSizeVft #cbAlignment #wTypeFlags #wMajorVerNum #wMinorVerNum #tdescAlias #idldescType)! !

!TYPEATTR class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

