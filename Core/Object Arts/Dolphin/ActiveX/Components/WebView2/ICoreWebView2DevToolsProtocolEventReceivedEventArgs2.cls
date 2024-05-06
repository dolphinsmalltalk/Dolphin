"Filed out from Dolphin Smalltalk"!

ICoreWebView2DevToolsProtocolEventReceivedEventArgs subclass: #ICoreWebView2DevToolsProtocolEventReceivedEventArgs2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ICoreWebView2DevToolsProtocolEventReceivedEventArgs2 guid: (IID fromString: '{2dc4959d-1494-4393-95ba-bea4cb9ebd1b}')!

ICoreWebView2DevToolsProtocolEventReceivedEventArgs2 comment: '`ICoreWebView2DevToolsProtocolEventReceivedEventArgs2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventArgs2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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

!ICoreWebView2DevToolsProtocolEventReceivedEventArgs2 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!ICoreWebView2DevToolsProtocolEventReceivedEventArgs2 methodsFor!

get_sessionId: sessionId
	"Private - Get the value of the 'sessionId' property of the receiver.

		HRESULT __stdcall sessionId(
			[out, retval]LPWSTR* sessionId);"

	<virtual stdcall: hresult 5 lpwstr*>
	^self invalidCall: _failureCode!

sessionId
	"Answer the <lpwstr> value of the 'sessionId' property of the receiver."

	| answer |
	answer := StructurePointer newNull: COMTaskMemory elementClass: Utf16String.
	self get_sessionId: answer.
	^answer asObject! !

!ICoreWebView2DevToolsProtocolEventReceivedEventArgs2 categoriesForMethods!
get_sessionId:!**auto generated**!COM Interfaces-ICoreWebView2DevToolsProtocolEventReceivedEventArgs2!private! !
sessionId!**auto generated**!properties!public! !
!

!ICoreWebView2DevToolsProtocolEventReceivedEventArgs2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventArgs2'
		ICoreWebView2DevToolsProtocolEventReceivedEventArgs2 defineTemplate"

	self
		defineFunction: #get_sessionId:
			argumentTypes: 'lpwstr*'
! !

!ICoreWebView2DevToolsProtocolEventReceivedEventArgs2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

