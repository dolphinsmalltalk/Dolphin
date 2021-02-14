"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'OS.COM.IConnectionPoint'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.IConnectionPoint guid: (OS.COM.IID fromString: '{b196b286-bab4-101a-b69c-00aa00341d07}')!
OS.COM.IConnectionPoint comment: '<IConnectionPoint> is a wrapper class for the custom interface ''OBJIDL.IConnectionPoint'' generated from type information in the ''ObjIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface.

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!OS.COM.IConnectionPoint categoriesForClass!No category! !
!OS.COM.IConnectionPoint methodsFor!

advise: client
	"Connect a clients connection point callback interface (which is usually a dispinterface)
	to the receiver. The client will receive any events sent through the receiver until 
	disconnected with #unadvise."

	| cookie |
	cookie := DWORD new.
	self Advise: client pdwCookie: cookie.
	^cookie asInteger!

Advise: pUnkSink pdwCookie: pdwCookie
	"Private - Invoke the Advise() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Advise(
			[in] IUnknown* pUnkSink,
			[out] unsigned long* pdwCookie);
	"

	<virtual stdcall: hresult 6 IUnknown* dword*>
	^self invalidCall: _failureCode!

connectionIID
	"Answer the IID of the receiver's connection pointer interface."

	| answer |
	answer := IID new.
	self GetConnectionInterface: answer.
	^answer!

connections
	"Answer a collection of the <CONNECTDATA> structures describing
	the sinks currently attached to the receiver."

	^Enumerable onIEnum: self enumConnections!

enumConnections
	| answer |
	answer := IEnumStruct elementClass: CONNECTDATA.
	self EnumConnections: answer.
	^answer!

EnumConnections: ppenum
	"Private - Invoke the EnumConnections() method of the COM object wrapped by the receiver.

		HRESULT __stdcall EnumConnections(
			[out] IEnumConnections** ppenum);
	"

	<virtual stdcall: hresult 8 void**>
	^self invalidCall: _failureCode!

getConnectionInterface
	"Answer the <GUID> result of invoking the COM Object's GetConnectionInterface() method."

	| answer |
	answer := GUID new.
	self
		GetConnectionInterface: answer.
	^answer asObject
!

GetConnectionInterface: pIID
	"Private - Invoke the GetConnectionInterface() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetConnectionInterface(
			[out] GUID* pIID);
	"

	<virtual stdcall: hresult 4 guid*>
	^self invalidCall: _failureCode!

getConnectionPointContainer
	"Answer the <IConnectionPointContainer> result of invoking the COM Object's GetConnectionPointContainer() method."

	| answer |
	answer := IConnectionPointContainer newPointer.
	self GetConnectionPointContainer: answer.
	^answer asObject!

GetConnectionPointContainer: ppCPC
	"Private - Invoke the GetConnectionPointContainer() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetConnectionPointContainer(
			[out] IConnectionPointContainer** ppCPC);
	"

	<virtual stdcall: hresult 5 IConnectionPointContainer**>
	^self invalidCall: _failureCode!

printOn: aStream
	"Append a developer friendly textual representation of the receiver to aStream."

	aStream 
		basicPrint: self;
		nextPut: $(;
		print: (self isNull ifTrue: ['NULL'] ifFalse: [self connectionIID]);
		nextPut: $)!

unadvise: dwCookie 
	"Invoke the Unadvise() method of the COM Object."

	self
		Unadvise: dwCookie
!

Unadvise: dwCookie
	"Private - Invoke the Unadvise() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Unadvise(
			[in] unsigned long dwCookie);

	Implementation Note: We really don't care about errors here, so we use an sdword return type
	rather than the auto-exception raising hresult.	
	"

	<virtual stdcall: sdword 7 dword>
	^self invalidCall: _failureCode! !
!OS.COM.IConnectionPoint categoriesFor: #advise:!adding!public! !
!OS.COM.IConnectionPoint categoriesFor: #Advise:pdwCookie:!**auto generated**!COM Interfaces-IConnectionPoint!private! !
!OS.COM.IConnectionPoint categoriesFor: #connectionIID!accessing!public! !
!OS.COM.IConnectionPoint categoriesFor: #connections!enumerating!public! !
!OS.COM.IConnectionPoint categoriesFor: #enumConnections!methods!public! !
!OS.COM.IConnectionPoint categoriesFor: #EnumConnections:!**auto generated**!COM Interfaces-IConnectionPoint!private! !
!OS.COM.IConnectionPoint categoriesFor: #getConnectionInterface!**auto generated**!methods!public! !
!OS.COM.IConnectionPoint categoriesFor: #GetConnectionInterface:!**auto generated**!COM Interfaces-IConnectionPoint!private! !
!OS.COM.IConnectionPoint categoriesFor: #getConnectionPointContainer!**auto generated**!methods!public! !
!OS.COM.IConnectionPoint categoriesFor: #GetConnectionPointContainer:!**auto generated**!COM Interfaces-IConnectionPoint!private! !
!OS.COM.IConnectionPoint categoriesFor: #printOn:!development!printing!public! !
!OS.COM.IConnectionPoint categoriesFor: #unadvise:!**auto generated**!methods!public! !
!OS.COM.IConnectionPoint categoriesFor: #Unadvise:!COM Interfaces-IConnectionPoint!private! !

!OS.COM.IConnectionPoint class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OBJIDL.IConnectionPoint'
		IConnectionPoint defineTemplate
	"

	self
		defineFunction: #GetConnectionInterface:
			argumentTypes: 'GUID*';
		defineFunction: #GetConnectionPointContainer:
			argumentTypes: 'IConnectionPointContainer**';
		defineFunction: #Advise:pdwCookie:
			argumentTypes: 'IUnknown* dword*';
		defineFunction: #Unadvise:
			argumentTypes: 'dword';
		defineFunction: #EnumConnections:
			argumentTypes: 'void**'
! !
!OS.COM.IConnectionPoint class categoriesFor: #defineFunctions!initializing!public! !

