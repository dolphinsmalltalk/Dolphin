"Filed out from Dolphin Smalltalk"!

COMFunctionAbstract subclass: #UnkQIFunction
	instanceVariableNames: ''
	classVariableNames: 'Descriptor'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

UnkQIFunction guid: (GUID fromString: '{28df5741-9369-4150-8e9f-14235fe2e47c}')!

UnkQIFunction comment: 'COMQueryInterfaceFunction is a specialized class of <COMFunction> intended to represent the IUnknown::QueryInterface() method.

As IUnknown is implemented entirely by the <COMObjectStub>, a COMQueryInterfaceFunction sends a #QueryInterface:ppvObject: message to the relevant stub.'!

!UnkQIFunction categoriesForClass!COM-Implementations! !

!UnkQIFunction methodsFor!

callback: stub interface: aCOMInterface withArgumentsAt: anAddress
	"Private - Send an IUnknown::QueryInterface() call as a #QueryInterface:ppvObject: 
	message back to the <COMObjectStub>, stub, with arguments instantiated from the 
	machine stack at the <integer> address, pArgs, corresponding to the receiver's argument 
	types. Answer the result."

"	This is slightly slower since the VM can instantiate the arguments more quickly,
	which more than makes up for the extra overhead of the indirect invocation via #perform.

	| va |
	va := anAddress asExternalAddress.
	^aCOMObject 
		QueryInterface: (REFGUID fromAddress: (va dwordAtOffset: 0))
		ppvObject: (LPVOID fromAddress: (va dwordAtOffset: 4))

"

	^stub perform: #QueryInterface:ppvObject: withArgumentsAt: anAddress descriptor: Descriptor!

descriptor
	"Private - Answer the descriptor object which described the external function represented
	by the receiver."

	^Descriptor!

selector
	"Private - Answer the selector sent when the receiver is evaluated."

	^#QueryInterface:ppvObject:! !

!UnkQIFunction categoriesForMethods!
callback:interface:withArgumentsAt:!evaluating!private! !
descriptor!accessing!private! !
selector!accessing!private! !
!

!UnkQIFunction class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize

	N.B. We frequently expect E_NOINTERFACE from QueryInterface() (i.e. it is NOT an exceptional condition),
	therefore we suppress the automatic exception raising provided by the virtual call primitive for
	HRESULTs by declaring QueryInterface as returing a signed integer. This must then be tested explicitly.
	"

	Descriptor := IUnknown descriptorClass
				callingConvention: IUnknown stdMethodCallType
				returnType: 'sdword'
				argumentTypes: '<1p>* void**' << GUID!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	Descriptor := nil! !

!UnkQIFunction class categoriesForMethods!
initialize!development!initializing!private! !
uninitialize!class hierarchy-removing!private! !
!

