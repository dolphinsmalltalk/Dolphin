"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2_9 subclass: #'WebView2.ICoreWebView2_10'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2_10 guid: (OS.COM.IID fromString: '{b1690564-6f5a-4983-8e48-31d1143fecdb}')!
WebView2.ICoreWebView2_10 comment: '`ICoreWebView2_10` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_10'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(b1690564-6f5a-4983-8e48-31d1143fecdb)
]
interface ICoreWebView2_10 : ICoreWebView2_9
 {
	[id(0x600a0000)]
	HRESULT __stdcall add_BasicAuthenticationRequested(
		[in]ICoreWebView2BasicAuthenticationRequestedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x600a0001)]
	HRESULT __stdcall remove_BasicAuthenticationRequested(
		[in]EventRegistrationToken token);
};
```
'!
!WebView2.ICoreWebView2_10 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2_10 methodsFor!

Add_BasicAuthenticationRequested: eventHandler token: token
	"Private - Invoke the add_BasicAuthenticationRequested() method of the COM object.

		HRESULT __stdcall add_BasicAuthenticationRequested(
			[in]ICoreWebView2BasicAuthenticationRequestedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 98 ICoreWebView2BasicAuthenticationRequestedEventHandler* sqword*>
	^self invalidCall: _failureCode!

Remove_BasicAuthenticationRequested: token
	"Private - Invoke the remove_BasicAuthenticationRequested() method of the COM object.

		HRESULT __stdcall remove_BasicAuthenticationRequested(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 99 sqword>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2_10 categoriesForMethods!
Add_BasicAuthenticationRequested:token:!**auto generated**!COM Interfaces-ICoreWebView2_10!private! !
Remove_BasicAuthenticationRequested:!**auto generated**!COM Interfaces-ICoreWebView2_10!private! !
!

!WebView2.ICoreWebView2_10 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_10'
		ICoreWebView2_10 defineTemplate"

	self
		defineFunction: #Add_BasicAuthenticationRequested:token:
			argumentTypes: 'ICoreWebView2BasicAuthenticationRequestedEventHandler* sqword*';
		defineFunction: #Remove_BasicAuthenticationRequested:
			argumentTypes: 'sqword'
! !
!WebView2.ICoreWebView2_10 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

