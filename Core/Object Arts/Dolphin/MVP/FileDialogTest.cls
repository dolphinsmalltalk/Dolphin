"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #FileDialogTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

FileDialogTest guid: (GUID fromString: '{c406269b-ec41-4f17-bc9a-0e8bc2ba4c92}')!

FileDialogTest comment: ''!

!FileDialogTest categoriesForClass!Unclassified! !

!FileDialogTest methodsFor!

testExtractPathnames
	| subject |
	subject := FileOpenDialog new.
	subject maxFileCount: 5.
	subject prepareStruct.
	#(#(#('c:\dir1\file1') #('c:\dir1\file1')) #(#('c:\dir1\dir2' 'file1' 'file2') #('c:\dir1\dir2\file1' 'c:\dir1\dir2\file2')))
		do: 
			[:each |
			| multisz buf pathNames |
			multisz := ($\0 join: each first) asUtf16String , (Utf16String new: 2).
			buf := subject winStruct fileName.
			buf
				replaceFrom: 1
				to: multisz size
				with: multisz.
			pathNames := subject extractPathNames: buf.
			self assert: pathNames equals: each second]!

testPrepareStructWithNil
	| subject |
	subject := FileSaveDialog on: nil asValue.
	subject prepareStruct.
	self assert: subject winStruct lpstrFile isEmpty!

testPrepareStructWithUtf8String
	| subject utf8String lpstrFile |
	utf8String := 'a 🐬 Utf8String' asUtf8String.
	subject := FileSaveDialog on: utf8String.
	subject prepareStruct.
	lpstrFile := subject winStruct lpstrFile.
	self assert: lpstrFile isKindOf: Utf16String.
	self assert: lpstrFile equals: utf8String! !

!FileDialogTest categoriesForMethods!
testExtractPathnames!public! !
testPrepareStructWithNil!public! !
testPrepareStructWithUtf8String!public! !
!

