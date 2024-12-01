"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2ContextMenuItem'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2ContextMenuItem guid: (OS.COM.IID fromString: '{7aed49e3-a93f-497a-811c-749c6b6b6c65}')!

WebView2.ICoreWebView2ContextMenuItem isEgressOnly: true!

WebView2.ICoreWebView2ContextMenuItem comment: '`ICoreWebView2ContextMenuItem` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ContextMenuItem'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(7aed49e3-a93f-497a-811c-749c6b6b6c65)
]
interface ICoreWebView2ContextMenuItem : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall name(
		[out, retval]LPWSTR* value);
	[id(0x60010001), propget]
	HRESULT __stdcall Label(
		[out, retval]LPWSTR* value);
	[id(0x60010002), propget]
	HRESULT __stdcall CommandId(
		[out, retval]int* value);
	[id(0x60010003), propget]
	HRESULT __stdcall ShortcutKeyDescription(
		[out, retval]LPWSTR* value);
	[id(0x60010004), propget]
	HRESULT __stdcall Icon(
		[out, retval]IStream** value);
	[id(0x60010005), propget]
	HRESULT __stdcall Kind(
		[out, retval]COREWEBVIEW2_CONTEXT_MENU_ITEM_KIND* value);
	[id(0x60010006), propput]
	HRESULT __stdcall IsEnabled(
		[in]long value);
	[id(0x60010006), propget]
	HRESULT __stdcall IsEnabled(
		[out, retval]long* value);
	[id(0x60010008), propput]
	HRESULT __stdcall IsChecked(
		[in]long value);
	[id(0x60010008), propget]
	HRESULT __stdcall IsChecked(
		[out, retval]long* value);
	[id(0x6001000a), propget]
	HRESULT __stdcall Children(
		[out, retval]ICoreWebView2ContextMenuItemCollection** value);
	[id(0x6001000b)]
	HRESULT __stdcall add_CustomItemSelected(
		[in]ICoreWebView2CustomItemSelectedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x6001000c)]
	HRESULT __stdcall remove_CustomItemSelected(
		[in]EventRegistrationToken token);
};
```
'!

!WebView2.ICoreWebView2ContextMenuItem categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2ContextMenuItem methodsFor!

Add_CustomItemSelected: eventHandler token: token
	"Private - Invoke the add_CustomItemSelected() method of the COM object.

		HRESULT __stdcall add_CustomItemSelected(
			[in]ICoreWebView2CustomItemSelectedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 15 ICoreWebView2CustomItemSelectedEventHandler* int64*>
	^self invalidCall: _failureCode!

children
	"Answer the <ICoreWebView2ContextMenuItemCollection> value of the 'Children' property of the receiver."

	| answer |
	answer := ICoreWebView2ContextMenuItemCollection newPointer.
	self get_Children: answer.
	^answer asObject!

commandId
	"Answer the <sdword> value of the 'CommandId' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_CommandId: answer.
	^answer asObject!

get_Children: value
	"Private - Get the value of the 'Children' property of the receiver.

		HRESULT __stdcall Children(
			[out, retval]ICoreWebView2ContextMenuItemCollection** value);"

	<virtual stdcall: hresult 14 ICoreWebView2ContextMenuItemCollection**>
	^self invalidCall: _failureCode!

get_CommandId: value
	"Private - Get the value of the 'CommandId' property of the receiver.

		HRESULT __stdcall CommandId(
			[out, retval]int* value);"

	<virtual stdcall: hresult 6 int32*>
	^self invalidCall: _failureCode!

get_Icon: value
	"Private - Get the value of the 'Icon' property of the receiver.

		HRESULT __stdcall Icon(
			[out, retval]IStream** value);"

	<virtual stdcall: hresult 8 IStream**>
	^self invalidCall: _failureCode!

get_IsChecked: value
	"Private - Get the value of the 'IsChecked' property of the receiver.

		HRESULT __stdcall IsChecked(
			[out, retval]long* value);"

	<virtual stdcall: hresult 13 int32*>
	^self invalidCall: _failureCode!

get_IsEnabled: value
	"Private - Get the value of the 'IsEnabled' property of the receiver.

		HRESULT __stdcall IsEnabled(
			[out, retval]long* value);"

	<virtual stdcall: hresult 11 int32*>
	^self invalidCall: _failureCode!

get_Kind: value
	"Private - Get the value of the 'Kind' property of the receiver.

		HRESULT __stdcall Kind(
			[out, retval]COREWEBVIEW2_CONTEXT_MENU_ITEM_KIND* value);"

	<virtual stdcall: hresult 9 int32*>
	^self invalidCall: _failureCode!

get_Label: value
	"Private - Get the value of the 'Label' property of the receiver.

		HRESULT __stdcall Label(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 5 lpwstr*>
	^self invalidCall: _failureCode!

get_name: value
	"Private - Get the value of the 'name' property of the receiver.

		HRESULT __stdcall name(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

get_ShortcutKeyDescription: value
	"Private - Get the value of the 'ShortcutKeyDescription' property of the receiver.

		HRESULT __stdcall ShortcutKeyDescription(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 7 lpwstr*>
	^self invalidCall: _failureCode!

icon_
	"Answer the <IStream> value of the 'Icon' property of the receiver."

	| answer |
	answer := IStream newPointer.
	self get_Icon: answer.
	^answer asObject!

isChecked
	"Answer whether the item is checked or not."

	| buf |
	buf := UInt32Bytes new.
	self get_IsChecked: buf.
	^buf asBoolean!

isChecked: value
	"Set the 'IsChecked' property of the receiver to the <sdword> value of the argument."

	self put_IsChecked: value asParameter!

isEnabled
	"Answer whether the item is enabled or not."

	| buf |
	buf := UInt32Bytes new.
	self get_IsEnabled: buf.
	^buf asBoolean!

isEnabled: value
	"Set the 'IsEnabled' property of the receiver to the <sdword> value of the argument."

	self put_IsEnabled: value asParameter!

items
	"Answer an <ICoreWebView2ContextMenuItemCollection> containing the receiver's sub-menu items, or nil if not a sub-menu"

	^self kind == #subMenu ifTrue: [self children]!

kind
	"Answer the <int32> value of the 'Kind' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_Kind: answer.
	^answer asObject!

kindName
	"Answer the symbolic name of the kind of menu item the receiver describes.
		#command	- Regular menu command
		#checkBox	- Toggle command
		#radioButton	- Option command in a group
		#separator	- Passive separator
		#subMenu	- Drill-down menu
	"

	^#(#command #checkBox #radioButton #separator #subMenu) at: self kind + 1!

label
	"Answer the menu item label, including &-shortcut designator. May be localised."

	| ptr answer |
	ptr := TaskMemory new.
	self get_Label: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

name
	"Answer the name of the command (constant, not localised). For unnamed items this returns 'other'."

	| ptr answer |
	ptr := TaskMemory new.
	self get_name: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

printableProperties
	| propertyNames kind |
	propertyNames := OrderedCollection new: 4.
	self name = 'other' ifFalse: [propertyNames addLast: #name].
	kind := self kindName.
	kind == #command ifFalse: [propertyNames addLast: #kindName].
	kind == #separator ifTrue: [^propertyNames].
	propertyNames addLast: #label.
	self commandId < 0 ifFalse: [propertyNames addLast: #commandId].
	(kind == #radioButton or: [kind == #checkBox]) ifTrue: [propertyNames addLast: #isChecked].
	propertyNames addLast: #isEnabled.
	self shortcutKeyDescription isEmpty ifFalse: [propertyNames addLast: #shortcutKeyDescription].
	^propertyNames!

put_IsChecked: value
	"Private - Set the value of the 'IsChecked' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall IsChecked(
			[in]long value);"

	<virtual stdcall: hresult 12 int32>
	^self invalidCall: _failureCode!

put_IsEnabled: value
	"Private - Set the value of the 'IsEnabled' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall IsEnabled(
			[in]long value);"

	<virtual stdcall: hresult 10 int32>
	^self invalidCall: _failureCode!

Remove_CustomItemSelected: token
	"Private - Invoke the remove_CustomItemSelected() method of the COM object.

		HRESULT __stdcall remove_CustomItemSelected(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 16 int64>
	^self invalidCall: _failureCode!

shortcutKeyDescription
	"Answer the <lpwstr> value of the 'ShortcutKeyDescription' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_ShortcutKeyDescription: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer! !

!WebView2.ICoreWebView2ContextMenuItem categoriesForMethods!
Add_CustomItemSelected:token:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuItem!private! !
children!**auto generated**!properties!public! !
commandId!**auto generated**!properties!public! !
get_Children:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuItem!private! !
get_CommandId:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuItem!private! !
get_Icon:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuItem!private! !
get_IsChecked:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuItem!private! !
get_IsEnabled:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuItem!private! !
get_Kind:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuItem!private! !
get_Label:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuItem!private! !
get_name:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuItem!private! !
get_ShortcutKeyDescription:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuItem!private! !
icon_!**auto generated**!properties!public! !
isChecked!properties!public! !
isChecked:!properties!public! !
isEnabled!properties!public! !
isEnabled:!properties!public! !
items!properties!public! !
kind!**auto generated**!properties!public! !
kindName!properties!public! !
label!properties!public! !
name!properties!public! !
printableProperties!printing!private! !
put_IsChecked:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuItem!private! !
put_IsEnabled:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuItem!private! !
Remove_CustomItemSelected:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuItem!private! !
shortcutKeyDescription!properties!public! !
!

!WebView2.ICoreWebView2ContextMenuItem class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ContextMenuItem'
		ICoreWebView2ContextMenuItem defineTemplate"

	self
		defineFunction: #get_name:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_Label:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_CommandId:
			argumentTypes: 'sdword*';
		defineFunction: #get_ShortcutKeyDescription:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_Icon:
			argumentTypes: 'IStream**';
		defineFunction: #get_Kind:
			argumentTypes: 'sdword*';
		defineFunction: #put_IsEnabled:
			argumentTypes: 'sdword';
		defineFunction: #get_IsEnabled:
			argumentTypes: 'sdword*';
		defineFunction: #put_IsChecked:
			argumentTypes: 'sdword';
		defineFunction: #get_IsChecked:
			argumentTypes: 'sdword*';
		defineFunction: #get_Children:
			argumentTypes: 'ICoreWebView2ContextMenuItemCollection**';
		defineFunction: #Add_CustomItemSelected:token:
			argumentTypes: 'ICoreWebView2CustomItemSelectedEventHandler* sqword*';
		defineFunction: #Remove_CustomItemSelected:
			argumentTypes: 'sqword'
! !

!WebView2.ICoreWebView2ContextMenuItem class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

