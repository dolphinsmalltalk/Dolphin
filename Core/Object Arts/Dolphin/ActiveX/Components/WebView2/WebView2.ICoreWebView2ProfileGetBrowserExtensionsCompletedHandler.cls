"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompletedHandler
	subclass: #'WebView2.ICoreWebView2ProfileGetBrowserExtensionsCompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2ProfileGetBrowserExtensionsCompletedHandler guid: (OS.COM.IID fromString: '{fce16a1c-f107-4601-8b75-fc4940ae25d0}')!

WebView2.ICoreWebView2ProfileGetBrowserExtensionsCompletedHandler comment: '`ICoreWebView2ProfileGetBrowserExtensionsCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ProfileGetBrowserExtensionsCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(fce16a1c-f107-4601-8b75-fc4940ae25d0)
]
interface ICoreWebView2ProfileGetBrowserExtensionsCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]HRESULT errorCode,
		[in]ICoreWebView2BrowserExtensionList* extensionList);
};
```
'!

!WebView2.ICoreWebView2ProfileGetBrowserExtensionsCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2ProfileGetBrowserExtensionsCompletedHandler methodsFor!

Invoke: errorCode arg: extensionList
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]HRESULT errorCode,
			[in]ICoreWebView2BrowserExtensionList* extensionList);"

	<virtual stdcall: hresult 4 hresult ICoreWebView2BrowserExtensionList*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2ProfileGetBrowserExtensionsCompletedHandler categoriesForMethods!
Invoke:arg:!COM Interfaces-ICoreWebView2ProfileGetBrowserExtensionsCompletedHandler!public! !
!

!WebView2.ICoreWebView2ProfileGetBrowserExtensionsCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ProfileGetBrowserExtensionsCompletedHandler'
		ICoreWebView2ProfileGetBrowserExtensionsCompletedHandler defineTemplate"

	self
		defineFunction: #Invoke:arg:
			argumentTypes: 'hresult ICoreWebView2BrowserExtensionList*'
! !

!WebView2.ICoreWebView2ProfileGetBrowserExtensionsCompletedHandler class categoriesForMethods!
defineFunctions!initializing!public!template definition! !
!

