"Filed out from Dolphin Smalltalk 7"!

GenericExternalArray subclass: #SAFEARRAY
	instanceVariableNames: 'data start recordInfo'
	classVariableNames: ''
	poolDictionaries: 'AXAutomationConstants AXAutomationErrors'
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cbElements' -> 16r4.
		'_OffsetOf_cDims' -> 16r0.
		'_OffsetOf_cLocks' -> 16r8.
		'_OffsetOf_fFeatures' -> 16r2.
		'_OffsetOf_pvData' -> 16rC.
		'_OffsetOf_rgsabound' -> 16r10
	}!
SAFEARRAY guid: (GUID fromString: '{c06f3b6a-0868-11d3-93af-00a024ca708a}')!
SAFEARRAY comment: 'SAFEARRAY is an <ExternalArray> class to represent the OLE Automation arrays.

SAFEARRAYs are a flexible representation of potentially multiple dimensioned arrays of almost any of the Variant (Visual Basic) types.

SAFEARRAY has similar behaviour to <StructureArray> in providing a means to map externally implemented arrays of values to appropriate Smalltalk objects (mostly from the <ExternalStructure> hierarchy), and thus (as of Dolphin 6) these share implemenation via a common abstract superclass.

Note that the reported length of a SAFEARRAY is actually the length of the rightmost (least significant) dimension.

Instance Variables:
	data		<ExternalAddress>. Pointer to data of array, when locked.
	start		<integer>. Lower bound of rightmost (least significant) dimension.
'!
!SAFEARRAY categoriesForClass!External-Data-Structured! !
!SAFEARRAY methodsFor!

_deepenShallowCopy: clone trail: copiesDictionary
	"Private - Deepen the argument, clone, which is a shallow copy of the receiver.
	Answer the deepened shallow copy.
	Implementation Note: We need to override this in order to correctly deepen 
	the contents instance variable by copying the referenced SAFEARRAY."

	clone beNullPointer.
	OLEAutLibrary default safeArrayCopy: self ppsaout: clone.
	^clone!

accessData
	"Private - Answer the address of the data buffer in which the receiver's elements
	are stored. This entails locking down the buffer."

	| pvData |
	self assert: [data isNull].
	pvData := ExternalAddress new.
	OLEAutLibrary default safeArrayAccessData: self ppvData: pvData.
	"We'll need finalization to unlock"
	self beFinalizable.
	^pvData!

asObject
	"Answer the <Object> value represented by the receiver
	(an <Array> of <Objects>)."

	^self elementClass == BYTE 
		ifTrue: [ByteArray fromAddress: self base length: self size]
		ifFalse: [self asArray]!

asSAFEARRAY
	"Answer the SAFEARRAY representation of the receiver."

	^self!

asVariant
	"Answer the VARIANT representation of the receiver."

	^VARIANT new
		array: self copy;
		yourself
!

base
	data isNull ifTrue: [data := self accessData asInteger].
	^data!

cbElements
	"Answer the <Integer> value of the receiver's 'cbElements' field."

	^bytes dwordAtOffset: _OffsetOf_cbElements!

cDims
	"Private - Answer the <Integer> value of the receiver's 'cDims' field."

	^bytes wordAtOffset: _OffsetOf_cDims!

cLocks
	"Answer the <Integer> value of the receiver's 'cLocks' field."

	^bytes dwordAtOffset: _OffsetOf_cLocks!

copy
	"Answer a suitable copy of the receiver, which does not share the same 
	SAFEARRAY data."

	| pcopy |
	pcopy := self pointerClass new.
	OLEAutLibrary default safeArrayCopy: self ppsaout: pcopy.
	^self class fromAddress: pcopy elementClass: self elementClass owner: nil!

data
	"Answer the address of the data buffer in which the receiver's elements
	are stored. This entails locking down the buffer."

	^self base asExternalAddress!

deduceElementClass
	"Private - Deduce an appropriate class of object to be used to represent the elements of the
	receiver by examining the fFeatures field."

	| f |
	f := self fFeatures.
	(f allMask: FADF_BSTR) ifTrue: [^BSTR].
	(f allMask: FADF_VARIANT) ifTrue: [^VARIANT].
	(f allMask: FADF_HAVEIID) 
		ifTrue: 
			[| class |
			class := COMInterface classForIID: self iid ifNone: [].
			class isNil 
				ifTrue: 
					["Not a recognised interface class so drop through and
					 return IDispatch or IUnknown depending on remaining flags"
					]
				ifFalse: [^class]].
	(f allMask: FADF_DISPATCH) ifTrue: [^IDispatch].
	(f allMask: FADF_UNKNOWN) ifTrue: [^IUnknown].
	(f allMask: FADF_RECORD) ifTrue: [^self recordClass ifNil: [self genericRecordClass]].
	(f allMask: FADF_HAVEVARTYPE) ifTrue: [^VARIANT classForVT: self vartype].
	^self error: 'Unrecognised safe array element type'!

detach
	"Detach the receiver from the underlying SAFEARRAY (useful for passing
	ownership."

	owner isNil 
		ifFalse: 
			[owner detach.
			owner := nil].
	self unaccessData.
	^super detach!

dimensions
	"Answer the number of dimensions in the receiver.
	Note: It is more efficient to access this as a structure member through cDims,
	but MS recommend using the (more object-oriented) functions."

	^OLEAutLibrary default safeArrayGetDim: self!

elementAt: aSequencedReadableCollectionOfInteger
	"Answer the element of the receiver at the location identified by the <sequencedReadableCollection> of <integer> argument."

	"Notes:
	1) This is likely to be rather slow because of the nature of the SAFEARRAY API, and if more than a few elements are to be accessed I'd recommend going directly through the pointer to the data accessible via the #data method (e.g. see the #from:to:keysAndValuesDo: method).
	2) SafeArrayGetElemnt copies the data if it is a BSTR, VARIANT, IDispatch, IUnknown, or UDT (VT_RECORD), and therefore the element will need freeing in those cases, however this will be done automatically by finalization."

	| buf rgIndices sz |
	buf := self elementClass newBuffer.	"We get ownership"
	sz := aSequencedReadableCollectionOfInteger size.
	rgIndices := SDWORDArray new: sz.
	1 to: sz do: [:i | rgIndices uncheckedAt: i put: (aSequencedReadableCollectionOfInteger at: i)].
	OLEAutLibrary default
		safeArrayGetElement: self
		rgIndices: rgIndices
		pv: buf.
	^buf!

elementAt: aSequencedReadableCollectionOfInteger put: anExternalObject
	"Set the value of the  the element of the receiver at the location identified by the <sequencedReadableCollection> of <integer> first argument to the 2nd argument, which must be of the element class of the receiver."

	| rgIndices sz |
	sz := aSequencedReadableCollectionOfInteger size.
	rgIndices := SDWORDArray new: sz.
	1 to: sz do: [:i | rgIndices uncheckedAt: i put: (aSequencedReadableCollectionOfInteger at: i)].
	OLEAutLibrary default
		safeArrayPutElement: self
		rgIndices: rgIndices
		pv: anExternalObject.
	^anExternalObject!

elementClass
	"Answer the class of object to be used to represent the receiver's 
	elements.	It may have to be deduced from the fFeatures element of the structure."

	elementClass isNil ifTrue: [elementClass := self deduceElementClass].
	^elementClass!

elementCount
	"Private - Answer the total number of elements in all dimensions of the receiver."

	^(1 to: self dimensions) inject: 1 into: [:sz :i | sz * (self sizeOfDimension: i)]
	!

elementSize
	"Answer the size in bytes of the indidividual elements of the receiver."

	^self cbElements!

fFeatures
	"Answer the <Integer> value of the receiver's 'fFeatures' field."

	^bytes wordAtOffset: _OffsetOf_fFeatures!

free
	"Free external resources owned by the receiver."

	"Implementation Note: Whether we free the data or not we must
	make sure that we remove any lock for which we are responsible."

	self unaccessData.
	super free!

genericRecordClass
	^AXRecord!

hasRecordInfo
	"Private - Answer whether there an <IRecordInfo> describing the receiver's elements is
	available."

	^recordInfo notNull or: [self fFeatures allMask: FADF_RECORD]!

iid
	"Answer the IID of the interface pointers stored in the receiver - only valid
	if the receiver is constructed to contain interface pointers."

	| answer |
	answer := IID new.
	OLEAutLibrary default safeArrayGetIID: self pguid: answer.
	^answer!

initializePointer
	"Private - Perform any initialization required for the receiver
	which is specific to the reference form. Answer the receiver."

	data := owner := nil.
	self beFinalizable!

length
	"Answer the number of elements in the least significant (rightmost) bound 
	of the receiver. This really only makes sense for single-dimensioned vectors."

	length isNil 
		ifTrue: 
			[| dims |
			length := (dims := self dimensions) == 0 ifTrue: [0] ifFalse: [self sizeOfDimension: dims]].
	^length!

length: rightDimLength
	"Set the length (in elements, not bytes) of the right most (least significant)
	dimension of the array. This only really makes sense (in terms of the inherited
	protocol) for single-dimensioned vectors."

	| lower |
	lower := self start.
	"Now we must redimension."
	self redim: (lower to: rightDimLength+lower-1)!

lowerBound: anInteger
	"Answer the lower bound of the specified dimension of the receiver. Typically this will be 1."

	| lBound |
	lBound := DWORDBytes new.
	OLEAutLibrary default
		safeArrayGetLBound: self
		nDim: anInteger
		plLbound: lBound.
	^lBound asSignedInteger!

newElementAt: anAddress 
	"Private - Answer a new reference instance of the receiver's element class, pointing at the
	element at the specified memory address."

	| elemFactory |
	elemFactory := self elementClass.
	^elemFactory == self genericRecordClass 
		ifTrue: 
			[elemFactory 
				fromAddress: anAddress
				recordInfo: self recordInfo
				owner: self]
		ifFalse: [elemFactory atAddress: anAddress]!

onStartup
	"Private - Clear down the receiver as it is pointing at an externally allocated
	safe array from the session when the image was saved which no longer exists."

	self beUnfinalizable.
	owner := nil.
	data := bytes := nil.
	length := 0!

pvData
	"Answer the <ExternalAddress> value of the receiver's 'pvData' field."

	^(bytes uintPtrAtOffset: _OffsetOf_pvData) asExternalAddress!

queryRecordInfo
	| recInfo |
	self hasRecordInfo ifFalse: [^nil].
	recInfo := IRecordInfo newPointer.
	OLEAutLibrary default safeArrayGetRecordInfo: self prinfo: recInfo.
	^recInfo!

recordClass
	"Private - Answer the <ExternalStructure> class registered for the <GUID> of the receiver's
	record information, of nil if none is registered. Note that even if no precompiled structure
	class is registered for the GUID, the array elements can still be accessed using the generic
	AXRecord class, which implements late bound access to the structure elements using the
	information supplied by the <IRecordInfo> interrface."

	^ExternalStructure classForGUID: self recordInfo guid ifNone: []!

recordInfo
	"Answer the <IRecordInfo> associated with the receiver (if the receiver is of type
	VT_RECORD), or nil if the receiver's elements are not of type VT_RECORD, or if no record
	info was provided when the array was constructed."

	recordInfo isNull ifTrue: [recordInfo := self queryRecordInfo].
	^recordInfo!

redim: interval
	"Set the bounds of the right most (least significant) dimension of
	the safe array. It is only possible to change the last dimension."

	| bound |
	self unaccessData.
	start := length := nil.
	bound := SAFEARRAYBOUND new.
	bound lLbound: interval start; cElements: interval size.
	OLEAutLibrary default
		safeArrayRedim: self psaboundNew: bound!

rgsabound
	"Answer the <StructureArray> value of the receiver's 'rgsabound' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_rgsabound
		length: self cDims
		elementClass: SAFEARRAYBOUND!

sizeOfDimension: anInteger
	"Answer the size (difference between upper and lower bounds) of the specified dimension of the receiver."

	^(self upperBound: anInteger) - (self lowerBound: anInteger) + 1!

start
	"Private - Answer the lower bound of the receiver's least significant dimension."

	start isNil ifTrue: [start := self lowerBound: self dimensions].
	^start!

unaccessData
	"Private - Reverse a previous #accessData if necessary."

	data notNull 
		ifTrue: 
			[data := nil.
			OLEAutLibrary default safeArrayUnaccessData: self]!

uncheckedAt: anInteger put: anObject
	"Private - Set the value of the element of the receiver at the specified <integer> index to the specified value, which must be representable by the element class of the receiver. Assumes that the receiver is a single-dimensioned array, if not an error will result. 
	Note: This isn't likely to be terribly fast!!"

	self elementAt: {anInteger + self start - 1} put: (self elementClass fromObject: anObject).
	^anObject!

upperBound: anInteger
	"Answer the upper bound of the specified dimension of the receiver."

	| uBound |
	uBound := DWORDBytes new.
	OLEAutLibrary default
		safeArrayGetUBound: self
		nDim: anInteger
		plUbound: uBound.
	^uBound asSignedInteger!

vartype
	"Answer the variant type of the receiver's elements. Note that this also includes various flags, so it is not a raw VT_XXX type number."

	| vt |
	vt := ByteArray new: 2.
	OLEAutLibrary default safeArrayGetVartype: self pvt: vt.
	^vt wordAtOffset: 0!

vt
	"Answer the receiver's variant type. This will depend on the element type, but always includes the array modifier."

	^self class vt bitOr: self elementClass vt!

with: otherCollection do: operation
	"Evaluate the <dyadicValuable> argument, operation, with each of 
	the receiver's elements along with the corresponding element from the 
	<sequencedReadableCollection> argument, otherCollection. 
	Raise an exception if otherCollection is not the same size as the receiver."

	self size = otherCollection size
		ifFalse: [^self error: 'collections are of different sizes'].
	self keysAndValuesDo: [:i :elem |
		operation
			value: elem
			value: (otherCollection at: i)]! !
!SAFEARRAY categoriesFor: #_deepenShallowCopy:trail:!copying!private! !
!SAFEARRAY categoriesFor: #accessData!helpers!private! !
!SAFEARRAY categoriesFor: #asObject!converting!public! !
!SAFEARRAY categoriesFor: #asSAFEARRAY!converting!public! !
!SAFEARRAY categoriesFor: #asVariant!converting!public! !
!SAFEARRAY categoriesFor: #base!accessing!private! !
!SAFEARRAY categoriesFor: #cbElements!**compiled accessors**!public! !
!SAFEARRAY categoriesFor: #cDims!**compiled accessors**!private! !
!SAFEARRAY categoriesFor: #cLocks!**compiled accessors**!public! !
!SAFEARRAY categoriesFor: #copy!copying!public! !
!SAFEARRAY categoriesFor: #data!accessing!public! !
!SAFEARRAY categoriesFor: #deduceElementClass!helpers!private! !
!SAFEARRAY categoriesFor: #detach!public!realizing/unrealizing! !
!SAFEARRAY categoriesFor: #dimensions!accessing!public! !
!SAFEARRAY categoriesFor: #elementAt:!accessing!public! !
!SAFEARRAY categoriesFor: #elementAt:put:!accessing!public! !
!SAFEARRAY categoriesFor: #elementClass!constants!public! !
!SAFEARRAY categoriesFor: #elementCount!accessing!private! !
!SAFEARRAY categoriesFor: #elementSize!accessing!public! !
!SAFEARRAY categoriesFor: #fFeatures!**compiled accessors**!public! !
!SAFEARRAY categoriesFor: #free!public!realizing/unrealizing! !
!SAFEARRAY categoriesFor: #genericRecordClass!constants!private! !
!SAFEARRAY categoriesFor: #hasRecordInfo!private!testing! !
!SAFEARRAY categoriesFor: #iid!accessing!public! !
!SAFEARRAY categoriesFor: #initializePointer!initializing!private! !
!SAFEARRAY categoriesFor: #length!accessing!public! !
!SAFEARRAY categoriesFor: #length:!accessing!public! !
!SAFEARRAY categoriesFor: #lowerBound:!accessing!public! !
!SAFEARRAY categoriesFor: #newElementAt:!helpers!private! !
!SAFEARRAY categoriesFor: #onStartup!event handling!private! !
!SAFEARRAY categoriesFor: #pvData!**compiled accessors**!public! !
!SAFEARRAY categoriesFor: #queryRecordInfo!helpers!private! !
!SAFEARRAY categoriesFor: #recordClass!helpers!private! !
!SAFEARRAY categoriesFor: #recordInfo!accessing!public! !
!SAFEARRAY categoriesFor: #redim:!operations!public! !
!SAFEARRAY categoriesFor: #rgsabound!**compiled accessors**!public! !
!SAFEARRAY categoriesFor: #sizeOfDimension:!accessing!public! !
!SAFEARRAY categoriesFor: #start!accessing!private! !
!SAFEARRAY categoriesFor: #unaccessData!helpers!private! !
!SAFEARRAY categoriesFor: #uncheckedAt:put:!accessing!private! !
!SAFEARRAY categoriesFor: #upperBound:!accessing!public! !
!SAFEARRAY categoriesFor: #vartype!accessing!public! !
!SAFEARRAY categoriesFor: #vt!constants!public! !
!SAFEARRAY categoriesFor: #with:do:!enumerating!public! !

SAFEARRAY methodProtocol: #variantCompatible attributes: #(#readOnly) selectors: #(#asVariant)!

!SAFEARRAY class methodsFor!

clear: addressOrBytes
	"Free an instance of the structure which instances of the receiver wrap
	which resides at the specified address."

	| hr |
	hr := OLEAutLibrary default safeArrayDestroy: addressOrBytes.
	hr < 0 ifFalse: [^self].
	"If the array is merely locked, then attempt to unlock it"
	hr = DISP_E_ARRAYISLOCKED 
		ifTrue: 
			["Set cLocks to 1, and then call unlock"

			addressOrBytes dwordAtOffset: 8 put: 1.
			hr := (OLEAutLibrary default)
						safeArrayUnlock: addressOrBytes;
						safeArrayDestroy: addressOrBytes].
	"If still locked after a large number of attempts, or some other error, then report it"
	hr < 0 ifTrue: [^HRESULTError signalWith: hr]!

createVector: lenInteger vt: vtInteger extra: pvExtra 
	"Private - Answer a pointer to a new vector (single dimensioned)
	SAFEARRAY of the specified size and element type, allocated
	by the OLE Automation Library. The lower bound is defaulted to 
	zero for compatibility with VB."

	| answer |
	answer := OLEAutLibrary default 
				safeArrayCreateVectorEx: vtInteger
				lLbound: 0
				cElements: lenInteger
				pvExtra: pvExtra.
	answer isNull 
		ifTrue: 
			["Unfortunately we don't know why it failed, because the call does not return an HRESULT, 
			 and doesn't SetLastError() either"

			^self error: 'Failed to create vector'].
	answer beFinalizable.
	^answer!

defineFields
	"Define the fields of the SAFEARRAY structure.

		SAFEARRAY compileDefinition.

		struct SAFEARRAY {
			unsigned short cDims;					// Number of dimensions in the array
			unsigned short fFeatures;					// Flags
			unsigned long cbElements;				// Element size
			unsigned long cLocks;					// Lock count
			void HUGEP* pvData; 					// Array data
			SAFEARRAYBOUND rgsabound[1];			// One bound for each dimension
		}; "

	self
		defineField: #cDims type: WORDField readOnly beNonBrowsable;
		defineField: #fFeatures type: WORDField readOnly;
		defineField: #cbElements type: DWORDField readOnly;
		defineField: #cLocks type: DWORDField readOnly;
		defineField: #pvData type: LPVOIDField readOnly;
		defineField: #rgsabound
			type: (StructureArrayField type: SAFEARRAYBOUND
					arrayLength: (ConformantArrayFieldLength lengthField: #cDims)) beReadOnly!

elementSize
	"Answer the size (in bytes) of the structure the receiver represents
	when used as an array element."

	^self byteSize!

fromAddress: anAddress
	"Answer a new SAFEARRAY object referencing and owning the native SAFEARRAY at the specified address.
	As the array is considered owned, it will be freed by finalization when the new object is finalized."

	^self fromAddress: anAddress owner: nil!

fromAddress: psa elementClass: varClass owner: arrayOwner 
	"Answer a new instance that points to the SAFEARRAY at
	the address, psa, which contains elements of <variantCompatible>
	class, varClass.  The instance will not free the safe array at psa
	unless the arrayOwner is nil."

	^psa isNull 
		ifFalse: 
			[(self basicNew)
				initializeAtAddress: psa;
				elementClass: varClass;
				owner: arrayOwner;
				yourself]!

fromAddress: anAddress owner: anObject
	"Answer a new SAFEARRAY object referencing the native SAFEARRAY at the specified address, with the owner, anObject.
	Unless anObject is nil, the native SAFEARRAY will not be freed when the new SAFEARRAY object goes out of scope. If anObject is nil, then the array is considered owned, it will be freed by finalization when the new object is finalized."

	^self
		fromAddress: anAddress
		elementClass: nil
		owner: anObject!

fromAddress: psa vt: vartype owner: arrayOwner
	"Answer a new instance that points to the SAFEARRAY at
	the address, psa, which contains elements of Variant type,
	vartype. The instance will not free the safe array at psa
	unless the arrayOwner is nil."

	^self 
		fromAddress: psa 
		elementClass: (VARIANT classForVT: vartype)
		owner: arrayOwner!

initialize
	"Private - Initialize the receiver.
	Register with session events to clean up sub-instances on startup and exit.
	
		SAFEARRAY initialize
	"

	SessionManager current 
		when: #sessionStarted
		send: #onStartup
		to: self!

length: length elementClass: elementClass
	"Answer a new vector (single dimensioned) safe array that 
	contains <integer>, length, elements of type, elementClass.
	The instance regards itself as the owner of the underlying
	safe array and will free it on receipt of a #free message, 
	or upon finalization, unless previously sent a #detach message."

	^elementClass newSAFEARRAY: length!

length: count elementSize: bytes
	"Private - Answer a new instance of the receiver allocated 
	with space for <integer>, count, elements of <integer>, bytes,
	size.
	Implementation Note: The size is ignored and the new instance
	holds <VARIANT>s."

	^self length: count elementClass: VARIANT!

length: length interfaceClass: comInterfaceClass
	"Answer a new instance of the receiver that owns a buffer
	of sufficient size to contain <integer>, length, interface pointers.
	The instance regards itself as the owner of the underlying
	safe array and will free it on receipt of a #free message, 
	or upon finalization, unless previously sent a #detach message."

	| vt answer |
	vt := comInterfaceClass vt.
	answer := self createVector: length vt: vt extra: comInterfaceClass iid.
	answer elementClass: comInterfaceClass.
	^answer!

length: length recordClass: recordClass
	"Answer a new instance of the receiver that owns a buffer
	of sufficient size to contain <integer>, length, interface pointers.
	The instance regards itself as the owner of the underlying
	safe array and will free it on receipt of a #free message, 
	or upon finalization, unless previously sent a #detach message."

	| answer |
	answer := self createVector: length vt: VT_RECORD extra: recordClass recordInfo.
	answer elementClass: recordClass.
	^answer!

length: length vt: vt
	"Answer a new instance of the receiver that owns a buffer
	of sufficient size to contain <integer>, length, elements of the variant type
	identified by the <integer> argument, vt.
	The instance regards itself as the owner of the underlying
	safe array and will free it on receipt of a #free message, 
	or upon finalization, unless previously sent a #detach message."

	^self 
		length: length
		elementClass: (VARIANT classForVT: vt)!

length: length vt: vt elementClass: elementClass
	"Private - Answer a new instance of the receiver that owns a buffer
	of sufficient size to contain <integer>, length, elements of the variant type
	identified by the <integer> argument, vt. The elements are of the structure
	class, elementClass."

	| answer |
	answer := self createVector: length vt: vt extra: nil.
	answer elementClass: elementClass.
	^answer!

newBuffer
	"Answer a new instance of the receiver.
	Implementation Note: SAFEARRAYs are reference only."

	^self newPointer!

onStartup
	"Private - Ensure all the receiver's subinstances are in their clean state on startup
	rather than attempting to use an old safe array hanging around from the sesssion 
	when the image was saved."

	self primAllSubinstances do: [:i | i onStartup].!

uninitialize
	SessionManager current removeEventsTriggeredFor: self!

vt
	"Answer the receiver's variant type. The actual type of instances will 
	depend on the element type, but it will always include this array modifier."

	^VT_ARRAY! !
!SAFEARRAY class categoriesFor: #clear:!public!realizing/unrealizing! !
!SAFEARRAY class categoriesFor: #createVector:vt:extra:!helpers!private! !
!SAFEARRAY class categoriesFor: #defineFields!public!template definition! !
!SAFEARRAY class categoriesFor: #elementSize!accessing!public! !
!SAFEARRAY class categoriesFor: #fromAddress:!instance creation!public! !
!SAFEARRAY class categoriesFor: #fromAddress:elementClass:owner:!instance creation!public! !
!SAFEARRAY class categoriesFor: #fromAddress:owner:!instance creation!public! !
!SAFEARRAY class categoriesFor: #fromAddress:vt:owner:!instance creation!public! !
!SAFEARRAY class categoriesFor: #initialize!development!initializing!private! !
!SAFEARRAY class categoriesFor: #length:elementClass:!instance creation!public! !
!SAFEARRAY class categoriesFor: #length:elementSize:!instance creation!private! !
!SAFEARRAY class categoriesFor: #length:interfaceClass:!instance creation!public! !
!SAFEARRAY class categoriesFor: #length:recordClass:!instance creation!public! !
!SAFEARRAY class categoriesFor: #length:vt:!instance creation!public! !
!SAFEARRAY class categoriesFor: #length:vt:elementClass:!instance creation!private! !
!SAFEARRAY class categoriesFor: #newBuffer!instance creation!public! !
!SAFEARRAY class categoriesFor: #onStartup!event handling!private! !
!SAFEARRAY class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!SAFEARRAY class categoriesFor: #vt!constants!public! !

