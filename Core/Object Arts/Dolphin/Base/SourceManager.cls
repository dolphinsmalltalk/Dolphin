"Filed out from Dolphin Smalltalk"!

Object subclass: #SourceManager
	instanceVariableNames: 'mutex'
	classVariableNames: 'ChangesIndex DefaultInstance SourcesIndex'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SourceManager guid: (GUID fromString: '{87b4c4bd-026e-11d3-9fd7-00a0cc3e4a32}')!

SourceManager comment: ''!

!SourceManager categoriesForClass!Development!System-Support! !

!SourceManager methodsFor!

basicChangesFiler
	^SourceFiles at: ChangesIndex!

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
	"Answer a <ChunkSourceFiler> on the specified stream. The filer leaves existing line endings alone."

	^ChunkSourceFiler on: aStream!

closeChangesFile
	"Private - Close the changes log file FileStream."

	self closeSourceAt: ChangesIndex
!

closeSourceAt: anInteger
	"Private - Closes the source FileStream SourceFiles at: anInteger and nil it out."

	(SourceFiles at: anInteger)
		ifNotNil: 
			[:file |
			file close.
			SourceFiles at: anInteger put: nil]!

closeSources
	"Private - Closes the changes and the sources files."

	1 to: SourceFiles size do: [:i | self closeSourceAt: i]!

closeSourcesFile
	"Private - Close the sources FileStream."

	self closeSourceAt: SourcesIndex
!

copySourceFilesTo: path
	"Private - Copy the various Smalltalk sources files to a new root name"

	self flushChanges.
	
	[File
		copy: self sourcesFileName to: (self sourcesFileNameFromPath: path);
		copy: self changesFileName to: (self changesFileNameFromPath: path)]
			on: HRESULTError
			do: 
				[:e |
				self error: ('Failed to copy sources to <1s> (<2s>)' expandMacrosWith: path with: e osErrorMessage)]!

errorNotPackaged: anObject
	"Private - Signal an error to indicate than anObject is not yet assigned to a packaged
	and therefore cannot be filed out"

	anObject error: 'Object is not owned by any package'!

fileIn: aFileName
	"File in the chunk format file named, aFileName, into the system."

	self fileIn: aFileName normalizeLineEndings: false!

fileIn: aString normalizeLineEndings: aBoolean
	"File in the chunk format file named, aString, into the system. If the <Boolean> argument is
	true then any non-standard CR or LF line endings are converted to CR-LF pairs."

	| stream |
	stream := FileStream read: aString.
	[self fileInFrom: stream normalizeLineEndings: aBoolean] ensure: [stream close]!

fileInFrom: aStream
	"Private - File in the expressions/definitions from the chunk stream, aStream. in the
	receiver's chunk format. Any methods that do not compile are stubbed with instances of
	CompileFailedMethod and errors logged to the Transcript. Existing line endings are
	preserved, which is probably only appropriate if the source stream is known to have CR-LF
	line endings already."

	self fileInFrom: aStream normalizeLineEndings: false!

fileInFrom: aStream normalizeLineEndings: aBoolean
	(self chunkFilerOn: aStream)
		normalizeLineEndings: aBoolean;
		fileIn!

fileInHere: aFileName 
	"File in the chunk format file named, aFileName, into the system but with
	the working directory set to the location of the file. The original directory
	is restored on completion."

	| cwd |
	cwd := File workingDirectory.
	File workingDirectory: (File splitPathFrom: aFileName).
	[self fileIn: (File splitFilenameFrom: aFileName)] ensure: [File workingDirectory: cwd]!

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

logEvaluate: aString
	"Record aString to the change log as an expression which has been evaluated."

	self changesFiler 
		ifNotNil: [:logger | mutex critical: 
					[logger
						fileOutExpression: aString;
						flush]]!

onExit
	"Private - The system is about to exit, close the source files."

	self closeSources
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

	^SourceFiles lookup: (self sourceIndexFromDescriptor: sourceDescriptor)!

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

!SourceManager categoriesForMethods!
basicChangesFiler!accessing!private! !
basicOpenSources:!operations-source files!private! !
changePositionFromDescriptor:!private!source filing! !
changePositionOf:!development!private!testing! !
changesExtension!constants!private! !
changesFileName!accessing!public! !
changesFileNameFromPath:!public!source filing! !
changesFiler!accessing!private! !
changesFileSize!accessing!public! !
changesStream!accessing!private! !
chunkFilerOn:!accessing!public! !
closeChangesFile!operations-source files!private! !
closeSourceAt:!operations-source files!private! !
closeSources!operations-source files!private! !
closeSourcesFile!operations-source files!private! !
copySourceFilesTo:!operations-source files!private! !
errorNotPackaged:!exceptions!private! !
fileIn:!public!source filing! !
fileIn:normalizeLineEndings:!public!source filing! !
fileInFrom:!private!source filing! !
fileInFrom:normalizeLineEndings:!private!source filing! !
fileInHere:!public!source filing! !
fileInPackagedClass:!development!public!source filing! !
fileInPackagedClass:from:!public!source filing! !
fileItIn:!public!source filing! !
flushChanges!operations-source files!private! !
getSourceFromDescriptor:!public!source filing! !
getSourceOfMethod:!public!source filing! !
hasMethodChanged:!private!testing! !
hasSources!private!testing! !
ignoreSources!operations-source files!private! !
initialize!initializing!private! !
isMethodChanged:!development!private!testing! !
logEvaluate:!operations-logging!public! !
onExit!event handling!private! !
openChangesFile:!operations-source files!private! !
openNewChangesFile:!helpers!private! !
openSources!operations-source files!private! !
openSources:!operations-source files!private! !
openSourcesFile:!operations-source files!private! !
packageManager!accessing!must strip!private! !
sourceFileFromDescriptor:!private!source filing! !
sourceFilerClass!constants!public! !
sourceFilerOn:!helpers!public! !
sourceIndexFromDescriptor:!private!source filing! !
sourcesExtension!constants!private! !
sourcesFileName!accessing!public! !
sourcesFileNameFromPath:!private!source filing! !
sourcesFileStream!accessing!private! !
storeCommentString:forClass:!private!source filing! !
storeCommentString:forPackage:!private!source filing! !
storeGUIDForClass:!private!source filing! !
storeSourceString:forMethod:!private!source filing! !
truncateChanges!operations-source files!private! !
!

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

!SourceManager class categoriesForMethods!
default!accessing!public! !
default:!accessing!public! !
initialize!initializing!public! !
new!instance creation!public! !
newDefault!instance creation!public! !
reset!initializing!private! !
uninitialize!class hierarchy!class hierarchy-removing!private! !
!

