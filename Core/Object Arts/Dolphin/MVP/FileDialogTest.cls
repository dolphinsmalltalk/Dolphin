"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #FileDialogTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FileDialogTest guid: (GUID fromString: '{c406269b-ec41-4f17-bc9a-0e8bc2ba4c92}')!
FileDialogTest comment: ''!
!FileDialogTest categoriesForClass!Unclassified! !
!FileDialogTest methodsFor!

testPrepareStructWithUtf8String
	| subject utf8String lpstrFile |
	utf8String := 'a 🐬 Utf8String' asUtf8String.
	subject := FileSaveDialog on: utf8String.
	subject prepareStruct.
	lpstrFile := subject winStruct lpstrFile.
	self assert: lpstrFile isKindOf: Utf16String.
	self assert: lpstrFile equals: utf8String! !
!FileDialogTest categoriesFor: #testPrepareStructWithUtf8String!public! !

