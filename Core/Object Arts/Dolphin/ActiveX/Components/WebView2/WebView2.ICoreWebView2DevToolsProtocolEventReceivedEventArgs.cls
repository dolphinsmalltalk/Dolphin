"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventArgs
	subclass: #'WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventArgs guid: (OS.COM.IID fromString: '{653c2959-bb3a-4377-8632-b58ada4e66c4}')!
WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventArgs isEgressOnly: true!
WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventArgs comment: '`ICoreWebView2DevToolsProtocolEventReceivedEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(653c2959-bb3a-4377-8632-b58ada4e66c4)
]
interface ICoreWebView2DevToolsProtocolEventReceivedEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall ParameterObjectAsJson(
		[out, retval]LPWSTR* ParameterObjectAsJson);
};
```
'!
!WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventArgs methodsFor!

get_ParameterObjectAsJson: parameterObjectAsJson
	"Private - Get the value of the 'ParameterObjectAsJson' property of the receiver.

		HRESULT __stdcall ParameterObjectAsJson(
			[out, retval]LPWSTR* ParameterObjectAsJson);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

parameterObjectAsJson
	"Answer the <lpwstr> value of the 'ParameterObjectAsJson' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_ParameterObjectAsJson: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer! !
!WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventArgs categoriesForMethods!
get_ParameterObjectAsJson:!**auto generated**!COM Interfaces-ICoreWebView2DevToolsProtocolEventReceivedEventArgs!private! !
parameterObjectAsJson!properties!public! !
!

!WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventArgs'
		ICoreWebView2DevToolsProtocolEventReceivedEventArgs defineTemplate"

	self
		defineFunction: #get_ParameterObjectAsJson:
			argumentTypes: 'lpwstr*'
!

latestDerivation
	^##(super latestDerivation)! !
!WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
latestDerivation!enquiries!public! !
!

