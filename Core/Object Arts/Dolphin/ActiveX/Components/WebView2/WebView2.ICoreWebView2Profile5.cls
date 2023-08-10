"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Profile4
	subclass: #'WebView2.ICoreWebView2Profile5'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2Profile5 guid: (OS.COM.IID fromString: '{2ee5b76e-6e80-4df2-bcd3-d4ec3340a01b}')!
WebView2.ICoreWebView2Profile5 comment: '`ICoreWebView2Profile5` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Profile5'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(2ee5b76e-6e80-4df2-bcd3-d4ec3340a01b)
]
interface ICoreWebView2Profile5 : ICoreWebView2Profile4
 {
	[id(0x60050000), propget]
	HRESULT __stdcall CookieManager(
		[out, retval]ICoreWebView2CookieManager** CookieManager);
};
```
'!
!WebView2.ICoreWebView2Profile5 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2Profile5 methodsFor!

get_CookieManager: cookieManager
	"Private - Get the value of the 'CookieManager' property of the receiver.

		HRESULT __stdcall CookieManager(
			[out, retval]ICoreWebView2CookieManager** CookieManager);"

	<virtual stdcall: hresult 18 ICoreWebView2CookieManager**>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2Profile5 categoriesForMethods!
get_CookieManager:!**auto generated**!COM Interfaces-ICoreWebView2Profile5!private! !
!

!WebView2.ICoreWebView2Profile5 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Profile5'
		ICoreWebView2Profile5 defineTemplate"

	self
		defineFunction: #get_CookieManager:
			argumentTypes: 'ICoreWebView2CookieManager**'
! !
!WebView2.ICoreWebView2Profile5 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

