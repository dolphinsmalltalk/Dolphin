"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Environment
	subclass: #'WebView2.ICoreWebView2Environment2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2Environment2 guid: (OS.COM.IID fromString: '{41f3632b-5ef4-404f-ad82-2d606c5a9a21}')!
WebView2.ICoreWebView2Environment2 comment: '`ICoreWebView2Environment2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Environment2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(41f3632b-5ef4-404f-ad82-2d606c5a9a21)
]
interface ICoreWebView2Environment2 : ICoreWebView2Environment
 {
	[id(0x60020000)]
	HRESULT __stdcall CreateWebResourceRequest(
		[in]LPWSTR uri,
		[in]LPWSTR Method,
		[in]IStream* postData,
		[in]LPWSTR Headers,
		[out, retval]ICoreWebView2WebResourceRequest** Request);
};
```
'!
!WebView2.ICoreWebView2Environment2 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2Environment2 methodsFor!

CreateWebResourceRequest: uri method: method postData: postData headers: headers request: request
	"Private - Invoke the CreateWebResourceRequest() method of the COM object.

		HRESULT __stdcall CreateWebResourceRequest(
			[in]LPWSTR uri,
			[in]LPWSTR Method,
			[in]IStream* postData,
			[in]LPWSTR Headers,
			[out, retval]ICoreWebView2WebResourceRequest** Request);"

	<virtual stdcall: hresult 9 lpwstr lpwstr IStream* lpwstr ICoreWebView2WebResourceRequest**>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2Environment2 categoriesForMethods!
CreateWebResourceRequest:method:postData:headers:request:!**auto generated**!COM Interfaces-ICoreWebView2Environment2!private! !
!

!WebView2.ICoreWebView2Environment2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Environment2'
		ICoreWebView2Environment2 defineTemplate"

	self
		defineFunction: #CreateWebResourceRequest:method:postData:headers:request:
			argumentTypes: 'lpwstr lpwstr IStream* lpwstr ICoreWebView2WebResourceRequest**'
! !
!WebView2.ICoreWebView2Environment2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

