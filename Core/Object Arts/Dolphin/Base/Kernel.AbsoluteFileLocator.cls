"Filed out from Dolphin Smalltalk"!

Core.FileLocator
	subclass: #'Kernel.AbsoluteFileLocator'
	instanceVariableNames: ''
	classVariableNames: 'Current'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.AbsoluteFileLocator guid: (Core.GUID fromString: '{0c174885-6aa9-43e4-98c3-a59915f5b3d7}')!

Kernel.AbsoluteFileLocator comment: 'An `AbsoluteFileLocator` is used to indicate the location of an external file that may be referenced within the image. 
Instances of this class always locate files by their full absolute path.

Try the following examples:
```
relativePath := FileLocator absolute abstract: SessionManager current imageFileName. "Display It"
FileLocator absolute resolve: relativePath. "Display It"
``'!

!Kernel.AbsoluteFileLocator categoriesForClass!System-Support! !

!Kernel.AbsoluteFileLocator methodsFor!

abstract: aPathOrString
	"Answer a <readableString> token for the resource with the specified <Path> or <readableString> path argument. In the case of the receiver, the answer will be a fully-qualified path."

	^aPathOrString asPath fullPath path!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^true!

printOn: aStream
	"Append a developer friendly textual representation of the receiver to aStream."

	aStream
		print: self class;
		nextPutAll: ' current'!

resolve: aString
	"Answer a full <Path> for the argument, which is expected to be the internal representation of a Path created be a previous call to #abstract: on this or an equivalent locator. 
	In this case we expect that the argument will be a fully qualified path because this locator 'abstracts' to such."

	^aString asPath! !

!Kernel.AbsoluteFileLocator categoriesForMethods!
abstract:!mapping!public! !
isSelfEvaluating!public!testing! !
printOn:!printing!public! !
resolve:!mapping!public! !
!

!Kernel.AbsoluteFileLocator class methodsFor!

current
	"Answer the singleton instance of the receiver"

	Current isNil ifTrue: [Current := self basicNew].
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

