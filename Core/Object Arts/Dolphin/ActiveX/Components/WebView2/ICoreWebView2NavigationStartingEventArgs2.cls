"Filed out from Dolphin Smalltalk"!

ICoreWebView2NavigationStartingEventArgs subclass: #ICoreWebView2NavigationStartingEventArgs2
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Smalltalk.WebView2Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
ICoreWebView2NavigationStartingEventArgs2 guid: (OS.COM.IID fromString: '{9086be93-91aa-472d-a7e0-579f2ba006ad}')!
ICoreWebView2NavigationStartingEventArgs2 comment: '`ICoreWebView2NavigationStartingEventArgs2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2NavigationStartingEventArgs2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(9086be93-91aa-472d-a7e0-579f2ba006ad)
]
interface ICoreWebView2NavigationStartingEventArgs2 : ICoreWebView2NavigationStartingEventArgs
 {
	[id(0x60020000), propget]
	HRESULT __stdcall AdditionalAllowedFrameAncestors(
		[out, retval]LPWSTR* value);
	[id(0x60020000), propput]
	HRESULT __stdcall AdditionalAllowedFrameAncestors(
		[in]LPWSTR value);
};
```
'!
!ICoreWebView2NavigationStartingEventArgs2 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2NavigationStartingEventArgs2 methodsFor!

additionalAllowedFrameAncestors
	"Answer the <lpwstr> value of the 'AdditionalAllowedFrameAncestors' property of the receiver."

	| ptr answer |
	ptr := COMTaskMemory new.
	self get_AdditionalAllowedFrameAncestors: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

additionalAllowedFrameAncestors: value
	"Set the 'AdditionalAllowedFrameAncestors' property of the receiver to the <lpwstr> value of the argument."

	self put_AdditionalAllowedFrameAncestors: value asUtf16String!

get_AdditionalAllowedFrameAncestors: value
	"Private - Get the value of the 'AdditionalAllowedFrameAncestors' property of the receiver.

		HRESULT __stdcall AdditionalAllowedFrameAncestors(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 11 lpwstr*>
	^self invalidCall: _failureCode!

put_AdditionalAllowedFrameAncestors: value
	"Private - Set the value of the 'AdditionalAllowedFrameAncestors' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, value.

		HRESULT __stdcall AdditionalAllowedFrameAncestors(
			[in]LPWSTR value);"

	<virtual stdcall: hresult 12 lpwstr>
	^self invalidCall: _failureCode! !
!ICoreWebView2NavigationStartingEventArgs2 categoriesForMethods!
additionalAllowedFrameAncestors!properties!public! !
additionalAllowedFrameAncestors:!**auto generated**!properties!public! !
get_AdditionalAllowedFrameAncestors:!**auto generated**!COM Interfaces-ICoreWebView2NavigationStartingEventArgs2!private! !
put_AdditionalAllowedFrameAncestors:!**auto generated**!COM Interfaces-ICoreWebView2NavigationStartingEventArgs2!private! !
!

!ICoreWebView2NavigationStartingEventArgs2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2NavigationStartingEventArgs2'
		ICoreWebView2NavigationStartingEventArgs2 defineTemplate"

	self
		defineFunction: #get_AdditionalAllowedFrameAncestors:
			argumentTypes: 'lpwstr*';
		defineFunction: #put_AdditionalAllowedFrameAncestors:
			argumentTypes: 'lpwstr'
! !
!ICoreWebView2NavigationStartingEventArgs2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

