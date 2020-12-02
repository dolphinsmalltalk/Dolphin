"Filed out from Dolphin Smalltalk 7"!

AbstractDocumentShell subclass: #DocumentShell
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DocumentShell guid: (GUID fromString: '{87b4c69b-026e-11d3-9fd7-00a0cc3e4a32}')!
DocumentShell comment: '`DocumentShell` is a legacy base class of  `<documentPresenter>`s that supports documents stored as text or STB-format binary representation. 

`DocumentShell` will be deprecated in a future release. Document shells should now be directly subclassed from `AbstractDocumentShell`, or from `TextDocument`.
'!
!DocumentShell categoriesForClass!MVP-Presenters! !
!DocumentShell methodsFor!

streamIn: aStream 
	"Private - Stream the receiver's model contents in from aStream"

	self setDocumentData: (self isText 
				ifTrue: 
					[aStream
						setToEnd;
						contents]
				ifFalse: [Object binaryReadFrom: aStream])!

streamOut: aStream
	"Private - Stream the receiver's model out to aStream"

	| data |
	data := self getDocumentData.
	self isText 
		ifTrue: [aStream nextPutAll: data]
		ifFalse: [data binaryStoreOn: aStream]! !
!DocumentShell categoriesFor: #streamIn:!private!streaming! !
!DocumentShell categoriesFor: #streamOut:!private!streaming! !

!DocumentShell class methodsFor!

defaultFileExtension
	"Answer a default extension that will be used for files saved from
	the receiver"

	^''! !
!DocumentShell class categoriesFor: #defaultFileExtension!constants!public! !

