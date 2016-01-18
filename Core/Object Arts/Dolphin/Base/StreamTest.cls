"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #StreamTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StreamTest guid: (GUID fromString: '{F1611EB3-2C1C-491E-A814-C62DCDCE0FFF}')!
StreamTest comment: ''!
!StreamTest categoriesForClass!Unclassified! !
!StreamTest methodsFor!

closeTempStream: aStream
	"Private - Clean up the temporary stream argument."!

streamClass
	^self subclassResponsibility!

streamOn: aString 
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <String> argument."

	^self streamClass on: aString! !
!StreamTest categoriesFor: #closeTempStream:!helpers!private! !
!StreamTest categoriesFor: #streamClass!helpers!private! !
!StreamTest categoriesFor: #streamOn:!helpers!private! !

!StreamTest class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self == ##(self)! !
!StreamTest class categoriesFor: #isAbstract!public!Testing! !

