"Filed out from Dolphin Smallalk"!

IUnknown subclass: #ICoreWebView2BytesReceivedChangedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2BytesReceivedChangedEventHandler guid: (IID fromString: '{828e8ab6-d94c-4264-9cef-5217170d6251}')!
ICoreWebView2BytesReceivedChangedEventHandler comment: '`ICoreWebView2BytesReceivedChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2BytesReceivedChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(828e8ab6-d94c-4264-9cef-5217170d6251)
]
interface ICoreWebView2BytesReceivedChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2DownloadOperation* sender,
		[in]IUnknown* args);
};
```
'!
!ICoreWebView2BytesReceivedChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2BytesReceivedChangedEventHandler methodsFor!

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
!ICoreWebView2BytesReceivedChangedEventHandler categoriesForMethods!
invoke:args:!**auto generated**!methods!public! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2BytesReceivedChangedEventHandler!private! !
!

!ICoreWebView2BytesReceivedChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2BytesReceivedChangedEventHandler'
		ICoreWebView2BytesReceivedChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2DownloadOperation* IUnknown*'
! !
!ICoreWebView2BytesReceivedChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

