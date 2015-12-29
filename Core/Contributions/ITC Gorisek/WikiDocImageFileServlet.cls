"Filed out from Dolphin Smalltalk X6.1"!

WebHttpFileServlet subclass: #WikiDocImageFileServlet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocImageFileServlet guid: (GUID fromString: '{682CE22C-35FB-4DBB-8326-74CB137FBB26}')!
WikiDocImageFileServlet comment: ''!
!WikiDocImageFileServlet categoriesForClass!Unclassified! !
!WikiDocImageFileServlet methodsFor!

getImageBytesFor: aWikiDocImage 
	^aWikiDocImage imageBytes!

processGet: request on: stream 
	| path filePath file creation modification fileSize ifModifiedSince contentType cachedFile bytes session |
	
	[session := self checkOrSetDefaultClientIdCookieAndSessionFor: request on: stream.
	((application configurationSettingsAt: 'application.loginForPreviewRequired') = 'true' 
		and: [session isNil or: [session user isNil]]) ifTrue: [^stream forbiddenResponse].
	path := self filePath: request.
	filePath := path copyFrom: numberOfCharactersToCut to: path size.
	fileCacheMutex critical: [cachedFile := self fileCache at: filePath ifAbsent: []].
	cachedFile isNil 
		ifTrue: 
			[(file := application getImage: filePath) isNil ifTrue: [^stream fileNotFoundResponse].
			creation := modification := file uploadTS.
			fileSize := (self getImageBytesFor: file) size]
		ifFalse: 
			[creation := cachedFile at: 1.
			modification := cachedFile at: 2.
			fileSize := cachedFile at: 3].
	((ifModifiedSince := request header ifModifiedSince) notNil and: 
			[(ifModifiedSince last isNil or: [ifModifiedSince last = fileSize]) and: 
					[ifModifiedSince first date = modification date and: 
							[ifModifiedSince first time minutes = modification time minutes 
								and: [ifModifiedSince first time seconds = modification time seconds]]]]) 
		ifTrue: [^stream notModifiedResponse].
	cachedFile isNil 
		ifTrue: 
			[bytes := (self getImageBytesFor: file) asByteArray.
			stream
				isBytes: true;
				nextPutAll: bytes.
			fileSize < 10240 
				ifTrue: 
					[fileCacheMutex critical: 
							[self fileCache at: filePath
								put: (Array 
										with: creation
										with: modification
										with: fileSize
										with: bytes)]]]
		ifFalse: 
			[stream
				isBytes: true;
				nextPutAll: (cachedFile at: 4)].
	contentType := self mimeTypeOf: filePath.
	stream
		date: creation;
		lastModified: modification;
		contentType: contentType.
	contentType := contentType asWebString.
	((contentType beginsWith: 'image') or: 
			[contentType = 'text/css' 
				or: [contentType = 'application/pdf' or: [contentType = 'application/x-shockwave-flash']]]) 
		ifTrue: 
			[stream
				expires: (Timestamp date: (Date today addDays: 10) time: Time now);
				cacheControl: 'max-age=864000, public']] 
			evaluateIn: application newTransaction!

urlPrefix: aString 
	numberOfCharactersToCut := aString size + 2 + '/wiki-images/' size.
	urlPrefix := aString! !
!WikiDocImageFileServlet categoriesFor: #getImageBytesFor:!public! !
!WikiDocImageFileServlet categoriesFor: #processGet:on:!public! !
!WikiDocImageFileServlet categoriesFor: #urlPrefix:!public! !

!WikiDocImageFileServlet class methodsFor!

servletName
	^'wiki'! !
!WikiDocImageFileServlet class categoriesFor: #servletName!public! !

