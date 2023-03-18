"Filed out from Dolphin Smalltalk"!

ResourceSTBAccessor
	subclass: #ResourceSTBFileAccessor
	instanceVariableNames: 'fileName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ResourceSTBFileAccessor guid: (Core.GUID fromString: '{87b4c6da-026e-11d3-9fd7-00a0cc3e4a32}')!
ResourceSTBFileAccessor comment: ''!
!ResourceSTBFileAccessor categoriesForClass!MVP-Resources! !
!ResourceSTBFileAccessor methodsFor!

asInternalAccessor
	"Private - Answer the receiver or a new resource accessor whose resources data is
	held entirely within the image."

	^ResourceSTBByteArrayAccessor onByteArray: self byteArray!

byteArray
	"Private - Answer a ByteArray of the contents of the receiver's file."

	| stream |
	stream := self readStream.
	^[stream contents] ensure: [stream close]!

copy
	"Private - Answer a copy of the receiver suitable for putting on the ResourcManager clipboard."

	^self asInternalAccessor!

fileName
	"Private - Answer the receiver's fileName inst var to aString. This is the name
	of the STB file from which the receiver will load instances of the resource."

	^fileName!

fileName: aString
	"Private - Set the receiver's fileName inst var to aString. This is the name
	of the STB file from which the receiver will load instances of the resource."

	fileName := aString!

isInternalAccessor
	"Answer true if the receiver denotes a resource that is held internal to the image"

	^false!

makeByteArrayClass: aResourceClass usingContext: context
	"Private - Mutate the receiver to a ResourceSTBByteArrayAccessor using the context to load
	the resource (if required), and the resources class aResourceClass to resave it."

	self become: self asInternalAccessor!

makeFile: aString class: aResourceClass usingContext: context
	"Private - Mutate the receiver to a ResourceSTBFileAccessor using the context to load
	the resource (if required), and the resources class aResourceClass to resave it into
	an STB file named aString."
!

readStream
	^FileStream read: fileName text: false!

save: anObject as: aResourceClass
	"Save out anObject in the format dictated by aResourceClass."

	| stream |
	stream := FileStream write: fileName text: false.
	
	[self
		save: anObject
		as: aResourceClass
		on: stream] ensure: [stream close]!

stbSaveOn: anSTBOutFiler
	"Output the receiver to anSTBOutFiler.
	If anSTBOutFiler has a non-nil context we assume this to be a Boolean
	that identifies whether resources should be saved as a single file. If so, we
	store the receiver's resource file data inline, and regenerate the file on load.
	Also, the proxy is required so that we can propagate the codebase of the loading
	STBInFiler into the reconstituted accessor thus allowing us to resolve remote
	class references within a resource."

	| singleFile proxy |
	singleFile := anSTBOutFiler context.

	proxy := (singleFile notNil and: [singleFile])
		ifTrue: [STBResourceSTBFileAccessorProxy withEmbeddedFile: self]
		ifFalse: [STBResourceSTBFileAccessorProxy withExternalFile: self].

	anSTBOutFiler saveObject: self as: proxy! !
!ResourceSTBFileAccessor categoriesForMethods!
asInternalAccessor!converting!private! !
byteArray!accessing!private! !
copy!copying!private! !
fileName!accessing!private! !
fileName:!accessing!private! !
isInternalAccessor!public!testing! !
makeByteArrayClass:usingContext:!mutating!private! !
makeFile:class:usingContext:!mutating!private! !
readStream!accessing!private! !
save:as:!operations!public! !
stbSaveOn:!binary filing!public! !
!

!ResourceSTBFileAccessor class methodsFor!

onFileName: aString
	"Answer a new instance of the receiver capable of loading instances of the contents
	of the STB file named aString."

	^self new
		fileName: aString;
		yourself!

stbConvertFromVersion1: version1Array
	"Private - Convert version1Array to version 2 format and answer the new Array.

	instVarAt:	Version 1		Version 0
	----------	---------		---------
		1		flags		flags
		2		classLocator	fileName
		3		fileName"

	^{version1Array at: 1. ClassLocator new. version1Array at: 2}!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^2! !
!ResourceSTBFileAccessor class categoriesForMethods!
onFileName:!instance creation!public! !
stbConvertFromVersion1:!binary filing!private! !
stbVersion!binary filing!public! !
!

