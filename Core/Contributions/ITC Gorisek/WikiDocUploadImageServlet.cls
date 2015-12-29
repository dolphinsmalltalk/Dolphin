"Filed out from Dolphin Smalltalk X6.1"!

WebHttpServlet subclass: #WikiDocUploadImageServlet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocUploadImageServlet guid: (GUID fromString: '{DA7E104C-BB70-4456-AD0E-0826BAB1C54D}')!
WikiDocUploadImageServlet comment: ''!
!WikiDocUploadImageServlet categoriesForClass!Unclassified! !
!WikiDocUploadImageServlet methodsFor!

process: request on: stream 
	| t session lang |
	session := self checkOrSetDefaultClientIdCookieAndSessionFor: request on: stream.

	"set default language for processing the request"
	(application applicationLanguages includes: (lang := request stringOrNilAt: 'lang')) 
		ifTrue: [Processor activeProcess language: lang].
	session user isNil ifTrue: [^stream forbiddenResponse].
	t := application newTransaction.
	
	[
	[self 
		dispatch: request
		using: #(#processDefault:on:)
		on: stream
		withDefault: #processDefault:on:] 
			evaluateIn: t] 
			ensure: [t abort]!

processDefault: request on: stream 
	| file newVersion previousVersion imageSize imageName |
	file := request getAttachedFile: 'NewFile'.
	imageName := ItcSystemManager fileNameFromPath: file key.
	previousVersion := application getImage: imageName.
	file isNil 
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
	application updateCachedImages! !
!WikiDocUploadImageServlet categoriesFor: #process:on:!public! !
!WikiDocUploadImageServlet categoriesFor: #processDefault:on:!public! !

!WikiDocUploadImageServlet class methodsFor!

servletName
	^'uploadImage.html'! !
!WikiDocUploadImageServlet class categoriesFor: #servletName!public! !

