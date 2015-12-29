"Filed out from Dolphin Smalltalk X6.2"!

StsPackageProxy subclass: #StsDolphinPackageProxy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsDolphinPackageProxy guid: (GUID fromString: '{4A69289D-5FF5-4EA4-AEAC-D8E421117C11}')!
StsDolphinPackageProxy comment: ''!
!StsDolphinPackageProxy categoriesForClass!Unclassified! !
!StsDolphinPackageProxy methodsFor!

allResourceNames: anObject 
	!

basicComment: aString 
	comment := aString!

basicPackageVersion: aString 
	version := aString!

basicScriptAt: aKey put: script 
	self scripts at: aKey put: script!

binaryGlobalNames: anObject
!

classNames
	^OrderedCollection new!

existClassInChunk: aString 
	^aString = '"Classes"'!

fileInBinaryGlobals: filer 
	^filer nextChunk!

fileInClassDefinitions: filer 
	| chunk str classProxy |
	[filer atEnd or: [(chunk := filer nextChunk) first = $"]] whileFalse: 
			[str := chunk subStrings at: 3.
			classProxy := self findOrCreateClassNamed: (str copyFrom: 2 to: str size) asSymbol.
			classProxy definition: chunk].
	^chunk!

fileInFrom: aStream 
	| filer lastChunk chunk |
	classes := OrderedCollection new.
	looseMethods := OrderedCollection new.
	resources := OrderedCollection new.
	filer := ChunkSourceFiler on: aStream.
	lastChunk := filer nextChunk.
	
	[chunk := lastChunk = '"Class Definitions"' 
				ifTrue: [self fileInClassDefinitions: filer]
				ifFalse: 
					[lastChunk = '"Loose Methods"' 
						ifTrue: [self fileInLooseMethods: filer]
						ifFalse: 
							[lastChunk = '"Global Aliases"' 
								ifTrue: [self fileInGlobalAliases: filer]
								ifFalse: 
									[lastChunk = '"Source Globals"' 
										ifTrue: [self fileInSourceGlobals: filer]
										ifFalse: 
											[(lastChunk = '"End of package definition"' or: [lastChunk = '"Classes"']) 
												ifTrue: [self fileInMethodsAndComments: filer]
												ifFalse: 
													[lastChunk = '"Binary Globals"' 
														ifTrue: [self fileInBinaryGlobals: filer]
														ifFalse: 
															[lastChunk = '"Resources"' 
																ifTrue: [self fileInResources: filer]
																ifFalse: 
																	[(lastChunk beginsWith: '"') ifTrue: [self halt].
																	filer nextChunk]]]]]]].
	filer atEnd] 
			whileFalse: [lastChunk := chunk]!

fileInGlobalAliases: filer 
	^filer nextChunk!

fileInLooseMethods: filer 
	| chunk tokens classProxy |
	[filer atEnd or: [(chunk := filer nextChunk) beginsWith: '"']] whileFalse: 
			[chunk := filer nextChunk.	"Class methodsFor"
			tokens := chunk subStrings.
			classProxy := StsClassProxy new name: tokens first asSymbol.
			tokens size = 3 ifTrue: [classProxy := classProxy metaClass].	"Class class?"
			self fileInMethodsForClass: classProxy chunkFiler: filer.
			looseMethods addAll: classProxy methodDictionary values].
	^chunk!

fileInMethodsAndComments: filer 
	"first skip and ignore Dolphin 4.0 Globals - I know we shouldn't but globals are bad practice anyway..."

	| chunk tokens classProxy value classCategories |
	
	[(filer atEnd or: [(chunk := filer nextChunk) beginsWith: '"']) ifTrue: [^chunk].
	tokens := chunk subStrings.
	tokens size > 1 and: [(tokens at: 2) = 'comment:' or: [(tokens at: 2) = 'guid:']]] 
			whileFalse: [].
	
	[(tokens at: 2) = 'methodProtocol:' 
		ifTrue: 
			["ignore method protocols since they are not supported by STS"
			chunk := filer nextChunk]
		ifFalse: 
			["get class"
			classProxy := self classNamed: tokens first asSymbol.
			"set comment and guid"
			2 timesRepeat: 
					[value := Compiler evaluate: (chunk copyFrom: (chunk indexOf: $:) + 1 to: chunk size) logged: false.
					(tokens at: 2) = 'comment:' ifTrue: [classProxy comment: value] ifFalse: [classProxy guid: value].
					chunk := filer nextChunk.
					tokens := chunk subStrings].
			"get class category - currently not used in STS"
			chunk := filer nextChunk.
			classCategories := ''.
			[(chunk := filer nextChunk) notEmpty] whileTrue: [classCategories := classCategories , chunk , '!!'].
			"instance or class methodsFor"
			((chunk := filer nextChunk) beginsWith: '"') ifTrue: [^chunk].
			chunk isEmpty 
				ifTrue: 
					[chunk := filer nextChunk.
					tokens := chunk subStrings.
					self fileInMethodsForClass: (tokens size = 3 ifTrue: [classProxy metaClass] ifFalse: [classProxy])
						chunkFiler: filer.
					"class methodsFor"
					((chunk := filer nextChunk) beginsWith: '"') ifTrue: [^chunk].
					chunk isEmpty 
						ifTrue: 
							[chunk := filer nextChunk.
							tokens := chunk subStrings.
							self fileInMethodsForClass: (tokens size = 3 ifTrue: [classProxy metaClass] ifFalse: [classProxy])
								chunkFiler: filer.
							chunk := filer nextChunk]]].
	chunk beginsWith: '"'] 
			whileFalse: [tokens := chunk subStrings].
	^chunk!

fileInMethodsForClass: classProxy chunkFiler: filer 
	| chunk method numberOfMethods selector categories |
	numberOfMethods := 0.
	[(chunk := filer nextChunk) isEmpty] whileFalse: 
			[numberOfMethods := numberOfMethods + 1.
			method := (StsCompiledMethodProxy new)
						methodSource: chunk;
						methodClass: classProxy;
						isPrivate: false.
			classProxy methodDictionary at: method selector put: method].
	numberOfMethods timesRepeat: 
			[filer nextChunk.
			selector := filer nextChunk subStrings last.
			method := classProxy methodDictionary at: (selector copyFrom: 2 to: selector size) asSymbol.
			categories := ''.
			[(chunk := filer nextChunk) isEmpty] whileFalse: 
					[chunk = 'private' 
						ifTrue: [method isPrivate: true]
						ifFalse: [chunk = 'public' ifFalse: [categories := categories , chunk , '!!']]].
			method categoriesString: categories]!

fileInResources: filer 
	| chunk readStream classProxy resourceProxy |
	[filer atEnd or: [((chunk := filer nextChunk) beginsWith: '"') or: [chunk isEmpty]]] whileFalse: 
			[readStream := ReadStream on: chunk.
			readStream upToAll: 'class: '.
			classProxy := StsClassProxy new name: (readStream upTo: $ ) asSymbol.
			readStream upToAll: 'name: '.
			resourceProxy := (StsDolphinResourceProxy new)
						name: (Compiler evaluate: (readStream upTo: $)) logged: false);
						owningClass: classProxy.
			readStream upToAll: 'assign: '.
			resourceProxy resource: (Compiler evaluate: readStream upToEnd logged: false).
			resources add: resourceProxy].
	^chunk!

fileInSourceGlobals: filer 
	| chunk |
	[filer atEnd or: [self existClassInChunk: (chunk := filer nextChunk)]] whileFalse: 
			[| poolDictionary globalName |
			globalName := self sourceManager nextItem: (ReadStream on: chunk) timesRepeat: 3.
			poolDictionary := PoolConstantsDictionary new.
			
			[filer atEnd or: 
					[(self sourceManager nextItem: (ReadStream on: (chunk := filer nextChunk)) timesRepeat: 2) 
						= 'shrink']] 
					whileFalse: 
						[| chunkStream |
						chunkStream := ReadStream on: chunk.
						self sourceManager nextItem: chunkStream timesRepeat: 2.
						self sourceManager ignoreSeparators: chunkStream.
						poolDictionary at: (self sourceManager nextString: chunkStream)
							put: (self sourceManager nextItem: chunkStream timesRepeat: 3) asNumber].
			globalName isEmpty 
				ifFalse: [globals at: (globalName copyFrom: 2 to: globalName size) asSymbol put: poolDictionary]].
	^chunk!

globalAliases: anObject 
	!

globalFromName: aSymbol 
	^globals at: aSymbol!

imageStripperBytes: aByteArray 
	imageStripperBytes := aByteArray!

methodNames
	^OrderedCollection new!

paxVersion: anInteger 
	"Ignore"

	!

resourceNames
	^OrderedCollection new!

setManualPrerequisites: anArray 
	manualPrerequisites := anArray!

setPrerequisites: anIdentitySet 
	prerequisiteNames := anIdentitySet!

sourceManager
	^self class sourceManager! !
!StsDolphinPackageProxy categoriesFor: #allResourceNames:!public! !
!StsDolphinPackageProxy categoriesFor: #basicComment:!public! !
!StsDolphinPackageProxy categoriesFor: #basicPackageVersion:!public! !
!StsDolphinPackageProxy categoriesFor: #basicScriptAt:put:!public! !
!StsDolphinPackageProxy categoriesFor: #binaryGlobalNames:!public! !
!StsDolphinPackageProxy categoriesFor: #classNames!public! !
!StsDolphinPackageProxy categoriesFor: #existClassInChunk:!public! !
!StsDolphinPackageProxy categoriesFor: #fileInBinaryGlobals:!public! !
!StsDolphinPackageProxy categoriesFor: #fileInClassDefinitions:!public! !
!StsDolphinPackageProxy categoriesFor: #fileInFrom:!public! !
!StsDolphinPackageProxy categoriesFor: #fileInGlobalAliases:!public! !
!StsDolphinPackageProxy categoriesFor: #fileInLooseMethods:!public! !
!StsDolphinPackageProxy categoriesFor: #fileInMethodsAndComments:!public! !
!StsDolphinPackageProxy categoriesFor: #fileInMethodsForClass:chunkFiler:!public! !
!StsDolphinPackageProxy categoriesFor: #fileInResources:!public! !
!StsDolphinPackageProxy categoriesFor: #fileInSourceGlobals:!public! !
!StsDolphinPackageProxy categoriesFor: #globalAliases:!public! !
!StsDolphinPackageProxy categoriesFor: #globalFromName:!public! !
!StsDolphinPackageProxy categoriesFor: #imageStripperBytes:!public! !
!StsDolphinPackageProxy categoriesFor: #methodNames!public! !
!StsDolphinPackageProxy categoriesFor: #paxVersion:!public! !
!StsDolphinPackageProxy categoriesFor: #resourceNames!public! !
!StsDolphinPackageProxy categoriesFor: #setManualPrerequisites:!public! !
!StsDolphinPackageProxy categoriesFor: #setPrerequisites:!public! !
!StsDolphinPackageProxy categoriesFor: #sourceManager!public! !

!StsDolphinPackageProxy class methodsFor!

loadFrom: pathname 
	| stream package |
	((File splitExtensionFrom: pathname) sameAs: 'pac') 
		ifFalse: 
			[MessageBox 
				errorMsg: 'The selected Dolphin Smalltalk package has an invalid file format.
Only packages with extension .PAC can be imported into repository.'.
			^nil].
	stream := FileStream read: pathname text: false.
	
	[(STBInFiler peekForSignatureIn: stream) 
		ifTrue: 
			[MessageBox 
				errorMsg: 'This package was saved with a different version of the Dolphin VM(98.2).
The package can not be imported into repository. Please install the package first.'.
			^nil].
	stream beText.
	package := self readFrom: stream.
	package isNil 
		ifTrue: 
			[MessageBox errorMsg: 'Invalid package file, file can not be imported.'.
			^nil].
	package fileInFrom: stream] 
			ensure: [stream close].
	^package!

readFrom: pacStream 
	"Private - Answer a new instance of the receiver created from the .PAC (source 
		text) format representation in the <readableStream>, pacStream.

		Instead of creating an instance of Package make an instance of yourself."

	| chunk readStream writeStream line |
	chunk := (ChunkSourceFiler on: pacStream) nextChunk.
	readStream := ReadStream on: chunk.
	writeStream := WriteStream on: String new.
	[(line := readStream nextLine) beginsWith: 'package :='] whileFalse: 
			[writeStream
				nextPutAll: line;
				cr].
	writeStream
		nextPutAll: 'package := StsDolphinPackageProxy new';
		nextPutAll: (line copyFrom: 19 to: line size);
		cr.
	[readStream atEnd] whileFalse: [writeStream nextPut: readStream next].
	^Compiler evaluate: writeStream contents logged: false! !
!StsDolphinPackageProxy class categoriesFor: #loadFrom:!public! !
!StsDolphinPackageProxy class categoriesFor: #readFrom:!private! !

