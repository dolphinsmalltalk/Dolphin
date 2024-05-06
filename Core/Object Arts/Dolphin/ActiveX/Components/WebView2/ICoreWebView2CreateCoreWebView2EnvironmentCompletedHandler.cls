"Filed out from Dolphin Smalltalk"!

ICoreWebView2CompletedHandler subclass: #ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler guid: (IID fromString: '{4e8a3389-c9d8-4bd2-b6b5-124fee6cc14d}')!

ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler comment: '`ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(4e8a3389-c9d8-4bd2-b6b5-124fee6cc14d)
]
interface ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		HRESULT errorCode,
		ICoreWebView2Environment* createdEnvironment);
};
```
'!

!ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler'
		ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler defineTemplate
	"

	self defineFunction: #Invoke:arg: argumentTypes: 'hresult ICoreWebView2Environment*'! !

!ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler class categoriesForMethods!
defineFunctions!initializing!public! !
!

