﻿"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2_4
	subclass: #'WebView2.ICoreWebView2_5'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2_5 guid: (OS.COM.IID fromString: '{bedb11b8-d63c-11eb-b8bc-0242ac130003}')!

WebView2.ICoreWebView2_5 isEgressOnly: true!

WebView2.ICoreWebView2_5 comment: '`ICoreWebView2_5` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_5'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(bedb11b8-d63c-11eb-b8bc-0242ac130003)
]
interface ICoreWebView2_5 : ICoreWebView2_4
 {
	[id(0x60050000)]
	HRESULT __stdcall add_ClientCertificateRequested(
		[in]ICoreWebView2ClientCertificateRequestedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60050001)]
	HRESULT __stdcall remove_ClientCertificateRequested(
		[in]EventRegistrationToken token);
};
```
'!

!WebView2.ICoreWebView2_5 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2_5 methodsFor!

Add_ClientCertificateRequested: eventHandler token: token
	"Private - Invoke the add_ClientCertificateRequested() method of the COM object.

		HRESULT __stdcall add_ClientCertificateRequested(
			[in]ICoreWebView2ClientCertificateRequestedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 78 ICoreWebView2ClientCertificateRequestedEventHandler* int64*>
	^self invalidCall: _failureCode!

Remove_ClientCertificateRequested: token
	"Private - Invoke the remove_ClientCertificateRequested() method of the COM object.

		HRESULT __stdcall remove_ClientCertificateRequested(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 79 int64>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2_5 categoriesForMethods!
Add_ClientCertificateRequested:token:!**auto generated**!COM Interfaces-ICoreWebView2_5!private! !
Remove_ClientCertificateRequested:!**auto generated**!COM Interfaces-ICoreWebView2_5!private! !
!

!WebView2.ICoreWebView2_5 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_5'
		ICoreWebView2_5 defineTemplate"

	self
		defineFunction: #Add_ClientCertificateRequested:token:
			argumentTypes: 'ICoreWebView2ClientCertificateRequestedEventHandler* sqword*';
		defineFunction: #Remove_ClientCertificateRequested:
			argumentTypes: 'sqword'
! !

!WebView2.ICoreWebView2_5 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

