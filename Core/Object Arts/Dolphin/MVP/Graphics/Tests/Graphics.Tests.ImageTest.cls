"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Graphics.Tests.ImageTest'
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

testDrawWithNegativeExtent
	| subject bitmap canvas |
	subject := self canonicalInstance.
	bitmap := DIBSection extent: 48 @ 48.
	canvas := bitmap canvas.
	canvas
		brush: Color chartreuse brush;
		pen: Color tomato pen.
	canvas rectangle: (0 @ 0 extent: bitmap extent).
	-5 to: -10 by: -5
		do: 
			[:i |
			self assert: (canvas pixelAt: 0 @ 0) equals: Color tomato.
			self assert: (canvas pixelAt: 1 @ 1) equals: Color chartreuse.
			subject
				drawOn: canvas
				at: 0 @ 0
				extent: i @ i].
	bitmap free!

testDrawWithNullExtent
	| subject bitmap canvas |
	subject := self canonicalInstance.
	bitmap := DIBSection extent: 48 @ 48.
	canvas := bitmap canvas.
	canvas
		brush: Color chartreuse brush;
		pen: Color tomato pen.
	canvas rectangle: (0 @ 0 extent: bitmap extent).
	self assert: (canvas pixelAt: 0 @ 0) equals: Color tomato.
	self assert: (canvas pixelAt: 1 @ 1) equals: Color chartreuse.
	subject
		drawOn: canvas
		at: 0 @ 0
		extent: 0 @ 0.
	self assert: (canvas pixelAt: 0 @ 0) equals: Color tomato.
	self assert: (canvas pixelAt: 1 @ 1) equals: Color chartreuse.
	bitmap free!

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
testDrawWithNegativeExtent!public! !
testDrawWithNullExtent!public! !
testFromFile!public! !
testFromFileNotFound!public! !
testFromSystemIdInvalid!public! !
!

