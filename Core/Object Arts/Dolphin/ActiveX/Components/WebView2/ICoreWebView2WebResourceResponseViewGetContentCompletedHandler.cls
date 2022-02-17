"Filed out from Dolphin Smallalk"!

IUnknown subclass: #ICoreWebView2WebResourceResponseViewGetContentCompletedHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2WebResourceResponseViewGetContentCompletedHandler guid: (IID fromString: '{875738e1-9fa2-40e3-8b74-2e8972dd6fe7}')!
ICoreWebView2WebResourceResponseViewGetContentCompletedHandler comment: '`ICoreWebView2WebResourceResponseViewGetContentCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2WebResourceResponseViewGetContentCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(875738e1-9fa2-40e3-8b74-2e8972dd6fe7)
]
interface ICoreWebView2WebResourceResponseViewGetContentCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]HRESULT errorCode,
		[in]IStream* Content);
};
```
'!
!ICoreWebView2WebResourceResponseViewGetContentCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2WebResourceResponseViewGetContentCompletedHandler methodsFor!

invoke: errorCode content: content
	"Invoke the Invoke() method of the COM object."

	^self Invoke: errorCode content: content!

Invoke: errorCode content: content
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]HRESULT errorCode,
			[in]IStream* Content);"

	<virtual stdcall: hresult 4 hresult IStream*>
	^self invalidCall: _failureCode! !
!ICoreWebView2WebResourceResponseViewGetContentCompletedHandler categoriesForMethods!
invoke:content:!**auto generated**!methods!public! !
Invoke:content:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceResponseViewGetContentCompletedHandler!private! !
!

!ICoreWebView2WebResourceResponseViewGetContentCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2WebResourceResponseViewGetContentCompletedHandler'
		ICoreWebView2WebResourceResponseViewGetContentCompletedHandler defineTemplate"

	self
		defineFunction: #Invoke:content:
			argumentTypes: 'hresult IStream*'
! !
!ICoreWebView2WebResourceResponseViewGetContentCompletedHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

