"Filed out from Dolphin Smalltalk 7"!

RelativeFileLocator subclass: #InstallRelativeFileLocator
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
InstallRelativeFileLocator guid: (GUID fromString: '{2543c5ae-b739-4aae-9aee-fe5537083fb7}')!
InstallRelativeFileLocator comment: 'An ImageRelativeFileLocator is used to indicate the location of an external file that may be referenced within the image. 
Instances of this class always locate files relative to the image directory, unless the file is outside the local directory hierarchy below the install directory, in which case an absolute path is used.
'!
!InstallRelativeFileLocator categoriesForClass!System-Support! !
!InstallRelativeFileLocator methodsFor!

basePath
	^SessionManager current installationDirectory!

stbSaveOn: anSTBOutFiler 
	"Save out a binary representation of the receiver to anSTBOutFiler."

	anSTBOutFiler writePreambleFor: self! !
!InstallRelativeFileLocator categoriesFor: #basePath!accessing!public! !
!InstallRelativeFileLocator categoriesFor: #stbSaveOn:!binary filing!public! !

!InstallRelativeFileLocator class methodsFor!

current
	"Answer the singleton instance of the receiver"

	Current isNil ifTrue: [ Current := self new ].
	^Current!

onPreStripImage
	"Private -  Assist in the image stripping process by clearning down any
	lazily initialized variables held by the receiver."

	self uninitialize!

stbReadFrom: anSTBInFiler format: anSTBClassConversion 
	"Read an instance of the receiver from the binary filer, aSTBInFiler."

	| singleton |
	singleton := self current.
	anSTBInFiler register: singleton.
	^singleton!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	Current := nil! !
!InstallRelativeFileLocator class categoriesFor: #current!accessing!public! !
!InstallRelativeFileLocator class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!InstallRelativeFileLocator class categoriesFor: #stbReadFrom:format:!binary filing!public! !
!InstallRelativeFileLocator class categoriesFor: #uninitialize!class hierarchy-removing!private! !

