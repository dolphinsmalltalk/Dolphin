"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2FindOptions'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2FindOptions guid: (OS.COM.IID fromString: '{e82e3b2b-a4af-5bc6-94c6-18b44157a16c}')!

WebView2.ICoreWebView2FindOptions comment: '`ICoreWebView2FindOptions` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FindOptions'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(e82e3b2b-a4af-5bc6-94c6-18b44157a16c)
]
interface ICoreWebView2FindOptions : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall FindTerm(
		[out, retval]LPWSTR* value);
	[id(0x60010000), propput]
	HRESULT __stdcall FindTerm(
		[in]LPWSTR value);
	[id(0x60010002), propget]
	HRESULT __stdcall IsCaseSensitive(
		[out, retval]long* value);
	[id(0x60010002), propput]
	HRESULT __stdcall IsCaseSensitive(
		[in]long value);
	[id(0x60010004), propget]
	HRESULT __stdcall ShouldHighlightAllMatches(
		[out, retval]long* value);
	[id(0x60010004), propput]
	HRESULT __stdcall ShouldHighlightAllMatches(
		[in]long value);
	[id(0x60010006), propget]
	HRESULT __stdcall ShouldMatchWord(
		[out, retval]long* value);
	[id(0x60010006), propput]
	HRESULT __stdcall ShouldMatchWord(
		[in]long value);
	[id(0x60010008), propget]
	HRESULT __stdcall SuppressDefaultFindDialog(
		[out, retval]long* value);
	[id(0x60010008), propput]
	HRESULT __stdcall SuppressDefaultFindDialog(
		[in]long value);
};
```
'!

!WebView2.ICoreWebView2FindOptions categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2FindOptions methodsFor!

findTerm
	"Answer the <lpwstr> value of the 'FindTerm' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_FindTerm: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

findTerm: value
	"Set the 'FindTerm' property of the receiver to the <lpwstr> value of the argument."

	self put_FindTerm: value asUtf16String!

get_FindTerm: value
	"Private - Get the value of the 'FindTerm' property of the receiver.

		HRESULT __stdcall FindTerm(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

get_IsCaseSensitive: value
	"Private - Get the value of the 'IsCaseSensitive' property of the receiver.

		HRESULT __stdcall IsCaseSensitive(
			[out, retval]long* value);"

	<virtual stdcall: hresult 6 int32*>
	^self invalidCall: _failureCode!

get_ShouldHighlightAllMatches: value
	"Private - Get the value of the 'ShouldHighlightAllMatches' property of the receiver.

		HRESULT __stdcall ShouldHighlightAllMatches(
			[out, retval]long* value);"

	<virtual stdcall: hresult 8 int32*>
	^self invalidCall: _failureCode!

get_ShouldMatchWord: value
	"Private - Get the value of the 'ShouldMatchWord' property of the receiver.

		HRESULT __stdcall ShouldMatchWord(
			[out, retval]long* value);"

	<virtual stdcall: hresult 10 int32*>
	^self invalidCall: _failureCode!

get_SuppressDefaultFindDialog: value
	"Private - Get the value of the 'SuppressDefaultFindDialog' property of the receiver.

		HRESULT __stdcall SuppressDefaultFindDialog(
			[out, retval]long* value);"

	<virtual stdcall: hresult 12 int32*>
	^self invalidCall: _failureCode!

isCaseSensitive
	"Answer the <Boolean> value of the 'IsCaseSensitive' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_IsCaseSensitive: buf.
	^buf asBoolean!

isCaseSensitive: aBoolean
	"Set the 'IsCaseSensitive' property of the receiver to the <boolean> value of the argument."

	self put_IsCaseSensitive: aBoolean asParameter!

put_FindTerm: value
	"Private - Set the value of the 'FindTerm' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, value.

		HRESULT __stdcall FindTerm(
			[in]LPWSTR value);"

	<virtual stdcall: hresult 5 lpwstr>
	^self invalidCall: _failureCode!

put_IsCaseSensitive: value
	"Private - Set the value of the 'IsCaseSensitive' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall IsCaseSensitive(
			[in]long value);"

	<virtual stdcall: hresult 7 int32>
	^self invalidCall: _failureCode!

put_ShouldHighlightAllMatches: value
	"Private - Set the value of the 'ShouldHighlightAllMatches' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall ShouldHighlightAllMatches(
			[in]long value);"

	<virtual stdcall: hresult 9 int32>
	^self invalidCall: _failureCode!

put_ShouldMatchWord: value
	"Private - Set the value of the 'ShouldMatchWord' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall ShouldMatchWord(
			[in]long value);"

	<virtual stdcall: hresult 11 int32>
	^self invalidCall: _failureCode!

put_SuppressDefaultFindDialog: value
	"Private - Set the value of the 'SuppressDefaultFindDialog' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall SuppressDefaultFindDialog(
			[in]long value);"

	<virtual stdcall: hresult 13 int32>
	^self invalidCall: _failureCode!

shouldHighlightAllMatches
	"Answer the <Boolean> value of the 'ShouldHighlightAllMatches' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_ShouldHighlightAllMatches: buf.
	^buf asBoolean!

shouldHighlightAllMatches: aBoolean
	"Set the 'ShouldHighlightAllMatches' property of the receiver to the <boolean> value of the argument."

	self put_ShouldHighlightAllMatches: aBoolean asParameter!

shouldMatchWord
	"Answer the <Boolean> value of the 'ShouldMatchWord' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_ShouldMatchWord: buf.
	^buf asBoolean!

shouldMatchWord: aBoolean
	"Set the 'ShouldMatchWord' property of the receiver to the <boolean> value of the argument."

	self put_ShouldMatchWord: aBoolean asParameter!

suppressDefaultFindDialog
	"Answer the <Boolean> value of the 'SuppressDefaultFindDialog' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_SuppressDefaultFindDialog: buf.
	^buf asBoolean!

suppressDefaultFindDialog: aBoolean
	"Set the 'SuppressDefaultFindDialog' property of the receiver to the <boolean> value of the argument."

	self put_SuppressDefaultFindDialog: aBoolean asParameter! !

!WebView2.ICoreWebView2FindOptions categoriesForMethods!
findTerm!properties!public! !
findTerm:!**auto generated**!properties!public! !
get_FindTerm:!**auto generated**!COM Interfaces-ICoreWebView2FindOptions!private! !
get_IsCaseSensitive:!**auto generated**!COM Interfaces-ICoreWebView2FindOptions!private! !
get_ShouldHighlightAllMatches:!**auto generated**!COM Interfaces-ICoreWebView2FindOptions!private! !
get_ShouldMatchWord:!**auto generated**!COM Interfaces-ICoreWebView2FindOptions!private! !
get_SuppressDefaultFindDialog:!**auto generated**!COM Interfaces-ICoreWebView2FindOptions!private! !
isCaseSensitive!properties!public! !
isCaseSensitive:!properties!public! !
put_FindTerm:!**auto generated**!COM Interfaces-ICoreWebView2FindOptions!private! !
put_IsCaseSensitive:!**auto generated**!COM Interfaces-ICoreWebView2FindOptions!private! !
put_ShouldHighlightAllMatches:!**auto generated**!COM Interfaces-ICoreWebView2FindOptions!private! !
put_ShouldMatchWord:!**auto generated**!COM Interfaces-ICoreWebView2FindOptions!private! !
put_SuppressDefaultFindDialog:!**auto generated**!COM Interfaces-ICoreWebView2FindOptions!private! !
shouldHighlightAllMatches!properties!public! !
shouldHighlightAllMatches:!properties!public! !
shouldMatchWord!properties!public! !
shouldMatchWord:!properties!public! !
suppressDefaultFindDialog!properties!public! !
suppressDefaultFindDialog:!properties!public! !
!

!WebView2.ICoreWebView2FindOptions class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FindOptions'
		ICoreWebView2FindOptions defineTemplate"

	self
		defineFunction: #get_FindTerm:
			argumentTypes: 'lpwstr*';
		defineFunction: #put_FindTerm:
			argumentTypes: 'lpwstr';
		defineFunction: #get_IsCaseSensitive:
			argumentTypes: 'int32*';
		defineFunction: #put_IsCaseSensitive:
			argumentTypes: 'int32';
		defineFunction: #get_ShouldHighlightAllMatches:
			argumentTypes: 'int32*';
		defineFunction: #put_ShouldHighlightAllMatches:
			argumentTypes: 'int32';
		defineFunction: #get_ShouldMatchWord:
			argumentTypes: 'int32*';
		defineFunction: #put_ShouldMatchWord:
			argumentTypes: 'int32';
		defineFunction: #get_SuppressDefaultFindDialog:
			argumentTypes: 'int32*';
		defineFunction: #put_SuppressDefaultFindDialog:
			argumentTypes: 'int32'
! !

!WebView2.ICoreWebView2FindOptions class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

