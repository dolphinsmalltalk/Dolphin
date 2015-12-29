"Filed out from Dolphin Smalltalk X6.1"!

WikiDocTask subclass: #WikiDocUploadTask
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocUploadTask guid: (GUID fromString: '{17D3B158-39AD-4C7C-BBA0-7DCD74E47BD2}')!
WikiDocUploadTask comment: ''!
!WikiDocUploadTask categoriesForClass!Unclassified! !
!WikiDocUploadTask methodsFor!

getNormalizedFileName: aString 
	| fileNamePart |
	aString isNilOrEmpty ifTrue: [^''].
	fileNamePart := aString reverse.
	(fileNamePart includes: $/) 
		ifTrue: [fileNamePart := fileNamePart copyFrom: 1 to: (fileNamePart indexOf: $/) - 1].
	(fileNamePart includes: $\) 
		ifTrue: [fileNamePart := fileNamePart copyFrom: 1 to: (fileNamePart indexOf: $\) - 1].
	^(fileNamePart select: 
			[:eachChar | 
			'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-_.() ' includes: eachChar]) 
		reverse! !
!WikiDocUploadTask categoriesFor: #getNormalizedFileName:!accessing!public! !

