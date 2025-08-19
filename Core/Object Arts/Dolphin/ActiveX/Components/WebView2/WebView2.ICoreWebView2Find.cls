"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2Find'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2Find guid: (OS.COM.IID fromString: '{a3ec0f5f-ddbc-54ed-8546-af75a785b9a6}')!

WebView2.ICoreWebView2Find comment: '`ICoreWebView2Find` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Find'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(a3ec0f5f-ddbc-54ed-8546-af75a785b9a6)
]
interface ICoreWebView2Find : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall ActiveMatchIndex(
		[out, retval]int* value);
	[id(0x60010001), propget]
	HRESULT __stdcall MatchCount(
		[out, retval]int* value);
	[id(0x60010002)]
	HRESULT __stdcall add_ActiveMatchIndexChanged(
		[in]ICoreWebView2FindActiveMatchIndexChangedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60010003)]
	HRESULT __stdcall remove_ActiveMatchIndexChanged(
		[in]EventRegistrationToken token);
	[id(0x60010004)]
	HRESULT __stdcall add_MatchCountChanged(
		[in]ICoreWebView2FindMatchCountChangedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60010005)]
	HRESULT __stdcall remove_MatchCountChanged(
		[in]EventRegistrationToken token);
	[id(0x60010006)]
	HRESULT __stdcall Start(
		[in]ICoreWebView2FindOptions* options,
		[in]ICoreWebView2FindStartCompletedHandler* handler);
	[id(0x60010007)]
	HRESULT __stdcall FindNext();
	[id(0x60010008)]
	HRESULT __stdcall FindPrevious();
	[id(0x60010009)]
	HRESULT __stdcall Stop();
};
```
'!

!WebView2.ICoreWebView2Find categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2Find methodsFor!

activeMatchIndex
	"Answer the <int32> value of the 'ActiveMatchIndex' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_ActiveMatchIndex: answer.
	^answer asObject!

Add_ActiveMatchIndexChanged: eventHandler token: token
	"Invoke the add_ActiveMatchIndexChanged() method of the COM object.

		HRESULT __stdcall add_ActiveMatchIndexChanged(
			[in]ICoreWebView2FindActiveMatchIndexChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 6 ICoreWebView2FindActiveMatchIndexChangedEventHandler* int64*>
	^self invalidCall: _failureCode!

Add_MatchCountChanged: eventHandler token: token
	"Invoke the add_MatchCountChanged() method of the COM object.

		HRESULT __stdcall add_MatchCountChanged(
			[in]ICoreWebView2FindMatchCountChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 8 ICoreWebView2FindMatchCountChangedEventHandler* int64*>
	^self invalidCall: _failureCode!

findNext
	"Invoke the FindNext() method of the COM object."

	^self FindNext!

FindNext
	"Invoke the FindNext() method of the COM object.

		HRESULT __stdcall FindNext();"

	<virtual stdcall: hresult 11>
	^self invalidCall: _failureCode!

findPrevious
	"Invoke the FindPrevious() method of the COM object."

	^self FindPrevious!

FindPrevious
	"Invoke the FindPrevious() method of the COM object.

		HRESULT __stdcall FindPrevious();"

	<virtual stdcall: hresult 12>
	^self invalidCall: _failureCode!

get_ActiveMatchIndex: value
	"Private - Get the value of the 'ActiveMatchIndex' property of the receiver.

		HRESULT __stdcall ActiveMatchIndex(
			[out, retval]int* value);"

	<virtual stdcall: hresult 4 int32*>
	^self invalidCall: _failureCode!

get_MatchCount: value
	"Private - Get the value of the 'MatchCount' property of the receiver.

		HRESULT __stdcall MatchCount(
			[out, retval]int* value);"

	<virtual stdcall: hresult 5 int32*>
	^self invalidCall: _failureCode!

matchCount
	"Answer the <int32> value of the 'MatchCount' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_MatchCount: answer.
	^answer asObject!

Remove_ActiveMatchIndexChanged: token
	"Invoke the remove_ActiveMatchIndexChanged() method of the COM object.

		HRESULT __stdcall remove_ActiveMatchIndexChanged(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 7 int64>
	^self invalidCall: _failureCode!

Remove_MatchCountChanged: token
	"Invoke the remove_MatchCountChanged() method of the COM object.

		HRESULT __stdcall remove_MatchCountChanged(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 9 int64>
	^self invalidCall: _failureCode!

Start: options handler: handler
	"Invoke the Start() method of the COM object.

		HRESULT __stdcall Start(
			[in]ICoreWebView2FindOptions* options,
			[in]ICoreWebView2FindStartCompletedHandler* handler);"

	<virtual stdcall: hresult 10 ICoreWebView2FindOptions* ICoreWebView2FindStartCompletedHandler*>
	^self invalidCall: _failureCode!

start: anICoreWebView2FindOptions thenDo: aMonadicValuable

	| handler |
	handler := (WebView2CompletionHandler completionBlock: aMonadicValuable)
				queryInterface: ICoreWebView2FindStartCompletedHandler.
	self
		Start: anICoreWebView2FindOptions
		handler: handler.
	handler free!

Stop
	"Invoke the Stop() method of the COM object.

		HRESULT __stdcall Stop();"

	<virtual stdcall: hresult 13>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2Find categoriesForMethods!
activeMatchIndex!**auto generated**!properties!public! !
Add_ActiveMatchIndexChanged:token:!**auto generated**!COM Interfaces-ICoreWebView2Find!public! !
Add_MatchCountChanged:token:!**auto generated**!COM Interfaces-ICoreWebView2Find!public! !
findNext!**auto generated**!methods!public! !
FindNext!**auto generated**!COM Interfaces-ICoreWebView2Find!public! !
findPrevious!**auto generated**!methods!public! !
FindPrevious!**auto generated**!COM Interfaces-ICoreWebView2Find!public! !
get_ActiveMatchIndex:!**auto generated**!COM Interfaces-ICoreWebView2Find!private! !
get_MatchCount:!**auto generated**!COM Interfaces-ICoreWebView2Find!private! !
matchCount!**auto generated**!properties!public! !
Remove_ActiveMatchIndexChanged:!**auto generated**!COM Interfaces-ICoreWebView2Find!public! !
Remove_MatchCountChanged:!**auto generated**!COM Interfaces-ICoreWebView2Find!public! !
Start:handler:!**auto generated**!COM Interfaces-ICoreWebView2Find!public! !
start:thenDo:!**auto generated**!COM Interfaces-ICoreWebView2Find!public! !
Stop!**auto generated**!COM Interfaces-ICoreWebView2Find!public! !
!

!WebView2.ICoreWebView2Find class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Find'
		ICoreWebView2Find defineTemplate"

	self
		defineFunction: #get_ActiveMatchIndex:
			argumentTypes: 'int32*';
		defineFunction: #get_MatchCount:
			argumentTypes: 'int32*';
		defineFunction: #Add_ActiveMatchIndexChanged:token:
			argumentTypes: 'ICoreWebView2FindActiveMatchIndexChangedEventHandler* int64*';
		defineFunction: #Remove_ActiveMatchIndexChanged:
			argumentTypes: 'int64';
		defineFunction: #Add_MatchCountChanged:token:
			argumentTypes: 'ICoreWebView2FindMatchCountChangedEventHandler* int64*';
		defineFunction: #Remove_MatchCountChanged:
			argumentTypes: 'int64';
		defineFunction: #Start:handler:
			argumentTypes: 'ICoreWebView2FindOptions* ICoreWebView2FindStartCompletedHandler*';
		defineFunction: #FindNext;
		defineFunction: #FindPrevious;
		defineFunction: #Stop
! !

!WebView2.ICoreWebView2Find class categoriesForMethods!
defineFunctions!initializing!public!template definition! !
!

