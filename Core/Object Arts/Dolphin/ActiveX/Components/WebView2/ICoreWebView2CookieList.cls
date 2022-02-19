"Filed out from Dolphin Smallalk"!

ICoreWebView2Sequence subclass: #ICoreWebView2CookieList
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2CookieList guid: (IID fromString: '{f7f6f714-5d2a-43c6-9503-346ece02d186}')!
ICoreWebView2CookieList comment: '`ICoreWebView2CookieList` is a wrapper class for the COM interface ''WebView2.ICoreWebView2CookieList'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(f7f6f714-5d2a-43c6-9503-346ece02d186)
]
interface ICoreWebView2CookieList : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall Count(
		[out, retval]unsigned int* Count);
	[id(0x60010001)]
	HRESULT __stdcall GetValueAtIndex(
		[in]unsigned int index,
		[out, retval]ICoreWebView2Cookie** cookie);
};
```
'!
!ICoreWebView2CookieList categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2CookieList methodsFor!

elementClass
	^ICoreWebView2Cookie!

GetValueAtIndex: index value: cookie
	"Private - Invoke the GetValueAtIndex() method of the COM object.

		HRESULT __stdcall GetValueAtIndex(
			[in]unsigned int index,
			[out, retval]ICoreWebView2Cookie** cookie);"

	<virtual stdcall: hresult 5 dword ICoreWebView2Cookie**>
	^self invalidCall: _failureCode! !
!ICoreWebView2CookieList categoriesForMethods!
elementClass!constants!private! !
GetValueAtIndex:value:!**auto generated**!COM Interfaces-ICoreWebView2CookieList!private! !
!

!ICoreWebView2CookieList class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2CookieList'
		ICoreWebView2CookieList defineTemplate"

	self
		defineFunction: #get_Count:
			argumentTypes: 'dword*';
		defineFunction: #GetValueAtIndex:value:
			argumentTypes: 'dword ICoreWebView2Cookie**'
! !
!ICoreWebView2CookieList class categoriesForMethods!
defineFunctions!initializing!public! !
!

