"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2BasicAuthenticationResponse'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2BasicAuthenticationResponse guid: (OS.COM.IID fromString: '{07023f7d-2d77-4d67-9040-6e7d428c6a40}')!
WebView2.ICoreWebView2BasicAuthenticationResponse comment: '`ICoreWebView2BasicAuthenticationResponse` is a wrapper class for the COM interface ''WebView2.ICoreWebView2BasicAuthenticationResponse'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(07023f7d-2d77-4d67-9040-6e7d428c6a40)
]
interface ICoreWebView2BasicAuthenticationResponse : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall UserName(
		[out, retval]LPWSTR* UserName);
	[id(0x60010000), propput]
	HRESULT __stdcall UserName(
		[in]LPWSTR UserName);
	[id(0x60010002), propget]
	HRESULT __stdcall Password(
		[out, retval]LPWSTR* Password);
	[id(0x60010002), propput]
	HRESULT __stdcall Password(
		[in]LPWSTR Password);
};
```
'!
!WebView2.ICoreWebView2BasicAuthenticationResponse categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2BasicAuthenticationResponse methodsFor!

get_Password: password
	"Private - Get the value of the 'Password' property of the receiver.

		HRESULT __stdcall Password(
			[out, retval]LPWSTR* Password);"

	<virtual stdcall: hresult 6 lpwstr*>
	^self invalidCall: _failureCode!

get_UserName: userName
	"Private - Get the value of the 'UserName' property of the receiver.

		HRESULT __stdcall UserName(
			[out, retval]LPWSTR* UserName);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

password
	"Answer the <lpwstr> value of the 'Password' property of the receiver."

	"The auto-generated code is functionally correct, but this code is slightly more efficient; in particular it avoids generating finalizable garbage."

	| ptr answer |
	ptr := TaskMemory new.
	self get_Password: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

password: password
	"Set the 'Password' property of the receiver to the <lpwstr> value of the argument."

	self put_Password: password asUtf16String!

printableProperties
	"We obviously don't want to print out the password in diagnostic output"

	^#(#userName)!

put_Password: password
	"Private - Set the value of the 'Password' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, password.

		HRESULT __stdcall Password(
			[in]LPWSTR Password);"

	<virtual stdcall: hresult 7 lpwstr>
	^self invalidCall: _failureCode!

put_UserName: userName
	"Private - Set the value of the 'UserName' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, userName.

		HRESULT __stdcall UserName(
			[in]LPWSTR UserName);"

	<virtual stdcall: hresult 5 lpwstr>
	^self invalidCall: _failureCode!

userName
	"Answer the <lpwstr> value of the 'UserName' property of the receiver."

	"The auto-generated code is functionally correct, but this code is slightly more efficient; in particular it avoids generating finalizable garbage."

	| ptr answer |
	ptr := TaskMemory new.
	self get_UserName: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

userName: userName
	"Set the 'UserName' property of the receiver to the <lpwstr> value of the argument."

	self put_UserName: userName asUtf16String! !
!WebView2.ICoreWebView2BasicAuthenticationResponse categoriesForMethods!
get_Password:!**auto generated**!COM Interfaces-ICoreWebView2BasicAuthenticationResponse!private! !
get_UserName:!**auto generated**!COM Interfaces-ICoreWebView2BasicAuthenticationResponse!private! !
password!properties!public! !
password:!**auto generated**!properties!public! !
printableProperties!printing!private! !
put_Password:!**auto generated**!COM Interfaces-ICoreWebView2BasicAuthenticationResponse!private! !
put_UserName:!**auto generated**!COM Interfaces-ICoreWebView2BasicAuthenticationResponse!private! !
userName!properties!public! !
userName:!**auto generated**!properties!public! !
!

!WebView2.ICoreWebView2BasicAuthenticationResponse class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2BasicAuthenticationResponse'
		ICoreWebView2BasicAuthenticationResponse defineTemplate"

	self
		defineFunction: #get_UserName:
			argumentTypes: 'lpwstr*';
		defineFunction: #put_UserName:
			argumentTypes: 'lpwstr';
		defineFunction: #get_Password:
			argumentTypes: 'lpwstr*';
		defineFunction: #put_Password:
			argumentTypes: 'lpwstr'
! !
!WebView2.ICoreWebView2BasicAuthenticationResponse class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

