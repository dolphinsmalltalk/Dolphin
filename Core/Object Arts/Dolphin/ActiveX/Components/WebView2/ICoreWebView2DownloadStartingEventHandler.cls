"Filed out from Dolphin Smallalk"!

IUnknown subclass: #ICoreWebView2DownloadStartingEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2DownloadStartingEventHandler guid: (IID fromString: '{efedc989-c396-41ca-83f7-07f845a55724}')!
ICoreWebView2DownloadStartingEventHandler comment: '`ICoreWebView2DownloadStartingEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2DownloadStartingEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(efedc989-c396-41ca-83f7-07f845a55724)
]
interface ICoreWebView2DownloadStartingEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2DownloadStartingEventArgs* args);
};
```
'!
!ICoreWebView2DownloadStartingEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2DownloadStartingEventHandler methodsFor!

invoke: sender args: args
	"Invoke the Invoke() method of the COM object."

	^self Invoke: sender args: args!

Invoke: sender args: args
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]ICoreWebView2DownloadStartingEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* ICoreWebView2DownloadStartingEventArgs*>
	^self invalidCall: _failureCode! !
!ICoreWebView2DownloadStartingEventHandler categoriesForMethods!
invoke:args:!**auto generated**!methods!public! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2DownloadStartingEventHandler!private! !
!

!ICoreWebView2DownloadStartingEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2DownloadStartingEventHandler'
		ICoreWebView2DownloadStartingEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2DownloadStartingEventArgs*'
! !
!ICoreWebView2DownloadStartingEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

