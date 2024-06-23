"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2_17
	subclass: #'WebView2.ICoreWebView2_18'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2_18 guid: (OS.COM.IID fromString: '{7a626017-28be-49b2-b865-3ba2b3522d90}')!

WebView2.ICoreWebView2_18 isEgressOnly: true!

WebView2.ICoreWebView2_18 comment: '`ICoreWebView2_18` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_18'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(7a626017-28be-49b2-b865-3ba2b3522d90)
]
interface ICoreWebView2_18 : ICoreWebView2_17
 {
	[id(0x60120000)]
	HRESULT __stdcall add_LaunchingExternalUriScheme(
		[in]ICoreWebView2LaunchingExternalUriSchemeEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60120001)]
	HRESULT __stdcall remove_LaunchingExternalUriScheme(
		[in]EventRegistrationToken token);
};
```
'!

!WebView2.ICoreWebView2_18 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2_18 methodsFor!

Add_LaunchingExternalUriScheme: eventHandler token: token
	"Private - Invoke the add_LaunchingExternalUriScheme() method of the COM object.

		HRESULT __stdcall add_LaunchingExternalUriScheme(
			[in]ICoreWebView2LaunchingExternalUriSchemeEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 118 ICoreWebView2LaunchingExternalUriSchemeEventHandler* int64*>
	^self invalidCall: _failureCode!

Remove_LaunchingExternalUriScheme: token
	"Private - Invoke the remove_LaunchingExternalUriScheme() method of the COM object.

		HRESULT __stdcall remove_LaunchingExternalUriScheme(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 119 int64>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2_18 categoriesForMethods!
Add_LaunchingExternalUriScheme:token:!**auto generated**!COM Interfaces-ICoreWebView2_18!private! !
Remove_LaunchingExternalUriScheme:!**auto generated**!COM Interfaces-ICoreWebView2_18!private! !
!

!WebView2.ICoreWebView2_18 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_18'
		ICoreWebView2_18 defineTemplate"

	self
		defineFunction: #Add_LaunchingExternalUriScheme:token:
			argumentTypes: 'ICoreWebView2LaunchingExternalUriSchemeEventHandler* int64*';
		defineFunction: #Remove_LaunchingExternalUriScheme:
			argumentTypes: 'int64'
! !

!WebView2.ICoreWebView2_18 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

