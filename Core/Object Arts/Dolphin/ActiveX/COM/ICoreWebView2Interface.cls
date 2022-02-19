"Filed out from Dolphin Smallalk"!

IUnknown subclass: #ICoreWebView2Interface
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2Interface guid: (IID fromString: '{9732fb2d-8abb-46fb-8acd-65e3cadfeecf}')!
ICoreWebView2Interface isAbstract: true!
ICoreWebView2Interface comment: '`ICoreWebView2Interface` is not defined in the WebView2 IDL, but is defined here to group all the WebView2 interfaces in an attempt to make the large API easier to navigate and understand, and to contain some common diagnostic functionality. In other words, there is no real is-a relationship, rather this is just a convenient grouping.
'!
!ICoreWebView2Interface categoriesForClass!COM-Interfaces! !
!ICoreWebView2Interface methodsFor!

printOn: aStream
	aStream
		basicPrint: self;
		nextPut: $(.
	self isNull ifTrue: [aStream print: bytes] ifFalse: [self printPropertiesOn: aStream].
	aStream nextPut: $).
	^self!

printPropertiesOn: aStream
	"Print any properties of the receiver that might be useful for debugging, and which are not too verbose. Emit nothing by default."! !
!ICoreWebView2Interface categoriesForMethods!
printOn:!development!printing!public! !
printPropertiesOn:!development!printing!private! !
!

