"Filed out from Dolphin Smalltalk X6.2"!

WebHttpServlet subclass: #WebHttpAbstractFileServingServlet
	instanceVariableNames: 'mimeMapping'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebHttpAbstractFileServingServlet guid: (GUID fromString: '{A91B944F-B0FE-4FA9-AE96-5847A583A9A5}')!
WebHttpAbstractFileServingServlet comment: ''!
!WebHttpAbstractFileServingServlet categoriesForClass!Unclassified! !
!WebHttpAbstractFileServingServlet methodsFor!

extensionOf: filepath 
	"Return the extension of @filepath. Answer nil if there is no extension."

	| index nextIndex size |
	index := 0.
	size := filepath size.
	[(nextIndex := filepath indexOf: $. startingAt: index + 1) ~~ 0] 
		whileTrue: [index := nextIndex].
	(index == 0 or: [index = size]) ifTrue: [^nil].
	^filepath copyFrom: index + 1 to: size!

mimeMapping
	mimeMapping isNil ifTrue: [mimeMapping := self class defaultMimeMapping].
	^mimeMapping!

mimeTypeOf: filepath 
	"Answer the MIME type of the file at @filepath.
	Answer nil if the MIME type cannot be determined."

	| extension |
	(extension := self extensionOf: filepath) isNil ifTrue: [^'application/octet-stream'].
	^self mimeMapping at: extension asLowercase ifAbsent: ['application/octet-stream']!

processPost: request on: stream 
	stream badRequestResponse!

service: request on: stream 
	self checkOrSetDefaultClientIdCookieFor: request on: stream.
	super service: request on: stream! !
!WebHttpAbstractFileServingServlet categoriesFor: #extensionOf:!public! !
!WebHttpAbstractFileServingServlet categoriesFor: #mimeMapping!public! !
!WebHttpAbstractFileServingServlet categoriesFor: #mimeTypeOf:!public! !
!WebHttpAbstractFileServingServlet categoriesFor: #processPost:on:!public! !
!WebHttpAbstractFileServingServlet categoriesFor: #service:on:!public! !

!WebHttpAbstractFileServingServlet class methodsFor!

defaultMimeMapping
	^HttpClient defaultMimeMapping! !
!WebHttpAbstractFileServingServlet class categoriesFor: #defaultMimeMapping!public! !

