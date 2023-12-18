"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Profile6
	subclass: #'WebView2.ICoreWebView2Profile7'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2Profile7 guid: (OS.COM.IID fromString: '{7b4c7906-a1aa-4cb4-b723-db09f813d541}')!
WebView2.ICoreWebView2Profile7 isEgressOnly: true!
WebView2.ICoreWebView2Profile7 comment: '`ICoreWebView2Profile7` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Profile7'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(7b4c7906-a1aa-4cb4-b723-db09f813d541)
]
interface ICoreWebView2Profile7 : ICoreWebView2Profile6
 {
	[id(0x60070000)]
	HRESULT __stdcall AddBrowserExtension(
		[in]LPWSTR extensionFolderPath,
		[in]ICoreWebView2ProfileAddBrowserExtensionCompletedHandler* handler);
	[id(0x60070001)]
	HRESULT __stdcall GetBrowserExtensions(
		[in]ICoreWebView2ProfileGetBrowserExtensionsCompletedHandler* handler);
};
```
'!
!WebView2.ICoreWebView2Profile7 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2Profile7 methodsFor!

AddBrowserExtension: extensionFolderPath handler: handler
	"Invoke the AddBrowserExtension() method of the COM object.

		HRESULT __stdcall AddBrowserExtension(
			[in]LPWSTR extensionFolderPath,
			[in]ICoreWebView2ProfileAddBrowserExtensionCompletedHandler* handler);"

	<virtual stdcall: hresult 23 lpwstr ICoreWebView2ProfileAddBrowserExtensionCompletedHandler*>
	^self invalidCall: _failureCode!

GetBrowserExtensions: handler
	"Invoke the GetBrowserExtensions() method of the COM object.

		HRESULT __stdcall GetBrowserExtensions(
			[in]ICoreWebView2ProfileGetBrowserExtensionsCompletedHandler* handler);"

	<virtual stdcall: hresult 24 ICoreWebView2ProfileGetBrowserExtensionsCompletedHandler*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2Profile7 categoriesForMethods!
AddBrowserExtension:handler:!**auto generated**!COM Interfaces-ICoreWebView2Profile7!public! !
GetBrowserExtensions:!**auto generated**!COM Interfaces-ICoreWebView2Profile7!public! !
!

!WebView2.ICoreWebView2Profile7 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Profile7'
		ICoreWebView2Profile7 defineTemplate"

	self
		defineFunction: #AddBrowserExtension:handler:
			argumentTypes: 'lpwstr ICoreWebView2ProfileAddBrowserExtensionCompletedHandler*';
		defineFunction: #GetBrowserExtensions:
			argumentTypes: 'ICoreWebView2ProfileGetBrowserExtensionsCompletedHandler*'
! !
!WebView2.ICoreWebView2Profile7 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

