"Filed out from Dolphin Smalltalk 7"!

COMInterfaceImp subclass: #'Kernel.IPDolphin'
	instanceVariableNames: 'plugHole coclasses'
	classVariableNames: 'Current'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.IPDolphin guid: (Core.GUID fromString: '{b115d2d8-5a00-4a5e-8615-109a3332690f}')!
Kernel.IPDolphin comment: 'IPDolphin is the singleton class whose instance hosts the main inbound COM interface, <IIPPlugHole> from the Dolphin in-process COM DLL stub. It is responsible for initialization and shutdown of the image, and ultimately for implementing the DllGetClassObject, DllCanUnloadNow, DllRegisterServer and DllUnregisterServer functions that are exported by the stub.

Once a Dolphin in-proc COM DLL has been loaded, inbound calls to the DllXXX functions in the stub are forwarded here.

Instance Variables:
	plugHole		<IIPPlugHole>
	coclasses		<LookupTable> of creatable classes below <COMInterfaceImp> for which class factories can be requested.

Class Variables:
	Current		<IPDolphin>. Singleton instance.

'!
!Kernel.IPDolphin categoriesForClass!Unclassified! !
!Kernel.IPDolphin methodsFor!

canUnloadNow
	"Answer whether it is OK to unload the in-proc. image now."

	Smalltalk.COMClassFactory lockCount > 0 ifTrue: [^false].
	#todo.	"Need a neater way to do this - at the moment need to look for COM objects are not the receiver to decide
			whether should stay up. Need to maintain a count and let those types of object adjust it so that they are 
			ignored?"
	Smalltalk.COMObjectStub registry keysDo: [:e | e ~~ self ifTrue: [^false]].
	^true!

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
		factory := Smalltalk.COMClassFactory on: coclass clsid: rclsid.
		ifClass := Smalltalk.COMInterface classForIID: riid ifNone: [^E_NOINTERFACE].
		punk := factory queryInterface: ifClass ifNone: [^E_NOINTERFACE].
		ppv value: punk detach.
		^S_OK].
			
	^CLASS_E_CLASSNOTAVAILABLE!

initialize
	SessionManager current 
		when: #sessionStarted
		send: #onStartup
		to: self!

OnInitialize
	"Private - This in-process COM component has just been loaded and is being informed of that fact.
	Perform any once-off initialization required.

		HRESULT __stdcall OnInitialize();
	"

	"Trace nextPutAll: 'OnInitialize: Started Dolphin image: '; print: SessionManager current imageFileName; cr."

	^S_OK!

OnShutdown
	"Private - The in-proc COM component is being unloaded, perform any shutdown actions that
	might be required.

		HRESULT __stdcall OnShutdown();
	"

	"Trace nextPutAll: 'OnShutdown: Exiting Dolphin image '; print: SessionManager current imageFileName; cr."

	SessionManager current isEmbedded 
		ifFalse: 
			[| mb |
			mb := UI.MessageBox new.
			mb beTaskModal.
			(mb confirm: 'You are about to exit Dolphin Smalltalk
Do you wish to save the image?') 
				ifTrue: [SessionManager current saveImage]].
	self pullPlug.

	"To avoid locking up the calling thread we must perform the actual VM exit after this call has returned,
	so post a non-cancellable quit (exit codes < 1 do not cause dev. session manager to prompt)."
	SessionManager current exit: -1.
	^S_OK!

onStartup
	"Private - Perform any session startup actions. 
	Implementation Note: See if the in-proc. plug-hole started us up by querying <IIPPlugHole> off the
	outer <IUnknown> passed as a startup argument. If it did then pass it back an <IIPDolphin>
	on the receiver so that it can call in for registration services, class factories, etc."

	| unkOuter |
	coclasses := nil.
	plugHole := nil.
	(unkOuter := SessionManager current outer) notNull
		ifTrue: 
			[plugHole := unkOuter queryInterface: IIPPlugHole.
			plugHole isNull
				ifFalse: 
					[| if |
					if := self queryInterface: IIPDolphin.
					plugHole put_Peer: if.
					if free]]!

pullPlug
	"Private - Break the connection with the host."

	plugHole free.
	plugHole := nil!

RegisterServer
	"Private - The DLLRegisterServer() function of the in-proc DLL has been called.
	Register any objects supported by this in-proc component.

		HRESULT __stdcall RegisterServer();
	"

	^
	[self coclasses do: [:coclass | coclass register].
	S_OK] on: Error
			do: 
				[:e | 
				e toTrace.
				e hresult asInteger]!

supportedInterfaces
	"Answer the set of interface classes supported by the receiver."

	^{IIPDolphin}!

UnregisterServer 
	"Private - The DLLUnregisterServer() function of the in-proc DLL has been called.
	Unregister any objects supported by this in-proc component.

		HRESULT __stdcall UnregisterServer();
	"
	| hr |

	[
		self coclasses do: [:coclass | coclass unregister].
		hr := S_OK.
	] on: Error do: [:e |
		e toTrace.
		hr := e hresult asInteger].

	^hr
! !
!Kernel.IPDolphin categoriesFor: #canUnloadNow!COM Interfaces-IInProcDolphin!public! !
!Kernel.IPDolphin categoriesFor: #CanUnloadNow!COM Interfaces-IInProcDolphin!private! !
!Kernel.IPDolphin categoriesFor: #coclasses!enumerating!private! !
!Kernel.IPDolphin categoriesFor: #GetClassObject:riid:ppv:!COM Interfaces-IInProcDolphin!private! !
!Kernel.IPDolphin categoriesFor: #initialize!initializing!private! !
!Kernel.IPDolphin categoriesFor: #OnInitialize!COM Interfaces-IInProcDolphin!private! !
!Kernel.IPDolphin categoriesFor: #OnShutdown!COM Interfaces-IInProcDolphin!private! !
!Kernel.IPDolphin categoriesFor: #onStartup!events-session!private! !
!Kernel.IPDolphin categoriesFor: #pullPlug!operations!private! !
!Kernel.IPDolphin categoriesFor: #RegisterServer!COM Interfaces-IInProcDolphin!private! !
!Kernel.IPDolphin categoriesFor: #supportedInterfaces!constants!public! !
!Kernel.IPDolphin categoriesFor: #UnregisterServer!COM Interfaces-IInProcDolphin!private! !

Kernel.IPDolphin methodProtocol: #'IPDolphin.IInProcDolphin' attributes: #(#readOnly) selectors: #(#CanUnloadNow #GetClassObject:riid:ppv: #OnInitialize #OnShutdown #RegisterServer #UnregisterServer)!

!Kernel.IPDolphin class methodsFor!

current
	"Answer the singleton instance of the receiver."

	Current isNil ifTrue: [Current := super new initialize].
	^Current!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	self current.!

new
	"Private - The receiver is a singleton class"

	^self shouldNotImplement!

reset
	"Private - Reset the current instance of the receiver.
		self reset
	"

	Current := nil!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	self reset.! !
!Kernel.IPDolphin class categoriesFor: #current!instance creation!public! !
!Kernel.IPDolphin class categoriesFor: #initialize!initializing!private! !
!Kernel.IPDolphin class categoriesFor: #new!object creation!private! !
!Kernel.IPDolphin class categoriesFor: #reset!instance creation!private! !
!Kernel.IPDolphin class categoriesFor: #uninitialize!class hierarchy-removing!private! !

