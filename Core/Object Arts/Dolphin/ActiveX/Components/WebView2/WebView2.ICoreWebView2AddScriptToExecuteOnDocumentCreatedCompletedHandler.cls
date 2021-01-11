"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler guid: (OS.COM.IID fromString: '{b99369f3-9b11-47b5-bc6f-8e7895fcea17}')!
WebView2.ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler comment: '`ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!WebView2.ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler methodsFor!

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
!WebView2.ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler categoriesFor: #invoke:id:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler categoriesFor: #Invoke:id:!**auto generated**!COM Interfaces-ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler!private! !

!WebView2.ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler'
		ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler defineTemplate"

	self
		defineFunction: #Invoke:id:
			argumentTypes: 'hresult lpwstr'
! !
!WebView2.ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

