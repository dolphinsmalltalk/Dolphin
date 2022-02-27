"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler subclass: #'WebView2.ICoreWebView2ClientCertificateRequestedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2ClientCertificateRequestedEventHandler guid: (OS.COM.IID fromString: '{d7175ba2-bcc3-11eb-8529-0242ac130003}')!
WebView2.ICoreWebView2ClientCertificateRequestedEventHandler comment: '`ICoreWebView2ClientCertificateRequestedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ClientCertificateRequestedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(d7175ba2-bcc3-11eb-8529-0242ac130003)
]
interface ICoreWebView2ClientCertificateRequestedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2ClientCertificateRequestedEventArgs* args);
};
```
'!
!WebView2.ICoreWebView2ClientCertificateRequestedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2ClientCertificateRequestedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_ClientCertificateRequested: self token: tokenBuffer!

basicUnregister
	source Remove_ClientCertificateRequested: token! !
!WebView2.ICoreWebView2ClientCertificateRequestedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!WebView2.ICoreWebView2ClientCertificateRequestedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ClientCertificateRequestedEventHandler'
		ICoreWebView2ClientCertificateRequestedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2ClientCertificateRequestedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#clientCertificateRequested:! !
!WebView2.ICoreWebView2ClientCertificateRequestedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

