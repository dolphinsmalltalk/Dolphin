"Filed out from Dolphin Smalltalk"!

Kernel.RelativeFileLocator
	subclass: #'Kernel.FolderRelativeFileLocator'
	instanceVariableNames: 'basePath'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.FolderRelativeFileLocator guid: (Core.GUID fromString: '{e16e8b7e-eac8-41ed-95f3-742c2fc7264a}')!

Kernel.FolderRelativeFileLocator comment: '`FolderRelativeFileLocator` is the class of `FileLocator`s that can be used to map between an absolute path and a path relative to a configurable base directory.
`FolderRelativeFileLocator`s use absolute paths for files outside the local directory hierarchy below the base directory, and relative paths within their local directory hierarchy.

Instance Variables:
	basePath		<String>. Base folder path.

'!

!Kernel.FolderRelativeFileLocator categoriesForClass!System-Support! !

!Kernel.FolderRelativeFileLocator methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	^self == anObject or: [self species == anObject species and: [basePath = anObject basePath]]!

basePath
	^basePath!

basePath: aString 
	basePath := aString asPath!

hash
	^basePath hash!

printOn: aStream 
	"Append, to aStream, a String whose characters are a description of the receiver as a developer
	would want to see it."

	aStream
		display: self class name;
		space;
		nextPutAll: #basePath:;
		space;
		display: self basePath! !

!Kernel.FolderRelativeFileLocator categoriesForMethods!
=!comparing!public! !
basePath!accessing!public! !
basePath:!accessing!public! !
hash!comparing!public! !
printOn:!development!printing!public! !
!

!Kernel.FolderRelativeFileLocator class methodsFor!

basePath: aPathOrString
	"Answer a new instance of the receiver for the specified base path."

	^self basicNew
		basePath: aPathOrString;
		yourself! !

!Kernel.FolderRelativeFileLocator class categoriesForMethods!
basePath:!accessing!public! !
!

