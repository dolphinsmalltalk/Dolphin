"Filed out from Dolphin Smalltalk"!

Object subclass: #FileSystemChange
	instanceVariableNames: 'time code fileNames'
	classVariableNames: 'ActionMap'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

FileSystemChange guid: (GUID fromString: '{ad5f4ada-4f26-46de-a418-b5a0e0c6b937}')!

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

!FileSystemChange categoriesForMethods!
=!comparing!public! !
action!public! !
code!accessing!private! !
fileNames!accessing!public! !
fileNames:!accessing!public! !
printOn:!public! !
setCode:fileName:!initializing!private! !
!

!FileSystemChange class methodsFor!

code: anInteger fileName: aString 
	^(self new)
		setCode: anInteger fileName: aString;
		yourself!

initialize
	ActionMap := #(#fileAdded: #fileRemoved: #fileModified: #fileRenamedFrom:to: 5)! !

!FileSystemChange class categoriesForMethods!
code:fileName:!instance creation!public! !
initialize!initializing!public! !
!

