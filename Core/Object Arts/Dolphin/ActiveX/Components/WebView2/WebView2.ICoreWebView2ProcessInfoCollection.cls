"Filed out from Dolphin Smalltalk"!

ICoreWebView2Sequence subclass: #ICoreWebView2ProcessInfoCollection
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ICoreWebView2ProcessInfoCollection guid: (OS.COM.IID fromString: '{402b99cd-a0cc-4fa5-b7a5-51d86a1d2339}')!
ICoreWebView2ProcessInfoCollection comment: '`ICoreWebView2ProcessInfoCollection` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ProcessInfoCollection'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(402b99cd-a0cc-4fa5-b7a5-51d86a1d2339)
]
interface ICoreWebView2ProcessInfoCollection : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall Count(
		[out, retval]unsigned int* Count);
	[id(0x60010001)]
	HRESULT __stdcall GetValueAtIndex(
		[in]unsigned int index,
		[out, retval]ICoreWebView2ProcessInfo** processInfo);
};
```
'!
!ICoreWebView2ProcessInfoCollection categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2ProcessInfoCollection methodsFor!

elementClass
	^ICoreWebView2ProcessInfo!

GetValueAtIndex: index value: processInfo
	"Private - Invoke the GetValueAtIndex() method of the COM object.

		HRESULT __stdcall GetValueAtIndex(
			[in]unsigned int index,
			[out, retval]ICoreWebView2ProcessInfo** processInfo);"

	<virtual stdcall: hresult 5 dword ICoreWebView2ProcessInfo**>
	^self invalidCall: _failureCode! !
!ICoreWebView2ProcessInfoCollection categoriesForMethods!
elementClass!constants!public! !
GetValueAtIndex:value:!COM Interfaces-ICoreWebView2ProcessInfoCollection!private! !
!

!ICoreWebView2ProcessInfoCollection class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ProcessInfoCollection'
		ICoreWebView2ProcessInfoCollection defineTemplate"

	self
		defineFunction: #get_Count:
			argumentTypes: 'dword*';
		defineFunction: #GetValueAtIndex:value:
			argumentTypes: 'dword ICoreWebView2ProcessInfo**'
! !
!ICoreWebView2ProcessInfoCollection class categoriesForMethods!
defineFunctions!initializing!public! !
!

