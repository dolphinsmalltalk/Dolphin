"Filed out from Dolphin Smalltalk"!

Graphics.ImageInitializer
	subclass: #'Graphics.ImageFromFileInitializer'
	instanceVariableNames: 'filename fileLocator flags extent'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.ImageFromFileInitializer guid: (Core.GUID fromString: '{8d67281f-7675-4dea-9545-22e66181e2a3}')!
Graphics.ImageFromFileInitializer comment: ''!
!Graphics.ImageFromFileInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent. Two Images loaded by identifier are equal if they are of the same species, and have the same id and are from the same resource modules."

	^self == anObject or: 
			[self species == anObject species
				and: [(filename equalsIgnoreCase: anObject filename) and: [fileLocator = anObject fileLocator]]]!

createImage: anImage extent: aPoint
	^(anImage
		loadFromFile: self fileSpec
		extent: aPoint
		flags: flags)
			ifNil: 
				["Historically images loaded from files have fallen back on attempting to load the icon as a named resource from the default resource library. This allowed, for example, `Icon fromFile: 'Object.ico' to load a file in the image directory by preference, but otherwise fall back on the default Object icon in the default resource library, providing a mechanism to override default resources by using the Image class>>fromFile: instantiator. This isn't really used in the Dolphin IDE, but may be used in deployed applications so we retain for backwards compatibility."
				anImage
					loadResource: filename
					fromModule: SessionManager.Current defaultResourceLibrary
					extent: aPoint
					flags: (flags bitOr: LR_SHARED)]!

extent
	^extent!

extent: aPoint
	extent := aPoint!

fileLocator
	^fileLocator!

fileLocator: anObject
	fileLocator := anObject!

filename
	^filename!

filename: anObject
	filename := anObject!

fileSpec
	^fileLocator ifNil: [filename] ifNotNil: [fileLocator localFileSpecFor: filename]!

flag: anInteger set: aBoolean
	flags := self flags mask: anInteger set: aBoolean!

flags
	^flags!

flags: anObject
	flags := anObject!

hash
	"Answer the <integer> hash value for the receiver."

	^filename hashIgnoreCase!

printImage: anImage on: aWriteStream
	"Private - Print an expression on the <WriteStream> argument that will create a copy of the <Image> initialized by the receiver."

	aWriteStream
		print: anImage class;
		nextPutAll: ' fromFile: ';
		print: filename.
	fileLocator = FileLocator default
		ifFalse: 
			[aWriteStream
				nextPutAll: ' usingLocator: ';
				print: fileLocator]! !
!Graphics.ImageFromFileInitializer categoriesForMethods!
=!comparing!public! !
createImage:extent:!private!realizing/unrealizing! !
extent!accessing!public! !
extent:!accessing!public! !
fileLocator!accessing!public! !
fileLocator:!initializing!private! !
filename!accessing!public! !
filename:!initializing!private! !
fileSpec!accessing!private! !
flag:set:!constants!private! !
flags!accessing!private! !
flags:!initializing!private! !
hash!comparing!public! !
printImage:on:!printing!private! !
!

!Graphics.ImageFromFileInitializer class methodsFor!

filename: aFilename fileLocator: aFileLocator flags: anInteger
	<primitive: 157>
	^self
		filename: aFilename
		fileLocator: aFileLocator
		flags: anInteger
		extent: nil!

filename: aFilename fileLocator: aFileLocator flags: anInteger extent: aPoint
	<primitive: 157>
	^self new
		filename: aFilename;
		fileLocator: aFileLocator;
		flags: anInteger;
		extent: aPoint;
		yourself! !
!Graphics.ImageFromFileInitializer class categoriesForMethods!
filename:fileLocator:flags:!instance creation!public! !
filename:fileLocator:flags:extent:!instance creation!public! !
!

