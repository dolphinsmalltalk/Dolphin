"Filed out from Dolphin Smalltalk"!

RelativeFileLocator subclass: #FolderRelativeFileLocator
	instanceVariableNames: 'basePath'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

FolderRelativeFileLocator guid: (GUID fromString: '{e16e8b7e-eac8-41ed-95f3-742c2fc7264a}')!

FolderRelativeFileLocator comment: 'FolderRelativeFileLocator is the class of <FileLocator>s that can be used to map between an absolute path and a path relative to a configurable base directory.
FolderRelativeFileLocators use absolute paths for files outside the local directory hierarchy below the base directory, and relative paths within their local directory hierarchy.

Instance Variables:
	basePath		<String>. Base folder path.

'!

!FolderRelativeFileLocator categoriesForClass!System-Support! !

!FolderRelativeFileLocator methodsFor!

basePath
	^basePath!

basePath: aString 
	basePath := aString!

printOn: aStream 
	"Append, to aStream, a String whose characters are a description of the receiver as a developer
	would want to see it."

	aStream
		display: self class name;
		space;
		nextPutAll: #basePath:;
		space;
		print: self basePath! !

!FolderRelativeFileLocator categoriesForMethods!
basePath!accessing!public! !
basePath:!accessing!public! !
printOn:!development!printing!public! !
!

!FolderRelativeFileLocator class methodsFor!

basePath: aString 
	"Answer a new instance of the receiver for the specified base path."

	^(self new)
		basePath: aString;
		yourself! !

!FolderRelativeFileLocator class categoriesForMethods!
basePath:!accessing!public! !
!

