"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2WindowFeatures'
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

get_HasPosition: value
	"Private - Get the value of the 'HasPosition' property of the receiver.

		HRESULT __stdcall HasPosition(
			[out, retval]long* value);"

	<virtual stdcall: hresult 4 sdword*>
	^self invalidCall: _failureCode!

get_HasSize: value
	"Private - Get the value of the 'HasSize' property of the receiver.

		HRESULT __stdcall HasSize(
			[out, retval]long* value);"

	<virtual stdcall: hresult 5 sdword*>
	^self invalidCall: _failureCode!

get_Height: value
	"Private - Get the value of the 'Height' property of the receiver.

		HRESULT __stdcall Height(
			[out, retval]unsigned int* value);"

	<virtual stdcall: hresult 8 dword*>
	^self invalidCall: _failureCode!

get_left: value
	"Private - Get the value of the 'left' property of the receiver.

		HRESULT __stdcall left(
			[out, retval]unsigned int* value);"

	<virtual stdcall: hresult 6 dword*>
	^self invalidCall: _failureCode!

get_ShouldDisplayMenuBar: value
	"Private - Get the value of the 'ShouldDisplayMenuBar' property of the receiver.

		HRESULT __stdcall ShouldDisplayMenuBar(
			[out, retval]long* value);"

	<virtual stdcall: hresult 10 sdword*>
	^self invalidCall: _failureCode!

get_ShouldDisplayScrollBars: value
	"Private - Get the value of the 'ShouldDisplayScrollBars' property of the receiver.

		HRESULT __stdcall ShouldDisplayScrollBars(
			[out, retval]long* value);"

	<virtual stdcall: hresult 13 sdword*>
	^self invalidCall: _failureCode!

get_ShouldDisplayStatus: value
	"Private - Get the value of the 'ShouldDisplayStatus' property of the receiver.

		HRESULT __stdcall ShouldDisplayStatus(
			[out, retval]long* value);"

	<virtual stdcall: hresult 11 sdword*>
	^self invalidCall: _failureCode!

get_ShouldDisplayToolbar: value
	"Private - Get the value of the 'ShouldDisplayToolbar' property of the receiver.

		HRESULT __stdcall ShouldDisplayToolbar(
			[out, retval]long* value);"

	<virtual stdcall: hresult 12 sdword*>
	^self invalidCall: _failureCode!

get_top: value
	"Private - Get the value of the 'top' property of the receiver.

		HRESULT __stdcall top(
			[out, retval]unsigned int* value);"

	<virtual stdcall: hresult 7 dword*>
	^self invalidCall: _failureCode!

get_Width: value
	"Private - Get the value of the 'Width' property of the receiver.

		HRESULT __stdcall Width(
			[out, retval]unsigned int* value);"

	<virtual stdcall: hresult 9 dword*>
	^self invalidCall: _failureCode!

hasPosition
	"Answer the <sdword> value of the 'HasPosition' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_HasPosition: answer.
	^answer asObject!

hasSize
	"Answer the <sdword> value of the 'HasSize' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_HasSize: answer.
	^answer asObject!

height
	"Answer the <dword> value of the 'Height' property of the receiver."

	| answer |
	answer := DWORD new.
	self get_Height: answer.
	^answer asObject!

left
	"Answer the <dword> value of the 'left' property of the receiver."

	| answer |
	answer := DWORD new.
	self get_left: answer.
	^answer asObject!

shouldDisplayMenuBar
	"Answer the <sdword> value of the 'ShouldDisplayMenuBar' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_ShouldDisplayMenuBar: answer.
	^answer asObject!

shouldDisplayScrollBars
	"Answer the <sdword> value of the 'ShouldDisplayScrollBars' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_ShouldDisplayScrollBars: answer.
	^answer asObject!

shouldDisplayStatus
	"Answer the <sdword> value of the 'ShouldDisplayStatus' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_ShouldDisplayStatus: answer.
	^answer asObject!

shouldDisplayToolbar
	"Answer the <sdword> value of the 'ShouldDisplayToolbar' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_ShouldDisplayToolbar: answer.
	^answer asObject!

top
	"Answer the <dword> value of the 'top' property of the receiver."

	| answer |
	answer := DWORD new.
	self get_top: answer.
	^answer asObject!

width
	"Answer the <dword> value of the 'Width' property of the receiver."

	| answer |
	answer := DWORD new.
	self get_Width: answer.
	^answer asObject! !
!WebView2.ICoreWebView2WindowFeatures categoriesFor: #get_HasPosition:!**auto generated**!COM Interfaces-ICoreWebView2WindowFeatures!private! !
!WebView2.ICoreWebView2WindowFeatures categoriesFor: #get_HasSize:!**auto generated**!COM Interfaces-ICoreWebView2WindowFeatures!private! !
!WebView2.ICoreWebView2WindowFeatures categoriesFor: #get_Height:!**auto generated**!COM Interfaces-ICoreWebView2WindowFeatures!private! !
!WebView2.ICoreWebView2WindowFeatures categoriesFor: #get_left:!**auto generated**!COM Interfaces-ICoreWebView2WindowFeatures!private! !
!WebView2.ICoreWebView2WindowFeatures categoriesFor: #get_ShouldDisplayMenuBar:!**auto generated**!COM Interfaces-ICoreWebView2WindowFeatures!private! !
!WebView2.ICoreWebView2WindowFeatures categoriesFor: #get_ShouldDisplayScrollBars:!**auto generated**!COM Interfaces-ICoreWebView2WindowFeatures!private! !
!WebView2.ICoreWebView2WindowFeatures categoriesFor: #get_ShouldDisplayStatus:!**auto generated**!COM Interfaces-ICoreWebView2WindowFeatures!private! !
!WebView2.ICoreWebView2WindowFeatures categoriesFor: #get_ShouldDisplayToolbar:!**auto generated**!COM Interfaces-ICoreWebView2WindowFeatures!private! !
!WebView2.ICoreWebView2WindowFeatures categoriesFor: #get_top:!**auto generated**!COM Interfaces-ICoreWebView2WindowFeatures!private! !
!WebView2.ICoreWebView2WindowFeatures categoriesFor: #get_Width:!**auto generated**!COM Interfaces-ICoreWebView2WindowFeatures!private! !
!WebView2.ICoreWebView2WindowFeatures categoriesFor: #hasPosition!**auto generated**!properties!public! !
!WebView2.ICoreWebView2WindowFeatures categoriesFor: #hasSize!**auto generated**!properties!public! !
!WebView2.ICoreWebView2WindowFeatures categoriesFor: #height!**auto generated**!properties!public! !
!WebView2.ICoreWebView2WindowFeatures categoriesFor: #left!**auto generated**!properties!public! !
!WebView2.ICoreWebView2WindowFeatures categoriesFor: #shouldDisplayMenuBar!**auto generated**!properties!public! !
!WebView2.ICoreWebView2WindowFeatures categoriesFor: #shouldDisplayScrollBars!**auto generated**!properties!public! !
!WebView2.ICoreWebView2WindowFeatures categoriesFor: #shouldDisplayStatus!**auto generated**!properties!public! !
!WebView2.ICoreWebView2WindowFeatures categoriesFor: #shouldDisplayToolbar!**auto generated**!properties!public! !
!WebView2.ICoreWebView2WindowFeatures categoriesFor: #top!**auto generated**!properties!public! !
!WebView2.ICoreWebView2WindowFeatures categoriesFor: #width!**auto generated**!properties!public! !

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
!WebView2.ICoreWebView2WindowFeatures class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

