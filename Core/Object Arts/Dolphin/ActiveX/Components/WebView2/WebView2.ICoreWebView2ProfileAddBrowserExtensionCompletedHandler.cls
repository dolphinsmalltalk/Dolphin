"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompletedHandler
	subclass: #'WebView2.ICoreWebView2ProfileAddBrowserExtensionCompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2ProfileAddBrowserExtensionCompletedHandler guid: (OS.COM.IID fromString: '{df1aab27-82b9-4ab6-aae8-017a49398c14}')!

WebView2.ICoreWebView2ProfileAddBrowserExtensionCompletedHandler comment: '`ICoreWebView2ProfileAddBrowserExtensionCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ProfileAddBrowserExtensionCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(df1aab27-82b9-4ab6-aae8-017a49398c14)
]
interface ICoreWebView2ProfileAddBrowserExtensionCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]HRESULT errorCode,
		[in]ICoreWebView2BrowserExtension* extension);
};
```
'!

!WebView2.ICoreWebView2ProfileAddBrowserExtensionCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2ProfileAddBrowserExtensionCompletedHandler methodsFor!

Invoke: errorCode arg: extension
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]HRESULT errorCode,
			[in]ICoreWebView2BrowserExtension* extension);"

	<virtual stdcall: hresult 4 hresult ICoreWebView2BrowserExtension*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2ProfileAddBrowserExtensionCompletedHandler categoriesForMethods!
Invoke:arg:!**auto generated**!COM Interfaces-ICoreWebView2ProfileAddBrowserExtensionCompletedHandler!public! !
!

!WebView2.ICoreWebView2ProfileAddBrowserExtensionCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ProfileAddBrowserExtensionCompletedHandler'
		ICoreWebView2ProfileAddBrowserExtensionCompletedHandler defineTemplate"

	self
		defineFunction: #Invoke:arg:
			argumentTypes: 'hresult ICoreWebView2BrowserExtension*'
! !

!WebView2.ICoreWebView2ProfileAddBrowserExtensionCompletedHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

