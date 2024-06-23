"Filed out from Dolphin Smalltalk"!

OS.COM.IUnknown
	subclass: #'WebView2.ICoreWebView2Interface'
	instanceVariableNames: ''
	classVariableNames: 'ResourceLib'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2Interface guid: (OS.COM.IID fromString: '{9732fb2d-8abb-46fb-8acd-65e3cadfeecf}')!

WebView2.ICoreWebView2Interface isNonInstantiable: true!

WebView2.ICoreWebView2Interface comment: '`ICoreWebView2Interface` is not defined in the WebView2 IDL, but is defined here to group all the WebView2 interfaces in an attempt to make the large API easier to navigate and understand, and to contain some common diagnostic functionality. In other words, there is no real is-a relationship, rather this is just a convenient grouping.
'!

!WebView2.ICoreWebView2Interface categoriesForClass!COM-Interfaces! !

!WebView2.ICoreWebView2Interface methodsFor!

printableProperties
	^#()!

printOn: aStream
	aStream
		basicPrint: self;
		nextPut: $(.
	self isNull ifTrue: [aStream print: bytes] ifFalse: [self printPropertiesOn: aStream].
	aStream nextPut: $).
	^self!

printPropertiesOn: aStream
	"Print any properties of the receiver that might be useful for debugging, and which are not too verbose. Emit nothing by default."

	self printableProperties do: 
			[:each |
			aStream
				nextPutAll: each;
				nextPutAll: ': ';
				print: (self perform: each)]
		separatedBy: [aStream nextPutAll: ', ']! !

!WebView2.ICoreWebView2Interface categoriesForMethods!
printableProperties!printing!private! !
printOn:!printing!public! !
printPropertiesOn:!printing!private! !
!

!WebView2.ICoreWebView2Interface class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^self resourceLib ifNil: [super icon] ifNotNil: [:lib | Graphics.Icon fromId: 'IDR_MAINFRAME' in: lib]!

resourceLib
	"Answers an Icon that can be used to represent this class"

	(ResourceLib notNil and: [ResourceLib isOpen]) ifTrue: [^ResourceLib].
	ResourceLib := nil.
	((RegKey classesRoot: #read) at: 'MSEdgeHTM\Application' ifAbsent: [])
		ifNotNil: 
			[:appKey |
			(appKey valueAt: 'ApplicationIcon' ifAbsent: [])
				ifNotNil: 
					[:appIcon |
					| splits |
					splits := $, split: appIcon.
					ResourceLib := ResourceLibrary open: splits first]].
	^ResourceLib! !

!WebView2.ICoreWebView2Interface class categoriesForMethods!
icon!constants!public! !
resourceLib!constants!public! !
!

