"Filed out from Dolphin Smalltalk"!

ICoreWebView2Sequence subclass: #ICoreWebView2StringCollection
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ICoreWebView2StringCollection guid: (OS.COM.IID fromString: '{f41f3f8a-bcc3-11eb-8529-0242ac130003}')!
ICoreWebView2StringCollection comment: '`ICoreWebView2StringCollection` is a wrapper class for the COM interface ''WebView2.ICoreWebView2StringCollection'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(f41f3f8a-bcc3-11eb-8529-0242ac130003)
]
interface ICoreWebView2StringCollection : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall Count(
		[out, retval]unsigned int* value);
	[id(0x60010001)]
	HRESULT __stdcall GetValueAtIndex(
		[in]unsigned int index,
		[out, retval]LPWSTR* value);
};
```
'!
!ICoreWebView2StringCollection categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2StringCollection methodsFor!

at: index
	"Answer the <Utf16String> result of invoking the GetValueAtIndex() method of the COM object."

	| ptr answer |
	ptr := COMTaskMemory new.
	self GetValueAtIndex: index - 1 value: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

elementClass
	^Utf16String!

GetValueAtIndex: index value: value
	"Private - Invoke the GetValueAtIndex() method of the COM object.

		HRESULT __stdcall GetValueAtIndex(
			[in]unsigned int index,
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 5 dword lpwstr*>
	^self invalidCall: _failureCode! !
!ICoreWebView2StringCollection categoriesForMethods!
at:!methods!public! !
elementClass!constants!private! !
GetValueAtIndex:value:!**auto generated**!COM Interfaces-ICoreWebView2StringCollection!private! !
!

!ICoreWebView2StringCollection class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2StringCollection'
		ICoreWebView2StringCollection defineTemplate"

	self
		defineFunction: #get_Count:
			argumentTypes: 'dword*';
		defineFunction: #GetValueAtIndex:value:
			argumentTypes: 'dword lpwstr*'
! !
!ICoreWebView2StringCollection class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

