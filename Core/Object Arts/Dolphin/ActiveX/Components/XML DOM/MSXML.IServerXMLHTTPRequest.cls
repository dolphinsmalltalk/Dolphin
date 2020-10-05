"Filed out from Dolphin Smalltalk 7"!

IXMLHttpRequest subclass: #IServerXMLHTTPRequest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
IServerXMLHTTPRequest guid: (IID fromString: '{2e9196bf-13ba-4dd4-91ca-6c571f281495}')!
IServerXMLHTTPRequest comment: '<IServerXMLHTTPRequest> is a wrapper class for the COM interface ''MSXML2.IServerXMLHTTPRequest'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IServerXMLHTTPRequest Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(2E9196BF-13BA-4DD4-91CA-6C571F281495), 
	helpstring("IServerXMLHTTPRequest Interface"), 
	dual
]
interface IServerXMLHTTPRequest : IXMLHTTPRequest
 {
	[id(0x0000000f), helpstring("Specify timeout settings (in milliseconds)")]
	HRESULT __stdcall setTimeouts(
		[in]long resolveTimeout,
		[in]long connectTimeout,
		[in]long sendTimeout,
		[in]long receiveTimeout);
	[id(0x00000010), helpstring("Wait for asynchronous send to complete, with optional timeout (in seconds)")]
	HRESULT __stdcall waitForResponse(
		[in, optional]VARIANT timeoutInSeconds,
		[out, retval]VARIANT_BOOL* isSuccessful);
	[id(0x00000011), helpstring("Get an option value")]
	HRESULT __stdcall getOption(
		[in]SERVERXMLHTTP_OPTION option,
		[out, retval]VARIANT* value);
	[id(0x00000012), helpstring("Set an option value")]
	HRESULT __stdcall setOption(
		[in]SERVERXMLHTTP_OPTION option,
		[in]VARIANT value);
};
'!
!IServerXMLHTTPRequest categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!IServerXMLHTTPRequest methodsFor!

getOption: option
	"Answer the <VARIANT> result of invoking the getOption() method of the COM object.
	Helpstring: Get an option value"

	| answer |
	answer := VARIANT new.
	self
		GetOption: option
		value: answer.
	^answer asObject
!

GetOption: option value: value
	"Private - Invoke the getOption() method of the COM object.
	Helpstring: Get an option value

		HRESULT __stdcall getOption(
			[in]SERVERXMLHTTP_OPTION option,
			[out, retval]VARIANT* value);"

	<virtual stdcall: hresult 24 sdword variant*>
	^self invalidCall: _failureCode!

setOption: option value: value
	"Invoke the setOption() method of the COM object.
	Helpstring: Set an option value"

	^self
		SetOption: option
		value: value asVariant
!

SetOption: option value: value
	"Private - Invoke the setOption() method of the COM object.
	Helpstring: Set an option value

		HRESULT __stdcall setOption(
			[in]SERVERXMLHTTP_OPTION option,
			[in]VARIANT value);"

	<virtual stdcall: hresult 25 sdword variant>
	^self invalidCall: _failureCode!

SetTimeouts: resolveTimeout connectTimeout: connectTimeout sendTimeout: sendTimeout receiveTimeout: receiveTimeout
	"Invoke the setTimeouts() method of the COM object.
	Helpstring: Specify timeout settings (in milliseconds)

		HRESULT __stdcall setTimeouts(
			[in]long resolveTimeout,
			[in]long connectTimeout,
			[in]long sendTimeout,
			[in]long receiveTimeout);"

	<virtual stdcall: hresult 22 sdword sdword sdword sdword>
	^self invalidCall: _failureCode!

waitForResponse
	"Answer the <VARIANT_BOOL> result of invoking the waitForResponse() method of the COM object.
	Default values are passed for all optional parameters."

	^self waitForResponse: VARIANT unspecified!

waitForResponse: timeoutInSeconds
	"Answer the <VARIANT_BOOL> result of invoking the waitForResponse() method of the COM object.
	Helpstring: Wait for asynchronous send to complete, with optional timeout (in seconds)"

	| answer |
	answer := (VARIANT_BOOL new).
	self
		WaitForResponse: timeoutInSeconds asVariant
		isSuccessful: answer.
	^answer asObject
!

WaitForResponse: timeoutInSeconds isSuccessful: isSuccessful
	"Private - Invoke the waitForResponse() method of the COM object.
	Helpstring: Wait for asynchronous send to complete, with optional timeout (in seconds)

		HRESULT __stdcall waitForResponse(
			[in, optional]VARIANT timeoutInSeconds,
			[out, retval]VARIANT_BOOL* isSuccessful);"

	<virtual stdcall: hresult 23 variant varbool*>
	^self invalidCall: _failureCode! !
!IServerXMLHTTPRequest categoriesFor: #getOption:!**auto generated**!methods!public! !
!IServerXMLHTTPRequest categoriesFor: #GetOption:value:!**auto generated**!COM Interfaces-IServerXMLHTTPRequest!private! !
!IServerXMLHTTPRequest categoriesFor: #setOption:value:!**auto generated**!methods!public! !
!IServerXMLHTTPRequest categoriesFor: #SetOption:value:!**auto generated**!COM Interfaces-IServerXMLHTTPRequest!private! !
!IServerXMLHTTPRequest categoriesFor: #SetTimeouts:connectTimeout:sendTimeout:receiveTimeout:!**auto generated**!COM Interfaces-IServerXMLHTTPRequest!public! !
!IServerXMLHTTPRequest categoriesFor: #waitForResponse!**auto generated**!methods!public! !
!IServerXMLHTTPRequest categoriesFor: #waitForResponse:!**auto generated**!methods!public! !
!IServerXMLHTTPRequest categoriesFor: #WaitForResponse:isSuccessful:!**auto generated**!COM Interfaces-IServerXMLHTTPRequest!private! !

!IServerXMLHTTPRequest class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IServerXMLHTTPRequest'
		IServerXMLHTTPRequest defineTemplate"

	self
		defineFunction: #SetTimeouts:connectTimeout:sendTimeout:receiveTimeout:
			argumentTypes: 'sdword sdword sdword sdword';
		defineFunction: #WaitForResponse:isSuccessful:
			argumentTypes: 'variant varbool*';
		defineFunction: #GetOption:value:
			argumentTypes: 'sdword variant*';
		defineFunction: #SetOption:value:
			argumentTypes: 'sdword variant'
!

newServerXMLHTTP
	"Answer a new instance of the receiver on the ServerXMLHTTP COM object"

	^self onCLSID: (CLSID fromString: '{AFBA6B42-5692-48EA-8141-DC517DCF0EF1}')
!

newServerXMLHTTP30
	"Answer a new instance of the receiver on the ServerXMLHTTP30 COM object"

	^self onCLSID: (CLSID fromString: '{AFB40FFD-B609-40A3-9828-F88BBE11E4E3}')
! !
!IServerXMLHTTPRequest class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!IServerXMLHTTPRequest class categoriesFor: #newServerXMLHTTP!**auto generated**!instance creation!public! !
!IServerXMLHTTPRequest class categoriesFor: #newServerXMLHTTP30!**auto generated**!instance creation!public! !

