"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.Folder'
	instanceVariableNames: 'path'
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

	^self <=> aFolder <= 0!

<=> aFolder
	"Answer the receiver's <integer> collation order with respect to the <Folder> argument, based on case-insensitive ordinal comparison of the receiver's string path."

	^path <=> aFolder path!

= anObject
	"Answer whether the receiver is equivalent to argument."

	^self species == anObject species and: [path = anObject path]!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: self name!

folderName
	"Answer the folder name of the receiver"

	^path isRoot ifTrue: [self volumeName] ifFalse: [(self rootName \ path) path]!

hash
	"Answer the <SmallInteger> hash value for the receiver"

	^path hash!

name
	"Answer the folder name of the receiver"

	^path isEmpty
		ifTrue: [self rootName]
		ifFalse: [path isRoot ifTrue: [self volumeName] ifFalse: [path withoutSeparator fileName]]!

parent
	"Answer a <Folder> representing the receiver's parent, or nil if a root.
	Note that this will be a new object each time as currently implemented,
	but they will be equal."

	^(path isEmpty or: [path isRoot])
		ifFalse: [self class pathname: path withoutSeparator directoryName]!

path
	"Answer the folder <Path> of the receiver"

	^path!

path: aStringName
	"Private - Initialize the receiver"

	path := aStringName asPath!

pathname
	"Answer the folder pathname of the receiver"

	^path path!

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

	^[(DiskVolumeInformation forPath: path) explorerName] on: Win32Error
		do: [:ex | path withoutSeparator path]! !

!UI.Folder categoriesForMethods!
<=!comparing!public! !
<=>!comparing!public! !
=!comparing!public! !
displayOn:!displaying!public! !
folderName!accessing!public! !
hash!comparing!public! !
name!accessing!public! !
parent!accessing!public! !
path!accessing!public! !
path:!accessing!private! !
pathname!accessing!public! !
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

pathname: aPathOrString
	"Answers an instance of the receiver with the specified path.
	Note that if the path is not expected to include a file stem, and must include
	a terminating delimiter."

	^super new path: aPathOrString!

root
	"Answer an instance of the receiver representing the current root folder."

	^self pathname: ''! !

!UI.Folder class categoriesForMethods!
icon!constants!development!public! !
new!instance creation!public! !
pathname:!instance creation!public! !
root!instance creation!public! !
!

