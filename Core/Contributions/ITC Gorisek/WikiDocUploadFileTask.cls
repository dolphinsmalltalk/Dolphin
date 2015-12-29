"Filed out from Dolphin Smalltalk X6.1"!

WikiDocUploadTask subclass: #WikiDocUploadFileTask
	instanceVariableNames: 'fileName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocUploadFileTask guid: (GUID fromString: '{FBAB4D78-7336-40BC-941F-73B35D95DCD7}')!
WikiDocUploadFileTask comment: ''!
!WikiDocUploadFileTask categoriesForClass!Unclassified! !
!WikiDocUploadFileTask methodsFor!

fileName: anObject 
	fileName := anObject!

process: request on: stream 
	self 
		dispatch: request
		using: #(#processDefault:on: #processUploadFile:on: #processRemoveFile:on:)
		on: stream
		withDefault: #processDefault:on:!

processDefault: request on: stream 
	(self newCoder: stream) 
		fileUploadPage: (application getDownloadableFile: fileName)
		errors: nil
		fileName: fileName!

processRemoveFile: request on: stream 
	!

processUploadFile: request on: stream 
	| file newVersion previousVersion |
	previousVersion := application getDownloadableFile: fileName.
	(file := request getAttachedFile: 'fileName') isNil 
		ifTrue: 
			[^(self newCoder: stream) 
				fileUploadPage: previousVersion
				errors: ((LookupTable new)
						at: 'fileName' put: 'asp.error.NoFileWasUploaded';
						yourself)
				fileName: fileName].
	newVersion := WikiDocDownloadableFile new.
	newVersion
		fileName: fileName;
		uploadTS: Timestamp now;
		fileBytes: file value;
		previousVersion: previousVersion.
	newVersion fileBytes size > 16384 
		ifTrue: [OmniBase currentTransaction store: newVersion fileBytes in: 'Images'].
	newVersion fileSize: newVersion fileBytes size.
	application downloadableFileIndex at: fileName put: newVersion.
	OmniBase checkpoint.
	application updateCachedFiles.
	(self newCoder: stream) 
		fileUploadPage: newVersion
		errors: nil
		fileName: fileName! !
!WikiDocUploadFileTask categoriesFor: #fileName:!public! !
!WikiDocUploadFileTask categoriesFor: #process:on:!public! !
!WikiDocUploadFileTask categoriesFor: #processDefault:on:!accessing!public! !
!WikiDocUploadFileTask categoriesFor: #processRemoveFile:on:!accessing!public! !
!WikiDocUploadFileTask categoriesFor: #processUploadFile:on:!accessing!public! !

