"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2EnvironmentOptions5'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2EnvironmentOptions5 guid: (OS.COM.IID fromString: '{0ae35d64-c47f-4464-814e-259c345d1501}')!

WebView2.ICoreWebView2EnvironmentOptions5 comment: '`ICoreWebView2EnvironmentOptions5` is a wrapper class for the COM interface ''WebView2.ICoreWebView2EnvironmentOptions5'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(0ae35d64-c47f-4464-814e-259c345d1501)
]
interface ICoreWebView2EnvironmentOptions5 : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall EnableTrackingPrevention(
		[out, retval]long* value);
	[id(0x60010000), propput]
	HRESULT __stdcall EnableTrackingPrevention(
		[in]long value);
};
```
'!

!WebView2.ICoreWebView2EnvironmentOptions5 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2EnvironmentOptions5 methodsFor!

enableTrackingPrevention
	"Answer the <Boolean> value of the 'EnableTrackingPrevention' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_EnableTrackingPrevention: buf.
	^buf asBoolean!

enableTrackingPrevention: aBoolean
	"Set the 'EnableTrackingPrevention' property of the receiver to the <int32> value of the argument."

	self put_EnableTrackingPrevention: aBoolean asParameter!

get_EnableTrackingPrevention: value
	"Private - Get the value of the 'EnableTrackingPrevention' property of the receiver.

		HRESULT __stdcall EnableTrackingPrevention(
			[out, retval]long* value);"

	<virtual stdcall: hresult 4 int32*>
	^self invalidCall: _failureCode!

put_EnableTrackingPrevention: value
	"Private - Set the value of the 'EnableTrackingPrevention' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall EnableTrackingPrevention(
			[in]long value);"

	<virtual stdcall: hresult 5 int32>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2EnvironmentOptions5 categoriesForMethods!
enableTrackingPrevention!properties!public! !
enableTrackingPrevention:!properties!public! !
get_EnableTrackingPrevention:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions5!private! !
put_EnableTrackingPrevention:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions5!private! !
!

WebView2.ICoreWebView2EnvironmentOptions5 methodProtocol: #ICoreWebView2EnvironmentOptions5 attributes: #(#readOnly) selectors: #(#get_EnableTrackingPrevention: #put_EnableTrackingPrevention:)!

!WebView2.ICoreWebView2EnvironmentOptions5 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2EnvironmentOptions5'
		ICoreWebView2EnvironmentOptions5 defineTemplate"

	self
		defineFunction: #get_EnableTrackingPrevention:
			argumentTypes: 'int32*';
		defineFunction: #put_EnableTrackingPrevention:
			argumentTypes: 'int32'
! !

!WebView2.ICoreWebView2EnvironmentOptions5 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

