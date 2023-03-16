"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface subclass: #'WebView2.ICoreWebView2PrintSettings'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2PrintSettings guid: (OS.COM.IID fromString: '{377f3721-c74e-48ca-8db1-df68e51d60e2}')!
WebView2.ICoreWebView2PrintSettings comment: '`ICoreWebView2PrintSettings` is a wrapper class for the COM interface ''WebView2.ICoreWebView2PrintSettings'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(377f3721-c74e-48ca-8db1-df68e51d60e2)
]
interface ICoreWebView2PrintSettings : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall Orientation(
		[out, retval]COREWEBVIEW2_PRINT_ORIENTATION* Orientation);
	[id(0x60010000), propput]
	HRESULT __stdcall Orientation(
		[in]COREWEBVIEW2_PRINT_ORIENTATION Orientation);
	[id(0x60010002), propget]
	HRESULT __stdcall ScaleFactor(
		[out, retval]double* ScaleFactor);
	[id(0x60010002), propput]
	HRESULT __stdcall ScaleFactor(
		[in]double ScaleFactor);
	[id(0x60010004), propget]
	HRESULT __stdcall PageWidth(
		[out, retval]double* PageWidth);
	[id(0x60010004), propput]
	HRESULT __stdcall PageWidth(
		[in]double PageWidth);
	[id(0x60010006), propget]
	HRESULT __stdcall PageHeight(
		[out, retval]double* PageHeight);
	[id(0x60010006), propput]
	HRESULT __stdcall PageHeight(
		[in]double PageHeight);
	[id(0x60010008), propget]
	HRESULT __stdcall MarginTop(
		[out, retval]double* MarginTop);
	[id(0x60010008), propput]
	HRESULT __stdcall MarginTop(
		[in]double MarginTop);
	[id(0x6001000a), propget]
	HRESULT __stdcall MarginBottom(
		[out, retval]double* MarginBottom);
	[id(0x6001000a), propput]
	HRESULT __stdcall MarginBottom(
		[in]double MarginBottom);
	[id(0x6001000c), propget]
	HRESULT __stdcall MarginLeft(
		[out, retval]double* MarginLeft);
	[id(0x6001000c), propput]
	HRESULT __stdcall MarginLeft(
		[in]double MarginLeft);
	[id(0x6001000e), propget]
	HRESULT __stdcall MarginRight(
		[out, retval]double* MarginRight);
	[id(0x6001000e), propput]
	HRESULT __stdcall MarginRight(
		[in]double MarginRight);
	[id(0x60010010), propget]
	HRESULT __stdcall ShouldPrintBackgrounds(
		[out, retval]long* ShouldPrintBackgrounds);
	[id(0x60010010), propput]
	HRESULT __stdcall ShouldPrintBackgrounds(
		[in]long ShouldPrintBackgrounds);
	[id(0x60010012), propget]
	HRESULT __stdcall ShouldPrintSelectionOnly(
		[out, retval]long* ShouldPrintSelectionOnly);
	[id(0x60010012), propput]
	HRESULT __stdcall ShouldPrintSelectionOnly(
		[in]long ShouldPrintSelectionOnly);
	[id(0x60010014), propget]
	HRESULT __stdcall ShouldPrintHeaderAndFooter(
		[out, retval]long* ShouldPrintHeaderAndFooter);
	[id(0x60010014), propput]
	HRESULT __stdcall ShouldPrintHeaderAndFooter(
		[in]long ShouldPrintHeaderAndFooter);
	[id(0x60010016), propget]
	HRESULT __stdcall HeaderTitle(
		[out, retval]LPWSTR* HeaderTitle);
	[id(0x60010016), propput]
	HRESULT __stdcall HeaderTitle(
		[in]LPWSTR HeaderTitle);
	[id(0x60010018), propget]
	HRESULT __stdcall FooterUri(
		[out, retval]LPWSTR* FooterUri);
	[id(0x60010018), propput]
	HRESULT __stdcall FooterUri(
		[in]LPWSTR FooterUri);
};
```
'!
!WebView2.ICoreWebView2PrintSettings categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2PrintSettings methodsFor!

downCast
	^self queryInterface: ICoreWebView2PrintSettings2 ifNone: [self]!

footerUri
	"Answer the <lpwstr> value of the 'FooterUri' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_FooterUri: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

footerUri: footerUri
	"Set the 'FooterUri' property of the receiver to the <lpwstr> value of the argument."

	self put_FooterUri: footerUri asUtf16String!

get_FooterUri: footerUri
	"Private - Get the value of the 'FooterUri' property of the receiver.

		HRESULT __stdcall FooterUri(
			[out, retval]LPWSTR* FooterUri);"

	<virtual stdcall: hresult 28 lpwstr*>
	^self invalidCall: _failureCode!

get_HeaderTitle: headerTitle
	"Private - Get the value of the 'HeaderTitle' property of the receiver.

		HRESULT __stdcall HeaderTitle(
			[out, retval]LPWSTR* HeaderTitle);"

	<virtual stdcall: hresult 26 lpwstr*>
	^self invalidCall: _failureCode!

get_MarginBottom: marginBottom
	"Private - Get the value of the 'MarginBottom' property of the receiver.

		HRESULT __stdcall MarginBottom(
			[out, retval]double* MarginBottom);"

	<virtual stdcall: hresult 14 double*>
	^self invalidCall: _failureCode!

get_MarginLeft: marginLeft
	"Private - Get the value of the 'MarginLeft' property of the receiver.

		HRESULT __stdcall MarginLeft(
			[out, retval]double* MarginLeft);"

	<virtual stdcall: hresult 16 double*>
	^self invalidCall: _failureCode!

get_MarginRight: marginRight
	"Private - Get the value of the 'MarginRight' property of the receiver.

		HRESULT __stdcall MarginRight(
			[out, retval]double* MarginRight);"

	<virtual stdcall: hresult 18 double*>
	^self invalidCall: _failureCode!

get_MarginTop: marginTop
	"Private - Get the value of the 'MarginTop' property of the receiver.

		HRESULT __stdcall MarginTop(
			[out, retval]double* MarginTop);"

	<virtual stdcall: hresult 12 double*>
	^self invalidCall: _failureCode!

get_Orientation: orientation
	"Private - Get the value of the 'Orientation' property of the receiver.

		HRESULT __stdcall Orientation(
			[out, retval]COREWEBVIEW2_PRINT_ORIENTATION* Orientation);"

	<virtual stdcall: hresult 4 sdword*>
	^self invalidCall: _failureCode!

get_PageHeight: pageHeight
	"Private - Get the value of the 'PageHeight' property of the receiver.

		HRESULT __stdcall PageHeight(
			[out, retval]double* PageHeight);"

	<virtual stdcall: hresult 10 double*>
	^self invalidCall: _failureCode!

get_PageWidth: pageWidth
	"Private - Get the value of the 'PageWidth' property of the receiver.

		HRESULT __stdcall PageWidth(
			[out, retval]double* PageWidth);"

	<virtual stdcall: hresult 8 double*>
	^self invalidCall: _failureCode!

get_ScaleFactor: scaleFactor
	"Private - Get the value of the 'ScaleFactor' property of the receiver.

		HRESULT __stdcall ScaleFactor(
			[out, retval]double* ScaleFactor);"

	<virtual stdcall: hresult 6 double*>
	^self invalidCall: _failureCode!

get_ShouldPrintBackgrounds: shouldPrintBackgrounds
	"Private - Get the value of the 'ShouldPrintBackgrounds' property of the receiver.

		HRESULT __stdcall ShouldPrintBackgrounds(
			[out, retval]long* ShouldPrintBackgrounds);"

	<virtual stdcall: hresult 20 sdword*>
	^self invalidCall: _failureCode!

get_ShouldPrintHeaderAndFooter: shouldPrintHeaderAndFooter
	"Private - Get the value of the 'ShouldPrintHeaderAndFooter' property of the receiver.

		HRESULT __stdcall ShouldPrintHeaderAndFooter(
			[out, retval]long* ShouldPrintHeaderAndFooter);"

	<virtual stdcall: hresult 24 sdword*>
	^self invalidCall: _failureCode!

get_ShouldPrintSelectionOnly: shouldPrintSelectionOnly
	"Private - Get the value of the 'ShouldPrintSelectionOnly' property of the receiver.

		HRESULT __stdcall ShouldPrintSelectionOnly(
			[out, retval]long* ShouldPrintSelectionOnly);"

	<virtual stdcall: hresult 22 sdword*>
	^self invalidCall: _failureCode!

headerTitle
	"Answer the <lpwstr> value of the 'HeaderTitle' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_HeaderTitle: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

headerTitle: headerTitle
	"Set the 'HeaderTitle' property of the receiver to the <lpwstr> value of the argument."

	self put_HeaderTitle: headerTitle asUtf16String!

marginBottom
	"Answer the <double> value of the 'MarginBottom' property of the receiver."

	| answer |
	answer := DOUBLE new.
	self get_MarginBottom: answer.
	^answer asObject!

marginBottom: marginBottom
	"Set the 'MarginBottom' property of the receiver to the <double> value of the argument."

	self put_MarginBottom: marginBottom!

marginLeft
	"Answer the <double> value of the 'MarginLeft' property of the receiver."

	| answer |
	answer := DOUBLE new.
	self get_MarginLeft: answer.
	^answer asObject!

marginLeft: marginLeft
	"Set the 'MarginLeft' property of the receiver to the <double> value of the argument."

	self put_MarginLeft: marginLeft!

marginRight
	"Answer the <double> value of the 'MarginRight' property of the receiver."

	| answer |
	answer := DOUBLE new.
	self get_MarginRight: answer.
	^answer asObject!

marginRight: marginRight
	"Set the 'MarginRight' property of the receiver to the <double> value of the argument."

	self put_MarginRight: marginRight!

margins
	^self marginLeft @ self marginTop corner: self marginRight @ self marginBottom!

marginTop
	"Answer the <double> value of the 'MarginTop' property of the receiver."

	| answer |
	answer := DOUBLE new.
	self get_MarginTop: answer.
	^answer asObject!

marginTop: marginTop
	"Set the 'MarginTop' property of the receiver to the <double> value of the argument."

	self put_MarginTop: marginTop!

orientation
	"Answer the <sdword> value of the 'Orientation' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_Orientation: answer.
	^answer asObject!

orientation: orientation
	"Set the 'Orientation' property of the receiver to the <sdword> value of the argument."

	self put_Orientation: orientation!

pageExtent
	^self pageWidth @ self pageHeight!

pageHeight
	"Answer the <double> value of the 'PageHeight' property of the receiver."

	| answer |
	answer := DOUBLE new.
	self get_PageHeight: answer.
	^answer asObject!

pageHeight: pageHeight
	"Set the 'PageHeight' property of the receiver to the <double> value of the argument."

	self put_PageHeight: pageHeight!

pageWidth
	"Answer the <double> value of the 'PageWidth' property of the receiver."

	| answer |
	answer := DOUBLE new.
	self get_PageWidth: answer.
	^answer asObject!

pageWidth: pageWidth
	"Set the 'PageWidth' property of the receiver to the <double> value of the argument."

	self put_PageWidth: pageWidth!

printableProperties
	^#(#footerUri #headerTitle #margins #orientation #pageExtent #scaleFactor #shouldPrintBackgrounds #shouldPrintHeaderAndFooter #shouldPrintSelectionOnly)!

put_FooterUri: footerUri
	"Private - Set the value of the 'FooterUri' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, footerUri.

		HRESULT __stdcall FooterUri(
			[in]LPWSTR FooterUri);"

	<virtual stdcall: hresult 29 lpwstr>
	^self invalidCall: _failureCode!

put_HeaderTitle: headerTitle
	"Private - Set the value of the 'HeaderTitle' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, headerTitle.

		HRESULT __stdcall HeaderTitle(
			[in]LPWSTR HeaderTitle);"

	<virtual stdcall: hresult 27 lpwstr>
	^self invalidCall: _failureCode!

put_MarginBottom: marginBottom
	"Private - Set the value of the 'MarginBottom' property of the object wrapped by the 
	 receiver to the <double> argument, marginBottom.

		HRESULT __stdcall MarginBottom(
			[in]double MarginBottom);"

	<virtual stdcall: hresult 15 double>
	^self invalidCall: _failureCode!

put_MarginLeft: marginLeft
	"Private - Set the value of the 'MarginLeft' property of the object wrapped by the 
	 receiver to the <double> argument, marginLeft.

		HRESULT __stdcall MarginLeft(
			[in]double MarginLeft);"

	<virtual stdcall: hresult 17 double>
	^self invalidCall: _failureCode!

put_MarginRight: marginRight
	"Private - Set the value of the 'MarginRight' property of the object wrapped by the 
	 receiver to the <double> argument, marginRight.

		HRESULT __stdcall MarginRight(
			[in]double MarginRight);"

	<virtual stdcall: hresult 19 double>
	^self invalidCall: _failureCode!

put_MarginTop: marginTop
	"Private - Set the value of the 'MarginTop' property of the object wrapped by the 
	 receiver to the <double> argument, marginTop.

		HRESULT __stdcall MarginTop(
			[in]double MarginTop);"

	<virtual stdcall: hresult 13 double>
	^self invalidCall: _failureCode!

put_Orientation: orientation
	"Private - Set the value of the 'Orientation' property of the object wrapped by the 
	 receiver to the <sdword> argument, orientation.

		HRESULT __stdcall Orientation(
			[in]COREWEBVIEW2_PRINT_ORIENTATION Orientation);"

	<virtual stdcall: hresult 5 sdword>
	^self invalidCall: _failureCode!

put_PageHeight: pageHeight
	"Private - Set the value of the 'PageHeight' property of the object wrapped by the 
	 receiver to the <double> argument, pageHeight.

		HRESULT __stdcall PageHeight(
			[in]double PageHeight);"

	<virtual stdcall: hresult 11 double>
	^self invalidCall: _failureCode!

put_PageWidth: pageWidth
	"Private - Set the value of the 'PageWidth' property of the object wrapped by the 
	 receiver to the <double> argument, pageWidth.

		HRESULT __stdcall PageWidth(
			[in]double PageWidth);"

	<virtual stdcall: hresult 9 double>
	^self invalidCall: _failureCode!

put_ScaleFactor: scaleFactor
	"Private - Set the value of the 'ScaleFactor' property of the object wrapped by the 
	 receiver to the <double> argument, scaleFactor.

		HRESULT __stdcall ScaleFactor(
			[in]double ScaleFactor);"

	<virtual stdcall: hresult 7 double>
	^self invalidCall: _failureCode!

put_ShouldPrintBackgrounds: shouldPrintBackgrounds
	"Private - Set the value of the 'ShouldPrintBackgrounds' property of the object wrapped by the 
	 receiver to the <sdword> argument, shouldPrintBackgrounds.

		HRESULT __stdcall ShouldPrintBackgrounds(
			[in]long ShouldPrintBackgrounds);"

	<virtual stdcall: hresult 21 sdword>
	^self invalidCall: _failureCode!

put_ShouldPrintHeaderAndFooter: shouldPrintHeaderAndFooter
	"Private - Set the value of the 'ShouldPrintHeaderAndFooter' property of the object wrapped by the 
	 receiver to the <sdword> argument, shouldPrintHeaderAndFooter.

		HRESULT __stdcall ShouldPrintHeaderAndFooter(
			[in]long ShouldPrintHeaderAndFooter);"

	<virtual stdcall: hresult 25 sdword>
	^self invalidCall: _failureCode!

put_ShouldPrintSelectionOnly: shouldPrintSelectionOnly
	"Private - Set the value of the 'ShouldPrintSelectionOnly' property of the object wrapped by the 
	 receiver to the <sdword> argument, shouldPrintSelectionOnly.

		HRESULT __stdcall ShouldPrintSelectionOnly(
			[in]long ShouldPrintSelectionOnly);"

	<virtual stdcall: hresult 23 sdword>
	^self invalidCall: _failureCode!

scaleFactor
	"Answer the <double> value of the 'ScaleFactor' property of the receiver."

	| answer |
	answer := DOUBLE new.
	self get_ScaleFactor: answer.
	^answer asObject!

scaleFactor: scaleFactor
	"Set the 'ScaleFactor' property of the receiver to the <double> value of the argument."

	self put_ScaleFactor: scaleFactor!

shouldPrintBackgrounds
	"Answer the <Boolean> value of the 'ShouldPrintBackgrounds' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_ShouldPrintBackgrounds: buf.
	^buf asBoolean!

shouldPrintBackgrounds: shouldPrintBackgrounds
	"Set the 'ShouldPrintBackgrounds' property of the receiver to the <sdword> value of the argument."

	self put_ShouldPrintBackgrounds: shouldPrintBackgrounds asParameter!

shouldPrintHeaderAndFooter
	"Answer the <Boolean> value of the 'ShouldPrintHeaderAndFooter' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_ShouldPrintHeaderAndFooter: buf.
	^buf asBoolean!

shouldPrintHeaderAndFooter: shouldPrintHeaderAndFooter
	"Set the 'ShouldPrintHeaderAndFooter' property of the receiver to the <sdword> value of the argument."

	self put_ShouldPrintHeaderAndFooter: shouldPrintHeaderAndFooter asParameter!

shouldPrintSelectionOnly
	"Answer the <Boolean> value of the 'ShouldPrintSelectionOnly' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_ShouldPrintSelectionOnly: buf.
	^buf asBoolean!

shouldPrintSelectionOnly: shouldPrintSelectionOnly
	"Set the 'ShouldPrintSelectionOnly' property of the receiver to the <sdword> value of the argument."

	self put_ShouldPrintSelectionOnly: shouldPrintSelectionOnly asParameter! !
!WebView2.ICoreWebView2PrintSettings categoriesForMethods!
downCast!converting!public! !
footerUri!properties!public! !
footerUri:!**auto generated**!properties!public! !
get_FooterUri:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings!private! !
get_HeaderTitle:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings!private! !
get_MarginBottom:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings!private! !
get_MarginLeft:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings!private! !
get_MarginRight:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings!private! !
get_MarginTop:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings!private! !
get_Orientation:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings!private! !
get_PageHeight:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings!private! !
get_PageWidth:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings!private! !
get_ScaleFactor:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings!private! !
get_ShouldPrintBackgrounds:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings!private! !
get_ShouldPrintHeaderAndFooter:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings!private! !
get_ShouldPrintSelectionOnly:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings!private! !
headerTitle!properties!public! !
headerTitle:!**auto generated**!properties!public! !
marginBottom!**auto generated**!properties!public! !
marginBottom:!**auto generated**!properties!public! !
marginLeft!**auto generated**!properties!public! !
marginLeft:!**auto generated**!properties!public! !
marginRight!**auto generated**!properties!public! !
marginRight:!**auto generated**!properties!public! !
margins!properties!public! !
marginTop!**auto generated**!properties!public! !
marginTop:!**auto generated**!properties!public! !
orientation!**auto generated**!properties!public! !
orientation:!**auto generated**!properties!public! !
pageExtent!properties!public! !
pageHeight!**auto generated**!properties!public! !
pageHeight:!**auto generated**!properties!public! !
pageWidth!**auto generated**!properties!public! !
pageWidth:!**auto generated**!properties!public! !
printableProperties!printing!public! !
put_FooterUri:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings!private! !
put_HeaderTitle:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings!private! !
put_MarginBottom:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings!private! !
put_MarginLeft:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings!private! !
put_MarginRight:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings!private! !
put_MarginTop:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings!private! !
put_Orientation:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings!private! !
put_PageHeight:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings!private! !
put_PageWidth:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings!private! !
put_ScaleFactor:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings!private! !
put_ShouldPrintBackgrounds:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings!private! !
put_ShouldPrintHeaderAndFooter:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings!private! !
put_ShouldPrintSelectionOnly:!**auto generated**!COM Interfaces-ICoreWebView2PrintSettings!private! !
scaleFactor!**auto generated**!properties!public! !
scaleFactor:!**auto generated**!properties!public! !
shouldPrintBackgrounds!properties!public! !
shouldPrintBackgrounds:!properties!public! !
shouldPrintHeaderAndFooter!properties!public! !
shouldPrintHeaderAndFooter:!properties!public! !
shouldPrintSelectionOnly!properties!public! !
shouldPrintSelectionOnly:!properties!public! !
!

!WebView2.ICoreWebView2PrintSettings class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2PrintSettings'
		ICoreWebView2PrintSettings defineTemplate"

	self
		defineFunction: #get_Orientation:
			argumentTypes: 'sdword*';
		defineFunction: #put_Orientation:
			argumentTypes: 'sdword';
		defineFunction: #get_ScaleFactor:
			argumentTypes: 'double*';
		defineFunction: #put_ScaleFactor:
			argumentTypes: 'double';
		defineFunction: #get_PageWidth:
			argumentTypes: 'double*';
		defineFunction: #put_PageWidth:
			argumentTypes: 'double';
		defineFunction: #get_PageHeight:
			argumentTypes: 'double*';
		defineFunction: #put_PageHeight:
			argumentTypes: 'double';
		defineFunction: #get_MarginTop:
			argumentTypes: 'double*';
		defineFunction: #put_MarginTop:
			argumentTypes: 'double';
		defineFunction: #get_MarginBottom:
			argumentTypes: 'double*';
		defineFunction: #put_MarginBottom:
			argumentTypes: 'double';
		defineFunction: #get_MarginLeft:
			argumentTypes: 'double*';
		defineFunction: #put_MarginLeft:
			argumentTypes: 'double';
		defineFunction: #get_MarginRight:
			argumentTypes: 'double*';
		defineFunction: #put_MarginRight:
			argumentTypes: 'double';
		defineFunction: #get_ShouldPrintBackgrounds:
			argumentTypes: 'sdword*';
		defineFunction: #put_ShouldPrintBackgrounds:
			argumentTypes: 'sdword';
		defineFunction: #get_ShouldPrintSelectionOnly:
			argumentTypes: 'sdword*';
		defineFunction: #put_ShouldPrintSelectionOnly:
			argumentTypes: 'sdword';
		defineFunction: #get_ShouldPrintHeaderAndFooter:
			argumentTypes: 'sdword*';
		defineFunction: #put_ShouldPrintHeaderAndFooter:
			argumentTypes: 'sdword';
		defineFunction: #get_HeaderTitle:
			argumentTypes: 'lpwstr*';
		defineFunction: #put_HeaderTitle:
			argumentTypes: 'lpwstr';
		defineFunction: #get_FooterUri:
			argumentTypes: 'lpwstr*';
		defineFunction: #put_FooterUri:
			argumentTypes: 'lpwstr'
! !
!WebView2.ICoreWebView2PrintSettings class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

