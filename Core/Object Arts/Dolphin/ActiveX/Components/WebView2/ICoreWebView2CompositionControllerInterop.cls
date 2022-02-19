"Filed out from Dolphin Smallalk"!

ICoreWebView2Interface subclass: #ICoreWebView2CompositionControllerInterop
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2CompositionControllerInterop guid: (IID fromString: '{8e9922ce-9c80-42e6-bad7-fcebf291a495}')!
ICoreWebView2CompositionControllerInterop comment: '`ICoreWebView2CompositionControllerInterop` is a wrapper class for the COM interface ''WebView2.ICoreWebView2CompositionControllerInterop'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(8e9922ce-9c80-42e6-bad7-fcebf291a495)
]
interface ICoreWebView2CompositionControllerInterop : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall UIAProvider(
		[out, retval]IUnknown** provider);
	[id(0x60010001), propget]
	HRESULT __stdcall RootVisualTarget(
		[out, retval]IUnknown** target);
	[id(0x60010001), propput]
	HRESULT __stdcall RootVisualTarget(
		[in]IUnknown* target);
};
```
'!
!ICoreWebView2CompositionControllerInterop categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2CompositionControllerInterop methodsFor!

get_RootVisualTarget: target
	"Private - Get the value of the 'RootVisualTarget' property of the receiver.

		HRESULT __stdcall RootVisualTarget(
			[out, retval]IUnknown** target);"

	<virtual stdcall: hresult 5 IUnknown**>
	^self invalidCall: _failureCode!

get_UIAProvider: provider
	"Private - Get the value of the 'UIAProvider' property of the receiver.

		HRESULT __stdcall UIAProvider(
			[out, retval]IUnknown** provider);"

	<virtual stdcall: hresult 4 IUnknown**>
	^self invalidCall: _failureCode!

put_RootVisualTarget: target
	"Private - Set the value of the 'RootVisualTarget' property of the object wrapped by the 
	 receiver to the <IUnknown*> argument, target.

		HRESULT __stdcall RootVisualTarget(
			[in]IUnknown* target);"

	<virtual stdcall: hresult 6 IUnknown*>
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

uiaProvider
	"Answer the <IUnknown> value of the 'UIAProvider' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get_UIAProvider: answer.
	^answer asObject! !
!ICoreWebView2CompositionControllerInterop categoriesForMethods!
get_RootVisualTarget:!**auto generated**!COM Interfaces-ICoreWebView2CompositionControllerInterop!private! !
get_UIAProvider:!**auto generated**!COM Interfaces-ICoreWebView2CompositionControllerInterop!private! !
put_RootVisualTarget:!**auto generated**!COM Interfaces-ICoreWebView2CompositionControllerInterop!private! !
rootVisualTarget!**auto generated**!properties!public! !
rootVisualTarget:!**auto generated**!properties!public! !
uiaProvider!**auto generated**!properties!public! !
!

!ICoreWebView2CompositionControllerInterop class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2CompositionControllerInterop'
		ICoreWebView2CompositionControllerInterop defineTemplate"

	self
		defineFunction: #get_UIAProvider:
			argumentTypes: 'IUnknown**';
		defineFunction: #get_RootVisualTarget:
			argumentTypes: 'IUnknown**';
		defineFunction: #put_RootVisualTarget:
			argumentTypes: 'IUnknown*'
! !
!ICoreWebView2CompositionControllerInterop class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

