"Filed out from Dolphin Smalltalk 7"!

OS.COM.InterfaceImplementation subclass: #'OS.COM.ClassFactory'
	instanceVariableNames: 'serverClass clsid registration'
	classVariableNames: 'Factories Instances LockCount'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.ClassFactory guid: (Core.GUID fromString: '{87b4c540-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.COM.ClassFactory comment: 'COMClassFactory is Dolphin''s standard implementation of IClassFactory. It can serve up instances of a particular coclass (possibly also a subclass of COMInterfaceImp), and having been registered once for any paricular coclass it will re-register the availability of that coclass with COM each time that Dolphin is started.

Subclasses can provide specialized services to support coclasses with particular instantiation requirements, and they can even implement alternative class factory interfaces (contrary to common believe IClassFactory is not mandatory).

Instance Variables:
	serverClass 	- the coclass <object>. Any class which exposes COM interfaces.
	clsid 		- the <CLSID> of the coclass.
	registration	- <integer> cookie supplied by COM to identify a coclass registration so that it can subsequently be revoked.

Class Variables:
	Factories 		- previously set up <COMClassFactory> instances which, in a running image, will be registered with COM.
	Instances		- a <WeakSet> containing all outstanding instances of all registered coclasses. Used to control server lifetime.
	LockCount	- <integer> lock count reflecting calls to LockServer().
'!
!OS.COM.ClassFactory categoriesForClass!COM-Implementations! !
!OS.COM.ClassFactory methodsFor!

basicFree
	"Private - clean up external resources held by the receiver."

	self revoke.
	SessionManager current unregisterServer: self!

clear
	"Private - Clear down any external resource handles held by the receiver."

	registration := nil!

clsid
	"Answer the CLSID which identifies the receiver's server class in the registry."

	^clsid!

clsid: aCLSID
	"Private - Record the CLSID which identifies the receiver's server class in the registry."

	clsid := aCLSID!

createInstance: pUnkOuter 
	"Private - Answer a new instance of the Smalltalk class the receiver represents,
	with the specified controlling unknown: A subclass may choose to use pUnkOuter
	for some purpose, but the standard framework doesn't pay it any heed here since
	COMObjectStub implements a delegating unknown when aggregated into an outer
	object."

	^self serverClass new!

CreateInstance: pUnkOuter riid: riid ppvObject: ppvObject
	"Private - Implement IClassFactory::CreateInstance().
	Manufacture an object of the receiver's server class, answering an interface
	of the specified IID on it through ppvObject. ppvObject is nulled if an
	error occurs.
	Answers an HRESULT with success/failure value as appropriate.
	E_NOINTERFACE is returned if the requested interface is not recognised or is
	not implemented by instances of the receiver's server class."

	| pUnk interfaceClass inst |
	ppvObject value: 0.
	interfaceClass := Interface classForIID: riid ifNone: [^E_NOINTERFACE].
	inst := [self createInstance: pUnkOuter] on: Error do: [:e | ^e hresult asInteger].
	pUnk := pUnkOuter yourAddress isNull
				ifTrue: [inst queryInterface: interfaceClass ifNone: [^E_NOINTERFACE]]
				ifFalse: 
					["Aggregation request"
					riid = IUnknown iid ifFalse: [^E_NOINTERFACE	"must request IUnknown when aggregating"].
					IUnknown on: inst outerUnknown: pUnkOuter].
	ppvObject value: pUnk detach.
	self registerInstance: inst.
	^S_OK!

CreateInstanceLic: pUnkOuter pUnkReserved: pUnkReserved riid: riid bstrKey: bstrKey ppvObject: ppvObject
	"Implement the IClassFactory2::CreateInstanceLic() interface function."

	^self CreateInstance: pUnkOuter riid: riid ppvObject: ppvObject
!

free
	"Free any external resources/and or references."

	| factory |
	factory := Factories lookup: self serverClass.
	factory == self ifFalse: [^self].
	Factories removeKey: self serverClass.
	self basicFree!

GetLicInfo: getLicInfo
	"Implement the IClassFactory2::GetLicInfo() interface function.
	Implementation Note: Licensing is not supported by this class factory."

	getLicInfo value: 0.
	^E_UNEXPECTED!

LockServer: aBoolean
	"Private - Implement IClassFactory::LockServer - not intended for internal use.
	(Un)Lock the server in memory (depending on aBoolean).
	Answers an HRESULT indicating success/failure."

	aBoolean 
		ifTrue: [self class incrementLockCount ]
		ifFalse: [self class decrementLockCount].
	^S_OK!

printOn: target 
	"Append, to the <puttableStream>, target, a string whose characters are a 
	the same as those which would result from sending a #printString
	message to the receiver."

	target
		basicPrint: self;
		nextPutAll: ' for ';
		print: self serverClass!

register
	"Private- (Re)Register the receiver with OLE as a local server class object (any existing
	registration is revoked)."

	| iClassFactory dwCookie |
	self revoke.	"revoke any existing registration"
	dwCookie := DWORDBytes new.
	iClassFactory := IClassFactory on: self.
	
	[OLELibrary default
		coRegisterClassObject: clsid
		pUnk: iClassFactory asParameter
		dwClsContext: CLSCTX_LOCAL_SERVER
		flags: REGCLS_MULTIPLEUSE
		lpdwRegister: dwCookie	"Only context currently supported"	"We can support multiple classes"]
			ensure: 
				[registration := dwCookie asInteger.
				iClassFactory free]!

registerInstance: anObject
	"Private - Register the newly created instance, anObject. The instance registers
	is used to determine when server shutdown is possible (it is weak, so it will empty
	when there are no more instances)."

	Instances add: anObject

	!

RequestLicKey: dwReserved pBstrKey: pbstrKey
	"Implement the IClassFactory2::RequestLicKey() interface function.
	Implementation Note: Return E_NOTIMPL to indicate that this class factory does not support licensing."

	pbstrKey value: 0.
	^E_NOTIMPL!

revoke
	"Private - Revoke the receiver's COM class object registration."

	registration isNil ifTrue: [^self].
	OLELibrary default coRevokeClassObject: registration.
	registration := nil!

serverClass
	"Private - Answer the class for which the receiver is acting as a factory."

	^serverClass!

serverClass: aClass
	"Private - Record the class for which the receiver is acting as a factory."

	serverClass := aClass!

supportedInterfaces
	"Answer the set of interface classes supported by the receiver."

	^{IClassFactory}! !
!OS.COM.ClassFactory categoriesFor: #basicFree!private!realizing/unrealizing! !
!OS.COM.ClassFactory categoriesFor: #clear!initializing!private! !
!OS.COM.ClassFactory categoriesFor: #clsid!accessing!public! !
!OS.COM.ClassFactory categoriesFor: #clsid:!accessing!private! !
!OS.COM.ClassFactory categoriesFor: #createInstance:!instance creation!private! !
!OS.COM.ClassFactory categoriesFor: #CreateInstance:riid:ppvObject:!COM Interfaces-IClassFactory!private! !
!OS.COM.ClassFactory categoriesFor: #CreateInstanceLic:pUnkReserved:riid:bstrKey:ppvObject:!COM Interfaces-IClassFactory2!public! !
!OS.COM.ClassFactory categoriesFor: #free!public!realizing/unrealizing! !
!OS.COM.ClassFactory categoriesFor: #GetLicInfo:!COM Interfaces-IClassFactory2!public! !
!OS.COM.ClassFactory categoriesFor: #LockServer:!COM Interfaces-IClassFactory!private! !
!OS.COM.ClassFactory categoriesFor: #printOn:!development!printing!public! !
!OS.COM.ClassFactory categoriesFor: #register!operations!private! !
!OS.COM.ClassFactory categoriesFor: #registerInstance:!operations!private! !
!OS.COM.ClassFactory categoriesFor: #RequestLicKey:pBstrKey:!COM Interfaces-IClassFactory2!public! !
!OS.COM.ClassFactory categoriesFor: #revoke!private!realizing/unrealizing! !
!OS.COM.ClassFactory categoriesFor: #serverClass!accessing!private! !
!OS.COM.ClassFactory categoriesFor: #serverClass:!accessing!private! !
!OS.COM.ClassFactory categoriesFor: #supportedInterfaces!constants!public! !

!OS.COM.ClassFactory class methodsFor!

basicOn: serverClass clsid: aCLSID 
	"Private - Answer an instance of the receiver for the specified server class and CLSID."

	^(self new)
		serverClass: serverClass;
		clsid: aCLSID;
		yourself!

canUnloadNow
	"Private - Answer whether the COM factory server is no longer in use, and can therefore
	be unloaded (according to COM rules)."

	^LockCount <= 0 and: [Instances isEmpty]!

clearAll	
	"Private - Clear down all registered instances of the receiver."

	Factories do: [:f | f clear]!

decrementLockCount
	"Private - Increment the server lock count."

	LockCount := LockCount - 1.
	LockCount <= 0
		ifTrue: [self shutdownIfDead]
!

freeAll
	"Private - Free all the existing class factories (revoking registrations
	and removing them from the registry of factories)."

	self initializeFactoryRegister!

incrementLockCount
	"Private - Increment the server lock count."

	LockCount := LockCount + 1
!

initialize
	"Private - Initialize the receiver's instance variables.
		COMClassFactory initialize
	"

	LockCount := 0.
	self initializeFactoryRegister.
	Instances := WeakSet new.
	Instances when: #elementsExpired: send: #onElementsExpired: to: self!

initializeFactoryRegister
	"Private - Initialize the receiver's Factory register."

	Factories isNil ifFalse: [self revokeAll].
	Factories := LookupTable new!

lockCount
	"Answer the total class factory lock count (locks result from calls to IClassFactory::LockServer)."

	^LockCount!

on: aServerClass
	"Answer an instance of the receiver registered as a class factory for
	manufacturing instances of aServerClass."

	^self on: aServerClass clsid: aServerClass clsid!

on: serverClass clsid: aCLSID
	"Answer an instance of the receiver for the specified server class and CLSID."

	| factory |
	Factories at: serverClass ifPresent: [:f | ^f].
	factory := self basicOn: serverClass clsid: aCLSID.
	factory register.
	^Factories at: serverClass put: factory!

onElementsExpired: anInteger
	"Private - At least one of server instances created by instances of the receiver has died.
	We handle this notification by determining if it is now possible to shut down the server
	(if opened for embedding only)."

	self shutdownIfDead!

onExit
	"Private - The system is shutting down. Revoke all known class factories.
	N.B. This event is sent by COMInterface, rather than being registered with
	SessionManager, because the order of shutdown is important."

	self revokeAll!

onStartup	
	"Private - The system is starting. Register all known class factories."

	LockCount := 0.
	Factories do: [:f | f clear].
	SessionManager current isDLL ifFalse: [self registerAll].
!

registerAll
	"Private - Register all the existing class factories.
	We register the receiver with the session as a 'server' to keep the image
	alive if required. This server registration will be revoked when the Instances
	weak collection is empty (collection of instances created by instances of the 
	receiver) and the LockCount drops to zero. This implements the COM Class Factory
	server lifetime rules."

	Factories do: [:f | f register].
	Factories notEmpty ifTrue: [SessionManager current registerServer: self]!

revokeAll
	"Private - Revoke all the existing class factories."

	Factories do: [:f | f revoke]
!

revokeOn: serverClass
	"Answer an instance of the receiver for the specified server class and CLSID."

	(Factories at: serverClass ifAbsent: [^self]) revoke!

shutdownIfDead
	"Private - Shutdown the class factory as it is no longer required."

	self canUnloadNow ifTrue: [SessionManager current unregisterServer: self]!

unregister: serverClass
	"Revoke and unregister any class factories for the specified server class."

	| f |
	f := Factories removeKey: serverClass ifAbsent: [^self].
	f revoke! !
!OS.COM.ClassFactory class categoriesFor: #basicOn:clsid:!instance creation!private! !
!OS.COM.ClassFactory class categoriesFor: #canUnloadNow!private!testing! !
!OS.COM.ClassFactory class categoriesFor: #clearAll!initializing!private! !
!OS.COM.ClassFactory class categoriesFor: #decrementLockCount!accessing!private! !
!OS.COM.ClassFactory class categoriesFor: #freeAll!operations!private! !
!OS.COM.ClassFactory class categoriesFor: #incrementLockCount!accessing!private! !
!OS.COM.ClassFactory class categoriesFor: #initialize!development!initializing!private! !
!OS.COM.ClassFactory class categoriesFor: #initializeFactoryRegister!initializing!private! !
!OS.COM.ClassFactory class categoriesFor: #lockCount!accessing!public! !
!OS.COM.ClassFactory class categoriesFor: #on:!instance creation!public! !
!OS.COM.ClassFactory class categoriesFor: #on:clsid:!instance creation!public! !
!OS.COM.ClassFactory class categoriesFor: #onElementsExpired:!event handling!private! !
!OS.COM.ClassFactory class categoriesFor: #onExit!event handling!private! !
!OS.COM.ClassFactory class categoriesFor: #onStartup!event handling!private! !
!OS.COM.ClassFactory class categoriesFor: #registerAll!operations!private! !
!OS.COM.ClassFactory class categoriesFor: #revokeAll!operations!private! !
!OS.COM.ClassFactory class categoriesFor: #revokeOn:!instance creation!public! !
!OS.COM.ClassFactory class categoriesFor: #shutdownIfDead!operations-shutdown!private! !
!OS.COM.ClassFactory class categoriesFor: #unregister:!instance creation!public! !

