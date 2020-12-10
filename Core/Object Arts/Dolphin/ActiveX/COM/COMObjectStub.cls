"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #COMObjectStub
	instanceVariableNames: 'cookie object count interfaces outerUnknown'
	classVariableNames: 'IdentityRegistry'
	imports: #(#{OS.Win32Errors private})
	classInstanceVariableNames: ''
	classConstants: {}!
COMObjectStub guid: (Core.GUID fromString: '{87b4c46c-026e-11d3-9fd7-00a0cc3e4a32}')!
COMObjectStub comment: 'COMObjectStub is a private class of objects which are used to wrap any object in the system so that they may be exposed as COM objects. COMObjectStub implements most <IUnknown>, functionality, providing reference count based lifetime management, and the basic mechanics for QueryInterface().

Note that each COM server objecty should have only one COMObjectStub so that the ref. count is correct, and so that queries for IUnknown always answer the same interface.

Instance Variables:
	cookie		<SmallInteger>. The receiver''s cookie identifying it in the Processor registry.
	object		<Object>. The actual COM server object implementing the COM interfaces.
	count		<integer>. COM reference count.
	interfaces		<Array>. Array of interfaces currently extant against this stub.
	outerUnknown	<IUnknown> or <UndefinedObject>. Controlling (outer) unknown.

Class Variables:
	IdentityRegistry	<IdentityDictionary>. Map of objects to their COMObjectStub wrapper.




'!
!COMObjectStub categoriesForClass!COM-Implementations! !
!COMObjectStub methodsFor!

addInterface: aCOMInterface
	"Private - Add the argument, aCOMInterface, to the receiver's list of current COM 
	interfaces. Answer aCOMInterface.
	It will not go away until the receiver does (which should happen when the receiver's 
	COM ref. count drops to zero).
	Implementation Note: If this is the first interface added, then the receiver will
	be registered, have a cookie allocated, and have its ref. count bumped to 1. The receiver
	will be protected from GC until its ref. count drops back to zero as a result of
	#Release messages."

	| iCookie |
	iCookie := interfaces addAnsweringIndex: aCOMInterface.
	aCOMInterface
		objectCookie: self cookie;
		interfaceCookie: iCookie.
	^aCOMInterface!

AddRef
	"Private - Implement IUnknown::AddRef() (see innerAddRef() for further details)."

	^outerUnknown isNil
		ifTrue: [self innerAddRef]
		ifFalse: [outerUnknown AddRef]!

callback: interfaceCookie vfn: vfnIndex withArgumentsAt: pArgs
	"Private - Invoke the specified 'virtual' callback function."

	"Bypassing the interface object itself  as follows has very little performance 
	benefit (2 or 3% on an AddRef call), and reduces flexibility slightly since the 
	interface can no longer use its own dispatching mechanism.

	| intf |
	^((intf := interfaces basicAt: interfaceCookie) 
		class functions basicAt: vfnIndex)
			callback: self interface: intf withArgumentsAt: pArgs
	"

	^(interfaces basicAt: interfaceCookie)
		callback: self vfn: vfnIndex withArgumentsAt: pArgs

!

cookie
	"Private - Answer the receiver's id (unique among all registered COMObjectStubs)"

	cookie isNil ifTrue: [cookie := Processor registerCOMStub: self].
	^cookie!

disconnect
	"Rudely disconnect any external clients of the receiver.
	WARNING: This should only be used for forcing a shutdown. If the user of the
	interface is in-process, then it will not know that the interface has been invalidated,
	and it may still call back through a COM interface."

	count > 0 ifTrue: [
		"This might indicate interface leaks in the client, so one might want them traced"
		"KernelLibrary default outputDebugString: 'Disconnecting ', self printString, String lineDelimiter."
		count := count + 1.
		OLELibrary default coDisconnectObject: interfaces first dwReserved: 0.
		self free]

	!

findInterface: interfaceClass ifNoneAdd: operation
	"Private - Answer a typed pointer to a COMInterface which supports the interface 
	class, interfaceClass (usually a subclass of IUnknown). If the receiver does 
	not currently have a suitable interface, then add that which results from 
	evaluating the niladic valuable, operation, and answer a typedd pointer to 
	that."

	| actualIf |
	actualIf := interfaces 
		detect: [:i | i supportsInterface: interfaceClass] 
		ifNone: [self addInterface: operation value].
"	self AddRef.	COMInterface>>fromAddress: sends AddRef to match the finalization Release."
	^interfaceClass fromAddress: actualIf yourAddress.!

free
	"Private - Remove the receiver's permanent registration (permits receiver
	to be GC'd in the normal manner). It is not a good idea to send this to a 'live'
	COM object with outstanding references, since those clients will be rather 
	rudely disconnected."

	| preservedCookie |
	preservedCookie := cookie.
	count := 0.
	cookie := nil.
	((IdentityRegistry removeKey: object ifAbsent: []) notNil and: [preservedCookie notNil]) 
		ifTrue: 
			["Notification signal: 'Unregistering ', self printString, ' at ', preservedCookie displayString."
			Processor unregisterCOMStub: preservedCookie]!

innerAddRef
	"Private - Increments the reference count for the object which the receiver is wrapping.
	Answer the ref. count after the operation (though COM does not require that this value behave
	in a predictable fashion, so don't rely on it). While the reference count is greater
	than 1, the receiver will prevent the wrapped object from being GC'd.
	
		ULONG AddRef(void);"

"	Transcript show: self printString, ' increasing ref count to ', (count+1) displayString; cr."
	^count := count + 1!

innerQueryInterface: pIID ppvObject: ppvOut
	"Private - Return an instance of the requested interface (through the out
	parameter, interface), if the receiver's implementor supports it. Note that this
	is the 'inner' query interface implementation (i.e. without aggregation), and directly
	implements a COM function, hence the nasty parameters and HRESULT codes, and
	is not intended for calling from within Smalltalk (send #queryInterface:[ifNone:] instead).
	The receiver's reference count is incremented (through #AddRef) 
	if the query successfully returns the requested interface. Answers S_OK if the 
	object supports the requested interface, or E_NOINTERFACE if not.

		HRESULT QueryInterface(
	  		REFIID iid,			(In)
			void** ppvObject		(Out)
		);
	
	There are certain rules of the COM game which are relevant:

	-	Querying for IUnknown against a particular object must always answer
		the same interface pointer value (COM may use this as an identity comparison).
	-	Querying for any other interface need not yield the same pointer each time.
		[In fact Dolphin cache's all interface pointers, and will answer the same pointer
		for each individual interface type].
	-	The set of interfaces which can be queried of an object must be static, not dynamic. 
		This means that if query succeeds once, then the same query should succeed again,
		and likewise if it fails the first time, it should fail on all subsequent attempts.
		This is a bit of a shame, as it somewhat limits the possibilities available in Smalltalk, but ...
	-	QueryInterface() must be symmetric - i.e. given a pointer to an interface on an object, 
		if I query it for the same interface, that call must succeed.
	-	QueryInterface() must be reflexive -  i.e. given a pointer to one interface if I can
		successfully query it for another, a query through the new interface for the original
		interface must succeed.
	-	QueryInterface() must be transitive - i.e. given a pointer to one interface through which I can 
		successfully query for a a second, and through that successfully query for a third, then a query for 
		the first interface through the the third must succeed."

	| interfaceClass interface |
	ppvOut value: 0.	"must set, even on error"
	"Notification signal: self printString, ': Querying interface ', (IID fromAddress: pIID yourAddress) displayString."
	interfaceClass := COMInterface classForIID: pIID ifNone: [^E_NOINTERFACE "IID not recognised"].
	interface := self queryInterface: interfaceClass ifNone: [^E_NOINTERFACE "interface not supported"].
	"Notification signal: 'Answering interface ', interface printString."
	ppvOut value: interface detach.
	^S_OK!

innerRelease
	"Private - Implement IUnknown::Release() (sans aggregation).
	Decrement the receiver's reference count, and if it becomes zero, the receiver
	is free to be garbage collected/deleted. Answers the new ref. count value after 
	the operation.

		ULONG Release(void);

	Implementation Note: An invariant of the Registry is that it can
	only contain COMObjectStubs with a reference count >= 1."

"	Notification signal: self printString, ' decreasing ref count to ', (count-1) displayString."

	count == 0 ifFalse: [
		count := count - 1.
		count == 0
			ifTrue: [object finalRelease. self free]].
	^count!

onObject: anObject
	"Private - Initialize the receiver.
	Implementation Note: COMObjectStubs have an initial ref. count of 0,
	and are not registered until their first interface is added (
	e.g. by a QueryInterface(IUnknown,...)."

	object := anObject.
	count := 0.
	interfaces := Array new!

outerUnknown: pUnkOuter
	"Private - Set the outer IUnknown of the receiver to the <IUnknown> argument, pUnkOuter."

	outerUnknown := pUnkOuter!

printOn: aStream
	"Append a debug description of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPutAll: ' on ';
		print: object;
		nextPutAll: ' refs ';
		display: count!

queryInterface: interfaceClass
	"Answer an pointer to an instance of the interface class, interfaceClass (usually a 
	subclass of IUnknown), on the receiver, or nil if the receiver does not support that 
	interface class."

	^self queryInterface: interfaceClass ifNone: []!

queryInterface: interfaceClass ifNone: exceptionHandler
	"Answer a pointer to an instance of the interface class, interfaceClass (usually a 
	subclass of IUnknown), on the receiver, or the result of evaluating the niladic
	valuable, exceptionHandle, if the receiver does not support that interface class.
	
	We implement this by first searching for existing interfaces on the receiver
	which support the requested interface. If one is found, we return a pointer to it 
	(incrementing the reference count of course). If there is no suitable existing 
	interface, then we first see if the interface is directly supported by the receiver, 
	creating a new interface if it is. Failing that we pass the request on to the implementor.

	Note: The 'interface' instance referred to is the Dolphin object which actually 
	implements the COM binary format (i.e. it is a C++ format object, with a reference 
	to the VM vtable as its first 4 bytes, and other information necessary to implement 
	COM in Dolphin via the generic virtual callback entry point). These objects are 
	instances of the appropriate subclass of COMInterface, and their first instance 
	variable contains a byte array which in turn contains the binary format of a Dolphin 
	COM interface object. Such interface objects have no effect on the ref. count of the 
	owning COMObject, and are not intended for external use. Normally interface objects are 
	referenced indirectly via an interface pointer (i.e. a subinstance of COMInterface 
	whose first instance variable is an instance of ExternalAddress containing the address 
	of the interface object), and are thus indistinguishable from externally implemented 
	interfaces. This arrangement is employed in order that the reference count of the 
	COMObject, and the lifetime of the COMObject and its interfaces, can be correctly 
	maintained purely with finalization, thus obviating the need for explicitly #free'ing 
	internal interfaces at the appropriate moment (which would be tricky, confusing, and 
	inconsistent)."

	^self
		findInterface: interfaceClass 
		ifNoneAdd: [
			(self supportsInterface: interfaceClass)
				ifTrue: [interfaceClass implementor: self]
				ifFalse: [
					"We have to ask the object itself via the normal public enquiry method (which will answer a Pointer).
					This could turn out to be infinitely recursive if queryInterface:ifNone: is not implemented correctly!!"
					^(object class canUnderstand: #queryInterface:ifNone:)
						ifTrue: [object queryInterface: interfaceClass ifNone: exceptionHandler ]
						ifFalse: [exceptionHandler value]]]!

QueryInterface: pIID ppvObject: ppvOut
	"Private - Implement IUnknown::QueryInterface().
	This method is a mere shell to provide aggregation support.
	See internalQueryInterface:ppvObject: for more details."

	^outerUnknown isNil
		ifTrue: [self innerQueryInterface: pIID ppvObject: ppvOut]
		ifFalse: [
			"Unfortunately we cannot pass the address through due to the implicit
			indirection of lppvoid parameter types - with the benefit of hindsight, perhaps
			this wasn't the best of ideas, but..."
			| pi |
			pi := External.Address new.
			outerUnknown QueryInterface: pIID ppvObject: pi.
			ppvOut value: pi]!

referenceCount
	"Private - Answer the receiver's reference count."

	^count!

Release
	"Private - Implement IUnknown::Release() (see #innerRelease for further details)."

	^outerUnknown isNil
		ifTrue: [self innerRelease]
		ifFalse: [outerUnknown Release]!

supportsInterface: interface
	"Private - Answer whether the receiver supports the specified interface
	(normally a subclass of IUnknown). The default is to answer true only
	for IUnknown, since COMObject implements only that (this method 
	supports that implementation!!)."

	^interface == IUnknown! !
!COMObjectStub categoriesFor: #addInterface:!accessing-interfaces!private! !
!COMObjectStub categoriesFor: #AddRef!COM Interfaces-IUnknown!private! !
!COMObjectStub categoriesFor: #callback:vfn:withArgumentsAt:!evaluating!private! !
!COMObjectStub categoriesFor: #cookie!accessing!private! !
!COMObjectStub categoriesFor: #disconnect!public!realizing/unrealizing! !
!COMObjectStub categoriesFor: #findInterface:ifNoneAdd:!accessing-interfaces!private! !
!COMObjectStub categoriesFor: #free!operations!private! !
!COMObjectStub categoriesFor: #innerAddRef!non delegating unknown!private! !
!COMObjectStub categoriesFor: #innerQueryInterface:ppvObject:!non delegating unknown!private! !
!COMObjectStub categoriesFor: #innerRelease!non delegating unknown!private! !
!COMObjectStub categoriesFor: #onObject:!initializing!private! !
!COMObjectStub categoriesFor: #outerUnknown:!accessing!private! !
!COMObjectStub categoriesFor: #printOn:!development!printing!public! !
!COMObjectStub categoriesFor: #queryInterface:!accessing-interfaces!public! !
!COMObjectStub categoriesFor: #queryInterface:ifNone:!accessing-interfaces!public! !
!COMObjectStub categoriesFor: #QueryInterface:ppvObject:!COM Interfaces-IUnknown!private! !
!COMObjectStub categoriesFor: #referenceCount!accessing!private! !
!COMObjectStub categoriesFor: #Release!COM Interfaces-IUnknown!private! !
!COMObjectStub categoriesFor: #supportsInterface:!accessing-interfaces!private!testing! !

!COMObjectStub class methodsFor!

disconnectAll
	"Rudely disconnect all external clients of COM objects implemented in Dolphin.
	This should be seen as a forced shutdown measure."

	IdentityRegistry do: [:object | object disconnect]
		!

initialize
	"Private - Initialize the receiver's class variables.
		COMObjectStub initialize
	"

	self initializeRegistries.
	VMLibrary default registryAtIndex: 70 put: #comCallback:id:subId:withArgumentsAt:cookie:

	"See also OLE COM package post install script which sets up various method skips with the debugger"!

initializeRegistries
	"Private - Initialize the receiver's registries."

	IdentityRegistry := IdentityDictionary new!

on: server
	"Answer an instance of the receiver which exposes the <Object>, server, as a COM Object."

	^IdentityRegistry at: server
		ifAbsentPut: [self new onObject: server]!

onExit
	"Private - Inform any remaining external clients that we are dying. This is rude,
	but if the user forces this app. to shut down, we have no choice.
	Implementation Note: This should be done after all of our own interfaces have
	had a change to be freed."

	self disconnectAll!

onStartup
	"Private - Initialize the receiver's registries on startup, as any outstanding objects will
	now be invalid."

	self initializeRegistries!

registry
	"Private - Return the registry of all extant stubs."

	^IdentityRegistry!

uninitialize
	"Private - Uninitialize the receiver immediately prior to its removal from the system."

	self initializeRegistries.
	VMLibrary default registryAtIndex: 70 put: nil! !
!COMObjectStub class categoriesFor: #disconnectAll!accessing!public! !
!COMObjectStub class categoriesFor: #initialize!development!initializing!private! !
!COMObjectStub class categoriesFor: #initializeRegistries!initializing!private! !
!COMObjectStub class categoriesFor: #on:!instance creation!public! !
!COMObjectStub class categoriesFor: #onExit!event handling!private! !
!COMObjectStub class categoriesFor: #onStartup!event handling!private! !
!COMObjectStub class categoriesFor: #registry!accessing!private! !
!COMObjectStub class categoriesFor: #uninitialize!class hierarchy-removing!private! !

