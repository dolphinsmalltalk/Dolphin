"Filed out from Dolphin Smalltalk X6.1"!

WebHttpAbstractFileServingServlet subclass: #WebHttpGenericMemoryFileServlet
	instanceVariableNames: 'fileName fileBytes fileTimestamp'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebHttpGenericMemoryFileServlet guid: (GUID fromString: '{B73D825D-2C18-4C78-A442-24B2FC4398AE}')!
WebHttpGenericMemoryFileServlet comment: ''!
!WebHttpGenericMemoryFileServlet categoriesForClass!Unclassified! !
!WebHttpGenericMemoryFileServlet methodsFor!

processGet: request on: stream 
	| ifModifiedSince contentType |
	((ifModifiedSince := request header ifModifiedSince) notNil and: 
			[(ifModifiedSince last isNil or: [ifModifiedSince last = fileBytes size]) and: 
					[ifModifiedSince first date = fileTimestamp date and: 
							[ifModifiedSince first time minutes = fileTimestamp time minutes 
								and: [ifModifiedSince first time seconds = fileTimestamp time seconds]]]]) 
		ifTrue: [^stream notModifiedResponse].
	stream
		isBytes: true;
		nextPutAll: fileBytes.
	contentType := self mimeTypeOf: fileName.
	stream
		date: fileTimestamp;
		lastModified: fileTimestamp;
		contentType: contentType.
	contentType := contentType asWebString.
	((contentType beginsWith: 'image') or: 
			[contentType = 'text/css' or: 
					[contentType = 'application/pdf' 
						or: [contentType = 'application/x-shockwave-flash' or: [contentType = 'application/x-javascript']]]]) 
		ifTrue: 
			[stream
				expires: (Timestamp date: (Date today addDays: 1) time: Time now);
				cacheControl: 'max-age=86400, public']!

servletName
	^fileName!

setFilename: aString contents: aByteArray 
	fileName := aString.
	fileBytes := aByteArray asByteArray.
	fileTimestamp := Timestamp now! !
!WebHttpGenericMemoryFileServlet categoriesFor: #processGet:on:!public! !
!WebHttpGenericMemoryFileServlet categoriesFor: #servletName!public! !
!WebHttpGenericMemoryFileServlet categoriesFor: #setFilename:contents:!public! !

!WebHttpGenericMemoryFileServlet class methodsFor!

newFor1x1PixelGifFileNamed: aString 
	^(self new)
		setFilename: aString
			contents: #(71 73 70 56 57 97 1 0 1 0 128 0 0 0 0 0 255 255 255 33 249 4 1 0 0 0 0 44 0 0 0 0 1 0 1 0 0 2 1 68 0 59);
		yourself! !
!WebHttpGenericMemoryFileServlet class categoriesFor: #newFor1x1PixelGifFileNamed:!public! !

