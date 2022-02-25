"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventArgs subclass: #ICoreWebView2ClientCertificateRequestedEventArgs
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ICoreWebView2ClientCertificateRequestedEventArgs guid: (OS.COM.IID fromString: '{bc59db28-bcc3-11eb-8529-0242ac130003}')!
ICoreWebView2ClientCertificateRequestedEventArgs comment: '`ICoreWebView2ClientCertificateRequestedEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ClientCertificateRequestedEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(bc59db28-bcc3-11eb-8529-0242ac130003)
]
interface ICoreWebView2ClientCertificateRequestedEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall Host(
		[out, retval]LPWSTR* value);
	[id(0x60010001), propget]
	HRESULT __stdcall Port(
		[out, retval]int* value);
	[id(0x60010002), propget]
	HRESULT __stdcall IsProxy(
		[out, retval]long* value);
	[id(0x60010003), propget]
	HRESULT __stdcall AllowedCertificateAuthorities(
		[out, retval]ICoreWebView2StringCollection** value);
	[id(0x60010004), propget]
	HRESULT __stdcall MutuallyTrustedCertificates(
		[out, retval]ICoreWebView2ClientCertificateCollection** value);
	[id(0x60010005), propget]
	HRESULT __stdcall SelectedCertificate(
		[out, retval]ICoreWebView2ClientCertificate** value);
	[id(0x60010005), propput]
	HRESULT __stdcall SelectedCertificate(
		[in]ICoreWebView2ClientCertificate* value);
	[id(0x60010007), propget]
	HRESULT __stdcall Cancel(
		[out, retval]long* value);
	[id(0x60010007), propput]
	HRESULT __stdcall Cancel(
		[in]long value);
	[id(0x60010009), propget]
	HRESULT __stdcall Handled(
		[out, retval]long* value);
	[id(0x60010009), propput]
	HRESULT __stdcall Handled(
		[in]long value);
	[id(0x6001000b)]
	HRESULT __stdcall GetDeferral(
		[out, retval]ICoreWebView2Deferral** deferral);
};
```
'!
!ICoreWebView2ClientCertificateRequestedEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2ClientCertificateRequestedEventArgs methodsFor!

allowedCertificateAuthorities
	"Answer the <ICoreWebView2StringCollection> value of the 'AllowedCertificateAuthorities' property of the receiver."

	| answer |
	answer := ICoreWebView2StringCollection newPointer.
	self get_AllowedCertificateAuthorities: answer.
	^answer asObject!

cancel
	"Answer the <Boolean> value of the 'Cancel' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_Cancel: answer.
	^answer asObject!

cancel: cancel
	"Set the 'Cancel' property of the receiver to the <sdword> value of the argument."

	self put_Cancel: cancel asParameter!

get_AllowedCertificateAuthorities: value
	"Private - Get the value of the 'AllowedCertificateAuthorities' property of the receiver.

		HRESULT __stdcall AllowedCertificateAuthorities(
			[out, retval]ICoreWebView2StringCollection** value);"

	<virtual stdcall: hresult 7 ICoreWebView2StringCollection**>
	^self invalidCall: _failureCode!

get_Cancel: value
	"Private - Get the value of the 'Cancel' property of the receiver.

		HRESULT __stdcall Cancel(
			[out, retval]long* value);"

	<virtual stdcall: hresult 11 sdword*>
	^self invalidCall: _failureCode!

get_Handled: value
	"Private - Get the value of the 'Handled' property of the receiver.

		HRESULT __stdcall Handled(
			[out, retval]long* value);"

	<virtual stdcall: hresult 13 sdword*>
	^self invalidCall: _failureCode!

get_Host: value
	"Private - Get the value of the 'Host' property of the receiver.

		HRESULT __stdcall Host(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

get_IsProxy: value
	"Private - Get the value of the 'IsProxy' property of the receiver.

		HRESULT __stdcall IsProxy(
			[out, retval]long* value);"

	<virtual stdcall: hresult 6 sdword*>
	^self invalidCall: _failureCode!

get_MutuallyTrustedCertificates: value
	"Private - Get the value of the 'MutuallyTrustedCertificates' property of the receiver.

		HRESULT __stdcall MutuallyTrustedCertificates(
			[out, retval]ICoreWebView2ClientCertificateCollection** value);"

	<virtual stdcall: hresult 8 ICoreWebView2ClientCertificateCollection**>
	^self invalidCall: _failureCode!

get_Port: value
	"Private - Get the value of the 'Port' property of the receiver.

		HRESULT __stdcall Port(
			[out, retval]int* value);"

	<virtual stdcall: hresult 5 sdword*>
	^self invalidCall: _failureCode!

get_SelectedCertificate: value
	"Private - Get the value of the 'SelectedCertificate' property of the receiver.

		HRESULT __stdcall SelectedCertificate(
			[out, retval]ICoreWebView2ClientCertificate** value);"

	<virtual stdcall: hresult 9 ICoreWebView2ClientCertificate**>
	^self invalidCall: _failureCode!

getDeferral
	"Answer the <ICoreWebView2Deferral> result of invoking the GetDeferral() method of the COM object."

	| answer |
	answer := ICoreWebView2Deferral newPointer.
	self GetDeferral: answer.
	^answer asObject!

GetDeferral: deferral
	"Private - Invoke the GetDeferral() method of the COM object.

		HRESULT __stdcall GetDeferral(
			[out, retval]ICoreWebView2Deferral** deferral);"

	<virtual stdcall: hresult 15 ICoreWebView2Deferral**>
	^self invalidCall: _failureCode!

handled
	"Answer the <Boolean> value of the 'Handled' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_Handled: answer.
	^answer asObject!

handled: handled
	"Set the 'Handled' property of the receiver to the <sdword> value of the argument."

	self put_Handled: handled asParameter!

host
	"Answer the <lpwstr> value of the 'Host' property of the receiver."

	| ptr answer |
	ptr := COMTaskMemory new.
	self get_Host: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

isProxy
	"Answer the <Boolean> value of the 'IsProxy' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_IsProxy: answer.
	^answer asObject!

mutuallyTrustedCertificates
	"Answer the <ICoreWebView2ClientCertificateCollection> value of the 'MutuallyTrustedCertificates' property of the receiver."

	| answer |
	answer := ICoreWebView2ClientCertificateCollection newPointer.
	self get_MutuallyTrustedCertificates: answer.
	^answer asObject!

port
	"Answer the <sdword> value of the 'Port' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_Port: answer.
	^answer asObject!

printableProperties
	^#(#host #isProxy #selectedCertificate)!

put_Cancel: value
	"Private - Set the value of the 'Cancel' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall Cancel(
			[in]long value);"

	<virtual stdcall: hresult 12 sdword>
	^self invalidCall: _failureCode!

put_Handled: value
	"Private - Set the value of the 'Handled' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall Handled(
			[in]long value);"

	<virtual stdcall: hresult 14 sdword>
	^self invalidCall: _failureCode!

put_SelectedCertificate: value
	"Private - Set the value of the 'SelectedCertificate' property of the object wrapped by the 
	 receiver to the <ICoreWebView2ClientCertificate*> argument, value.

		HRESULT __stdcall SelectedCertificate(
			[in]ICoreWebView2ClientCertificate* value);"

	<virtual stdcall: hresult 10 ICoreWebView2ClientCertificate*>
	^self invalidCall: _failureCode!

selectedCertificate
	"Answer the <ICoreWebView2ClientCertificate> value of the 'SelectedCertificate' property of the receiver."

	| answer |
	answer := ICoreWebView2ClientCertificate newPointer.
	self get_SelectedCertificate: answer.
	^answer asObject!

selectedCertificate: value
	"Set the 'SelectedCertificate' property of the receiver to the <ICoreWebView2ClientCertificate*> value of the argument."

	self put_SelectedCertificate: value! !
!ICoreWebView2ClientCertificateRequestedEventArgs categoriesForMethods!
allowedCertificateAuthorities!**auto generated**!properties!public! !
cancel!properties!public! !
cancel:!properties!public! !
get_AllowedCertificateAuthorities:!**auto generated**!COM Interfaces-ICoreWebView2ClientCertificateRequestedEventArgs!private! !
get_Cancel:!**auto generated**!COM Interfaces-ICoreWebView2ClientCertificateRequestedEventArgs!private! !
get_Handled:!**auto generated**!COM Interfaces-ICoreWebView2ClientCertificateRequestedEventArgs!private! !
get_Host:!**auto generated**!COM Interfaces-ICoreWebView2ClientCertificateRequestedEventArgs!private! !
get_IsProxy:!**auto generated**!COM Interfaces-ICoreWebView2ClientCertificateRequestedEventArgs!private! !
get_MutuallyTrustedCertificates:!**auto generated**!COM Interfaces-ICoreWebView2ClientCertificateRequestedEventArgs!private! !
get_Port:!**auto generated**!COM Interfaces-ICoreWebView2ClientCertificateRequestedEventArgs!private! !
get_SelectedCertificate:!**auto generated**!COM Interfaces-ICoreWebView2ClientCertificateRequestedEventArgs!private! !
getDeferral!**auto generated**!methods!public! !
GetDeferral:!**auto generated**!COM Interfaces-ICoreWebView2ClientCertificateRequestedEventArgs!private! !
handled!properties!public! !
handled:!properties!public! !
host!properties!public! !
isProxy!**auto generated**!properties!public! !
mutuallyTrustedCertificates!**auto generated**!properties!public! !
port!**auto generated**!properties!public! !
printableProperties!development!printing!private! !
put_Cancel:!**auto generated**!COM Interfaces-ICoreWebView2ClientCertificateRequestedEventArgs!private! !
put_Handled:!**auto generated**!COM Interfaces-ICoreWebView2ClientCertificateRequestedEventArgs!private! !
put_SelectedCertificate:!**auto generated**!COM Interfaces-ICoreWebView2ClientCertificateRequestedEventArgs!private! !
selectedCertificate!**auto generated**!properties!public! !
selectedCertificate:!**auto generated**!properties!public! !
!

!ICoreWebView2ClientCertificateRequestedEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ClientCertificateRequestedEventArgs'
		ICoreWebView2ClientCertificateRequestedEventArgs defineTemplate"

	self
		defineFunction: #get_Host:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_Port:
			argumentTypes: 'sdword*';
		defineFunction: #get_IsProxy:
			argumentTypes: 'sdword*';
		defineFunction: #get_AllowedCertificateAuthorities:
			argumentTypes: 'ICoreWebView2StringCollection**';
		defineFunction: #get_MutuallyTrustedCertificates:
			argumentTypes: 'ICoreWebView2ClientCertificateCollection**';
		defineFunction: #get_SelectedCertificate:
			argumentTypes: 'ICoreWebView2ClientCertificate**';
		defineFunction: #put_SelectedCertificate:
			argumentTypes: 'ICoreWebView2ClientCertificate*';
		defineFunction: #get_Cancel:
			argumentTypes: 'sdword*';
		defineFunction: #put_Cancel:
			argumentTypes: 'sdword';
		defineFunction: #get_Handled:
			argumentTypes: 'sdword*';
		defineFunction: #put_Handled:
			argumentTypes: 'sdword';
		defineFunction: #GetDeferral:
			argumentTypes: 'ICoreWebView2Deferral**'
! !
!ICoreWebView2ClientCertificateRequestedEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

