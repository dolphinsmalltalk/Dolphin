"Filed out from Dolphin Smalltalk X6"!

Object subclass: #SourceManager
	instanceVariableNames: 'mutex '
	classVariableNames: 'ChangesIndex DefaultInstance SourcesIndex'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SourceManager guid: (GUID fromString: '{87B4C4BD-026E-11D3-9FD7-00A0CC3E4A32}')!
SourceManager comment: ''!
!SourceManager categoriesForClass!Development!System-Support! !
!SourceManager methodsFor!

basicChangesFiler
	^SourceFiles at: ChangesIndex!

basicCompressSources: progress 
	"Private - Compresses the sources file reporting the progress to
	<monadicValuable>, progress."

	| totalClasses index tmpPath smlFile filer classes |
	index := 0.
	classes := self class environment allClasses.
	totalClasses := classes size.

	"Create temporary stream file"
	tmpPath := File temporaryFilenameWithPrefix: self changesExtension.
	smlFile := self sourcesFileName.
	filer := self sourceFilerOn: (FileStream write: tmpPath).
	filer
		sourceFileIndex: SourcesIndex;
		isSourceOnly: true.
	self logComment: 'Compressing sources....' to: filer.
	index := 0.
	classes do: 
			[:class | 
			filer storeCommentString: class comment forClass: class.
			filer fileOutAllMethodsOfBehavior: class class.
			filer fileOutAllMethodsOfBehavior: class.
			progress value: (index := index + 1) * 100 / totalClasses].
	self compressPackageCommentsOn: filer.
	filer close.

	"Copy temporary file over to dolphin.sml"
	self closeSourcesFile.
	File
		delete: smlFile;
		rename: tmpPath to: smlFile.
	self openSourcesFile: smlFile.

	"Save image"
	SessionManager current saveImage.

	"Clear down change log"
	self truncateChanges.
	self logComment: 'Compressed sources'!

basicOpenSources: filePath
	"Private - Open the source streams"

	self
		openSourcesFile: filePath;
		openChangesFile: filePath!

changePositionFromDescriptor: anInteger 
	"Private - Answer the offset from the start of the source file at which the chunk containing
	the source code whose location is described by, sourceDescriptor, can be found.
	If sourceObject is not an Integer, then an error will result."

	^self basicChangesFiler sourcePositionFromDescriptor: anInteger!

changePositionOf: aSourceObject 
	"Private - Answer the offset from the start of the source file at which the chunk containing
	the source code of the specified <sourceObject> can be found. The answer is only valid
	if aSourceObject has actually been changed."

	^aSourceObject sourceDescriptor 
		ifNil: [self changesFileSize]
		ifNotNil: [:descriptor | self changePositionFromDescriptor: descriptor]!

changesExtension
	"Private - Answers the suffix to use for the changes file"

	^'chg'!

changesFileName
	"Answer the file name for the current change log."

	^self changesStream name!

changesFileNameFromPath: filePath
	"Answer the file name for a change log with the specified image path."

	^File path: filePath extension: self changesExtension!

changesFiler
	"Private - Answer a <SourceFiler> open on the changes log file, or nil 
	if there is no change log. The <SourceFiler> is position to the end of 
	the log ready to log new source, etc."

	^self basicChangesFiler ifNotNil: 
			[:changes | 
			changes
				setToEnd;
				yourself]!

changesFileSize
	"Answer the current size of the change log."

	^self changesStream size!

changesStream
	"Private - Answer the FileStream open on the changes log file."

	^self basicChangesFiler ifNotNil: [:changes | changes stream]!

chunkFilerOn: aStream 
	"Answer a <ChunkSourceFiler> on the specified stream."

	^ChunkSourceFiler on: aStream!

closeChangesFile
	"Private - Close the changes log file FileStream."

	self closeSourceAt: ChangesIndex
!

closeSourceAt: anInteger
	"Private - Closes the source FileStream SourceFiles at: anInteger and nil it out."

	(SourceFiles at: anInteger) notNil ifTrue: [
		(SourceFiles at: anInteger) close.
		SourceFiles at: anInteger put: nil ].
!

closeSources
	"Private - Closes the changes and the sources files."

	self closeSourcesFile; closeChangesFile!

closeSourcesFile
	"Private - Close the sources FileStream."

	self closeSourceAt: SourcesIndex
!

compressChangedMethodsOf: aBehavior onto: aSourceFiler 
	"Private - Emits the changed methods of aBehavior onto aSourceFiler."

	| changed |
	changed := aBehavior changedMethods collect: [:each | each selector].
	aSourceFiler fileOutMessages: changed ofBehavior: aBehavior!

compressChanges
	"Compresses the change log to remove duplicate entries, and save the image to keep it in sync."

	| tmpPath filer |
	tmpPath := File temporaryFilenameWithPrefix: self changesExtension.
	filer := self chunkFilerOn: (FileStream write: tmpPath).
	filer sourceFileIndex: ChangesIndex.
	mutex critical: 
			[self compressChangesOnto: filer.
			filer close.
			self openNewChangesFile: tmpPath].
	self logComment: 'Compressed changes'.

	"Save image"
	SessionManager current saveImage!

compressChangesOf: aClass onto: aSourceFiler 
	"Private - Compress any changes to the specified class onto the <SourceFiler>."

	"First the comment ..."

	(self sourceIndexFromDescriptor: aClass sourceDescriptor) = ChangesIndex 
		ifTrue: [aSourceFiler storeCommentString: aClass comment forClass: aClass].
	"...then the methods..."
	self
		compressChangedMethodsOf: aClass class onto: aSourceFiler;
		compressChangedMethodsOf: aClass onto: aSourceFiler.
	"Have to reset the changes index so that all changed methods are included since we have lost
	the save point"
	aClass isChanged 
		ifTrue: 
			["Note that it is necessary to remove the existing change index first since
			 attempts after the first to set it are ignored"
			aClass
				isChanged: false;
				changeIndexValue: [0]]!

compressChangesOnto: aSourceFiler 
	self class environment allClassesDo: [:each | self compressChangesOf: each onto: aSourceFiler].
	Package manager packages do: 
			[:each | 
			(self sourceIndexFromDescriptor: each sourceDescriptor) = ChangesIndex 
				ifTrue: [aSourceFiler storeCommentString: each comment forPackage: each]]!

compressPackageCommentsOn: aSourceFiler 
	Package manager packages do: 
			[:each | 
			| comment |
			comment := each comment.
			comment isEmpty 
				ifTrue: [each sourceDescriptor: nil]
				ifFalse: [aSourceFiler storeCommentString: comment forPackage: each]]!

compressSources
	"Compresses the change log into the sources file. The result is a new empty changes log.
	The image must be saved to keep it in sync."

	self basicCompressSources: [:x | ]

!

copyAndReopenSources: aString 
	"Private - Copy sources to the path and root file name (i.e. without extension) specified
	by the <readableString> argument, and then open the copies for any further perusal and 
	modification.

	Take a special interest if we do not currently have the source files available.
	This will be the case when we load from a .exe. In this case we generate some
	suitable empty source files. We also have to mark methods so that they know
	they have lost any reference to information in a .sml file."

	| hadSources |
	hadSources := self hasSources.

	"Copy and and swap over sources. Take care to end up with a good sources and imagePath"
	hadSources 
		ifTrue: 
			[self copySourceFilesTo: aString.
			self closeSources].
	hadSources 
		ifFalse: 
			[self createSources: aString.
			"We have permanently lost access to any source information so mark all methods"
			self class environment 
				allBehaviorsDo: [:aBehavior | aBehavior methodDictionary do: [:aMethod | aMethod loseSource]]].
	self openSources: aString!

copySourceFilesTo: path
	"Private - Copy the various Smalltalk sources files to a new root name"

	self flushChanges.
	[ File
		copy: self sourcesFileName to: (self sourcesFileNameFromPath: path);
		copy: self changesFileName to: (self changesFileNameFromPath: path)
	] on: HRESULTError do: [:e |
		self error: 'Failed to copy sources to ', path, '(', e osErrorMessage, ')']!

createSources: filePath
	"Private - This will create a sources and changes file for the current image. Does not
	update the receiver to use these new files though."

	self createSourcesFile: filePath.
	(File open: (self changesFileNameFromPath: filePath) mode: #truncate check: false) close!

createSourcesFile: filePath 
	"Private - Create (or truncate) a source file with the specified path (and default extension)."

	(self newSourceFiler: (self sourcesFileNameFromPath: filePath)) close!

emitFileOutHeaderOn: aSourceFiler 
	"Private - Append the standard Dolphin file out header to the
	<puttableStream>, aWriteStream."

	aSourceFiler
		emitComment: 'Filed out from ' , VMLibrary default productName;
		cr!

errorNotPackaged: anObject
	"Private - Signal an error to indicate than anObject is not yet assigned to a packaged
	and therefore cannot be filed out"

	anObject error: 'Object is not owned by any package'!

fileIn: aFileName
	"File in the chunk format file named, aFileName, into the system."

	| stream |
	stream := FileStream read: aFileName.
	[self fileInFrom: stream] ensure: [stream close].!

fileInFrom: aStream 
	"Private - File in the expressions/definitions from the chunk stream, aStream.
	in the receiver's chunk format. Any methods that do not	compile are stubbed 
	with instances of CompileFailedMethod and errors logged to the Transcript."

	(self chunkFilerOn: aStream) fileIn!

fileInPackagedClass: aClass
	"File in aClass via the package mechanism. The class is filed in from the same directory as the
	package which contains it. Following this call the class and its methods are marked as unchanged."

	self fileInPackagedClass: aClass from: aClass fileOutName.


	!

fileInPackagedClass: aClass from: aFileName
	"File in aClass via the package mechanism. The class is filed in from aFileName.
	Following this call the class and its methods are marked as unchanged."

	self fileIn: aFileName.
	aClass initializeAfterLoad


	!

fileItIn: aString
	"File the chunk format Smalltalk expression in aString into the system"

	self fileInFrom: aString readStream
!

fileOut: anObject
	"File out anObject to its default file. If an error occurs during file out, the file
	will be closed by finalization."

	self fileOut: anObject to: anObject fileOutName.!

fileOut: anObject to: aFileName 
	"File out anObject to aFileName. If an error occurs during file out, the file
	will be closed by finalization."

	| filer |
	filer := self newSourceFiler: aFileName.
	anObject fileOutOn: filer.
	filer close!

fileOutPackagedClass: aClass
	"File out aClass via the package mechanism. The class is filed out to the same directory as the
	package which contains it. Only the methods contained in this package are included in the 
	generated file and following this call the class and its methods are marked as unchanged."

	self fileOutPackagedClass: aClass to: aClass fileOutName.
	!

fileOutPackagedClass: aClass to: aFileName 
	"File out aClass via the package mechanism. The class is filed out to aFileName.
	Only the methods contained in this package are included in the 
	generated file and following this call the class and its methods are marked as unchanged."

	| package filer |
	package := self packageManager packageOfClass: aClass.
	package isNil 
		ifTrue: 
			["Not in any package so just file out normally"
			^self fileOut: aClass to: aFileName].
	filer := self newSourceFiler: aFileName.
	filer fileOutDefinitionOfClass: aClass.
	package fileOutMethodsOfClass: aClass on: filer.
	package fileOutMethodsOfClass: aClass class on: filer.
	filer close.

	"Flag the class as being saved, i.e. no longer changed"
	aClass isChanged: false!

flushChanges
	"Private - Perform a full flush (i.e. flush OS file buffers) on the change log so 
	that change log file is guaranteed to be up-to-date. This should be performed before 
	an image save to guarantee that source is not lost."

	self changesStream fullFlush
!

getSourceFromDescriptor: sourceDescriptor
	"Answer the <readableString> source corresponding to the specified <integer> 
	descriptor, sourceDescriptor, from the receiver's source files. Note that the descriptor
	is allowed to be nil (in which case the answer is the empty string), or some other
	non-integer <readableString> object directly representing the source."

	| filer |
	filer := self sourceFileFromDescriptor: sourceDescriptor.
	filer notNil 
		ifTrue: [^mutex critical: [filer getSourceFromDescriptor: sourceDescriptor]]
		ifFalse: 
			[(sourceDescriptor isNil or: [sourceDescriptor isInteger]) 
				ifFalse: [^sourceDescriptor asString]].
	^''!

getSourceOfMethod: aCompiledMethod
	"Answer the source of the method, aCompiledMethod, from the receiver's source files."

	| source |
	source := self getSourceFromDescriptor: aCompiledMethod sourceDescriptor.
	^source isEmpty 
		ifTrue: ['"Source currently unavailable"']
		ifFalse: [source]!

hasMethodChanged: aCompiledMethod
	"Private - Answer whether the receiver has been 'changed' (i.e. it has source in
	the change log)."

	^(self sourceIndexFromDescriptor: aCompiledMethod sourceDescriptor) == ChangesIndex!

hasSources
	"Private - Answer whether the the sources and changes files are available."

	^self changesStream notNil and: [self sourcesFileStream notNil]!

ignoreSources
	"Private - Initialize the receiver so that no source is available"

	SourceFiles
		at: ChangesIndex put: nil;
		at: SourcesIndex put: nil.!

initialize
	"N.B. This must be a mutex as, for example,when copying a methods source from one source stream from another 
	re-entry will occur."

	mutex := Mutex new!

isMethodChanged: aCompiledMethod 
	"Private - Answer whether the <CompiledMethod> argument is 'changed' (i.e. it has been
	changed since its class was last saved)."

	"Implementation Note: Its faster to lookup the class 'first change' index last, because it
	is stored in a property."

	^(self hasMethodChanged: aCompiledMethod) and: 
			[(aCompiledMethod isLoose 
				ifTrue: [aCompiledMethod owningPackage changeIndex]
				ifFalse: [aCompiledMethod methodClass instanceClass changeIndex]) 
					ifNil: [false]
					ifNotNil: [:i | (self changePositionOf: aCompiledMethod) >= i]]!

logChanged: aSourceObject
	"File out the changed <sourceObject>, aSourceObject, to the change log."

	self changesFiler 
		ifNotNil: [:logger | mutex critical: 
					[aSourceObject fileOutOn: logger.
					logger flush]]!

logComment: aString
	"Record aString to the change log as a comment. All comments
	logged are prefixed with a timestamp.
	N.B. Logging requests should be directed through the SessionManager."

	self changesFiler 
		ifNotNil: [:logger | mutex critical: [self logComment: aString to: logger]]!

logComment: aString to: aSourceFiler
	"Private - Record aString to the specified source file as a comment. All comments
	logged are prefixed with a timestamp."

	aSourceFiler emitComment: TimeStamp current displayString, ': ', aString; cr!

logEvaluate: aString
	"Record aString to the change log as an expression which has been evaluated."

	self changesFiler 
		ifNotNil: [:logger | mutex critical: 
					[logger
						fileOutExpression: aString;
						flush]]!

newSourceFiler: path
	"Private - Answer a new <SourceFiler> on the specified path with the default
	format. Any existing file with at the specified path is truncated."

	| answer dir |
	dir := File splitPathFrom: path.
	(File isDirectory: dir) ifFalse: [File createDirectoryPath: dir].
	answer := self sourceFilerOn: (FileStream write: path).
	self emitFileOutHeaderOn: answer.
	^answer!

onExit
	"Private - The system is about to exit, close the source files."

	SourceFiles do: [:f | f notNil ifTrue: [f close]]
!

openChangesFile: filePath 
	"Private - Open the change log file and record it in SourceFiles at: 2."

	| stream |
	stream := FileStream readWrite: (self changesFileNameFromPath: filePath).
	SourceFiles 
		at: ChangesIndex 
			put: ((self chunkFilerOn: stream) sourceFileIndex: ChangesIndex; yourself)!

openNewChangesFile: aString 
	| changesFileName |
	changesFileName := self changesFileName.
	self closeChangesFile.
	File
		delete: changesFileName;
		rename: aString to: changesFileName.
	^self openChangesFile: changesFileName!

openSources
	"Private - Initialize source streams -to the defaults for the current session"

	self openSources: SessionManager current imagePath!

openSources: aString
	"Private - Initialize source streams - otherwise we'll not be able to see any source code.
	This should be done very early on in the startup."

	self closeSources.
	[self basicOpenSources: aString] on: FileException do: [:aFileException |
		aFileException notify.
		self ignoreSources]!

openSourcesFile: filePath 
	"Private - Opens a big sources file and record it in SourceFiles at: 1."

	| stream |
	stream := FileStream read: (self sourcesFileNameFromPath: filePath).
	SourceFiles 
		at: SourcesIndex 
		put: ((self sourceFilerOn: stream) sourceFileIndex: SourcesIndex; yourself)!

packageManager
	"Private - Answer the package manager to be used by the receiver."

	^Package manager!

sourceFileFromDescriptor: sourceDescriptor
	"Private - Answer the <SourceFiler> corresponding to the <integer> source descriptor,
	sourceDescriptor, which encodes the index of the filer in its first 4 bits. The remaining
	bits are the unique identifier used by that filer to locate the source for that object. If
	the specified source descriptor is not actually an integer (which is permitted) then answer
	nil, in which case the source descriptor is expected to be an object which can be resolved
	to the source by sending it the #asString method."

	^SourceFiles at: (self sourceIndexFromDescriptor: sourceDescriptor) ifAbsent: []!

sourceFilerClass
	"Answer the class of <SourceFiler> used by the receiver to write source files."

	^ChunkSourceFiler!

sourceFilerOn: aStream
	"Answer a <SourceFiler> on the <puttableStream>, aWriteStream."

	^self sourceFilerClass on: aStream!

sourceIndexFromDescriptor: sourceObject 
	"Private - Answer an index into the SourceFiles array which specifies where the source of the 
	method whose source descriptor is, sourceObject, or 0 if the sourceObject is not an <integer>
	source descriptor."

	^sourceObject isInteger ifTrue: [sourceObject bitAnd: 16rF] ifFalse: [0]!

sourcesExtension
	"Private - Answer the suffix for the sources file"

	^'sml'!

sourcesFileName
	"Answer the file name for the current sources file."

	^self sourcesFileStream name!

sourcesFileNameFromPath: filePath
	"Private - Answer a file name for a source file at the specified path."

	^File path: filePath extension: self sourcesExtension!

sourcesFileStream
	"Private - Answer the FileStream open on the big sources file."

	^(SourceFiles at: SourcesIndex) ifNotNil: [:sourceFile | sourceFile stream]!

storeCategoriesForClass: class
	"Private - Store the categories of the <ClassDescription>, class, to
	the change log so that they may be reloaded later."

	self changesFiler 
		ifNotNil: [:logger | mutex critical: 
					[logger
						emitCategoriesOfClass: class;
						flush]]!

storeCategoriesForMethod: method
	"Private - Store the categories of the <CompiledMethod>, method, to the change
	log so that they may be reloaded later."

	self changesFiler ifNotNil: 
			[:logger | 
			mutex critical: 
					[logger
						emitCategoriesOfMethod: method;
						cr;
						flush]]!

storeCommentString: aString forClass: aClass 
	"Private - Append the <readableString> comment, aString, for the <Class>, aClass, to the
	change log, saving the position and index so that it may be retrieved later. If a valid
	source file is not available then just store aString directly in the class."

	self changesFiler 
		ifNil: [aClass sourceDescriptor: aString]
		ifNotNil: 
			[:filer | 
			mutex critical: 
					[filer
						storeCommentString: aString forClass: aClass;
						flush]]!

storeCommentString: aString forPackage: aPackage 
	"Private - Append the <readableString> comment, aString, for the <Package>, aPackage, to the
	change log, saving the position and index so that it may be retrieved later. If a valid
	source file is not available then just store aString directly in the package."

	self changesFiler 
		ifNil: [aPackage sourceDescriptor: aString]
		ifNotNil: 
			[:filer | 
			mutex critical: 
					[filer
						storeCommentString: aString forPackage: aPackage;
						flush]]!

storeGUIDForClass: class
	"Private - Append the GUID of the <Class>, class, to the change log in a evaluable chunk."

	self changesFiler 
		ifNotNil: [:logger | mutex critical: 
					[logger
						emitGUIDOfClass: class;
						flush]]!

storeSourceString: aString forMethod: aCompiledMethod
	"Private - Append the source, aString, for the method, aCompiledMethod, 
	to the change log, saving the position and index so that it may be 
	retrieved later.
	If a valid source file is not available then just store aString
	directly in the method."

	| logger |
	(logger := self changesFiler) isNil 
		ifTrue: [aCompiledMethod sourceDescriptor: aString]
		ifFalse: [mutex critical: [logger storeSourceString: aString forMethod: aCompiledMethod]]!

truncateChanges
	"Private - Truncate the change log.
	WARNING: If you do this you will lose the source of all changes since the
	last #compressSources."

	mutex critical: 
			[| chgFile |
			chgFile := self changesFileName.
			self closeChangesFile.
			(FileStream write: chgFile) close.	"truncate it"
			self openChangesFile: chgFile]! !
!SourceManager categoriesFor: #basicChangesFiler!accessing!private! !
!SourceManager categoriesFor: #basicCompressSources:!operations-source files!private! !
!SourceManager categoriesFor: #basicOpenSources:!operations-source files!private! !
!SourceManager categoriesFor: #changePositionFromDescriptor:!private!source filing! !
!SourceManager categoriesFor: #changePositionOf:!development!private!testing! !
!SourceManager categoriesFor: #changesExtension!constants!private! !
!SourceManager categoriesFor: #changesFileName!accessing!public! !
!SourceManager categoriesFor: #changesFileNameFromPath:!public!source filing! !
!SourceManager categoriesFor: #changesFiler!accessing!private! !
!SourceManager categoriesFor: #changesFileSize!accessing!public! !
!SourceManager categoriesFor: #changesStream!accessing!private! !
!SourceManager categoriesFor: #chunkFilerOn:!accessing!public! !
!SourceManager categoriesFor: #closeChangesFile!operations-source files!private! !
!SourceManager categoriesFor: #closeSourceAt:!operations-source files!private! !
!SourceManager categoriesFor: #closeSources!operations-source files!private! !
!SourceManager categoriesFor: #closeSourcesFile!operations-source files!private! !
!SourceManager categoriesFor: #compressChangedMethodsOf:onto:!operations-source files!private! !
!SourceManager categoriesFor: #compressChanges!operations-source files!public! !
!SourceManager categoriesFor: #compressChangesOf:onto:!operations-source files!private! !
!SourceManager categoriesFor: #compressChangesOnto:!operations-source files!public! !
!SourceManager categoriesFor: #compressPackageCommentsOn:!operations-source files!private! !
!SourceManager categoriesFor: #compressSources!operations-source files!public! !
!SourceManager categoriesFor: #copyAndReopenSources:!operations-source files!private! !
!SourceManager categoriesFor: #copySourceFilesTo:!operations-source files!private! !
!SourceManager categoriesFor: #createSources:!operations-source files!private! !
!SourceManager categoriesFor: #createSourcesFile:!operations-source files!private! !
!SourceManager categoriesFor: #emitFileOutHeaderOn:!private!source filing! !
!SourceManager categoriesFor: #errorNotPackaged:!exceptions!private! !
!SourceManager categoriesFor: #fileIn:!public!source filing! !
!SourceManager categoriesFor: #fileInFrom:!private!source filing! !
!SourceManager categoriesFor: #fileInPackagedClass:!public!source filing! !
!SourceManager categoriesFor: #fileInPackagedClass:from:!public!source filing! !
!SourceManager categoriesFor: #fileItIn:!public!source filing! !
!SourceManager categoriesFor: #fileOut:!public!source filing! !
!SourceManager categoriesFor: #fileOut:to:!public!source filing! !
!SourceManager categoriesFor: #fileOutPackagedClass:!public!source filing! !
!SourceManager categoriesFor: #fileOutPackagedClass:to:!public!source filing! !
!SourceManager categoriesFor: #flushChanges!operations-source files!private! !
!SourceManager categoriesFor: #getSourceFromDescriptor:!public!source filing! !
!SourceManager categoriesFor: #getSourceOfMethod:!public!source filing! !
!SourceManager categoriesFor: #hasMethodChanged:!private!testing! !
!SourceManager categoriesFor: #hasSources!private!testing! !
!SourceManager categoriesFor: #ignoreSources!operations-source files!private! !
!SourceManager categoriesFor: #initialize!initializing!private! !
!SourceManager categoriesFor: #isMethodChanged:!development!private!testing! !
!SourceManager categoriesFor: #logChanged:!public!source filing! !
!SourceManager categoriesFor: #logComment:!operations-logging!public! !
!SourceManager categoriesFor: #logComment:to:!operations-logging!private! !
!SourceManager categoriesFor: #logEvaluate:!operations-logging!public! !
!SourceManager categoriesFor: #newSourceFiler:!private!source filing! !
!SourceManager categoriesFor: #onExit!event handling!private! !
!SourceManager categoriesFor: #openChangesFile:!operations-source files!private! !
!SourceManager categoriesFor: #openNewChangesFile:!helpers!private! !
!SourceManager categoriesFor: #openSources!operations-source files!private! !
!SourceManager categoriesFor: #openSources:!operations-source files!private! !
!SourceManager categoriesFor: #openSourcesFile:!operations-source files!private! !
!SourceManager categoriesFor: #packageManager!accessing!must strip!private! !
!SourceManager categoriesFor: #sourceFileFromDescriptor:!private!source filing! !
!SourceManager categoriesFor: #sourceFilerClass!constants!public! !
!SourceManager categoriesFor: #sourceFilerOn:!helpers!public! !
!SourceManager categoriesFor: #sourceIndexFromDescriptor:!private!source filing! !
!SourceManager categoriesFor: #sourcesExtension!constants!private! !
!SourceManager categoriesFor: #sourcesFileName!accessing!public! !
!SourceManager categoriesFor: #sourcesFileNameFromPath:!private!source filing! !
!SourceManager categoriesFor: #sourcesFileStream!accessing!private! !
!SourceManager categoriesFor: #storeCategoriesForClass:!private!source filing! !
!SourceManager categoriesFor: #storeCategoriesForMethod:!private!source filing! !
!SourceManager categoriesFor: #storeCommentString:forClass:!private!source filing! !
!SourceManager categoriesFor: #storeCommentString:forPackage:!private!source filing! !
!SourceManager categoriesFor: #storeGUIDForClass:!private!source filing! !
!SourceManager categoriesFor: #storeSourceString:forMethod:!private!source filing! !
!SourceManager categoriesFor: #truncateChanges!operations-source files!private! !

!SourceManager class methodsFor!

default
	"Answer the default SourceManager to use."

	DefaultInstance isNil ifTrue: [ SourceManager newDefault ].
	^DefaultInstance!

default: aSourceManager
	"Set the default  source manager to aSourceManager."

	DefaultInstance notNil ifTrue: [ DefaultInstance closeSources ].
	DefaultInstance := aSourceManager.
	DefaultInstance notNil ifTrue: [ DefaultInstance openSources ].!

icon
	"Answers an Icon that can be used to represent this class. Here we use a constant expression 
	evaluated at compile time in order to statically bind 'self' at this position in the class hierarchy 
	(i.e. to Object). This ensures that subclasses which do not override this method still answer 
	'Object defaultIcon' rather than 'aSubclass defaultIcon'. Classes which provide their own default icon 
	can override this method with a similar implementation perhaps with #defaultIconFrom: if the icon comes
	from an ExternalResourceLibrary other than the system default."

	^##(self) defaultIcon!

initialize
	"Initialize the class variables of the receiver"

	SourcesIndex := 1.
	ChangesIndex := 2!

new
	^super new initialize!

newDefault
	"Answer an instance of the receiver which becomes the default source manager"

	| sm |
	sm := self new.
	self default: sm.
	^sm!

reset
	"Private - Reset this class"
	DefaultInstance class==self ifTrue: [ 
		DefaultInstance closeSources.
		DefaultInstance  := nil ].
!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	self reset! !
!SourceManager class categoriesFor: #default!accessing!public! !
!SourceManager class categoriesFor: #default:!accessing!public! !
!SourceManager class categoriesFor: #icon!constants!public! !
!SourceManager class categoriesFor: #initialize!initializing!public! !
!SourceManager class categoriesFor: #new!instance creation!public! !
!SourceManager class categoriesFor: #newDefault!instance creation!public! !
!SourceManager class categoriesFor: #reset!initializing!private! !
!SourceManager class categoriesFor: #uninitialize!class hierarchy!class hierarchy-removing!private! !

