"Filed out from Dolphin Smalltalk"!

OS.COM.MemberDesc
	subclass: #'OS.COM.FUNCDESC'
	instanceVariableNames: 'names arguments outputIndices retvalIndex methodName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_FUNCDESC_Size' -> 16r34.
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

	^arguments ifNil: [self buildArguments]!

basicFree
	"Private - Free external resources owned by the receiver."

	super basicFree.
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

buildArguments
	| argc elemdescs |
	argc := self cParams.
	argc == 0 ifTrue: [^arguments := #()].
	elemdescs := self lprgelemdescParam.
	arguments := Array new: argc.
	elemdescs keysAndValuesDo: 
			[:eachKey :eachValue |
			eachValue
				owner: self;
				index: eachKey - 1.
			arguments at: eachKey put: eachValue].
	^arguments!

callconv
	"Answer the <Integer> value of the receiver's 'callconv' field."

	^bytes int32AtOffset: _OffsetOf_callconv!

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

	^bytes int16AtOffset: _OffsetOf_cParams!

cParamsOpt
	"Answer the <Integer> value of the receiver's 'cParamsOpt' field."

	^bytes int16AtOffset: _OffsetOf_cParamsOpt!

cScodes
	"Private - Answer the <Integer> value of the receiver's 'cScodes' field."

	^bytes int16AtOffset: _OffsetOf_cScodes!

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

	^bytes int32AtOffset: _OffsetOf_funckind!

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

	^bytes int32AtOffset: _OffsetOf_invkind!

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

	^bytes int32AtOffset: _OffsetOf_memid!

name
	"Answer the name of the function described by the receiver."

	^self names first!

names
	"Private -  Answer a <sequencedReadableCollection> of <String>, consisting of the 
	the function described by the receiver, and subsequently the names of its parameters."

	^names ifNil: [names := analyzer getNamesOfMember: self memid count: self cParams + 1]!

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

	^bytes int16AtOffset: _OffsetOf_oVft!

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

	^bytes uint16AtOffset: _OffsetOf_wFuncFlags! !
!OS.COM.FUNCDESC categoriesForMethods!
argumentNameFor:!helpers!private! !
argumentNames!accessing!public! !
arguments!accessing!public! !
basicFree!private!realizing/unrealizing! !
basicIdlAttributes!printing-IDL!private! !
buildArguments!helpers!private! !
callconv!**compiled accessors**!public! !
callingConvention!accessing!public! !
clearMethodName!development!initializing!private! !
cParams!**compiled accessors**!private! !
cParamsOpt!**compiled accessors**!public! !
cScodes!**compiled accessors**!private! !
elemDesc!accessing!public! !
elemdescFunc!**compiled accessors**!public! !
elemDescFunc!accessing!public! !
flags!accessing!private! !
funckind!**compiled accessors**!public! !
getAllCustData!accessing!private! !
hasRetval!public!testing! !
idlCallingConvention!printing-IDL!private! !
invkind!**compiled accessors**!public! !
isDispatchable!public!testing! !
isMethod!public!testing! !
isPropGet!public!testing! !
isPropPut!public!testing! !
isPropPutRef!public!testing! !
isPropSet!public!testing! !
isReadOnly!public!testing! !
isRequestEdit!public!testing! !
isRestricted!public!testing! !
isVirtual!public!testing! !
lprgelemdescParam!**compiled accessors**!public! !
lprgscode!**compiled accessors**!public! !
memid!**compiled accessors**!public! !
name!accessing!public! !
names!accessing!private! !
optionalInputs!accessing!private! !
outputIndices!accessing!private! !
oVft!**compiled accessors**!public! !
retvalIndex!accessing!private! !
selector!accessing!public! !
tdescFunc!accessing!private! !
vfnIndex!accessing!private! !
wFuncFlags!**compiled accessors**!public! !
!

!OS.COM.FUNCDESC class methodsFor!

byteSize
	^_FUNCDESC_Size!

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
		defineField: #memid type: Int32Field readOnly;
		defineField: #lprgscode
			type: (StructureArrayPointerField type: HRESULT
					arrayLength: (ConformantArrayFieldLength lengthField: #cScodes)) beReadOnly;
		defineField: #lprgelemdescParam
			type: (StructureArrayPointerField type: ELEMDESC
					arrayLength: (ConformantArrayFieldLength lengthField: #cParams)) beReadOnly;
		defineField: #funckind type: Int32Field readOnly;
		defineField: #invkind type: Int32Field readOnly;
		defineField: #callconv type: Int32Field readOnly;
		defineField: #cParams type: Int16Field readOnly beNonBrowsable;
		defineField: #cParamsOpt type: Int16Field readOnly;
		defineField: #oVft type: Int16Field readOnly;
		defineField: #cScodes type: Int16Field readOnly beNonBrowsable;
		defineField: #elemdescFunc type: (StructureField type: ELEMDESC) beReadOnly;
		defineField: #wFuncFlags type: UInt16Field readOnly!

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
!OS.COM.FUNCDESC class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
stbConvertFrom:!binary filing!development!public! !
stbVersion!binary filing!development!public! !
!

