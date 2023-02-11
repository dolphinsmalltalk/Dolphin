"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2PermissionRequestedEventArgs subclass: #'WebView2.ICoreWebView2PermissionRequestedEventArgs2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2PermissionRequestedEventArgs2 guid: (OS.COM.IID fromString: '{74d7127f-9de6-4200-8734-42d6fb4ff741}')!
WebView2.ICoreWebView2PermissionRequestedEventArgs2 comment: '`ICoreWebView2PermissionRequestedEventArgs2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2PermissionRequestedEventArgs2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(74d7127f-9de6-4200-8734-42d6fb4ff741)
]
interface ICoreWebView2PermissionRequestedEventArgs2 : ICoreWebView2PermissionRequestedEventArgs
 {
	[id(0x60020000), propget]
	HRESULT __stdcall Handled(
		[out, retval]long* Handled);
	[id(0x60020000), propput]
	HRESULT __stdcall Handled(
		[in]long Handled);
};
```
'!
!WebView2.ICoreWebView2PermissionRequestedEventArgs2 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2PermissionRequestedEventArgs2 methodsFor!

get_Handled: handled
	"Private - Get the value of the 'Handled' property of the receiver.

		HRESULT __stdcall Handled(
			[out, retval]long* Handled);"

	<virtual stdcall: hresult 10 int32*>
	^self invalidCall: _failureCode!

handled
	"Answer the <sdword> value of the 'Handled' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_Handled: answer.
	^answer asObject!

handled: handled
	"Set the 'Handled' property of the receiver to the <sdword> value of the argument."

	self put_Handled: handled!

put_Handled: handled
	"Private - Set the value of the 'Handled' property of the object wrapped by the 
	 receiver to the <sdword> argument, handled.

		HRESULT __stdcall Handled(
			[in]long Handled);"

	<virtual stdcall: hresult 11 int32>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2PermissionRequestedEventArgs2 categoriesForMethods!
get_Handled:!**auto generated**!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs2!private! !
handled!**auto generated**!properties!public! !
handled:!**auto generated**!properties!public! !
put_Handled:!**auto generated**!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs2!private! !
!

!WebView2.ICoreWebView2PermissionRequestedEventArgs2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2PermissionRequestedEventArgs2'
		ICoreWebView2PermissionRequestedEventArgs2 defineTemplate"

	self
		defineFunction: #get_Handled:
			argumentTypes: 'sdword*';
		defineFunction: #put_Handled:
			argumentTypes: 'sdword'
! !
!WebView2.ICoreWebView2PermissionRequestedEventArgs2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

