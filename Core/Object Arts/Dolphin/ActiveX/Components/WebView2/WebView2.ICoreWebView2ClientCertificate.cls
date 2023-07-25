"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Certificate
	subclass: #'WebView2.ICoreWebView2ClientCertificate'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2ClientCertificate guid: (OS.COM.IID fromString: '{e7188076-bcc3-11eb-8529-0242ac130003}')!
WebView2.ICoreWebView2ClientCertificate comment: '`ICoreWebView2ClientCertificate` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ClientCertificate'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(e7188076-bcc3-11eb-8529-0242ac130003)
]
interface ICoreWebView2ClientCertificate : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall Subject(
		[out, retval]LPWSTR* value);
	[id(0x60010001), propget]
	HRESULT __stdcall Issuer(
		[out, retval]LPWSTR* value);
	[id(0x60010002), propget]
	HRESULT __stdcall ValidFrom(
		[out, retval]double* value);
	[id(0x60010003), propget]
	HRESULT __stdcall ValidTo(
		[out, retval]double* value);
	[id(0x60010004), propget]
	HRESULT __stdcall DerEncodedSerialNumber(
		[out, retval]LPWSTR* value);
	[id(0x60010005), propget]
	HRESULT __stdcall DisplayName(
		[out, retval]LPWSTR* value);
	[id(0x60010006)]
	HRESULT __stdcall ToPemEncoding(
		[out, retval]LPWSTR* pemEncodedData);
	[id(0x60010007), propget]
	HRESULT __stdcall PemEncodedIssuerCertificateChain(
		[out, retval]ICoreWebView2StringCollection** value);
	[id(0x60010008), propget]
	HRESULT __stdcall Kind(
		[out, retval]COREWEBVIEW2_CLIENT_CERTIFICATE_KIND* value);
};
```
'!
!WebView2.ICoreWebView2ClientCertificate categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2ClientCertificate methodsFor!

get_Kind: value
	"Private - Get the value of the 'Kind' property of the receiver.

		HRESULT __stdcall Kind(
			[out, retval]COREWEBVIEW2_CLIENT_CERTIFICATE_KIND* value);"

	<virtual stdcall: hresult 12 int32*>
	^self invalidCall: _failureCode!

kind
	"Answer the <sdword> value of the 'Kind' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_Kind: answer.
	^answer asObject! !
!WebView2.ICoreWebView2ClientCertificate categoriesForMethods!
get_Kind:!**auto generated**!COM Interfaces-ICoreWebView2ClientCertificate!private! !
kind!**auto generated**!properties!public! !
!

!WebView2.ICoreWebView2ClientCertificate class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ClientCertificate'
		ICoreWebView2ClientCertificate defineTemplate"

	self defineFunction: #get_Kind: argumentTypes: 'sdword*'! !
!WebView2.ICoreWebView2ClientCertificate class categoriesForMethods!
defineFunctions!initializing!public!template definition! !
!

