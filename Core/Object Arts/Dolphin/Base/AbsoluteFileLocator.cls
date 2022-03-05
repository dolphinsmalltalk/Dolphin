"Filed out from Dolphin Smalltalk"!

FileLocator subclass: #AbsoluteFileLocator
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AbsoluteFileLocator guid: (GUID fromString: '{0c174885-6aa9-43e4-98c3-a59915f5b3d7}')!
AbsoluteFileLocator comment: 'An AbsoluteFileLocator is used to indicate the location of an external file that may be referenced within the image. 
Instances of this class always locate files by their full absolute path.

Try the following examples:

relativePath := FileLocator absolute relativePathTo: SessionManager current imageFileName. "Display It"
FileLocator absolute localFileSpecFor: relativePath. "Display It"'!
!AbsoluteFileLocator categoriesForClass!System-Support! !
!AbsoluteFileLocator methodsFor!

localFileSpecFor: aStringFilename
	"Answer a filespec for aStringFilename, which is expected to be an absolute path already."

	^aStringFilename

!

relativePathTo: aFilename
	"Answer a minimal <readableString> relative path to the resource with the 
	specified <readableString> path, which the receiver can map back to a full
	path via its #localFileSpecFor: method. In this case we need an absolute path."

	^File fullPathOf: aFilename
!

stbSaveOn: anSTBOutFiler 
	"Save out a binary representation of the receiver to anSTBOutFiler."

	anSTBOutFiler writePreambleFor: self! !
!AbsoluteFileLocator categoriesForMethods!
localFileSpecFor:!accessing!public! !
relativePathTo:!accessing!public! !
stbSaveOn:!binary filing!public! !
!

!AbsoluteFileLocator class methodsFor!

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
!AbsoluteFileLocator class categoriesForMethods!
current!accessing!public! !
onPreStripImage!class hierarchy-removing!private! !
stbReadFrom:format:!binary filing!public! !
uninitialize!class hierarchy-removing!private! !
!

