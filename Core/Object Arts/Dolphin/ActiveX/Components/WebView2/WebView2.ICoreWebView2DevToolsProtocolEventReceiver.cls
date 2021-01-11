"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2DevToolsProtocolEventReceiver'
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

add_DevToolsProtocolEventReceived: handler
	"Answer the <EventRegistrationToken> result of invoking the add_DevToolsProtocolEventReceived() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_DevToolsProtocolEventReceived: handler token: answer.
	^answer asObject!

Add_DevToolsProtocolEventReceived: handler token: token
	"Private - Invoke the add_DevToolsProtocolEventReceived() method of the COM object.

		HRESULT __stdcall add_DevToolsProtocolEventReceived(
			[in]ICoreWebView2DevToolsProtocolEventReceivedEventHandler* handler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 4 ICoreWebView2DevToolsProtocolEventReceivedEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

remove_DevToolsProtocolEventReceived: token
	"Invoke the remove_DevToolsProtocolEventReceived() method of the COM object."

	^self Remove_DevToolsProtocolEventReceived: token!

Remove_DevToolsProtocolEventReceived: token
	"Private - Invoke the remove_DevToolsProtocolEventReceived() method of the COM object.

		HRESULT __stdcall remove_DevToolsProtocolEventReceived(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 5 EventRegistrationToken>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2DevToolsProtocolEventReceiver categoriesFor: #add_DevToolsProtocolEventReceived:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2DevToolsProtocolEventReceiver categoriesFor: #Add_DevToolsProtocolEventReceived:token:!**auto generated**!COM Interfaces-ICoreWebView2DevToolsProtocolEventReceiver!private! !
!WebView2.ICoreWebView2DevToolsProtocolEventReceiver categoriesFor: #remove_DevToolsProtocolEventReceived:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2DevToolsProtocolEventReceiver categoriesFor: #Remove_DevToolsProtocolEventReceived:!**auto generated**!COM Interfaces-ICoreWebView2DevToolsProtocolEventReceiver!private! !

!WebView2.ICoreWebView2DevToolsProtocolEventReceiver class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2DevToolsProtocolEventReceiver'
		ICoreWebView2DevToolsProtocolEventReceiver defineTemplate"

	self
		defineFunction: #Add_DevToolsProtocolEventReceived:token:
			argumentTypes: 'ICoreWebView2DevToolsProtocolEventReceivedEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_DevToolsProtocolEventReceived:
			argumentTypes: 'EventRegistrationToken'
! !
!WebView2.ICoreWebView2DevToolsProtocolEventReceiver class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

