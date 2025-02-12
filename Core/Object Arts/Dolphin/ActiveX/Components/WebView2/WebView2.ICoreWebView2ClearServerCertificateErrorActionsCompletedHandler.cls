﻿"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompletedHandler
	subclass: #'WebView2.ICoreWebView2ClearServerCertificateErrorActionsCompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2ClearServerCertificateErrorActionsCompletedHandler guid: (OS.COM.IID fromString: '{3b40aac6-acfe-4ffd-8211-f607b96e2d5b}')!

WebView2.ICoreWebView2ClearServerCertificateErrorActionsCompletedHandler comment: '`ICoreWebView2ClearServerCertificateErrorActionsCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ClearServerCertificateErrorActionsCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(3b40aac6-acfe-4ffd-8211-f607b96e2d5b)
]
interface ICoreWebView2ClearServerCertificateErrorActionsCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]HRESULT errorCode);
};
```
'!

!WebView2.ICoreWebView2ClearServerCertificateErrorActionsCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2ClearServerCertificateErrorActionsCompletedHandler methodsFor!

Invoke: errorCode
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]HRESULT errorCode);"

	<virtual stdcall: hresult 4 hresult>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2ClearServerCertificateErrorActionsCompletedHandler categoriesForMethods!
Invoke:!**auto generated**!COM Interfaces-ICoreWebView2ClearServerCertificateErrorActionsCompletedHandler!public! !
!

!WebView2.ICoreWebView2ClearServerCertificateErrorActionsCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ClearServerCertificateErrorActionsCompletedHandler'
		ICoreWebView2ClearServerCertificateErrorActionsCompletedHandler defineTemplate"

	self
		defineFunction: #Invoke:
			argumentTypes: 'hresult'
! !

!WebView2.ICoreWebView2ClearServerCertificateErrorActionsCompletedHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

