"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs guid: (OS.COM.IID fromString: '{9f760f8a-fb79-42be-9990-7b56900fa9c7}')!
WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs comment: '`ICoreWebView2AcceleratorKeyPressedEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(9f760f8a-fb79-42be-9990-7b56900fa9c7)
]
interface ICoreWebView2AcceleratorKeyPressedEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall KeyEventKind(
		[out, retval]COREWEBVIEW2_KEY_EVENT_KIND* KeyEventKind);
	[id(0x60010001), propget]
	HRESULT __stdcall VirtualKey(
		[out, retval]unsigned int* VirtualKey);
	[id(0x60010002), propget]
	HRESULT __stdcall KeyEventLParam(
		[out, retval]int* lParam);
	[id(0x60010003), propget]
	HRESULT __stdcall PhysicalKeyStatus(
		[out, retval]COREWEBVIEW2_PHYSICAL_KEY_STATUS* PhysicalKeyStatus);
	[id(0x60010004), propget]
	HRESULT __stdcall Handled(
		[out, retval]long* Handled);
	[id(0x60010004), propput]
	HRESULT __stdcall Handled(
		[in]long Handled);
};
```
'!
!WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs methodsFor!

get_Handled: handled
	"Private - Get the value of the 'Handled' property of the receiver.

		HRESULT __stdcall Handled(
			[out, retval]long* Handled);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall: _failureCode!

get_KeyEventKind: keyEventKind
	"Private - Get the value of the 'KeyEventKind' property of the receiver.

		HRESULT __stdcall KeyEventKind(
			[out, retval]COREWEBVIEW2_KEY_EVENT_KIND* KeyEventKind);"

	<virtual stdcall: hresult 4 sdword*>
	^self invalidCall: _failureCode!

get_KeyEventLParam: lParam
	"Private - Get the value of the 'KeyEventLParam' property of the receiver.

		HRESULT __stdcall KeyEventLParam(
			[out, retval]int* lParam);"

	<virtual stdcall: hresult 6 sdword*>
	^self invalidCall: _failureCode!

get_PhysicalKeyStatus: physicalKeyStatus
	"Private - Get the value of the 'PhysicalKeyStatus' property of the receiver.

		HRESULT __stdcall PhysicalKeyStatus(
			[out, retval]COREWEBVIEW2_PHYSICAL_KEY_STATUS* PhysicalKeyStatus);"

	<virtual stdcall: hresult 7 COREWEBVIEW2_PHYSICAL_KEY_STATUS*>
	^self invalidCall: _failureCode!

get_VirtualKey: virtualKey
	"Private - Get the value of the 'VirtualKey' property of the receiver.

		HRESULT __stdcall VirtualKey(
			[out, retval]unsigned int* VirtualKey);"

	<virtual stdcall: hresult 5 dword*>
	^self invalidCall: _failureCode!

handled
	"Answer the <sdword> value of the 'Handled' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_Handled: answer.
	^answer asObject!

handled: handled
	"Set the 'Handled' property of the receiver to the <sdword> value of the argument."

	self put_Handled: handled!

keyEventKind
	"Answer the <sdword> value of the 'KeyEventKind' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_KeyEventKind: answer.
	^answer asObject!

keyEventLParam
	"Answer the <sdword> value of the 'KeyEventLParam' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_KeyEventLParam: answer.
	^answer asObject!

physicalKeyStatus
	"Answer the <COREWEBVIEW2_PHYSICAL_KEY_STATUS> value of the 'PhysicalKeyStatus' property of the receiver."

	| answer |
	answer := COREWEBVIEW2_PHYSICAL_KEY_STATUS new.
	self get_PhysicalKeyStatus: answer.
	^answer asObject!

put_Handled: handled
	"Private - Set the value of the 'Handled' property of the object wrapped by the 
	 receiver to the <sdword> argument, handled.

		HRESULT __stdcall Handled(
			[in]long Handled);"

	<virtual stdcall: hresult 9 sdword>
	^self invalidCall: _failureCode!

virtualKey
	"Answer the <dword> value of the 'VirtualKey' property of the receiver."

	| answer |
	answer := DWORD new.
	self get_VirtualKey: answer.
	^answer asObject! !
!WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs categoriesFor: #get_Handled:!**auto generated**!COM Interfaces-ICoreWebView2AcceleratorKeyPressedEventArgs!private! !
!WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs categoriesFor: #get_KeyEventKind:!**auto generated**!COM Interfaces-ICoreWebView2AcceleratorKeyPressedEventArgs!private! !
!WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs categoriesFor: #get_KeyEventLParam:!**auto generated**!COM Interfaces-ICoreWebView2AcceleratorKeyPressedEventArgs!private! !
!WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs categoriesFor: #get_PhysicalKeyStatus:!**auto generated**!COM Interfaces-ICoreWebView2AcceleratorKeyPressedEventArgs!private! !
!WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs categoriesFor: #get_VirtualKey:!**auto generated**!COM Interfaces-ICoreWebView2AcceleratorKeyPressedEventArgs!private! !
!WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs categoriesFor: #handled!**auto generated**!properties!public! !
!WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs categoriesFor: #handled:!**auto generated**!properties!public! !
!WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs categoriesFor: #keyEventKind!**auto generated**!properties!public! !
!WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs categoriesFor: #keyEventLParam!**auto generated**!properties!public! !
!WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs categoriesFor: #physicalKeyStatus!**auto generated**!properties!public! !
!WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs categoriesFor: #put_Handled:!**auto generated**!COM Interfaces-ICoreWebView2AcceleratorKeyPressedEventArgs!private! !
!WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs categoriesFor: #virtualKey!**auto generated**!properties!public! !

!WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs'
		ICoreWebView2AcceleratorKeyPressedEventArgs defineTemplate"

	self
		defineFunction: #get_KeyEventKind:
			argumentTypes: 'sdword*';
		defineFunction: #get_VirtualKey:
			argumentTypes: 'dword*';
		defineFunction: #get_KeyEventLParam:
			argumentTypes: 'sdword*';
		defineFunction: #get_PhysicalKeyStatus:
			argumentTypes: 'COREWEBVIEW2_PHYSICAL_KEY_STATUS*';
		defineFunction: #get_Handled:
			argumentTypes: 'sdword*';
		defineFunction: #put_Handled:
			argumentTypes: 'sdword'
! !
!WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

