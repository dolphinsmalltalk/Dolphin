"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Graphics.Tests.ImageTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Tests.ImageTest guid: (Core.GUID fromString: '{b1d5b3fb-9bac-444a-883b-3c3dfed414b1}')!
Graphics.Tests.ImageTest isNonInstantiable: true!
Graphics.Tests.ImageTest comment: ''!
!Graphics.Tests.ImageTest methodsFor!

canonicalInstance
	^self subjectClass default!

expectedImageExtent
	^self subjectClass defaultExtent!

imageFile
	^self subclassResponsibility!

subjectClass
	^self subclassResponsibility!

testFromFile
	| image1 image2 |
	image1 := self subjectClass fromFile: self imageFile.
	self deny: image1 initializer isLoadShared.
	image2 := self subjectClass fromFile: self imageFile asLowercase.
	self assert: image1 equals: image2.
	self deny: image1 equals: self canonicalInstance.
	self assert: image1 hash equals: image2 hash.
	self assert: image1 extent equals: self expectedImageExtent.
	(image1 respondsTo: #imageIndex) ifTrue: [self assert: image1 imageIndex equals: image2 imageIndex]!

testFromFileNotFound
	| subject |
	subject := self subjectClass fromFile: 'NothingToSeeHere'.
	self assert: subject handle equals: self subjectClass defaultHandle!

testFromSystemIdInvalid
	| subject |
	subject := self subjectClass fromSystemId: 1.
	self assert: subject handle equals: self subjectClass defaultHandle! !
!Graphics.Tests.ImageTest categoriesForMethods!
canonicalInstance!constants!private! !
expectedImageExtent!constants!private! !
imageFile!constants!private! !
subjectClass!constants!private! !
testFromFile!public! !
testFromFileNotFound!public! !
testFromSystemIdInvalid!public! !
!

