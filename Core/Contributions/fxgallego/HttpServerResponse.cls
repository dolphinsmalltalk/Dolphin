"Filed out from Dolphin Smalltalk 7"!

HttpServerObject subclass: #HttpServerResponse
	instanceVariableNames: 'request statusCode reason contentType content headers'
	classVariableNames: ''
	poolDictionaries: 'WinHttpServerConsts'
	classInstanceVariableNames: ''!
HttpServerResponse guid: (GUID fromString: '{03858539-95a9-4195-93d3-5ee4c3dabed2}')!
HttpServerResponse comment: ''!
!HttpServerResponse categoriesForClass!Unclassified! !
!HttpServerResponse methodsFor!

addCookie: cookie
	self headers headerAt: 'Set-Cookie' ifPresent: [:value | self error: 'Only one cookie supported'].

	self headers headerAt: 'Set-Cookie' put: cookie asString!

attachFile: aHttpServerFile
	self
		statusCode: 200;
		reason: 'OK';
		content: aHttpServerFile contents;
		contentType: (aHttpServerFile contentType ifNil: ['application/octect-stream']);
		headerAt: 'Content-Disposition'
			put: ('attachment; filename=%1' formatWith: aHttpServerFile fileName)!

content
	^content!

content: anObject
	content := anObject!

contentType: type
	self headerAt: 'Content-Type' put: type!

headerAt: name
	^headers headerAt: name ifAbsent: []!

headerAt: name put: stringValue
	^headers headerAt: name put: stringValue!

headers
	^headers!

headers: anObject
	headers := anObject!

initialize
	statusCode := 0.
	reason := ''.
	contentType := ''.
	content := ''.
	headers := HttpServerHeaders new!

initializeOn: httpApiRequest
	request := httpApiRequest!

reason
	^reason!

reason: anObject
	reason := anObject!

request
	^request!

send
	| response |
	response := HTTP_RESPONSE new.
	response
		StatusCode: self statusCode;
		pReason: self reason.
	self content notEmpty ifTrue: [response content: self content].
	headers write: response.
	self lib
		sendResponse: response
		queue: request queueHandle
		id: request id!

statusCode
	^statusCode!

statusCode: anObject
	statusCode := anObject! !
!HttpServerResponse categoriesFor: #addCookie:!accessing!public! !
!HttpServerResponse categoriesFor: #attachFile:!public! !
!HttpServerResponse categoriesFor: #content!accessing!public! !
!HttpServerResponse categoriesFor: #content:!accessing!public! !
!HttpServerResponse categoriesFor: #contentType:!accessing!public! !
!HttpServerResponse categoriesFor: #headerAt:!public! !
!HttpServerResponse categoriesFor: #headerAt:put:!public! !
!HttpServerResponse categoriesFor: #headers!public! !
!HttpServerResponse categoriesFor: #headers:!accessing!public! !
!HttpServerResponse categoriesFor: #initialize!private! !
!HttpServerResponse categoriesFor: #initializeOn:!private! !
!HttpServerResponse categoriesFor: #reason!accessing!public! !
!HttpServerResponse categoriesFor: #reason:!accessing!public! !
!HttpServerResponse categoriesFor: #request!accessing!public! !
!HttpServerResponse categoriesFor: #send!public! !
!HttpServerResponse categoriesFor: #statusCode!accessing!public! !
!HttpServerResponse categoriesFor: #statusCode:!accessing!public! !

!HttpServerResponse class methodsFor!

for: httpApiRequest
	^self new initializeOn: httpApiRequest! !
!HttpServerResponse class categoriesFor: #for:!public! !

