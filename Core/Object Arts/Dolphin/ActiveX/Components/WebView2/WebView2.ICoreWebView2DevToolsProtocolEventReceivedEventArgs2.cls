"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventArgs
	subclass: #'WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventArgs2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventArgs2 guid: (OS.COM.IID fromString: '{2dc4959d-1494-4393-95ba-bea4cb9ebd1b}')!

WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventArgs2 isEgressOnly: true!

WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventArgs2 comment: '`ICoreWebView2DevToolsProtocolEventReceivedEventArgs2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventArgs2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(2dc4959d-1494-4393-95ba-bea4cb9ebd1b)
]
interface ICoreWebView2DevToolsProtocolEventReceivedEventArgs2 : ICoreWebView2DevToolsProtocolEventReceivedEventArgs
 {
	[id(0x60020000), propget]
	HRESULT __stdcall sessionId(
		[out, retval]LPWSTR* sessionId);
};
```
'!

!WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventArgs2 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventArgs2 methodsFor!

get_sessionId: sessionId
	"Private - Get the value of the 'sessionId' property of the receiver.

		HRESULT __stdcall sessionId(
			[out, retval]LPWSTR* sessionId);"

	<virtual stdcall: hresult 5 lpwstr*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventArgs2 categoriesForMethods!
get_sessionId:!**auto generated**!COM Interfaces-ICoreWebView2DevToolsProtocolEventReceivedEventArgs2!private! !
!

!WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventArgs2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventArgs2'
		ICoreWebView2DevToolsProtocolEventReceivedEventArgs2 defineTemplate"

	self
		defineFunction: #get_sessionId:
			argumentTypes: 'lpwstr*'
! !

!WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventArgs2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

