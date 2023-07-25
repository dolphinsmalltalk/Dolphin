"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventArgs
	subclass: #'WebView2.ICoreWebView2ContextMenuRequestedEventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2ContextMenuRequestedEventArgs guid: (OS.COM.IID fromString: '{a1d309ee-c03f-11eb-8529-0242ac130003}')!
WebView2.ICoreWebView2ContextMenuRequestedEventArgs comment: '`ICoreWebView2ContextMenuRequestedEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ContextMenuRequestedEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(a1d309ee-c03f-11eb-8529-0242ac130003)
]
interface ICoreWebView2ContextMenuRequestedEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall MenuItems(
		[out, retval]ICoreWebView2ContextMenuItemCollection** value);
	[id(0x60010001), propget]
	HRESULT __stdcall ContextMenuTarget(
		[out, retval]ICoreWebView2ContextMenuTarget** value);
	[id(0x60010002), propget]
	HRESULT __stdcall Location(
		[out, retval]POINT* value);
	[id(0x60010003), propput]
	HRESULT __stdcall SelectedCommandId(
		[in]int value);
	[id(0x60010003), propget]
	HRESULT __stdcall SelectedCommandId(
		[out, retval]int* value);
	[id(0x60010005), propput]
	HRESULT __stdcall Handled(
		[in]long value);
	[id(0x60010005), propget]
	HRESULT __stdcall Handled(
		[out, retval]long* value);
	[id(0x60010007)]
	HRESULT __stdcall GetDeferral(
		[out, retval]ICoreWebView2Deferral** deferral);
};
```
'!
!WebView2.ICoreWebView2ContextMenuRequestedEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2ContextMenuRequestedEventArgs methodsFor!

contextMenuTarget
	"Answer the <ICoreWebView2ContextMenuTarget> value of the 'ContextMenuTarget' property of the receiver."

	| answer |
	answer := ICoreWebView2ContextMenuTarget newPointer.
	self get_ContextMenuTarget: answer.
	^answer asObject!

get_ContextMenuTarget: value
	"Private - Get the value of the 'ContextMenuTarget' property of the receiver.

		HRESULT __stdcall ContextMenuTarget(
			[out, retval]ICoreWebView2ContextMenuTarget** value);"

	<virtual stdcall: hresult 5 ICoreWebView2ContextMenuTarget**>
	^self invalidCall: _failureCode!

get_Handled: value
	"Private - Get the value of the 'Handled' property of the receiver.

		HRESULT __stdcall Handled(
			[out, retval]long* value);"

	<virtual stdcall: hresult 10 bool*>
	^self invalidCall: _failureCode!

get_Location: value
	"Private - Get the value of the 'Location' property of the receiver.

		HRESULT __stdcall Location(
			[out, retval]POINT* value);"

	<virtual stdcall: hresult 6 POINTL*>
	^self invalidCall: _failureCode!

get_MenuItems: value
	"Private - Get the value of the 'MenuItems' property of the receiver.

		HRESULT __stdcall MenuItems(
			[out, retval]ICoreWebView2ContextMenuItemCollection** value);"

	<virtual stdcall: hresult 4 ICoreWebView2ContextMenuItemCollection**>
	^self invalidCall: _failureCode!

get_SelectedCommandId: value
	"Private - Get the value of the 'SelectedCommandId' property of the receiver.

		HRESULT __stdcall SelectedCommandId(
			[out, retval]int* value);"

	<virtual stdcall: hresult 8 int32*>
	^self invalidCall: _failureCode!

GetDeferral: deferral
	"Private - Invoke the GetDeferral() method of the COM object.

		HRESULT __stdcall GetDeferral(
			[out, retval]ICoreWebView2Deferral** deferral);"

	<virtual stdcall: hresult 11 ICoreWebView2Deferral**>
	^self invalidCall: _failureCode!

handled
	"Answer the <Boolean> value of the 'Handled' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_Handled: answer.
	^answer value!

handled: value
	"Set the 'Handled' property of the receiver to the <sdword> value of the argument."

	self put_Handled: value!

location
	"Answer the <POINTL> value of the 'Location' property of the receiver."

	| answer |
	answer := POINTL new.
	self get_Location: answer.
	^answer asObject!

menuItems
	"Answer the <ICoreWebView2ContextMenuItemCollection> value of the 'MenuItems' property of the receiver."

	| answer |
	answer := ICoreWebView2ContextMenuItemCollection newPointer.
	self get_MenuItems: answer.
	^answer asObject!

printableProperties
	^#(#location #handled #contextMenuTarget)!

put_Handled: value
	"Private - Set the value of the 'Handled' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall Handled(
			[in]long value);"

	<virtual stdcall: hresult 9 bool>
	^self invalidCall: _failureCode!

put_SelectedCommandId: value
	"Private - Set the value of the 'SelectedCommandId' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall SelectedCommandId(
			[in]int value);"

	<virtual stdcall: hresult 7 int32>
	^self invalidCall: _failureCode!

selectedCommandId
	"Answer the <sdword> value of the 'SelectedCommandId' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_SelectedCommandId: answer.
	^answer asObject!

selectedCommandId: value
	"Set the 'SelectedCommandId' property of the receiver to the <sdword> value of the argument."

	self put_SelectedCommandId: value! !
!WebView2.ICoreWebView2ContextMenuRequestedEventArgs categoriesForMethods!
contextMenuTarget!**auto generated**!properties!public! !
get_ContextMenuTarget:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuRequestedEventArgs!private! !
get_Handled:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuRequestedEventArgs!private! !
get_Location:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuRequestedEventArgs!private! !
get_MenuItems:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuRequestedEventArgs!private! !
get_SelectedCommandId:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuRequestedEventArgs!private! !
GetDeferral:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuRequestedEventArgs!private! !
handled!properties!public! !
handled:!**auto generated**!properties!public! !
location!**auto generated**!properties!public! !
menuItems!**auto generated**!properties!public! !
printableProperties!printing!private! !
put_Handled:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuRequestedEventArgs!private! !
put_SelectedCommandId:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuRequestedEventArgs!private! !
selectedCommandId!**auto generated**!properties!public! !
selectedCommandId:!**auto generated**!properties!public! !
!

!WebView2.ICoreWebView2ContextMenuRequestedEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ContextMenuRequestedEventArgs'
		ICoreWebView2ContextMenuRequestedEventArgs defineTemplate"

	self
		defineFunction: #get_MenuItems:
			argumentTypes: 'ICoreWebView2ContextMenuItemCollection**';
		defineFunction: #get_ContextMenuTarget:
			argumentTypes: 'ICoreWebView2ContextMenuTarget**';
		defineFunction: #get_Location:
			argumentTypes: 'POINTL*';
		defineFunction: #put_SelectedCommandId:
			argumentTypes: 'sdword';
		defineFunction: #get_SelectedCommandId:
			argumentTypes: 'sdword*';
		defineFunction: #put_Handled:
			argumentTypes: 'bool';
		defineFunction: #get_Handled:
			argumentTypes: 'bool*';
		defineFunction: #GetDeferral:
			argumentTypes: 'ICoreWebView2Deferral**'
! !
!WebView2.ICoreWebView2ContextMenuRequestedEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

