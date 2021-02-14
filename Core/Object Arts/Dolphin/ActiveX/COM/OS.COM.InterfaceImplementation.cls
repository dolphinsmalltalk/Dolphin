"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'OS.COM.InterfaceImplementation'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.Win32Errors} #{OS.COM.OLEConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.InterfaceImplementation guid: (Core.GUID fromString: '{87b4c467-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.COM.InterfaceImplementation isNonInstantiable: true!
OS.COM.InterfaceImplementation comment: '`OS.COM.InterfaceImplementation` is an abstract class which provides the basic implementation for a COM object such as interface querying (i.e. implements #queryInterface:ifNone: sent by the framework when a previously unencountered interface is requested of the COM object), factory registration, CLSID access, and aggregation.

Note that, although it is convenient, it is not necessary for a COM server object to be a subclass of this class: any Dolphin object can be a COM object. The COM framework provides a wrapper class, `OS.COM.ObjectStub`, which takes care of the boilerplate implementation details, and hence the responsibilities here are few and simple. The only message sent by framework to a COM server object is #queryInterface:ifNone:, and even that is optional. If your class sits more happily elsewhere in the hierarchy then this class is a suitable reference for implementing COM support directly in your class.

Subclasses should implement:
	(class)#clsid		to answer their CLSID
	(class)#progID			to answer their ProgID (necessary for registration)
	#supportedInterfaces		to answer an Array of the support interface classes (not class names)

Subclasses may implement:
	#aggregatee		to answer an aggregated object, if supported

Having added your subclass (and implemented #clsid), you can expose your object to external clients by sending the class the #registerClassFactory method. This need only be done once and a class factory will then be registered with COM each time the image is started. #revokeClassFactories permanently undoes the registration.

Should you wish to aggregate another object in your subclass then see the comment in the #aggregatee instance method for further instructions.'!
!OS.COM.InterfaceImplementation categoriesForClass!COM-Implementations! !
!OS.COM.InterfaceImplementation methodsFor!

aggregatee
	"Answer the IUnknown (which must be a non-delegating unknown implementation)
	of any aggregatee of the receiver, or nil if there is none (the default case).

	Note: In order to aggregate an object in a subclass:
	1)	 Add an instance variable to hold the IUnknown pointer to the aggregatee.
	2) 	Override #initialize on the instance side to create the aggregatee and store down
		the aggregatee's non-delegating unknown into the instance variable, e.g:
			innee := IUnknown onCLSID: Aggee clsid outerIUnknown: (self queryInterface: IUnknown)
	3) 	Override this method to answer the instance variable holding the inner unknown ('innee' in the eg).
	
	Should you wish to aggregate more than one object, then you will need to hold an array of the non-delegating
	unknowns of the contained objects and also override #queryInterface:ifNone:"

	^nil!

clsid
	"Answer the CLSID which identifies the receiver's server class in the registry.
	Valid subclasses can be created which do not implement this method, but they will
	not be valid COM 'class' implementations."

	^self class clsid!

finalRelease
	"The last reference to the receiver (as a COM object) has been released.
	This is an opportunity to actively clean up, rather than passively waiting 
	for finalization which might is asynchronous and may never happen if the 
	object doesn't become garbage."

	"Override as necessary"!

queryInterface: anInterfaceClass
	"Answer a new interface which supports the specified interface protocol
	(usually a class), or nil if the receiver does not support the interface."

	^self queryInterface: anInterfaceClass ifNone: []
!

queryInterface: anInterfaceClass ifNone: exceptionHandler
	"Answer a new interface pointer which supports the specified interface protocol
	(usually a class). If the receiver does not support the interface, answer the
	result of evaluating the niladic valuable, exceptionHandler."

	| class |
	class := self supportedInterfaces 
				detect: [:ic | ic supportsInterface: anInterfaceClass] 
				ifNone: [ | aggee |
					aggee := self aggregatee.
					^aggee isNil 
						ifTrue: [exceptionHandler value]
						ifFalse: [aggee queryInterface: anInterfaceClass ifNone: exceptionHandler]].
	^class on: self server implementor: self!

server
	"Answer the server object on behalf of which the receiver is implementing an
	interface or interfaces. By default this is the receiver itself, but subclasses
	may implement interfaces on behalf of other objects in order that any particular
	server object can support any number of interfaces with different implementors."

	^self!

supportedInterfaces
	"Answer the set of interface classes supported by the receiver.
	N.B. The receiver should implement all of the methods defined in all of the 
	interfaces in the collection answered, with the same selector names (i.e. the
	first keyword will be the COM function name, with an uppercase initial letter).
	A simple way to generate templates for these methods is to use the <MethodProtocol>
	mechanism. The type library analyzer can be configured to generate a protocol when
	it is building an interface wrapper class. The protocol can simply be dragged into
	the implementation class to generate the required set of methods. These template 
	methods do nothing but return E_NOTIMPL and can be implemented
	as necessary."

	^self subclassResponsibility! !
!OS.COM.InterfaceImplementation categoriesFor: #aggregatee!accessing!public! !
!OS.COM.InterfaceImplementation categoriesFor: #clsid!accessing!public! !
!OS.COM.InterfaceImplementation categoriesFor: #finalRelease!public!realizing/unrealizing! !
!OS.COM.InterfaceImplementation categoriesFor: #queryInterface:!accessing-interfaces!public! !
!OS.COM.InterfaceImplementation categoriesFor: #queryInterface:ifNone:!accessing!accessing-interfaces!public! !
!OS.COM.InterfaceImplementation categoriesFor: #server!accessing!public! !
!OS.COM.InterfaceImplementation categoriesFor: #supportedInterfaces!constants!public! !

OS.COM.InterfaceImplementation methodProtocol: #COMObject attributes: #(#readOnly) selectors: #(#clsid #finalRelease #queryInterface: #queryInterface:ifNone:)!

!OS.COM.InterfaceImplementation class methodsFor!

clsid
	"Answer the CLSID which identifies the receiver's server class in the registry.
	Valid subclasses can be created which do not implement this method, but they will
	be noncreatable COM coclasses (i.e they cannot be instantiated with CoCreateInstance())."

	^CLSID null!

inprocSurrogate: aBoolean
	"Answer the COM server DLL which can be used as a surrogate to host the development
	image. This can be used for debugging an in-process component, or bound with a stripped image
	to create a deployable in-process component."

	^aBoolean ifTrue: ['IPDolphinToGo.dll'] ifFalse: ['IPDolphin.dll']!

new
	"Answer a new initialized instance of the receiver.
	Many COM object implementations will require initializing."

	^super new initialize!

progDescription
	"Answer the description of the receiver's used to represent it as a COM component in client
	applications or programming environments.
	It is sensible to override this to provide a more friendly name, but this is the kind of name one
	gets from, e.g.,  the ATL wizard, and I suppose its better than nothing."

	^self name, ' object'

	!

progID
	"Answer the receiver's programmatic ID, typically used from scripting or macro languagues to 
	create instances of the receiver, e.g. 'Dolphin.Object.1'. This is not mandatory, and if not 
	specified for the component then the answer will be nil."

	^nil!

register
	"Make the necessary registry entries to expose the receiver as a COM object which can be used by
	other applications. Registry entries for both in-process and out-of-process use are created if the 
	necessary components are present. This (along with #unregister) provides the necessary mechanism 
	for self-registration."

	| sesh |
	sesh := SessionManager current.
	self register: (sesh isDLL 
				ifTrue: [CLSCTX_INPROC_SERVER]
				ifFalse: 
					[sesh isRuntime 
						ifTrue: [CLSCTX_LOCAL_SERVER]
						ifFalse: 
							["For development, register both generic stubs"

							CLSCTX_INPROC_SERVER | CLSCTX_LOCAL_SERVER]])!

register: anInteger
	"Make the necessary registry entries to expose the receiver as a COM object which can be used by
	other applications for serving objects with the specified class creation context flags."

	| desc clsid pid clsidKey |
	clsid := self clsid asString.
	desc := self progDescription.
	pid := self progID.
	"First the ProgID to CLSID mappings (if ProgId available)"
	pid notNil 
		ifTrue: 
			[| vipid pidKey vipidKey |
			vipid := self versionIndependentProgID.
			pidKey := RegKey classesRoot createKey: pid.
			pidKey value: desc.
			pidKey at: 'CLSID' put: clsid.
			vipidKey := RegKey classesRoot createKey: vipid.
			vipidKey
				value: desc;
				at: 'CLSID' put: clsid;
				at: 'CurVer' put: pid].

	"Then the CLSID to server .EXE/.DLL mappings."
	clsidKey := (RegKey classesRoot at: 'CLSID') createKey: clsid.
	clsidKey value: desc.
	pid notNil ifTrue: [clsidKey at: 'ProgID' put: pid].
	(anInteger allMask: CLSCTX_LOCAL_SERVER) ifTrue: [self registerAsLocalServer: clsidKey].
	(anInteger allMask: CLSCTX_INPROC_SERVER) ifTrue: [self registerAsInProcServer: clsidKey]!

registerAsInProcServer: aRegKey
	| sesh imageFileName |
	sesh := SessionManager current.
	imageFileName := sesh imageFileName.
	sesh isDLL 
		ifTrue: [aRegKey at: 'InProcServer32' put: imageFileName]
		ifFalse: 
			["For an executable image we can register the generic in-proc stub for 
			in-process activation (but only if it is available)."

			| inProcStub |
			inProcStub := FileLocator installRelative localFileSpecFor: (self inprocSurrogate: false).
			(File exists: inProcStub) 
				ifTrue: 
					[aRegKey at: 'InProcServer32' put: inProcStub.
					"The Dolphin specific 'Image' key is needed so the generic stub can find the image to load"
					aRegKey at: 'Image' put: imageFileName]]!

registerAsLocalServer: aRegKey
	| commandLine sesh |
	commandLine := String writeStream.
	commandLine nextPutAll: (External.DynamicLinkLibrary moduleFileName: nil).
	sesh := SessionManager current.
	sesh isRuntime
		ifFalse: 
			[commandLine
				space;
				nextPut: $";
				nextPutAll: sesh imageFileName;
				nextPut: $"].
	aRegKey at: 'LocalServer32' put: commandLine contents!

registerClassFactory
	"Register a class factory on the receiver and answer it."

	^ClassFactory on: self!

revokeClassFactories
	"Revoke any class factories on the receiver."

	^ClassFactory revokeOn: self!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system
	(ensure that any class factories are unregistered and revoked)."

	self unregisterClassFactory!

uninitializeBeforeRemove
	"Perform any pre-removal uninitialisation for the class. This includes any specific #uninitialize
	implementation (but note that #uninitialize is only sent to classes which directly implement
	#uninitialize, otherwise we'd probably end up damaging superclasses which are not being
	removed).
	Implementation Note: This is one of those cases where we want subclasses to inherit the
	uninitialize, so override to always call it."

	self uninitialize!

unregister
	"Tidy away the residue of a previous #register from the Windows registration database."

	self progID
		ifNotNil:
			[:pid | 
			(RegKey classesRoot)
				removeKey: pid
					ifAbsent: [];
				removeKey: self versionIndependentProgID
					ifAbsent: []].
	(RegKey classesRoot at: 'CLSID')
		removeKey: self clsid asString
		ifAbsent: []!

unregisterClassFactory
	"Revoke and unregistery any class factories on the receiver."

	^ClassFactory unregister: self!

versionIndependentProgID
	"Answer the receiver's version independent programmatic ID, typically used from 
	scripting or macro languagues to create instances of the receiver, e.g. 'Dolphin.Object'.
	Implementation Note: Override this if you don't want to follow the usual convention
	of the version independent ProgID being the ProgID sans the last numeric component."

	| pid |
	pid := self progID.
	^pid copyFrom: 1 to: (pid lastIndexOf: $.)-1! !
!OS.COM.InterfaceImplementation class categoriesFor: #clsid!constants!public! !
!OS.COM.InterfaceImplementation class categoriesFor: #inprocSurrogate:!constants!public! !
!OS.COM.InterfaceImplementation class categoriesFor: #new!instance creation!public! !
!OS.COM.InterfaceImplementation class categoriesFor: #progDescription!accessing!public! !
!OS.COM.InterfaceImplementation class categoriesFor: #progID!constants!public! !
!OS.COM.InterfaceImplementation class categoriesFor: #register!operations!public! !
!OS.COM.InterfaceImplementation class categoriesFor: #register:!operations!public! !
!OS.COM.InterfaceImplementation class categoriesFor: #registerAsInProcServer:!helpers!private! !
!OS.COM.InterfaceImplementation class categoriesFor: #registerAsLocalServer:!helpers!private! !
!OS.COM.InterfaceImplementation class categoriesFor: #registerClassFactory!operations!public! !
!OS.COM.InterfaceImplementation class categoriesFor: #revokeClassFactories!operations!public! !
!OS.COM.InterfaceImplementation class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!OS.COM.InterfaceImplementation class categoriesFor: #uninitializeBeforeRemove!class hierarchy-removing!private! !
!OS.COM.InterfaceImplementation class categoriesFor: #unregister!operations!public! !
!OS.COM.InterfaceImplementation class categoriesFor: #unregisterClassFactory!operations!public! !
!OS.COM.InterfaceImplementation class categoriesFor: #versionIndependentProgID!constants!public! !

