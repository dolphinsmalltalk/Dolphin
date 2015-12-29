"Filed out from Dolphin Smalltalk X6.1"!

WikiDocUploadTask subclass: #WikiDocUploadImageTask
	instanceVariableNames: 'imageName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocUploadImageTask guid: (GUID fromString: '{86A9932C-E02E-4FD6-8556-29094C4D4378}')!
WikiDocUploadImageTask comment: ''!
!WikiDocUploadImageTask categoriesForClass!Unclassified! !
!WikiDocUploadImageTask methodsFor!

imageName: anObject
	imageName := anObject!

process: request on: stream 
	self 
		dispatch: request
		using: #(#processDefault:on: #processUploadImage:on: #processRemoveImage:on:)
		on: stream
		withDefault: #processDefault:on:!

processDefault: request on: stream 
	(self newCoder: stream) 
		imageUploadPage: (application getImage: imageName)
		errors: nil
		imageName: imageName!

processRemoveImage: request on: stream 
	!

processUploadImage: request on: stream 
	| file newVersion previousVersion imageSize |
	previousVersion := application getImage: imageName.
	(file := request getAttachedFile: 'fileName') isNil 
		ifTrue: 
			[^(self newCoder: stream) 
				imageUploadPage: previousVersion
				errors: ((LookupTable new)
						at: 'imageName' put: 'asp.error.NoFileWasUploaded';
						yourself)
				imageName: imageName].
	imageSize := ItcSystemManager getImageSize: file value fileName: imageName.
	newVersion := WikiDocImage new.
	newVersion
		imageName: imageName;
		uploadTS: Timestamp now;
		uploadIP: request clientIP;
		imageBytes: file value;
		previousVersion: previousVersion.
	newVersion imageBytes size > 16384 
		ifTrue: [OmniBase currentTransaction store: newVersion imageBytes in: 'Images'].
	application imageIndex at: imageName put: newVersion.
	imageSize isNil 
		ifFalse: 
			[newVersion
				width: imageSize x;
				height: imageSize y].
	newVersion 
		thumbnailBytes: (WikiDocImage getThumbnailBytesForImage: newVersion application: application).
	OmniBase checkpoint.
	application updateCachedImages.
	(self newCoder: stream) 
		imageUploadPage: newVersion
		errors: nil
		imageName: imageName! !
!WikiDocUploadImageTask categoriesFor: #imageName:!accessing!public! !
!WikiDocUploadImageTask categoriesFor: #process:on:!accessing!public! !
!WikiDocUploadImageTask categoriesFor: #processDefault:on:!accessing!public! !
!WikiDocUploadImageTask categoriesFor: #processRemoveImage:on:!accessing!public! !
!WikiDocUploadImageTask categoriesFor: #processUploadImage:on:!accessing!public! !

