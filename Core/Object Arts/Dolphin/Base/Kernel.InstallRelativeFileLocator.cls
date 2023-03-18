"Filed out from Dolphin Smalltalk"!

Kernel.RelativeFileLocator
	subclass: #'Kernel.InstallRelativeFileLocator'
	instanceVariableNames: ''
	classVariableNames: 'Current'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.InstallRelativeFileLocator guid: (Core.GUID fromString: '{2543c5ae-b739-4aae-9aee-fe5537083fb7}')!
Kernel.InstallRelativeFileLocator comment: 'An ImageRelativeFileLocator is used to indicate the location of an external file that may be referenced within the image. 
Instances of this class always locate files relative to the image directory, unless the file is outside the local directory hierarchy below the install directory, in which case an absolute path is used.
'!
!Kernel.InstallRelativeFileLocator categoriesForClass!System-Support! !
!Kernel.InstallRelativeFileLocator methodsFor!

basePath
	^SessionManager current installationDirectory!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^true!

printOn: aStream
	"Append a developer friendly textual representation of the receiver to aStream."

	aStream
		print: self class;
		nextPutAll: ' current'!

stbSaveOn: anSTBOutFiler 
	"Save out a binary representation of the receiver to anSTBOutFiler."

	anSTBOutFiler writePreambleFor: self! !
!Kernel.InstallRelativeFileLocator categoriesForMethods!
basePath!accessing!public! !
isSelfEvaluating!public!testing! !
printOn:!printing!public! !
stbSaveOn:!binary filing!public! !
!

!Kernel.InstallRelativeFileLocator class methodsFor!

current
	"Answer the singleton instance of the receiver"

	Current isNil ifTrue: [ Current := self new ].
	^Current!

onPreStripImage
	"Private -  Assist in the image stripping process by clearning down any
	lazily initialized variables held by the receiver."

	self uninitialize!

stbReadFrom: anSTBInFiler format: anSTBClassConversion size: anInteger
	"Read an instance of the receiver from the binary filer, aSTBInFiler."

	| singleton |
	singleton := self current.
	anSTBInFiler register: singleton.
	^singleton!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	Current := nil! !
!Kernel.InstallRelativeFileLocator class categoriesForMethods!
current!accessing!public! !
onPreStripImage!class hierarchy-removing!private! !
stbReadFrom:format:size:!binary filing!public! !
uninitialize!class hierarchy-removing!private! !
!

