"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.Folder'
	instanceVariableNames: 'pathname'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Folder guid: (Core.GUID fromString: '{a5b3954d-5310-45c1-b09e-ee7dd70d6cd5}')!
UI.Folder comment: ''!
!UI.Folder categoriesForClass!MVP-Models! !
!UI.Folder methodsFor!

<= aFolder
	"Answer whether the receiver is less than or equal to the <Folder> argument."

	^(pathname compare: aFolder pathname ignoreCase: true) <= 0!

= anObject
	"Answer whether the receiver is equivalent to argument."

	^self species == anObject species and: [pathname equalsIgnoreCase: anObject pathname]!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: self name!

folderName
	"Answer the folder name of the receiver"

	^(File isRootPath: self pathname)
		ifTrue: [self volumeName]
		ifFalse: [File composePath: self rootName subPath: self pathname]!

hash
	"Answer the <SmallInteger> hash value for the receiver"

	^pathname hashIgnoreCase!

name
	"Answer the folder name of the receiver"

	^self pathname isEmpty
		ifTrue: [self rootName]
		ifFalse: 
			[(File isRootPath: self pathname)
				ifTrue: [self volumeName]
				ifFalse: [File splitFilenameFrom: (File removePathDelimiter: self pathname)]]!

parent
	"Answer a <Folder> representing the receiver's parent, or nil if a root.
	Note that this will be a new object each time as currently implemented,
	but they will be equal."

	| path |
	path := self pathname.
	^(path isEmpty or: [File isRootPath: path])
		ifFalse: [self class pathname: (File splitPathFrom: (File removePathDelimiter: path))]!

pathname
	"Answer the folder pathname of the receiver"

	^pathname!

pathname: aStringName
	"Private - Initialize the receiver"

	pathname := aStringName!

printOn: aStream
	"Append, to aStream, a String whose characters are a description of the receiver as a developer
	would want to see it."

	aStream
		basicPrint: self;
		nextPut: $(;
		display: self folderName;
		nextPut: $)
!

rootName
	"Private - Answer the name to use for the folder at the root of the current image hierarchy"

	^'\'!

volumeName
	"Answer the name of the volume of this package folder in the form that Windows explorer
	would display it."

	^[(DiskVolumeInformation forPath: self pathname) explorerName] on: Win32Error
		do: [:ex | File removePathDelimiter: self pathname]! !
!UI.Folder categoriesForMethods!
<=!comparing!public! !
=!comparing!public! !
displayOn:!displaying!public! !
folderName!accessing!public! !
hash!comparing!public! !
name!accessing!public! !
parent!accessing!public! !
pathname!accessing!public! !
pathname:!accessing!private! !
printOn:!printing!public! !
rootName!constants!private! !
volumeName!accessing!private! !
!

!UI.Folder class methodsFor!

icon
	"Answers an Icon that can be used to represent this class. "

	^##(self) defaultIcon!

new
	"Private - Use #pathname:"

	self shouldNotImplement!

pathname: aString
	"Answers an instance of the receiver with the specified path.
	Note that if the path is not expected to include a file stem, and must include
	a terminating delimiter."

	^super new pathname: aString!

root
	"Answer an instance of the receiver representing the current root folder."

	^self pathname: ''! !
!UI.Folder class categoriesForMethods!
icon!constants!development!public! !
new!instance creation!public! !
pathname:!instance creation!public! !
root!instance creation!public! !
!

