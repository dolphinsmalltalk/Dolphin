"Filed out from Dolphin Smalltalk 7"!

OS.COM.TypeInfoStructure subclass: #'OS.COM.TYPEATTR'
	instanceVariableNames: 'piTypeInfo'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cbAlignment' -> 16r34.
		'_OffsetOf_cbSizeInstance' -> 16r24.
		'_OffsetOf_cbSizeVft' -> 16r32.
		'_OffsetOf_cFuncs' -> 16r2C.
		'_OffsetOf_cImplTypes' -> 16r30.
		'_OffsetOf_cVars' -> 16r2E.
		'_OffsetOf_dwReserved' -> 16r14.
		'_OffsetOf_guid' -> 16r0.
		'_OffsetOf_idldescType' -> 16r44.
		'_OffsetOf_lcid' -> 16r10.
		'_OffsetOf_lpstrSchema' -> 16r20.
		'_OffsetOf_memidConstructor' -> 16r18.
		'_OffsetOf_memidDestructor' -> 16r1C.
		'_OffsetOf_tdescAlias' -> 16r3C.
		'_OffsetOf_typekind' -> 16r28.
		'_OffsetOf_wMajorVerNum' -> 16r38.
		'_OffsetOf_wMinorVerNum' -> 16r3A.
		'_OffsetOf_wTypeFlags' -> 16r36
	}!
OS.COM.TYPEATTR guid: (Core.GUID fromString: '{c06f3b69-0868-11d3-93af-00a024ca708a}')!
OS.COM.TYPEATTR comment: 'TYPEATTR is an <ExternalStructure> class to represent the Active-X Automation TYPEATTR structure.

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
!OS.COM.TYPEATTR categoriesForClass!External-Data-Structured-COM! !
!OS.COM.TYPEATTR methodsFor!

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
!OS.COM.TYPEATTR categoriesFor: #basicFree!private!realizing/unrealizing! !
!OS.COM.TYPEATTR categoriesFor: #cbAlignment!**compiled accessors**!public! !
!OS.COM.TYPEATTR categoriesFor: #cbSizeInstance!**compiled accessors**!public! !
!OS.COM.TYPEATTR categoriesFor: #cbSizeVft!**compiled accessors**!public! !
!OS.COM.TYPEATTR categoriesFor: #cFuncs!**compiled accessors**!public! !
!OS.COM.TYPEATTR categoriesFor: #cImplTypes!**compiled accessors**!public! !
!OS.COM.TYPEATTR categoriesFor: #classDesc!accessing!private! !
!OS.COM.TYPEATTR categoriesFor: #cVars!**compiled accessors**!public! !
!OS.COM.TYPEATTR categoriesFor: #guid!**compiled accessors**!public! !
!OS.COM.TYPEATTR categoriesFor: #idldescType!**compiled accessors**!public! !
!OS.COM.TYPEATTR categoriesFor: #isAggregatable!public!testing! !
!OS.COM.TYPEATTR categoriesFor: #isAppObject!public!testing! !
!OS.COM.TYPEATTR categoriesFor: #isAutomationCompatible!public!testing! !
!OS.COM.TYPEATTR categoriesFor: #isControl!public!testing! !
!OS.COM.TYPEATTR categoriesFor: #isDispatchable!public!testing! !
!OS.COM.TYPEATTR categoriesFor: #isExtensible!public!testing! !
!OS.COM.TYPEATTR categoriesFor: #isInstantiable!public!testing! !
!OS.COM.TYPEATTR categoriesFor: #isLicensed!public!testing! !
!OS.COM.TYPEATTR categoriesFor: #isRestricted!public!testing! !
!OS.COM.TYPEATTR categoriesFor: #lcid!**compiled accessors**!public! !
!OS.COM.TYPEATTR categoriesFor: #memidConstructor!**compiled accessors**!public! !
!OS.COM.TYPEATTR categoriesFor: #memidDestructor!**compiled accessors**!public! !
!OS.COM.TYPEATTR categoriesFor: #name!accessing!public! !
!OS.COM.TYPEATTR categoriesFor: #piTypeInfo:!accessing!private! !
!OS.COM.TYPEATTR categoriesFor: #tdesc!accessing!public! !
!OS.COM.TYPEATTR categoriesFor: #tdescAlias!**compiled accessors**!public! !
!OS.COM.TYPEATTR categoriesFor: #typekind!**compiled accessors**!public! !
!OS.COM.TYPEATTR categoriesFor: #wMajorVerNum!**compiled accessors**!public! !
!OS.COM.TYPEATTR categoriesFor: #wMinorVerNum!**compiled accessors**!public! !
!OS.COM.TYPEATTR categoriesFor: #wTypeFlags!**compiled accessors**!public! !

!OS.COM.TYPEATTR class methodsFor!

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
		defineField: #guid type: (StructureField type: GUID) beReadOnly;
		defineField: #lcid type: DWORDField readOnly;
		defineField: #dwReserved type: DWORDField filler;
		defineField: #memidConstructor type: SDWORDField readOnly;
		defineField: #memidDestructor type: SDWORDField readOnly;
		defineField: #lpstrSchema type: (PointerField type: Utf16String) beFiller;
		defineField: #cbSizeInstance type: DWORDField readOnly;
		defineField: #typekind type: SDWORDField readOnly;
		defineField: #cFuncs type: WORDField readOnly;
		defineField: #cVars type: WORDField readOnly;
		defineField: #cImplTypes type: WORDField readOnly;
		defineField: #cbSizeVft type: WORDField readOnly;
		defineField: #cbAlignment type: WORDField readOnly;
		defineField: #wTypeFlags type: WORDField readOnly;
		defineField: #wMajorVerNum type: WORDField readOnly;
		defineField: #wMinorVerNum type: WORDField readOnly;
		defineField: #tdescAlias type: (StructureField type: TYPEDESC) beReadOnly;
		defineField: #idldescType type: (StructureField type: IDLDESC) beReadOnly	"MEMBERID = DISPID = LONG"	"MEMBERID"	"enumerated type TYPEKIND"!

getFieldNames
	^#(#guid #lcid #memidConstructor #memidDestructor #cbSizeInstance #typekind #cFuncs #cVars #cImplTypes #cbSizeVft #cbAlignment #wTypeFlags #wMajorVerNum #wMinorVerNum #tdescAlias #idldescType)! !
!OS.COM.TYPEATTR class categoriesFor: #defineFields!public!template definition! !
!OS.COM.TYPEATTR class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

