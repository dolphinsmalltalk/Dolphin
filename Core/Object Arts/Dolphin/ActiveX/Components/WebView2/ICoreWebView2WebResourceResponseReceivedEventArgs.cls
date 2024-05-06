"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventArgs subclass: #ICoreWebView2WebResourceResponseReceivedEventArgs
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ICoreWebView2WebResourceResponseReceivedEventArgs guid: (IID fromString: '{d1db483d-6796-4b8b-80fc-13712bb716f4}')!

ICoreWebView2WebResourceResponseReceivedEventArgs comment: '`ICoreWebView2WebResourceResponseReceivedEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2WebResourceResponseReceivedEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(d1db483d-6796-4b8b-80fc-13712bb716f4)
]
interface ICoreWebView2WebResourceResponseReceivedEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall Request(
		[out, retval]ICoreWebView2WebResourceRequest** Request);
	[id(0x60010001), propget]
	HRESULT __stdcall Response(
		[out, retval]ICoreWebView2WebResourceResponseView** Response);
};
```
'!

!ICoreWebView2WebResourceResponseReceivedEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!ICoreWebView2WebResourceResponseReceivedEventArgs methodsFor!

get_Request: request
	"Private - Get the value of the 'Request' property of the receiver.

		HRESULT __stdcall Request(
			[out, retval]ICoreWebView2WebResourceRequest** Request);"

	<virtual stdcall: hresult 4 ICoreWebView2WebResourceRequest**>
	^self invalidCall: _failureCode!

get_Response: response
	"Private - Get the value of the 'Response' property of the receiver.

		HRESULT __stdcall Response(
			[out, retval]ICoreWebView2WebResourceResponseView** Response);"

	<virtual stdcall: hresult 5 ICoreWebView2WebResourceResponseView**>
	^self invalidCall: _failureCode!

printPropertiesOn: aStream
	"Print any properties of the receiver that might be useful for debugging, and which are not too verbose. Emit nothing by default."

	self request printPropertiesOn: aStream.
	aStream nextPutAll: ', '.
	self response printPropertiesOn: aStream!

request
	"Answer the <ICoreWebView2WebResourceRequest> value of the 'Request' property of the receiver."

	| answer |
	answer := ICoreWebView2WebResourceRequest newPointer.
	self get_Request: answer.
	^answer asObject!

response
	"Answer the <ICoreWebView2WebResourceResponseView> value of the 'Response' property of the receiver."

	| answer |
	answer := ICoreWebView2WebResourceResponseView newPointer.
	self get_Response: answer.
	^answer asObject! !

!ICoreWebView2WebResourceResponseReceivedEventArgs categoriesForMethods!
get_Request:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceResponseReceivedEventArgs!private! !
get_Response:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceResponseReceivedEventArgs!private! !
printPropertiesOn:!development!printing!private! !
request!**auto generated**!properties!public! !
response!**auto generated**!properties!public! !
!

!ICoreWebView2WebResourceResponseReceivedEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2WebResourceResponseReceivedEventArgs'
		ICoreWebView2WebResourceResponseReceivedEventArgs defineTemplate"

	self
		defineFunction: #get_Request:
			argumentTypes: 'ICoreWebView2WebResourceRequest**';
		defineFunction: #get_Response:
			argumentTypes: 'ICoreWebView2WebResourceResponseView**'
! !

!ICoreWebView2WebResourceResponseReceivedEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

