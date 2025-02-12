﻿"Filed out from Dolphin Smalltalk"!

OS.COM.InterfaceImplementation
	subclass: #'Kernel.IPDolphin'
	instanceVariableNames: 'plugHole coclasses'
	classVariableNames: 'Current'
	imports: #(#{OS.COM private})
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.IPDolphin guid: (Core.GUID fromString: '{b115d2d8-5a00-4a5e-8615-109a3332690f}')!

Kernel.IPDolphin comment: '`IPDolphin` is the singleton class whose instance is responsible for managing communication with the C++ code of the Dolphin in-process COM DLL stubs. IPDolphin implements the `IIPDolphin` COM interface that the stub calls to communicate with the image, and holds the `IIPPlugHole` implemented by the Dolphin in-process COM DLL stubs for calls back to the stub. The instance is responsible for initialization and shutdown of the image, and for implementing the 4 core COM DLL services. ultimately for implementing the `DllGetClassObject`, `DllCanUnloadNow`, `DllRegisterServer` and `DllUnregisterServer` functions that are exported by the stub.

Once a Dolphin in-proc COM DLL has been loaded, inbound calls to the DllXXX functions in the stub are forwarded here.

## Instance Variables:
  `plugHole`		`IIPPlugHole`. COM interface used to communicate with the in-proc stub. Implemented in the stub C++ code, and passed in when the stub starts the in-proc image.
  `coclasses`		`LookupTable` of creatable classes, typically subclasses of `OS.COM.InterfaceImplementation`, for which class factories can be requested.

## Class Variables:
  `Current`		`IPDolphin`.  Singleton instance.

'!

!Kernel.IPDolphin methodsFor!

canUnloadNow
	"Private - Answer whether it is OK to unload the in-proc. image now."

	^SessionManager current canUnloadNow!

CanUnloadNow 
	"Private - Answer whether it is OK to unload the in-proc. image now.

		HRESULT __stdcall CanUnloadNow();
	"

	^self canUnloadNow
		ifTrue: [S_OK]
		ifFalse: [S_FALSE]!

coclasses
	"Private - Answer a <LookupTable> of the creatable coclasses supported by this image
	keyed by <CLSID>."

	coclasses isNil 
		ifTrue: 
			[coclasses := LookupTable new.
			Smalltalk allBehaviorsDo: 
					[:each | 
					(each conformsToProtocol: #COMObject) 
						ifTrue: 
							[| clsid |
							clsid := (each respondsTo: #clsid) ifTrue: [each clsid].
							(clsid isNull or: [coclasses includesKey: clsid]) 
								ifFalse: [coclasses at: clsid put: each]]]].
	^coclasses!

fileName
	^self session imageFileName!

GetClassObject: rclsid riid: riid ppv: ppv
	"Private - The DLLGetClassObject() function of the in-proc component has been called by the OLE/COM
	system, respond by answering the requested class factory.

		HRESULT __stdcall GetClassObject(
			[in] GUID* rclsid,
			[in] GUID* riid,
			[out, retval] void** ppv);
	"

	ppv value: 0.
	self coclasses at: rclsid ifPresent: [:coclass | | factory punk ifClass |
		factory := ClassFactory on: coclass clsid: rclsid.
		ifClass := Interface classForIID: riid ifNone: [^E_NOINTERFACE].
		punk := factory queryInterface: ifClass ifNone: [^E_NOINTERFACE].
		ppv value: punk detach.
		^S_OK].
			
	^CLASS_E_CLASSNOTAVAILABLE!

initialize
	self session
		when: #sessionStarted
			send: #onStartup
			to: self;
		when: #sessionStopped
			send: #onStopped
			to: self!

OnInitialize
	"Private - This in-process COM component has just been loaded and is being informed of that fact.
	Perform any once-off initialization required.

		HRESULT __stdcall OnInitialize();
	"

	self traceStream
		print: self;
		nextPutAll: ' OnInitialize - Started Dolphin image: ';
		print: self fileName;
		cr.
	^S_OK!

OnShutdown
	"Private - The in-proc COM component is being unloaded, perform any shutdown actions that
	might be required.

		HRESULT __stdcall OnShutdown();
	"

	self traceStream
		print: self; 
		nextPutAll: ' OnShutdown - Initiating exit of Dolphin image ';
		print: self fileName;
		cr.
	self pullPlug.

	"To avoid locking up the calling thread we must perform the actual VM exit after this call has returned, so post a quit.
	The negative exit code prevents a development session manager from allowing the user to cancel."
	self session exit: -1.
	^S_OK!

onStartup
	"Private - Perform any session startup actions."

	"Implementation Note: See if the in-proc. plug-hole started us up by querying <IIPPlugHole> off the outer <IUnknown> passed as a startup argument. If it did then pass it back an <IIPDolphin>	on the receiver so that it can call in for registration services, class factories, etc."

	| unkOuter |
	coclasses := nil.
	plugHole := nil.
	(unkOuter := self session outer) notNull
		ifTrue: 
			[plugHole := unkOuter queryInterface: IIPPlugHole.
			plugHole isNull
				ifFalse: 
					[| if |
					if := self queryInterface: IIPDolphin.
					plugHole put_Peer: if.
					if free]]!

onStopped
	"Private - Perform any session shutdown actions."

	self pullPlug!

pullPlug
	"Private - Break the connection with the host."

	plugHole
		ifNil: 
			["Already pulled"
			^self].
	[plugHole put_Peer: nil] on: HRESULTError do: [:ex | ex toTrace].
	plugHole free.
	plugHole := nil!

registerCoClasses
	| classes |
	classes := self coclasses.
	self traceStream
		nextPutAll: 'Attempting to register coclasses: ';
		print: coclasses associations;
		cr.
	classes do: [:coclass | coclass registerComServer].
	self traceStream
		nextPutAll: 'Successfully registered coclasses';
		cr!

registerServer
	self
		registerTypeLib;
		registerCoClasses!

RegisterServer
	"Private - The DLLRegisterServer() function of the in-proc DLL has been called.
	Register any objects supported by this in-proc component.

		HRESULT __stdcall RegisterServer();
	"

	^
	[self registerServer.
	S_OK] on: Error
			do: 
				[:ex |
				self traceStream
					nextPutAll: 'COM Server registration failed: ';
					nextPutAll: ex description;
					cr.
				ex return: ex hresult asInteger]!

registerTypeLib
	"Private - Register the type library embedded in the DLL, if any."

	^
	[(ITypeLib open: self fileName register: true) free.
	self traceStream
		nextPutAll: 'Successfully registered type library';
		cr.
	S_OK]
			on: HRESULTError
			do: 
				[:ex |
				self traceStream
					nextPutAll: 'Failed to register type library: ';
					nextPutAll: ex description;
					cr.
				ex return: ex hresult asInteger]!

session
	^SessionManager current!

supportedInterfaces
	"Answer the set of interface classes supported by the receiver."

	^##({ IUnknown. IIPDolphin })!

traceStream
	^SessionManager current traceStream!

unregisterCoClasses
	self coclasses do: [:coclass | coclass unregisterComServer]!

unregisterServer
	self
		unregisterTypeLib;
		unregisterCoClasses!

UnregisterServer
	"Private - The DLLUnregisterServer() function of the in-proc DLL has been called.
	Unregister any objects supported by this in-proc component.

		HRESULT __stdcall UnregisterServer();
	"

	^
	[self unregisterServer.
	S_OK] on: Error
			do: 
				[:ex |
				self traceStream
					nextPutAll: 'COM Server unregistration failed: ';
					nextPutAll: ex description;
					cr.
				ex return: ex hresult asInteger]!

unregisterTypeLib
	"Private - Register the type library embedded in the DLL, if any."

	^
	[ITypeLib unregister: self fileName.
	self traceStream
		nextPutAll: 'Successfully unregistered type library';
		cr.
	S_OK]
			on: HRESULTError
			do: 
				[:ex |
				self traceStream
					nextPutAll: 'Failed to unregister type library: ';
					nextPutAll: ex description;
					cr.
				ex return: ex hresult asInteger]! !

!Kernel.IPDolphin categoriesForMethods!
canUnloadNow!private!testing! !
CanUnloadNow!COM Interfaces-IPDolphin!private! !
coclasses!enumerating!private! !
fileName!accessing!private! !
GetClassObject:riid:ppv:!COM Interfaces-IPDolphin!private! !
initialize!initializing!private! !
OnInitialize!COM Interfaces-IPDolphin!private! !
OnShutdown!COM Interfaces-IPDolphin!private! !
onStartup!events-session!private! !
onStopped!events-session!private! !
pullPlug!operations!private! !
registerCoClasses!private!registering! !
registerServer!private!registering! !
RegisterServer!COM Interfaces-IPDolphin!private! !
registerTypeLib!private!registering! !
session!accessing!private! !
supportedInterfaces!constants!public! !
traceStream!accessing!private! !
unregisterCoClasses!operations!private! !
unregisterServer!operations!private! !
UnregisterServer!COM Interfaces-IPDolphin!private! !
unregisterTypeLib!private!registering! !
!

Kernel.IPDolphin methodProtocol: #'IPDolphin.IInProcDolphin' attributes: #(#readOnly) selectors: #(#CanUnloadNow #GetClassObject:riid:ppv: #OnInitialize #OnShutdown #RegisterServer #UnregisterServer)!

!Kernel.IPDolphin class methodsFor!

current
	"Answer the singleton instance of the receiver."

	^Current ifNil: [Current := super new initialize]!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	self current.!

new
	"Private - The receiver is a singleton class"

	^self shouldNotImplement!

onExit
	Current ifNil: [^self].
	Current pullPlug!

reset
	"Private - Reset the current instance of the receiver.
		self reset
	"

	Current := nil!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	self reset.! !

!Kernel.IPDolphin class categoriesForMethods!
current!instance creation!public! !
initialize!initializing!private! !
new!object creation!private! !
onExit!instance creation!public! !
reset!instance creation!private! !
uninitialize!class hierarchy-removing!private! !
!

