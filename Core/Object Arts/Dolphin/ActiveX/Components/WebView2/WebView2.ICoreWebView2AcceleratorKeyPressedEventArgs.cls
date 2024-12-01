"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventArgs
	subclass: #'WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs guid: (OS.COM.IID fromString: '{9f760f8a-fb79-42be-9990-7b56900fa9c7}')!

WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs isEgressOnly: true!

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

	<virtual stdcall: hresult 8 int32*>
	^self invalidCall: _failureCode!

get_IsBrowserAcceleratorKeyEnabled: value
	"Private - Get the value of the 'IsBrowserAcceleratorKeyEnabled' property of the receiver.

		HRESULT __stdcall IsBrowserAcceleratorKeyEnabled(
			[out, retval]long* value);"

	value value: 1.
	^S_OK!

get_KeyEventKind: keyEventKind
	"Private - Get the value of the 'KeyEventKind' property of the receiver.

		HRESULT __stdcall KeyEventKind(
			[out, retval]COREWEBVIEW2_KEY_EVENT_KIND* KeyEventKind);"

	<virtual stdcall: hresult 4 int32*>
	^self invalidCall: _failureCode!

get_KeyEventLParam: lParam
	"Private - Get the value of the 'KeyEventLParam' property of the receiver.

		HRESULT __stdcall KeyEventLParam(
			[out, retval]int* lParam);"

	<virtual stdcall: hresult 6 int32*>
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

	<virtual stdcall: hresult 5 uint32*>
	^self invalidCall: _failureCode!

isBrowserAcceleratorKeyEnabled
	"Answer the <Boolean> value of the 'IsBrowserAcceleratorKeyEnabled' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_IsBrowserAcceleratorKeyEnabled: buf.
	^buf asBoolean!

isBrowserAcceleratorKeyEnabled: aBoolean
	"Set the 'IsBrowserAcceleratorKeyEnabled' property of the receiver to the <int32> value of the argument."

	self put_IsBrowserAcceleratorKeyEnabled: aBoolean asParameter!

keyEventKind
	"Answer the <sdword> value of the 'KeyEventKind' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_KeyEventKind: answer.
	^answer asObject!

keyEventLParam
	"Answer the <sdword> value of the 'KeyEventLParam' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_KeyEventLParam: answer.
	^answer asObject!

keyName
	^UI.Keyboard default keyNameFromLParam: self keyEventLParam!

physicalKeyStatus
	"Answer the <COREWEBVIEW2_PHYSICAL_KEY_STATUS> value of the 'PhysicalKeyStatus' property of the receiver."

	| answer |
	answer := COREWEBVIEW2_PHYSICAL_KEY_STATUS new.
	self get_PhysicalKeyStatus: answer.
	^answer asObject!

printPropertiesOn: aStream
	aStream
		nextPutAll: self windowsKeyEvent;
		nextPutAll: ': ';
		nextPutAll: self keyName;
		nextPutAll: ', handled: ';
		print: self handled!

put_Handled: handled
	"Private - Set the value of the 'Handled' property of the object wrapped by the 
	 receiver to the <sdword> argument, handled.

		HRESULT __stdcall Handled(
			[in]long Handled);"

	<virtual stdcall: hresult 9 int32>
	^self invalidCall: _failureCode!

put_IsBrowserAcceleratorKeyEnabled: value
	"Private - Set the value of the 'IsBrowserAcceleratorKeyEnabled' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall IsBrowserAcceleratorKeyEnabled(
			[in]long value);"

	^E_NOTIMPL!

virtualKey
	"Answer the <dword> value of the 'VirtualKey' property of the receiver."

	| answer |
	answer := UInt32 new.
	self get_VirtualKey: answer.
	^answer asObject!

windowsKeyEvent
	^#('WM_KEYDOWN' 'WM_KEYUP' 'WM_SYSKEYDOWN' 'WM_SYSKEYUP') at: self keyEventKind + 1! !

!WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs categoriesForMethods!
get_Handled:!**auto generated**!COM Interfaces-ICoreWebView2AcceleratorKeyPressedEventArgs!private! !
get_IsBrowserAcceleratorKeyEnabled:!COM Interfaces-ICoreWebView2AcceleratorKeyPressedEventArgs2!private! !
get_KeyEventKind:!**auto generated**!COM Interfaces-ICoreWebView2AcceleratorKeyPressedEventArgs!private! !
get_KeyEventLParam:!**auto generated**!COM Interfaces-ICoreWebView2AcceleratorKeyPressedEventArgs!private! !
get_PhysicalKeyStatus:!**auto generated**!COM Interfaces-ICoreWebView2AcceleratorKeyPressedEventArgs!private! !
get_VirtualKey:!**auto generated**!COM Interfaces-ICoreWebView2AcceleratorKeyPressedEventArgs!private! !
isBrowserAcceleratorKeyEnabled!properties!public! !
isBrowserAcceleratorKeyEnabled:!properties!public! !
keyEventKind!**auto generated**!properties!public! !
keyEventLParam!**auto generated**!properties!public! !
keyName!accessing!public! !
physicalKeyStatus!**auto generated**!properties!public! !
printPropertiesOn:!printing!private! !
put_Handled:!**auto generated**!COM Interfaces-ICoreWebView2AcceleratorKeyPressedEventArgs!private! !
put_IsBrowserAcceleratorKeyEnabled:!COM Interfaces-ICoreWebView2AcceleratorKeyPressedEventArgs2!private! !
virtualKey!**auto generated**!properties!public! !
windowsKeyEvent!printing!public! !
!

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
!

latestDerivation
	^##(super latestDerivation)! !

!WebView2.ICoreWebView2AcceleratorKeyPressedEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
latestDerivation!enquiries!public! !
!

