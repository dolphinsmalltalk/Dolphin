"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventArgs
	subclass: #'WebView2.ICoreWebView2ServerCertificateErrorDetectedEventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'Actions' -> #(#alwaysAllow #cancel #default).
			'ErrorMessages'
				-> #('Unknown' 'Certificate common name is incorrect' 'Certificate expired' 'Client certificate contains errors' 'Certificate revoked' 'Certificate is invalid' 'Server unreachable' 'Timeout' 'Error http invalid server response' 'Connection aborted' 'Connection reset' 'Disconnected' 'Cannot connect' 'Host name not resolved' 'Operation canceled' 'Redirect failed' 'Unexpected error' 'Valid authentication credentials required' 'Valid proxy authentication required')
		}!

WebView2.ICoreWebView2ServerCertificateErrorDetectedEventArgs guid: (OS.COM.IID fromString: '{012193ed-7c13-48ff-969d-a84c1f432a14}')!

WebView2.ICoreWebView2ServerCertificateErrorDetectedEventArgs isEgressOnly: true!

WebView2.ICoreWebView2ServerCertificateErrorDetectedEventArgs comment: '`ICoreWebView2ServerCertificateErrorDetectedEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ServerCertificateErrorDetectedEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(012193ed-7c13-48ff-969d-a84c1f432a14)
]
interface ICoreWebView2ServerCertificateErrorDetectedEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall ErrorStatus(
		[out, retval]COREWEBVIEW2_WEB_ERROR_STATUS* value);
	[id(0x60010001), propget]
	HRESULT __stdcall RequestUri(
		[out, retval]LPWSTR* value);
	[id(0x60010002), propget]
	HRESULT __stdcall ServerCertificate(
		[out, retval]ICoreWebView2Certificate** value);
	[id(0x60010003), propget]
	HRESULT __stdcall Action(
		[out, retval]COREWEBVIEW2_SERVER_CERTIFICATE_ERROR_ACTION* value);
	[id(0x60010003), propput]
	HRESULT __stdcall Action(
		[in]COREWEBVIEW2_SERVER_CERTIFICATE_ERROR_ACTION value);
	[id(0x60010005)]
	HRESULT __stdcall GetDeferral(
		[out, retval]ICoreWebView2Deferral** deferral);
};
```
'!

!WebView2.ICoreWebView2ServerCertificateErrorDetectedEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2ServerCertificateErrorDetectedEventArgs methodsFor!

action
	"Answer the <sdword> value of the 'Action' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_Action: answer.
	^answer asObject!

action: value
	"Set the 'Action' property of the receiver to the <sdword> value of the argument."

	self put_Action: value!

actionName
	"Answer the symbolic name of the 'Action' property of the receiver."

	^Actions at: self action + 1!

actionName: aSymbol
	"Set the 'Action' property of the receiver."

	self action: (Actions identityIndexOf: aSymbol) - 1!

errorMessage
	^(ErrorMessages lookup: self errorStatus + 1) ?? 'Unknown'!

errorStatus
	"Answer the <sdword> value of the 'ErrorStatus' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_ErrorStatus: answer.
	^answer asObject!

get_Action: value
	"Private - Get the value of the 'Action' property of the receiver.

		HRESULT __stdcall Action(
			[out, retval]COREWEBVIEW2_SERVER_CERTIFICATE_ERROR_ACTION* value);"

	<virtual stdcall: hresult 7 int32*>
	^self invalidCall: _failureCode!

get_ErrorStatus: value
	"Private - Get the value of the 'ErrorStatus' property of the receiver.

		HRESULT __stdcall ErrorStatus(
			[out, retval]COREWEBVIEW2_WEB_ERROR_STATUS* value);"

	<virtual stdcall: hresult 4 int32*>
	^self invalidCall: _failureCode!

get_RequestUri: value
	"Private - Get the value of the 'RequestUri' property of the receiver.

		HRESULT __stdcall RequestUri(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 5 lpwstr*>
	^self invalidCall: _failureCode!

get_ServerCertificate: value
	"Private - Get the value of the 'ServerCertificate' property of the receiver.

		HRESULT __stdcall ServerCertificate(
			[out, retval]ICoreWebView2Certificate** value);"

	<virtual stdcall: hresult 6 ICoreWebView2Certificate**>
	^self invalidCall: _failureCode!

GetDeferral: deferral
	"Private - Invoke the GetDeferral() method of the COM object.

		HRESULT __stdcall GetDeferral(
			[out, retval]ICoreWebView2Deferral** deferral);"

	<virtual stdcall: hresult 9 ICoreWebView2Deferral**>
	^self invalidCall: _failureCode!

printableProperties
	^#(#actionName #errorMessage #requestUri #serverCertificate)!

put_Action: value
	"Private - Set the value of the 'Action' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall Action(
			[in]COREWEBVIEW2_SERVER_CERTIFICATE_ERROR_ACTION value);"

	<virtual stdcall: hresult 8 int32>
	^self invalidCall: _failureCode!

requestUri
	"Answer the <readableString> value of the 'RequestUri' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_RequestUri: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

serverCertificate
	"Answer the <ICoreWebView2Certificate> value of the 'ServerCertificate' property of the receiver."

	| answer |
	answer := ICoreWebView2Certificate newPointer.
	self get_ServerCertificate: answer.
	^answer asObject! !

!WebView2.ICoreWebView2ServerCertificateErrorDetectedEventArgs categoriesForMethods!
action!**auto generated**!properties!public! !
action:!**auto generated**!properties!public! !
actionName!properties!public! !
actionName:!properties!public! !
errorMessage!**auto generated**!properties!public! !
errorStatus!**auto generated**!properties!public! !
get_Action:!**auto generated**!COM Interfaces-ICoreWebView2ServerCertificateErrorDetectedEventArgs!private! !
get_ErrorStatus:!**auto generated**!COM Interfaces-ICoreWebView2ServerCertificateErrorDetectedEventArgs!private! !
get_RequestUri:!**auto generated**!COM Interfaces-ICoreWebView2ServerCertificateErrorDetectedEventArgs!private! !
get_ServerCertificate:!**auto generated**!COM Interfaces-ICoreWebView2ServerCertificateErrorDetectedEventArgs!private! !
GetDeferral:!**auto generated**!COM Interfaces-ICoreWebView2ServerCertificateErrorDetectedEventArgs!private! !
printableProperties!printing!private! !
put_Action:!**auto generated**!COM Interfaces-ICoreWebView2ServerCertificateErrorDetectedEventArgs!private! !
requestUri!properties!public! !
serverCertificate!**auto generated**!properties!public! !
!

!WebView2.ICoreWebView2ServerCertificateErrorDetectedEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ServerCertificateErrorDetectedEventArgs'
		ICoreWebView2ServerCertificateErrorDetectedEventArgs defineTemplate"

	self
		defineFunction: #get_ErrorStatus:
			argumentTypes: 'sdword*';
		defineFunction: #get_RequestUri:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_ServerCertificate:
			argumentTypes: 'ICoreWebView2Certificate**';
		defineFunction: #get_Action:
			argumentTypes: 'sdword*';
		defineFunction: #put_Action:
			argumentTypes: 'sdword';
		defineFunction: #GetDeferral:
			argumentTypes: 'ICoreWebView2Deferral**'
!

initialize
	super initialize.
	self addClassConstant: 'ErrorMessages'
		value: (((WebView2 associations
				select: [:each | each key beginsWith: 'COREWEBVIEW2_WEB_ERROR_STATUS'])
					asSortedArray: [:a :b | a value < b value]) collect: 
						[:each |
						| parts |
						parts := $_ split: each key.
						$\x20 join: { (parts at: 5) titleCased } , ((parts copyFrom: 6) collect: [:p | p asLowercase])])! !

!WebView2.ICoreWebView2ServerCertificateErrorDetectedEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
initialize!public! !
!

