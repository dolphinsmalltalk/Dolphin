"Filed out from Dolphin Smallalk"!

ICoreWebView2Interface subclass: #ICoreWebView2Interop
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2Interop guid: (IID fromString: '{912b34a7-d10b-49c4-af18-7cb7e604e01a}')!
ICoreWebView2Interop comment: '`ICoreWebView2Interop` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Interop'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(912b34a7-d10b-49c4-af18-7cb7e604e01a)
]
interface ICoreWebView2Interop : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall AddHostObjectToScript(
		[in]LPWSTR name,
		[in]VARIANT* object);
};
```
'!
!ICoreWebView2Interop categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2Interop methodsFor!

addHostObjectToScript: name object: object
	"Invoke the AddHostObjectToScript() method of the COM object."

	^self AddHostObjectToScript: name asUtf16String object: object asVariant!

AddHostObjectToScript: name object: object
	"Private - Invoke the AddHostObjectToScript() method of the COM object.

		HRESULT __stdcall AddHostObjectToScript(
			[in]LPWSTR name,
			[in]VARIANT* object);"

	<virtual stdcall: hresult 4 lpwstr variant*>
	^self invalidCall: _failureCode! !
!ICoreWebView2Interop categoriesForMethods!
addHostObjectToScript:object:!**auto generated**!methods!public! !
AddHostObjectToScript:object:!**auto generated**!COM Interfaces-ICoreWebView2Interop!private! !
!

!ICoreWebView2Interop class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Interop'
		ICoreWebView2Interop defineTemplate"

	self
		defineFunction: #AddHostObjectToScript:object:
			argumentTypes: 'lpwstr variant*'
! !
!ICoreWebView2Interop class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

