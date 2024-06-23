"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2ProcessExtendedInfo'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2ProcessExtendedInfo guid: (OS.COM.IID fromString: '{af4c4c2e-45db-11ee-be56-0242ac120002}')!

WebView2.ICoreWebView2ProcessExtendedInfo isEgressOnly: true!

WebView2.ICoreWebView2ProcessExtendedInfo comment: '`ICoreWebView2ProcessExtendedInfo` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ProcessExtendedInfo'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(af4c4c2e-45db-11ee-be56-0242ac120002)
]
interface ICoreWebView2ProcessExtendedInfo : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall processInfo(
		[out, retval]ICoreWebView2ProcessInfo** processInfo);
	[id(0x60010001), propget]
	HRESULT __stdcall AssociatedFrameInfos(
		[out, retval]ICoreWebView2FrameInfoCollection** frames);
};
```
'!

!WebView2.ICoreWebView2ProcessExtendedInfo categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2ProcessExtendedInfo methodsFor!

associatedFrameInfos
	"Answer the <ICoreWebView2FrameInfoCollection> value of the 'AssociatedFrameInfos' property of the receiver."

	| answer |
	answer := ICoreWebView2FrameInfoCollection newPointer.
	self get_AssociatedFrameInfos: answer.
	^answer asObject!

get_AssociatedFrameInfos: frames
	"Private - Get the value of the 'AssociatedFrameInfos' property of the receiver.

		HRESULT __stdcall AssociatedFrameInfos(
			[out, retval]ICoreWebView2FrameInfoCollection** frames);"

	<virtual stdcall: hresult 5 ICoreWebView2FrameInfoCollection**>
	^self invalidCall: _failureCode!

get_processInfo: processInfo
	"Private - Get the value of the 'processInfo' property of the receiver.

		HRESULT __stdcall processInfo(
			[out, retval]ICoreWebView2ProcessInfo** processInfo);"

	<virtual stdcall: hresult 4 ICoreWebView2ProcessInfo**>
	^self invalidCall: _failureCode!

printableProperties
	| propertyNames |
	propertyNames := OrderedCollection with: #processInfo.
	self associatedFrameInfos isEmpty ifFalse: [propertyNames addLast: #associatedFrameInfos].
	^propertyNames!

processInfo
	"Answer the <ICoreWebView2ProcessInfo> value of the 'processInfo' property of the receiver."

	| answer |
	answer := ICoreWebView2ProcessInfo newPointer.
	self get_processInfo: answer.
	^answer asObject! !

!WebView2.ICoreWebView2ProcessExtendedInfo categoriesForMethods!
associatedFrameInfos!**auto generated**!properties!public! !
get_AssociatedFrameInfos:!**auto generated**!COM Interfaces-ICoreWebView2ProcessExtendedInfo!private! !
get_processInfo:!**auto generated**!COM Interfaces-ICoreWebView2ProcessExtendedInfo!private! !
printableProperties!printing!private! !
processInfo!**auto generated**!properties!public! !
!

!WebView2.ICoreWebView2ProcessExtendedInfo class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ProcessExtendedInfo'
		ICoreWebView2ProcessExtendedInfo defineTemplate"

	self
		defineFunction: #get_processInfo:
			argumentTypes: 'ICoreWebView2ProcessInfo**';
		defineFunction: #get_AssociatedFrameInfos:
			argumentTypes: 'ICoreWebView2FrameInfoCollection**'
! !

!WebView2.ICoreWebView2ProcessExtendedInfo class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

