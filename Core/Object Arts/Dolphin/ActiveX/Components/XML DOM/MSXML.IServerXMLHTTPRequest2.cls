"Filed out from Dolphin Smalltalk 7"!

MSXML.IServerXMLHTTPRequest subclass: #'MSXML.IServerXMLHTTPRequest2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.IServerXMLHTTPRequest2 guid: (OS.COM.IID fromString: '{2e01311b-c322-4b0a-bd77-b90cfdc8dce7}')!
MSXML.IServerXMLHTTPRequest2 comment: '<IServerXMLHTTPRequest2> is a wrapper class for the COM interface ''MSXML2.IServerXMLHTTPRequest2'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IServerXMLHTTPRequest2 Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(2E01311B-C322-4B0A-BD77-B90CFDC8DCE7), 
	helpstring("IServerXMLHTTPRequest2 Interface"), 
	dual
]
interface IServerXMLHTTPRequest2 : IServerXMLHTTPRequest
 {
	[id(0x00000013), helpstring("Specify proxy configuration")]
	HRESULT __stdcall setProxy(
		[in]SXH_PROXY_SETTING proxySetting,
		[in, optional]VARIANT varProxyServer,
		[in, optional]VARIANT varBypassList);
	[id(0x00000014), helpstring("Specify proxy authentication credentials")]
	HRESULT __stdcall setProxyCredentials(
		[in]BSTR bstrUserName,
		[in]BSTR bstrPassword);
};
'!
!MSXML.IServerXMLHTTPRequest2 categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.IServerXMLHTTPRequest2 methodsFor!

setProxy: proxySetting
	"Invoke the setProxy() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		setProxy: proxySetting
		varProxyServer: VARIANT unspecified
		varBypassList: VARIANT unspecified!

setProxy: proxySetting varProxyServer: varProxyServer varBypassList: varBypassList
	"Invoke the setProxy() method of the COM object.
	Helpstring: Specify proxy configuration"

	^self
		SetProxy: proxySetting
		varProxyServer: varProxyServer asVariant
		varBypassList: varBypassList asVariant!

SetProxy: proxySetting varProxyServer: varProxyServer varBypassList: varBypassList
	"Private - Invoke the setProxy() method of the COM object.
	Helpstring: Specify proxy configuration

		HRESULT __stdcall setProxy(
			[in]SXH_PROXY_SETTING proxySetting,
			[in, optional]VARIANT varProxyServer,
			[in, optional]VARIANT varBypassList);"

	<virtual stdcall: hresult 26 sdword variant variant>
	^self invalidCall: _failureCode!

SetProxyCredentials: bstrUserName bstrPassword: bstrPassword
	"Invoke the setProxyCredentials() method of the COM object.
	Helpstring: Specify proxy authentication credentials

		HRESULT __stdcall setProxyCredentials(
			[in]BSTR bstrUserName,
			[in]BSTR bstrPassword);"

	<virtual stdcall: hresult 27 bstr bstr>
	^self invalidCall: _failureCode! !
!MSXML.IServerXMLHTTPRequest2 categoriesFor: #setProxy:!**auto generated**!methods!public! !
!MSXML.IServerXMLHTTPRequest2 categoriesFor: #setProxy:varProxyServer:varBypassList:!**auto generated**!methods!public! !
!MSXML.IServerXMLHTTPRequest2 categoriesFor: #SetProxy:varProxyServer:varBypassList:!**auto generated**!COM Interfaces-IServerXMLHTTPRequest2!private! !
!MSXML.IServerXMLHTTPRequest2 categoriesFor: #SetProxyCredentials:bstrPassword:!**auto generated**!COM Interfaces-IServerXMLHTTPRequest2!public! !

!MSXML.IServerXMLHTTPRequest2 class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (ServerXMLHTTP60) for which the receiver is the default interface."

	^CLSID fromString: '{88d96a0b-f192-11d4-a65f-0040963251e5}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IServerXMLHTTPRequest2'
		IServerXMLHTTPRequest2 defineTemplate"

	self
		defineFunction: #SetProxy:varProxyServer:varBypassList:
			argumentTypes: 'sdword variant variant';
		defineFunction: #SetProxyCredentials:bstrPassword:
			argumentTypes: 'bstr bstr'
! !
!MSXML.IServerXMLHTTPRequest2 class categoriesFor: #clsid!**auto generated**!constants!private! !
!MSXML.IServerXMLHTTPRequest2 class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

