"Filed out from Dolphin Smalltalk 7"!

OS.COM.MemberDesc subclass: #'OS.COM.VARDESC'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_elemdesc' -> 16rC.
		'_OffsetOf_lpstrSchema' -> 16r4.
		'_OffsetOf_lpvarValue' -> 16r8.
		'_OffsetOf_memid' -> 16r0.
		'_OffsetOf_oInst' -> 16r8.
		'_OffsetOf_varkind' -> 16r20.
		'_OffsetOf_wVarFlags' -> 16r1C
	}!
OS.COM.VARDESC guid: (Core.GUID fromString: '{c06f3b6b-0868-11d3-93af-00a024ca708a}')!
OS.COM.VARDESC comment: 'VARDESC is an <ExternalStructure> class to represent the OLE Automation structure of the same name.

The VARDESC structure describes a variable constant or data member.

Member variables:
	memid		<SDWORD> Unique id of the variable
	lpstrSchema	<LPWSTR> "reserved for future use"
	u.
	  oInst		<DWORD> Offset of variable if flags includes "VAR_PERINSTANCE"
	  lpvarValue	<VARIANT*> the value if flags includes "VAR_CONST" 
	elemdescVar	<ELEMDESC> description of the element (type, etc)
	wVarFlags	<WORD> various flags
	varkind		<SDWORD> from the VARKIND enumeration.

Please see the MS Automation help for further information.'!
!OS.COM.VARDESC categoriesForClass!External-Data-Structured-COM! !
!OS.COM.VARDESC methodsFor!

arguments
	"Answer a <sequencedReadableCollection> containing <ELEMDESC> structures
	describing each of the receiver's parameters.
	Implementation Note: The receiver is describing a 'property', and so doesn't really
	have any arguments, but its property set function does so it can be convenient to
	consider it as having one argument of the properties type."

	^{self elemDesc}!

basicFree
	"Private - Free external resources owned by the receiver."

	analyzer releaseVarDesc: self.!

basicIdlAttributes
	"Private - Answer a <sequencedReadableCollection> of the string names
	of the various IDL flags assocated with the receiver."

	| answer |
	answer := super basicIdlAttributes.
	self isReadOnly ifTrue: [answer add: 'readonly'].
	^answer!

elemdesc
	"Answer the <ELEMDESC> value of the receiver's 'elemdesc' field."

	^ELEMDESC fromAddress: bytes yourAddress + _OffsetOf_elemdesc!

elemDesc
	"Answer an <ELEMDESC> describing the receiver's type."

	^self elemdesc owner: self!

flags
	^self wVarFlags!

getAllCustData
	^analyzer tlbInterface getAllVarCustData: index!

getValidFields
	"Private - Answer a <sequencedReadableCollection> of <Symbol>, being the fields defined in
	the receiver's template, sorted in ascending order of offset from the start of the
	structure, that are valid in this particular instance."

	| fields |
	fields := self class getFieldNames.
	^self isSymbolicConstant ifTrue: [fields] ifFalse: [fields copyWithout: #lpvarValue]!

isAnonymous
	"Answer whether the variable described by the receiver is anonymous (i.e. unnamed). This is
	independent of whether the type of the variable is anonymous."

	"This relies on an implementation detail of MIDL, but there is (it would appear) no other
	way to tell if the variable was unnamed in the original IDL."

	^self name beginsWith: '__MIDL_'!

isConformant
	"Answer whether the variable described by the receiver has the custom Dolphin 'size_is' attribute in the original IDL."

	^self customAttributes includesKey: #size_is!

isReadOnly
	"Answer whether the receiver is describing a read-only variable/property."

	^self wVarFlags allMask: VARFLAG_FREADONLY!

isRequestEdit
	"Answer whether the receiver is describing a 'requestedit' property (i.e. one that causes a
	call to IPropertyNotifySink::OnRequestEdit when one attemps to change its value)."

	^self wVarFlags allMask: VARFLAG_FREQUESTEDIT!

isRestricted
	"Answer whether the receiver is describing a restricted property (i.e. one not
	intended to be used from macro/scripting languages)."

	^self wVarFlags allMask: VARFLAG_FRESTRICTED!

isStatic
	"Answer whether the receiver is describing a static (i.e. non-member) variable."

	^self varkind == VAR_STATIC!

isStringField
	"Answer whether the variable described by the receiver has the custom Dolphin 'string'
	attribute in the original IDL. This can be used to mark embedded character arrays as
	strings, which is not normally supported as although the [string] attribute is valid in IDL
	for arrays, it is not supported by type libraries."

	^self customAttributes includesKey: #string!

isSymbolicConstant
	"Answer whether the receiver is describing a symbolic constant (not to be
	confused with a const variable/parameter)."

	^self varkind == VAR_CONST!

isUnion
	"Answer whether the variable described by the receiver is a union."

	^self tdesc isUnion!

lpvarValue
	"Answer the <VARIANT> value of the receiver's 'lpvarValue' field."

	^VARIANT fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpvarValue)!

memid
	"Answer the <Integer> value of the receiver's 'memid' field."

	^bytes sdwordAtOffset: _OffsetOf_memid!

oInst
	"Answer the <Integer> value of the receiver's 'oInst' field."

	^bytes dwordAtOffset: _OffsetOf_oInst!

varkind
	"Answer the <Integer> value of the receiver's 'varkind' field."

	^bytes sdwordAtOffset: _OffsetOf_varkind!

wVarFlags
	"Answer the <Integer> value of the receiver's 'wVarFlags' field."

	^bytes wordAtOffset: _OffsetOf_wVarFlags! !
!OS.COM.VARDESC categoriesFor: #arguments!accessing!public! !
!OS.COM.VARDESC categoriesFor: #basicFree!private!realizing/unrealizing! !
!OS.COM.VARDESC categoriesFor: #basicIdlAttributes!printing-IDL!private! !
!OS.COM.VARDESC categoriesFor: #elemdesc!**compiled accessors**!public! !
!OS.COM.VARDESC categoriesFor: #elemDesc!accessing!public! !
!OS.COM.VARDESC categoriesFor: #flags!accessing!private! !
!OS.COM.VARDESC categoriesFor: #getAllCustData!accessing!private! !
!OS.COM.VARDESC categoriesFor: #getValidFields!accessing!private! !
!OS.COM.VARDESC categoriesFor: #isAnonymous!public!testing! !
!OS.COM.VARDESC categoriesFor: #isConformant!public!testing! !
!OS.COM.VARDESC categoriesFor: #isReadOnly!public!testing! !
!OS.COM.VARDESC categoriesFor: #isRequestEdit!public!testing! !
!OS.COM.VARDESC categoriesFor: #isRestricted!public!testing! !
!OS.COM.VARDESC categoriesFor: #isStatic!public!testing! !
!OS.COM.VARDESC categoriesFor: #isStringField!public!testing! !
!OS.COM.VARDESC categoriesFor: #isSymbolicConstant!public!testing! !
!OS.COM.VARDESC categoriesFor: #isUnion!public!testing! !
!OS.COM.VARDESC categoriesFor: #lpvarValue!**compiled accessors**!public! !
!OS.COM.VARDESC categoriesFor: #memid!**compiled accessors**!public! !
!OS.COM.VARDESC categoriesFor: #oInst!**compiled accessors**!public! !
!OS.COM.VARDESC categoriesFor: #varkind!**compiled accessors**!public! !
!OS.COM.VARDESC categoriesFor: #wVarFlags!**compiled accessors**!public! !

!OS.COM.VARDESC class methodsFor!

defineFields
	"Define the fields of the VARDESC structure.

		VARDESC compileDefinition.

		typedef struct FARSTRUCT tagVARDESC {
			MEMBERID memid;
			OLECHAR FAR* lpstrSchema;	// Reserved for future use.    
			union {
										// VAR_PERINSTANCE, the offset of this 
										// variable within the instance.
				unsigned long oInst;
										// VAR_CONST, the value of the constant.
				VARIANT FAR* lpvarValue;    

			} UNION_NAME(u);
			ELEMDESC elemdescVar;	***
			unsigned short wVarFlags;
			VARKIND varkind;
		} VARDESC;

	*** We rename this to 'elemdesc' to make a polymorphic accessor shared with FUNCDESC
	"

	self
		defineField: #memid type: SDWORDField readOnly;
		defineField: #lpstrSchema type: (PointerField type: Utf16String) beFiller;
		defineField: #lpvarValue type: (PointerField type: VARIANT) beReadOnly;
		defineField: #elemdesc type: (StructureField type: ELEMDESC) beReadOnly;
		defineField: #wVarFlags type: WORDField readOnly;
		defineField: #varkind type: SDWORDField readOnly.

	"Note union here"
	self
		defineField: #oInst
		type: DWORDField readOnly
		offset: (self offsetOf: #lpvarValue)!

getFieldNames
	^#(#memid #lpvarValue #oInst #elemdesc #wVarFlags #varkind)! !
!OS.COM.VARDESC class categoriesFor: #defineFields!public!template definition! !
!OS.COM.VARDESC class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

