"Filed out from Dolphin Smalltalk X6.1"!

WebHttpAbstractFileServingServlet subclass: #WebHttpFileServlet
	instanceVariableNames: 'rootPath numberOfCharactersToCut urlPrefix fileCache fileCacheMutex'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebHttpFileServlet guid: (GUID fromString: '{9ED298EA-0AC9-499D-BBDB-C3C3CCF1B7AA}')!
WebHttpFileServlet comment: ''!
!WebHttpFileServlet categoriesForClass!Unclassified! !
!WebHttpFileServlet methodsFor!

fileCache
	fileCache isNil ifTrue: [fileCache := LookupTable new].
	^fileCache!

fileCacheMutex
	^fileCacheMutex!

filePath: request 
	| path end |
	(path := request header url) isNil ifTrue: [^'/'].
	(end := path indexOf: $?) = 0 ifTrue: [^path webHttpUrlDecodePathComponent].
	^(path copyFrom: 1 to: end - 1) webHttpUrlDecodePathComponent!

initialize
	fileCacheMutex := Semaphore forMutualExclusion!

processGet: request on: stream 
	| path filePath fileStream fileData creation modification fileSize ifModifiedSince contentType cachedFile contentStartPosition contentOffsetLength eTag |
	path := self filePath: request.
	filePath := path copyFrom: numberOfCharactersToCut to: path size.
	(filePath isEmpty 
		or: [filePath first ~= $/ or: [(filePath indexOfSubCollection: '..' startingAt: 1) > 0]]) 
			ifTrue: [^stream fileNotFoundResponse].
	ItcSystemManager isRuntime 
		ifTrue: 
			["do not cache files in development image"
			fileCacheMutex critical: [cachedFile := self fileCache at: filePath asUppercase ifAbsent: []]]
		ifFalse: [ItcSystemManager logLineWithTS: 'File servlet: download request for: ' , filePath].
	filePath = '/' 
		ifTrue: 
			[^application indexServlet isNil 
				ifTrue: [stream fileNotFoundResponse]
				ifFalse: [stream redirectResponseTemporarilyTo: application indexServlet urlPrefix]].
	cachedFile isNil 
		ifTrue: 
			[(fileData := ItcSystemManager fileDataFor: rootPath , filePath) isNil 
				ifTrue: [^stream fileNotFoundResponse]]
		ifFalse: [fileData := cachedFile].
	creation := fileData at: 1.
	modification := fileData at: 2.
	fileSize := fileData at: 3.
	((ifModifiedSince := request header ifModifiedSince) notNil and: 
			[(ifModifiedSince last isNil or: [ifModifiedSince last = fileSize]) and: 
					[ifModifiedSince first date = modification date and: 
							[ifModifiedSince first time minutes = modification time minutes 
								and: [ifModifiedSince first time seconds = modification time seconds]]]]) 
		ifTrue: [^stream notModifiedResponse].
	eTag := (MD5 hashMessage: modification asFilenameString) asHexString.
	contentType := self mimeTypeOf: filePath.
	cachedFile isNil 
		ifTrue: 
			[[fileStream := FileStream read: rootPath , filePath type: #binary] on: Error
				do: [:ex | ex exitWith: nil].
			fileStream isFileStream ifFalse: [^stream forbiddenResponse].
			
			[contentOffsetLength := fileSize.
			contentStartPosition isNil 
				ifTrue: 
					["check if file is larger than 10 MB, if larger then it can be only downloaded using partial byte range requests 5 MB at a time"
					fileSize > 10485760 
						ifTrue: 
							[contentStartPosition := 0.
							contentOffsetLength := 10485760]].
			stream isBytes: true.
			contentStartPosition isNil 
				ifFalse: 
					[fileStream position: contentStartPosition.
					contentType := 'application/octet-stream'.
					stream
						attachmentFilename: (ItcSystemManager fileNameFromPath: filePath);
						partialContentResponse;
						acceptByteRanges: true;
						contentRange: (Association key: contentStartPosition value: fileSize)].
			stream nextPutAll: (fileStream next: contentOffsetLength)] 
					ensure: [fileStream close].
			(fileSize < 30720 or: [fileSize < 1024000 and: [filePath endsWith: '.js']]) 
				ifTrue: 
					[fileCacheMutex critical: 
							[self fileCache at: filePath asUppercase
								put: (Array 
										with: creation
										with: modification
										with: fileSize
										with: stream contents)]]]
		ifFalse: 
			[stream
				isBytes: true;
				nextPutAll: (cachedFile at: 4)].
	stream
		eTag: eTag;
		date: creation;
		lastModified: modification;
		contentType: contentType.
	(contentType := contentType asWebString) = 'application/octet-stream' 
		ifTrue: [stream attachmentFilename: (ItcSystemManager fileNameFromPath: filePath)]
		ifFalse: 
			[((contentType beginsWith: 'image') or: 
					[contentType = 'text/css' or: 
							[contentType = 'application/pdf' 
								or: [contentType = 'application/x-shockwave-flash' or: [contentType = 'application/x-javascript']]]]) 
				ifTrue: 
					[stream
						expires: (Timestamp date: (Date today addDays: 10) time: Time now);
						cacheControl: 'max-age=864000, public']]!

releaseCachedFiles
	fileCacheMutex 
		critical: [fileCache isNil ifFalse: [fileCache keys copy do: [:each | fileCache removeKey: each]]]!

rootPath: aString 
	rootPath := aString!

setFileCache: aDictionary mutex: aMutex 
	fileCache := aDictionary.
	fileCacheMutex := aMutex!

urlPrefix
	^urlPrefix!

urlPrefix: aString 
	numberOfCharactersToCut := aString size + 2.
	urlPrefix := aString! !
!WebHttpFileServlet categoriesFor: #fileCache!public! !
!WebHttpFileServlet categoriesFor: #fileCacheMutex!public! !
!WebHttpFileServlet categoriesFor: #filePath:!public! !
!WebHttpFileServlet categoriesFor: #initialize!public! !
!WebHttpFileServlet categoriesFor: #processGet:on:!public! !
!WebHttpFileServlet categoriesFor: #releaseCachedFiles!public! !
!WebHttpFileServlet categoriesFor: #rootPath:!public! !
!WebHttpFileServlet categoriesFor: #setFileCache:mutex:!public! !
!WebHttpFileServlet categoriesFor: #urlPrefix!public! !
!WebHttpFileServlet categoriesFor: #urlPrefix:!public! !

