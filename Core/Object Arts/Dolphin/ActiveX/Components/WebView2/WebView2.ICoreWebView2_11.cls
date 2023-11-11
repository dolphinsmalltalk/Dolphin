"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2_10
	subclass: #'WebView2.ICoreWebView2_11'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2_11 guid: (OS.COM.IID fromString: '{0be78e56-c193-4051-b943-23b460c08bdb}')!
WebView2.ICoreWebView2_11 isEgressOnly: true!
WebView2.ICoreWebView2_11 comment: '`ICoreWebView2_11` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_11'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(0be78e56-c193-4051-b943-23b460c08bdb)
]
interface ICoreWebView2_11 : ICoreWebView2_10
 {
	[id(0x600b0000)]
	HRESULT __stdcall CallDevToolsProtocolMethodForSession(
		[in]LPWSTR sessionId,
		[in]LPWSTR methodName,
		[in]LPWSTR parametersAsJson,
		[in]ICoreWebView2CallDevToolsProtocolMethodCompletedHandler* handler);
	[id(0x600b0001)]
	HRESULT __stdcall add_ContextMenuRequested(
		[in]ICoreWebView2ContextMenuRequestedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x600b0002)]
	HRESULT __stdcall remove_ContextMenuRequested(
		[in]EventRegistrationToken token);
};
```
'!
!WebView2.ICoreWebView2_11 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2_11 methodsFor!

Add_ContextMenuRequested: eventHandler token: token
	"Private - Invoke the add_ContextMenuRequested() method of the COM object.

		HRESULT __stdcall add_ContextMenuRequested(
			[in]ICoreWebView2ContextMenuRequestedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 101 ICoreWebView2ContextMenuRequestedEventHandler* int64*>
	^self invalidCall: _failureCode!

CallDevToolsProtocolMethodForSession: sessionId methodName: methodName parametersAsJson: parametersAsJson handler: handler
	"Private - Invoke the CallDevToolsProtocolMethodForSession() method of the COM object.

		HRESULT __stdcall CallDevToolsProtocolMethodForSession(
			[in]LPWSTR sessionId,
			[in]LPWSTR methodName,
			[in]LPWSTR parametersAsJson,
			[in]ICoreWebView2CallDevToolsProtocolMethodCompletedHandler* handler);"

	<virtual stdcall: hresult 100 lpwstr lpwstr lpwstr ICoreWebView2CallDevToolsProtocolMethodCompletedHandler*>
	^self invalidCall: _failureCode!

Remove_ContextMenuRequested: token
	"Private - Invoke the remove_ContextMenuRequested() method of the COM object.

		HRESULT __stdcall remove_ContextMenuRequested(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 102 int64>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2_11 categoriesForMethods!
Add_ContextMenuRequested:token:!**auto generated**!COM Interfaces-ICoreWebView2_11!private! !
CallDevToolsProtocolMethodForSession:methodName:parametersAsJson:handler:!**auto generated**!COM Interfaces-ICoreWebView2_11!private! !
Remove_ContextMenuRequested:!**auto generated**!COM Interfaces-ICoreWebView2_11!private! !
!

!WebView2.ICoreWebView2_11 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_11'
		ICoreWebView2_11 defineTemplate"

	self
		defineFunction: #CallDevToolsProtocolMethodForSession:methodName:parametersAsJson:handler:
			argumentTypes: 'lpwstr lpwstr lpwstr ICoreWebView2CallDevToolsProtocolMethodCompletedHandler*';
		defineFunction: #Add_ContextMenuRequested:token:
			argumentTypes: 'ICoreWebView2ContextMenuRequestedEventHandler* sqword*';
		defineFunction: #Remove_ContextMenuRequested:
			argumentTypes: 'sqword'
! !
!WebView2.ICoreWebView2_11 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

