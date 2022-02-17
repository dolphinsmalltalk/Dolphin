"Filed out from Dolphin Smallalk"!

IUnknown subclass: #ICoreWebView2ExecuteScriptCompletedHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2ExecuteScriptCompletedHandler guid: (IID fromString: '{49511172-cc67-4bca-9923-137112f4c4cc}')!
ICoreWebView2ExecuteScriptCompletedHandler comment: '`ICoreWebView2ExecuteScriptCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ExecuteScriptCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(49511172-cc67-4bca-9923-137112f4c4cc)
]
interface ICoreWebView2ExecuteScriptCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]HRESULT errorCode,
		[in]LPWSTR resultObjectAsJson);
};
```
'!
!ICoreWebView2ExecuteScriptCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2ExecuteScriptCompletedHandler methodsFor!

invoke: errorCode resultObjectAsJson: resultObjectAsJson
	"Invoke the Invoke() method of the COM object."

	^self Invoke: errorCode resultObjectAsJson: resultObjectAsJson asUtf16String!

Invoke: errorCode resultObjectAsJson: resultObjectAsJson
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]HRESULT errorCode,
			[in]LPWSTR resultObjectAsJson);"

	<virtual stdcall: hresult 4 hresult lpwstr>
	^self invalidCall: _failureCode! !
!ICoreWebView2ExecuteScriptCompletedHandler categoriesForMethods!
invoke:resultObjectAsJson:!**auto generated**!methods!public! !
Invoke:resultObjectAsJson:!**auto generated**!COM Interfaces-ICoreWebView2ExecuteScriptCompletedHandler!private! !
!

!ICoreWebView2ExecuteScriptCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ExecuteScriptCompletedHandler'
		ICoreWebView2ExecuteScriptCompletedHandler defineTemplate"

	self
		defineFunction: #Invoke:resultObjectAsJson:
			argumentTypes: 'hresult lpwstr'
! !
!ICoreWebView2ExecuteScriptCompletedHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

