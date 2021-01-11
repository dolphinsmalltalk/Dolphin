"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventHandler guid: (OS.COM.IID fromString: '{e2fda4be-5456-406c-a261-3d452138362c}')!
WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventHandler comment: '`ICoreWebView2DevToolsProtocolEventReceivedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(e2fda4be-5456-406c-a261-3d452138362c)
]
interface ICoreWebView2DevToolsProtocolEventReceivedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2DevToolsProtocolEventReceivedEventArgs* args);
};
```
'!
!WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventHandler methodsFor!

invoke: sender args: args
	"Invoke the Invoke() method of the COM object."

	^self Invoke: sender args: args!

Invoke: sender args: args
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]ICoreWebView2DevToolsProtocolEventReceivedEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* ICoreWebView2DevToolsProtocolEventReceivedEventArgs*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventHandler categoriesFor: #invoke:args:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventHandler categoriesFor: #Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2DevToolsProtocolEventReceivedEventHandler!private! !

!WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventHandler'
		ICoreWebView2DevToolsProtocolEventReceivedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2DevToolsProtocolEventReceivedEventArgs*'
! !
!WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventHandler class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

