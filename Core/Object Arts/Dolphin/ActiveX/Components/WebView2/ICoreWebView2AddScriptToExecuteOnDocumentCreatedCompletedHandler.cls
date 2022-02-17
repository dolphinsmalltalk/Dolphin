"Filed out from Dolphin Smallalk"!

IUnknown subclass: #ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler guid: (IID fromString: '{b99369f3-9b11-47b5-bc6f-8e7895fcea17}')!
ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler comment: '`ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(b99369f3-9b11-47b5-bc6f-8e7895fcea17)
]
interface ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]HRESULT errorCode,
		[in]LPWSTR id);
};
```
'!
!ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler methodsFor!

invoke: errorCode id: id
	"Invoke the Invoke() method of the COM object."

	^self Invoke: errorCode id: id asUtf16String!

Invoke: errorCode id: id
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]HRESULT errorCode,
			[in]LPWSTR id);"

	<virtual stdcall: hresult 4 hresult lpwstr>
	^self invalidCall: _failureCode! !
!ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler categoriesForMethods!
invoke:id:!**auto generated**!methods!public! !
Invoke:id:!**auto generated**!COM Interfaces-ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler!private! !
!

!ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler'
		ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler defineTemplate"

	self
		defineFunction: #Invoke:id:
			argumentTypes: 'hresult lpwstr'
! !
!ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

