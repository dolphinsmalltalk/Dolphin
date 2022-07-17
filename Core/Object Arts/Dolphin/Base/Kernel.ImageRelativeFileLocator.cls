"Filed out from Dolphin Smalltalk"!

Kernel.RelativeFileLocator subclass: #'Kernel.ImageRelativeFileLocator'
	instanceVariableNames: ''
	classVariableNames: 'Current'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.ImageRelativeFileLocator guid: (Core.GUID fromString: '{42513a65-8d78-44a8-b475-bdfd1e7fb6fc}')!
Kernel.ImageRelativeFileLocator comment: 'An ImageRelativeFileLocator is used to indicate the location of an external file that may be referenced within the image. 
Instances of this class always locate files relative to the image directory, unless the file is outside the local directory hierarchy below the image directory, in which case an absolute path is used.

Note that the ''image'' directory may dynamically change between image restarts, and in the case of a deployed application the ''image'' directory is the folder in which the executable resides.

Try the following examples:

relativePath := FileLocator imageRelative relativePathTo: SessionManager current imageFileName. "Display It - should be ''.\dolphin.img''"
FileLocator imageRelative localFileSpecFor: relativePath. "Display It - should be the full image path"'!
!Kernel.ImageRelativeFileLocator categoriesForClass!System-Support! !
!Kernel.ImageRelativeFileLocator methodsFor!

stbSaveOn: anSTBOutFiler 
	"Save out a binary representation of the receiver to anSTBOutFiler."

	anSTBOutFiler writePreambleFor: self! !
!Kernel.ImageRelativeFileLocator categoriesForMethods!
stbSaveOn:!binary filing!public! !
!

!Kernel.ImageRelativeFileLocator class methodsFor!

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
!Kernel.ImageRelativeFileLocator class categoriesForMethods!
current!accessing!public! !
onPreStripImage!class hierarchy-removing!private! !
stbReadFrom:format:size:!binary filing!public! !
uninitialize!class hierarchy-removing!private! !
!

