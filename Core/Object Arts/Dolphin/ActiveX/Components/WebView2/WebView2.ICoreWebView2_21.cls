"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2_20
	subclass: #'WebView2.ICoreWebView2_21'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2_21 guid: (OS.COM.IID fromString: '{c4980dea-587b-43b9-8143-3ef3bf552d95}')!

WebView2.ICoreWebView2_21 comment: '`ICoreWebView2_21` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_21'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(c4980dea-587b-43b9-8143-3ef3bf552d95)
]
interface ICoreWebView2_21 : ICoreWebView2_20
 {
	[id(0x60150000)]
	HRESULT __stdcall ExecuteScriptWithResult(
		[in]LPWSTR javaScript,
		[in]ICoreWebView2ExecuteScriptWithResultCompletedHandler* handler);
};
```
'!

!WebView2.ICoreWebView2_21 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2_21 methodsFor!

ExecuteScriptWithResult: javaScript handler: handler
	"Private - Invoke the ExecuteScriptWithResult() method of the COM object.

		HRESULT __stdcall ExecuteScriptWithResult(
			[in]LPWSTR javaScript,
			[in]ICoreWebView2ExecuteScriptWithResultCompletedHandler* handler);"

	<virtual stdcall: hresult 123 lpwstr ICoreWebView2ExecuteScriptWithResultCompletedHandler*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2_21 categoriesForMethods!
ExecuteScriptWithResult:handler:!**auto generated**!COM Interfaces-ICoreWebView2_21!private! !
!

!WebView2.ICoreWebView2_21 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_21'
		ICoreWebView2_21 defineTemplate"

	self
		defineFunction: #ExecuteScriptWithResult:handler:
			argumentTypes: 'lpwstr ICoreWebView2ExecuteScriptWithResultCompletedHandler*'
! !

!WebView2.ICoreWebView2_21 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

