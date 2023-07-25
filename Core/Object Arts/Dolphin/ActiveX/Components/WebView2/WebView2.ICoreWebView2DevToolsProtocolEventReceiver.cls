"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2DevToolsProtocolEventReceiver'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2DevToolsProtocolEventReceiver guid: (OS.COM.IID fromString: '{b32ca51a-8371-45e9-9317-af021d080367}')!
WebView2.ICoreWebView2DevToolsProtocolEventReceiver comment: '`ICoreWebView2DevToolsProtocolEventReceiver` is a wrapper class for the COM interface ''WebView2.ICoreWebView2DevToolsProtocolEventReceiver'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(b32ca51a-8371-45e9-9317-af021d080367)
]
interface ICoreWebView2DevToolsProtocolEventReceiver : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall add_DevToolsProtocolEventReceived(
		[in]ICoreWebView2DevToolsProtocolEventReceivedEventHandler* handler,
		[out]EventRegistrationToken* token);
	[id(0x60010001)]
	HRESULT __stdcall remove_DevToolsProtocolEventReceived(
		[in]EventRegistrationToken token);
};
```
'!
!WebView2.ICoreWebView2DevToolsProtocolEventReceiver categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2DevToolsProtocolEventReceiver methodsFor!

Add_DevToolsProtocolEventReceived: handler token: token
	"Private - Invoke the add_DevToolsProtocolEventReceived() method of the COM object.

		HRESULT __stdcall add_DevToolsProtocolEventReceived(
			[in]ICoreWebView2DevToolsProtocolEventReceivedEventHandler* handler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 4 ICoreWebView2DevToolsProtocolEventReceivedEventHandler* int64*>
	^self invalidCall: _failureCode!

Remove_DevToolsProtocolEventReceived: token
	"Private - Invoke the remove_DevToolsProtocolEventReceived() method of the COM object.

		HRESULT __stdcall remove_DevToolsProtocolEventReceived(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 5 int64>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2DevToolsProtocolEventReceiver categoriesForMethods!
Add_DevToolsProtocolEventReceived:token:!**auto generated**!COM Interfaces-ICoreWebView2DevToolsProtocolEventReceiver!private! !
Remove_DevToolsProtocolEventReceived:!**auto generated**!COM Interfaces-ICoreWebView2DevToolsProtocolEventReceiver!private! !
!

!WebView2.ICoreWebView2DevToolsProtocolEventReceiver class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2DevToolsProtocolEventReceiver'
		ICoreWebView2DevToolsProtocolEventReceiver defineTemplate"

	self
		defineFunction: #Add_DevToolsProtocolEventReceived:token:
			argumentTypes: 'ICoreWebView2DevToolsProtocolEventReceivedEventHandler* sqword*';
		defineFunction: #Remove_DevToolsProtocolEventReceived:
			argumentTypes: 'sqword'
! !
!WebView2.ICoreWebView2DevToolsProtocolEventReceiver class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

