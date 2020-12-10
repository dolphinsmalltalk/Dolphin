"Filed out from Dolphin Smalltalk 7"!

External.Structure subclass: #COMInterface
	instanceVariableNames: 'implementor'
	classVariableNames: 'InterfaceClasses'
	imports: #(#{Smalltalk.OLEConstants private} #{OS.Win32Constants private} #{OS.Win32Errors private})
	classInstanceVariableNames: 'argSizes functions typeLib'
	classConstants: {
		'_OffsetOf_argSizes' -> 16r4.
		'_OffsetOf_interfaceCookie' -> 16rC.
		'_OffsetOf_objectCookie' -> 16r8.
		'_OffsetOf_vtbl' -> 16r0
	}!
COMInterface guid: (IID fromString: '{87b4c591-026e-11d3-9fd7-00a0cc3e4a32}')!
COMInterface isNonInstantiable: true!
COMInterface comment: ''!
!COMInterface categoriesForClass!External-Data-Structured-COM! !
!COMInterface methodsFor!

_addRef 
	"Private - Increment the receiver's reference count, ignoring the request
	if null."

	self isNull ifFalse: [self AddRef]
!

= anObject
	"Answer whether the receiver is equivalent to the <Object>, anObject.
	Two COMInterfaces are only considered equal if they have the same IID and
	the the same address (but see also #isSameCOMObject: which is a more
	expensive comparison which tests for the same underlying COM object)."

	^self == anObject or: [
		self species == anObject species and: [
			bytes = anObject bytes]]!

AddRef
	"Increment the object's reference count."

	^self subclassResponsibility!

argSizes: anExternalAddress
	"Set the receiver's 'argSizes' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: _OffsetOf_argSizes put: anExternalAddress!

asParameter
	"Answer the receiver in a form suitable for passing
	to an ExternalLibrary call, as itself in fact."

	^self!

attach: interfaceAddress
	"Attach the receiver to the interface at the specified address.	
	Note that this effectively takes ownership of an orphan interface
	pointer in that no further reference is added to that pointer."

	bytes := interfaceAddress asExternalAddress.
	self beFinalizable
!

basicFree
	"Private - Free the receiver's external resources by releasing the interface."

	| refs |
	refs := self Release.
	"Notification signal: 'Releasing ', self printString, ' ref count=', refs printString."
	(self isPointer or: [refs == 0]) ifTrue: [bytes := nil]
		

	!

callback: stub vfn: vfnIndex withArgumentsAt: pArgs
	"Private - On behalf of the <COMObjectStub>, stub, invoke the 
	appropriate callback function identified by vfnIndex within the receiver's 
	class' callback table, instantiating any arguments from the machine
	stack starting at <integer> address, pArgs."

	^(self class functions basicAt: vfnIndex)
		callback: stub interface: self withArgumentsAt: pArgs!

copy
	"Answer a suitable copy of the receiver, which does not share the same byte data."

	^self shallowCopy postCopy!

detach
	"Detach the receiver from the interface at which it is pointing, answering the address
	of that interface. This is useful where one wishes to take-over an interface
	reference (e.g. to pass it to some external party), and to assume the reference count."

	^self isPointer 
		ifTrue: 
			[| pInterface |
			pInterface := self bytes.
			bytes := nil.
			self beUnfinalizable.	"reduce Memory Manager load"
			pInterface]
		ifFalse: 
			[self AddRef.
			self yourAddress asExternalAddress]!

free
	"Private - Frees the receiver's external resources by releasing the interface. 
	Normally inside Smalltalk we have no need to call #AddRef and #Release explicitly 
	since we can rely on the internal garbage collection and finalization to do the same job.
	We can rely on the reference count of internally implemented interfaces being correct,
	but not those we access via pointers."

	(bytes notNil and: [(bytes basicDwordAtOffset: 0) ~~ 0])
		ifTrue: [self basicFree].
	self beUnfinalizable		

	!

getExtendedErrorInfo: excep
	"Private - Add extended error information to the <HRESULTError> argument, if available."

	| errorInfo |
	self supportsErrorInfo ifFalse: [^self].
	errorInfo := IErrorInfo newPointer.
	(OLEAutLibrary default getErrorInfo: 0 pperrinfo: errorInfo) == S_OK
		ifTrue: [excep errorInfo: errorInfo]!

hash
	"Answer the SmallInteger hash value for the receiver."

	^bytes hash!

hresultError: hr
	"Signal that a member function in the receiver returned the specified hresult.
	Include the COM object's extended error information, if available."

	| excep |
	excep := HRESULTError fromInteger: hr.
	self isNull ifFalse: [self getExtendedErrorInfo: excep].
	^excep signal!

identity
	"Answer an Integer that uniquely identifies the object onto which the receiver is an interface.
	The COM specification guarantees this ability of IUnknown pointers only."

	| iUnk id |
	self class == IUnknown ifTrue: [^self yourAddress].
	iUnk := self queryInterface: IUnknown.
	id := iUnk yourAddress.
	iUnk free.	"Explicitly free this to avoid generating excessive garbage"
	^id!

iid
	"Answer the receiver's globally unique interface id (IID).
	In general this is fixed across all instances of the receiver's class."

	^self class iid!

implementor
	"Answer the receiver's implementing object."

	^implementor!

implementor: anObject
	"Set the receiver's implementor to anObject."

	implementor := anObject!

initialize: anInteger
	"Private - Create an external buffer in the receiver of the specified size.
	The receiver (which is being created as an interface on a Dolphin COMObject)
	contains an instance thunk which starts with a pointer to the generic
	virtual function table. The id/subId fields are filled out later when the 
	interface is registered."

	super initialize: anInteger.
	self vtbl: VMLibrary default getVTable.
	self argSizes: self class argSizes yourAddress!

initializeAtAddress: anAddress
	"Private - Initialize the receiver to be a reference to a COMInterface at 
	the specified address i.e. as a pointer to some interface which is probably
	implemented outside Dolphin (though not necessarily).
	Note that an OLE reference is added, which will be removed by finalization
	if the receiver is not explicitly freed."

	super initializeAtAddress: anAddress.
	self beFinalizable.
	self _addRef!

interfaceCookie: anInteger
	"Set the receiver's 'interfaceCookie' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_interfaceCookie put: anInteger!

isSameCOMObject: aCOMInterface
	"Answer true if aCOMInterface has the same underlying COMObject as the receiver."

	^self identity = aCOMInterface identity!

objectCookie: anInteger
	"Set the receiver's 'objectCookie' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_objectCookie put: anInteger!

onExit
	"Clean up the external interface pointer on image exit to free external resources"

	(self isPointer and: [self isFinalizable]) ifTrue: [self free]!

onStartup
	"Clean up the external interface pointer on image startup so that it isn't left
	pointing at an invalid object."

	self isPointer
		ifTrue: [
			self beUnfinalizable.
			bytes := nil]

	!

postCopy
	"Apply any final flourish to the copy that may be required.
	In this case we may need to AddRef()."

	self isPointer ifTrue: [self _addRef].
	^self!

printOn: aStream
	"Append a developer friendly textual representation of the receiver to aStream.
	As OLE interfaces are opaque, pure, interfaces, we revert to the basic
	implementation, but include the address as this may help."

	aStream 
		basicPrint: self;
		nextPut: $(;
		print: bytes;
		nextPut: $)!

queryInterface: interfaceClass
	"Query, via the receiver, for the specified interface class, answering a new pointer
	to that interface, or nil if it is not implemented by the receiver."

	^self queryInterface: interfaceClass ifNone: []!

queryInterface: anInterfaceClass ifNone: exceptionHandler
	"Query, via the receiver, for the specified interface class, answering a new pointer
	to that interface, or the result of evaluating the niladic valuable, exceptionHandler,
	if it is not implemented by the receiver.
	Implementation Note: We do not consider E_NOINTERFACE to be an error, or even an 
	exceptional condition - S_FALSE would seem a more suitable answer to a query."

	| pUnk hresult |
	pUnk := anInterfaceClass newPointer.
	hresult := self QueryInterface: anInterfaceClass iid ppvObject: pUnk.
	^hresult < 0 
		ifTrue: [
			(hresult = E_NOINTERFACE or: [hresult = -2147023179])
				ifTrue: [exceptionHandler value]
				ifFalse: [self hresultError: hresult]]
		ifFalse: [pUnk]!

QueryInterface: riid ppvObject: ppvObject 
	^self subclassResponsibility!

referenceCount
	"Private - Answer the current reference count of the receiver.
	N.B. FOR DEBUGGING ONLY."

	^self isNull
		ifTrue: [0]
		ifFalse: [self AddRef; Release]!

Release
	"Decrement the object's ref. count, and delete if it drops to zero."

	^self subclassResponsibility!

supportsErrorInfo
	"Answer whether the receiver supports extended Automation error information."

	^self supportsErrorInfo: self class!

supportsErrorInfo: interface 
	"Answer whether the <COMInterface>, interface, as implemented by the receiver supports
	extended Automation error information.
	Implementation Note: Some COM Objects (e.g. Microsoft Agent 2) have a bug whereby 
	they claim not to support error info at their most derived interfaces (e.g. IAgentCtlEx) but 
	change their minds when 	one moves up the inheritance chain. We provide a general 
	workaround for this bug here by asking each interface up to (but not including) IUnknown.
	Note also that we call QueryInterface() directly to avoid the possibility of a recursive error
	as this method is usually invoked when handling an error."

	| piSEI hr |
	piSEI := ISupportErrorInfo newPointer.
	hr := self QueryInterface: ISupportErrorInfo iid ppvObject: piSEI.
	hr == S_OK 
		ifTrue: 
			[| itfClass |
			itfClass := interface.
			[itfClass == IUnknown] whileFalse: 
					["The MonthView control has a horrible bug whereby it
					 overwrites the first four bytes of the GUID argument, so to
					 work around that (and the same potential bug elsewhere), we
					 pass a copy of the IID."
					(piSEI InterfaceSupportsErrorInfo: itfClass iid copy) == S_OK ifTrue: [^true].
					itfClass := itfClass superclass]].
	^false!

supportsIID: anIID
	"Answer whether the receiver supports the interface identified by the IID, anIID.
	The default is to support only those interfaces with an exactly matching IID."

	^self iid = anIID" or: [ anIID iid = IUnknown iid ]"!

supportsInterface: anInterfaceClass
	"Answer whether the receiver supports the interface identified by the argument."

	^self class == anInterfaceClass "isKindOf: anInterfaceClass"!

vtbl: anExternalAddress
	"Set the receiver's 'vtbl' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: _OffsetOf_vtbl put: anExternalAddress! !
!COMInterface categoriesFor: #_addRef!methods!private! !
!COMInterface categoriesFor: #=!comparing!public! !
!COMInterface categoriesFor: #AddRef!methods!public! !
!COMInterface categoriesFor: #argSizes:!**compiled accessors**!public! !
!COMInterface categoriesFor: #asParameter!converting!public! !
!COMInterface categoriesFor: #attach:!initializing!public! !
!COMInterface categoriesFor: #basicFree!private!realizing/unrealizing! !
!COMInterface categoriesFor: #callback:vfn:withArgumentsAt:!evaluating!private! !
!COMInterface categoriesFor: #copy!copying!public! !
!COMInterface categoriesFor: #detach!public!realizing/unrealizing! !
!COMInterface categoriesFor: #free!private!realizing/unrealizing! !
!COMInterface categoriesFor: #getExtendedErrorInfo:!exceptions!private! !
!COMInterface categoriesFor: #hash!comparing!public! !
!COMInterface categoriesFor: #hresultError:!exceptions!public! !
!COMInterface categoriesFor: #identity!accessing!public! !
!COMInterface categoriesFor: #iid!constants!public! !
!COMInterface categoriesFor: #implementor!accessing!public! !
!COMInterface categoriesFor: #implementor:!accessing!public! !
!COMInterface categoriesFor: #initialize:!initializing!private! !
!COMInterface categoriesFor: #initializeAtAddress:!initializing!private! !
!COMInterface categoriesFor: #interfaceCookie:!**compiled accessors**!public! !
!COMInterface categoriesFor: #isSameCOMObject:!public!testing! !
!COMInterface categoriesFor: #objectCookie:!**compiled accessors**!public! !
!COMInterface categoriesFor: #onExit!event handling!public! !
!COMInterface categoriesFor: #onStartup!event handling!public! !
!COMInterface categoriesFor: #postCopy!copying!public! !
!COMInterface categoriesFor: #printOn:!development!printing!public! !
!COMInterface categoriesFor: #queryInterface:!accessing-interfaces!public! !
!COMInterface categoriesFor: #queryInterface:ifNone:!accessing-interfaces!public! !
!COMInterface categoriesFor: #QueryInterface:ppvObject:!methods!public! !
!COMInterface categoriesFor: #referenceCount!development!private! !
!COMInterface categoriesFor: #Release!methods!public! !
!COMInterface categoriesFor: #supportsErrorInfo!public!testing! !
!COMInterface categoriesFor: #supportsErrorInfo:!public!testing! !
!COMInterface categoriesFor: #supportsIID:!public!testing! !
!COMInterface categoriesFor: #supportsInterface:!public!testing! !
!COMInterface categoriesFor: #vtbl:!**compiled accessors**!public! !

!COMInterface class methodsFor!

addFunction: functionClass selector: aSymbol descriptor: aFunctionDescriptor
	"Private - Add a function call definition to the receivers dispatch table."

	functions add: (functionClass
					selector: aSymbol
					descriptor: aFunctionDescriptor)!

argSizes
	"Private - Answer the DWORD array of arg sizes."

	^argSizes!

atAddress: anAddress
	"Answer a new instance of the receiver instantiated from the
	data at the specified address. 
	Implementation Note: Since COMInterfaces always have reference
	form (except in rare cases for the stubs that Dolphin uses internally
	when acting as a COM server), it is assumed that the specified address
	contains an interface pointer, so the address is dereferenced to get
	the actual address."

	^self fromAddress: (anAddress asExternalAddress dwordAtOffset: 0)!

attach: interfaceAddress
	"Attach the a new pointer instance of the receiver to the interface at 
	the specified address. 
	Note that this effectively takes ownership of an orphan interface
	pointer in that no further reference is added to that pointer, and the 
	interface pointer will be released when the instance is GC'd."

	^self basicNew attach: interfaceAddress!

attachInterface: interface
	"Attach a new pointer instance of the receiver to the <COMInterface>,
	interface, which is detached. If interface is instead nil, then answer nil."

	^interface isNil ifFalse: [self attach: interface detach]!

calcArgSizes
	"Private - Work through the callback array, building an table of argument sizes
	corresponding to each virtual callback function. This table is linked into the
	instance thunks of the receiver's instances and used to clean off the stack."

	| sizes count |
	"self instanceCount > 0 ifTrue: [ Warning signal: 'Attempting to redefine COM Interface with outstanding instances' ]."
	sizes := functions collect: [ :cb | cb argumentsSize ].
	count := functions size.
	(argSizes isNil or: [argSizes size < (count*4)]) ifTrue: [argSizes := ByteArray newFixed: count*4].
	1 to: count do: [ :i |
		argSizes dwordAtOffset: (i-1*4) put: (sizes at: i) ].!

classForIID: aGUID
	"Answer the COM interface class (a subclass of the receiver) which
	provides the COM interface identified by the argument, aGUID.
	Note that in general, instances of the class do not actually implement the
	interface, they are just a facade. Raise an error if the GUID is not
	recognised."

	^self classForIID: aGUID 
		ifNone: [self error: 'There is no interface registered for the IID ', aGUID displayString]
	!

classForIID: aGUID ifNone: exceptionHandler
	"Answer the COM interface class (a subclass of the receiver) which
	provides the COM interface identified by the argument, aGUID.
	Note that in general, instances of the class do not actually implement the
	interface, they are just a facade. Answer nil if the GUID is not recognised."

	^InterfaceClasses at: aGUID ifAbsent: exceptionHandler

	!

clear: addressOrBytes
	"Finalize an instance of the structure which instances of the receiver wrap
	which resides at the specified address. Note that this is not about freeing
	the specified memory block, but any resources which it references."

	(IUnknown attach: addressOrBytes) free!

clsid
	"Answer the component id for the receiver's COM class."

	^CLSID null!

comObjectClass
	"Answer the class of COMObjectStub to use for wrapping objects which instantiate
	interfaces which are instances of the receiver."

	^COMObjectStub!

compileFunction: anInteger 
	"Private - Generate a suitable compiled method for the specified COM function."

	| aStream fn |
	fn := self functions at: anInteger.
	aStream := WriteStream on: (Utf8String new: 512).
	aStream
		nextPutAll: fn messageSelectorAndArgumentNames;
		cr;
		tab;
		nextPutAll: '"Callout for the ';
		nextPutAll: self name;
		nextPutAll: '::';
		nextPutAll: (fn selector upTo: $:);
		nextPutAll: '() interface function.';
		cr;
		tab;
		nextPutAll: 'N.B. This method has been automatically generated from ';
		cr;
		tab;
		nextPutAll: 'the vtable defined in ';
		nextPutAll: self name;
		nextPutAll: '>>defineFunctions. DO NOT MODIFY!!"';
		cr;
		cr;
		tab;
		nextPutAll: '<virtual ';
		nextPutAll: fn callingConvention;
		space;
		nextPutAll: fn returnType;
		space;
		display: anInteger.
	fn argumentTypes do: 
			[:t | 
			aStream
				space;
				nextPutAll: t].
	aStream
		nextPut: $>;
		cr;
		tab;
		nextPutAll: '^self invalidCall'.

	"	Notification signal: aStream contents."
	self compile: aStream contents categories: self generatedFunctionCategories!

compileFunctions
	"Initialize the receiver class' structure template and callback table.
	Send this to subclasses of the receiver when you want to be able to invoke functions
	in an interface supplied by a third party (CALL OUT)."

	self removeCompiledFunctions.
	self defineVTable.
	superclass functions size + 1 to: functions size do: [:i | self compileFunction: i].
	self subclassesDo: [:s | s compileFunctions]!

compileFunctionsIntoImplementor: aClass
	"Helper to compile a set of method templates for the receiver's interface
	into the implementing class, aClass. These methods are of the form:

		<selector_arglist>
			"

	"Implement the <interface_name>::<function_name> function."

	"

			^E_NOTIMPL

		IEnumXXXX compileFunctionsIntoImplementor: EnumRECT
	"

	| aStream cat |
	cat := self generatedFunctionCategories first.
	((aClass includesCategory: cat) and: 
			[(MessageBox
				confirm: ('<1p> already includes the method category ''<2s>''
The generated template methods may overwrite existing methods in the class.
Are you sure you want to proceed?'
						expandMacrosWith: aClass
						with: cat))
					not])
		ifTrue: [^self].
	aStream := (Utf8String new: 256) writeStream.
	functions
		from: superclass functions size + 1
		to: functions size
		do: 
			[:fn |
			aStream
				nextPutAll: fn messageSelectorAndArgumentNames;
				cr;
				tab;
				nextPutAll: '"Implement the ';
				nextPutAll: self name;
				nextPutAll: '::';
				nextPutAll: (fn selector upTo: $:);
				nextPutAll: '() interface function."';
				cr;
				cr;
				tab;
				nextPutAll: '^E_NOTIMPL.';
				cr;
				tab;
				nextPutAll: '#todo "Implement me"';
				cr.
			aClass compile: aStream contents categories: self generatedFunctionCategories.
			aStream reset]!

createContextFlags
	"Answer a combination of flags from the CTX_ enumeration which specify the types of servers
	acceptable when creating COM objects.
	Implementation Note: As a default we no longer include the inproc-handler option, because
	that appears to result in useless instances with a lot of Microsoft out-of-proc. servers."

	^IClassFactory ctxServer
!

createObject: progID
	"Answer an instance or subinstance of the receiver on an instance of the COM component 
	registered under the specified <readableString> progID, which can be either a ProgID or
	the standard string representation of a CLSID (i.e. a long hex number in curly brackets).
	This is a simplified interface for creating COM objects which is similar to that in VB."

	| clsid |
	clsid := progID first == ${
			ifTrue: [CLSID fromString: progID]
			ifFalse: [CLSID fromProgID: progID].
	^self onCLSID: clsid!

defineFields
	"Define the fields of the COM interface 'structure'.

		COMInterface compileDefinition; allSubclasses do: [ :c | c defineTemplate ]
	"

	self
		defineField: #vtbl type: LPVOIDField writeOnly;
		defineField: #argSizes type: LPVOIDField writeOnly;
		defineField: #objectCookie type: DWORDField writeOnly;
		defineField: #interfaceCookie type: DWORDField writeOnly!

defineFunction: aSymbol
	"Declare a virtual function supported by the receiver and implemented in the object
	on which instances of the receiver are actually created (the 'client' or 'implementor')."

	self
		defineFunction: aSymbol
		argumentTypes: ''!

defineFunction: aSymbol argumentTypes: aString
	"Declare a virtual function supported by the receiver and implemented in the object
	on which instances of the receiver are actually created (the 'client' or 'implementor')."

	self
		defineFunction: aSymbol 
		returnType: self stdMethodReturnType
		argumentTypes: aString

!

defineFunction: aSymbol descriptor: aFunctionDescriptor
	"Declare a virtual function supported by the receiver and implemented in the object
	on which instances of the receiver are actually created (the 'client' or 'implementor')."

	self
		addFunction: COMFunction
		selector: aSymbol
		descriptor: aFunctionDescriptor!

defineFunction: aSymbol returnType: retString
	"Declare a virtual function supported by the receiver and implemented in the object
	on which instances of the receiver are actually created (the 'client' or 'implementor')."

	self 
		defineFunction: aSymbol
		returnType: retString
		argumentTypes: ''!

defineFunction: aSymbol returnType: retString argumentTypes: argString
	"Declare a virtual function supported by the receiver and implemented in the object
	on which instances of the receiver are actually created (the 'client' or 'implementor')."

	self 
		defineFunction: aSymbol
		descriptor: 
			(self descriptorClass
				callingConvention: self stdMethodCallType
				returnType: retString
				argumentTypes: argString)

!

defineFunction: aSymbol type: functionClass returnType: retString argumentTypes: argString
	"Declare a virtual function supported by the receiver and implemented in the receiver
	using the <COMFunction> class, functionClass, to represent the function."

	self
		addFunction: functionClass
		selector: aSymbol 
		descriptor: 
			(self descriptorClass
				callingConvention: self stdMethodCallType
				returnType: retString
				argumentTypes: argString)
!

defineFunctions
	"Declare the virtual functions supported by the receiver.
	You must override this to declare an interface class."

	^self subclassResponsibility!

defineTemplate
	"Initialize the receiver class' structure template and VTable."

	super defineTemplate.
	self defineVTable!

defineVTable
	"Initialize the receiver class' structure template and callback table.
	Send this to the subclasses of the receiver to define the VTable when
	implementing COM interfaces (CALL IN)."

	self == ##(self) 
		ifTrue: 
			[functions := #().
			argSizes := nil]
		ifFalse: 
			[| inherited |
			functions := OrderedCollection new.
			inherited := self superclass functions.
			functions addAll: inherited.
			(self class includesSelector: #defineFunctions) ifTrue: [self defineFunctions].
			functions := functions asArray.
			self calcArgSizes]!

elementSize
	"Answer the size (in bytes) of the structure the receiver represents
	when used as an array element."

	^VMConstants.IntPtrSize!

functions
	"Private - Answer the array of functions definitions."

	^functions!

generatedFunctionCategories
	"Answer the categories into which COMInterface functions are compiled
	during the autogeneration process.
	N.B. It is important that the main category appears first in the list."

	^{'COM Interfaces', '-', self name. 'public'}!

getFieldNames
	^#()!

getObject: aString
	"Answer an instance or subinstance of the receiver on an instance of the COM component 
	instantiated by binding the moniker with display name equivalent to the <readableString>
	argument. This is a simplified interface for binding to COM objects 
	through monikers, which is similar to the GetObject function in VB."

	| answer |
	answer := self newPointer.
	OLELibrary default
		coGetObject: aString
		pBindOptions: nil
		riid: self iid
		ppv: answer.
	^answer!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

iid
	"Answer the receiver's globally unique interface id (IID)"

	^self guid!

implementor: implementor
	"Private - Answer a new  instance of the receiver suitable for use
	as a reference to an interface implemented by the object, implementor.
	N.B. Use #on:(implementor:) in any implementations of #queryInterface:ifNone:,
	this is for basic instantiation only, and answers the non-pointer form, which
	is not intended for use outside the OLE framework."

	^self newInternal
		implementor: implementor!

initialize
	"Private - Initialize the receiver.
		COMInterface initialize
		COMInterface registerSubclasses
	Implementation Note: Unusually for an initialize method, this implementation
	must work for all subclasses."

	self == ##(self)
		ifTrue: [ "Initialize COMInterface itself"
			functions := #()]
		ifFalse: [self initializeInterface]!

initializeAfterLoad
	"Perform any post-load initialisation for the class.
	In this case we set up the function table now to avoid overhead of lazy init. test
	init. on every virtual function callback."

	"Superclass method only initializes direct implementors, so we must initialize others"
	(self class includesSelector: #initialize) ifFalse: [self initialize].
	super initializeAfterLoad.!

initializeInterface
	"Private - Initialize aspects common to all COM interface classes in Dolphin
	(the IID, type lib reference, and virtual function table)."

	self initializeTypeLib.
	self defineTemplate.!

initializeRegister
	"Private - Initialize the register of IIDs to interface classes."

	InterfaceClasses := LookupTable new

!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library (if any)."

	typeLib := nil!

interfaceClasses
	"Private - Answer the map between IID's and classes."

	^InterfaceClasses!

new
	"Answer a new instance of the receiver and associated component instance
	(created via CoCreateInstance)."

	^self onCLSID: self clsid.
!

newBuffer
	"Answer a instance of the receiver suitable for use as a buffer to hold the
	external structure type which the subclass wraps.
	Implementation Note: COMInterfaces are always pointers."

	^self newPointer!

newInternal
	"Answer a new instance of the receiver suitable for use as a interface
	to some Dolphin object (the 'implementor'). The receiver (in conjunction
	with a COMObject instance) takes care of the boilerplate implementation
	of the Common Object Model, but it is generally up to the implementor to
	implement the rest of a particular interface.
	Implementation Note: The answered interface instance is not finalizable
	since it is strongly referenced from a COMObject, which is strongly referenced
	from a PermanentRegistry. The COMObject will not become a candidate for GC
	until it is sent #release sufficient times to reduce its ref. count to zero, 
	at which point all outstanding interfaces registered with it will be GC'd."

	^super newBuffer!

on: server
	"Answer an instance (new or existing) of the receiver suitable for use 
	as a reference to an internally implemented interface on the argument, server,
	(assumed to be an exported server Object). This may result in the creation and 
	registration of a private COMObject instance which wraps anObject to provide basic 
	support for the Common Object Model, such as reference counting, and the boilerplate of 
	interface querying (if one does not already exist). The reference count of the 
	COMObject will be increased to reflect the existence of the new interface reference.
	This is the simple case where the server implements not only the server functionality,
	but also the interface functions too.
	N.B. It is assumed that the object, server, does actually implement the interface
	which the receiver represents - use the #queryOn: method to conditionally
	create an interface pointer."

	^self on: server implementor: server!

on: server implementor: implementor
	"Answer a pointer to a (new or existing) instance of the receiver suitable for use
	as a reference to an internally implemented interface on the argument, server,
	(assumed to be an exported server Object), but where the interface functions are actually
	implemented in the argument, implementor. This may result in the creation 
	and registration of a private COMObject instance which wraps the server object to provide 
	basic support for the Common Object Model, such as reference counting, and the boilerplate of 
	interface querying (if one does not already exist). The reference count of the 
	COMObject will be increased to reflect the existence of the new interface pointer.
	This instantiator is for the case where the server does not implement the COM
	interface functions, but instead relies on an interface implementor which (presumably)
	knows about the server and can call on it to implement the interface."

	^(self comObjectClass on: server)
		findInterface: self 
		ifNoneAdd: [self implementor: implementor]!

on: server implementor: implementor outerUnknown: pUnkOuter
	"Private - Answer a pointer to a new instance of the receiver suitable for use
	as a reference to an internally implemented interface on the argument, server,
	(assumed to be an exported server Object), but where the interface functions are actually
	implemented in the argument, implementor. This may result in the creation 
	and registration of a private COMObject instance which wraps the server object to provide 
	basic support for the Common Object Model, such as reference counting, and the boilerplate of 
	interface querying (if one does not already exist). The reference count of the 
	COMObject will be increased to reflect the existence of the new interface pointer.
	This instantiator is for the case where the server does not implement the COM
	interface functions, but instead relies on an interface implementor which (presumably)
	knows about the server and can call on it to implement the interface."

	^(self comObjectClass on: server outerUnknown: pUnkOuter)
		findInterface: self 
		ifNoneAdd: [self implementor: implementor]!

onCLSID: aCLSID
	"Answer an instance or subinstance of the receiver on an instance of the specified COM component 
	class (instantiated by its registered server using CoCreateInstance). We don't care about the
	server context, so it could be in/out of process, even remote."

	^self onCLSID: aCLSID outerIUnknown: nil!

onCLSID: aCLSID hostName: aString
	"Answer an instance or subinstance of the receiver on an instance of the 
	specified COM component class, instantiated using CoCreateInstanceEx() 
	on the specified remote host."

	^self onCLSID: aCLSID outerIUnknown: nil hostName: aString!

onCLSID: aCLSID outerIUnknown: anIUnknown
	"Answer an instance or subinstance of the receiver on an instance of the specified 
	COM component class (instantiated by its registered server using CoCreateInstance), 
	with the specified outer (controlling) unknown. We don't care about the server context, 
	so it could be in/out of process, even remote."

	^self onCLSID: aCLSID outerIUnknown: anIUnknown hostName: nil licenseKey: nil!

onCLSID: aCLSID outerIUnknown: anIUnknown hostName:aString
	"Answer an instance or subinstance of the receiver on an instance of the specified 
	COM component class, instantiated by its registered server via CoCreateInstanceEx, 
	with the specified outer (controlling) unknown, on the specified remote host."

	^self onCLSID: aCLSID outerIUnknown: anIUnknown hostName:aString licenseKey: nil!

onCLSID: aCLSID outerIUnknown: pUnkOuter hostName: hostNameString licenseKey: licenseString 
	"Answer an instance or subinstance of the receiver on an instance of the specified COM 
	component class, instantiated by its registered server, with the specified outer (controlling) 
	unknown, on the specified remote host, and using the specified license string (or nil if not 
	licensed)."

	| dwClsContext hr pServerInfo pUnk pFactory |
	dwClsContext := self createContextFlags.
	(hostNameString notNil and: [hostNameString notEmpty]) 
		ifTrue: 
			[pServerInfo := COSERVERINFO new.
			pServerInfo hostName: hostNameString.
			dwClsContext := dwClsContext bitOr: CLSCTX_REMOTE_SERVER].
	pFactory := IClassFactory newPointer.
	OLELibrary default 
		coGetClassObject: aCLSID
		dwClsContext: dwClsContext
		pServerInfo: pServerInfo
		riid: pFactory iid
		ppv: pFactory.
	"pFactory should not be null (an exception should have been raised), but just in case the class factory is
	implemented incorrectly..."
	pFactory isNull ifTrue: [^nil].
	"Successfully retrieved class factory - now ask it to make an instance"
	pUnk := self newPointer.
	hr := pFactory 
				CreateInstance: pUnkOuter
				riid: self iid
				ppvObject: pUnk.
	hr < 0 
		ifTrue: 
			["Failed for some reason, perhaps it needs a license"
			| license |
			hr = CLASS_E_NOTLICENSED ifFalse: [^HRESULTError signalWith: hr].
			pFactory := pFactory queryInterface: IClassFactory2.
			pFactory isNil ifTrue: [^HRESULTError signalWith: hr].

			"If a license key was not supplied, then try and get a runtime license"
			license := licenseString ifNil: [pFactory requestLicenseKey].
			pFactory 
				CreateInstanceLic: pUnkOuter
				pUnkReserved: nil
				riid: pUnk iid
				bstrKey: license
				ppvObject: pUnk].
	^pUnk!

onExit
	"Ensure all the receiver's subinstances are in their clean state on exit
	so that they have released any external resources they are holding."

	COMClassFactory onExit.
	self primAllSubinstances do: [:i | i onExit].
	COMObjectStub onExit
	!

onStartup
	"Ensure all the receiver's subinstances are in their clean state on startup
	rather than attempting to use an old interface hanging around from the sesssion 
	when the image was saved."

	self primAllSubinstances do: [:i | i onStartup].
	Processor unregisterCOMStubs.					"remove old COM stubs (now invalid)"
	COMObjectStub onStartup.						"clear down any old registy entries"
	COMClassFactory onStartup					"now safe to register class factories"!

queryOn: server
	"Answer a pointer to a (new or existing) instance of the receiver suitable for use
	as a reference to an internally implemented interface on the argument, server,
	(assumed to be an exported server Object), where the interface functions are 
	implemented by that object. If the interface is not supported by the 
	specified implementor, then the answer will be nil.
	Note that you cannot specify the implementor when querying the interface, because
	this is really up to the server object."

	^(self comObjectClass on: server)
		queryInterface: self!

recompileReferences
	self == ##(self) 
		ifTrue: [super recompileReferences]
		ifFalse: 
			["Do nothing for all subclasses as these do not declare any fields and cannot be passed by value"
			]!

register
	"(Re)Register the receiver's as COM interface classes with
	the appropriate GUIDs. This is intended as a helper function when
	developing, and has no run-time significance."

	self registerClass: self forIID: self iid!

registerClass: anInterfaceClass forIID: aGUID
	"Register the specified interface class, which must support the COM interface protocol
	(basically that defined in IUnknown)."

	| existingKey |
	InterfaceClasses isNil ifTrue: [self initializeRegister].
	existingKey := InterfaceClasses keyAtValue: anInterfaceClass ifAbsent: [].
	existingKey isNil ifFalse: [InterfaceClasses removeKey: existingKey].
	InterfaceClasses at: aGUID put: anInterfaceClass!

registerSubclasses
	"(Re)Register the receiver's subclasses as COM interface classes with
	their appropriate GUIDs. This is intended as a helper function when
	developing, and has no run-time significance.

		COMInterface registerSubclasses
	"

	self initializeRegister.
	self allSubclassesDo: [:c | c register]!

removeCompiledFunctions
	"Remove the functions generated automatically from the receiver's function table."

	[self removeCategory: self generatedFunctionCategories first] on: NotFoundError do: [:e | e notify]!

setGuid: id
	"Private - Set the value of the receiver's 'guid' instance variable to the 
	<GUID>, id."

	super setGuid: (id becomeAn: IID)!

stdMethodCallType
	"Private - Answer the standard calling convention for a COM function."
	
	^'stdcall:'!

stdMethodReturnType
	"Private - Answer the standard method return type for a COM function call (HRESULT)."
	
	^'hresult'!

supportsInterface: anInterfaceClass 
	"Answer whether instances of the receiver support the requested interface class."

	#defineFunctions.
	^self == anInterfaceClass or: [self inheritsFrom: anInterfaceClass]!

uninitialize
	"Private - Unitialize the receiver as it is about to be removed."

	SessionManager current removeEventsTriggeredFor: self.
	Processor unregisterCOMStubs

!

uninitializeBeforeRemove
	"Perform any pre-removal uninitialisation for the class."

	typeLib := argSizes := functions := nil.
	super uninitializeBeforeRemove.
!

unregister
	"Unregister the receiver's as COM interface classes with
	the appropriate GUIDs. This is intended as a helper function when
	developing (primarily for deinstalling packages), and has no run-time 
	significance."

	InterfaceClasses removeKey: self iid ifAbsent: []! !
!COMInterface class categoriesFor: #addFunction:selector:descriptor:!automatic generation!public! !
!COMInterface class categoriesFor: #argSizes!initializing!private! !
!COMInterface class categoriesFor: #atAddress:!instance creation!public! !
!COMInterface class categoriesFor: #attach:!instance creation!public! !
!COMInterface class categoriesFor: #attachInterface:!instance creation!public! !
!COMInterface class categoriesFor: #calcArgSizes!initializing!private! !
!COMInterface class categoriesFor: #classForIID:!enquiries!public! !
!COMInterface class categoriesFor: #classForIID:ifNone:!enquiries!public! !
!COMInterface class categoriesFor: #clear:!public!realizing/unrealizing! !
!COMInterface class categoriesFor: #clsid!accessing!public! !
!COMInterface class categoriesFor: #comObjectClass!constants!public! !
!COMInterface class categoriesFor: #compileFunction:!automatic generation!development!private! !
!COMInterface class categoriesFor: #compileFunctions!automatic generation!development!public! !
!COMInterface class categoriesFor: #compileFunctionsIntoImplementor:!automatic generation!development!public! !
!COMInterface class categoriesFor: #createContextFlags!constants!public! !
!COMInterface class categoriesFor: #createObject:!instance creation!public! !
!COMInterface class categoriesFor: #defineFields!automatic generation!public!template definition! !
!COMInterface class categoriesFor: #defineFunction:!automatic generation!public! !
!COMInterface class categoriesFor: #defineFunction:argumentTypes:!automatic generation!public! !
!COMInterface class categoriesFor: #defineFunction:descriptor:!automatic generation!public! !
!COMInterface class categoriesFor: #defineFunction:returnType:!automatic generation!public! !
!COMInterface class categoriesFor: #defineFunction:returnType:argumentTypes:!automatic generation!public! !
!COMInterface class categoriesFor: #defineFunction:type:returnType:argumentTypes:!automatic generation!public! !
!COMInterface class categoriesFor: #defineFunctions!initializing!public! !
!COMInterface class categoriesFor: #defineTemplate!public!template definition! !
!COMInterface class categoriesFor: #defineVTable!automatic generation!public! !
!COMInterface class categoriesFor: #elementSize!accessing!public! !
!COMInterface class categoriesFor: #functions!initializing!private! !
!COMInterface class categoriesFor: #generatedFunctionCategories!constants!public! !
!COMInterface class categoriesFor: #getFieldNames!constants!private! !
!COMInterface class categoriesFor: #getObject:!instance creation!public! !
!COMInterface class categoriesFor: #icon!constants!public! !
!COMInterface class categoriesFor: #iid!accessing!public! !
!COMInterface class categoriesFor: #implementor:!instance creation!private! !
!COMInterface class categoriesFor: #initialize!development!initializing!private! !
!COMInterface class categoriesFor: #initializeAfterLoad!initializing!public! !
!COMInterface class categoriesFor: #initializeInterface!initializing!private! !
!COMInterface class categoriesFor: #initializeRegister!initializing!private! !
!COMInterface class categoriesFor: #initializeTypeLib!initializing!private! !
!COMInterface class categoriesFor: #interfaceClasses!accessing!private! !
!COMInterface class categoriesFor: #new!instance creation!public! !
!COMInterface class categoriesFor: #newBuffer!instance creation!public! !
!COMInterface class categoriesFor: #newInternal!instance creation!public! !
!COMInterface class categoriesFor: #on:!instance creation!public! !
!COMInterface class categoriesFor: #on:implementor:!instance creation!public! !
!COMInterface class categoriesFor: #on:implementor:outerUnknown:!instance creation!private! !
!COMInterface class categoriesFor: #onCLSID:!instance creation!public! !
!COMInterface class categoriesFor: #onCLSID:hostName:!instance creation!public! !
!COMInterface class categoriesFor: #onCLSID:outerIUnknown:!instance creation!public! !
!COMInterface class categoriesFor: #onCLSID:outerIUnknown:hostName:!instance creation!public! !
!COMInterface class categoriesFor: #onCLSID:outerIUnknown:hostName:licenseKey:!instance creation!public! !
!COMInterface class categoriesFor: #onExit!event handling!public! !
!COMInterface class categoriesFor: #onStartup!drawing!public! !
!COMInterface class categoriesFor: #queryOn:!instance creation!public! !
!COMInterface class categoriesFor: #recompileReferences!development!private! !
!COMInterface class categoriesFor: #register!adding!public! !
!COMInterface class categoriesFor: #registerClass:forIID:!adding!public! !
!COMInterface class categoriesFor: #registerSubclasses!initializing!public! !
!COMInterface class categoriesFor: #removeCompiledFunctions!automatic generation!development!public! !
!COMInterface class categoriesFor: #setGuid:!accessing!private! !
!COMInterface class categoriesFor: #stdMethodCallType!constants!private! !
!COMInterface class categoriesFor: #stdMethodReturnType!constants!private! !
!COMInterface class categoriesFor: #supportsInterface:!public!testing! !
!COMInterface class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!COMInterface class categoriesFor: #uninitializeBeforeRemove!class hierarchy-removing!public! !
!COMInterface class categoriesFor: #unregister!public!removing! !

