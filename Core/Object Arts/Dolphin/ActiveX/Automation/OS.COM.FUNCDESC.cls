"Filed out from Dolphin Smalltalk 7"!

OS.COM.MemberDesc subclass: #'OS.COM.FUNCDESC'
	instanceVariableNames: 'names arguments outputIndices retvalIndex methodName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_callconv' -> 16r14.
		'_OffsetOf_cParams' -> 16r18.
		'_OffsetOf_cParamsOpt' -> 16r1A.
		'_OffsetOf_cScodes' -> 16r1E.
		'_OffsetOf_elemdescFunc' -> 16r20.
		'_OffsetOf_funckind' -> 16rC.
		'_OffsetOf_invkind' -> 16r10.
		'_OffsetOf_lprgelemdescParam' -> 16r8.
		'_OffsetOf_lprgscode' -> 16r4.
		'_OffsetOf_memid' -> 16r0.
		'_OffsetOf_oVft' -> 16r1C.
		'_OffsetOf_wFuncFlags' -> 16r30
	}!
OS.COM.FUNCDESC guid: (Core.GUID fromString: '{c06f3b6e-0868-11d3-93af-00a024ca708a}')!
OS.COM.FUNCDESC comment: 'FUNCDESC is an <ExternalStructure> class to represent the Active-X Automation FUNCDESC structure.

A FUNCDESC describes various attributes of a function including, for example, the number of parameters, and their types.

Fields:
	memid		<SDWORD> unique identifier of the function within its enclosing ITypeInfo.
	lprgscode		<HRESULT*> array of possible return values from the function, typically NULL.
	lprgelemdescParam	<ELEMDESC*>
	funckind		<SDWORD> from the FUNCKIND enumeration. Type of function.
	invkind		<SDWORD> from the INVOKEKIND enumeration. Property accessor or straight method.
	callconv		<SDWORD> from the CALLCONV enumeration to describe the calling convention, e.g. cdecl.
	cParams		<SWORD> number of parameters to the function (no. of elems in lprgelemdescParam).
	cParamsOpt	<SWORD> number of optional parameters to the function.
	oVft		<SWORD> offset in the vtable. Use of signed 16-bit field implies max. of 8191 methods.
	cScodes		<SWORD> the number of HRESULT codes in the lprgscode array.
	elemdescFunc	<ELEMDESC> describing the return type from the function
	wFuncFlags	<WORD>. Various flags about the function.
'!
!OS.COM.FUNCDESC categoriesForClass!External-Data-Structured-COM! !
!OS.COM.FUNCDESC methodsFor!

argumentNameFor: paramName
	"Private - Answer a suitable <readableString> Smalltalk argument paramName for
	the <readableString> parameter paramName, paramName, which may be empty.
	using the following rules.
		func -> func
		Func -> func
		XFunc -> xFunc
		FUNC -> func
	"

	| firstAlpha firstLower size leadingUppers |
	firstAlpha := 1.
	size := paramName size.
	[firstAlpha <= size and: [(paramName at: firstAlpha) == $_]] whileTrue: [firstAlpha := firstAlpha + 1].
	firstLower := firstAlpha.
	[firstLower <= size and: [(paramName at: firstLower) isUppercase]] whileTrue: [firstLower := firstLower + 1].

	firstLower > size ifTrue: [ "eg. FUNC -> func"
		^paramName asLowercase].

	^(leadingUppers := firstLower - firstAlpha) == 0
		ifTrue: [paramName "eg. func -> func"]
		ifFalse: [
			"eg. XFunc -> xFunc, Func -> func, of FUNCTwo -> funcTwo"
			| mid |
			mid := leadingUppers min: 2.
			(paramName copyFrom: 1 to: (firstLower-mid)) asLowercase, 
				(paramName copyFrom: firstLower-mid+1 to: size)]
!

argumentNames
	"Answer a <sequencedReadableCollection> of <readableString> names of the 
	parameters of the function described by the receiver."

	^self names allButFirst!

arguments
	"Answer a <sequencedReadableCollection> containing <ELEMDESC> structures
	describing each of the receiver's parameters."

	arguments isNil ifTrue: [arguments := self lprgelemdescParam collect: [:e | e owner: self; yourself]].
	^arguments!

basicFree
	"Private - Free external resources owned by the receiver."

	analyzer releaseFuncDesc: self!

basicIdlAttributes
	"Private - Answer a <sequencedReadableCollection> of the string names
	of the various IDL flags assocated with the receiver."

	| answer |
	answer := super basicIdlAttributes.
	self isPropPut ifTrue: [answer add: 'propput'].
	self isPropPutRef ifTrue: [answer add: 'propputref'].
	self isPropGet ifTrue: [answer add: 'propget'].
	^answer!

callconv
	"Answer the <Integer> value of the receiver's 'callconv' field."

	^bytes sdwordAtOffset: _OffsetOf_callconv!

callingConvention
	"Answer the Dolphin external calling convention for the receiver."

	^##(IdentityDictionary new
		at: CC_CDECL put: 'cdecl:';
		at: CC_STDCALL put: 'stdcall:';
		yourself) 
	at: self callconv!

clearMethodName
	methodName := nil!

cParams
	"Private - Answer the <Integer> value of the receiver's 'cParams' field."

	^bytes swordAtOffset: _OffsetOf_cParams!

cParamsOpt
	"Answer the <Integer> value of the receiver's 'cParamsOpt' field."

	^bytes swordAtOffset: _OffsetOf_cParamsOpt!

cScodes
	"Private - Answer the <Integer> value of the receiver's 'cScodes' field."

	^bytes swordAtOffset: _OffsetOf_cScodes!

elemDesc
	"Answer an <ELEMDESC> describing the receiver's actual return or property type (as opposed to the normal
	HRESULT return type)."

	^self hasRetval ifTrue: [self arguments at: self retvalIndex] ifFalse: [self elemDescFunc]!

elemdescFunc
	"Answer the <ELEMDESC> value of the receiver's 'elemdescFunc' field."

	^ELEMDESC fromAddress: bytes yourAddress + _OffsetOf_elemdescFunc!

elemDescFunc
	^(self elemdescFunc)
		owner: self;
		yourself!

flags
	^self wFuncFlags!

funckind
	"Answer the <Integer> value of the receiver's 'funckind' field."

	^bytes sdwordAtOffset: _OffsetOf_funckind!

getAllCustData
	^analyzer tlbInterface getAllFuncCustData: index!

hasRetval
	"Answer whether the receiver has retval argument."

	^self retvalIndex ~= 0!

idlCallingConvention
	"Private - Answer the receiver's calling convention as it would be specified in IDL."

	^##(IdentityDictionary new
		at: CC_CDECL put: '__cdecl';
		at: CC_STDCALL put: '__stdcall';
		yourself) 
	at: self callconv!

invkind
	"Answer the <Integer> value of the receiver's 'invkind' field."

	^bytes sdwordAtOffset: _OffsetOf_invkind!

isDispatchable
	"Answer whether the receiver is only invokable via IDispatch"

	^self funckind == FUNC_DISPATCH!

isMethod
	"Answer whether the receiver should be invoked as a method (i.e. with DISPATCH_METHOD)"

	^self invkind == INVOKE_FUNC!

isPropGet
	"Answer whether the receiver should be invoked as a property access
	function (i.e. with DISPATCH_PROPERTYGET)"

	^self invkind == INVOKE_PROPERTYGET!

isPropPut
	"Answer whether the receiver should be invoked as a property value assignment 
	function (i.e. with DISPATCH_PROPERTYPUT)"

	^self invkind == INVOKE_PROPERTYPUT!

isPropPutRef
	"Answer whether the receiver should be invoked as a property reference assignment 
	function (i.e. with DISPATCH_PROPERTYPUTREF)"

	^self invkind == INVOKE_PROPERTYPUTREF!

isPropSet
	"Answer whether the receiver describes a property value or reference assignment
	function (i.e. it is of invocation type INVOKE_PROPERTYPUT[REF])."

	| invkind |
	^(invkind := self invkind) == INVOKE_PROPERTYPUT
		or: [invkind == INVOKE_PROPERTYPUTREF]!

isReadOnly
	^self isPropGet!

isRequestEdit
	"Answer whether the receiver is describing a 'requestedit' property (i.e. one that causes a
	call to IPropertyNotifySink::OnRequestEdit when one attemps to change its value)."

	^self wFuncFlags allMask: FUNCFLAG_FREQUESTEDIT!

isRestricted
	"Answer whether the receiver is describing a 'restricted' function (i.e. one not
	intended to be used from macro/scripting languages)."

	^self wFuncFlags allMask: FUNCFLAG_FRESTRICTED!

isVirtual
	"Answer whether the receiver describes some kind of virtual function."

	| fk |
	fk := self funckind.
	^fk == FUNC_PUREVIRTUAL or: [fk == FUNC_VIRTUAL]!

lprgelemdescParam
	"Answer the <StructureArray> value of the receiver's 'lprgelemdescParam' field."

	^StructureArray
		fromAddress: (bytes intPtrAtOffset: _OffsetOf_lprgelemdescParam)
		length: self cParams
		elementClass: ELEMDESC!

lprgscode
	"Answer the <StructureArray> value of the receiver's 'lprgscode' field."

	^StructureArray
		fromAddress: (bytes intPtrAtOffset: _OffsetOf_lprgscode)
		length: self cScodes
		elementClass: HRESULT!

memid
	"Answer the <Integer> value of the receiver's 'memid' field."

	^bytes sdwordAtOffset: _OffsetOf_memid!

name
	"Answer the name of the function described by the receiver."

	^self names first!

names
	"Private -  Answer a <sequencedReadableCollection> of <String>, consisting of the 
	the function described by the receiver, and subsequently the names of its parameters."

	names isNil 
		ifTrue: 
			[| count |
			count := self cParams + 1.
			names := analyzer getNamesOfMember: self memid count: count].
	^names!

optionalInputs
	"Private - Answer the indices of the input arguments of the receiver which are optional."

	| args |
	args := self arguments.
	^(1 to: args size) select: 
			[:i | 
			| arg |
			arg := args at: i.
			arg isOptional and: [arg isIn]]!

outputIndices
	"Private - Answer the indices of the arguments of the receiver which are outputs."

	outputIndices isNil ifTrue: [ | args |
		args := self arguments.
		outputIndices := (1 to: args size) select: [:i | (args at: i) isOut]].
	^outputIndices

!

oVft
	"Answer the <Integer> value of the receiver's 'oVft' field."

	^bytes swordAtOffset: _OffsetOf_oVft!

retTypeName
	"Answer a Dolphin external type name for the receiver's actual return type
	(as opposed to the retval type name)."

	^self tdescFunc typeName!

retvalIndex
	"Private - Answer the index of the retval argument of the receiver.
	This is the index of the argument which is the real return value as
	opposed to the actual return value, which is typically an HRESULT code.
	If there isn't an argument with the IDL retval attribute, then we use
	the last non-optional output argument, if any."

	retvalIndex isNil 
		ifTrue: 
			[| args |
			args := self arguments.
			retvalIndex := self outputIndices detect: [:each | (args at: each) isRetVal]
						ifNone: 
							[| outOnly |
							outOnly := outputIndices reject: 
											[:i | 
											| each |
											each := args at: i.
											each isIn or: [each isOptional]].
							outOnly isEmpty ifTrue: [0] ifFalse: [outOnly last]]].
	^retvalIndex!

selector
	"Answer a suitable selector for the receiver. Note that this takes no account of existing
	common selectors with which we might not want to clash, so the selector may need a little
	reinvention depending on what its purpose. It might also need a prefix, e.g. get_ or put_ for
	property get/puts. It should be OK as an event selector as it is though."

	"Although this might seem to be development time only functionality, it can be used at run time
	to build the names of events to be triggered when sinking a COM 'source'/event interface."

	| argc |
	^(argc := self argumentCount) < 1
		ifTrue: 
			["Special case if no arguments"
			self name asSymbol]
		ifFalse: 
			[| answer keywords |
			keywords := self names.
			answer := String smalltalkWriteStream: argc * 10.
			answer
				nextPutAll: keywords first;
				nextPut: $:.
			3 to: keywords size
				do: 
					[:i |
					answer
						nextPutAll: (keywords at: i);
						nextPut: $:].
			answer contents asSymbol]!

tdescFunc
	"Private - Answer a TYPEDESC describing the receiver's formal return type.
	For a dispinterface function this may be the actual return type, but for an
	interface method it will normally just be HRESULT, but see also #tdesc."

	^self elemDescFunc tdesc!

vfnIndex
	"Private - Answer the receiver's virtual function index.
	Raise an error if the receiver does not describe a virtual function."

	self isVirtual ifFalse: [self error: 'Not a virtual function'].
	^(self oVft//4)+1.!

wFuncFlags
	"Answer the <Integer> value of the receiver's 'wFuncFlags' field."

	^bytes wordAtOffset: _OffsetOf_wFuncFlags! !
!OS.COM.FUNCDESC categoriesFor: #argumentNameFor:!helpers!private! !
!OS.COM.FUNCDESC categoriesFor: #argumentNames!accessing!public! !
!OS.COM.FUNCDESC categoriesFor: #arguments!accessing!public! !
!OS.COM.FUNCDESC categoriesFor: #basicFree!private!realizing/unrealizing! !
!OS.COM.FUNCDESC categoriesFor: #basicIdlAttributes!printing-IDL!private! !
!OS.COM.FUNCDESC categoriesFor: #callconv!**compiled accessors**!public! !
!OS.COM.FUNCDESC categoriesFor: #callingConvention!accessing!public! !
!OS.COM.FUNCDESC categoriesFor: #clearMethodName!development!initializing!private! !
!OS.COM.FUNCDESC categoriesFor: #cParams!**compiled accessors**!private! !
!OS.COM.FUNCDESC categoriesFor: #cParamsOpt!**compiled accessors**!public! !
!OS.COM.FUNCDESC categoriesFor: #cScodes!**compiled accessors**!private! !
!OS.COM.FUNCDESC categoriesFor: #elemDesc!accessing!public! !
!OS.COM.FUNCDESC categoriesFor: #elemdescFunc!**compiled accessors**!public! !
!OS.COM.FUNCDESC categoriesFor: #elemDescFunc!accessing!public! !
!OS.COM.FUNCDESC categoriesFor: #flags!accessing!private! !
!OS.COM.FUNCDESC categoriesFor: #funckind!**compiled accessors**!public! !
!OS.COM.FUNCDESC categoriesFor: #getAllCustData!accessing!private! !
!OS.COM.FUNCDESC categoriesFor: #hasRetval!public!testing! !
!OS.COM.FUNCDESC categoriesFor: #idlCallingConvention!printing-IDL!private! !
!OS.COM.FUNCDESC categoriesFor: #invkind!**compiled accessors**!public! !
!OS.COM.FUNCDESC categoriesFor: #isDispatchable!public!testing! !
!OS.COM.FUNCDESC categoriesFor: #isMethod!public!testing! !
!OS.COM.FUNCDESC categoriesFor: #isPropGet!public!testing! !
!OS.COM.FUNCDESC categoriesFor: #isPropPut!public!testing! !
!OS.COM.FUNCDESC categoriesFor: #isPropPutRef!public!testing! !
!OS.COM.FUNCDESC categoriesFor: #isPropSet!public!testing! !
!OS.COM.FUNCDESC categoriesFor: #isReadOnly!public!testing! !
!OS.COM.FUNCDESC categoriesFor: #isRequestEdit!public!testing! !
!OS.COM.FUNCDESC categoriesFor: #isRestricted!public!testing! !
!OS.COM.FUNCDESC categoriesFor: #isVirtual!public!testing! !
!OS.COM.FUNCDESC categoriesFor: #lprgelemdescParam!**compiled accessors**!public! !
!OS.COM.FUNCDESC categoriesFor: #lprgscode!**compiled accessors**!public! !
!OS.COM.FUNCDESC categoriesFor: #memid!**compiled accessors**!public! !
!OS.COM.FUNCDESC categoriesFor: #name!accessing!public! !
!OS.COM.FUNCDESC categoriesFor: #names!accessing!private! !
!OS.COM.FUNCDESC categoriesFor: #optionalInputs!accessing!private! !
!OS.COM.FUNCDESC categoriesFor: #outputIndices!accessing!private! !
!OS.COM.FUNCDESC categoriesFor: #oVft!**compiled accessors**!public! !
!OS.COM.FUNCDESC categoriesFor: #retTypeName!accessing!public! !
!OS.COM.FUNCDESC categoriesFor: #retvalIndex!accessing!private! !
!OS.COM.FUNCDESC categoriesFor: #selector!accessing!public! !
!OS.COM.FUNCDESC categoriesFor: #tdescFunc!accessing!private! !
!OS.COM.FUNCDESC categoriesFor: #vfnIndex!accessing!private! !
!OS.COM.FUNCDESC categoriesFor: #wFuncFlags!**compiled accessors**!public! !

!OS.COM.FUNCDESC class methodsFor!

defineFields
	"Define the fields of the FUNCDESC structure.

		FUNCDESC compileDefinition.

		struct FUNCDESC
		{
			MEMBERID memid;
			SCODE *lprgscode;
			ELEMDESC *lprgelemdescParam;
			FUNCKIND funckind;
			INVOKEKIND invkind;
			CALLCONV callconv;
			SHORT cParams;
			SHORT cParamsOpt;
			SHORT oVft;
			SHORT cScodes;
			ELEMDESC elemdescFunc;
			WORD wFuncFlags;
		};
	"

	self
		defineField: #memid type: SDWORDField readOnly;
		defineField: #lprgscode
			type: (StructureArrayPointerField type: HRESULT
					arrayLength: (ConformantArrayFieldLength lengthField: #cScodes)) beReadOnly;
		defineField: #lprgelemdescParam
			type: (StructureArrayPointerField type: ELEMDESC
					arrayLength: (ConformantArrayFieldLength lengthField: #cParams)) beReadOnly;
		defineField: #funckind type: SDWORDField readOnly;
		defineField: #invkind type: SDWORDField readOnly;
		defineField: #callconv type: SDWORDField readOnly;
		defineField: #cParams type: SWORDField readOnly beNonBrowsable;
		defineField: #cParamsOpt type: SWORDField readOnly;
		defineField: #oVft type: SWORDField readOnly;
		defineField: #cScodes type: SWORDField readOnly beNonBrowsable;
		defineField: #elemdescFunc type: (StructureField type: ELEMDESC) beReadOnly;
		defineField: #wFuncFlags type: WORDField readOnly!

getFieldNames
	^#(#memid #lprgscode #lprgelemdescParam #funckind #invkind #callconv #cParams #cParamsOpt #oVft #cScodes #elemdescFunc #wFuncFlags)!

stbConvertFrom: anSTBClassFormat
	"Convert from version 0 FUNCDESC.
		1) Change of use, and name, of former keywordsAndArgs instance variable."

	^
	[:data | 
	| newInstance |
	newInstance := self basicNew.
	1 to: data size do: [:i | newInstance instVarAt: i put: (data at: i)].
	newInstance clearMethodName.
	newInstance]!

stbVersion
	^1! !
!OS.COM.FUNCDESC class categoriesFor: #defineFields!public!template definition! !
!OS.COM.FUNCDESC class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!OS.COM.FUNCDESC class categoriesFor: #stbConvertFrom:!binary filing!development!public! !
!OS.COM.FUNCDESC class categoriesFor: #stbVersion!binary filing!development!public! !

