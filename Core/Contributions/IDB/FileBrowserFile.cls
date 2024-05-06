"Filed out from Dolphin Smalltalk"!

FileBrowserAbstract subclass: #FileBrowserFile
	instanceVariableNames: 'size type timeStamp'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

FileBrowserFile guid: (GUID fromString: '{782ed51a-5423-11d3-998b-bca753d3b065}')!

FileBrowserFile comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!FileBrowserFile categoriesForClass!IDB Goodies! !

!FileBrowserFile methodsFor!

isChunkFile
	"Answers true if the file type is st or cls"

	^self isTypeIn: #('st' 'cls')!

isHTMLFile
	"Answers true if the file type is htm or html"

	^self isTypeIn: #('htm' 'html')!

isImageFile
	"Answers true if the file type is an image
	tif, tiff and png are (currently?) not displayed as images"

	^self isTypeIn: #('bmp' 'ico' 'jpg' 'jpeg' 'gif' 'tif' 'tiff' 'png')!

isTypeIn: aCollection 
	"Answers true if the file extension is included in aCollection (case insensitive)"

	^aCollection anySatisfy: [:each | each sameAs: type]!

setName: aString parent: aFileBrowserFolderOrNil 
	"initializes the extra information held about a file"

	| data |
	super setName: aString parent: aFileBrowserFolderOrNil.
	data := (File find: self path) first.
	size := data fileSize.
	type := File splitExtensionFrom: data fileName.
	timeStamp := DateAndTime fromSYSTEMTIME: data ftLastWriteTime asSYSTEMTIME.
	^self!

size
	"Answer the value of the receiver's 'size' instance variable."

	^size!

timeStamp
	"Answer the value of the receiver's 'timeStamp' instance variable."

	^timeStamp!

type
	"Answer the value of the receiver's 'type' instance variable."

	^type! !

!FileBrowserFile categoriesForMethods!
isChunkFile!public!testing! !
isHTMLFile!public!testing! !
isImageFile!public!testing! !
isTypeIn:!public!testing! !
setName:parent:!initializing!public! !
size!accessing!public! !
timeStamp!accessing!public! !
type!accessing!public! !
!

