"Filed out from Dolphin Smalltalk 7"!

OS.COM.OLEStructure subclass: #'OS.COM.TYPEDESC'
	instanceVariableNames: 'owner classDesc typeInfo'
	classVariableNames: ''
	imports: #(#{OS.COM.AutomationConstants})
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_hreftype' -> 16r0.
		'_OffsetOf_lpadesc' -> 16r0.
		'_OffsetOf_lptdesc' -> 16r0.
		'_OffsetOf_vt' -> 16r4.
		'VTIndirections' -> #[0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
	}!
OS.COM.TYPEDESC guid: (Core.GUID fromString: '{c06f3b7a-0868-11d3-93af-00a024ca708a}')!
OS.COM.TYPEDESC comment: 'TYPEDESC is an ExternalStructure class to represent the AX Automation structure, TYPEDESC.

The TYPEDESC structure describes the type of a variable, function parameter, or return value, and is one of the key structures in the type library model.

Member Variables:
	u
		lptdesc		<TYPEDESC*> For a VT_PTR|VT_SAFEARRAY, describes the pointed at type
		lpadesc		<ARRAYDESC*> For a VT_CARRAY, provides additional description of the array
		hreftype		<HREFTYPE> For a VT_USERDEFINEDTYPE, ?
	vt			<VARTYPE> Variant type id (16-bits)

Note that this structure is only 6-bytes long, and requires packing when embedded in other structures (Dolphin''s external structure/array packing and alignment algorithm will handle this automatically).

Instance Variables:
	owner		<ExternalStructure>. Backpointer to original structure to keep it alive, and also to locate ITypeInfo.
'!
!OS.COM.TYPEDESC categoriesForClass!External-Data-Structured-COM! !
!OS.COM.TYPEDESC methodsFor!

analyzer
	"Private - Answer the <AXTypeInfoAnalyzer> from which the receiver originated."

	^owner analyzer!

arrayDesc
	"Private - Recurse down through any typedefs to the underlying ARRAYDESC. Anwer nil if the type does not describe an array."

	| vt |
	vt := self vt.
	vt == VT_PTR ifTrue: [^self tdesc arrayDesc].
	vt == VT_CARRAY ifTrue: [^self tdescArray].
	vt == VT_USERDEFINED ifTrue: [^self typeInfo tdesc arrayDesc].
	^nil!

buildClassDesc
	| vt |
	vt := self vt.
	vt == VT_PTR
		ifTrue: 
			[| indirTo |
			"Its a pointer to something, so we need to recurse and answer  <typename>*"
			indirTo := self tdesc classDesc.
			^indirTo key -> (indirTo value + 1 min: 2)].
	vt == VT_CARRAY
		ifTrue: 
			[| arryDesc |
			arryDesc := self tdescArray tdesc classDesc.
			"Answer the type of array and the number of indirections to it - note that the element 
		type 	is asked to supply this array type, but the result may well be the generic 	
		<StructureArray>."
			^(arryDesc key arrayType: arryDesc value) -> 0].
	vt == VT_SAFEARRAY ifTrue: [^SAFEARRAY -> 1].
	vt == VT_USERDEFINED
		ifTrue: [^owner isNil ifTrue: [Structure -> 1] ifFalse: [self typeInfo classDesc]].
	^(VARIANT classForVT: vt) -> (VTIndirections at: vt + 1)!

classDesc
	"Private - Answer a Dolphin class and indirection count pair which can be used to
	represent the external type described by the receiver."

	classDesc isNil ifTrue: [classDesc := self buildClassDesc].
	^classDesc!

getRefType
	^self analyzer getRefType: self hreftype!

hreftype
	"Answer the <Integer> value of the receiver's 'hreftype' field."

	^bytes dwordAtOffset: _OffsetOf_hreftype!

isAnonymous
	"Answer whether the type described by the receiver is an anonymous (i.e. unnamed)
	struct or union type."

	^self isStructure and: [self typeInfo isAnonymous]!

isStructure
	"Answer whether the receiver describes a user-defined struct or union type."

	^self isUserDefined and: [self typeInfo isStructure]!

isUnion
	"Answer whether the receiver describes a user-defined union type."

	^self isUserDefined and: [self realTypeInfo isUnion]!

isUserDefined
	"Answer whether the receiver describes a user-defined type, e.g. a struct."

	^self vt = VT_USERDEFINED!

lpadesc
	"Answer the <ARRAYDESC> value of the receiver's 'lpadesc' field."

	^ARRAYDESC fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpadesc)!

lptdesc
	"Answer the <TYPEDESC> value of the receiver's 'lptdesc' field."

	^TYPEDESC fromAddress: (bytes intPtrAtOffset: _OffsetOf_lptdesc)!

owner: struct
	"Private - Set the value of the receiver's 'owner' instance variable to the <AXTypeInfoStructure> 
	argument, struct. Answer the receiver."

	owner := struct!

realTypeInfo
	"Answer an <AXTypeInfoAnalyzer> on the underlying type described by the receiver."

	^self typeInfo realTypeInfo!

tdesc
	"Answer a <TYPEDESC> which is the type of the element described by the receiver.
	Implementation Note: Set the back-pointer to be the same as the receiver's, since it
	is the destruction of the <AXTypeInfoStructure> which we wish to postpone for the
	lifetime of the TYPEDESC."

	^self lptdesc owner: owner!

tdescArray
	"Answer a <TYPEDESC> which is the type of the array described by the receiver.
	Implementation Note: Set the back-pointer to be the same as the receiver's, since it
	is the destruction of the <AXTypeInfoStructure> which we wish to postpone for the
	lifetime of the TYPEDESC."

	^self lpadesc
		owner: owner!

typeDesc
	"Recurse down through any typedefs to resolve the actual element type."

	| vt |
	vt := self vt.
	vt == VT_PTR ifTrue: [^self tdesc typeDesc].
	vt == VT_CARRAY ifTrue: [^self tdescArray tdesc typeDesc].
	vt == VT_USERDEFINED ifTrue: [self typeInfo tdesc typeDesc].
	^self!

typeInfo
	^typeInfo ifNil: [typeInfo := self getRefType]!

typeName
	"Answer the Dolphin external type name for the type described by the receiver."

	^self isAnonymous
		ifFalse: 
			[| desc answer |
			desc := self classDesc.
			answer := desc key typeName.
			desc value timesRepeat: [answer := answer , '*'].
			answer]!

vartype
	"Private - Answer the ultimate (implementation) variant type of the receiver.
	This may involve chasing down through aliases, etc, if the type is user defined."

	| vt |
	vt := self vt.
	self assert: [vt <= 16rFFF	"modifier flags not valid in a TYPEDESC"].
	(vt == VT_PTR or: [vt == VT_SAFEARRAY]) ifTrue: [^self tdesc vartype].
	vt == VT_USERDEFINED 
		ifTrue: 
			["Chase down the actual type via the referenced Type Info."

			^self typeInfo vt].
	^vt!

vt
	"Answer the <Integer> value of the receiver's 'vt' field."

	^bytes wordAtOffset: _OffsetOf_vt!

vtName
	"Private - Answer the Dolphin external type name for the receiver's variant type."

	^VARIANT nameOfVT: self vartype! !
!OS.COM.TYPEDESC categoriesFor: #analyzer!accessing!private! !
!OS.COM.TYPEDESC categoriesFor: #arrayDesc!development!private! !
!OS.COM.TYPEDESC categoriesFor: #buildClassDesc!helpers!private! !
!OS.COM.TYPEDESC categoriesFor: #classDesc!accessing!private! !
!OS.COM.TYPEDESC categoriesFor: #getRefType!accessing!private! !
!OS.COM.TYPEDESC categoriesFor: #hreftype!**compiled accessors**!public! !
!OS.COM.TYPEDESC categoriesFor: #isAnonymous!public!testing! !
!OS.COM.TYPEDESC categoriesFor: #isStructure!public!testing! !
!OS.COM.TYPEDESC categoriesFor: #isUnion!public!testing! !
!OS.COM.TYPEDESC categoriesFor: #isUserDefined!public!testing! !
!OS.COM.TYPEDESC categoriesFor: #lpadesc!**compiled accessors**!public! !
!OS.COM.TYPEDESC categoriesFor: #lptdesc!**compiled accessors**!public! !
!OS.COM.TYPEDESC categoriesFor: #owner:!accessing!private! !
!OS.COM.TYPEDESC categoriesFor: #realTypeInfo!accessing!public! !
!OS.COM.TYPEDESC categoriesFor: #tdesc!accessing!public! !
!OS.COM.TYPEDESC categoriesFor: #tdescArray!accessing!public! !
!OS.COM.TYPEDESC categoriesFor: #typeDesc!helpers!private! !
!OS.COM.TYPEDESC categoriesFor: #typeInfo!accessing!public! !
!OS.COM.TYPEDESC categoriesFor: #typeName!accessing!public! !
!OS.COM.TYPEDESC categoriesFor: #vartype!accessing!public! !
!OS.COM.TYPEDESC categoriesFor: #vt!**compiled accessors**!public! !
!OS.COM.TYPEDESC categoriesFor: #vtName!accessing!private! !

!OS.COM.TYPEDESC class methodsFor!

defineFields
	"Define the fields of the TYPEDESC structure.
		TYPEDESC compileDefinition
	
		typedef 		struct tagTYPEDESC {
			union 
			{
				TYPEDESC *lptdesc;
				ARRAYDESC *lpadesc;
				HREFTYPE hreftype;			// Handle to identify type description
			};
			VARTYPE vt;
		} TYPEDESC;

	See the constants beginning 'VT_...' in AXAutomationConstants for VARTYPEs.
	"

	self
		defineField: #lptdesc type: (PointerField type: TYPEDESC) beReadOnly;
		defineField: #vt type: WORDField readOnly.

	"Other fields of the union"
	self
		defineField: #lpadesc
			type: (PointerField type: ARRAYDESC) beReadOnly
			offset: 0;
		defineField: #hreftype
			type: DWORDField readOnly
			offset: 0!

getFieldNames
	^#(#hreftype #lpadesc #lptdesc #vt)!

initialize
	"
		self initialize
	"

	self addClassConstant: 'VTIndirections'
		value: ((ByteArray new: VT_CLSID + 1 withAll: 0)
				at: VT_DISPATCH + 1 put: 1;
				at: VT_UNKNOWN + 1 put: 1;
				at: VT_SAFEARRAY + 1 put: 1;
				yourself)! !
!OS.COM.TYPEDESC class categoriesFor: #defineFields!public!template definition! !
!OS.COM.TYPEDESC class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!OS.COM.TYPEDESC class categoriesFor: #initialize!class initialization!development!public! !

