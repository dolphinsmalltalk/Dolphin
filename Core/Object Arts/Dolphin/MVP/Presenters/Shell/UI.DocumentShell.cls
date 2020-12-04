"Filed out from Dolphin Smalltalk 7"!

UI.AbstractDocumentShell subclass: #'UI.DocumentShell'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.DocumentShell guid: (Core.GUID fromString: '{87b4c69b-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.DocumentShell comment: '`DocumentShell` is a legacy base class of  `<documentPresenter>`s that supports documents stored as text or STB-format binary representation. 

`DocumentShell` will be deprecated in a future release. Document shells should now be directly subclassed from `AbstractDocumentShell`, or from `TextDocument`.
'!
!UI.DocumentShell categoriesForClass!MVP-Presenters! !
!UI.DocumentShell methodsFor!

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
!UI.DocumentShell categoriesFor: #streamIn:!private!streaming! !
!UI.DocumentShell categoriesFor: #streamOut:!private!streaming! !

!UI.DocumentShell class methodsFor!

defaultFileExtension
	"Answer a default extension that will be used for files saved from
	the receiver"

	^''! !
!UI.DocumentShell class categoriesFor: #defaultFileExtension!constants!public! !

