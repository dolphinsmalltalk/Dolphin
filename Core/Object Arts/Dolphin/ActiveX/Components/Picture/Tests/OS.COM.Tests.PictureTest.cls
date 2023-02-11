"Filed out from Dolphin Smalltalk"!

Graphics.Tests.ImageTest subclass: #'OS.COM.Tests.PictureTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.Tests.PictureTest guid: (Core.GUID fromString: '{757ce423-a612-4964-abe1-c1e2d65ea27a}')!
OS.COM.Tests.PictureTest comment: ''!
!OS.COM.Tests.PictureTest methodsFor!

canonicalInstance
	^self subjectClass new!

expectedImageExtent
	^190 @ 380!

imageFile
	^'Resources\LagoonSideBar.jpg'!

subjectClass
	^Picture!

testFromFileNotFound
	| subject |
	subject := self subjectClass fromFile: 'NothingToSeeHere'.
	"We get a default picture if the file was not found"
	self assert: subject handle notNull! !
!OS.COM.Tests.PictureTest categoriesForMethods!
canonicalInstance!constants!private! !
expectedImageExtent!constants!private! !
imageFile!constants!private! !
subjectClass!constants!private! !
testFromFileNotFound!public! !
!

