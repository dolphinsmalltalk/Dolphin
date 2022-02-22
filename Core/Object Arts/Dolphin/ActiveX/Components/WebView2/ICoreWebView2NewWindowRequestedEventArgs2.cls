"Filed out from Dolphin Smalltalk"!

ICoreWebView2NewWindowRequestedEventArgs subclass: #ICoreWebView2NewWindowRequestedEventArgs2
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Smalltalk.WebView2Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
ICoreWebView2NewWindowRequestedEventArgs2 guid: (OS.COM.IID fromString: '{bbc7baed-74c6-4c92-b63a-7f5aeae03de3}')!
ICoreWebView2NewWindowRequestedEventArgs2 comment: '`ICoreWebView2NewWindowRequestedEventArgs2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2NewWindowRequestedEventArgs2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(bbc7baed-74c6-4c92-b63a-7f5aeae03de3)
]
interface ICoreWebView2NewWindowRequestedEventArgs2 : ICoreWebView2NewWindowRequestedEventArgs
 {
	[id(0x60020000), propget]
	HRESULT __stdcall name(
		[out, retval]LPWSTR* value);
};
```
'!
!ICoreWebView2NewWindowRequestedEventArgs2 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2NewWindowRequestedEventArgs2 methodsFor!

get_name: value
	"Private - Get the value of the 'name' property of the receiver.

		HRESULT __stdcall name(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 12 lpwstr*>
	^self invalidCall: _failureCode!

name
	"Answer the <lpwstr> value of the 'name' property of the receiver."

	| ptr answer |
	ptr := COMTaskMemory new.
	self get_name: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer! !
!ICoreWebView2NewWindowRequestedEventArgs2 categoriesForMethods!
get_name:!**auto generated**!COM Interfaces-ICoreWebView2NewWindowRequestedEventArgs2!private! !
name!properties!public! !
!

!ICoreWebView2NewWindowRequestedEventArgs2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2NewWindowRequestedEventArgs2'
		ICoreWebView2NewWindowRequestedEventArgs2 defineTemplate"

	self
		defineFunction: #get_name:
			argumentTypes: 'lpwstr*'
! !
!ICoreWebView2NewWindowRequestedEventArgs2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

