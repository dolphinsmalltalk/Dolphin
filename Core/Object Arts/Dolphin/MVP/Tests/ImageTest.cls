"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #ImageTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ImageTest guid: (GUID fromString: '{f5eeb969-bf36-4531-8578-24e5089a9563}')!

ImageTest isAbstract: true!

ImageTest comment: ''!

!ImageTest categoriesForClass!Unclassified! !

!ImageTest methodsFor!

canonicalInstance
	^self subjectClass default!

defaultHandle
	^0!

expectedImageExtent
	^self subclassResponsibility!

imageFile
	^self subclassResponsibility!

subjectClass
	^self subclassResponsibility!

testFromFile
	| image1 image2 |
	image1 := self subjectClass fromFile: self imageFile.
	self deny: image1 isShared.
	image2 := self subjectClass fromFile: self imageFile asLowercase.
	self assert: image1 equals: image2.
	self deny: image1 equals: self canonicalInstance.
	self assert: image1 hash equals: image2 hash.
	self assert: image1 extent equals: self expectedImageExtent.
	(image1 respondsTo: #imageIndex) ifTrue: [self assert: image1 imageIndex equals: image2 imageIndex]!

testFromFileNotFound
	| subject |
	subject := self subjectClass fromFile: 'NothingToSeeHere'.
	self assert: subject handle equals: self defaultHandle!

testFromSystemIdInvalid
	| subject |
	subject := self subjectClass fromSystemId: 1.
	self assert: subject handle equals: self defaultHandle! !

!ImageTest categoriesForMethods!
canonicalInstance!helpers!private! !
defaultHandle!constants!private! !
expectedImageExtent!constants!private! !
imageFile!constants!private! !
subjectClass!constants!private! !
testFromFile!public!unit tests! !
testFromFileNotFound!public!unit tests! !
testFromSystemIdInvalid!public!unit tests! !
!

