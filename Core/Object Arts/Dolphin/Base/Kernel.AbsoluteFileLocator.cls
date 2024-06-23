"Filed out from Dolphin Smalltalk"!

Core.FileLocator
	subclass: #'Kernel.AbsoluteFileLocator'
	instanceVariableNames: ''
	classVariableNames: 'Current'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.AbsoluteFileLocator guid: (Core.GUID fromString: '{0c174885-6aa9-43e4-98c3-a59915f5b3d7}')!

Kernel.AbsoluteFileLocator comment: 'An AbsoluteFileLocator is used to indicate the location of an external file that may be referenced within the image. 
Instances of this class always locate files by their full absolute path.

Try the following examples:

relativePath := FileLocator absolute relativePathTo: SessionManager current imageFileName. "Display It"
FileLocator absolute localFileSpecFor: relativePath. "Display It"'!

!Kernel.AbsoluteFileLocator categoriesForClass!System-Support! !

!Kernel.AbsoluteFileLocator methodsFor!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^true!

localFileSpecFor: aStringFilename
	"Answer a filespec for aStringFilename, which is expected to be an absolute path already."

	^aStringFilename

!

printOn: aStream
	"Append a developer friendly textual representation of the receiver to aStream."

	aStream
		print: self class;
		nextPutAll: ' current'!

relativePathTo: aFilename
	"Answer a minimal <readableString> relative path to the resource with the 
	specified <readableString> path, which the receiver can map back to a full
	path via its #localFileSpecFor: method. In this case we need an absolute path."

	^File fullPathOf: aFilename! !

!Kernel.AbsoluteFileLocator categoriesForMethods!
isSelfEvaluating!public!testing! !
localFileSpecFor:!accessing!public! !
printOn:!printing!public! !
relativePathTo:!accessing!public! !
!

!Kernel.AbsoluteFileLocator class methodsFor!

current
	"Answer the singleton instance of the receiver"

	Current isNil ifTrue: [ Current := self new ].
	^Current!

onPreStripImage
	"Private -  Assist in the image stripping process by clearning down any
	lazily initialized variables held by the receiver."

	self uninitialize!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	Current := nil! !

!Kernel.AbsoluteFileLocator class categoriesForMethods!
current!accessing!public! !
onPreStripImage!class hierarchy-removing!private! !
uninitialize!class hierarchy-removing!private! !
!

