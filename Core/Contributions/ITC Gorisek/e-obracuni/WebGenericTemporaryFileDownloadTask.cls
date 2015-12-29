"Filed out from Dolphin Smalltalk X6.1"!

WebGenericDownloadTask subclass: #WebGenericTemporaryFileDownloadTask
	instanceVariableNames: 'sourceFilePathname onTaskRemove'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebGenericTemporaryFileDownloadTask guid: (GUID fromString: '{462083C6-67A4-4ECD-B2ED-F8BDC46D301D}')!
WebGenericTemporaryFileDownloadTask comment: ''!
!WebGenericTemporaryFileDownloadTask categoriesForClass!Unclassified! !
!WebGenericTemporaryFileDownloadTask methodsFor!

onTaskRemove: aBlock 
	"aBlock will be evaluated when the task is removed from the session."

	onTaskRemove := aBlock!

onTaskRemoved
	onTaskRemove isNil 
		ifFalse: [onTaskRemove value]
		ifTrue: [ItcSystemManager fileRemove: sourceFilePathname]!

process: request on: stream 
	| fileData creation modification fileSize ifModifiedSince fileStream bytes |
	(fileData := ItcSystemManager fileDataFor: sourceFilePathname) isNil 
		ifTrue: [^stream fileNotFoundResponse].
	creation := fileData at: 1.
	modification := fileData at: 2.
	fileSize := fileData at: 3.
	((ifModifiedSince := request header ifModifiedSince) notNil and: 
			[(ifModifiedSince last isNil or: [ifModifiedSince last = fileSize]) and: 
					[ifModifiedSince first date = modification date and: 
							[ifModifiedSince first time minutes = modification time minutes 
								and: [ifModifiedSince first time seconds = modification time seconds]]]]) 
		ifTrue: [^stream notModifiedResponse].
	[fileStream := FileStream read: sourceFilePathname type: #binary] on: Error
		do: 
			[:ex | 
			ItcSystemManager 
				logLineWithTsAndSession: 'Could not download ' , fileName asWebString , ' due to ' , ex printString.
			ex exitWith: nil].
	fileStream isFileStream ifFalse: [^stream forbiddenResponse].
	[bytes := fileStream contents] ensure: [fileStream close].
	attachmentFilename isNilOrEmpty ifFalse: [stream attachmentFilename: attachmentFilename].
	stream
		isBytes: true;
		nextPutAll: bytes.
	contentType isNil 
		ifTrue: 
			[contentType := WebHttpFileServlet defaultMimeMapping 
						at: (ItcSystemManager fileExtensionFromPath: fileName) asLowercase
						ifAbsent: []].
	stream
		date: creation;
		lastModified: modification;
		contentType: contentType.
	contentType := contentType asWebString.
	((contentType beginsWith: 'image') 
		or: [contentType = 'text/css' or: [contentType = 'application/x-zip']]) 
			ifTrue: 
				[stream
					expires: (Timestamp date: (Date today addDays: 10) time: Time now);
					cacheControl: 'max-age=2700, must-revalidate']!

setFileName: fn contentType: ct sourceFilePathname: aString 
	fileName := fn.
	contentType := ct.
	sourceFilePathname := aString! !
!WebGenericTemporaryFileDownloadTask categoriesFor: #onTaskRemove:!public! !
!WebGenericTemporaryFileDownloadTask categoriesFor: #onTaskRemoved!private! !
!WebGenericTemporaryFileDownloadTask categoriesFor: #process:on:!public! !
!WebGenericTemporaryFileDownloadTask categoriesFor: #setFileName:contentType:sourceFilePathname:!public! !

