"Filed out from Dolphin Smalltalk X6.1"!

WebHttpFileServlet subclass: #WikiDocDownloadableFileServlet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocDownloadableFileServlet guid: (GUID fromString: '{998C7AC7-4BDA-4CAE-ABCC-5C2E35AA7851}')!
WikiDocDownloadableFileServlet comment: ''!
!WikiDocDownloadableFileServlet categoriesForClass!Unclassified! !
!WikiDocDownloadableFileServlet methodsFor!

processGet: request on: stream 
	| path filePath file creation modification fileSize ifModifiedSince contentType cachedFile session mutex |
	
	[session := self checkOrSetDefaultClientIdCookieAndSessionFor: request on: stream.
	((application configurationSettingsAt: 'application.loginForPreviewRequired') = 'true' 
		and: [session isNil or: [session user isNil]]) ifTrue: [^stream forbiddenResponse].
	path := self filePath: request.
	filePath := path copyFrom: numberOfCharactersToCut to: path size.
	fileCacheMutex critical: [cachedFile := self fileCache at: filePath ifAbsent: []].
	cachedFile isNil 
		ifTrue: 
			[(file := application getDownloadableFile: filePath) isNil ifTrue: [^stream fileNotFoundResponse].
			creation := modification := file uploadTS.
			fileSize := file fileSize]
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
	(mutex := session sessionData at: #statMutex ifAbsent: []) isNil 
		ifFalse: 
			["record that user has downloaded the file"
			mutex critical: 
					[((session sessionData at: #downloads) at: filePath ifAbsentPut: [OrderedCollection new]) 
						add: Timestamp now]].
	"---"
	cachedFile isNil 
		ifTrue: 
			[stream
				isBytes: true;
				nextPutAll: file fileBytes asByteArray.
			fileSize < 10240 
				ifTrue: 
					[fileCacheMutex critical: 
							[self fileCache at: filePath
								put: (Array 
										with: creation
										with: modification
										with: fileSize
										with: file fileBytes)]]]
		ifFalse: 
			[stream
				isBytes: true;
				nextPutAll: (cachedFile at: 4) asByteArray].
	contentType := self mimeTypeOf: filePath.
	stream
		date: creation;
		lastModified: modification;
		contentType: contentType.
	contentType = 'application/x-shockwave-flash' 
		ifFalse: 
			["Flash 10 was changed, content-disposition must not be set, otherwise Flash animations wont run. See:

			http://www.adobe.com/devnet/flashplayer/articles/fplayer10_security_changes_02.html#head32
			"
			stream attachmentFilename: filePath].
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
	numberOfCharactersToCut := aString size + 2 + '/files-wiki/' size.
	urlPrefix := aString! !
!WikiDocDownloadableFileServlet categoriesFor: #processGet:on:!public! !
!WikiDocDownloadableFileServlet categoriesFor: #urlPrefix:!public! !

!WikiDocDownloadableFileServlet class methodsFor!

servletName
	^'files'! !
!WikiDocDownloadableFileServlet class categoriesFor: #servletName!public! !

