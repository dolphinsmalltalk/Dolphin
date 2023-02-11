"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface subclass: #'WebView2.ICoreWebView2ContextMenuTarget'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2ContextMenuTarget guid: (OS.COM.IID fromString: '{b8611d99-eed6-4f3f-902c-a198502ad472}')!
WebView2.ICoreWebView2ContextMenuTarget comment: '`ICoreWebView2ContextMenuTarget` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ContextMenuTarget'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(b8611d99-eed6-4f3f-902c-a198502ad472)
]
interface ICoreWebView2ContextMenuTarget : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall Kind(
		[out, retval]COREWEBVIEW2_CONTEXT_MENU_TARGET_KIND* value);
	[id(0x60010001), propget]
	HRESULT __stdcall IsEditable(
		[out, retval]long* value);
	[id(0x60010002), propget]
	HRESULT __stdcall IsRequestedForMainFrame(
		[out, retval]long* value);
	[id(0x60010003), propget]
	HRESULT __stdcall PageUri(
		[out, retval]LPWSTR* value);
	[id(0x60010004), propget]
	HRESULT __stdcall FrameUri(
		[out, retval]LPWSTR* value);
	[id(0x60010005), propget]
	HRESULT __stdcall HasLinkUri(
		[out, retval]long* value);
	[id(0x60010006), propget]
	HRESULT __stdcall LinkUri(
		[out, retval]LPWSTR* value);
	[id(0x60010007), propget]
	HRESULT __stdcall HasLinkText(
		[out, retval]long* value);
	[id(0x60010008), propget]
	HRESULT __stdcall LinkText(
		[out, retval]LPWSTR* value);
	[id(0x60010009), propget]
	HRESULT __stdcall HasSourceUri(
		[out, retval]long* value);
	[id(0x6001000a), propget]
	HRESULT __stdcall SourceUri(
		[out, retval]LPWSTR* value);
	[id(0x6001000b), propget]
	HRESULT __stdcall HasSelection(
		[out, retval]long* value);
	[id(0x6001000c), propget]
	HRESULT __stdcall SelectionText(
		[out, retval]LPWSTR* value);
};
```
'!
!WebView2.ICoreWebView2ContextMenuTarget categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2ContextMenuTarget methodsFor!

frameUri
	"Answer the <readableString> value of the 'FrameUri' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_FrameUri: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

get_FrameUri: value
	"Private - Get the value of the 'FrameUri' property of the receiver.

		HRESULT __stdcall FrameUri(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 8 lpwstr*>
	^self invalidCall: _failureCode!

get_HasLinkText: value
	"Private - Get the value of the 'HasLinkText' property of the receiver.

		HRESULT __stdcall HasLinkText(
			[out, retval]long* value);"

	<virtual stdcall: hresult 11 int32*>
	^self invalidCall: _failureCode!

get_HasLinkUri: value
	"Private - Get the value of the 'HasLinkUri' property of the receiver.

		HRESULT __stdcall HasLinkUri(
			[out, retval]long* value);"

	<virtual stdcall: hresult 9 int32*>
	^self invalidCall: _failureCode!

get_HasSelection: value
	"Private - Get the value of the 'HasSelection' property of the receiver.

		HRESULT __stdcall HasSelection(
			[out, retval]long* value);"

	<virtual stdcall: hresult 15 int32*>
	^self invalidCall: _failureCode!

get_HasSourceUri: value
	"Private - Get the value of the 'HasSourceUri' property of the receiver.

		HRESULT __stdcall HasSourceUri(
			[out, retval]long* value);"

	<virtual stdcall: hresult 13 int32*>
	^self invalidCall: _failureCode!

get_IsEditable: value
	"Private - Get the value of the 'IsEditable' property of the receiver.

		HRESULT __stdcall IsEditable(
			[out, retval]long* value);"

	<virtual stdcall: hresult 5 int32*>
	^self invalidCall: _failureCode!

get_IsRequestedForMainFrame: value
	"Private - Get the value of the 'IsRequestedForMainFrame' property of the receiver.

		HRESULT __stdcall IsRequestedForMainFrame(
			[out, retval]long* value);"

	<virtual stdcall: hresult 6 int32*>
	^self invalidCall: _failureCode!

get_Kind: value
	"Private - Get the value of the 'Kind' property of the receiver.

		HRESULT __stdcall Kind(
			[out, retval]COREWEBVIEW2_CONTEXT_MENU_TARGET_KIND* value);"

	<virtual stdcall: hresult 4 int32*>
	^self invalidCall: _failureCode!

get_LinkText: value
	"Private - Get the value of the 'LinkText' property of the receiver.

		HRESULT __stdcall LinkText(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 12 lpwstr*>
	^self invalidCall: _failureCode!

get_LinkUri: value
	"Private - Get the value of the 'LinkUri' property of the receiver.

		HRESULT __stdcall LinkUri(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 10 lpwstr*>
	^self invalidCall: _failureCode!

get_PageUri: value
	"Private - Get the value of the 'PageUri' property of the receiver.

		HRESULT __stdcall PageUri(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 7 lpwstr*>
	^self invalidCall: _failureCode!

get_SelectionText: value
	"Private - Get the value of the 'SelectionText' property of the receiver.

		HRESULT __stdcall SelectionText(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 16 lpwstr*>
	^self invalidCall: _failureCode!

get_SourceUri: value
	"Private - Get the value of the 'SourceUri' property of the receiver.

		HRESULT __stdcall SourceUri(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 14 lpwstr*>
	^self invalidCall: _failureCode!

hasLinkText
	"Answer the <Boolean> value of the 'HasLinkText' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_HasLinkText: answer.
	^answer value!

hasLinkUri
	"Answer the <Boolean> value of the 'HasLinkUri' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_HasLinkUri: answer.
	^answer value!

hasSelection
	"Answer the <Boolean> value of the 'HasSelection' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_HasSelection: answer.
	^answer value!

hasSourceUri
	"Answer the <sdword> value of the 'HasSourceUri' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_HasSourceUri: answer.
	^answer value!

isEditable
	"Answer the <Boolean> value of the 'IsEditable' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_IsEditable: answer.
	^answer value!

isRequestedForMainFrame
	"Answer the <Boolean> value of the 'IsRequestedForMainFrame' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_IsRequestedForMainFrame: answer.
	^answer value!

kind
	"Answer the <sdword> value of the 'Kind' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_Kind: answer.
	^answer asObject!

linkText
	"Answer the <readableString> value of the 'LinkText' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_LinkText: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

linkUri
	"Answer the <readableString> value of the 'LinkUri' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_LinkUri: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

pageUri
	"Answer the <readableString> value of the 'PageUri' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_PageUri: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

printableProperties
	| propertyNames |
	propertyNames := OrderedCollection withAll: #(#kind #isEditable #isRequestedForMainFrame).
	self hasSelection ifTrue: [propertyNames addLast: #selectionText].
	self hasSourceUri ifTrue: [propertyNames addLast: #sourceUri].
	self hasLinkText ifTrue: [propertyNames addLast: #linkText].
	self hasLinkUri ifTrue: [propertyNames addLast: #linkUri].
	propertyNames addAll: #(#pageUri).
	^propertyNames!

selectionText
	"Answer the <readableString> value of the 'SelectionText' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_SelectionText: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

sourceUri
	"Answer the <readableString> value of the 'SourceUri' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_SourceUri: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer! !
!WebView2.ICoreWebView2ContextMenuTarget categoriesForMethods!
frameUri!properties!public! !
get_FrameUri:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuTarget!private! !
get_HasLinkText:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuTarget!private! !
get_HasLinkUri:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuTarget!private! !
get_HasSelection:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuTarget!private! !
get_HasSourceUri:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuTarget!private! !
get_IsEditable:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuTarget!private! !
get_IsRequestedForMainFrame:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuTarget!private! !
get_Kind:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuTarget!private! !
get_LinkText:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuTarget!private! !
get_LinkUri:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuTarget!private! !
get_PageUri:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuTarget!private! !
get_SelectionText:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuTarget!private! !
get_SourceUri:!**auto generated**!COM Interfaces-ICoreWebView2ContextMenuTarget!private! !
hasLinkText!properties!public! !
hasLinkUri!properties!public! !
hasSelection!properties!public! !
hasSourceUri!properties!public! !
isEditable!properties!public! !
isRequestedForMainFrame!properties!public! !
kind!**auto generated**!properties!public! !
linkText!properties!public! !
linkUri!properties!public! !
pageUri!properties!public! !
printableProperties!printing!private! !
selectionText!properties!public! !
sourceUri!properties!public! !
!

!WebView2.ICoreWebView2ContextMenuTarget class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ContextMenuTarget'
		ICoreWebView2ContextMenuTarget defineTemplate"

	self
		defineFunction: #get_Kind:
			argumentTypes: 'sdword*';
		defineFunction: #get_IsEditable:
			argumentTypes: 'sdword*';
		defineFunction: #get_IsRequestedForMainFrame:
			argumentTypes: 'sdword*';
		defineFunction: #get_PageUri:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_FrameUri:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_HasLinkUri:
			argumentTypes: 'sdword*';
		defineFunction: #get_LinkUri:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_HasLinkText:
			argumentTypes: 'sdword*';
		defineFunction: #get_LinkText:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_HasSourceUri:
			argumentTypes: 'sdword*';
		defineFunction: #get_SourceUri:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_HasSelection:
			argumentTypes: 'sdword*';
		defineFunction: #get_SelectionText:
			argumentTypes: 'lpwstr*'
! !
!WebView2.ICoreWebView2ContextMenuTarget class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

