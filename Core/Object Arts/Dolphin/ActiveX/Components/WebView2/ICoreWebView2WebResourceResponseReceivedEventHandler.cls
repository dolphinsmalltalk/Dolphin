"Filed out from Dolphin Smallalk"!

IUnknown subclass: #ICoreWebView2WebResourceResponseReceivedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2WebResourceResponseReceivedEventHandler guid: (IID fromString: '{7de9898a-24f5-40c3-a2de-d4f458e69828}')!
ICoreWebView2WebResourceResponseReceivedEventHandler comment: '`ICoreWebView2WebResourceResponseReceivedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2WebResourceResponseReceivedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(7de9898a-24f5-40c3-a2de-d4f458e69828)
]
interface ICoreWebView2WebResourceResponseReceivedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2WebResourceResponseReceivedEventArgs* args);
};
```
'!
!ICoreWebView2WebResourceResponseReceivedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2WebResourceResponseReceivedEventHandler methodsFor!

invoke: sender args: args
	"Invoke the Invoke() method of the COM object."

	^self Invoke: sender args: args!

Invoke: sender args: args
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]ICoreWebView2WebResourceResponseReceivedEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* ICoreWebView2WebResourceResponseReceivedEventArgs*>
	^self invalidCall: _failureCode! !
!ICoreWebView2WebResourceResponseReceivedEventHandler categoriesForMethods!
invoke:args:!**auto generated**!methods!public! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceResponseReceivedEventHandler!private! !
!

!ICoreWebView2WebResourceResponseReceivedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2WebResourceResponseReceivedEventHandler'
		ICoreWebView2WebResourceResponseReceivedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2WebResourceResponseReceivedEventArgs*'
! !
!ICoreWebView2WebResourceResponseReceivedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

