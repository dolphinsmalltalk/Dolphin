"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2PrintSettings
	subclass: #'WebView2.ICoreWebView2PrintSettings2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2PrintSettings2 guid: (OS.COM.IID fromString: '{ca7f0e1f-3484-41d1-8c1a-65cd44a63f8d}')!
WebView2.ICoreWebView2PrintSettings2 comment: '`ICoreWebView2PrintSettings2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2PrintSettings2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(ca7f0e1f-3484-41d1-8c1a-65cd44a63f8d)
]
interface ICoreWebView2PrintSettings2 : ICoreWebView2PrintSettings
 {
	[id(0x60020000), propget]
	HRESULT __stdcall PageRanges(
		[out, retval]LPWSTR* value);
	[id(0x60020000), propput]
	HRESULT __stdcall PageRanges(
		[in]LPWSTR value);
	[id(0x60020002), propget]
	HRESULT __stdcall PagesPerSide(
		[out, retval]int* value);
	[id(0x60020002), propput]
	HRESULT __stdcall PagesPerSide(
		[in]int value);
	[id(0x60020004), propget]
	HRESULT __stdcall Copies(
		[out, retval]int* value);
	[id(0x60020004), propput]
	HRESULT __stdcall Copies(
		[in]int value);
	[id(0x60020006), propget]
	HRESULT __stdcall Collation(
		[out, retval]COREWEBVIEW2_PRINT_COLLATION* value);
	[id(0x60020006), propput]
	HRESULT __stdcall Collation(
		[in]COREWEBVIEW2_PRINT_COLLATION value);
	[id(0x60020008), propget]
	HRESULT __stdcall ColorMode(
		[out, retval]COREWEBVIEW2_PRINT_COLOR_MODE* value);
	[id(0x60020008), propput]
	HRESULT __stdcall ColorMode(
		[in]COREWEBVIEW2_PRINT_COLOR_MODE value);
	[id(0x6002000a), propget]
	HRESULT __stdcall Duplex(
		[out, retval]COREWEBVIEW2_PRINT_DUPLEX* value);
	[id(0x6002000a), propput]
	HRESULT __stdcall Duplex(
		[in]COREWEBVIEW2_PRINT_DUPLEX value);
	[id(0x6002000c), propget]
	HRESULT __stdcall MediaSize(
		[out, retval]COREWEBVIEW2_PRINT_MEDIA_SIZE* value);
	[id(0x6002000c), propput]
	HRESULT __stdcall MediaSize(
		[in]COREWEBVIEW2_PRINT_MEDIA_SIZE value);
	[id(0x6002000e), propget]
	HRESULT __stdcall PrinterName(
		[out, retval]LPWSTR* value);
	[id(0x6002000e), propput]
	HRESULT __stdcall PrinterName(
		[in]LPWSTR value);
};
```
'!
!WebView2.ICoreWebView2PrintSettings2 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2PrintSettings2 methodsFor!

collation
	"Answer the <sdword> value of the 'Collation' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_Collation: answer.
	^answer asObject!

collation: value
	"Set the 'Collation' property of the receiver to the <sdword> value of the argument."

	self put_Collation: value!

colorMode
	"Answer the <sdword> value of the 'ColorMode' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_ColorMode: answer.
	^answer asObject!

colorMode: value
	"Set the 'ColorMode' property of the receiver to the <sdword> value of the argument."

	self put_ColorMode: value!

copies
	"Answer the <sdword> value of the 'Copies' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_Copies: answer.
	^answer asObject!

copies: value
	"Set the 'Copies' property of the receiver to the <sdword> value of the argument."

	self put_Copies: value!

duplex
	"Answer the <sdword> value of the 'Duplex' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_Duplex: answer.
	^answer asObject!

duplex: value
	"Set the 'Duplex' property of the receiver to the <sdword> value of the argument."

	self put_Duplex: value!

get_Collation: value
	"Private - Get the value of the 'Collation' property of the receiver.

		HRESULT __stdcall Collation(
			[out, retval]COREWEBVIEW2_PRINT_COLLATION* value);"

	<virtual stdcall: hresult 36 sdword*>
	^self invalidCall: _failureCode!

get_ColorMode: value
	"Private - Get the value of the 'ColorMode' property of the receiver.

		HRESULT __stdcall ColorMode(
			[out, retval]COREWEBVIEW2_PRINT_COLOR_MODE* value);"

	<virtual stdcall: hresult 38 sdword*>
	^self invalidCall: _failureCode!

get_Copies: value
	"Private - Get the value of the 'Copies' property of the receiver.

		HRESULT __stdcall Copies(
			[out, retval]int* value);"

	<virtual stdcall: hresult 34 sdword*>
	^self invalidCall: _failureCode!

get_Duplex: value
	"Private - Get the value of the 'Duplex' property of the receiver.

		HRESULT __stdcall Duplex(
			[out, retval]COREWEBVIEW2_PRINT_DUPLEX* value);"

	<virtual stdcall: hresult 40 sdword*>
	^self invalidCall: _failureCode!

get_MediaSize: value
	"Private - Get the value of the 'MediaSize' property of the receiver.

		HRESULT __stdcall MediaSize(
			[out, retval]COREWEBVIEW2_PRINT_MEDIA_SIZE* value);"

	<virtual stdcall: hresult 42 sdword*>
	^self invalidCall: _failureCode!

get_PageRanges: value
	"Private - Get the value of the 'PageRanges' property of the receiver.

		HRESULT __stdcall PageRanges(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 30 lpwstr*>
	^self invalidCall: _failureCode!

get_PagesPerSide: value
	"Private - Get the value of the 'PagesPerSide' property of the receiver.

		HRESULT __stdcall PagesPerSide(
			[out, retval]int* value);"

	<virtual stdcall: hresult 32 sdword*>
	^self invalidCall: _failureCode!

get_PrinterName: value
	"Private - Get the value of the 'PrinterName' property of the receiver.

		HRESULT __stdcall PrinterName(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 44 lpwstr*>
	^self invalidCall: _failureCode!

mediaSize
	"Answer the <sdword> value of the 'MediaSize' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_MediaSize: answer.
	^answer asObject!

mediaSize: value
	"Set the 'MediaSize' property of the receiver to the <sdword> value of the argument."

	self put_MediaSize: value!

pageRanges
	"Answer the <lpwstr> value of the 'PageRanges' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_PageRanges: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

pageRanges: value
	"Set the 'PageRanges' property of the receiver to the <lpwstr> value of the argument."

	self put_PageRanges: value asUtf16String!

pagesPerSide
	"Answer the <sdword> value of the 'PagesPerSide' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_PagesPerSide: answer.
	^answer asObject!

pagesPerSide: value
	"Set the 'PagesPerSide' property of the receiver to the <sdword> value of the argument."

	self put_PagesPerSide: value!

printableProperties
	^#(#printerName #pageRanges #collation #colorMode #copies #duplex #mediaSize #pagesPerSide)
		, super printableProperties!

printerName
	"Answer the <lpwstr> value of the 'PrinterName' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_PrinterName: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

printerName: value
	"Set the 'PrinterName' property of the receiver to the <lpwstr> value of the argument."

	self put_PrinterName: value asUtf16String!

put_Collation: value
	"Private - Set the value of the 'Collation' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall Collation(
			[in]COREWEBVIEW2_PRINT_COLLATION value);"

	<virtual stdcall: hresult 37 sdword>
	^self invalidCall: _failureCode!

put_ColorMode: value
	"Private - Set the value of the 'ColorMode' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall ColorMode(
			[in]COREWEBVIEW2_PRINT_COLOR_MODE value);"

	<virtual stdcall: hresult 39 sdword>
	^self invalidCall: _failureCode!

put_Copies: value
	"Private - Set the value of the 'Copies' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall Copies(
			[in]int value);"

	<virtual stdcall: hresult 35 sdword>
	^self invalidCall: _failureCode!

put_Duplex: value
	"Private - Set the value of the 'Duplex' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall Duplex(
			[in]COREWEBVIEW2_PRINT_DUPLEX value);"

	<virtual stdcall: hresult 41 sdword>
	^self invalidCall: _failureCode!

put_MediaSize: value
	"Private - Set the value of the 'MediaSize' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall MediaSize(
			[in]COREWEBVIEW2_PRINT_MEDIA_SIZE value);"

	<virtual stdcall: hresult 43 sdword>
	^self invalidCall: _failureCode!

put_PageRanges: value
	"Private - Set the value of the 'PageRanges' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, value.

		HRESULT __stdcall PageRanges(
			[in]LPWSTR value);"

	<virtual stdcall: hresult 31 lpwstr>
	^self invalidCall: _failureCode!

put_PagesPerSide: value
	"Private - Set the value of the 'PagesPerSide' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall PagesPerSide(
			[in]int value);"

	<virtual stdcall: hresult 33 sdword>
	^self invalidCall: _failureCode!

put_PrinterName: value
	"Private - Set the value of the 'PrinterName' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, value.

		HRESULT __stdcall PrinterName(
			[in]LPWSTR value);"

	<virtual stdcall: hresult 45 lpwstr>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2PrintSettings2 categoriesForMethods!
collation!**auto generated**!properties!public! !
collation:!**auto generated**!properties!public! !
colorMode!**auto generated**!properties!public! !
colorMode:!**auto generated**!properties!public! !
copies!**auto generated**!properties!public! !
copies:!**auto generated**!properties!public! !
duplex!**auto generated**!properties!public! !
duplex:!**auto generated**!properties!public! !
get_Collation:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings2!private! !
get_ColorMode:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings2!private! !
get_Copies:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings2!private! !
get_Duplex:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings2!private! !
get_MediaSize:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings2!private! !
get_PageRanges:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings2!private! !
get_PagesPerSide:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings2!private! !
get_PrinterName:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings2!private! !
mediaSize!**auto generated**!properties!public! !
mediaSize:!**auto generated**!properties!public! !
pageRanges!properties!public! !
pageRanges:!**auto generated**!properties!public! !
pagesPerSide!**auto generated**!properties!public! !
pagesPerSide:!**auto generated**!properties!public! !
printableProperties!printing!public! !
printerName!properties!public! !
printerName:!**auto generated**!properties!public! !
put_Collation:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings2!private! !
put_ColorMode:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings2!private! !
put_Copies:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings2!private! !
put_Duplex:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings2!private! !
put_MediaSize:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings2!private! !
put_PageRanges:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings2!private! !
put_PagesPerSide:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings2!private! !
put_PrinterName:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings2!private! !
!

!WebView2.ICoreWebView2PrintSettings2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2PrintSettings2'
		ICoreWebView2PrintSettings2 defineTemplate"

	self
		defineFunction: #get_PageRanges:
			argumentTypes: 'lpwstr*';
		defineFunction: #put_PageRanges:
			argumentTypes: 'lpwstr';
		defineFunction: #get_PagesPerSide:
			argumentTypes: 'sdword*';
		defineFunction: #put_PagesPerSide:
			argumentTypes: 'sdword';
		defineFunction: #get_Copies:
			argumentTypes: 'sdword*';
		defineFunction: #put_Copies:
			argumentTypes: 'sdword';
		defineFunction: #get_Collation:
			argumentTypes: 'sdword*';
		defineFunction: #put_Collation:
			argumentTypes: 'sdword';
		defineFunction: #get_ColorMode:
			argumentTypes: 'sdword*';
		defineFunction: #put_ColorMode:
			argumentTypes: 'sdword';
		defineFunction: #get_Duplex:
			argumentTypes: 'sdword*';
		defineFunction: #put_Duplex:
			argumentTypes: 'sdword';
		defineFunction: #get_MediaSize:
			argumentTypes: 'sdword*';
		defineFunction: #put_MediaSize:
			argumentTypes: 'sdword';
		defineFunction: #get_PrinterName:
			argumentTypes: 'lpwstr*';
		defineFunction: #put_PrinterName:
			argumentTypes: 'lpwstr'
! !
!WebView2.ICoreWebView2PrintSettings2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

