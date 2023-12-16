﻿"Filed out from Dolphin Smalltalk"!

ICoreWebView2IterableCollection subclass: #ICoreWebView2FrameInfoCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2FrameInfoCollection guid: (IID fromString: '{8f834154-d38e-4d90-affb-6800a7272839}')!
ICoreWebView2FrameInfoCollection comment: '`ICoreWebView2FrameInfoCollection` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FrameInfoCollection'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(8f834154-d38e-4d90-affb-6800a7272839)
]
interface ICoreWebView2FrameInfoCollection : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall GetIterator(
		[out, retval]ICoreWebView2FrameInfoCollectionIterator** iterator);
};
```
'!
!ICoreWebView2FrameInfoCollection categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2FrameInfoCollection methodsFor!

GetIterator: iterator
	"Private - Invoke the GetIterator() method of the COM object.

		HRESULT __stdcall GetIterator(
			[out, retval]ICoreWebView2FrameInfoCollectionIterator** iterator);"

	<virtual stdcall: hresult 4 ICoreWebView2FrameInfoCollectionIterator**>
	^self invalidCall: _failureCode!

iteratorClass
	^ICoreWebView2FrameInfoCollectionIterator! !
!ICoreWebView2FrameInfoCollection categoriesForMethods!
GetIterator:!**auto generated**!COM Interfaces-ICoreWebView2FrameInfoCollection!private! !
iteratorClass!constants!private! !
!

!ICoreWebView2FrameInfoCollection class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FrameInfoCollection'
		ICoreWebView2FrameInfoCollection defineTemplate"

	self
		defineFunction: #GetIterator:
			argumentTypes: 'ICoreWebView2FrameInfoCollectionIterator**'
! !
!ICoreWebView2FrameInfoCollection class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!
