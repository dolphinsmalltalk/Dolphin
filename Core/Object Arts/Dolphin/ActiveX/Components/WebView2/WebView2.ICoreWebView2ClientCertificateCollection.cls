"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Sequence
	subclass: #'WebView2.ICoreWebView2ClientCertificateCollection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2ClientCertificateCollection guid: (OS.COM.IID fromString: '{ef5674d2-bcc3-11eb-8529-0242ac130003}')!
WebView2.ICoreWebView2ClientCertificateCollection comment: '`ICoreWebView2ClientCertificateCollection` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ClientCertificateCollection'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(ef5674d2-bcc3-11eb-8529-0242ac130003)
]
interface ICoreWebView2ClientCertificateCollection : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall Count(
		[out, retval]unsigned int* value);
	[id(0x60010001)]
	HRESULT __stdcall GetValueAtIndex(
		[in]unsigned int index,
		[out, retval]ICoreWebView2ClientCertificate** certificate);
};
```
'!
!WebView2.ICoreWebView2ClientCertificateCollection categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2ClientCertificateCollection methodsFor!

elementClass
	^ICoreWebView2ClientCertificate!

GetValueAtIndex: index value: certificate
	"Private - Invoke the GetValueAtIndex() method of the COM object.

		HRESULT __stdcall GetValueAtIndex(
			[in]unsigned int index,
			[out, retval]ICoreWebView2ClientCertificate** certificate);"

	<virtual stdcall: hresult 5 uint32 ICoreWebView2ClientCertificate**>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2ClientCertificateCollection categoriesForMethods!
elementClass!constants!private! !
GetValueAtIndex:value:!**auto generated**!COM Interfaces-ICoreWebView2ClientCertificateCollection!private! !
!

!WebView2.ICoreWebView2ClientCertificateCollection class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ClientCertificateCollection'
		ICoreWebView2ClientCertificateCollection defineTemplate"

	self
		defineFunction: #get_Count:
			argumentTypes: 'dword*';
		defineFunction: #GetValueAtIndex:value:
			argumentTypes: 'dword ICoreWebView2ClientCertificate**'
! !
!WebView2.ICoreWebView2ClientCertificateCollection class categoriesForMethods!
defineFunctions!initializing!public! !
!

