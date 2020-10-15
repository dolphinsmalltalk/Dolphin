"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'MSXML.IXMLHTTPRequest2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.IXMLHTTPRequest2 guid: (OS.COM.IID fromString: '{e5d37dc0-552a-4d52-9cc0-a14d546fbd04}')!
MSXML.IXMLHTTPRequest2 comment: '`IXMLHTTPRequest2` is a wrapper class for the COM interface ''MSXML2.IXMLHTTPRequest2'' generated from type information in the ''Microsoft XML, v6.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IXMLHTTPRequest2 Interface"

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(e5d37dc0-552a-4d52-9cc0-a14d546fbd04), 
	helpstring("IXMLHTTPRequest2 Interface")
]
interface IXMLHTTPRequest2 : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall open(
		[in]LPWSTR pwszMethod,
		[in]LPWSTR pwszUrl,
		[in]IXMLHTTPRequest2Callback* pStatusCallback,
		[in]LPWSTR pwszUserName,
		[in]LPWSTR pwszPassword,
		[in]LPWSTR pwszProxyUserName,
		[in]LPWSTR pwszProxyPassword);
	[id(0x60010001)]
	HRESULT __stdcall send(
		[in]ISequentialStream* pBody,
		[in]unsigned __int64 cbBody);
	[id(0x60010002)]
	HRESULT __stdcall abort();
	[id(0x60010003)]
	HRESULT __stdcall SetCookie(
		[in]XHR_COOKIE* pCookie,
		[out]unsigned long* pdwCookieState);
	[id(0x60010004)]
	HRESULT __stdcall SetCustomResponseStream(
		[in]ISequentialStream* pSequentialStream);
	[id(0x60010005)]
	HRESULT __stdcall setProperty(
		[in]XHR_PROPERTY eProperty,
		[in]unsigned __int64 ullValue);
	[id(0x60010006)]
	HRESULT __stdcall setRequestHeader(
		[in]LPWSTR pwszHeader,
		[in]LPWSTR pwszValue);
	[id(0x60010007)]
	HRESULT __stdcall getAllResponseHeaders(
		[out]LPWSTR* ppwszHeaders);
	[id(0x60010008)]
	HRESULT __stdcall GetCookie(
		[in]LPWSTR pwszUrl,
		[in]LPWSTR pwszName,
		[in]unsigned long dwFlags,
		[out]unsigned long* pcCookies,
		[out]XHR_COOKIE** ppCookies);
	[id(0x60010009)]
	HRESULT __stdcall getResponseHeader(
		[in]LPWSTR pwszHeader,
		[out]LPWSTR* ppwszValue);
};
```
'!
!MSXML.IXMLHTTPRequest2 categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.IXMLHTTPRequest2 methodsFor!

Abort
	"Invoke the abort() method of the COM object.

		HRESULT __stdcall abort();"

	<virtual stdcall: hresult 6>
	^self invalidCall: _failureCode!

getAllResponseHeaders
	"Answer the <lpwstr> result of invoking the getAllResponseHeaders() method of the COM object."

	| answer |
	answer := StructurePointer newNull: TaskMemory elementClass: Utf16String.
	self GetAllResponseHeaders: answer.
	^answer asObject!

GetAllResponseHeaders: ppwszHeaders
	"Private - Invoke the getAllResponseHeaders() method of the COM object.

		HRESULT __stdcall getAllResponseHeaders(
			[out]LPWSTR* ppwszHeaders);"

	<virtual stdcall: hresult 11 lpwstr*>
	^self invalidCall: _failureCode!

getCookie: pwszUrl pwszName: pwszName dwFlags: dwFlags
	"Invoke the GetCookie() method of the COM object."

	| outputs |
	outputs := {DWORD new. XHR_COOKIE newBufferClass: TaskMemory}.
	self
		GetCookie: pwszUrl asUtf16String
		pwszName: pwszName asUtf16String
		dwFlags: dwFlags
		pcCookies: (outputs basicAt: 1)
		ppCookies: (outputs basicAt: 2).
	^outputs collect: [:each | each asObject]!

GetCookie: pwszUrl pwszName: pwszName dwFlags: dwFlags pcCookies: pcCookies ppCookies: ppCookies
	"Private - Invoke the GetCookie() method of the COM object.

		HRESULT __stdcall GetCookie(
			[in]LPWSTR pwszUrl,
			[in]LPWSTR pwszName,
			[in]unsigned long dwFlags,
			[out]unsigned long* pcCookies,
			[out]XHR_COOKIE** ppCookies);"

	<virtual stdcall: hresult 12 lpwstr lpwstr dword dword* XHR_COOKIE**>
	^self invalidCall: _failureCode!

getResponseHeader: pwszHeader
	"Answer the <lpwstr> result of invoking the getResponseHeader() method of the COM object."

	| answer |
	answer := StructurePointer newNull: TaskMemory elementClass: Utf16String.
	self GetResponseHeader: pwszHeader asUtf16String ppwszValue: answer.
	^answer asObject!

GetResponseHeader: pwszHeader ppwszValue: ppwszValue
	"Private - Invoke the getResponseHeader() method of the COM object.

		HRESULT __stdcall getResponseHeader(
			[in]LPWSTR pwszHeader,
			[out]LPWSTR* ppwszValue);"

	<virtual stdcall: hresult 13 lpwstr lpwstr*>
	^self invalidCall: _failureCode!

Open: pwszMethod pwszUrl: pwszUrl pStatusCallback: pStatusCallback pwszUserName: pwszUserName pwszPassword: pwszPassword pwszProxyUserName: pwszProxyUserName pwszProxyPassword: pwszProxyPassword
	"Invoke the open() method of the COM object.

		HRESULT __stdcall open(
			[in]LPWSTR pwszMethod,
			[in]LPWSTR pwszUrl,
			[in]IXMLHTTPRequest2Callback* pStatusCallback,
			[in]LPWSTR pwszUserName,
			[in]LPWSTR pwszPassword,
			[in]LPWSTR pwszProxyUserName,
			[in]LPWSTR pwszProxyPassword);"

	<virtual stdcall: hresult 4 lpwstr lpwstr IXMLHTTPRequest2Callback* lpwstr lpwstr lpwstr lpwstr>
	^self invalidCall: _failureCode!

Send: pBody cbBody: cbBody
	"Invoke the send() method of the COM object.

		HRESULT __stdcall send(
			[in]ISequentialStream* pBody,
			[in]unsigned __int64 cbBody);"

	<virtual stdcall: hresult 5 ISequentialStream* qword>
	^self invalidCall: _failureCode!

setCookie: pCookie
	"Answer the <dword> result of invoking the SetCookie() method of the COM object."

	| answer |
	answer := DWORD new.
	self SetCookie: pCookie pdwCookieState: answer.
	^answer asObject!

SetCookie: pCookie pdwCookieState: pdwCookieState
	"Private - Invoke the SetCookie() method of the COM object.

		HRESULT __stdcall SetCookie(
			[in]XHR_COOKIE* pCookie,
			[out]unsigned long* pdwCookieState);"

	<virtual stdcall: hresult 7 XHR_COOKIE* dword*>
	^self invalidCall: _failureCode!

SetCustomResponseStream: pSequentialStream
	"Invoke the SetCustomResponseStream() method of the COM object.

		HRESULT __stdcall SetCustomResponseStream(
			[in]ISequentialStream* pSequentialStream);"

	<virtual stdcall: hresult 8 ISequentialStream*>
	^self invalidCall: _failureCode!

SetProperty: eProperty ullValue: ullValue
	"Invoke the setProperty() method of the COM object.

		HRESULT __stdcall setProperty(
			[in]XHR_PROPERTY eProperty,
			[in]unsigned __int64 ullValue);"

	<virtual stdcall: hresult 9 sdword qword>
	^self invalidCall: _failureCode!

SetRequestHeader: pwszHeader pwszValue: pwszValue
	"Invoke the setRequestHeader() method of the COM object.

		HRESULT __stdcall setRequestHeader(
			[in]LPWSTR pwszHeader,
			[in]LPWSTR pwszValue);"

	<virtual stdcall: hresult 10 lpwstr lpwstr>
	^self invalidCall: _failureCode! !
!MSXML.IXMLHTTPRequest2 categoriesFor: #Abort!**auto generated**!COM Interfaces-IXMLHTTPRequest2!public! !
!MSXML.IXMLHTTPRequest2 categoriesFor: #getAllResponseHeaders!**auto generated**!methods!public! !
!MSXML.IXMLHTTPRequest2 categoriesFor: #GetAllResponseHeaders:!**auto generated**!COM Interfaces-IXMLHTTPRequest2!private! !
!MSXML.IXMLHTTPRequest2 categoriesFor: #getCookie:pwszName:dwFlags:!**auto generated**!methods!public! !
!MSXML.IXMLHTTPRequest2 categoriesFor: #GetCookie:pwszName:dwFlags:pcCookies:ppCookies:!**auto generated**!COM Interfaces-IXMLHTTPRequest2!private! !
!MSXML.IXMLHTTPRequest2 categoriesFor: #getResponseHeader:!**auto generated**!methods!public! !
!MSXML.IXMLHTTPRequest2 categoriesFor: #GetResponseHeader:ppwszValue:!**auto generated**!COM Interfaces-IXMLHTTPRequest2!private! !
!MSXML.IXMLHTTPRequest2 categoriesFor: #Open:pwszUrl:pStatusCallback:pwszUserName:pwszPassword:pwszProxyUserName:pwszProxyPassword:!**auto generated**!COM Interfaces-IXMLHTTPRequest2!public! !
!MSXML.IXMLHTTPRequest2 categoriesFor: #Send:cbBody:!**auto generated**!COM Interfaces-IXMLHTTPRequest2!public! !
!MSXML.IXMLHTTPRequest2 categoriesFor: #setCookie:!**auto generated**!methods!public! !
!MSXML.IXMLHTTPRequest2 categoriesFor: #SetCookie:pdwCookieState:!**auto generated**!COM Interfaces-IXMLHTTPRequest2!private! !
!MSXML.IXMLHTTPRequest2 categoriesFor: #SetCustomResponseStream:!**auto generated**!COM Interfaces-IXMLHTTPRequest2!public! !
!MSXML.IXMLHTTPRequest2 categoriesFor: #SetProperty:ullValue:!**auto generated**!COM Interfaces-IXMLHTTPRequest2!public! !
!MSXML.IXMLHTTPRequest2 categoriesFor: #SetRequestHeader:pwszValue:!**auto generated**!COM Interfaces-IXMLHTTPRequest2!public! !

!MSXML.IXMLHTTPRequest2 class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (FreeThreadedXMLHTTP60) for which the receiver is the default interface."

	^CLSID fromString: '{88d96a09-f192-11d4-a65f-0040963251e5}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLHTTPRequest2'
		IXMLHTTPRequest2 defineTemplate"

	self
		defineFunction: #Open:pwszUrl:pStatusCallback:pwszUserName:pwszPassword:pwszProxyUserName:pwszProxyPassword:
			argumentTypes: 'lpwstr lpwstr IXMLHTTPRequest2Callback* lpwstr lpwstr lpwstr lpwstr';
		defineFunction: #Send:cbBody:
			argumentTypes: 'ISequentialStream* qword';
		defineFunction: #Abort;
		defineFunction: #SetCookie:pdwCookieState:
			argumentTypes: 'XHR_COOKIE* dword*';
		defineFunction: #SetCustomResponseStream:
			argumentTypes: 'ISequentialStream*';
		defineFunction: #SetProperty:ullValue:
			argumentTypes: 'sdword qword';
		defineFunction: #SetRequestHeader:pwszValue:
			argumentTypes: 'lpwstr lpwstr';
		defineFunction: #GetAllResponseHeaders:
			argumentTypes: 'lpwstr*';
		defineFunction: #GetCookie:pwszName:dwFlags:pcCookies:ppCookies:
			argumentTypes: 'lpwstr lpwstr dword dword* XHR_COOKIE**';
		defineFunction: #GetResponseHeader:ppwszValue:
			argumentTypes: 'lpwstr lpwstr*'
! !
!MSXML.IXMLHTTPRequest2 class categoriesFor: #clsid!**auto generated**!constants!private! !
!MSXML.IXMLHTTPRequest2 class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

