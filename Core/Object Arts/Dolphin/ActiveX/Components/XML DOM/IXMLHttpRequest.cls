"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IXMLHttpRequest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
IXMLHttpRequest guid: (IID fromString: '{ed8c108d-4349-11d2-91a4-00c04f7969e8}')!
IXMLHttpRequest comment: '<IXMLHttpRequest> is a wrapper class for the COM interface ''MSXML.IXMLHttpRequest'' generated from type information in the ''Microsoft XML, version 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following (typically unhelpful) helpstring for this interface
	"IXMLHttpRequest Interface"

The Http Request COM object can be used to send and receive XML via HTTP to a Web server, including DAV enabled servers.'!
!IXMLHttpRequest categoriesForClass!COM-Interfaces!MSXML-Interfaces! !
!IXMLHttpRequest methodsFor!

Abort
	"Invoke the abort() method of the COM object.
	Helpstring: Abort HTTP request

		HRESULT __stdcall abort();"

	<virtual stdcall: hresult 13>
	^self invalidCall: _failureCode!

get_readyState: plState
	"Private - Get the value of the 'readyState' property of the receiver.

		HRESULT __stdcall readyState(
			[out, retval]long* plState);"

	<virtual stdcall: hresult 20 sdword*>
	^self invalidCall: _failureCode!

get_responseBody: pvarBody
	"Private - Get the value of the 'responseBody' property of the receiver.

		HRESULT __stdcall responseBody(
			[out, retval]VARIANT* pvarBody);"

	<virtual stdcall: hresult 18 variant*>
	^self invalidCall: _failureCode!

get_responseStream: pvarBody
	"Private - Get the value of the 'responseStream' property of the receiver.

		HRESULT __stdcall responseStream(
			[out, retval]VARIANT* pvarBody);"

	<virtual stdcall: hresult 19 variant*>
	^self invalidCall: _failureCode!

get_responseText: pbstrBody
	"Private - Get the value of the 'responseText' property of the receiver.

		HRESULT __stdcall responseText(
			[out, retval]BSTR* pbstrBody);"

	<virtual stdcall: hresult 17 bstr*>
	^self invalidCall: _failureCode!

get_responseXML: ppBody
	"Private - Get the value of the 'responseXML' property of the receiver.

		HRESULT __stdcall responseXML(
			[out, retval]IDispatch** ppBody);"

	<virtual stdcall: hresult 16 IDispatch**>
	^self invalidCall: _failureCode!

get_status: plStatus
	"Private - Get the value of the 'status' property of the receiver.

		HRESULT __stdcall status(
			[out, retval]long* plStatus);"

	<virtual stdcall: hresult 14 sdword*>
	^self invalidCall: _failureCode!

get_statusText: pbstrStatus
	"Private - Get the value of the 'statusText' property of the receiver.

		HRESULT __stdcall statusText(
			[out, retval]BSTR* pbstrStatus);"

	<virtual stdcall: hresult 15 bstr*>
	^self invalidCall: _failureCode!

getAllResponseHeaders
	"Answer the <BSTR> result of invoking the getAllResponseHeaders() method of the COM object.
	Helpstring: Get all HTTP response headers"

	| answer |
	answer := BSTR new.
	self GetAllResponseHeaders: answer.
	^answer asObject
!

GetAllResponseHeaders: pbstrHeaders
	"Private - Invoke the getAllResponseHeaders() method of the COM object.
	Helpstring: Get all HTTP response headers

		HRESULT __stdcall getAllResponseHeaders(
			[out, retval]BSTR* pbstrHeaders);"

	<virtual stdcall: hresult 11 bstr*>
	^self invalidCall: _failureCode!

getResponseHeader: bstrHeader
	"Answer the <BSTR> result of invoking the getResponseHeader() method of the COM object.
	Helpstring: Get HTTP response header"

	| answer |
	answer := BSTR new.
	self
		GetResponseHeader: bstrHeader
		pbstrValue: answer.
	^answer asObject
!

GetResponseHeader: bstrHeader pbstrValue: pbstrValue
	"Private - Invoke the getResponseHeader() method of the COM object.
	Helpstring: Get HTTP response header

		HRESULT __stdcall getResponseHeader(
			[in]BSTR bstrHeader,
			[out, retval]BSTR* pbstrValue);"

	<virtual stdcall: hresult 10 bstr bstr*>
	^self invalidCall: _failureCode!

onreadystatechange: arg1
	"Set the 'onreadystatechange' property of the receiver to the <IDispatch*> value of the argument.
	Helpstring: Register a complete event handler"

	self put_onreadystatechange: arg1
!

open: bstrMethod bstrUrl: bstrUrl
	"Invoke the open() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 open: bstrMethod
		 bstrUrl: bstrUrl
		 varAsync: VARIANT unspecified
		 bstrUser: VARIANT unspecified
		 bstrPassword: VARIANT unspecified!

open: bstrMethod bstrUrl: bstrUrl varAsync: varAsync bstrUser: bstrUser bstrPassword: bstrPassword
	"Invoke the open() method of the COM object.
	Helpstring: Open HTTP connection"

	^self
		Open: bstrMethod
		bstrUrl: bstrUrl
		varAsync: varAsync asVariant
		bstrUser: bstrUser asVariant
		bstrPassword: bstrPassword asVariant
!

Open: bstrMethod bstrUrl: bstrUrl varAsync: varAsync bstrUser: bstrUser bstrPassword: bstrPassword
	"Private - Invoke the open() method of the COM object.
	Helpstring: Open HTTP connection

		HRESULT __stdcall open(
			[in]BSTR bstrMethod,
			[in]BSTR bstrUrl,
			[in, optional]VARIANT varAsync,
			[in, optional]VARIANT bstrUser,
			[in, optional]VARIANT bstrPassword);"

	<virtual stdcall: hresult 8 bstr bstr variant variant variant>
	^self invalidCall: _failureCode!

put_onreadystatechange: arg1
	"Private - Set the value of the 'onreadystatechange' property of the object wrapped by the 
	 receiver to the <IDispatch*> argument, arg1.

		HRESULT __stdcall onreadystatechange(
			[in]IDispatch* arg1);"

	<virtual stdcall: hresult 21 IDispatch*>
	^self invalidCall: _failureCode!

readyState
	"Answer the <sdword> value of the 'readyState' property of the receiver.
	Helpstring: Get ready state"

	| answer |
	answer := (SDWORD new).
	self get_readyState: answer.
	^answer asObject
!

responseBody
	"Answer the <variant> value of the 'responseBody' property of the receiver.
	Helpstring: Get response body"

	| answer |
	answer := VARIANT new.
	self get_responseBody: answer.
	^answer asObject
!

responseStream
	"Answer the <variant> value of the 'responseStream' property of the receiver.
	Helpstring: Get response body"

	| answer |
	answer := VARIANT new.
	self get_responseStream: answer.
	^answer asObject
!

responseText
	"Answer the <bstr> value of the 'responseText' property of the receiver.
	Helpstring: Get response body"

	| answer |
	answer := BSTR new.
	self get_responseText: answer.
	^answer asObject
!

responseXML
	"Answer the <IDispatch> value of the 'responseXML' property of the receiver.
	Helpstring: Get response body"

	| answer |
	answer := IDispatch newPointer.
	self get_responseXML: answer.
	^answer asObject
!

send
	"Invoke the send() method of the COM object.
	Default values are passed for all optional parameters."

	^self send: VARIANT unspecified!

send: varBody
	"Invoke the send() method of the COM object.
	Helpstring: Send HTTP request"

	^self Send: varBody asVariant
!

Send: varBody
	"Private - Invoke the send() method of the COM object.
	Helpstring: Send HTTP request

		HRESULT __stdcall send(
			[in, optional]VARIANT varBody);"

	<virtual stdcall: hresult 12 variant>
	^self invalidCall: _failureCode!

SetRequestHeader: bstrHeader bstrValue: bstrValue
	"Invoke the setRequestHeader() method of the COM object.
	Helpstring: Add HTTP request header

		HRESULT __stdcall setRequestHeader(
			[in]BSTR bstrHeader,
			[in]BSTR bstrValue);"

	<virtual stdcall: hresult 9 bstr bstr>
	^self invalidCall: _failureCode!

status
	"Answer the <sdword> value of the 'status' property of the receiver.
	Helpstring: Get HTTP status code"

	| answer |
	answer := (SDWORD new).
	self get_status: answer.
	^answer asObject
!

statusText
	"Answer the <bstr> value of the 'statusText' property of the receiver.
	Helpstring: Get HTTP status text"

	| answer |
	answer := BSTR new.
	self get_statusText: answer.
	^answer asObject
! !
!IXMLHttpRequest categoriesFor: #Abort!**auto generated**!COM Interfaces-IXMLHTTPRequest!public! !
!IXMLHttpRequest categoriesFor: #get_readyState:!**auto generated**!COM Interfaces-IXMLHTTPRequest!private! !
!IXMLHttpRequest categoriesFor: #get_responseBody:!**auto generated**!COM Interfaces-IXMLHTTPRequest!private! !
!IXMLHttpRequest categoriesFor: #get_responseStream:!**auto generated**!COM Interfaces-IXMLHTTPRequest!private! !
!IXMLHttpRequest categoriesFor: #get_responseText:!**auto generated**!COM Interfaces-IXMLHTTPRequest!private! !
!IXMLHttpRequest categoriesFor: #get_responseXML:!**auto generated**!COM Interfaces-IXMLHTTPRequest!private! !
!IXMLHttpRequest categoriesFor: #get_status:!**auto generated**!COM Interfaces-IXMLHTTPRequest!private! !
!IXMLHttpRequest categoriesFor: #get_statusText:!**auto generated**!COM Interfaces-IXMLHTTPRequest!private! !
!IXMLHttpRequest categoriesFor: #getAllResponseHeaders!**auto generated**!methods!public! !
!IXMLHttpRequest categoriesFor: #GetAllResponseHeaders:!**auto generated**!COM Interfaces-IXMLHTTPRequest!private! !
!IXMLHttpRequest categoriesFor: #getResponseHeader:!**auto generated**!methods!public! !
!IXMLHttpRequest categoriesFor: #GetResponseHeader:pbstrValue:!**auto generated**!COM Interfaces-IXMLHTTPRequest!private! !
!IXMLHttpRequest categoriesFor: #onreadystatechange:!**auto generated**!properties!public! !
!IXMLHttpRequest categoriesFor: #open:bstrUrl:!**auto generated**!methods!public! !
!IXMLHttpRequest categoriesFor: #open:bstrUrl:varAsync:bstrUser:bstrPassword:!**auto generated**!methods!public! !
!IXMLHttpRequest categoriesFor: #Open:bstrUrl:varAsync:bstrUser:bstrPassword:!**auto generated**!COM Interfaces-IXMLHTTPRequest!private! !
!IXMLHttpRequest categoriesFor: #put_onreadystatechange:!**auto generated**!COM Interfaces-IXMLHTTPRequest!private! !
!IXMLHttpRequest categoriesFor: #readyState!**auto generated**!properties!public! !
!IXMLHttpRequest categoriesFor: #responseBody!**auto generated**!properties!public! !
!IXMLHttpRequest categoriesFor: #responseStream!**auto generated**!properties!public! !
!IXMLHttpRequest categoriesFor: #responseText!**auto generated**!properties!public! !
!IXMLHttpRequest categoriesFor: #responseXML!**auto generated**!properties!public! !
!IXMLHttpRequest categoriesFor: #send!**auto generated**!methods!public! !
!IXMLHttpRequest categoriesFor: #send:!**auto generated**!methods!public! !
!IXMLHttpRequest categoriesFor: #Send:!**auto generated**!COM Interfaces-IXMLHTTPRequest!private! !
!IXMLHttpRequest categoriesFor: #SetRequestHeader:bstrValue:!**auto generated**!COM Interfaces-IXMLHTTPRequest!public! !
!IXMLHttpRequest categoriesFor: #status!**auto generated**!properties!public! !
!IXMLHttpRequest categoriesFor: #statusText!**auto generated**!properties!public! !

!IXMLHttpRequest class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLHTTPRequest'
		IXMLHttpRequest defineTemplate"

	self
		defineFunction: #Open:bstrUrl:varAsync:bstrUser:bstrPassword:
			argumentTypes: 'bstr bstr variant variant variant';
		defineFunction: #SetRequestHeader:bstrValue:
			argumentTypes: 'bstr bstr';
		defineFunction: #GetResponseHeader:pbstrValue:
			argumentTypes: 'bstr bstr*';
		defineFunction: #GetAllResponseHeaders:
			argumentTypes: 'bstr*';
		defineFunction: #Send:
			argumentTypes: 'variant';
		defineFunction: #Abort;
		defineFunction: #get_status:
			argumentTypes: 'sdword*';
		defineFunction: #get_statusText:
			argumentTypes: 'bstr*';
		defineFunction: #get_responseXML:
			argumentTypes: 'IDispatch**';
		defineFunction: #get_responseText:
			argumentTypes: 'bstr*';
		defineFunction: #get_responseBody:
			argumentTypes: 'variant*';
		defineFunction: #get_responseStream:
			argumentTypes: 'variant*';
		defineFunction: #get_readyState:
			argumentTypes: 'sdword*';
		defineFunction: #put_onreadystatechange:
			argumentTypes: 'IDispatch*'
!

newXMLHTTP
	"Answer a new instance of the receiver on the XMLHTTP COM object"

	^self onCLSID: (CLSID fromString: '{F6D90F16-9C73-11D3-B32E-00C04F990BB4}')
!

newXMLHTTP26
	"Answer a new instance of the receiver on the XMLHTTP26 COM object"

	^self onCLSID: (CLSID fromString: '{F5078F1E-C551-11D3-89B9-0000F81FE221}')
!

newXMLHTTP30
	"Answer a new instance of the receiver on the XMLHTTP30 COM object"

	^self onCLSID: (CLSID fromString: '{F5078F35-C551-11D3-89B9-0000F81FE221}')
!

newXMLHTTP40
	"Answer a new instance of the receiver on the XMLHTTP40 COM object"

	^self onCLSID: (CLSID fromString: '{88D969C5-F192-11D4-A65F-0040963251E5}')
!

newXMLHTTP60
	"Answer a new instance of the receiver on the XMLHTTP60 COM object"

	^self onCLSID: (CLSID fromString: '{88D96A0A-F192-11D4-A65F-0040963251E5}')
! !
!IXMLHttpRequest class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!IXMLHttpRequest class categoriesFor: #newXMLHTTP!**auto generated**!instance creation!public! !
!IXMLHttpRequest class categoriesFor: #newXMLHTTP26!**auto generated**!instance creation!public! !
!IXMLHttpRequest class categoriesFor: #newXMLHTTP30!**auto generated**!instance creation!public! !
!IXMLHttpRequest class categoriesFor: #newXMLHTTP40!**auto generated**!instance creation!public! !
!IXMLHttpRequest class categoriesFor: #newXMLHTTP60!**auto generated**!instance creation!public! !

