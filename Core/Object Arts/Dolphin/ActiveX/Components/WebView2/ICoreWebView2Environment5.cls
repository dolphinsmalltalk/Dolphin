"Filed out from Dolphin Smalltalk"!

ICoreWebView2Environment4 subclass: #ICoreWebView2Environment5
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2Environment5 guid: (IID fromString: '{319e423d-e0d7-4b8d-9254-ae9475de9b17}')!
ICoreWebView2Environment5 comment: '`ICoreWebView2Environment5` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Environment5'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(319e423d-e0d7-4b8d-9254-ae9475de9b17)
]
interface ICoreWebView2Environment5 : ICoreWebView2Environment4
 {
	[id(0x60050000)]
	HRESULT __stdcall add_BrowserProcessExited(
		[in]ICoreWebView2BrowserProcessExitedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60050001)]
	HRESULT __stdcall remove_BrowserProcessExited(
		[in]EventRegistrationToken token);
};
```
'!
!ICoreWebView2Environment5 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2Environment5 methodsFor!

Add_BrowserProcessExited: eventHandler token: token
	"Private - Invoke the add_BrowserProcessExited() method of the COM object.

		HRESULT __stdcall add_BrowserProcessExited(
			[in]ICoreWebView2BrowserProcessExitedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 13 ICoreWebView2BrowserProcessExitedEventHandler* sqword*>
	^self invalidCall: _failureCode!

Remove_BrowserProcessExited: token
	"Private - Invoke the remove_BrowserProcessExited() method of the COM object.

		HRESULT __stdcall remove_BrowserProcessExited(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 14 sqword>
	^self invalidCall: _failureCode! !
!ICoreWebView2Environment5 categoriesForMethods!
Add_BrowserProcessExited:token:!**auto generated**!COM Interfaces-ICoreWebView2Environment5!private! !
Remove_BrowserProcessExited:!**auto generated**!COM Interfaces-ICoreWebView2Environment5!private! !
!

!ICoreWebView2Environment5 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Environment5'
		ICoreWebView2Environment5 defineTemplate"

	self
		defineFunction: #Add_BrowserProcessExited:token:
			argumentTypes: 'ICoreWebView2BrowserProcessExitedEventHandler* sqword*';
		defineFunction: #Remove_BrowserProcessExited:
			argumentTypes: 'sqword'
! !
!ICoreWebView2Environment5 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

