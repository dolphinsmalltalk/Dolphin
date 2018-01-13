"Filed out from Dolphin Smalltalk 7"!

HttpServerObject subclass: #HttpServerFile
	instanceVariableNames: 'contents contentType fileName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HttpServerFile guid: (GUID fromString: '{596f50c0-71b4-4589-b32b-6cc3364c5f0f}')!
HttpServerFile comment: ''!
!HttpServerFile categoriesForClass!Unclassified! !
!HttpServerFile methodsFor!

contents
	^contents!

contents: anObject
	contents := anObject!

contentType
	^contentType!

contentType: anObject
	contentType := anObject!

fileName
	^fileName!

fileName: anObject
	fileName := anObject!

tempFile
	| temp file |
	temp := File temporaryFilenameWithPrefix: (File splitStemFrom: fileName).
	file := File open: temp.
	[file write: self contents] ensure: [file close].
	^File splitFilenameFrom: temp! !
!HttpServerFile categoriesFor: #contents!accessing!public! !
!HttpServerFile categoriesFor: #contents:!accessing!public! !
!HttpServerFile categoriesFor: #contentType!accessing!public! !
!HttpServerFile categoriesFor: #contentType:!accessing!public! !
!HttpServerFile categoriesFor: #fileName!accessing!public! !
!HttpServerFile categoriesFor: #fileName:!accessing!public! !
!HttpServerFile categoriesFor: #tempFile!public! !

