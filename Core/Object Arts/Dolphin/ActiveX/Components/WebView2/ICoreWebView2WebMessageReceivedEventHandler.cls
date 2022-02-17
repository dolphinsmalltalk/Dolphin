"Filed out from Dolphin Smallalk"!

IUnknown subclass: #ICoreWebView2WebMessageReceivedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2WebMessageReceivedEventHandler guid: (IID fromString: '{57213f19-00e6-49fa-8e07-898ea01ecbd2}')!
ICoreWebView2WebMessageReceivedEventHandler comment: '`ICoreWebView2WebMessageReceivedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2WebMessageReceivedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(57213f19-00e6-49fa-8e07-898ea01ecbd2)
]
interface ICoreWebView2WebMessageReceivedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2WebMessageReceivedEventArgs* args);
};
```
'!
!ICoreWebView2WebMessageReceivedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2WebMessageReceivedEventHandler methodsFor!

invoke: sender args: args
	"Invoke the Invoke() method of the COM object."

	^self Invoke: sender args: args!

Invoke: sender args: args
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]ICoreWebView2WebMessageReceivedEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* ICoreWebView2WebMessageReceivedEventArgs*>
	^self invalidCall: _failureCode! !
!ICoreWebView2WebMessageReceivedEventHandler categoriesForMethods!
invoke:args:!**auto generated**!methods!public! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2WebMessageReceivedEventHandler!private! !
!

!ICoreWebView2WebMessageReceivedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2WebMessageReceivedEventHandler'
		ICoreWebView2WebMessageReceivedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2WebMessageReceivedEventArgs*'
! !
!ICoreWebView2WebMessageReceivedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

