"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler guid: (OS.COM.IID fromString: '{4e8a3389-c9d8-4bd2-b6b5-124fee6cc14d}')!
WebView2.ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler comment: '`ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!WebView2.ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler methodsFor!

invoke: errorCode createdEnvironment: createdEnvironment
	"Invoke the Invoke() method of the COM object."

	^self Invoke: errorCode createdEnvironment: createdEnvironment!

Invoke: errorCode createdEnvironment: createdEnvironment
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			HRESULT errorCode,
			ICoreWebView2Environment* createdEnvironment);"

	<virtual stdcall: hresult 4 hresult ICoreWebView2Environment*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler categoriesFor: #invoke:createdEnvironment:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler categoriesFor: #Invoke:createdEnvironment:!**auto generated**!COM Interfaces-ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler!private! !

!WebView2.ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler'
		ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler defineTemplate"

	self
		defineFunction: #Invoke:createdEnvironment:
			argumentTypes: 'hresult ICoreWebView2Environment*'
! !
!WebView2.ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

