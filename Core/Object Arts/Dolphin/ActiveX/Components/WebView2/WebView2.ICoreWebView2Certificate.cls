"Filed out from Dolphin Smalltalk"!

ICoreWebView2Interface subclass: #ICoreWebView2Certificate
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2Certificate guid: (IID fromString: '{c5fb2fce-1cac-4aee-9c79-5ed0362eaae0}')!
ICoreWebView2Certificate comment: '`ICoreWebView2Certificate` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Certificate'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(c5fb2fce-1cac-4aee-9c79-5ed0362eaae0)
]
interface ICoreWebView2Certificate : IUnknown
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
};
```
'!
!ICoreWebView2Certificate categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2Certificate methodsFor!

derEncodedSerialNumber
	"Answer the <lpwstr> value of the 'DerEncodedSerialNumber' property of the receiver."

	| ptr answer |
	ptr := COMTaskMemory new.
	self get_DerEncodedSerialNumber: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

displayName
	"Answer the <lpwstr> value of the 'DisplayName' property of the receiver."

	| ptr answer |
	ptr := COMTaskMemory new.
	self get_DisplayName: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

displayOn: aWriteStream
	aWriteStream nextPutAll: self displayName!

get_DerEncodedSerialNumber: value
	"Private - Get the value of the 'DerEncodedSerialNumber' property of the receiver.

		HRESULT __stdcall DerEncodedSerialNumber(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 8 lpwstr*>
	^self invalidCall: _failureCode!

get_DisplayName: value
	"Private - Get the value of the 'DisplayName' property of the receiver.

		HRESULT __stdcall DisplayName(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 9 lpwstr*>
	^self invalidCall: _failureCode!

get_Issuer: value
	"Private - Get the value of the 'Issuer' property of the receiver.

		HRESULT __stdcall Issuer(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 5 lpwstr*>
	^self invalidCall: _failureCode!

get_PemEncodedIssuerCertificateChain: value
	"Private - Get the value of the 'PemEncodedIssuerCertificateChain' property of the receiver.

		HRESULT __stdcall PemEncodedIssuerCertificateChain(
			[out, retval]ICoreWebView2StringCollection** value);"

	<virtual stdcall: hresult 11 ICoreWebView2StringCollection**>
	^self invalidCall: _failureCode!

get_Subject: value
	"Private - Get the value of the 'Subject' property of the receiver.

		HRESULT __stdcall Subject(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

get_ValidFrom: value
	"Private - Get the value of the 'ValidFrom' property of the receiver.

		HRESULT __stdcall ValidFrom(
			[out, retval]double* value);"

	<virtual stdcall: hresult 6 double*>
	^self invalidCall: _failureCode!

get_ValidTo: value
	"Private - Get the value of the 'ValidTo' property of the receiver.

		HRESULT __stdcall ValidTo(
			[out, retval]double* value);"

	<virtual stdcall: hresult 7 double*>
	^self invalidCall: _failureCode!

issuer
	"Answer the <lpwstr> value of the 'Issuer' property of the receiver."

	| ptr answer |
	ptr := COMTaskMemory new.
	self get_Issuer: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

pemEncodedIssuerCertificateChain
	"Answer the <ICoreWebView2StringCollection> value of the 'PemEncodedIssuerCertificateChain' property of the receiver."

	| answer |
	answer := ICoreWebView2StringCollection newPointer.
	self get_PemEncodedIssuerCertificateChain: answer.
	^answer asObject!

printableProperties
	^#(#displayName #subject #issuer #validFrom #validTo)!

subject
	"Answer the <lpwstr> value of the 'Subject' property of the receiver."

	| ptr answer |
	ptr := COMTaskMemory new.
	self get_Subject: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

toPemEncoding
	"Answer the <Utf16String> result of invoking the ToPemEncoding() method of the COM object."

	| ptr answer |
	ptr := COMTaskMemory new.
	self ToPemEncoding: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer
!

ToPemEncoding: pemEncodedData
	"Private - Invoke the ToPemEncoding() method of the COM object.

		HRESULT __stdcall ToPemEncoding(
			[out, retval]LPWSTR* pemEncodedData);"

	<virtual stdcall: hresult 10 lpwstr*>
	^self invalidCall: _failureCode!

validFrom
	"Answer the <DateAndTime> value of the 'ValidFrom' property of the receiver."

	| answer |
	answer := DOUBLE newBuffer.
	self get_ValidFrom: answer.
	^DateAndTime fromUnixTime: answer value!

validTo
	"Answer the <double> value of the 'ValidTo' property of the receiver."

	| answer |
	answer := DOUBLE newBuffer.
	self get_ValidTo: answer.
	^DateAndTime fromUnixTime: answer value! !
!ICoreWebView2Certificate categoriesForMethods!
derEncodedSerialNumber!properties!public! !
displayName!properties!public! !
displayOn:!displaying!public! !
get_DerEncodedSerialNumber:!**auto generated**!COM Interfaces-ICoreWebView2Certificate!private! !
get_DisplayName:!**auto generated**!COM Interfaces-ICoreWebView2Certificate!private! !
get_Issuer:!**auto generated**!COM Interfaces-ICoreWebView2Certificate!private! !
get_PemEncodedIssuerCertificateChain:!**auto generated**!COM Interfaces-ICoreWebView2Certificate!private! !
get_Subject:!**auto generated**!COM Interfaces-ICoreWebView2Certificate!private! !
get_ValidFrom:!**auto generated**!COM Interfaces-ICoreWebView2Certificate!private! !
get_ValidTo:!**auto generated**!COM Interfaces-ICoreWebView2Certificate!private! !
issuer!properties!public! !
pemEncodedIssuerCertificateChain!**auto generated**!properties!public! !
printableProperties!printing!private! !
subject!properties!public! !
toPemEncoding!methods!public! !
ToPemEncoding:!**auto generated**!COM Interfaces-ICoreWebView2ClientCertificate!private! !
validFrom!properties!public! !
validTo!**auto generated**!properties!public! !
!

!ICoreWebView2Certificate class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Certificate'
		ICoreWebView2Certificate defineTemplate"

	self
		defineFunction: #get_Subject:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_Issuer:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_ValidFrom:
			argumentTypes: 'double*';
		defineFunction: #get_ValidTo:
			argumentTypes: 'double*';
		defineFunction: #get_DerEncodedSerialNumber:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_DisplayName:
			argumentTypes: 'lpwstr*';
		defineFunction: #ToPemEncoding:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_PemEncodedIssuerCertificateChain:
			argumentTypes: 'ICoreWebView2StringCollection**'
! !
!ICoreWebView2Certificate class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

