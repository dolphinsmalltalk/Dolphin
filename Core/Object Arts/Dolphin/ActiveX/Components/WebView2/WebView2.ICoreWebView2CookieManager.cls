"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2CookieManager'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2CookieManager guid: (OS.COM.IID fromString: '{177cd9e7-b6f5-451a-94a0-5d7a3a4c4141}')!
WebView2.ICoreWebView2CookieManager isEgressOnly: true!
WebView2.ICoreWebView2CookieManager comment: '`ICoreWebView2CookieManager` is a wrapper class for the COM interface ''WebView2.ICoreWebView2CookieManager'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(177cd9e7-b6f5-451a-94a0-5d7a3a4c4141)
]
interface ICoreWebView2CookieManager : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall CreateCookie(
		[in]LPWSTR name,
		[in]LPWSTR value,
		[in]LPWSTR Domain,
		[in]LPWSTR Path,
		[out, retval]ICoreWebView2Cookie** cookie);
	[id(0x60010001)]
	HRESULT __stdcall CopyCookie(
		[in]ICoreWebView2Cookie* cookieParam,
		[out, retval]ICoreWebView2Cookie** cookie);
	[id(0x60010002)]
	HRESULT __stdcall GetCookies(
		[in]LPWSTR uri,
		[in]ICoreWebView2GetCookiesCompletedHandler* handler);
	[id(0x60010003)]
	HRESULT __stdcall AddOrUpdateCookie(
		[in]ICoreWebView2Cookie* cookie);
	[id(0x60010004)]
	HRESULT __stdcall DeleteCookie(
		[in]ICoreWebView2Cookie* cookie);
	[id(0x60010005)]
	HRESULT __stdcall DeleteCookies(
		[in]LPWSTR name,
		[in]LPWSTR uri);
	[id(0x60010006)]
	HRESULT __stdcall DeleteCookiesWithDomainAndPath(
		[in]LPWSTR name,
		[in]LPWSTR Domain,
		[in]LPWSTR Path);
	[id(0x60010007)]
	HRESULT __stdcall DeleteAllCookies();
};
```
'!
!WebView2.ICoreWebView2CookieManager categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2CookieManager methodsFor!

addOrUpdateCookie: cookie
	"Invoke the AddOrUpdateCookie() method of the COM object."

	^self AddOrUpdateCookie: cookie!

AddOrUpdateCookie: cookie
	"Private - Invoke the AddOrUpdateCookie() method of the COM object.

		HRESULT __stdcall AddOrUpdateCookie(
			[in]ICoreWebView2Cookie* cookie);"

	<virtual stdcall: hresult 7 ICoreWebView2Cookie*>
	^self invalidCall: _failureCode!

copyCookie: cookieParam
	"Answer the <ICoreWebView2Cookie> result of invoking the CopyCookie() method of the COM object."

	| answer |
	answer := ICoreWebView2Cookie newPointer.
	self CopyCookie: cookieParam cookie: answer.
	^answer asObject!

CopyCookie: cookieParam cookie: cookie
	"Private - Invoke the CopyCookie() method of the COM object.

		HRESULT __stdcall CopyCookie(
			[in]ICoreWebView2Cookie* cookieParam,
			[out, retval]ICoreWebView2Cookie** cookie);"

	<virtual stdcall: hresult 5 ICoreWebView2Cookie* ICoreWebView2Cookie**>
	^self invalidCall: _failureCode!

createCookie: name value: value domain: domain path: path
	"Answer the <ICoreWebView2Cookie> result of invoking the CreateCookie() method of the COM object."

	| answer |
	answer := ICoreWebView2Cookie newPointer.
	self
		CreateCookie: name asUtf16String
		value: value asUtf16String
		domain: domain asUtf16String
		path: path asUtf16String
		cookie: answer.
	^answer asObject!

CreateCookie: name value: value domain: domain path: path cookie: cookie
	"Private - Invoke the CreateCookie() method of the COM object.

		HRESULT __stdcall CreateCookie(
			[in]LPWSTR name,
			[in]LPWSTR value,
			[in]LPWSTR Domain,
			[in]LPWSTR Path,
			[out, retval]ICoreWebView2Cookie** cookie);"

	<virtual stdcall: hresult 4 lpwstr lpwstr lpwstr lpwstr ICoreWebView2Cookie**>
	^self invalidCall: _failureCode!

deleteAllCookies
	"Invoke the DeleteAllCookies() method of the COM object."

	^self DeleteAllCookies!

DeleteAllCookies
	"Private - Invoke the DeleteAllCookies() method of the COM object.

		HRESULT __stdcall DeleteAllCookies();"

	<virtual stdcall: hresult 11>
	^self invalidCall: _failureCode!

deleteCookie: cookie
	"Invoke the DeleteCookie() method of the COM object."

	^self DeleteCookie: cookie!

DeleteCookie: cookie
	"Private - Invoke the DeleteCookie() method of the COM object.

		HRESULT __stdcall DeleteCookie(
			[in]ICoreWebView2Cookie* cookie);"

	<virtual stdcall: hresult 8 ICoreWebView2Cookie*>
	^self invalidCall: _failureCode!

deleteCookies: name uri: uri
	"Invoke the DeleteCookies() method of the COM object."

	^self DeleteCookies: name asUtf16String uri: uri asUtf16String!

DeleteCookies: name uri: uri
	"Private - Invoke the DeleteCookies() method of the COM object.

		HRESULT __stdcall DeleteCookies(
			[in]LPWSTR name,
			[in]LPWSTR uri);"

	<virtual stdcall: hresult 9 lpwstr lpwstr>
	^self invalidCall: _failureCode!

deleteCookiesWithDomainAndPath: name domain: domain path: path
	"Invoke the DeleteCookiesWithDomainAndPath() method of the COM object."

	^self
		DeleteCookiesWithDomainAndPath: name asUtf16String
		domain: domain asUtf16String
		path: path asUtf16String!

DeleteCookiesWithDomainAndPath: name domain: domain path: path
	"Private - Invoke the DeleteCookiesWithDomainAndPath() method of the COM object.

		HRESULT __stdcall DeleteCookiesWithDomainAndPath(
			[in]LPWSTR name,
			[in]LPWSTR Domain,
			[in]LPWSTR Path);"

	<virtual stdcall: hresult 10 lpwstr lpwstr lpwstr>
	^self invalidCall: _failureCode!

GetCookies: uri handler: handler
	"Private - Invoke the GetCookies() method of the COM object.

		HRESULT __stdcall GetCookies(
			[in]LPWSTR uri,
			[in]ICoreWebView2GetCookiesCompletedHandler* handler);"

	<virtual stdcall: hresult 6 lpwstr ICoreWebView2GetCookiesCompletedHandler*>
	^self invalidCall: _failureCode!

getCookies: uriString thenDo: aDyadicValuable
	"Asynchronously request the cookie list for the specified URI, invoking the <dyadicValuable> second argument when the request completes. The valuable is passed an HRESULT status code and an ICoreWebView2CookieList if successful."

	| handler |
	handler := (WebView2CompletionHandler completionBlock: aDyadicValuable)
				queryInterface: ICoreWebView2GetCookiesCompletedHandler.
	self GetCookies: uriString asUtf16String handler: handler.
	handler free! !
!WebView2.ICoreWebView2CookieManager categoriesForMethods!
addOrUpdateCookie:!**auto generated**!methods!public! !
AddOrUpdateCookie:!**auto generated**!COM Interfaces-ICoreWebView2CookieManager!private! !
copyCookie:!**auto generated**!methods!public! !
CopyCookie:cookie:!**auto generated**!COM Interfaces-ICoreWebView2CookieManager!private! !
createCookie:value:domain:path:!**auto generated**!methods!public! !
CreateCookie:value:domain:path:cookie:!**auto generated**!COM Interfaces-ICoreWebView2CookieManager!private! !
deleteAllCookies!**auto generated**!methods!public! !
DeleteAllCookies!**auto generated**!COM Interfaces-ICoreWebView2CookieManager!private! !
deleteCookie:!**auto generated**!methods!public! !
DeleteCookie:!**auto generated**!COM Interfaces-ICoreWebView2CookieManager!private! !
deleteCookies:uri:!**auto generated**!methods!public! !
DeleteCookies:uri:!**auto generated**!COM Interfaces-ICoreWebView2CookieManager!private! !
deleteCookiesWithDomainAndPath:domain:path:!**auto generated**!methods!public! !
DeleteCookiesWithDomainAndPath:domain:path:!**auto generated**!COM Interfaces-ICoreWebView2CookieManager!private! !
GetCookies:handler:!**auto generated**!COM Interfaces-ICoreWebView2CookieManager!private! !
getCookies:thenDo:!methods!public! !
!

!WebView2.ICoreWebView2CookieManager class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2CookieManager'
		ICoreWebView2CookieManager defineTemplate"

	self
		defineFunction: #CreateCookie:value:domain:path:cookie:
			argumentTypes: 'lpwstr lpwstr lpwstr lpwstr ICoreWebView2Cookie**';
		defineFunction: #CopyCookie:cookie:
			argumentTypes: 'ICoreWebView2Cookie* ICoreWebView2Cookie**';
		defineFunction: #GetCookies:handler:
			argumentTypes: 'lpwstr ICoreWebView2GetCookiesCompletedHandler*';
		defineFunction: #AddOrUpdateCookie:
			argumentTypes: 'ICoreWebView2Cookie*';
		defineFunction: #DeleteCookie:
			argumentTypes: 'ICoreWebView2Cookie*';
		defineFunction: #DeleteCookies:uri:
			argumentTypes: 'lpwstr lpwstr';
		defineFunction: #DeleteCookiesWithDomainAndPath:domain:path:
			argumentTypes: 'lpwstr lpwstr lpwstr';
		defineFunction: #DeleteAllCookies
! !
!WebView2.ICoreWebView2CookieManager class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

