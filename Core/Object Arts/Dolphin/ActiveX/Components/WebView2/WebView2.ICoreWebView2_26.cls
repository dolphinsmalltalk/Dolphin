"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2_25
	subclass: #'WebView2.ICoreWebView2_26'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2_26 guid: (OS.COM.IID fromString: '{806268b8-f897-5685-88e5-c45fca0b1a48}')!

WebView2.ICoreWebView2_26 comment: '`ICoreWebView2_26` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_26'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(806268b8-f897-5685-88e5-c45fca0b1a48)
]
interface ICoreWebView2_26 : ICoreWebView2_25
 {
	[id(0x601a0000)]
	HRESULT __stdcall add_SaveFileSecurityCheckStarting(
		[in]ICoreWebView2SaveFileSecurityCheckStartingEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x601a0001)]
	HRESULT __stdcall remove_SaveFileSecurityCheckStarting(
		[in]EventRegistrationToken token);
};
```
'!

!WebView2.ICoreWebView2_26 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2_26 methodsFor!

Add_SaveFileSecurityCheckStarting: eventHandler token: token
	"Private - Invoke the add_SaveFileSecurityCheckStarting() method of the COM object.

		HRESULT __stdcall add_SaveFileSecurityCheckStarting(
			[in]ICoreWebView2SaveFileSecurityCheckStartingEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 132 ICoreWebView2SaveFileSecurityCheckStartingEventHandler* int64*>
	^self invalidCall: _failureCode!

Remove_SaveFileSecurityCheckStarting: token
	"Private - Invoke the remove_SaveFileSecurityCheckStarting() method of the COM object.

		HRESULT __stdcall remove_SaveFileSecurityCheckStarting(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 133 int64>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2_26 categoriesForMethods!
Add_SaveFileSecurityCheckStarting:token:!**auto generated**!COM Interfaces-ICoreWebView2_26!private! !
Remove_SaveFileSecurityCheckStarting:!**auto generated**!COM Interfaces-ICoreWebView2_26!private! !
!

!WebView2.ICoreWebView2_26 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_26'
		ICoreWebView2_26 defineTemplate"

	self
		defineFunction: #Add_SaveFileSecurityCheckStarting:token:
			argumentTypes: 'ICoreWebView2SaveFileSecurityCheckStartingEventHandler* int64*';
		defineFunction: #Remove_SaveFileSecurityCheckStarting:
			argumentTypes: 'int64'
! !

!WebView2.ICoreWebView2_26 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

