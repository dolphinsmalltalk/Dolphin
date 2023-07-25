"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompositionController2
	subclass: #'WebView2.ICoreWebView2CompositionController3'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2CompositionController3 guid: (OS.COM.IID fromString: '{9570570e-4d76-4361-9ee1-f04d0dbdfb1e}')!
WebView2.ICoreWebView2CompositionController3 comment: '`ICoreWebView2CompositionController3` is a wrapper class for the COM interface ''WebView2.ICoreWebView2CompositionController3'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(9570570e-4d76-4361-9ee1-f04d0dbdfb1e)
]
interface ICoreWebView2CompositionController3 : ICoreWebView2CompositionController2
 {
	[id(0x60030000)]
	HRESULT __stdcall DragEnter(
		[in]IDataObject* dataObject,
		[in]unsigned long keyState,
		[in]POINT point,
		[out, retval]unsigned long* effect);
	[id(0x60030001)]
	HRESULT __stdcall DragLeave();
	[id(0x60030002)]
	HRESULT __stdcall DragOver(
		[in]unsigned long keyState,
		[in]POINT point,
		[out, retval]unsigned long* effect);
	[id(0x60030003)]
	HRESULT __stdcall Drop(
		[in]IDataObject* dataObject,
		[in]unsigned long keyState,
		[in]POINT point,
		[out, retval]unsigned long* effect);
};
```
'!
!WebView2.ICoreWebView2CompositionController3 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2CompositionController3 methodsFor!

dragEnter: dataObject keyState: keyState point: point
	"Answer the <UInt32> result of invoking the DragEnter() method of the COM object."

	| answer |
	answer := UInt32 new.
	self
		DragEnter: dataObject
		keyState: keyState
		point: point
		effect: answer.
	^answer asObject!

DragEnter: dataObject keyState: keyState point: point effect: effect
	"Private - Invoke the DragEnter() method of the COM object.

		HRESULT __stdcall DragEnter(
			[in]IDataObject* dataObject,
			[in]unsigned long keyState,
			[in]POINT point,
			[out, retval]unsigned long* effect);"

	<virtual stdcall: hresult 13 IDataObject* uint32 POINTL uint32*>
	^self invalidCall: _failureCode!

dragLeave
	"Invoke the DragLeave() method of the COM object."

	^self DragLeave!

DragLeave
	"Private - Invoke the DragLeave() method of the COM object.

		HRESULT __stdcall DragLeave();"

	<virtual stdcall: hresult 14>
	^self invalidCall: _failureCode!

dragOver: keyState point: point
	"Answer the <UInt32> result of invoking the DragOver() method of the COM object."

	| answer |
	answer := UInt32 new.
	self
		DragOver: keyState
		point: point
		effect: answer.
	^answer asObject!

DragOver: keyState point: point effect: effect
	"Private - Invoke the DragOver() method of the COM object.

		HRESULT __stdcall DragOver(
			[in]unsigned long keyState,
			[in]POINT point,
			[out, retval]unsigned long* effect);"

	<virtual stdcall: hresult 15 uint32 POINTL uint32*>
	^self invalidCall: _failureCode!

drop: dataObject keyState: keyState point: point
	"Answer the <UInt32> result of invoking the Drop() method of the COM object."

	| answer |
	answer := UInt32 new.
	self
		Drop: dataObject
		keyState: keyState
		point: point
		effect: answer.
	^answer asObject!

Drop: dataObject keyState: keyState point: point effect: effect
	"Private - Invoke the Drop() method of the COM object.

		HRESULT __stdcall Drop(
			[in]IDataObject* dataObject,
			[in]unsigned long keyState,
			[in]POINT point,
			[out, retval]unsigned long* effect);"

	<virtual stdcall: hresult 16 IDataObject* uint32 POINTL uint32*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2CompositionController3 categoriesForMethods!
dragEnter:keyState:point:!**auto generated**!methods!public! !
DragEnter:keyState:point:effect:!**auto generated**!COM Interfaces-ICoreWebView2CompositionController3!private! !
dragLeave!**auto generated**!methods!public! !
DragLeave!**auto generated**!COM Interfaces-ICoreWebView2CompositionController3!private! !
dragOver:point:!**auto generated**!methods!public! !
DragOver:point:effect:!**auto generated**!COM Interfaces-ICoreWebView2CompositionController3!private! !
drop:keyState:point:!**auto generated**!methods!public! !
Drop:keyState:point:effect:!**auto generated**!COM Interfaces-ICoreWebView2CompositionController3!private! !
!

!WebView2.ICoreWebView2CompositionController3 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2CompositionController3'
		ICoreWebView2CompositionController3 defineTemplate"

	self
		defineFunction: #DragEnter:keyState:point:effect:
			argumentTypes: 'IDataObject* dword POINTL dword*';
		defineFunction: #DragLeave;
		defineFunction: #DragOver:point:effect:
			argumentTypes: 'dword POINTL dword*';
		defineFunction: #Drop:keyState:point:effect:
			argumentTypes: 'IDataObject* dword POINTL dword*'
! !
!WebView2.ICoreWebView2CompositionController3 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

