"Filed out from Dolphin Smallalk"!

ICoreWebView2Sequence subclass: #ICoreWebView2ClientCertificateCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2ClientCertificateCollection guid: (IID fromString: '{ef5674d2-bcc3-11eb-8529-0242ac130003}')!
ICoreWebView2ClientCertificateCollection comment: '`ICoreWebView2ClientCertificateCollection` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ClientCertificateCollection'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!ICoreWebView2ClientCertificateCollection categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2ClientCertificateCollection methodsFor!

elementClass
	^ICoreWebView2ClientCertificate!

GetValueAtIndex: index value: certificate
	"Private - Invoke the GetValueAtIndex() method of the COM object.

		HRESULT __stdcall GetValueAtIndex(
			[in]unsigned int index,
			[out, retval]ICoreWebView2ClientCertificate** certificate);"

	<virtual stdcall: hresult 5 dword ICoreWebView2ClientCertificate**>
	^self invalidCall: _failureCode! !
!ICoreWebView2ClientCertificateCollection categoriesForMethods!
elementClass!constants!private! !
GetValueAtIndex:value:!**auto generated**!COM Interfaces-ICoreWebView2ClientCertificateCollection!private! !
!

!ICoreWebView2ClientCertificateCollection class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ClientCertificateCollection'
		ICoreWebView2ClientCertificateCollection defineTemplate"

	self
		defineFunction: #get_Count:
			argumentTypes: 'dword*';
		defineFunction: #GetValueAtIndex:value:
			argumentTypes: 'dword ICoreWebView2ClientCertificate**'
! !
!ICoreWebView2ClientCertificateCollection class categoriesForMethods!
defineFunctions!initializing!public! !
!

