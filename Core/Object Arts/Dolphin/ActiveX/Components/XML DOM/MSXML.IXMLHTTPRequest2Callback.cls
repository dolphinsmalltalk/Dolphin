"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'MSXML.IXMLHTTPRequest2Callback'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.IXMLHTTPRequest2Callback guid: (OS.COM.IID fromString: '{a44a9299-e321-40de-8866-341b41669162}')!
MSXML.IXMLHTTPRequest2Callback comment: '`IXMLHTTPRequest2Callback` is a wrapper class for the COM interface ''MSXML2.IXMLHTTPRequest2Callback'' generated from type information in the ''Microsoft XML, v6.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IXMLHTTPRequest2Callback Interface"

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(a44a9299-e321-40de-8866-341b41669162), 
	helpstring("IXMLHTTPRequest2Callback Interface")
]
interface IXMLHTTPRequest2Callback : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall OnRedirect(
		[in]IXMLHTTPRequest2* pXHR,
		[in]LPWSTR pwszRedirectUrl);
	[id(0x60010001)]
	HRESULT __stdcall OnHeadersAvailable(
		[in]IXMLHTTPRequest2* pXHR,
		[in]unsigned long dwStatus,
		[in]LPWSTR pwszStatus);
	[id(0x60010002)]
	HRESULT __stdcall ondataavailable(
		[in]IXMLHTTPRequest2* pXHR,
		[in]ISequentialStream* pResponseStream);
	[id(0x60010003)]
	HRESULT __stdcall OnResponseReceived(
		[in]IXMLHTTPRequest2* pXHR,
		[in]ISequentialStream* pResponseStream);
	[id(0x60010004)]
	HRESULT __stdcall OnError(
		[in]IXMLHTTPRequest2* pXHR,
		[in]HRESULT hrError);
};
```
'!
!MSXML.IXMLHTTPRequest2Callback categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.IXMLHTTPRequest2Callback methodsFor!

Ondataavailable: pXHR pResponseStream: pResponseStream
	"Invoke the ondataavailable() method of the COM object.

		HRESULT __stdcall ondataavailable(
			[in]IXMLHTTPRequest2* pXHR,
			[in]ISequentialStream* pResponseStream);"

	<virtual stdcall: hresult 6 IXMLHTTPRequest2* ISequentialStream*>
	^self invalidCall: _failureCode!

OnError: pXHR hrError: hrError
	"Invoke the OnError() method of the COM object.

		HRESULT __stdcall OnError(
			[in]IXMLHTTPRequest2* pXHR,
			[in]HRESULT hrError);"

	<virtual stdcall: hresult 8 IXMLHTTPRequest2* hresult>
	^self invalidCall: _failureCode!

OnHeadersAvailable: pXHR dwStatus: dwStatus pwszStatus: pwszStatus
	"Invoke the OnHeadersAvailable() method of the COM object.

		HRESULT __stdcall OnHeadersAvailable(
			[in]IXMLHTTPRequest2* pXHR,
			[in]unsigned long dwStatus,
			[in]LPWSTR pwszStatus);"

	<virtual stdcall: hresult 5 IXMLHTTPRequest2* dword lpwstr>
	^self invalidCall: _failureCode!

OnRedirect: pXHR pwszRedirectUrl: pwszRedirectUrl
	"Invoke the OnRedirect() method of the COM object.

		HRESULT __stdcall OnRedirect(
			[in]IXMLHTTPRequest2* pXHR,
			[in]LPWSTR pwszRedirectUrl);"

	<virtual stdcall: hresult 4 IXMLHTTPRequest2* lpwstr>
	^self invalidCall: _failureCode!

OnResponseReceived: pXHR pResponseStream: pResponseStream
	"Invoke the OnResponseReceived() method of the COM object.

		HRESULT __stdcall OnResponseReceived(
			[in]IXMLHTTPRequest2* pXHR,
			[in]ISequentialStream* pResponseStream);"

	<virtual stdcall: hresult 7 IXMLHTTPRequest2* ISequentialStream*>
	^self invalidCall: _failureCode! !
!MSXML.IXMLHTTPRequest2Callback categoriesFor: #Ondataavailable:pResponseStream:!**auto generated**!COM Interfaces-IXMLHTTPRequest2Callback!public! !
!MSXML.IXMLHTTPRequest2Callback categoriesFor: #OnError:hrError:!**auto generated**!COM Interfaces-IXMLHTTPRequest2Callback!public! !
!MSXML.IXMLHTTPRequest2Callback categoriesFor: #OnHeadersAvailable:dwStatus:pwszStatus:!**auto generated**!COM Interfaces-IXMLHTTPRequest2Callback!public! !
!MSXML.IXMLHTTPRequest2Callback categoriesFor: #OnRedirect:pwszRedirectUrl:!**auto generated**!COM Interfaces-IXMLHTTPRequest2Callback!public! !
!MSXML.IXMLHTTPRequest2Callback categoriesFor: #OnResponseReceived:pResponseStream:!**auto generated**!COM Interfaces-IXMLHTTPRequest2Callback!public! !

!MSXML.IXMLHTTPRequest2Callback class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLHTTPRequest2Callback'
		IXMLHTTPRequest2Callback defineTemplate"

	self
		defineFunction: #OnRedirect:pwszRedirectUrl:
			argumentTypes: 'IXMLHTTPRequest2* lpwstr';
		defineFunction: #OnHeadersAvailable:dwStatus:pwszStatus:
			argumentTypes: 'IXMLHTTPRequest2* dword lpwstr';
		defineFunction: #Ondataavailable:pResponseStream:
			argumentTypes: 'IXMLHTTPRequest2* ISequentialStream*';
		defineFunction: #OnResponseReceived:pResponseStream:
			argumentTypes: 'IXMLHTTPRequest2* ISequentialStream*';
		defineFunction: #OnError:hrError:
			argumentTypes: 'IXMLHTTPRequest2* hresult'
! !
!MSXML.IXMLHTTPRequest2Callback class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

