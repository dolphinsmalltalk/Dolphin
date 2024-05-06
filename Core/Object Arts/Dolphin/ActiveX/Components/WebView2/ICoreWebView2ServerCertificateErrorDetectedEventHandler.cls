"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2ServerCertificateErrorDetectedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ICoreWebView2ServerCertificateErrorDetectedEventHandler guid: (IID fromString: '{969b3a26-d85e-4795-8199-fef57344da22}')!

ICoreWebView2ServerCertificateErrorDetectedEventHandler comment: '`ICoreWebView2ServerCertificateErrorDetectedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ServerCertificateErrorDetectedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(969b3a26-d85e-4795-8199-fef57344da22)
]
interface ICoreWebView2ServerCertificateErrorDetectedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2ServerCertificateErrorDetectedEventArgs* args);
};
```
'!

!ICoreWebView2ServerCertificateErrorDetectedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!ICoreWebView2ServerCertificateErrorDetectedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_ServerCertificateErrorDetected: self token: tokenBuffer!

basicUnregister
	source Remove_ServerCertificateErrorDetected: token! !

!ICoreWebView2ServerCertificateErrorDetectedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2ServerCertificateErrorDetectedEventHandler class methodsFor!

argsClass
	^ICoreWebView2SourceChangedEventArgs!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ServerCertificateErrorDetectedEventHandler'
		ICoreWebView2ServerCertificateErrorDetectedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2ServerCertificateErrorDetectedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#serverCertificateErrorDetected:! !

!ICoreWebView2ServerCertificateErrorDetectedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

