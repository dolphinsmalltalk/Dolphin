"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'WinHttp.IWinHttpRequest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{WinHttp.WinHttpConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
WinHttp.IWinHttpRequest guid: (OS.COM.IID fromString: '{016fe2ec-b2c8-45f8-b23b-39e53a75396b}')!
WinHttp.IWinHttpRequest comment: '`IWinHttpRequest` is a wrapper class for the COM interface ''WinHttp.IWinHttpRequest'' generated from type information in the ''Microsoft WinHTTP Services, version 5.1'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IWinHttpRequest Interface"

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(016fe2ec-b2c8-45f8-b23b-39e53a75396b), 
	helpstring("IWinHttpRequest Interface"), 
	nonextensible, 
	dual
]
interface IWinHttpRequest : IDispatch
 {
	[id(0x0000000d), helpstring("Specify proxy configuration")]
	HRESULT __stdcall SetProxy(
		[in]HTTPREQUEST_PROXY_SETTING ProxySetting,
		[in, optional]VARIANT ProxyServer,
		[in, optional]VARIANT BypassList);
	[id(0x0000000e), helpstring("Specify authentication credentials")]
	HRESULT __stdcall SetCredentials(
		[in]BSTR UserName,
		[in]BSTR Password,
		[in]HTTPREQUEST_SETCREDENTIALS_FLAGS Flags);
	[id(0x00000001), helpstring("Open HTTP connection")]
	HRESULT __stdcall Open(
		[in]BSTR Method,
		[in]BSTR Url,
		[in, optional]VARIANT Async);
	[id(0x00000002), helpstring("Add HTTP request header")]
	HRESULT __stdcall SetRequestHeader(
		[in]BSTR Header,
		[in]BSTR Value);
	[id(0x00000003), helpstring("Get HTTP response header")]
	HRESULT __stdcall GetResponseHeader(
		[in]BSTR Header,
		[out, retval]BSTR* Value);
	[id(0x00000004), helpstring("Get all HTTP response headers")]
	HRESULT __stdcall GetAllResponseHeaders(
		[out, retval]BSTR* Headers);
	[id(0x00000005), helpstring("Send HTTP request")]
	HRESULT __stdcall Send(
		[in, optional]VARIANT Body);
	[id(0x00000007), propget, helpstring("Get HTTP status code")]
	HRESULT __stdcall Status(
		[out, retval]long* Status);
	[id(0x00000008), propget, helpstring("Get HTTP status text")]
	HRESULT __stdcall StatusText(
		[out, retval]BSTR* Status);
	[id(0x00000009), propget, helpstring("Get response body as a string")]
	HRESULT __stdcall ResponseText(
		[out, retval]BSTR* Body);
	[id(0x0000000a), propget, helpstring("Get response body as a safearray of UI1")]
	HRESULT __stdcall ResponseBody(
		[out, retval]VARIANT* Body);
	[id(0x0000000b), propget, helpstring("Get response body as a stream")]
	HRESULT __stdcall ResponseStream(
		[out, retval]VARIANT* Body);
	[id(0x00000006), propget]
	HRESULT __stdcall Option(
		[in]WinHttpRequestOption Option,
		[out, retval]VARIANT* Value);
	[id(0x00000006), propput]
	HRESULT __stdcall Option(
		[in]WinHttpRequestOption Option,
		[in]VARIANT Value);
	[id(0x0000000f), helpstring("Wait for asynchronous send to complete, with optional timeout (in seconds)")]
	HRESULT __stdcall WaitForResponse(
		[in, optional]VARIANT Timeout,
		[out, retval]VARIANT_BOOL* Succeeded);
	[id(0x0000000c), helpstring("Abort an asynchronous operation in progress")]
	HRESULT __stdcall Abort();
	[id(0x00000010), helpstring("Specify timeout settings (in milliseconds)")]
	HRESULT __stdcall SetTimeouts(
		[in]long ResolveTimeout,
		[in]long ConnectTimeout,
		[in]long SendTimeout,
		[in]long ReceiveTimeout);
	[id(0x00000011), helpstring("Specify a client certificate")]
	HRESULT __stdcall SetClientCertificate(
		[in]BSTR ClientCertificate);
	[id(0x00000012), helpstring("Specify if credentials should be sent automatically")]
	HRESULT __stdcall SetAutoLogonPolicy(
		[in]WinHttpRequestAutoLogonPolicy AutoLogonPolicy);
};
```
'!
!WinHttp.IWinHttpRequest categoriesForClass!COM-Interfaces!WinHttp-Interfaces! !
!WinHttp.IWinHttpRequest methodsFor!

abort
	"Invoke the Abort() method of the COM object.
	Helpstring: Abort an asynchronous operation in progress"

	^self Abort!

Abort
	"Private - Invoke the Abort() method of the COM object.
	Helpstring: Abort an asynchronous operation in progress

		HRESULT __stdcall Abort();"

	<virtual stdcall: hresult 23>
	^self invalidCall: _failureCode!

get: aString
	"Perform an HTTP Get on the specified URL, answering the HTTP status code, e.g. 200 for OK"

	^self
		open: 'get' url: aString;
		send;
		status!

get_Option: option value: value
	"Private - Get the value of the 'Option' property of the receiver.

		HRESULT __stdcall Option(
			[in]WinHttpRequestOption Option,
			[out, retval]VARIANT* Value);"

	<virtual stdcall: hresult 20 sdword variant*>
	^self invalidCall: _failureCode!

get_ResponseBody: body
	"Private - Get the value of the 'ResponseBody' property of the receiver.

		HRESULT __stdcall ResponseBody(
			[out, retval]VARIANT* Body);"

	<virtual stdcall: hresult 18 variant*>
	^self invalidCall: _failureCode!

get_ResponseStream: body
	"Private - Get the value of the 'ResponseStream' property of the receiver.

		HRESULT __stdcall ResponseStream(
			[out, retval]VARIANT* Body);"

	<virtual stdcall: hresult 19 variant*>
	^self invalidCall: _failureCode!

get_ResponseText: body
	"Private - Get the value of the 'ResponseText' property of the receiver.

		HRESULT __stdcall ResponseText(
			[out, retval]BSTR* Body);"

	<virtual stdcall: hresult 17 bstr*>
	^self invalidCall: _failureCode!

get_Status: status
	"Private - Get the value of the 'Status' property of the receiver.

		HRESULT __stdcall Status(
			[out, retval]long* Status);"

	<virtual stdcall: hresult 15 sdword*>
	^self invalidCall: _failureCode!

get_StatusText: status
	"Private - Get the value of the 'StatusText' property of the receiver.

		HRESULT __stdcall StatusText(
			[out, retval]BSTR* Status);"

	<virtual stdcall: hresult 16 bstr*>
	^self invalidCall: _failureCode!

getAllResponseHeaders
	"Answer the <bstr> result of invoking the GetAllResponseHeaders() method of the COM object.
	Helpstring: Get all HTTP response headers"

	| answer |
	answer := BSTR new.
	self GetAllResponseHeaders: answer.
	^answer asObject!

GetAllResponseHeaders: headers
	"Private - Invoke the GetAllResponseHeaders() method of the COM object.
	Helpstring: Get all HTTP response headers

		HRESULT __stdcall GetAllResponseHeaders(
			[out, retval]BSTR* Headers);"

	<virtual stdcall: hresult 13 bstr*>
	^self invalidCall: _failureCode!

getResponseHeader: header
	"Answer the <bstr> result of invoking the GetResponseHeader() method of the COM object.
	Helpstring: Get HTTP response header"

	| answer |
	answer := BSTR new.
	self GetResponseHeader: header value: answer.
	^answer asObject!

GetResponseHeader: header value: value
	"Private - Invoke the GetResponseHeader() method of the COM object.
	Helpstring: Get HTTP response header

		HRESULT __stdcall GetResponseHeader(
			[in]BSTR Header,
			[out, retval]BSTR* Value);"

	<virtual stdcall: hresult 12 bstr bstr*>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

open: method url: url
	"Invoke the Open() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		open: method
		url: url
		async: VARIANT unspecified!

open: method url: url async: async
	"Invoke the Open() method of the COM object.
	Helpstring: Open HTTP connection"

	^self
		Open: method
		url: url
		async: async asVariant!

Open: method url: url async: async
	"Private - Invoke the Open() method of the COM object.
	Helpstring: Open HTTP connection

		HRESULT __stdcall Open(
			[in]BSTR Method,
			[in]BSTR Url,
			[in, optional]VARIANT Async);"

	<virtual stdcall: hresult 10 bstr bstr variant>
	^self invalidCall: _failureCode!

option: option
	"Answer the <variant> value of the 'Option' property of the receiver."

	| answer |
	answer := VARIANT new.
	self get_Option: option value: answer.
	^answer asObject!

option: option value: value
	"Set the 'Option' property of the receiver to the <variant> value of the argument."

	self put_Option: option value: value asVariant!

put_Option: option value: value
	"Private - Set the value of the 'Option' property of the object wrapped by the 
	 receiver to the <variant> argument, value.

		HRESULT __stdcall Option(
			[in]WinHttpRequestOption Option,
			[in]VARIANT Value);"

	<virtual stdcall: hresult 21 sdword variant>
	^self invalidCall: _failureCode!

responseBody
	"Answer the raw bytes of the response body."

	"Implementation Note: Don't use the get_ResponseBody call as returning and then extracting a ByteArray via the medium of a SAFEARRAY of BYTE is inefficient. Rather just read all the bytes from the response stream."

	^self responseStream contents!

responseStream
	"Answer an <IStream> on the response body for accessing the raw bytes."

	| variant stream unk |
	variant := VARIANT newBuffer.
	self get_ResponseStream: variant.
	unk := variant value.
	variant free.
	stream := unk queryInterface: IStream.
	unk free.
	^stream!

responseText
	"Answer the <bstr> value of the 'ResponseText' property of the receiver.
	Helpstring: Get response body as a string"

	| answer |
	answer := BSTR new.
	self get_ResponseText: answer.
	^answer asObject!

send
	"Invoke the Send() method of the COM object.
	Default values are passed for all optional parameters."

	^self send: VARIANT unspecified!

send: body
	"Invoke the Send() method of the COM object.
	Helpstring: Send HTTP request"

	^self Send: body asVariant!

Send: body
	"Private - Invoke the Send() method of the COM object.
	Helpstring: Send HTTP request

		HRESULT __stdcall Send(
			[in, optional]VARIANT Body);"

	<virtual stdcall: hresult 14 variant>
	^self invalidCall: _failureCode!

setAutoLogonPolicy: autoLogonPolicy
	"Invoke the SetAutoLogonPolicy() method of the COM object.
	Helpstring: Specify if credentials should be sent automatically"

	^self SetAutoLogonPolicy: autoLogonPolicy!

SetAutoLogonPolicy: autoLogonPolicy
	"Private - Invoke the SetAutoLogonPolicy() method of the COM object.
	Helpstring: Specify if credentials should be sent automatically

		HRESULT __stdcall SetAutoLogonPolicy(
			[in]WinHttpRequestAutoLogonPolicy AutoLogonPolicy);"

	<virtual stdcall: hresult 26 sdword>
	^self invalidCall: _failureCode!

setClientCertificate: clientCertificate
	"Invoke the SetClientCertificate() method of the COM object.
	Helpstring: Specify a client certificate"

	^self SetClientCertificate: clientCertificate!

SetClientCertificate: clientCertificate
	"Private - Invoke the SetClientCertificate() method of the COM object.
	Helpstring: Specify a client certificate

		HRESULT __stdcall SetClientCertificate(
			[in]BSTR ClientCertificate);"

	<virtual stdcall: hresult 25 bstr>
	^self invalidCall: _failureCode!

setCredentials: userName password: password flags: flags
	"Invoke the SetCredentials() method of the COM object.
	Helpstring: Specify authentication credentials"

	^self
		SetCredentials: userName
		password: password
		flags: flags!

SetCredentials: userName password: password flags: flags
	"Private - Invoke the SetCredentials() method of the COM object.
	Helpstring: Specify authentication credentials

		HRESULT __stdcall SetCredentials(
			[in]BSTR UserName,
			[in]BSTR Password,
			[in]HTTPREQUEST_SETCREDENTIALS_FLAGS Flags);"

	<virtual stdcall: hresult 9 bstr bstr sdword>
	^self invalidCall: _failureCode!

setProxy: proxySetting
	"Invoke the SetProxy() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		setProxy: proxySetting
		proxyServer: VARIANT unspecified
		bypassList: VARIANT unspecified!

setProxy: proxySetting proxyServer: proxyServer bypassList: bypassList
	"Invoke the SetProxy() method of the COM object.
	Helpstring: Specify proxy configuration"

	^self
		SetProxy: proxySetting
		proxyServer: proxyServer asVariant
		bypassList: bypassList asVariant!

SetProxy: proxySetting proxyServer: proxyServer bypassList: bypassList
	"Private - Invoke the SetProxy() method of the COM object.
	Helpstring: Specify proxy configuration

		HRESULT __stdcall SetProxy(
			[in]HTTPREQUEST_PROXY_SETTING ProxySetting,
			[in, optional]VARIANT ProxyServer,
			[in, optional]VARIANT BypassList);"

	<virtual stdcall: hresult 8 sdword variant variant>
	^self invalidCall: _failureCode!

setRequestHeader: header value: value
	"Invoke the SetRequestHeader() method of the COM object.
	Helpstring: Add HTTP request header"

	^self SetRequestHeader: header value: value!

SetRequestHeader: header value: value
	"Private - Invoke the SetRequestHeader() method of the COM object.
	Helpstring: Add HTTP request header

		HRESULT __stdcall SetRequestHeader(
			[in]BSTR Header,
			[in]BSTR Value);"

	<virtual stdcall: hresult 11 bstr bstr>
	^self invalidCall: _failureCode!

setTimeouts: resolveTimeout connectTimeout: connectTimeout sendTimeout: sendTimeout receiveTimeout: receiveTimeout
	"Invoke the SetTimeouts() method of the COM object.
	Helpstring: Specify timeout settings (in milliseconds)"

	^self
		SetTimeouts: resolveTimeout
		connectTimeout: connectTimeout
		sendTimeout: sendTimeout
		receiveTimeout: receiveTimeout!

SetTimeouts: resolveTimeout connectTimeout: connectTimeout sendTimeout: sendTimeout receiveTimeout: receiveTimeout
	"Private - Invoke the SetTimeouts() method of the COM object.
	Helpstring: Specify timeout settings (in milliseconds)

		HRESULT __stdcall SetTimeouts(
			[in]long ResolveTimeout,
			[in]long ConnectTimeout,
			[in]long SendTimeout,
			[in]long ReceiveTimeout);"

	<virtual stdcall: hresult 24 sdword sdword sdword sdword>
	^self invalidCall: _failureCode!

status
	"Answer the <sdword> value of the 'Status' property of the receiver.
	Helpstring: Get HTTP status code"

	| answer |
	answer := SDWORD new.
	self get_Status: answer.
	^answer asObject!

statusText
	"Answer the <bstr> value of the 'StatusText' property of the receiver.
	Helpstring: Get HTTP status text"

	| answer |
	answer := BSTR new.
	self get_StatusText: answer.
	^answer asObject!

waitForResponse
	"Answer the <varbool> result of invoking the WaitForResponse() method of the COM object.
	Default values are passed for all optional parameters."

	^self waitForResponse: VARIANT unspecified!

waitForResponse: timeout
	"Answer the <varbool> result of invoking the WaitForResponse() method of the COM object.
	Helpstring: Wait for asynchronous send to complete, with optional timeout (in seconds)"

	| answer |
	answer := VARIANT_BOOL new.
	self WaitForResponse: timeout asVariant succeeded: answer.
	^answer asObject!

WaitForResponse: timeout succeeded: succeeded
	"Private - Invoke the WaitForResponse() method of the COM object.
	Helpstring: Wait for asynchronous send to complete, with optional timeout (in seconds)

		HRESULT __stdcall WaitForResponse(
			[in, optional]VARIANT Timeout,
			[out, retval]VARIANT_BOOL* Succeeded);"

	<virtual stdcall: hresult 22 variant varbool*>
	^self invalidCall: _failureCode! !
!WinHttp.IWinHttpRequest categoriesFor: #abort!**auto generated**!methods!public! !
!WinHttp.IWinHttpRequest categoriesFor: #Abort!**auto generated**!COM Interfaces-IWinHttpRequest!private! !
!WinHttp.IWinHttpRequest categoriesFor: #get:!operations!public! !
!WinHttp.IWinHttpRequest categoriesFor: #get_Option:value:!**auto generated**!COM Interfaces-IWinHttpRequest!private! !
!WinHttp.IWinHttpRequest categoriesFor: #get_ResponseBody:!**auto generated**!COM Interfaces-IWinHttpRequest!private! !
!WinHttp.IWinHttpRequest categoriesFor: #get_ResponseStream:!**auto generated**!COM Interfaces-IWinHttpRequest!private! !
!WinHttp.IWinHttpRequest categoriesFor: #get_ResponseText:!**auto generated**!COM Interfaces-IWinHttpRequest!private! !
!WinHttp.IWinHttpRequest categoriesFor: #get_Status:!**auto generated**!COM Interfaces-IWinHttpRequest!private! !
!WinHttp.IWinHttpRequest categoriesFor: #get_StatusText:!**auto generated**!COM Interfaces-IWinHttpRequest!private! !
!WinHttp.IWinHttpRequest categoriesFor: #getAllResponseHeaders!**auto generated**!methods!public! !
!WinHttp.IWinHttpRequest categoriesFor: #GetAllResponseHeaders:!**auto generated**!COM Interfaces-IWinHttpRequest!private! !
!WinHttp.IWinHttpRequest categoriesFor: #getResponseHeader:!**auto generated**!methods!public! !
!WinHttp.IWinHttpRequest categoriesFor: #GetResponseHeader:value:!**auto generated**!COM Interfaces-IWinHttpRequest!private! !
!WinHttp.IWinHttpRequest categoriesFor: #isExtensible!**auto generated**!public!testing! !
!WinHttp.IWinHttpRequest categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!WinHttp.IWinHttpRequest categoriesFor: #open:url:!**auto generated**!methods!public! !
!WinHttp.IWinHttpRequest categoriesFor: #open:url:async:!**auto generated**!methods!public! !
!WinHttp.IWinHttpRequest categoriesFor: #Open:url:async:!**auto generated**!COM Interfaces-IWinHttpRequest!private! !
!WinHttp.IWinHttpRequest categoriesFor: #option:!**auto generated**!properties!public! !
!WinHttp.IWinHttpRequest categoriesFor: #option:value:!**auto generated**!properties!public! !
!WinHttp.IWinHttpRequest categoriesFor: #put_Option:value:!**auto generated**!COM Interfaces-IWinHttpRequest!private! !
!WinHttp.IWinHttpRequest categoriesFor: #responseBody!properties!public! !
!WinHttp.IWinHttpRequest categoriesFor: #responseStream!properties!public! !
!WinHttp.IWinHttpRequest categoriesFor: #responseText!**auto generated**!properties!public! !
!WinHttp.IWinHttpRequest categoriesFor: #send!**auto generated**!methods!public! !
!WinHttp.IWinHttpRequest categoriesFor: #send:!**auto generated**!methods!public! !
!WinHttp.IWinHttpRequest categoriesFor: #Send:!**auto generated**!COM Interfaces-IWinHttpRequest!private! !
!WinHttp.IWinHttpRequest categoriesFor: #setAutoLogonPolicy:!**auto generated**!methods!public! !
!WinHttp.IWinHttpRequest categoriesFor: #SetAutoLogonPolicy:!**auto generated**!COM Interfaces-IWinHttpRequest!private! !
!WinHttp.IWinHttpRequest categoriesFor: #setClientCertificate:!**auto generated**!methods!public! !
!WinHttp.IWinHttpRequest categoriesFor: #SetClientCertificate:!**auto generated**!COM Interfaces-IWinHttpRequest!private! !
!WinHttp.IWinHttpRequest categoriesFor: #setCredentials:password:flags:!**auto generated**!methods!public! !
!WinHttp.IWinHttpRequest categoriesFor: #SetCredentials:password:flags:!**auto generated**!COM Interfaces-IWinHttpRequest!private! !
!WinHttp.IWinHttpRequest categoriesFor: #setProxy:!**auto generated**!methods!public! !
!WinHttp.IWinHttpRequest categoriesFor: #setProxy:proxyServer:bypassList:!**auto generated**!methods!public! !
!WinHttp.IWinHttpRequest categoriesFor: #SetProxy:proxyServer:bypassList:!**auto generated**!COM Interfaces-IWinHttpRequest!private! !
!WinHttp.IWinHttpRequest categoriesFor: #setRequestHeader:value:!**auto generated**!methods!public! !
!WinHttp.IWinHttpRequest categoriesFor: #SetRequestHeader:value:!**auto generated**!COM Interfaces-IWinHttpRequest!private! !
!WinHttp.IWinHttpRequest categoriesFor: #setTimeouts:connectTimeout:sendTimeout:receiveTimeout:!**auto generated**!methods!public! !
!WinHttp.IWinHttpRequest categoriesFor: #SetTimeouts:connectTimeout:sendTimeout:receiveTimeout:!**auto generated**!COM Interfaces-IWinHttpRequest!private! !
!WinHttp.IWinHttpRequest categoriesFor: #status!**auto generated**!properties!public! !
!WinHttp.IWinHttpRequest categoriesFor: #statusText!**auto generated**!properties!public! !
!WinHttp.IWinHttpRequest categoriesFor: #waitForResponse!**auto generated**!methods!public! !
!WinHttp.IWinHttpRequest categoriesFor: #waitForResponse:!**auto generated**!methods!public! !
!WinHttp.IWinHttpRequest categoriesFor: #WaitForResponse:succeeded:!**auto generated**!COM Interfaces-IWinHttpRequest!private! !

!WinHttp.IWinHttpRequest class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (WinHttpRequest) for which the receiver is the default interface."

	^CLSID fromString: '{2087c2f4-2cef-4953-a8ab-66779b670495}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'WinHttp.IWinHttpRequest'
		IWinHttpRequest defineTemplate"

	self
		defineFunction: #SetProxy:proxyServer:bypassList:
			argumentTypes: 'sdword variant variant';
		defineFunction: #SetCredentials:password:flags:
			argumentTypes: 'bstr bstr sdword';
		defineFunction: #Open:url:async:
			argumentTypes: 'bstr bstr variant';
		defineFunction: #SetRequestHeader:value:
			argumentTypes: 'bstr bstr';
		defineFunction: #GetResponseHeader:value:
			argumentTypes: 'bstr bstr*';
		defineFunction: #GetAllResponseHeaders:
			argumentTypes: 'bstr*';
		defineFunction: #Send:
			argumentTypes: 'variant';
		defineFunction: #get_Status:
			argumentTypes: 'sdword*';
		defineFunction: #get_StatusText:
			argumentTypes: 'bstr*';
		defineFunction: #get_ResponseText:
			argumentTypes: 'bstr*';
		defineFunction: #get_ResponseBody:
			argumentTypes: 'variant*';
		defineFunction: #get_ResponseStream:
			argumentTypes: 'variant*';
		defineFunction: #get_Option:value:
			argumentTypes: 'sdword variant*';
		defineFunction: #put_Option:value:
			argumentTypes: 'sdword variant';
		defineFunction: #WaitForResponse:succeeded:
			argumentTypes: 'variant varbool*';
		defineFunction: #Abort;
		defineFunction: #SetTimeouts:connectTimeout:sendTimeout:receiveTimeout:
			argumentTypes: 'sdword sdword sdword sdword';
		defineFunction: #SetClientCertificate:
			argumentTypes: 'bstr';
		defineFunction: #SetAutoLogonPolicy:
			argumentTypes: 'sdword'
! !
!WinHttp.IWinHttpRequest class categoriesFor: #clsid!**auto generated**!constants!private! !
!WinHttp.IWinHttpRequest class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

