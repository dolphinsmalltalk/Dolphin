"Filed out from Dolphin Smallalk"!

IUnknown subclass: #ICoreWebView2StateChangedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2StateChangedEventHandler guid: (IID fromString: '{81336594-7ede-4ba9-bf71-acf0a95b58dd}')!
ICoreWebView2StateChangedEventHandler comment: '`ICoreWebView2StateChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2StateChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(81336594-7ede-4ba9-bf71-acf0a95b58dd)
]
interface ICoreWebView2StateChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2DownloadOperation* sender,
		[in]IUnknown* args);
};
```
'!
!ICoreWebView2StateChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2StateChangedEventHandler methodsFor!

invoke: sender args: args
	"Invoke the Invoke() method of the COM object."

	^self Invoke: sender args: args!

Invoke: sender args: args
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2DownloadOperation* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2DownloadOperation* IUnknown*>
	^self invalidCall: _failureCode! !
!ICoreWebView2StateChangedEventHandler categoriesForMethods!
invoke:args:!**auto generated**!methods!public! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2StateChangedEventHandler!private! !
!

!ICoreWebView2StateChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2StateChangedEventHandler'
		ICoreWebView2StateChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2DownloadOperation* IUnknown*'
! !
!ICoreWebView2StateChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

