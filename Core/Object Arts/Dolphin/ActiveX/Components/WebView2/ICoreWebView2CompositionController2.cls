"Filed out from Dolphin Smalltalk"!

ICoreWebView2CompositionController subclass: #ICoreWebView2CompositionController2
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Smalltalk.WebView2Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
ICoreWebView2CompositionController2 guid: (OS.COM.IID fromString: '{0b6a3d24-49cb-4806-ba20-b5e0734a7b26}')!
ICoreWebView2CompositionController2 comment: '`ICoreWebView2CompositionController2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2CompositionController2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(0b6a3d24-49cb-4806-ba20-b5e0734a7b26)
]
interface ICoreWebView2CompositionController2 : ICoreWebView2CompositionController
 {
	[id(0x60020000), propget]
	HRESULT __stdcall UIAProvider(
		[out, retval]IUnknown** provider);
};
```
'!
!ICoreWebView2CompositionController2 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2CompositionController2 methodsFor!

get_UIAProvider: provider
	"Private - Get the value of the 'UIAProvider' property of the receiver.

		HRESULT __stdcall UIAProvider(
			[out, retval]IUnknown** provider);"

	<virtual stdcall: hresult 12 IUnknown**>
	^self invalidCall: _failureCode! !
!ICoreWebView2CompositionController2 categoriesForMethods!
get_UIAProvider:!**auto generated**!COM Interfaces-ICoreWebView2CompositionController2!private! !
!

!ICoreWebView2CompositionController2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2CompositionController2'
		ICoreWebView2CompositionController2 defineTemplate"

	self
		defineFunction: #get_UIAProvider:
			argumentTypes: 'IUnknown**'
! !
!ICoreWebView2CompositionController2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

