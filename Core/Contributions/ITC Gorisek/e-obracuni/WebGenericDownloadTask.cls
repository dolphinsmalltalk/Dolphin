"Filed out from Dolphin Smalltalk X6.1"!

WebTask subclass: #WebGenericDownloadTask
	instanceVariableNames: 'content fileName contentType attachmentFilename'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebGenericDownloadTask guid: (GUID fromString: '{7972D03F-DA06-48E2-8B9D-6C9627BF4E32}')!
WebGenericDownloadTask comment: ''!
!WebGenericDownloadTask categoriesForClass!Unclassified! !
!WebGenericDownloadTask methodsFor!

process: request on: stream 
	attachmentFilename isNilOrEmpty ifFalse: [stream attachmentFilename: attachmentFilename].
	stream
		contentType: contentType;
		nextPutAll: content!

setFileName: fn contentType: ct contents: cnt 
	content := cnt.
	contentType := ct.
	fileName := fn!

urlExtension
	^fileName isNil ifFalse: ['/' , fileName] ifTrue: ['.html']! !
!WebGenericDownloadTask categoriesFor: #process:on:!public! !
!WebGenericDownloadTask categoriesFor: #setFileName:contentType:contents:!public! !
!WebGenericDownloadTask categoriesFor: #urlExtension!public! !

