"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.AbstractICoreWebView2WebResourceResponse'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.AbstractICoreWebView2WebResourceResponse guid: (OS.COM.IID fromString: '{d81c5d24-f116-4534-9c26-e5517ae46247}')!

WebView2.AbstractICoreWebView2WebResourceResponse isNonInstantiable: true!

WebView2.AbstractICoreWebView2WebResourceResponse comment: ''!

!WebView2.AbstractICoreWebView2WebResourceResponse methodsFor!

get_Headers: headers
	self subclassResponsibility!

get_ReasonPhrase: reasonPhrase
	self subclassResponsibility!

get_StatusCode: statusCode
	self subclassResponsibility!

headers
	"Answer the <ICoreWebView2HttpResponseHeaders> value of the 'Headers' property of the receiver."

	| answer |
	answer := ICoreWebView2HttpResponseHeaders newPointer.
	self get_Headers: answer.
	^answer asObject!

printableProperties
	^#(#statusCode #reasonPhrase #headers)!

reasonPhrase
	"Answer the <lpwstr> value of the 'ReasonPhrase' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_ReasonPhrase: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

statusCode
	"Answer the <sdword> value of the 'StatusCode' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_StatusCode: answer.
	^answer asObject! !

!WebView2.AbstractICoreWebView2WebResourceResponse categoriesForMethods!
get_Headers:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceResponse!private! !
get_ReasonPhrase:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceResponse!private! !
get_StatusCode:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceResponse!private! !
headers!**auto generated**!properties!public! !
printableProperties!printing!private! !
reasonPhrase!properties!public! !
statusCode!**auto generated**!properties!public! !
!

