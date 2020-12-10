"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #StreamTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StreamTest guid: (GUID fromString: '{f1611eb3-2c1c-491e-a814-c62dcdce0fff}')!
StreamTest isAbstract: true!
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

