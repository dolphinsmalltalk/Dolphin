"Filed out from Dolphin Smalltalk"!

Object subclass: #FileBrowserAbstract
	instanceVariableNames: 'name parent children'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FileBrowserAbstract guid: (GUID fromString: '{782ed519-5423-11d3-998b-bca753d3b065}')!
FileBrowserAbstract comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!FileBrowserAbstract categoriesForClass!IDB Goodies! !
!FileBrowserAbstract methodsFor!

name
	"Answers the name of the receiver. This can be either a complete path (the root folder) or
	a folder name of a file name depending on the subclass used"

	^name!

parent
	"Answers the parent of the receiver or nil if it is the root"

	^parent!

path
	"Creates the path of the receiver by appending to the path of the parent (s)"

	parent isNil ifTrue: [^name].
	^File composePath: parent path subPath: name!

printOn: aStream 
	"Answer the String to be used for the receiver in the tree or list"

	aStream nextPutAll: name!

setName: aString parent: aFileBrowserFolderOrNil 
	"Sets the name of this objects and remembers its parent. The children (folders
	not files) will be found dynamically by the subclass"

	name := aString.
	parent := aFileBrowserFolderOrNil.
	^self! !
!FileBrowserAbstract categoriesForMethods!
name!accessing!public! !
parent!accessing!public! !
path!accessing!public! !
printOn:!protocols-Object!public! !
setName:parent:!initializing!public! !
!

!FileBrowserAbstract class methodsFor!

name: aString parent: aFileBrowserFolderOrNil 
	"Answers a new instance of the receiver"

	^self new setName: aString parent: aFileBrowserFolderOrNil! !
!FileBrowserAbstract class categoriesForMethods!
name:parent:!instance creation!public! !
!

