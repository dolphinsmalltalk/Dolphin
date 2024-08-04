"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2EnvironmentOptions8'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2EnvironmentOptions8 guid: (OS.COM.IID fromString: '{7c7ecf51-e918-5caf-853c-e9a2bcc27775}')!

WebView2.ICoreWebView2EnvironmentOptions8 comment: '`ICoreWebView2EnvironmentOptions8` is a wrapper class for the COM interface ''WebView2.ICoreWebView2EnvironmentOptions8'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(7c7ecf51-e918-5caf-853c-e9a2bcc27775)
]
interface ICoreWebView2EnvironmentOptions8 : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall ScrollBarStyle(
		[out, retval]COREWEBVIEW2_SCROLLBAR_STYLE* value);
	[id(0x60010000), propput]
	HRESULT __stdcall ScrollBarStyle(
		[in]COREWEBVIEW2_SCROLLBAR_STYLE value);
};
```
'!

!WebView2.ICoreWebView2EnvironmentOptions8 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2EnvironmentOptions8 methodsFor!

get_ScrollBarStyle: value
	"Private - Get the value of the 'ScrollBarStyle' property of the receiver.

		HRESULT __stdcall ScrollBarStyle(
			[out, retval]COREWEBVIEW2_SCROLLBAR_STYLE* value);"

	<virtual stdcall: hresult 4 int32*>
	^self invalidCall: _failureCode!

put_ScrollBarStyle: value
	"Private - Set the value of the 'ScrollBarStyle' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall ScrollBarStyle(
			[in]COREWEBVIEW2_SCROLLBAR_STYLE value);"

	<virtual stdcall: hresult 5 int32>
	^self invalidCall: _failureCode!

scrollBarStyle
	"Answer the <int32> value of the 'ScrollBarStyle' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_ScrollBarStyle: answer.
	^answer asObject!

scrollBarStyle: value
	"Set the 'ScrollBarStyle' property of the receiver to the <int32> value of the argument."

	self put_ScrollBarStyle: value! !

!WebView2.ICoreWebView2EnvironmentOptions8 categoriesForMethods!
get_ScrollBarStyle:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions8!private! !
put_ScrollBarStyle:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions8!private! !
scrollBarStyle!**auto generated**!properties!public! !
scrollBarStyle:!**auto generated**!properties!public! !
!

WebView2.ICoreWebView2EnvironmentOptions8 methodProtocol: #ICoreWebView2EnvironmentOptions8 attributes: #(#readOnly) selectors: #(#get_ScrollBarStyle: #put_ScrollBarStyle:)!

!WebView2.ICoreWebView2EnvironmentOptions8 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2EnvironmentOptions8'
		ICoreWebView2EnvironmentOptions8 defineTemplate"

	self
		defineFunction: #get_ScrollBarStyle:
			argumentTypes: 'int32*';
		defineFunction: #put_ScrollBarStyle:
			argumentTypes: 'int32'
! !

!WebView2.ICoreWebView2EnvironmentOptions8 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

