"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Sequence
	subclass: #'WebView2.ICoreWebView2ProcessExtendedInfoCollection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2ProcessExtendedInfoCollection guid: (OS.COM.IID fromString: '{32efa696-407a-11ee-be56-0242ac120002}')!
WebView2.ICoreWebView2ProcessExtendedInfoCollection isEgressOnly: true!
WebView2.ICoreWebView2ProcessExtendedInfoCollection comment: '`ICoreWebView2ProcessExtendedInfoCollection` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ProcessExtendedInfoCollection'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(32efa696-407a-11ee-be56-0242ac120002)
]
interface ICoreWebView2ProcessExtendedInfoCollection : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall Count(
		[out, retval]unsigned int* Count);
	[id(0x60010001)]
	HRESULT __stdcall GetValueAtIndex(
		[in]unsigned int index,
		[out, retval]ICoreWebView2ProcessExtendedInfo** processInfo);
};
```
'!
!WebView2.ICoreWebView2ProcessExtendedInfoCollection categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2ProcessExtendedInfoCollection methodsFor!

elementClass
	^ICoreWebView2ProcessExtendedInfo!

GetValueAtIndex: index value: processInfo
	"Private - Invoke the GetValueAtIndex() method of the COM object.

		HRESULT __stdcall GetValueAtIndex(
			[in]unsigned int index,
			[out, retval]ICoreWebView2ProcessExtendedInfo** processInfo);"

	<virtual stdcall: hresult 5 uint32 ICoreWebView2ProcessExtendedInfo**>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2ProcessExtendedInfoCollection categoriesForMethods!
elementClass!constants!public! !
GetValueAtIndex:value:!COM Interfaces-ICoreWebView2ProcessExtendedInfoCollection!private! !
!

!WebView2.ICoreWebView2ProcessExtendedInfoCollection class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ProcessExtendedInfoCollection'
		ICoreWebView2ProcessExtendedInfoCollection defineTemplate"

	self
		defineFunction: #get_Count:
			argumentTypes: 'uint32*';
		defineFunction: #GetValueAtIndex:value:
			argumentTypes: 'uint32 ICoreWebView2ProcessExtendedInfo**'
! !
!WebView2.ICoreWebView2ProcessExtendedInfoCollection class categoriesForMethods!
defineFunctions!initializing!public!template definition! !
!

