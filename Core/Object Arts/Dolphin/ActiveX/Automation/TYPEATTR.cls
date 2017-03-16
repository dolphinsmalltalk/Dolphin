"Filed out from Dolphin Smalltalk 7"!

AXTypeInfoStructure subclass: #TYPEATTR
	instanceVariableNames: 'piTypeInfo'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TYPEATTR guid: (GUID fromString: '{c06f3b69-0868-11d3-93af-00a024ca708a}')!
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

	piTypeInfo asParameter ReleaseTypeAttr: self!

cbAlignment
	"Answer the receiver's cbAlignment field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #cbAlignment)!

cbSizeInstance
	"Answer the receiver's cbSizeInstance field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #cbSizeInstance)!

cbSizeVft
	"Answer the receiver's cbSizeVft field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #cbSizeVft)!

cFuncs
	"Answer the receiver's cFuncs field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #cFuncs)!

cImplTypes
	"Answer the receiver's cImplTypes field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #cImplTypes)!

classDesc
	"Private - Answer an <Association> between a Dolphin class suitable for representing
	the external type described by the receiver, and the number of indirections
	to the type."

	^self tdesc classDesc!

cVars
	"Answer the receiver's cVars field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #cVars)!

guid
	"Answer the receiver's guid field as a Smalltalk object."

	^GUID fromAddress: bytes yourAddress!

idldescType
	"Answer the receiver's idldescType field as a Smalltalk object."

	^IDLDESC fromAddress: bytes yourAddress + ##(self offsetOf: #idldescType)!

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
	"Answer the receiver's lcid field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #lcid)!

memidConstructor
	"Answer the receiver's memidConstructor field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #memidConstructor)!

memidDestructor
	"Answer the receiver's memidDestructor field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #memidDestructor)!

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
	"Answer the receiver's tdescAlias field as a Smalltalk object."

	^TYPEDESC fromAddress: bytes yourAddress + ##(self offsetOf: #tdescAlias)!

typekind
	"Answer the receiver's typekind field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #typekind)!

wMajorVerNum
	"Answer the receiver's wMajorVerNum field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #wMajorVerNum)!

wMinorVerNum
	"Answer the receiver's wMinorVerNum field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #wMinorVerNum)!

wTypeFlags
	"Answer the receiver's wTypeFlags field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #wTypeFlags)! !
!TYPEATTR categoriesFor: #basicFree!private!realizing/unrealizing! !
!TYPEATTR categoriesFor: #cbAlignment!**compiled accessors**!public! !
!TYPEATTR categoriesFor: #cbSizeInstance!**compiled accessors**!public! !
!TYPEATTR categoriesFor: #cbSizeVft!**compiled accessors**!public! !
!TYPEATTR categoriesFor: #cFuncs!**compiled accessors**!public! !
!TYPEATTR categoriesFor: #cImplTypes!**compiled accessors**!public! !
!TYPEATTR categoriesFor: #classDesc!accessing!private! !
!TYPEATTR categoriesFor: #cVars!**compiled accessors**!public! !
!TYPEATTR categoriesFor: #guid!**compiled accessors**!public! !
!TYPEATTR categoriesFor: #idldescType!**compiled accessors**!public! !
!TYPEATTR categoriesFor: #isAggregatable!public!testing! !
!TYPEATTR categoriesFor: #isAppObject!public!testing! !
!TYPEATTR categoriesFor: #isAutomationCompatible!public!testing! !
!TYPEATTR categoriesFor: #isControl!public!testing! !
!TYPEATTR categoriesFor: #isDispatchable!public!testing! !
!TYPEATTR categoriesFor: #isExtensible!public!testing! !
!TYPEATTR categoriesFor: #isInstantiable!public!testing! !
!TYPEATTR categoriesFor: #isLicensed!public!testing! !
!TYPEATTR categoriesFor: #isRestricted!public!testing! !
!TYPEATTR categoriesFor: #lcid!**compiled accessors**!public! !
!TYPEATTR categoriesFor: #memidConstructor!**compiled accessors**!public! !
!TYPEATTR categoriesFor: #memidDestructor!**compiled accessors**!public! !
!TYPEATTR categoriesFor: #name!accessing!public! !
!TYPEATTR categoriesFor: #piTypeInfo:!accessing!private! !
!TYPEATTR categoriesFor: #tdesc!accessing!public! !
!TYPEATTR categoriesFor: #tdescAlias!**compiled accessors**!public! !
!TYPEATTR categoriesFor: #typekind!**compiled accessors**!public! !
!TYPEATTR categoriesFor: #wMajorVerNum!**compiled accessors**!public! !
!TYPEATTR categoriesFor: #wMinorVerNum!**compiled accessors**!public! !
!TYPEATTR categoriesFor: #wTypeFlags!**compiled accessors**!public! !

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
		defineField: #lpstrSchema		type: (PointerField type: UnicodeString) beFiller;
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
		defineField: #idldescType		type: (StructureField type: IDLDESC) beReadOnly! !
!TYPEATTR class categoriesFor: #defineFields!initializing!public! !

