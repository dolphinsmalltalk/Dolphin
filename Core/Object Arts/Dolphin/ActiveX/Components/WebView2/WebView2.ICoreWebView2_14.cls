"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2_13
	subclass: #'WebView2.ICoreWebView2_14'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2_14 guid: (OS.COM.IID fromString: '{6daa4f10-4a90-4753-8898-77c5df534165}')!
WebView2.ICoreWebView2_14 comment: '`ICoreWebView2_14` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_14'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(6daa4f10-4a90-4753-8898-77c5df534165)
]
interface ICoreWebView2_14 : ICoreWebView2_13
 {
	[id(0x600e0000)]
	HRESULT __stdcall add_ServerCertificateErrorDetected(
		[in]ICoreWebView2ServerCertificateErrorDetectedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x600e0001)]
	HRESULT __stdcall remove_ServerCertificateErrorDetected(
		[in]EventRegistrationToken token);
	[id(0x600e0002)]
	HRESULT __stdcall ClearServerCertificateErrorActions(
		[in]ICoreWebView2ClearServerCertificateErrorActionsCompletedHandler* handler);
};
```
'!
!WebView2.ICoreWebView2_14 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2_14 methodsFor!

Add_ServerCertificateErrorDetected: eventHandler token: token
	"Private - Invoke the add_ServerCertificateErrorDetected() method of the COM object.

		HRESULT __stdcall add_ServerCertificateErrorDetected(
			[in]ICoreWebView2ServerCertificateErrorDetectedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 107 ICoreWebView2ServerCertificateErrorDetectedEventHandler* int64*>
	^self invalidCall: _failureCode!

ClearServerCertificateErrorActions: handler
	"Private - Invoke the ClearServerCertificateErrorActions() method of the COM object.

		HRESULT __stdcall ClearServerCertificateErrorActions(
			[in]ICoreWebView2ClearServerCertificateErrorActionsCompletedHandler* handler);"

	<virtual stdcall: hresult 109 ICoreWebView2ClearServerCertificateErrorActionsCompletedHandler*>
	^self invalidCall: _failureCode!

Remove_ServerCertificateErrorDetected: token
	"Private - Invoke the remove_ServerCertificateErrorDetected() method of the COM object.

		HRESULT __stdcall remove_ServerCertificateErrorDetected(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 108 int64>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2_14 categoriesForMethods!
Add_ServerCertificateErrorDetected:token:!**auto generated**!COM Interfaces-ICoreWebView2_14!private! !
ClearServerCertificateErrorActions:!**auto generated**!COM Interfaces-ICoreWebView2_14!private! !
Remove_ServerCertificateErrorDetected:!**auto generated**!COM Interfaces-ICoreWebView2_14!private! !
!

!WebView2.ICoreWebView2_14 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_14'
		ICoreWebView2_14 defineTemplate"

	self
		defineFunction: #Add_ServerCertificateErrorDetected:token:
			argumentTypes: 'ICoreWebView2ServerCertificateErrorDetectedEventHandler* sqword*';
		defineFunction: #Remove_ServerCertificateErrorDetected:
			argumentTypes: 'sqword';
		defineFunction: #ClearServerCertificateErrorActions:
			argumentTypes: 'ICoreWebView2ClearServerCertificateErrorActionsCompletedHandler*'
! !
!WebView2.ICoreWebView2_14 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

