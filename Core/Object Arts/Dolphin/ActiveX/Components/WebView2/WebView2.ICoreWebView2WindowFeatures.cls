"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2WindowFeatures'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2WindowFeatures guid: (OS.COM.IID fromString: '{5eaf559f-b46e-4397-8860-e422f287ff1e}')!
WebView2.ICoreWebView2WindowFeatures comment: '`ICoreWebView2WindowFeatures` is a wrapper class for the COM interface ''WebView2.ICoreWebView2WindowFeatures'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(5eaf559f-b46e-4397-8860-e422f287ff1e)
]
interface ICoreWebView2WindowFeatures : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall HasPosition(
		[out, retval]long* value);
	[id(0x60010001), propget]
	HRESULT __stdcall HasSize(
		[out, retval]long* value);
	[id(0x60010002), propget]
	HRESULT __stdcall left(
		[out, retval]unsigned int* value);
	[id(0x60010003), propget]
	HRESULT __stdcall top(
		[out, retval]unsigned int* value);
	[id(0x60010004), propget]
	HRESULT __stdcall Height(
		[out, retval]unsigned int* value);
	[id(0x60010005), propget]
	HRESULT __stdcall Width(
		[out, retval]unsigned int* value);
	[id(0x60010006), propget]
	HRESULT __stdcall ShouldDisplayMenuBar(
		[out, retval]long* value);
	[id(0x60010007), propget]
	HRESULT __stdcall ShouldDisplayStatus(
		[out, retval]long* value);
	[id(0x60010008), propget]
	HRESULT __stdcall ShouldDisplayToolbar(
		[out, retval]long* value);
	[id(0x60010009), propget]
	HRESULT __stdcall ShouldDisplayScrollBars(
		[out, retval]long* value);
};
```
'!
!WebView2.ICoreWebView2WindowFeatures categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2WindowFeatures methodsFor!

extent
	^self width @ self height!

get_HasPosition: value
	"Private - Get the value of the 'HasPosition' property of the receiver.

		HRESULT __stdcall HasPosition(
			[out, retval]long* value);"

	<virtual stdcall: hresult 4 int32*>
	^self invalidCall: _failureCode!

get_HasSize: value
	"Private - Get the value of the 'HasSize' property of the receiver.

		HRESULT __stdcall HasSize(
			[out, retval]long* value);"

	<virtual stdcall: hresult 5 int32*>
	^self invalidCall: _failureCode!

get_Height: value
	"Private - Get the value of the 'Height' property of the receiver.

		HRESULT __stdcall Height(
			[out, retval]unsigned int* value);"

	<virtual stdcall: hresult 8 uint32*>
	^self invalidCall: _failureCode!

get_left: value
	"Private - Get the value of the 'left' property of the receiver.

		HRESULT __stdcall left(
			[out, retval]unsigned int* value);"

	<virtual stdcall: hresult 6 uint32*>
	^self invalidCall: _failureCode!

get_ShouldDisplayMenuBar: value
	"Private - Get the value of the 'ShouldDisplayMenuBar' property of the receiver.

		HRESULT __stdcall ShouldDisplayMenuBar(
			[out, retval]long* value);"

	<virtual stdcall: hresult 10 int32*>
	^self invalidCall: _failureCode!

get_ShouldDisplayScrollBars: value
	"Private - Get the value of the 'ShouldDisplayScrollBars' property of the receiver.

		HRESULT __stdcall ShouldDisplayScrollBars(
			[out, retval]long* value);"

	<virtual stdcall: hresult 13 int32*>
	^self invalidCall: _failureCode!

get_ShouldDisplayStatus: value
	"Private - Get the value of the 'ShouldDisplayStatus' property of the receiver.

		HRESULT __stdcall ShouldDisplayStatus(
			[out, retval]long* value);"

	<virtual stdcall: hresult 11 int32*>
	^self invalidCall: _failureCode!

get_ShouldDisplayToolbar: value
	"Private - Get the value of the 'ShouldDisplayToolbar' property of the receiver.

		HRESULT __stdcall ShouldDisplayToolbar(
			[out, retval]long* value);"

	<virtual stdcall: hresult 12 int32*>
	^self invalidCall: _failureCode!

get_top: value
	"Private - Get the value of the 'top' property of the receiver.

		HRESULT __stdcall top(
			[out, retval]unsigned int* value);"

	<virtual stdcall: hresult 7 uint32*>
	^self invalidCall: _failureCode!

get_Width: value
	"Private - Get the value of the 'Width' property of the receiver.

		HRESULT __stdcall Width(
			[out, retval]unsigned int* value);"

	<virtual stdcall: hresult 9 uint32*>
	^self invalidCall: _failureCode!

hasPosition
	"Answer the <Boolean> value of the 'HasPosition' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_HasPosition: buf.
	^buf asBoolean!

hasSize
	"Answer the <Boolean> value of the 'HasSize' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_HasSize: buf.
	^buf asBoolean!

height
	"Answer the <dword> value of the 'Height' property of the receiver."

	| answer |
	answer := UInt32 new.
	self get_Height: answer.
	^answer asObject!

left
	"Answer the <dword> value of the 'left' property of the receiver."

	| answer |
	answer := UInt32 new.
	self get_left: answer.
	^answer asObject!

position
	^self left @ self top!

printableProperties
	| propertyNames |
	propertyNames := OrderedCollection new: 6.
	self hasPosition ifTrue: [propertyNames add: #position].
	self hasSize ifTrue: [propertyNames add: #extent].
	propertyNames
		addAll: #(#shouldDisplayMenuBar #shouldDisplayScrollBars #shouldDisplayStatus #shouldDisplayToolbar).
	^propertyNames!

shouldDisplayMenuBar
	"Answer the <Boolean> value of the 'ShouldDisplayMenuBar' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_ShouldDisplayMenuBar: buf.
	^buf asBoolean!

shouldDisplayScrollBars
	"Answer the <Boolean> value of the 'ShouldDisplayScrollBars' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_ShouldDisplayScrollBars: buf.
	^buf asBoolean!

shouldDisplayStatus
	"Answer the <Boolean> value of the 'ShouldDisplayStatus' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_ShouldDisplayStatus: buf.
	^buf asBoolean!

shouldDisplayToolbar
	"Answer the <Boolean> value of the 'ShouldDisplayToolbar' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_ShouldDisplayToolbar: buf.
	^buf asBoolean!

top
	"Answer the <dword> value of the 'top' property of the receiver."

	| answer |
	answer := UInt32 new.
	self get_top: answer.
	^answer asObject!

width
	"Answer the <dword> value of the 'Width' property of the receiver."

	| answer |
	answer := UInt32 new.
	self get_Width: answer.
	^answer asObject! !
!WebView2.ICoreWebView2WindowFeatures categoriesForMethods!
extent!properties!public! !
get_HasPosition:!**auto generated**!COM Interfaces-ICoreWebView2WindowFeatures!private! !
get_HasSize:!**auto generated**!COM Interfaces-ICoreWebView2WindowFeatures!private! !
get_Height:!**auto generated**!COM Interfaces-ICoreWebView2WindowFeatures!private! !
get_left:!**auto generated**!COM Interfaces-ICoreWebView2WindowFeatures!private! !
get_ShouldDisplayMenuBar:!**auto generated**!COM Interfaces-ICoreWebView2WindowFeatures!private! !
get_ShouldDisplayScrollBars:!**auto generated**!COM Interfaces-ICoreWebView2WindowFeatures!private! !
get_ShouldDisplayStatus:!**auto generated**!COM Interfaces-ICoreWebView2WindowFeatures!private! !
get_ShouldDisplayToolbar:!**auto generated**!COM Interfaces-ICoreWebView2WindowFeatures!private! !
get_top:!**auto generated**!COM Interfaces-ICoreWebView2WindowFeatures!private! !
get_Width:!**auto generated**!COM Interfaces-ICoreWebView2WindowFeatures!private! !
hasPosition!properties!public! !
hasSize!properties!public! !
height!**auto generated**!properties!public! !
left!**auto generated**!properties!public! !
position!properties!public! !
printableProperties!printing!private! !
shouldDisplayMenuBar!properties!public! !
shouldDisplayScrollBars!properties!public! !
shouldDisplayStatus!properties!public! !
shouldDisplayToolbar!properties!public! !
top!**auto generated**!properties!public! !
width!**auto generated**!properties!public! !
!

!WebView2.ICoreWebView2WindowFeatures class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2WindowFeatures'
		ICoreWebView2WindowFeatures defineTemplate"

	self
		defineFunction: #get_HasPosition:
			argumentTypes: 'sdword*';
		defineFunction: #get_HasSize:
			argumentTypes: 'sdword*';
		defineFunction: #get_left:
			argumentTypes: 'dword*';
		defineFunction: #get_top:
			argumentTypes: 'dword*';
		defineFunction: #get_Height:
			argumentTypes: 'dword*';
		defineFunction: #get_Width:
			argumentTypes: 'dword*';
		defineFunction: #get_ShouldDisplayMenuBar:
			argumentTypes: 'sdword*';
		defineFunction: #get_ShouldDisplayStatus:
			argumentTypes: 'sdword*';
		defineFunction: #get_ShouldDisplayToolbar:
			argumentTypes: 'sdword*';
		defineFunction: #get_ShouldDisplayScrollBars:
			argumentTypes: 'sdword*'
! !
!WebView2.ICoreWebView2WindowFeatures class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

