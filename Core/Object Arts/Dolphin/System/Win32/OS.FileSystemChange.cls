"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'OS.FileSystemChange'
	instanceVariableNames: 'time code fileNames'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'ActionMap' -> #(#fileAdded: #fileRemoved: #fileModified: #fileRenamedFrom:to: 16r5)
		}!

OS.FileSystemChange guid: (Core.GUID fromString: '{ad5f4ada-4f26-46de-a418-b5a0e0c6b937}')!

OS.FileSystemChange comment: ''!

!OS.FileSystemChange categoriesForClass!Kernel-Objects! !

!OS.FileSystemChange methodsFor!

= aFileSystemChange 
	^self species == aFileSystemChange species 
		and: [code = aFileSystemChange code and: [fileNames = aFileSystemChange fileNames]]!

action
	^ActionMap at: code ifAbsent: #unknownFileChange:!

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
	fileNames := {aString}! !

!OS.FileSystemChange categoriesForMethods!
=!comparing!public! !
action!public! !
code!accessing!private! !
fileNames!accessing!public! !
fileNames:!accessing!public! !
printOn:!public! !
setCode:fileName:!initializing!private! !
!

!OS.FileSystemChange class methodsFor!

code: anInteger fileName: aString 
	^(self new)
		setCode: anInteger fileName: aString;
		yourself! !

!OS.FileSystemChange class categoriesForMethods!
code:fileName:!instance creation!public! !
!

