﻿"Filed out from Dolphin Smalltalk"!

ICoreWebView2Environment8 subclass: #ICoreWebView2Environment9
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ICoreWebView2Environment9 guid: (IID fromString: '{f06f41bf-4b5a-49d8-b9f6-fa16cd29f274}')!

ICoreWebView2Environment9 comment: '`ICoreWebView2Environment9` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Environment9'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(f06f41bf-4b5a-49d8-b9f6-fa16cd29f274)
]
interface ICoreWebView2Environment9 : ICoreWebView2Environment8
 {
	[id(0x60090000)]
	HRESULT __stdcall CreateContextMenuItem(
		[in]LPWSTR Label,
		[in]IStream* iconStream,
		[in]COREWEBVIEW2_CONTEXT_MENU_ITEM_KIND Kind,
		[out, retval]ICoreWebView2ContextMenuItem** item);
};
```
'!

!ICoreWebView2Environment9 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!ICoreWebView2Environment9 methodsFor!

CreateContextMenuItem: label iconStream: iconStream kind: kind item: item
	"Private - Invoke the CreateContextMenuItem() method of the COM object.

		HRESULT __stdcall CreateContextMenuItem(
			[in]LPWSTR Label,
			[in]IStream* iconStream,
			[in]COREWEBVIEW2_CONTEXT_MENU_ITEM_KIND Kind,
			[out, retval]ICoreWebView2ContextMenuItem** item);"

	<virtual stdcall: hresult 20 lpwstr IStream* sdword ICoreWebView2ContextMenuItem**>
	^self invalidCall: _failureCode! !

!ICoreWebView2Environment9 categoriesForMethods!
CreateContextMenuItem:iconStream:kind:item:!**auto generated**!COM Interfaces-ICoreWebView2Environment9!private! !
!

!ICoreWebView2Environment9 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Environment9'
		ICoreWebView2Environment9 defineTemplate"

	self
		defineFunction: #CreateContextMenuItem:iconStream:kind:item:
			argumentTypes: 'lpwstr IStream* sdword ICoreWebView2ContextMenuItem**'
! !

!ICoreWebView2Environment9 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!
