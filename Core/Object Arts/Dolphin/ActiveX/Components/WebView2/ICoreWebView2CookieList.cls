"Filed out from Dolphin Smallalk"!

IUnknown subclass: #ICoreWebView2CookieList
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
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

count
	"Answer the <dword> value of the 'Count' property of the receiver."

	| answer |
	answer := DWORD new.
	self get_Count: answer.
	^answer asObject!

get_Count: count
	"Private - Get the value of the 'Count' property of the receiver.

		HRESULT __stdcall Count(
			[out, retval]unsigned int* Count);"

	<virtual stdcall: hresult 4 dword*>
	^self invalidCall: _failureCode!

getValueAtIndex: index
	"Answer the <ICoreWebView2Cookie> result of invoking the GetValueAtIndex() method of the COM object."

	| answer |
	answer := ICoreWebView2Cookie newPointer.
	self GetValueAtIndex: index cookie: answer.
	^answer asObject!

GetValueAtIndex: index cookie: cookie
	"Private - Invoke the GetValueAtIndex() method of the COM object.

		HRESULT __stdcall GetValueAtIndex(
			[in]unsigned int index,
			[out, retval]ICoreWebView2Cookie** cookie);"

	<virtual stdcall: hresult 5 dword ICoreWebView2Cookie**>
	^self invalidCall: _failureCode! !
!ICoreWebView2CookieList categoriesForMethods!
count!**auto generated**!properties!public! !
get_Count:!**auto generated**!COM Interfaces-ICoreWebView2CookieList!private! !
getValueAtIndex:!**auto generated**!methods!public! !
GetValueAtIndex:cookie:!**auto generated**!COM Interfaces-ICoreWebView2CookieList!private! !
!

!ICoreWebView2CookieList class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2CookieList'
		ICoreWebView2CookieList defineTemplate"

	self
		defineFunction: #get_Count:
			argumentTypes: 'dword*';
		defineFunction: #GetValueAtIndex:cookie:
			argumentTypes: 'dword ICoreWebView2Cookie**'
! !
!ICoreWebView2CookieList class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

