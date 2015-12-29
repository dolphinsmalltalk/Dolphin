"Filed out from Dolphin Smalltalk X6"!

Object subclass: #FileSystemChange
	instanceVariableNames: 'time code fileNames'
	classVariableNames: 'ActionMap'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FileSystemChange guid: (GUID fromString: '{AD5F4ADA-4F26-46DE-A418-B5A0E0C6B937}')!
FileSystemChange comment: ''!
!FileSystemChange categoriesForClass!Kernel-Objects! !
!FileSystemChange methodsFor!

= aFileSystemChange 
	^self species == aFileSystemChange species 
		and: [code = aFileSystemChange code and: [fileNames = aFileSystemChange fileNames]]!

action
	^ActionMap at: code ifAbsent: [#unknownFileChange:]!

code
	^code!

fileNames
	^fileNames!

fileNames: anArray 
	fileNames := anArray!

printOn: aStream 
	aStream
		basicPrint: self;
		nextPut: $(;
		display: time;
		space;
		print: self action;
		space;
		print: self fileNames;
		nextPut: $)!

setCode: anInteger fileName: aString 
	time := FILETIME now.
	code := anInteger.
	fileNames := Array with: aString! !
!FileSystemChange categoriesFor: #=!comparing!public! !
!FileSystemChange categoriesFor: #action!public! !
!FileSystemChange categoriesFor: #code!accessing!private! !
!FileSystemChange categoriesFor: #fileNames!accessing!public! !
!FileSystemChange categoriesFor: #fileNames:!accessing!public! !
!FileSystemChange categoriesFor: #printOn:!public! !
!FileSystemChange categoriesFor: #setCode:fileName:!initializing!private! !

!FileSystemChange class methodsFor!

code: anInteger fileName: aString 
	^(self new)
		setCode: anInteger fileName: aString;
		yourself!

initialize
	ActionMap := #(#fileAdded: #fileRemoved: #fileModified: #fileRenamedFrom:to: 5)! !
!FileSystemChange class categoriesFor: #code:fileName:!instance creation!public! !
!FileSystemChange class categoriesFor: #initialize!initializing!public! !

