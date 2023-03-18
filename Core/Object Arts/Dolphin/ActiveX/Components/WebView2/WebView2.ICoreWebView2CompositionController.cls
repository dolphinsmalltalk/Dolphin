"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2CompositionController'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2CompositionController guid: (OS.COM.IID fromString: '{3df9b733-b9ae-4a15-86b4-eb9ee9826469}')!
WebView2.ICoreWebView2CompositionController comment: '`ICoreWebView2CompositionController` is a wrapper class for the COM interface ''WebView2.ICoreWebView2CompositionController'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(3df9b733-b9ae-4a15-86b4-eb9ee9826469)
]
interface ICoreWebView2CompositionController : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall RootVisualTarget(
		[out, retval]IUnknown** target);
	[id(0x60010000), propput]
	HRESULT __stdcall RootVisualTarget(
		[in]IUnknown* target);
	[id(0x60010002)]
	HRESULT __stdcall SendMouseInput(
		[in]COREWEBVIEW2_MOUSE_EVENT_KIND eventKind,
		[in]COREWEBVIEW2_MOUSE_EVENT_VIRTUAL_KEYS virtualKeys,
		[in]unsigned int mouseData,
		[in]POINT point);
	[id(0x60010003)]
	HRESULT __stdcall SendPointerInput(
		[in]COREWEBVIEW2_POINTER_EVENT_KIND eventKind,
		[in]ICoreWebView2PointerInfo* pointerInfo);
	[id(0x60010004), propget]
	HRESULT __stdcall Cursor(
		[out, retval]wireHICON* Cursor);
	[id(0x60010005), propget]
	HRESULT __stdcall SystemCursorId(
		[out, retval]unsigned int* SystemCursorId);
	[id(0x60010006)]
	HRESULT __stdcall add_CursorChanged(
		[in]ICoreWebView2CursorChangedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60010007)]
	HRESULT __stdcall remove_CursorChanged(
		[in]EventRegistrationToken token);
};
```
'!
!WebView2.ICoreWebView2CompositionController categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2CompositionController methodsFor!

Add_CursorChanged: eventHandler token: token
	"Private - Invoke the add_CursorChanged() method of the COM object.

		HRESULT __stdcall add_CursorChanged(
			[in]ICoreWebView2CursorChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 10 ICoreWebView2CursorChangedEventHandler* int64*>
	^self invalidCall: _failureCode!

currentCursor
	"Answer the current <Cursor>."

	| hCursor |
	hCursor := self cursor.
	^hCursor == 0 ifFalse: [Graphics.Cursor fromHandle: hCursor]!

cursor
	"Answer the <handle> value of the 'Cursor' property of the receiver."

	| answer |
	answer := Handle new.
	self get_Cursor: answer.
	^answer asObject!

get_Cursor: cursor
	"Private - Get the value of the 'Cursor' property of the receiver.

		HRESULT __stdcall Cursor(
			[out, retval]wireHICON* Cursor);"

	<virtual stdcall: hresult 8 handle*>
	^self invalidCall: _failureCode!

get_RootVisualTarget: target
	"Private - Get the value of the 'RootVisualTarget' property of the receiver.

		HRESULT __stdcall RootVisualTarget(
			[out, retval]IUnknown** target);"

	<virtual stdcall: hresult 4 IUnknown**>
	^self invalidCall: _failureCode!

get_SystemCursorId: systemCursorId
	"Private - Get the value of the 'SystemCursorId' property of the receiver.

		HRESULT __stdcall SystemCursorId(
			[out, retval]unsigned int* SystemCursorId);"

	<virtual stdcall: hresult 9 uint32*>
	^self invalidCall: _failureCode!

get_UIAProvider: provider
	"Private - Get the value of the 'UIAProvider' property of the receiver.

		HRESULT __stdcall UIAProvider(
			[out, retval]IUnknown** provider);"

	"Not implemented in this version"
	^E_NOTIMPL!

printableProperties
	| propertyNames |
	propertyNames := #(rootVisualTarget #systemCursorId).
	self cursor == 0 ifFalse: [propertyNames := propertyNames copyWith: #currentCursor].
	^propertyNames!

put_RootVisualTarget: target
	"Private - Set the value of the 'RootVisualTarget' property of the object wrapped by the 
	 receiver to the <IUnknown*> argument, target.

		HRESULT __stdcall RootVisualTarget(
			[in]IUnknown* target);"

	<virtual stdcall: hresult 5 IUnknown*>
	^self invalidCall: _failureCode!

Remove_CursorChanged: token
	"Private - Invoke the remove_CursorChanged() method of the COM object.

		HRESULT __stdcall remove_CursorChanged(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 11 int64>
	^self invalidCall: _failureCode!

rootVisualTarget
	"Answer the <IUnknown> value of the 'RootVisualTarget' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get_RootVisualTarget: answer.
	^answer asObject!

rootVisualTarget: target
	"Set the 'RootVisualTarget' property of the receiver to the <IUnknown*> value of the argument."

	self put_RootVisualTarget: target!

SendMouseInput: eventKind virtualKeys: virtualKeys mouseData: mouseData point: point
	"Private - Invoke the SendMouseInput() method of the COM object.

		HRESULT __stdcall SendMouseInput(
			[in]COREWEBVIEW2_MOUSE_EVENT_KIND eventKind,
			[in]COREWEBVIEW2_MOUSE_EVENT_VIRTUAL_KEYS virtualKeys,
			[in]unsigned int mouseData,
			[in]POINT point);"

	<virtual stdcall: hresult 6 int32 int32 uint32 POINTL>
	^self invalidCall: _failureCode!

SendPointerInput: eventKind pointerInfo: pointerInfo
	"Private - Invoke the SendPointerInput() method of the COM object.

		HRESULT __stdcall SendPointerInput(
			[in]COREWEBVIEW2_POINTER_EVENT_KIND eventKind,
			[in]ICoreWebView2PointerInfo* pointerInfo);"

	<virtual stdcall: hresult 7 int32 ICoreWebView2PointerInfo*>
	^self invalidCall: _failureCode!

systemCursorId
	"Answer the <dword> value of the 'SystemCursorId' property of the receiver."

	| answer |
	answer := UInt32 new.
	self get_SystemCursorId: answer.
	^answer asObject!

uiaProvider
	"Answer the <IUnknown> value of the 'UIAProvider' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get_UIAProvider: answer.
	^answer asObject! !
!WebView2.ICoreWebView2CompositionController categoriesForMethods!
Add_CursorChanged:token:!**auto generated**!COM Interfaces-ICoreWebView2CompositionController!events!private! !
currentCursor!properties!public! !
cursor!**auto generated**!properties!public! !
get_Cursor:!**auto generated**!COM Interfaces-ICoreWebView2CompositionController!private!properties! !
get_RootVisualTarget:!**auto generated**!COM Interfaces-ICoreWebView2CompositionController!private!properties! !
get_SystemCursorId:!**auto generated**!COM Interfaces-ICoreWebView2CompositionController!private!properties! !
get_UIAProvider:!COM Interfaces-ICoreWebView2CompositionController2!private! !
printableProperties!printing!private! !
put_RootVisualTarget:!**auto generated**!COM Interfaces-ICoreWebView2CompositionController!private!properties! !
Remove_CursorChanged:!**auto generated**!COM Interfaces-ICoreWebView2CompositionController!events!private! !
rootVisualTarget!**auto generated**!properties!public! !
rootVisualTarget:!**auto generated**!properties!public! !
SendMouseInput:virtualKeys:mouseData:point:!**auto generated**!COM Interfaces-ICoreWebView2CompositionController!methods!private! !
SendPointerInput:pointerInfo:!**auto generated**!COM Interfaces-ICoreWebView2CompositionController!methods!private! !
systemCursorId!**auto generated**!properties!public! !
uiaProvider!properties!public! !
!

WebView2.ICoreWebView2CompositionController methodProtocol: #ICoreWebView2CompositionController attributes: #(#readOnly) selectors: #(#Add_CursorChanged:token: #get_Cursor: #get_RootVisualTarget: #get_SystemCursorId: #put_RootVisualTarget: #Remove_CursorChanged: #SendMouseInput:virtualKeys:mouseData:point: #SendPointerInput:pointerInfo:)!
WebView2.ICoreWebView2CompositionController methodProtocol: #ICoreWebView2CompositionController2 attributes: #(#readOnly) selectors: #(#Add_CursorChanged:token: #get_Cursor: #get_RootVisualTarget: #get_SystemCursorId: #get_UIAProvider: #put_RootVisualTarget: #Remove_CursorChanged: #SendMouseInput:virtualKeys:mouseData:point: #SendPointerInput:pointerInfo:)!

!WebView2.ICoreWebView2CompositionController class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2CompositionController'
		ICoreWebView2CompositionController defineTemplate"

	self
		defineFunction: #get_RootVisualTarget:
			argumentTypes: 'IUnknown**';
		defineFunction: #put_RootVisualTarget:
			argumentTypes: 'IUnknown*';
		defineFunction: #SendMouseInput:virtualKeys:mouseData:point:
			argumentTypes: 'sdword sdword dword POINTL';
		defineFunction: #SendPointerInput:pointerInfo:
			argumentTypes: 'sdword ICoreWebView2PointerInfo*';
		defineFunction: #get_Cursor:
			argumentTypes: 'handle*';
		defineFunction: #get_SystemCursorId:
			argumentTypes: 'dword*';
		defineFunction: #Add_CursorChanged:token:
			argumentTypes: 'ICoreWebView2CursorChangedEventHandler* sqword*';
		defineFunction: #Remove_CursorChanged:
			argumentTypes: 'sqword'
! !
!WebView2.ICoreWebView2CompositionController class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

