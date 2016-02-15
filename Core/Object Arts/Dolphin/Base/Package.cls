"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Package
	instanceVariableNames: 'name packagePathname comment classNames methodNames globalNames prerequisiteNames events scripts doNotReuse imageStripperBytes aboutBlock packageVersion manualPrerequisites timestamp untracedGlobals'
	classVariableNames: '_Uncommitted ChangedIcon CheckTimestamps ClashSignal SourcePackageIcon UnsaveableSignal'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Package guid: (GUID fromString: '{87B4C4A6-026E-11D3-9FD7-00A0CC3E4A32}')!
Package comment: ''!
!Package categoriesForClass!Development! !
!Package methodsFor!

about
	"Displays an about screen for the receiver using the aboutBlock if any has been set."

	self aboutBlock notNil ifTrue: [
		self aboutBlock value: self ]!

aboutBlock
	"Answer the <monadicValuable> that will display an About screen
	or nil if there is none. The receiver is passed as the parameter."

	^aboutBlock
!

aboutBlock: aMonadicValuableOrNil
	"Set the <monadicValuable> that will display an About screen.  The receiver
	will be passed as the parameter to the valuable. 
	When a package is created it does not have an about operation set. 
	To set a default splash screen see #defaultAbout."

	aboutBlock := aMonadicValuableOrNil.
	self isChanged: true.

!

aboutBlockBytes: aByteArray
	"Private - Set the receiver's about block by rehydrating that in serialized
	form in the <ByteArray> argument."

	aboutBlock := Object fromBinaryStoreBytes: aByteArray

!

addClass: aClass
	"Add aClass to the list of classes owned by the receiver. A class can only be owned by
	a single package. Answer aClass."

	self manager addClass: aClass to: self.
	^aClass!

addGlobalNamed: globalName
	"Add the global object to those owned by the receiver. Answer anObject."

	self manager addGlobalNamed: globalName to: self.
	^globalName!

addLooseMethod: method 
	"Private - Add the <CompiledMethod>, method, to the set of loose methods
	owned by the receiver."

	self assert: [(self includesClass: method methodClass) not].
	self methodNames add: (self nameForMethod: method)!

addMethod: method
	"Add the <CompiledMethod>, method, to the list of methods owned by the receiver and
	answer that method. As this will involve moving the method from another package, this
	is a composite operation and we need to involve the package manager to avoid problems
	with issuing events while the package system is in an interim state."

	self manager addMethod: method to: self.
	^method!

addPackagedMethod: method 
	"Private - The <CompiledMethod> argument, which is owned indirectly by this package because
	it is a method of a class which is owned, is to be re-added to this package."

	self assert: [self includesClass: method methodClass].
	method methodClass methodChanged: method!

addResourceIdentifier: rid
	"Add the <ResourceIdentifier>, rid, to the list of resources owned by the
	receiver. Answer the argument."

	self manager addResourceIdentifier: rid to: self.
	^rid!

allDependentPackages
	"Answer a <collection> of the packages which are directly dependant on the receiver."

	^self manager allDependentPackagesOf: self visited: Set new!

allFileOutNames
	"Private - Answers an OrderedCollection of the source filenames for the receiver and all of its 
	contents when in PAX source mode. Note that the PAX filename is alway last in the collection."

	| answer |
	answer := OrderedCollection new.
	self allSourceObjectsDo: [:each | answer add: each fileOutName].
	^answer!

allMethods
	"Answer an <IdentitySet> of all the <CompiledMethod>s directly owned by
	the receiver or by owning the class in which it is situated."

	| answer |
	answer := IdentitySet new: (classNames size * 20).	"On average, about 10 methods per behaviour"
	self allMethodsDo: [:m | answer add: m].
	^answer!

allMethodsDo: operation
	"Private - Evaluate the <monadicValuable>, operation, for Answer an <IdentitySet> of all the <CompiledMethod>s 
	directly owned by the receiver or by owning the class in which it is situated."

	| loose |
	loose := self manager looseMethods.
	self behaviorsDo: 
			[:eachBehavior | 
			eachBehavior methodDictionary 
				do: [:eachMethod | (loose includesKey: eachMethod name) ifFalse: [operation value: eachMethod]]].

	"Finally evaluate the operation for all the package's own loose methods"
	self methods do: operation!

allPrerequisites
	"Private - Answer a collection of all the Packages objects which must be loaded in before the
	receiver may be loaded in."

	| answer immediatePrereqs |
	immediatePrereqs := self prerequisites asIdentitySet.
	answer := IdentitySet new.
	immediatePrereqs do: [:each | 
		(answer includes: each) ifFalse: [answer add: each; addAll: each allPrerequisites]].
	^answer!

allResourceIdentifiers
	"Answer a Set of all the ResourceIdentifiers directly owned by
	the receiver or by owning the class in which it is situated."

	| resources resourceMethods |
	resources := Set new.
	self classesDo: [:each | resources addAll: each resourceIdentifiers].
	resourceMethods := self methods 
				select: [:each | each selector beginsWith: ResourceIdentifier selectorPrefix].
	resourceMethods do: [:each | resources add: (ResourceIdentifier forMethod: each)].
	^resources!

allResourceNames
	"Answer a <Collection> of all the resource names directly owned by the receiver or by its owned classes."

	^self propertyAt: #allResourceNames ifAbsent: [^OrderedCollection new]!

allResourceNames: resources
	"Private - Record the <Collection> of <Associations>s, resources, as the names of all resources
	in this package. This information is recorded only temporarily during package loading, and later
	it is generated dynamically."

	self propertyAt: #allResourceNames put: resources!

allSourceObjects
	"Answer a <collection> containing the members of the receiver that can be filed out as 
	separate source files. These objects must respond to the <sourceObject> protocol. If the
	receiver is not the system package, then it is included as the last element of the collection.
	Currently we can externalize the receiver's PAX and it's classes, resources and 
	constant pools."

	| answer |
	answer := OrderedCollection new.
	self allSourceObjectsDo: [:each | answer add: each].
	^answer!

allSourceObjectsDo: operation 
	self classesDo: operation.
	self sourceGlobalVariables do: [:each | operation value: each value].
	"Note that the package itself is always enumerated last - this is important"
	operation value: self!

basicAddClass: aClass 
	"Private - Add aClass to the list of classes owned by the receiver. A class can only be owned by
	a single package. Answer aClass. Note that it is assumed that the class is _not_ currently
	packaged. To correctly add a class regardless of packaging use PackageManager>>addClass:to:"

	"ignore any methods of aClass which we own as they are included by our new ownership of aClass"
	| className |
	(self methods 
		select: [:aMethod | aMethod methodClass == aClass or: [aMethod methodClass == aClass class]]) 
			do: [:method | self removeLooseMethod: method].
	className := self nameForClass: aClass.
	classNames add: className.

	"Although the class hasn't changed in itself, it will need to be filed out to its new location, if using .PAX format"
	aClass isChanged: true.
	^aClass!

basicAddGlobalNamed: globalName
	"Private - Add the global object to those owned by the receiver. Answer anObject.
	 Note that it is assumed that the global is _not_ currently packaged. To 
	correctly add a class regardless of packaging use the PackageManager."

	| global names |
	names := self globalNames.
	names add: globalName.

	"The global's value has not changed, but it may now need filing out to a new location"
	global := self globalFromName: globalName.
	(self isSourceGlobal: global) ifTrue: [
		global isChanged: true].

	^globalName!

basicComment: aString
	"Private - Set the comment of the receiver."

	comment := aString!

basicPackageVersion: aString
	"Private - Sets the package version identification to aStringOrNil."

	packageVersion := (aString isNil or: [aString isEmpty]) ifFalse: [aString]!

basicRemoveClass: aClass
	"Private - Remove aClass from the list of Classes owned by the receiver.
	Answer aClass."

	classNames remove: (self nameForClass: aClass).
	^aClass!

basicRemoveGlobalNamed: globalName 
	"Private - Remove globalName from the list of globals owned by the receiver.
	Answer globalName."

	| names |
	names := self globalNames.
	names remove: globalName ifAbsent: [].
	names isEmpty ifTrue: [globalNames := nil].
	^globalName!

basicScriptAt: scriptSymbol put: aString 
	"Private - Set the script String associated with scriptSymbol."

	scripts := self scripts.
	aString isEmpty 
		ifTrue: 
			[scripts removeKey: scriptSymbol ifAbsent: [].
			scripts isEmpty ifTrue: [scripts := nil]]
		ifFalse: [scripts at: scriptSymbol put: aString]!

behaviorFromName: aString ifAbsent: exceptionHandler 
	| index |
	index := aString identityIndexOf: $ .
	^index == 0 
		ifTrue: [self classFromName: aString ifAbsent: exceptionHandler]
		ifFalse: 
			[(self classFromName: (aString leftString: index - 1) ifAbsent: []) 
				ifNil: [exceptionHandler value]
				ifNotNil: [:class | class class]]!

behaviors
	"Answer an <IdentitySet> of the <Behavior>s owned by the receiver."

	| answer |
	answer := IdentitySet new: (classNames size + 1) * 2. "Avoid need to grow set by presizing"
	self behaviorsDo: [:b | answer add: b].
	^answer!

behaviorsDo: operation
	"Evaluate the monadicValuable, operation, for each and every <Behavior> owned
	by the receiver."

	self classesDo: [:aClass | operation value: aClass; value: aClass class].
!

beNotUsingPAX
	"Place the receiver into a mode where it is not using PAX source files.
	This simply involves deleting any PAX source files that currently exist. Without the
	presence of a same named PAX file, the receiver assumes it is operating in
	non-PAX mode for all future save operations."

	| msg names |
	self isUsingPAX ifFalse: [^self].
	names := self allFileOutNames.
	msg := 'Placing this package into PAC mode will delete <2d> PAX source files in the<n>directory <3s>.<n><n>Are you sure that you wish to proceed?' 
				expandMacrosWith: self name
				with: names size
				with: self path.
	(MessageBox confirm: msg caption: ('Convert <1p> to PAC mode...' expandMacrosWith: self name)) 
		ifTrue: [names do: [:each | File delete: each]]!

beUsingPAX
	"Place the receiver into a mode where it is using PAX source files.
	This simply involves creating the PAX source files for the first time. With the
	presence of a same named PAX file, the receiver assumes it is operating in
	PAX mode for all future save operations."

	| msg |
	self isUsingPAX ifTrue: [^self].
	msg := 'Placing this package into PAX source mode will create <1d> source files<n>in the directory <2s>.<n><n>Are you sure that you wish to proceed?' 
				expandMacrosWith: self allSourceObjects size
				with: self path.
	(MessageBox confirm: msg caption: ('Convert <1p> to PAX mode...' expandMacrosWith: self name)) 
		ifTrue: [self fileOutAll]!

binaryGlobalNames
	"Private - Answer a <Collection> of <Symbol>s, being the names of all binary global variables
	in this package. This information is cached temporarily during package loading, and
	subsequently (after the package has been loaded) calculated."

	^self propertyAt: #binaryGlobalNames 
		ifAbsent: [self binaryGlobalVariables collect: [:var | var key]]!

binaryGlobalNames: globs
	"Private - Record the <Collection> of <Symbol>s, globs, as the names of all binary global variables
	in this package. This information is recorded only temporarily during package loading."

	self propertyAt: #binaryGlobalNames put: globs!

binaryGlobalVariables
	"Private - Answer the receiver's binary globals that can't be filed out as separate source 
	objects. Note that this _includes_ any aliases."

	^self globalVariables reject: [:e | self isSourceGlobal: e value]!

buildPrerequisiteNames
	"Private - Calculate the names of the receiver's prerequisite packages."

	| prereqs |
	prereqs := Set new.
	self calculatePrerequisites do:[:each | prereqs add: each name].
	self manualPrerequisites 
		do: [:each | (self manager packageNamed: each ifNone: []) notNil ifTrue: [prereqs add: each]].
	^prereqs!

calculatePrerequisites
	"Private - Answer an <IdentitySet? of the prerequisite <Package>s which have to be
	present before the receiver's objects may be successfully used. These packages may
	well need other packages to be loaded before they can operate."

	^self tracePrerequisites keys!

canFileOut
	"Answer true if the receiver can be filed out. At this stage we just check to ensure that
	all the file out names associated with the PAX file are writeable."

	^self fileOutNames allSatisfy: [:each | File isWriteable: each]!

canShowAbout
	"Answer true if we can show an about box for the receiver, i.e. we have an aboutBlock"

	^self aboutBlock notNil!

changedFrom: aMonadicValuable 
	"Set the changed flag for the receiver to aBoolean"

	self isChanged ifTrue: [^self].
	self changeIndexValue: aMonadicValuable.
	self trigger: #changed!

changeIndex
	^self propertyAt: #changeIndex ifAbsent: []!

changeIndexValue: aBlock 
	self propertyManager 
		propertyOf: self
		at: #changeIndex
		ifAbsentPut: aBlock!

checkTimestamps
	"Compare the timestamp cached when the package was installed against the timestamp of the
	package file. If the package file has been modified since the package was loaded, then warn
	the user to avoid inadvertent overwrites of later package versions causing loss of changes."

	(CheckTimestamps and: [self isRenegade]) ifFalse: [^self].
	Warning 
		signal: ('The package <1s> has been modified outside this image since it was loaded or last saved.

	Package timestamp:	<2s>
	File modification time:	<3s>

If you proceed and save it from this image then you may lose changes that have been made in another image. It is recommended that before proceeding you first take a backup copy of the current version on disk, or that you abort this operation.' 
				expandMacrosWith: self name
				with: self timestamp displayString
				with: (FILETIME fromInteger: self fileModificationTime) displayString)

!

classDefinitionsFileName
	"Private - Answer a filename to use for filing out the class definitions of the receiver.
	Note this is only relevant if the receiver is a system package."

	^File composePath: self path stem: self name, 'Classes' extension: 'st'.!

classes
	"Answer a Set of the Classes owned by the receiver."

	^classNames collect: [:className | self classFromName: className]!

classesDo: operation 
	"Evaluate the <monadicValuable>, operation, for each of the classes 
	owned by the receiver. Note that this does not include the classes of
	the receiver's loose methods."

	^classNames do: [:each | operation value: (self classFromName: each)]!

classesInHierarchyOrder
	"Private - Answer an <sequencedReadableCollection> of the
	receiver's ownded classes in the order that they would be
	visited by a depth-first traversal of the class hierarchy."

	^self hierarchyOrderOfClasses: self classes!

classFromName: className
	"Private - Answer the Class object which className encodes.

	See Package>>nameForClass: for the reverse transformation."

	^self environment at: className!

classFromName: className ifAbsent: exceptionHandler
	"Private - Answer the Class object which className encodes.

	See Package>>nameForClass: for the reverse transformation."

	^self environment at: className ifAbsent: exceptionHandler!

classNames
	"Answer an <Set> of <Symbol>s naming all the classes owned by the receiver."

	^classNames!

comment
	"Answer the comment String of the receiver"

	^comment 
		ifNil: ['']
		ifNotNil: 
			[comment isInteger 
				ifTrue: [String readFrom: (self sourceManager getSourceFromDescriptor: comment) readStream]
				ifFalse: [comment]]!

comment: aString 
	"Set the comment of the receiver, and flag as changed."

	self basicComment: aString.
	self storeComment.
	self isChanged: true!

createPackagePath
	"Private - Create the directory where the receiver resides on disk"

	File createDirectoryPath: (File splitPathFrom: self fileOutName)
!

declareClasses
	"Private - Predefine global variables for each of the classes in the package prior to those classes
	being loaded. Only required for PAX (not PAC) loading"

	self classNames do: 
			[:each | 
			Object 
				subclass: each asSymbol
				instanceVariableNames: ''
				classVariableNames: ''
				poolDictionaries: '']!

declareGlobals
	"Private - Define global variables for each of the globals in the package prior to those globals
	being loaded. Later (after the classes in the package have been defined - in case the globals are 
	instances of any of those classes) these will be loaded from their individual STB files."

	self globalNames do: [:each | self environment at: each put: nil]!

dependentPackages
	"Answer a <collection> of the packages which are directly dependant on the receiver."

	^self manager dependentPackagesOf: self!

depthOfClass: aClass 
	| depth class |
	depth := 0.
	class := aClass.
	[class superclass isNil] whileFalse: [
		class := class superclass.
		depth := depth + 1].
	^depth!

displayOn: aStream
	"Append a representation of the receiver to aStream which is suitable for display to the end user."

	aStream nextPutAll: self name!

dotPacPath
	^File path: self packageFileName extension: self class packageExtension!

endClassDefinitionsMarker
	"Private - Answer a String marker used to indicate the end of the
	class definitions section in a legacy (pre 4.0) package file."

	^'end-class-definition'!

environment
	"Private - Answer the global name associated with the receiver."

	^Smalltalk!

errorFileCorrupt
	"Private - Filing in the receivers owned objects has failed because the
	file is corrupt."

	self error: 'FileIn of ', self name, ' package has failed, file is corrupt'!

fileInClassDefinitions: aFileStream 
	"Private - Load all package classes from the filestream up to the end marker.
	Note that this is only used for loading binary legacy (pre 4.0) packages."

	| filer |
	aFileStream beText.
	filer := ChunkSourceFiler on: aFileStream.
	
	[filer atEnd ifTrue: [^self errorFileCorrupt].
	(Compiler evaluate: filer nextChunk logged: true) = 'end-class-definition'] 
			whileFalse.
	aFileStream skipSeparators.
	aFileStream next ~= $X ifTrue: [^self errorFileCorrupt].
	aFileStream beBinary!

fileInClasses
	"Private - Load all packaged classes from external files"

	self classesInHierarchyOrder do: [:each | self sourceManager fileIn: each fileOutName]!

fileInScript: aSymbol 
	"Private - 'File in' the named script."

	| filer |
	filer := self sourceManager chunkFilerOn: (self scriptAt: aSymbol) readStream.
	filer evaluationContext: self.
	[filer fileIn] on: Compiler errorClass
		do: 
			[:x | 
			| msg |
			msg := 'Error: Script for <1p> at line <2d>: <3d>' 
						expandMacrosWith: aSymbol
						with: x line
						with: (x _descriptionArguments at: 5).
			Notification signal: msg.
			x
				beep;
				resume]!

fileLocator
	^PackageRelativeFileLocator package: self!

fileModificationTime
	"Private - Answer the modification time of the receiver's package file on disk as the
	<integer> number of 100-nanosecond intervals since 12:00 A.M. January 1, 1601 UTC (i.e. a
	Win32 FILETIME), or 0 if it does not currently exist."

	| fileName |
	fileName := self isSystemPackage 
				ifTrue: [self classDefinitionsFileName]
				ifFalse: [self isUsingPAX ifTrue: [self fileOutName] ifFalse: [self packageFileName]].
	^(File lastWriteTime: fileName) ifNil: [0] ifNotNil: [:filetime | filetime asInteger]!

fileNameForBinaryGlobal: globalName
	"Private - Answer a filename for storing the binary globalName."

	^File composePath: self path stem: globalName extension: self class binaryGlobalExtension
!

fileNameForSourceGlobal: globalName
	"Private - Answer a filename for storing the source globalObject."

	^File composePath: self path stem: globalName extension: self class sourceGlobalExtension
!

fileOut
	"Private - File out a definition of the receiver to source files. Normally this
	involves saving a PAX file except in the case where the receiver is a system package
	when separate class and resource definitions files are saved instead."

	self isSystemPackage 
		ifFalse: 
			[self
				savePAC;
				savePAX;
				versionIfRequired]
		ifTrue: [self fileOutBootDefinitions].
	self updateTimestamp.
	self isChanged: false!

fileOutAll
	"Fileout the receiver to a PAX file and all out it's associated source files.
	The .PAC file is also saved when the .PAX is created in order to ensure that
	the two remain in sync."

	self allSourceObjectsDo: [:each | each fileOut]!

fileOutAllChanged
	"Fileout the changed source objects in the receiver"

	self allSourceObjectsDo: [:each | each isChanged ifTrue: [each fileOut]]!

fileOutAllOn: aSourceFiler 
	self fileOutOn: aSourceFiler.
	self
		fileOutSourceGlobalsOn: aSourceFiler;
		fileOutClassesOn: aSourceFiler;
		fileOutBinaryGlobalsOn: aSourceFiler
!

fileOutBinaryGlobals
	"Private - File out binary globals to individual .STB files.
	This is used in the multi-file .PAX format to avoid binary merge conflicts in the
	main PAX."

	(self binaryGlobalVariables - self globalAliasVariables) do: [:var | | globalStream |
		globalStream := FileStream write: (self fileNameForBinaryGlobal: var key) text: false.
		var value binaryStoreOn: globalStream.
		globalStream close].

!

fileOutBinaryGlobalsOn: aSourceFiler 
	"Private - File out the binary representation of the receiver's non-<sourceObject> 
	globals onto the <SourceFiler> argument. Binary globals are saved as the literal 
	representation of their #binaryStoreBytes.  This is used in the single-file .PAC format."

	aSourceFiler 
		emitComment: 'Binary Globals';
		cr.
	(self binaryGlobalVariables asSortedCollection: self variableSortBlock) 
		do: [:var | aSourceFiler fileOutBinaryGlobal: var; cr]!

fileOutBootDefinitions
	"Private - If this is a system package then only write out .st files capable of defining
	the classes independently of the PAX. These are required by the Dolphin boot process.
	Note that the base system package cannot contain any resources."

	| filer |
	filer := ChunkSourceFiler 
				on: (FileStream write: self classDefinitionsFileName text: true).
	[self fileOutClassDefinitionsOn: filer] ensure: [filer close]!

fileOutClassDefinitionsOn: aSourceFiler 
	"Private - Append the text definitions of the receivers owned classes to aFileStream.
	This should produce the minimal amount of information to create a new class when 
	loaded in (i.e. only the basic definitions are emitted)."

	aSourceFiler
		emitComment: 'Class Definitions';
		cr.
	self classesInHierarchyOrder 
		do: [:aClass | aSourceFiler fileOutBasicDefinitionOfClass: aClass].
	aSourceFiler cr!

fileOutClassesOn: aSourceFiler 
	"Private - Append definitions of all the classes owned by the
	receiver to the <SourceFiler>, aSourceFiler.
	Note that the classes are filed out in class hierarchy order to 
	avoid creating forward references and to create a consistently
	ordered source file that can be effectively diff'd."

	aSourceFiler
		emitComment: 'Classes';
		cr.
	self classesInHierarchyOrder do: 
			[:aClass | 
			aSourceFiler fileOutAttributesOfClass: aClass.
			self fileOutMethodsOfClass: aClass on: aSourceFiler.
			self fileOutMethodsOfClass: aClass class on: aSourceFiler]!

fileOutGlobalAliasesOn: aSourceFiler 
	"Private - File out the text representation of the receiver's global aliases onto the
	<puttableStream>, stream."

	aSourceFiler
		emitComment: 'Global Aliases';
		cr.
	(self globalAliasVariables asSortedCollection: self variableSortBlock) 
		do: [:var | aSourceFiler fileOutExpression: var key , ' := ' , var value name].
	aSourceFiler cr!

fileOutLooseMethodsOn: aSourceFiler 
	"Private - File out the loose methods owned by the receiver to the <SourceFiler> argument."

	aSourceFiler
		emitComment: 'Loose Methods';
		cr.
	aSourceFiler fileOutMethods: self methods!

fileOutMethodsOfClass: aClass on: aSourceFiler 
	"Private - Append any definitions of the classes methods which
	are not owned by another package to the <puttableStream>, target."

	| methods |
	methods := self methodsOfClass: aClass.
	methods size = aClass methodDictionary size 
		ifTrue: 
			["The common case is that all methods of the class also belong to the this package..."

			aSourceFiler fileOutAllMethodsOfBehavior: aClass]
		ifFalse: 
			["...but if some methods are not owned by this package we have more work to do"

			| selectors prereqs addBlock |
			selectors := methods collect: [:m | m selector].
			aSourceFiler fileOutMessages: selectors ofBehavior: aClass.

			"File out the intersection of the immediate protocols of the class and those of this
			and prerequisite packages' methods"

			"First add all selectors in the superclass chain which are in this package or one of its
			pre-requisites into the set of available selectors."
			prereqs := self prerequisites.
			addBlock := 
					[:e :p | 
					selectors addAll: ((p methodsOfClass: e) collect: [:m | m selector])].
			prereqs do: [:p | addBlock value: aClass value: p].
			aClass allSuperclassesDo: 
					[:e | 
					addBlock value: e value: self.
					prereqs do: [:p | addBlock value: e value: p]].
			#todo.	"File out partial protocols, although tools should prevent protocols being split across packages really"
			aSourceFiler fileOutProtocols: (aClass protocols 
						select: [:p | (p selectors difference: selectors) isEmpty])
				ofBehavior: aClass]!

fileOutName
	"Answer the pathname used to store the PAX file for the sources of the receiver"

	^File composePath: self path stem: self name extension: self class sourcePackageExtension!

fileOutNames
	"Private - Answers a set of the source filenames for the receiver when in the multi-file
	(.PAX) source mode. This contains pathnames used to store the PAX file and each of the
	binary globals, etc. It does not include the source files for the	<sourceObject>s held by the 
	receiver."
	
	^self isSystemPackage 
		ifTrue: [Set with: self classDefinitionsFileName]
		ifFalse: [
			Set new 
				add: self fileOutName;
				addAll: (self binaryGlobalNames collect: [:each | self fileNameForBinaryGlobal: each]);
				yourself]!

fileOutOn: aSourceFiler
	"Append the definition of the receiver in PAX format onto the
	<SourceFiler> argument. This does not file out the source files of the 
	receiver's contents."

	self savePAXChunkOn: aSourceFiler.
	self fileOutClassDefinitionsOn: aSourceFiler.
	self fileOutGlobalAliasesOn: aSourceFiler.
	self fileOutLooseMethodsOn: aSourceFiler.
	aSourceFiler
		emitComment: 'End of package definition';
		cr!

fileOutSourceGlobalsOn: aSourceFiler 
	"Private - File out the text representation of the receiver's globals onto the
	<puttableStream>, stream. This is used in the single-file .PAC format."

	aSourceFiler
		emitComment: 'Source Globals';
		cr.
	(self sourceGlobalVariables asSortedCollection: self variableSortBlock) do: 
			[:var | 
			var value fileOutOn: aSourceFiler.
			aSourceFiler cr]!

getEvents
	"Private - Answer the EventsCollection belonging to the receiver, or nil if the receiver
	has no events registered for it"

	^events!

getPrerequisites
	"Private - Answer a collection of <Package>s that must be loaded before the
	receiver can be loaded. Note that this differs from #prerequisites in that it will
	trace the prerequisites of the system package (which is slow)."

	(prerequisiteNames isNil and: [self isSystemPackage]) 
		ifTrue: [prerequisiteNames := self buildPrerequisiteNames].
	^self prerequisites!

globalAliases
	"Private - Answer a <collection> of <Symbol>s, being the names of global 
	variables owned by the receiver that are just aliases to other globals."

	^self propertyAt: #globalAliases
		ifAbsent: [self globalAliasVariables collect: [:var | var key]]!

globalAliases: aliases
	"Private - Record the <Collection> of <Symbol>s, globs, as the names of all global variables
	owned by this package which are just aliases for other globals. This information is recorded only 
	temporarily during package loading and is subsequently calculated."

	self propertyAt: #globalAliases put: aliases!

globalAliasVariables
	"Private - Answer a <collection> of <Association>s, being the global variables owned
	by the receiver that are just aliases to classes."

	^self globalVariables select: [:var | self isGlobalAlias: var]!

globalFromName: globalName
	"Private - Answer the global Object which globalName encodes.

	See Package>>nameForGlobal: for the reverse transformation."

	^self environment at: globalName!

globalNameOfLiteral: anObject 
	"Private - Answer the global name of the argument, anObject, extracted from a CompiledMethods
	literal frame, or nil if it is not a global."

	^(anObject isKindOf: VariableBinding) 
		ifTrue: 
			[| key |
			key := anObject key.
			self environment associationAt: key ifPresent: [:v | v == anObject ifTrue: [key]]]
		ifFalse: 
			[(anObject isKindOf: Class) 
				ifTrue: 
					[| key |
					key := anObject name.
					(self environment includesKey: key) ifTrue: [key]]]!

globalNames
	"Answer an <Set> of <Symbol>s,  naming all global objects
	(including pools but excluding classes) owned by the receiver."

	^globalNames ifNil: [globalNames := IdentitySet new]!

globals
	"Private - Answer a set of the non-class globals in the receiver."

	^self globalVariables collect: [:a | a value]
!

globalVariables
	"Private - Answer a <collection> of <Association>s, being the receiver's global variables."

	^self globalNames collect: [:each | self environment associationAt: each ifAbsent: [each->nil]]!

hasCyclicPrerequisites
	"Private - Answer whether any of the receivers prerequisites or their
	prerequisites are cyclic. So two packages rely on each other to be
	loaded before they can be loaded. The package system does not currently
	handle this smoothly though it is possible to load in such a thing by
	repeatedly trying to load in all packages until it works..."

	^self hasCyclicPrerequisites: IdentitySet new!

hasCyclicPrerequisites: trail
	"Private - Walk the package pre-requisite net looking for a cyclic dependency.
	The <collection> trail includes all those packages already visited. If we find
	a duplicate package on the path then we know a cycle exists."

	| answer |
	trail add: self.
	answer := self prerequisites anySatisfy: [:prereq | 
				(trail includes: prereq) or: [prereq hasCyclicPrerequisites: trail]].
	trail remove: self.
	^answer!

hasImageStripper
	^imageStripperBytes notNil and: [self imageStripper notNil]!

hasUncommittedPrerequisites
	"Private - Answer whether any of the receivers prerequisites or their
	prerequisites are current uncomitted. If so the package should not be saved
	as it will not be reloadable into an image without the uncommitted objects.
	N.B. This method will go infinitely recursive if the package has cyclic
	pre-requisites as it does not maintain a visit list. It should therefore
	be called only after hasCyclicPrerequisites has returned false."

	^self prerequisites anySatisfy: [:prereq | 
		prereq == _Uncommitted or: [prereq hasUncommittedPrerequisites]]!

hierarchyOrderOfClasses: aCollection 
	"Private - Answer an OrderedCollection of all the Classes owned
	by the receiver intersected with the collection in classes. 
	The classes are ordered by their depth in the class hierarchy, with Object
	being first if it is owned by the receiver."

	^self environment allClasses intersection: aCollection!

imageStripper
	"Answer an image stripper for the receiver, or nil ImageStripper class is not present.
	Since we have to be able to load the receiver into images that do no necessarily have the 
	ImageStripper class installed, we hold the stripper as a binary filed out ByteArray in imageStripperBytes.
	We reconstitute this here."

	^self environment at: #ImageStripper
		ifPresent: [:stripperClass | self rehydrateImageStripper: stripperClass]!

imageStripper: anImageStripper 
	"Set the image stripper for the receiver to anImageStripper. 
	Since we have to be able to load the receiver into images that do no necessarily 
	have the ImageStripper class installed, we hold the stripper as a binary filed out ByteArray 
	in imageStripperBytes"

	| newBytes |
	newBytes := anImageStripper isNil ifFalse: [anImageStripper binaryStoreBytes].
	imageStripperBytes = newBytes ifTrue: [^self].
	self imageStripperBytes: newBytes.
	self isChanged: true!

imageStripperBytes
	^imageStripperBytes!

imageStripperBytes: aByteArray
	"Private - Set the image stripper bytes for the receiver to aByteArray."

	imageStripperBytes := aByteArray.

!

includesClass: aClass 
	"Answer whether the receiver owns aClass. aClass's metaclass is
	automatically owned as well."

	^(classNames includes: (self nameForClass: aClass instanceClass)) 
		and: [(self isImportedClass: aClass) not]!

includesGlobalNamed: globalName
	"Answer whether the receiver owns the global named globalName."

	^self globalNames includes: globalName!

includesMethod: aCompiledMethod 
	"Answer whether the receiver owns aMethod."

	^methodNames notNil and: 
			[(self isImportedClass: aCompiledMethod methodClass) not 
				and: [methodNames includes: (self nameForMethod: aCompiledMethod)]]!

includesResourceIdentifier: aResourceIdentifier 
	"Private - Answer whether the receiver directly owns aResourceIdentifier.
	Implementation Note: Avoid the lookup in the table of imported classes if
	possible, as that is a relatively expensive operation."

	^aResourceIdentifier owningPackage == self 
		and: [(self isImportedClass: aResourceIdentifier owningClass) not]!

initialize
	"Private - Initialize the state of the receiver."

	classNames := IdentitySet new.
	timestamp := 0!

initializeClasses
	"Private - Initialize all loaded classes."

	self classesInHierarchyOrder do: [:aClass | aClass initializeAfterLoad]!

initializeGlobals
	"Private - Initialize all globals (including classes) that require it."

	self initializeClasses.
	self globals 
		do: [:each | (each respondsTo: #initializeAfterLoad) ifTrue: [each initializeAfterLoad]].
	self globalAliasVariables 
		do: [:each | each value class isMeta ifTrue: [ClassLocator addAlias: each key forClass: each value]]!

initializeOldSourcePackage
	(self respondsTo: #loadLegacyResources) 
		ifTrue: [self perform: #loadLegacyResources]
		ifFalse: [self error: 'Unable to load package (Legacy package importer is not loaded)']	"Initialize old style (pre D6) binary resources"!

isBaseImagePackage
	"Answer true if the receiver is a basic component of Dolphin "

	#deprecated.

	^self isBasePackage!

isBasePackage
	"Answer true if the receiver is a basic component of Dolphin. This is usually an indication that
	it was present at the time the image was booted and may be used as a hint that
	you may not need to version the package into an external repository such as STS."

	^self class manager basePackages includes: self!

isChanged
	"Answer true if the receiver or any of it's contents have been changed since
	their changed flag was last reset."

	^self changeIndex notNil!

isChanged: aBoolean 
	"Set the changed flag for the receiver to aBoolean"

	self isChanged = aBoolean ifTrue: [^self].
	aBoolean 
		ifTrue: [self changeIndexValue: [Package sourceManager changesFileSize]]
		ifFalse: [self removePropertyAt: #changeIndex ifAbsent: []].
	self trigger: #changed!

isDefaultPackage
	"Answer whether the receiver is the default package to which all newly defined
	classes and methods are added."

	^self manager defaultPackage == self!

isGlobalAlias: anAssociation 
	| glob |
	glob := anAssociation value.
	^(self isSourceGlobal: glob) and: [anAssociation key ~= glob name]!

isImportedClass: aClass
	"Private - Answer true if aClass is an imported binary class"

	^ClassLocator importedClasses identityIncludes: aClass!

isInstalled
	"Answer whether the receiver is currently installed in the system."

	^self manager includesPackage: self!

isRenegade
	"Answer whether the receiver was loaded (or last saved) before its source representation in the file system.
	An example of where a package might be a renegade is if it has been modified and saved from another image."

	| lastWriteTime |
	lastWriteTime := self fileModificationTime.
	^lastWriteTime > timestamp!

isSourceGlobal: aGlobal
	"Private - Answer true if aGlobal can be filed out as an external source file"

	^aGlobal class conformsToProtocol: #sourceObject
!

isSystemPackage
	"Answer whether the receiver is the system package"

	^self manager systemPackage == self!

isUsingPAX
	"Answer true if the receiver is using PAX mode. If a PAX file of the same name as the
	receiver exists on disk then both PAC and PAX files are saved simultaneously."

	^self isSystemPackage or: [File exists: self fileOutName]!

isUsingPAX: aBoolean
	"Place the receiver into a mode where it is using PAX source format according to aBoolean."

	self assert: [self isSystemPackage not].
	aBoolean 
		ifTrue: [ self beUsingPAX ]
		ifFalse: [ self beNotUsingPAX ]!

load
	"Private - Load all the objects owned by the receiver. This assumes that all prerequisite
	packages are currently loaded in."

	((File splitExtensionFrom: self packageFileName) sameAs: self class sourcePackageExtension) 
		ifTrue: [self loadPAX]
		ifFalse: [self loadPAC].
	self removePAXProperties.
	self synchronizeNames.
	self upateFileNames!

loadBinaryGlobals
	"Private - Load each of the receiver's binary globals from their individual STB files."

	self binaryGlobalNames do: [:each | | globalStream |
		globalStream := FileStream read: (self fileNameForBinaryGlobal: each) text: false.
		self environment at: each put: (Object binaryReadFrom: globalStream).
		globalStream close]!

loadPAC
	"Private - Load all the objects owned by the receiver. This assumes that all prerequisite
	packages are currently loaded."

	| filename stream |
	filename := self packageFileName.
	Notification signal: ('Loading package <1p> from: <2s>' expandMacrosWith: self name with: filename).
	stream := FileStream read: filename text: false.
	timestamp := stream file lastWriteTime asInteger.
	
	[(STBInFiler peekForSignatureIn: stream) 
		ifTrue: 
			[stream reset.
			self loadLegacyPAC: stream]
		ifFalse: 
			[stream beText.
			self loadPAC: stream]] 
			ensure: [stream close]!

loadPAC: stream 
	"Private - Load a chunked source text .PAC from the <readableStream>, stream."

	| filer |
	filer := ChunkSourceFiler on: stream.

	"Skip the first chunk since it represents the receiver."
	filer nextChunk.
	self fileInScript: #preinstall.

	"Must declare the globals before filing in any code"
	self declareGlobals.

	"File in the definitions of the package's members (pools, classes, methods, globals, resources, etc)"
	filer fileIn.
	self paxVersion < 1 ifTrue: [self initializeOldSourcePackage].
	self initializeGlobals.
	self fileInScript: #postinstall!

loadPAX
	"Private - Load all the objects owned by the receiver. This assumes that all prerequisite
	packages are currently loaded in."

	| filename filer stream |
	filename := self packageFileName.
	Notification 
		signal: ('Loading source package <1p> from: <2s>' expandMacrosWith: self name with: filename).
	stream := FileStream read: filename.
	timestamp := stream file lastWriteTime asInteger.
	filer := ChunkSourceFiler on: stream.
	
	[filer nextChunk.	"Skip the first chunk since it represents the receiver."
	self fileInScript: #preinstall.

	"Define any globals that might be referenced from source code, but don't load them as yet as they
		 may be instances of one of the classes in the package."
	self declareGlobals.

	"Forward reference any classes just in case they are required by the globals that are just about to be loaded"
	self declareClasses.

	"Load source globals"
	self globalNames - (self propertyAt: #binaryGlobalNames ifAbsent: [#()]) 
		- (self propertyAt: #globalAliases ifAbsent: [#()]) 
			do: [:each | self sourceManager fileIn: (self fileNameForSourceGlobal: each)].

	"Load class definitions, aliases, and loose methods from the remainder of the PAX file"
	filer fileIn.
	self fileInClasses.
	self loadBinaryGlobals.
	self initializeGlobals.
	self paxVersion < 1 
		ifTrue: 
			["Initialize old style (pre D6) binary resources"
			self initializeOldSourcePackage].
	self fileInScript: #postinstall] 
			ensure: [filer close]!

manager
	"Answer the object responsible for managing this package."

	^self class manager!

manualPrerequisites
	"Answer the <collection> of manually specified pre-requisite package names for the receiver.
	Normally pre-requisites are calculated automatically, but in certain instances (such as method-only
	packages) the pre-requisite tracing mechanism doesn't find the dependency, so this collection
	is provided to permit the user to specify any additional pre-requisites. At present the collection
	must be maintained by inspecting the properties of the package."

	^manualPrerequisites isNil 
		ifTrue: [OrderedCollection new]
		ifFalse: [manualPrerequisites asOrderedCollection]!

manualPrerequisites: aCollectionOfStrings 
	"Set the <collection> of manually specified pre-requisite package names for the receiver."

	| newPrereqs |
	newPrereqs := aCollectionOfStrings notEmpty 
				ifTrue: [aCollectionOfStrings asSortedCollection asArray copyWithout: self name].
	newPrereqs = manualPrerequisites ifTrue: [^self].
	manualPrerequisites := newPrereqs.
	self isChanged: true.
	self resetPrerequisites!

membershipChanged
	^self membershipChangedAt: [Package sourceManager changesFileSize]!

membershipChangedAt: aNiladicValuable 
	"Private - The receiver's membership has changed, and its immediate pre-requisites may have 
	changed as a result."

	self memberUpdatedAt: aNiladicValuable.
	self trigger: #ownedChanged!

memberUpdatedAt: aBlockClosure 
	"Private - The receiver, or an object owned by the receiver has been updated.
	Mark the receiver as changed, and reset pre-requisites just in case there is any 
	effect on those, but do not trigger an #ownedChanged event."

	self resetPrerequisites.
	self changedFrom: aBlockClosure!

methodFromName: methodName ifAbsent: exceptionHandler 
	"Private - Answer the <CompiledMethod> object which the <Association> argument encodes.
	There is some messing around to handle class methods. If there is no such method, then
	answer the value of evaluating the <niladicValuable>, exceptionHandler.

	See Package>>nameForMethod: for the reverse transformation."

	^(self behaviorFromName: methodName key ifAbsent: []) 
		ifNil: [exceptionHandler value]
		ifNotNil: [:methodClass | methodClass compiledMethodAt: methodName value asSymbol ifAbsent: exceptionHandler]!

methodNames
	"Answer a <Set> of <Association>s, naming the methods owned by the
	receiver. Note that this only includes loose methods that extend classes in other 
	packages, not the name of methods defined in classes owned by this package."

	^methodNames ifNil: [methodNames := PluggableSet searchPolicy: AssociationSearchPolicy current]!

methods
	"Answer an <IdentitySet> of the <CompiledMethod>s owned by the receiver."

	| newIdentitySet names |
	names := self methodNames.
	newIdentitySet := IdentitySet new: names size.
	names do: [:methodName | newIdentitySet add: (self methodFromName: methodName ifAbsent: [])].
	^newIdentitySet!

methodsOfClass: aClass
	"Answer a Collection of the methods of aClass which the receiver either
	directly owns (as loose methods) or through owning aClass."

	^(self includesClass: aClass) 
		ifTrue: 
			["A neat way to express this would be:
				aClass methodDictionary asIdentitySet difference: self class manager looseMethods
			but unfortunately performance is critical here, and we can double the speed as follows:"

			| owned loose all |
			all := aClass methodDictionary.
			owned := IdentitySet new: all size.
			loose := self manager looseMethods.
			all do: [:each | (loose includesKey: each name) ifFalse: [owned add: each]].
			owned]
		ifFalse: 
			["Just pick out any loose methods we own in the class"

			self methods select: [:aMethod | aMethod methodClass == aClass]]!

name
	"Answer the name of the receiver. This must always be the same as the stem of the package's
	file name, and must be unique amongst all loaded packages in the system."

	^name!

nameForClass: aClass
	"Private - Answer a String name suitable for adding to the receivers classNames.
	See: Package>>classFromName for the reverse transformation.
	Implementation Note: As of package binary file version 1, we store the class names
	as Symbols to avoid wasting space."

	^aClass name!

nameForMethod: aMethod
	"Private - Answer an Association of the method class name String -> methods selector Symbol.
	See: Package>>methodFromName for the reverse transformation."

	^self class nameForMethod: aMethod!

nameForResourceIdentifier: aResourceIdentifier
	"Private - Answer an <Association> that uniquely identifies the <ResourceIdentifier> argument."

	^aResourceIdentifier owningClass name -> aResourceIdentifier name!

okToSaveOrDeploy
	"Private - Prior to saving or deploying the receiver, check that all is consistent and answer whether the
	receiver should be saved. Raise Errors that describe any problems."

	self isSystemPackage ifTrue: [^false].
	self hasCyclicPrerequisites 
		ifTrue: 
			[self class unsaveableSignal 
				signal: ('The package <1p> has cyclic prerequisites.' expandMacrosWith: self name).
			^false].

	"N.B. This must be done after the above, as it will go infinitely recursive if there are cycles."
	self hasUncommittedPrerequisites 
		ifTrue: 
			[self class unsaveableSignal 
				signal: ('The package <1p> has prerequisites which are not currently assigned to any other package, or it is dependent on other packages which in turn have uncommitted prerequisites.' 
						expandMacrosWith: self name).
			^false].
	self validate.
	^true!

okToUninstall
	"Private - Validate that the receiver can be uninstalled. 
	Raise Errors that describe any problems. Answer whether
	OK to proceed."

	self isSystemPackage 
		ifTrue: 
			[Error signal: 'The base system package cannot be uninstalled'.
			^false].
	self hasCyclicPrerequisites 
		ifTrue: 
			[Error signal: ('The package <1p> has cyclic prerequisites and cannot be uninstalled.' 
						expandMacrosWith: self name).
			^false].
	^true!

onClassRemoved: aClass 
	"Private - React to aClass being removed from the Dolphin system.
	Ensure that none of the receivers loaded packages refer to aClass
	or its methods now it has departed.

	N.B. We have to take care here when checking methods. As aClass is
	no longer tied into the system class tree we have to use the method
	names."

	| className classClassName ownedChanged |
	className := aClass name.
	classClassName := aClass class name.
	ownedChanged := false.

	"remove any directly owned methods from aClass"
	methodNames 
		ifNotNil: 
			[| removed |
			removed := methodNames 
						select: [:methodName | methodName key = className or: [methodName key = classClassName]].
			removed notEmpty 
				ifTrue: 
					[ownedChanged := true.
					self removeMethodNames: removed]].
	(self includesClass: aClass) 
		ifTrue: 
			[ownedChanged := true.
			self basicRemoveClass: aClass].
	^ownedChanged!

onClassRenamed: aClass from: oldName to: newName 
	"Private - React to the <Class>, aClass, being removed from the Dolphin system.
	Ensure that none of the receivers loaded packages refer to aClass
	or its methods now it has departed.

	N.B. We have to take care here when checking methods. As aClass is
	no longer tied into the system class tree we have to use the method
	names."

	"Search for and rename any resources keyed on the class"

	(classNames includes: oldName) 
		ifTrue: 
			[classNames
				remove: oldName;
				add: newName.
			"If class includes package, can't be any loose methods or resources, so early out"
			^true].
	^self renameLooseMethodsOf: oldName to: newName!

onGlobalRenamed: anAssociation from: oldName 
	"Private - React to oldName global being renamed. Note that this
	is sent only for non-Class globals."

	| names |
	names := self globalNames.
	(names includes: oldName) ifFalse: [^self].
	names
		remove: oldName;
		add: anAssociation key.
	"Note that the pre-requisites are unaffected, but we reset them anyway because this is rare"
	self memberUpdatedAt: [Package sourceManager changesFileSize].
	self trigger: #ownedChanged!

owningPackage
	"Answers the package that owns the receiver. This is obviously self in the case of packages"

	^self!

packageFileName
	"Answer the full path name (ie Path+Stem+Extension) of the file used
	to store the source code representation of the receiver. This is recomposed
	from the relative path held"

	^File fullPathOf: packagePathname relativeTo: SessionManager current imageBase!

packageFileName: pathname 
	"Private - Set the path name (ie Path+Stem+Extension) of the file used
	to store the binary representation of the receiver. This is always held as
	relative to the current image base. This name should only be changed
	through the PackageManager, and in fact it is not advisable to change
	it any way because other packages may be dependent upon it.."

	self packagePathname: (FileLocator imageRelative 
				relativePathTo: (File default: pathname
						extension: self class packageExtension))!

packageFolder
	^File splitPathFrom: self packagePathname!

packagePathname
	^packagePathname!

packagePathname: aString 
	"Private - Set the receiver's path and name."

	| oldname |
	packagePathname := aString.
	"The name can no longer be independent of the file name, and is in fact just cached from the file stem"
	oldname := name.
	name := File splitStemFrom: aString.
	(oldname isNil or: [oldname sameAs: name]) ifTrue: [^self].
	self isChanged: true.
	"If a package is renamed, then the dependent packages need to be resaved to update their pre-requisite information"
	self dependentPackages do: [:each | each isChanged: true]!

packageVersion
	"Answer the version identification of the receiver as a String"

	^packageVersion notNil ifTrue: [packageVersion] ifFalse: [''].
!

packageVersion: aString
	"Sets the package version identification to the <readableString>, aString,
	and flag as changed."

	self basicPackageVersion: aString.
	self isChanged: true.
!

path
	"Answer the full path to the directory holding the receivers files."

	^File splitPathFrom: self packageFileName!

paxVersion
	"Private - Answer the PAX format version of the package being loaded (or the current
	format if a loaded package)."

	^self propertyAt: #paxVersion ifAbsent: [self class paxVersion]!

paxVersion: anInteger
	"Private - Temporarily record the PAX format version in which the package being loaded
	was saved. This may be used for loading old format source packages in future."

	self propertyAt: #paxVersion put: anInteger!

prerequisiteNames
	"Private - Answer the <readableString> names of the receiver's prerequisite packages, i.e.
	the packages which must be loaded before the receiver.

	There is a lazy evaluation here because anytime an object is added/removed/deleted
	from the current PackageManager then the prerequisites may change. Rather than
	updating after every change we set all Packages prerequisitePackages to nil and 
	recalculate them as they are requested."

	^prerequisiteNames ifNil: 
			["To save time make a special case of the system package"

			self isSystemPackage 
				ifTrue: [Set new]
				ifFalse: [prerequisiteNames := self buildPrerequisiteNames]]!

prerequisites
	"Answer a collection of <Package>s that must be loaded before the
	receiver can be loaded."

	| pacman |
	pacman := self manager.
	^self prerequisiteNames 
		collect: [:packageName | pacman packageNamed: packageName ifNone: [_Uncommitted]]!

printBinaryStoreBytesOf: anObject
	"Private - Prints the literal representation of the binary store bytes of anObject
	onto a String and answers this."

	| bytes stream |
	stream := String writeStream.
	bytes := anObject binaryStoreBytes.
	bytes printPrefixOn: stream.
	bytes do: [:each | stream display: each; display: ' '].
	bytes printSuffixOn: stream.
	^stream contents!

printOn: aStream
	"Append a representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: self name;
		nextPut: $)
!

privateUninstall
	"Private - This attempt to delete all the objects owned by the receiver
	from the system. This is a very defensive method, taking the view that any
	of the named objects it owns may not have a real object to match with that
	name. Still it tries to battle on and rid the system of all its owned objects.

	This does not remove the receiver from its package manager. Other than
	emergency situations it should be called from PackageManager>>uninstall:."

	self
		uninstallGlobals;
		uninstallClasses;
		uninstallMethods!

rebaseTo: basePathName 
	"Rebase this package relative to the give base image directory"

	self packageFileName: (File 
				relativePathOf: (File fullPathOf: self packagePathname relativeTo: basePathName)
				to: SessionManager current imagePath)!

remainingClasses
	"Answer a Set of the classes that are still present (i.e. ignore missing classes)"

	| classes |
	classes := Set new.
	classNames do: [:className |
		[
			classes add: (self classFromName: className)
		] on: Error do: [:ignoredException | ignoredException notify]].
	^classes
!

removeClass: aClass
	"Remove aClass from the list of Classes owned by the receiver.
	Answer aClass."

	self manager addClass: aClass to: nil.
	^aClass!

removeGlobalNamed: globalName
	"Remove globalName from the list of globals owned by the receiver.
	Answer globalName."

	self manager addGlobalNamed: globalName to: nil.
	^globalName!

removeLooseMethod: aCompiledMethod 
	"Private - Remove the <CompiledMethod> argument which is directly owned by the receiver
	(i.e. a loose method) from this package. Do not fire any events."

	self assert: [(self includesClass: aCompiledMethod methodClass) not].
	self removeMethodNames: (Array with: (self nameForMethod: aCompiledMethod))!

removeMethod: method
	"Remove the <CompiledMethod>, method, from the list of loose methods owned by 
	the receiver, and answer that method.
	Note that the method is _not_ being removed from the system, just this package."

	self manager addMethod: method to: nil.
	^method
!

removeMethodNames: aCollection 
	methodNames removeAll: aCollection.
	methodNames isEmpty ifTrue: [methodNames := nil]!

removePackagedMethod: method
	"Private - Remove the <CompiledMethod>, method, which is a method of one of the classes
	owned by the receiver (i.e. not a loose method) from this package."

	self assert: [self includesClass: method methodClass].
	method methodClass isChanged: true!

removePAXProperties
	"Private - Throw away any info cached to load the package, and make sure not marked as changed"

	#(#allResourceNames #binaryGlobalNames #globalAliases #paxVersion #changeIndex) 
		do: [:each | self removePropertyAt: each ifAbsent: []]!

renameLooseMethodsOf: oldClassNameString to: newClassNameString 
	| oldMetaName renamed |
	methodNames ifNil: [^false].
	oldMetaName := oldClassNameString , ' class'.
	renamed := methodNames select: [:each | each key = oldClassNameString or: [each key = oldMetaName]].
	^renamed notEmpty and: 
			[| newMetaName |
			newMetaName := newClassNameString , ' class'.
			renamed do: 
					[:each | 
					methodNames 
						add: (each key = oldClassNameString ifTrue: [newClassNameString] ifFalse: [newMetaName]) 
								-> each value].
			self removeMethodNames: renamed.
			true]!

resetChangeFlags
	self allSourceObjectsDo: [:each | each isChanged: false].
	self isChanged: false!

resetPrerequisites
	"Private - Mark that the prerequisite packages for the receiver
	have changed. The packages will be recalculated the next time the
	#prerequsiteNames accessor is sent. An event is triggered
	iff the pre-reqs are actually reset, in case any tool (such as a
	PackagePrerequisitesShell) is monitoring them."

	prerequisiteNames isNil ifTrue: [^self].
	prerequisiteNames := nil.
	self trigger: #prerequisitesReset!

resourceIdentifiers
	"Answer a collection of <ResourceIdentifier> objects owned by the receiver."

	^ResourceIdentifier allResourceIdentifiers select: [:each | each owningPackage == self]!

save
	"Save the receiver to a single PAC file. This includes all of the source for the receiver's contents.
	If the receiver is operating in PAX source mode then all of the source files are also
	filed out, including a .PAX definition. Answer whether the package was actually saved.
	This is the implementation behind the Package Browser's 'Save' command."

	self isUsingPAX ifTrue: [self fileOutAll] ifFalse: [self saveSingleFilePackage].
	^true!

saveAs: aString 
	self manager renamePackage: self to: aString.
	self save!

saveChanges
	"Save the receiver, if changed. This includes all of the source for the receiver's contents.
	If the receiver is operating in PAX source mode then all of the changed source files are
	also filed out. including a .PAX definition. Answer whether the package was actually saved.
	This is the implementation behind the Package Browser's 'Save Changes' command."

	self isChanged ifFalse: [^self].
	self isUsingPAX 
		ifTrue: 
			[self fileOutAllChanged.
			self isChanged: false]
		ifFalse: [self saveSingleFilePackage]!

savePAC
	"Private - File out a definition of the receiver and all the objects it owns to a single
	text .PAC file. Any binary objects (views, non-<sourceObject> globals) are saved as a
	printed representation of their STB'd binary store bytes."

	| filer |
	self okToSaveOrDeploy.
	self checkTimestamps.
	self createPackagePath.
	"This event can be hooked to backup the old package before it is overwritten, etc"
	self manager trigger: #aboutToSave: with: self.
	filer := self sourceManager sourceFilerOn: (FileStream write: self dotPacPath).
	[self fileOutAllOn: filer] ensure: [filer close]!

savePAX
	"Private - File out a definition of the receiver to a .PAX source file. This does not file
	out the source files of the receiver's contents."

	"Implementation Note: All fileouts use case sensitive collation in order to avoid problem of order
	switches for same named identifiers with different case, which can cause a line-based source
	management system to detect a change where there isn't one."

	| filer |
	self createPackagePath.
	filer := self sourceManager sourceFilerOn: (FileStream write: self fileOutName).
	[self fileOutOn: filer] ensure: [filer close].

	"We must also file out the binary globals at this stage, as they are not <sourceObject>s."
	self fileOutBinaryGlobals!

savePAXAboutBlockOn: stream 
	aboutBlock isNil ifTrue: [^self].
	stream nextPutAll: 'package aboutBlockBytes: '.
	aboutBlock binaryStoreBytes base64StoreOn: stream.
	stream
		nextPut: $.;
		cr!

savePAXChunkOn: aSourceFiler 
	"Private - File out the receiver's package description stream in PAX source file format
	to the <puttableStream>, stream. This is in the form of a chunk which, when re-evaluated,
	creates an equivalent package description in a state which can be used for comparision
	or loading, etc. None of the code in the package, with the exception of the package scripts,
	is included. None of the code, including the package scripts, is evaluated."

	| stream |
	stream := String writeStream: 1024.
	self
		savePAXPackageOn: stream;
		savePAXPackageVersionOn: stream;
		savePAXAboutBlockOn: stream;
		savePAXStripperBytesOn: stream;
		savePAXScriptsOn: stream;
		savePAXNamesOn: stream;
		savePAXGlobalNamesOn: stream;
		savePAXPrerequisiteNamesOn: stream;
		savePAXManualPrerequisitesOn: stream;
		savePAXUntracedGlobalsOn: stream.

	"Finish off the stream by answering the package loaded"
	stream nextPutAll: 'package'.
	aSourceFiler fileOutExpression: stream contents!

savePAXGlobalNamesOn: target
	"Private - File out the PAX source file expressions to record the names of
	the non-source globals owned by the receiver."

	#(#binaryGlobalNames #globalAliases) do: 
			[:each | 
			target
				nextPutAll: 'package ';
				nextPutAll: each;
				nextPutAll: ': (Set new';
				cr.
			self savePAXNames: (self perform: each) on: target.
			target
				nextPutAll: ').';
				cr;
				cr]!

savePAXManualPrerequisitesOn: target 
	"Private - File out the names of any manually configured pre-requisite packages 
	of the receiver onto the <puttableStream>, target."

	| prereqs |
	prereqs := self manualPrerequisites.
	prereqs isEmpty ifTrue: [^self].
	target
		nextPutAll: 'package ';
		nextPutAll: #setManualPrerequisites:;
		nextPutAll: ' #('.
	manualPrerequisites do: 
			[:s | 
			target
				crtab;
				print: s].
	target
		nextPutAll: ').';
		cr;
		cr!

savePAXNames: names on: stream
	"Private - File out the PAX source file representation of the list of source object
	names, names, onto the <puttableStream>, stream, in ascending order of their
	printable representation."

	((names collect: [:each | each printString]) asSortedCollection: SortedCollection caseSensitiveSortBlock)
		do: [:eachName | stream tab; nextPutAll: 'add: '; nextPutAll: eachName; nextPut: $;; cr ].
	stream 
		tab; nextPutAll: 'yourself'!

savePAXNamesOn: target 
	"Private - File out the PAX source file representation of the class names, loose method 
	names, global names, resource names, onto the <puttableStream>, stream, in ascending 
	order of their printable representation."

	#(#classNames #methodNames #globalNames) do: 
			[:each | 
			| names |
			names := self perform: each.
			names notEmpty 
				ifTrue: 
					[target
						nextPutAll: 'package ';
						nextPutAll: each;
						cr.
					self savePAXNames: names on: target.
					target
						nextPut: $.;
						cr;
						cr]]!

savePAXPackageOn: stream
	"Private - Save the basic details of the receiver in the PAX source file 
	representation onto the <puttableStream>, target."

	"Create package and set some basic attributes"

	stream
		nextPutAll: '| package |';
		cr;
		nextPutAll: 'package := ';
		print: self class;
		space;
		nextPutAll: #name:;
		space;
		print: self name;
		nextPut: $.;
		cr;
		nextPutAll: 'package ';
		nextPutAll: #paxVersion:;
		space;
		print: self paxVersion;
		nextPut: $;;
		crtab;
		nextPutAll: #basicComment:;
		space;
		print: self comment;
		nextPut: $.;
		cr;
		cr.
!

savePAXPackageVersionOn: aStream 
	"Private - Save Package Version - this is the version of the package, not the file out format"

	packageVersion isNil ifTrue: [^self].
	aStream
		nextPutAll: 'package ';
		nextPutAll: #basicPackageVersion:;
		space;
		print: self packageVersion;
		nextPut: $.;
		cr;
		cr!

savePAXPrerequisiteNamesOn: target
	"Private - File out names of the pre-requisite packages of the receiver onto the onto 
	the <puttableStream>, target, in ascending order."

	| basePath |
	target
		nextPutAll: 'package ';
		nextPutAll: #setPrerequisites:;
		nextPutAll: ' (IdentitySet new';
		cr.
	basePath := self path.
	(self prerequisites asSortedCollection: [:a :b | (a name trueCompare: b name) < 0]) do: 
			[:each | 
			target
				tab;
				nextPutAll: 'add: ';
				print: (File removeExtension: (File relativePathOf: each packageFileName to: basePath));
				nextPut: $;;
				cr].
	target
		tab;
		nextPutAll: 'yourself).';
		cr;
		cr!

savePAXScriptsOn: target 
	"Private - File out the PAX source file representation of the receiver's scripts
	onto the <puttableStream>, target.
	Implementation Note: The scripts are installed using #basicScriptAt:put: to
	avoid the package being flagged as changed and the consequent transmission 
	of a change event."

	self scripts keys asSortedCollection do: 
			[:each | 
			target
				nextPutAll: 'package basicScriptAt: ';
				print: each;
				nextPutAll: ' put: ';
				print: (self scriptAt: each);
				nextPut: $.;
				cr].
	target cr!

savePAXStripperBytesOn: stream 
	"Private - File out the PAX source file representation of the receiver's 
	image stripper bytes (if any) onto the <puttableStream>, target."

	imageStripperBytes isNil ifTrue: [^self].
	stream nextPutAll: 'package imageStripperBytes: '.
	imageStripperBytes base64StoreOn: stream.
	stream
		nextPut: $.;
		cr!

savePAXUntracedGlobalsOn: aWriteStream 
	| untraced |
	untraced := self untracedGlobals.
	untraced isEmpty ifTrue: [^self].
	aWriteStream
		nextPutAll: 'package ';
		display: #untracedGlobals:;
		nextPutAll: ' (Set new';
		cr.
	self savePAXNames: self untracedGlobals on: aWriteStream.
	aWriteStream
		nextPutAll: ').';
		cr;
		cr!

saveSingleFilePackage
	"Save the receiver and all owned objects to a single .PAC file.
	The complementary message to save a multi-file package is #fileOutAll."

	self savePAC.
	self updateTimestamp.
	self resetChangeFlags!

scriptAt: scriptName 
	"Answer the script <String> associated with the <Symbol>, scriptName.

	The currently used scripts are: #preinstall, #postinstall, #preuninstall and
	#postuninstall."

	^self scripts at: scriptName ifAbsent: ['']!

scriptAt: scriptSymbol put: aString
	"Set the script String associated with scriptSymbol."

	self basicScriptAt: scriptSymbol put: aString.
	self isChanged: true.!

scripts
	^scripts ifNil: [IdentityDictionary new]!

setEvents: anEventsCollectionOrNil
	"Private - Set the EventsCollection of the receiver to be anEventsCollectionOrNil.
	Answer the receiver."

	events := anEventsCollectionOrNil!

setManualPrerequisites: anArrayOfStrings
	"Private - Set the names of the extra manually specified pre-requisite packages for 
	the receiver.
	**Note that this is sent from the chunks which define a package in .PAC and .PAX files
	and should not be deleted**."

	manualPrerequisites := anArrayOfStrings!

setPrerequisites: anIdentitySet
	"Private - Set the pre-computed pre-requisites of the receiver to specified Set of package names. 
	**Note that this is sent from the chunks which define a package in .PAC and .PAX files
	and should not be deleted**."

	prerequisiteNames := anIdentitySet!

sourceDescriptor
	^comment isInteger ifTrue: [comment]!

sourceDescriptor: anObject
	comment := anObject!

sourceGlobalNames
	"Private - Answer a <collection> of <Symbols>'s, being the names of the global variables 
	owned by the receiver that can be filed out as separate source objects."

	^self globalNames 
		- self binaryGlobalNames 
		- self globalAliases!

sourceGlobalVariables
	"Private - Answer a <collection> of <Association>'s, being the global variable owned 
	by the receiver that can be filed out as separate source objects."

	^self globalVariables 
		select: [:var | (self isSourceGlobal: var value) and: [(self isGlobalAlias: var) not]]!

sourceManager
	"Answer the receiver's source manager."

	^self class sourceManager!

stbSaveOn: anSTBOutFiler
	"Output the receiver to anSTBOutFiler. We must ensure that the local events collection
	is NOT saved to the filer"

	anSTBOutFiler override: events with: nil.
	super stbSaveOn: anSTBOutFiler.!

storeComment
	self assert: [comment isKindOf: String].
	self sourceManager storeCommentString: comment forPackage: self!

synchronizeNames
	"Private - Classes in the package may have been renamed (or otherwise refactored) and 
	aliased over, so we want to sync.up to the current names."

	| methods |
	methods := self methods.
	methodNames := methods isEmpty 
				ifFalse: 
					[| names |
					names := methodNames copyEmpty.
					methods do: [:each | names add: (self nameForMethod: each)].
					names]!

systemGlobalRenamed: oldName to: newName 
	"Private - React to oldName global being renamed."

	| globals |
	(classNames includes: oldName) 
		ifTrue: 
			[classNames
				remove: oldName;
				add: newName.
			^self].
	globals := self globalNames.
	(globals includes: oldName) 
		ifTrue: 
			[globals
				remove: oldName;
				add: newName]!

timestamp
	"Answer a <FILETIME> that represents the last write time of the receiver (i.e. the
	modification time of the file from which the package was loaded, or the time when the
	package was last saved) expressed as the number of 100-nanosecond intervals since 12:00 A.M.
	January 1, 1601 UTC. The <integer> value of the FILETIME will be 0 if the package is new and
	has not been written to disk."

	^FILETIME fromInteger: timestamp!

toggleUsingPAX
	"Toggles the use of PAX mode."

	^self isUsingPAX: self isUsingPAX not!

trace: trace prerequisite: aPackage from: from to: to type: type
	"Private - Append the supplied details of a prerequisite link
	to trace."

	| entries prereq |
	aPackage == self ifTrue: [^self].
	prereq := aPackage ifNil: [_Uncommitted].
	entries := trace at: prereq ifAbsentPut: [OrderedCollection new].
	entries add: (Array 
				with: from
				with: to
				with: type)!

tracePrerequisiteGlobals: trace packagedGlobals: globalLookup
	"Private - Trace the prerequisites of the receiver that come about because of
	references to globals from methods."

	self allMethodsDo: [:aMethod | 
		aMethod literalReferencesDo: [:literal | | global |
			global := self globalNameOfLiteral: literal.
			global notNil ifTrue: [ | prereq |
				prereq := globalLookup at: global ifAbsent: [].
				self trace: trace prerequisite: prereq from: aMethod to: global type: 'references global']]]!

tracePrerequisites
	"Private - Answer an IdentityDictionary of prerequisite package keys against an
	OrderedCollection of traces of the owned objects which forced a prerequisite link
	and the reason why. See #tracePrerequisites for further details."

	"Notification signal: 'Tracing prerequisites of ', self name."
	^self tracePrerequisites: self manager packagedGlobals!

tracePrerequisites: anIdentityDictionary 
	"Private - Answer an <IdentityDictionary> of prerequisite package keys against an
	<OrderedCollection> of traces of the owned objects which forced a prerequisite link and the
	reason why. The argument is an <IdentityDictionary>, the keys of which are# the names of all
	packaged globals, with the associated values being the owning <Package> of the global.

	1	from	The owned object of the receiver
	2	to		The object belonging to a prerequsite package which from references
	3	reason	String description of how from references to.

	There are quite a few reasons for a prequisite being generated:

	*	'from' is a Class which is a subclass of the Class 'to'.
	*	'from' is a directly owned CompiledMethod which is a method of the Class 'to'.
	*	'from' is a CompiledMethod which references the global object 'to'.
	*	'from' is a Class whose shared pools includes the global object 'to'.
	*	'from' is a global that aliases the class 'to'
	*	'from' is a global that references an instance of the class 'to'."

	| trace |
	trace := IdentityDictionary new.
	self
		tracePrerequisitesOfClasses: trace packagedGlobals: anIdentityDictionary;
		tracePrerequisitesOfGlobals: trace packagedGlobals: anIdentityDictionary;
		tracePrerequisitesOfMethods: trace;
		tracePrerequisitesOfImageStripper: trace;
		tracePrerequisiteGlobals: trace packagedGlobals: anIdentityDictionary.
	^trace!

tracePrerequisitesOfClasses: trace packagedGlobals: globalLookup
	"Private - Trace the prerequisites of the receiver's owned classes."

	| manager |
	manager := self manager.
	self classesDo: [:aClass | | base prereq |
		base := aClass superclass.
		"Have to account specially for subclasses of nil to avoid dependency on _Uncommitted"
		prereq := base isNil 
					ifTrue: [manager systemPackage] 
					ifFalse: [manager packageOfClass: base].
		self 
			trace: trace 
			prerequisite: prereq 
			from: aClass 
			to: base 
			type: 'is a subclass of'.

		"Look for references to pool dictionaries"
		aClass sharedPoolNames do: [:poolName |
			self 
				trace: trace 
				prerequisite: (globalLookup at: poolName ifAbsent: [])
				from: aClass 
				to: poolName 
				type: 'uses the shared pool']]

!

tracePrerequisitesOfGlobals: trace packagedGlobals: anObject 
	"Private - Trace the prerequisites of the receiver's loose methods."

	| untraced |
	untraced := self untracedGlobals.
	self globalVariables do: 
			[:each | 
			(untraced includes: each key) 
				ifFalse: 
					[(self isGlobalAlias: each) 
						ifTrue: 
							[self 
								trace: trace
								prerequisite: (anObject at: each value name)
								from: each key
								to: each value
								type: 'is an alias for']
						ifFalse: 
							[self 
								trace: trace
								prerequisite: (anObject at: each value class name)
								from: each value
								to: each value class
								type: 'is an instance of']]]!

tracePrerequisitesOfImageStripper: anIdentityDictionary 
	"Only possible to trace the stripper prereqs in DPRO"

	| stream hiddenObjects |
	(imageStripperBytes isNil or: [(self environment includesKey: #ImageStripper) not]) ifTrue: [^self].
	stream := imageStripperBytes readStream.
	hiddenObjects := 
			[(STBInFiler on: stream)
				basicNext;
				readMap] ensure: [stream close].
	hiddenObjects do: 
			[:each | 
			(each class isMeta and: 
					[
					"We only trace prerequisite objects that are NOT in the
					Lagoon package. After all, we know that Loaggon must be
					present if an ImageStripper is ever loaded into memory"
					| imageStripperClass lagoonPackage |
					imageStripperClass := self environment at: #ImageStripper.
					lagoonPackage := imageStripperClass owningPackage.
					each owningPackage ~= lagoonPackage]) 
				ifTrue: 
					[self 
						trace: anIdentityDictionary
						prerequisite: each owningPackage
						from: self
						to: each
						type: 'references class']]!

tracePrerequisitesOfMethods: trace 
	"Private - Trace the prerequisites of the receiver's loose methods."

	| manager |
	manager := self manager.
	self methods do: 
			[:aMethod | 
			self 
				trace: trace
				prerequisite: (manager packageOfClass: aMethod methodClass)
				from: aMethod
				to: aMethod methodClass
				type: 'is a method of']!

uninstall
	"Uninstall the receiver and any dependent packages from the system with no questions asked.
	Does not prompt to save changes."

	self manager uninstall: self!

uninstallClasses
	"Private - Uninstall the classes owned by the receiver.
	Note that the ClassBuilder may raise its #hasInstancesSignal if the class has extant
	instances. This is passed on to any outer handler, giving that handler the opportunity
	to state whether the presence of instances hould be ignored or not. For example a
	graphical tool might prompt the user to decide, whereas an automatic uninstaller might
	just affirm. The outer handler needs to resume with true in order to actually go ahead
	and remove the class, otherwise the class will be "

	| classes empty |
	classes := self remainingClasses.

	"Remove classes, bottom up so as to remove subclasses first"
	classes := classes asSortedCollection: [:a :b | (self depthOfClass: a) > (self depthOfClass: b)].
	classes do: 
			[:aClass | 
			"Notification signal: 'Removing class ', aClass name."
			[ClassBuilder removeClass: aClass ignoreInstances: true] 
				on: ClassBuilder invalidRemoveError
				do: 
					[:e | 
					e notify.
					e isNested 
						ifTrue: 
							["Remember that global Error trap will also count as nest"
							e outer == true ifFalse: [e return]].
					"Either no outer handler, or outer said to ignore, in either case remove it anyway"
					e resume]
				on: Error
				do: 
					[:ignoredException | 
					ignoredException notify
					"aClass allInstances do: [:e | Notification signal: e allReferences printString]"]].

	"If having difficulty tracking down the source of an image stripping problem which is
	 keeping references to uninstalled packaged classes, then try commenting in this code."
	empty := MethodDictionary new.
	classes do: 
			[:aClass | 
			(aClass environment includesKey: aClass name) 
				ifFalse: 
					[aClass class methodDictionary: empty.
					aClass methodDictionary: empty]]!

uninstallGlobals
	"Private - Uninstall the globals owned by the receiver. Should be done before classes 
	in case globals hold onto instances of any of the classes."

	self globalNames do: [:globalName |
		[	self environment removeGlobalNamed: globalName
		] on: Error do: [:ignoredException | ignoredException notify]].

!

uninstallMethods
	"Private - Uninstall the methods owned by the receiver that belong to classes which are not
	owned by the receiver (i.e. methods installed into classes outside this package)."

	self methodNames do: 
			[:methodName | 
			| method |
			method := self methodFromName: methodName ifAbsent: [].
			method isNil 
				ifTrue: 
					[Notification 
						signal: ('Packaged method <1s>>><2s> no longer exists' expandMacrosWith: methodName key
								with: methodName value)]
				ifFalse: [method methodClass removeSelector: method selector]]!

untracedGlobals
	"Answer a <collection> of <Symbol>s, being the names of the global variables which should be
	ignored when tracing prerequisites. This allows a global to reference an object from another
	package without creating a dependency on that package. An example of where this is useful is
	that the Transcript global owned by the the base package is assigned an instance of
	TranscriptShell by the Transcript development package when the latter is loaded. "

	^untracedGlobals isNil 
		ifTrue: [IdentitySet new]
		ifFalse: [untracedGlobals asIdentitySet]!

untracedGlobals: aCollectionOfSymbols 
	untracedGlobals := aCollectionOfSymbols notNil ifTrue: [aCollectionOfSymbols asArray]!

upateFileNames
	"Private - Update the package filename to match the package name and to be a PAC."

	self packageFileName: (File 
				composePath: self path
				stem: self name
				extension: self class packageExtension).
	"The prereqs may be out of date due to changes since last load, also the pre-reqs set at package load time
	include relative paths, so just toss them away"
	prerequisiteNames := nil!

updateTimestamp
	"Private - Synchronise the receiver's timestamp with its source file."

	timestamp := self fileModificationTime!

validate
	"Private - Validate the internal structure repairing any errors"

	methodNames := self methodNames select: [:each | (self methodFromName: each ifAbsent: []) notNil].
	methodNames isEmpty ifTrue: [methodNames := nil]!

variableSortBlock
	"Private - Answer a <dyadicValuable> sort block suitable for sorting global variable <Association>s
	into alphabetic order."

	^[:a :b | (a key trueCompare: b key) <= 0]!

versionIfRequired
	Package manager versionPackageIfRequired: self!

vmVersionCheck: verWhenSaved 
	"Private - Raise a warning to the effect that the package being loaded
	was saved with an older, and incompatible, version of the VM, and so
	it may need to be modified (e.g. by recompiling blocks in version resources)
	in order to work - it should load OK though."

	| versionString verOnLoad |
	verOnLoad := VMLibrary default bytecodeVersion.
	verWhenSaved = verOnLoad ifTrue: [^self].
	versionString := verWhenSaved > 0 
				ifTrue: [verWhenSaved highWord displayString , '.' , verWhenSaved lowWord displayString]
				ifFalse: ['unknown'].
	Notification 
		signal: ('The package <1p> was saved with a different version of the Dolphin VM (<2s>). 
It will probably load, but it may not operate correctly. 
If you experience subsequent problems please contact the package supplier for an updated version.' 
				expandMacrosWith: self name
				with: versionString)! !
!Package categoriesFor: #about!commands!public! !
!Package categoriesFor: #aboutBlock!accessing!public! !
!Package categoriesFor: #aboutBlock:!accessing!public! !
!Package categoriesFor: #aboutBlockBytes:!accessing!private! !
!Package categoriesFor: #addClass:!adding!public! !
!Package categoriesFor: #addGlobalNamed:!adding!public! !
!Package categoriesFor: #addLooseMethod:!adding!private! !
!Package categoriesFor: #addMethod:!adding!public! !
!Package categoriesFor: #addPackagedMethod:!adding!private! !
!Package categoriesFor: #addResourceIdentifier:!adding!public! !
!Package categoriesFor: #allDependentPackages!accessing!public! !
!Package categoriesFor: #allFileOutNames!accessing!private!source filing! !
!Package categoriesFor: #allMethods!accessing!public! !
!Package categoriesFor: #allMethodsDo:!enumerating!private! !
!Package categoriesFor: #allPrerequisites!accessing!private! !
!Package categoriesFor: #allResourceIdentifiers!accessing!public! !
!Package categoriesFor: #allResourceNames!accessing!public! !
!Package categoriesFor: #allResourceNames:!private!source filing! !
!Package categoriesFor: #allSourceObjects!accessing!public!source filing! !
!Package categoriesFor: #allSourceObjectsDo:!enumerating!public!source filing! !
!Package categoriesFor: #basicAddClass:!adding!private! !
!Package categoriesFor: #basicAddGlobalNamed:!adding!private! !
!Package categoriesFor: #basicComment:!accessing!private! !
!Package categoriesFor: #basicPackageVersion:!accessing!private! !
!Package categoriesFor: #basicRemoveClass:!private!removing! !
!Package categoriesFor: #basicRemoveGlobalNamed:!private!removing! !
!Package categoriesFor: #basicScriptAt:put:!accessing!private! !
!Package categoriesFor: #behaviorFromName:ifAbsent:!mapping!private! !
!Package categoriesFor: #behaviors!enumerating!public! !
!Package categoriesFor: #behaviorsDo:!enumerating!public! !
!Package categoriesFor: #beNotUsingPAX!modes!public! !
!Package categoriesFor: #beUsingPAX!modes!public! !
!Package categoriesFor: #binaryGlobalNames!accessing!private! !
!Package categoriesFor: #binaryGlobalNames:!accessing!private! !
!Package categoriesFor: #binaryGlobalVariables!private!source filing! !
!Package categoriesFor: #buildPrerequisiteNames!helpers!private! !
!Package categoriesFor: #calculatePrerequisites!operations!private! !
!Package categoriesFor: #canFileOut!public!source filing! !
!Package categoriesFor: #canShowAbout!public!testing! !
!Package categoriesFor: #changedFrom:!public!source filing! !
!Package categoriesFor: #changeIndex!accessing!development!private! !
!Package categoriesFor: #changeIndexValue:!accessing!development!private! !
!Package categoriesFor: #checkTimestamps!helpers!private! !
!Package categoriesFor: #classDefinitionsFileName!constants!private! !
!Package categoriesFor: #classes!enumerating!public! !
!Package categoriesFor: #classesDo:!enumerating!public! !
!Package categoriesFor: #classesInHierarchyOrder!enumerating!private! !
!Package categoriesFor: #classFromName:!mapping!private! !
!Package categoriesFor: #classFromName:ifAbsent:!mapping!private! !
!Package categoriesFor: #classNames!accessing!public! !
!Package categoriesFor: #comment!accessing!public! !
!Package categoriesFor: #comment:!accessing!public! !
!Package categoriesFor: #createPackagePath!private!source filing! !
!Package categoriesFor: #declareClasses!helpers!private! !
!Package categoriesFor: #declareGlobals!helpers!private! !
!Package categoriesFor: #dependentPackages!accessing!public! !
!Package categoriesFor: #depthOfClass:!helpers!public! !
!Package categoriesFor: #displayOn:!displaying!public! !
!Package categoriesFor: #dotPacPath!helpers!private! !
!Package categoriesFor: #endClassDefinitionsMarker!constants!private! !
!Package categoriesFor: #environment!constants!private! !
!Package categoriesFor: #errorFileCorrupt!exceptions!private! !
!Package categoriesFor: #fileInClassDefinitions:!development!public!source filing! !
!Package categoriesFor: #fileInClasses!private!source filing! !
!Package categoriesFor: #fileInScript:!private!source filing! !
!Package categoriesFor: #fileLocator!accessing!public! !
!Package categoriesFor: #fileModificationTime!helpers!private! !
!Package categoriesFor: #fileNameForBinaryGlobal:!mapping!private! !
!Package categoriesFor: #fileNameForSourceGlobal:!mapping!private! !
!Package categoriesFor: #fileOut!public!source filing! !
!Package categoriesFor: #fileOutAll!public!source filing! !
!Package categoriesFor: #fileOutAllChanged!public!source filing! !
!Package categoriesFor: #fileOutAllOn:!public!source filing! !
!Package categoriesFor: #fileOutBinaryGlobals!private!source filing! !
!Package categoriesFor: #fileOutBinaryGlobalsOn:!private!source filing! !
!Package categoriesFor: #fileOutBootDefinitions!development!private! !
!Package categoriesFor: #fileOutClassDefinitionsOn:!private!source filing! !
!Package categoriesFor: #fileOutClassesOn:!private!source filing! !
!Package categoriesFor: #fileOutGlobalAliasesOn:!private!source filing! !
!Package categoriesFor: #fileOutLooseMethodsOn:!private!source filing! !
!Package categoriesFor: #fileOutMethodsOfClass:on:!private!source filing! !
!Package categoriesFor: #fileOutName!public!source filing! !
!Package categoriesFor: #fileOutNames!private!source filing! !
!Package categoriesFor: #fileOutOn:!public!source filing! !
!Package categoriesFor: #fileOutSourceGlobalsOn:!private!source filing! !
!Package categoriesFor: #getEvents!events!private! !
!Package categoriesFor: #getPrerequisites!enumerating!private! !
!Package categoriesFor: #globalAliases!private!source filing! !
!Package categoriesFor: #globalAliases:!accessing!private! !
!Package categoriesFor: #globalAliasVariables!accessing!private!source filing! !
!Package categoriesFor: #globalFromName:!mapping!private! !
!Package categoriesFor: #globalNameOfLiteral:!enumerating!private! !
!Package categoriesFor: #globalNames!accessing!public! !
!Package categoriesFor: #globals!accessing!private! !
!Package categoriesFor: #globalVariables!private!source filing! !
!Package categoriesFor: #hasCyclicPrerequisites!private!testing! !
!Package categoriesFor: #hasCyclicPrerequisites:!private!testing! !
!Package categoriesFor: #hasImageStripper!private!testing! !
!Package categoriesFor: #hasUncommittedPrerequisites!private!testing! !
!Package categoriesFor: #hierarchyOrderOfClasses:!helpers!private! !
!Package categoriesFor: #imageStripper!accessing!public! !
!Package categoriesFor: #imageStripper:!accessing!public! !
!Package categoriesFor: #imageStripperBytes!accessing!private! !
!Package categoriesFor: #imageStripperBytes:!accessing!private! !
!Package categoriesFor: #includesClass:!public!searching! !
!Package categoriesFor: #includesGlobalNamed:!public!searching! !
!Package categoriesFor: #includesMethod:!public!searching! !
!Package categoriesFor: #includesResourceIdentifier:!private!searching! !
!Package categoriesFor: #initialize!initializing!private! !
!Package categoriesFor: #initializeClasses!initializing!private! !
!Package categoriesFor: #initializeGlobals!initializing!private! !
!Package categoriesFor: #initializeOldSourcePackage!private!source filing-pax! !
!Package categoriesFor: #isBaseImagePackage!public! !
!Package categoriesFor: #isBasePackage!public! !
!Package categoriesFor: #isChanged!development!public!source filing!testing! !
!Package categoriesFor: #isChanged:!public!source filing! !
!Package categoriesFor: #isDefaultPackage!public!testing! !
!Package categoriesFor: #isGlobalAlias:!private!testing! !
!Package categoriesFor: #isImportedClass:!private!testing! !
!Package categoriesFor: #isInstalled!public!testing! !
!Package categoriesFor: #isRenegade!public!testing! !
!Package categoriesFor: #isSourceGlobal:!private!testing! !
!Package categoriesFor: #isSystemPackage!public!testing! !
!Package categoriesFor: #isUsingPAX!public!testing! !
!Package categoriesFor: #isUsingPAX:!public!testing! !
!Package categoriesFor: #load!operations!private! !
!Package categoriesFor: #loadBinaryGlobals!binary filing!private! !
!Package categoriesFor: #loadPAC!private!source filing! !
!Package categoriesFor: #loadPAC:!private!source filing! !
!Package categoriesFor: #loadPAX!private!source filing-pax! !
!Package categoriesFor: #manager!accessing!public! !
!Package categoriesFor: #manualPrerequisites!accessing!public! !
!Package categoriesFor: #manualPrerequisites:!accessing!public! !
!Package categoriesFor: #membershipChanged!event handling!private! !
!Package categoriesFor: #membershipChangedAt:!helpers!private! !
!Package categoriesFor: #memberUpdatedAt:!event handling!private! !
!Package categoriesFor: #methodFromName:ifAbsent:!mapping!private! !
!Package categoriesFor: #methodNames!accessing!public! !
!Package categoriesFor: #methods!enumerating!public! !
!Package categoriesFor: #methodsOfClass:!enumerating!public! !
!Package categoriesFor: #name!accessing!public! !
!Package categoriesFor: #nameForClass:!mapping!private! !
!Package categoriesFor: #nameForMethod:!mapping!private! !
!Package categoriesFor: #nameForResourceIdentifier:!mapping!private! !
!Package categoriesFor: #okToSaveOrDeploy!helpers!private! !
!Package categoriesFor: #okToUninstall!helpers!private! !
!Package categoriesFor: #onClassRemoved:!event handling!private! !
!Package categoriesFor: #onClassRenamed:from:to:!event handling!private! !
!Package categoriesFor: #onGlobalRenamed:from:!event handling!private! !
!Package categoriesFor: #owningPackage!public!source filing! !
!Package categoriesFor: #packageFileName!accessing!public! !
!Package categoriesFor: #packageFileName:!accessing!private! !
!Package categoriesFor: #packageFolder!instance creation!public! !
!Package categoriesFor: #packagePathname!accessing!private! !
!Package categoriesFor: #packagePathname:!accessing!private! !
!Package categoriesFor: #packageVersion!accessing!public! !
!Package categoriesFor: #packageVersion:!accessing!public! !
!Package categoriesFor: #path!accessing!public! !
!Package categoriesFor: #paxVersion!accessing!private! !
!Package categoriesFor: #paxVersion:!accessing!private! !
!Package categoriesFor: #prerequisiteNames!accessing!private! !
!Package categoriesFor: #prerequisites!enumerating!public! !
!Package categoriesFor: #printBinaryStoreBytesOf:!helpers!private! !
!Package categoriesFor: #printOn:!printing!public! !
!Package categoriesFor: #privateUninstall!private!removing! !
!Package categoriesFor: #rebaseTo:!public!testing! !
!Package categoriesFor: #remainingClasses!accessing!public! !
!Package categoriesFor: #removeClass:!public!removing! !
!Package categoriesFor: #removeGlobalNamed:!public!removing! !
!Package categoriesFor: #removeLooseMethod:!private!removing! !
!Package categoriesFor: #removeMethod:!public!removing! !
!Package categoriesFor: #removeMethodNames:!event handling!private! !
!Package categoriesFor: #removePackagedMethod:!private!removing! !
!Package categoriesFor: #removePAXProperties!operations!private! !
!Package categoriesFor: #renameLooseMethodsOf:to:!event handling!private! !
!Package categoriesFor: #resetChangeFlags!public!source filing! !
!Package categoriesFor: #resetPrerequisites!operations!private! !
!Package categoriesFor: #resourceIdentifiers!accessing!public! !
!Package categoriesFor: #save!operations!public! !
!Package categoriesFor: #saveAs:!commands!public! !
!Package categoriesFor: #saveChanges!operations!public! !
!Package categoriesFor: #savePAC!helpers!private! !
!Package categoriesFor: #savePAX!private!source filing-pax! !
!Package categoriesFor: #savePAXAboutBlockOn:!private!source filing-pax! !
!Package categoriesFor: #savePAXChunkOn:!private!source filing-pax! !
!Package categoriesFor: #savePAXGlobalNamesOn:!private!source filing-pax! !
!Package categoriesFor: #savePAXManualPrerequisitesOn:!private!source filing-pax! !
!Package categoriesFor: #savePAXNames:on:!private!source filing-pax! !
!Package categoriesFor: #savePAXNamesOn:!private!source filing-pax! !
!Package categoriesFor: #savePAXPackageOn:!private!source filing-pax! !
!Package categoriesFor: #savePAXPackageVersionOn:!private!source filing-pax! !
!Package categoriesFor: #savePAXPrerequisiteNamesOn:!private!source filing-pax! !
!Package categoriesFor: #savePAXScriptsOn:!private!source filing-pax! !
!Package categoriesFor: #savePAXStripperBytesOn:!private!source filing-pax! !
!Package categoriesFor: #savePAXUntracedGlobalsOn:!public!source filing-pax! !
!Package categoriesFor: #saveSingleFilePackage!public!source filing! !
!Package categoriesFor: #scriptAt:!accessing!public! !
!Package categoriesFor: #scriptAt:put:!accessing!public! !
!Package categoriesFor: #scripts!accessing!private! !
!Package categoriesFor: #setEvents:!events!private! !
!Package categoriesFor: #setManualPrerequisites:!accessing!private! !
!Package categoriesFor: #setPrerequisites:!accessing!private! !
!Package categoriesFor: #sourceDescriptor!accessing!private! !
!Package categoriesFor: #sourceDescriptor:!accessing!private! !
!Package categoriesFor: #sourceGlobalNames!accessing!private! !
!Package categoriesFor: #sourceGlobalVariables!accessing!private! !
!Package categoriesFor: #sourceManager!accessing!public! !
!Package categoriesFor: #stbSaveOn:!binary filing!public! !
!Package categoriesFor: #storeComment!helpers!private! !
!Package categoriesFor: #synchronizeNames!helpers!private! !
!Package categoriesFor: #systemGlobalRenamed:to:!event handling!private! !
!Package categoriesFor: #timestamp!accessing!public! !
!Package categoriesFor: #toggleUsingPAX!commands!public! !
!Package categoriesFor: #trace:prerequisite:from:to:type:!helpers!private! !
!Package categoriesFor: #tracePrerequisiteGlobals:packagedGlobals:!operations!private! !
!Package categoriesFor: #tracePrerequisites!operations!private! !
!Package categoriesFor: #tracePrerequisites:!operations!private! !
!Package categoriesFor: #tracePrerequisitesOfClasses:packagedGlobals:!operations!private! !
!Package categoriesFor: #tracePrerequisitesOfGlobals:packagedGlobals:!operations!private! !
!Package categoriesFor: #tracePrerequisitesOfImageStripper:!operations!private! !
!Package categoriesFor: #tracePrerequisitesOfMethods:!operations!private! !
!Package categoriesFor: #uninstall!public!removing! !
!Package categoriesFor: #uninstallClasses!private!removing! !
!Package categoriesFor: #uninstallGlobals!private!removing! !
!Package categoriesFor: #uninstallMethods!private!removing! !
!Package categoriesFor: #untracedGlobals!accessing!public! !
!Package categoriesFor: #untracedGlobals:!accessing!public! !
!Package categoriesFor: #upateFileNames!operations!private! !
!Package categoriesFor: #updateTimestamp!helpers!private! !
!Package categoriesFor: #validate!operations!private! !
!Package categoriesFor: #variableSortBlock!constants!private! !
!Package categoriesFor: #versionIfRequired!public! !
!Package categoriesFor: #vmVersionCheck:!constants!private! !

Package methodProtocol: #sourceObject attributes: #() selectors: #(#canFileOut #fileOut #fileOutName #isChanged #isChanged: #owningPackage)!

!Package class methodsFor!

binaryGlobalExtension
	"Private - Answer the file extension for the files to which binary globals are stored."

	^ 'stb'!

clashSignal
	"Private - Answer the <Signal> which is raised should overlapping/clashing membership
	be detected when attempting to install a package."

	^ClashSignal!

defaultSortBlock
	^[:a :b | a name < b name]!

errorInvalidPACFile: pathString 
	"Private - Raise an <Error> to the effect that the file with the specified path is
	not a valid .PAC file."

	^self error: 'Invalid PAC file: ', pathString!

errorInvalidPAXFile: pathString 
	"Private - Raise an <Error> to the effect that the file with the specified path is
	not a valid .PAX file."

	^self error: 'Invalid PAX file: ', pathString!

fromFile: path
	"Private - Answer a new instance of the receiver created from the package file at the
	specified <readableString> path, pathname, or nil if the file does not contain a
	package"

	| answer pathname |

	pathname := File default: path extension: self sourcePackageExtension.
	answer := ((File splitExtensionFrom: pathname) sameAs: self sourcePackageExtension) 
		ifTrue: [self fromPAXFile: pathname]
		ifFalse: [self fromPACFile: pathname].
	answer packageFileName: pathname.
	^answer!

fromPACFile: pathname 
	"Private - Answer a new instance of the receiver created from the .PAC file at the
	specified <readableString> path, pathname, or raise an error if the file does not contain a
	package."

	| pacStream answer |
	pacStream := FileStream read: pathname text: false.
	answer := 
			[(STBInFiler peekForSignatureIn: pacStream) 
				ifTrue: 
					[pacStream reset.
					(STBInFiler on: pacStream) next]
				ifFalse: 
					[pacStream beText.
					self readFrom: pacStream]] 
					ensure: [pacStream close].
	answer isNil ifTrue: [self errorInvalidPACFile: pathname].
	^answer!

fromPAXFile: pathname 
	"Private - Answer a new instance of the receiver created from the .PAX file at the
	specified <readableString> path, pathname, or raise an error if the file does not contain a
	package in source text representation."

	| paxStream answer |
	paxStream := FileStream read: pathname.
	answer := [self readFrom: paxStream] ensure: [paxStream close].
	answer isNil ifTrue: [self errorInvalidPAXFile: pathname].
	^answer!

icon
	"Answers an Icon that can be used to represent this class."

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables.
		Package initialize
	"

	_Uncommitted := (self basicNew)
				initialize;
				packagePathname: '<Unpackaged>';
				yourself.
	ClashSignal := Signal resumableDescription: 'Package contents clash'.
	UnsaveableSignal := Signal description: 'Package cannot be saved (check for cyclic dependencies or unpackaged prereqs)'.
	CheckTimestamps := true!

manager
	"Answer the object responsible for managing the collection of installed packages.
	N.B. This should be the only reference to PackageManager in the entire system,
	as the class may be removed from a future release."

	^PackageManager current!

name: nameString
	"Answer a new instance of the receiver with the <readableString> name, nameString."

	^self new
		packageFileName: nameString;
		yourself
!

nameForMethod: aMethod
	"Private - Answer an Association of the method class name String -> methods selector Symbol.
	See: Package>>methodFromName for the reverse transformation.
	Implementation Note: As of file version 1 we use a symbolic class name, if one
	is available, to save space. Metaclasses are not globals, so these _will_ have string names."

	^aMethod methodClass name -> aMethod selector!

new
	"Answer a new instance of the receiver."

	^super new initialize!

onPreStripImage
	"Private - The image is about to be stripped, clear lazily initialize class variables to assist
	the stripping process."

	ChangedIcon := SourcePackageIcon := nil!

packageExtension
	"Private - Answer the file extension for the file which an instance of the
	receiver is filed out to."

	^ 'pac'!

packageFileVersion
	"Answer the current file format version of the receiever."

	^5!

paxVersion
	"Private - Answer the current PAX format version number.
	0 - Original D5.1 format
	1 - D6.0 format with implicit literal (i.e. not embedded binary) resources"

	^1!

readFrom: pacStream
	"Private - Answer a new instance of the receiver created from the .PAX (source 
	text) format representation in the <readableStream>, pacStream."

	| chunk |
	chunk := (ChunkSourceFiler on: pacStream) nextChunk.
	^Compiler evaluate: chunk logged: false!

sourceGlobalExtension
	"Private - Answer the file extension for the files to which source globals are stored."

	^ 'st'!

sourcePackageExtension
	"Private - Answer the file extension for the file to which sources for an instance of the
	receiver is filed out to."

	^ 'pax'!

stbConvertFrom: anSTBClassFormat
	"Convert version 0 packages by mutating class names from Strings
	into Symbols. There is no layout change."

	Notification signal: 'Converting package from version ',
						anSTBClassFormat version printString, ' to: ',
						self stbVersion printString.

	^[:data |
		(anSTBClassFormat version to: self stbVersion - 1)
			inject: data into: [:inject :version |
				self perform: ('stbConvertFromVersion', version displayString, ':') asSymbol with: inject]]
		
		
		!

stbConvertFromVersion0: data
	"Private - Convert version 0 packages by mutating class names from Strings
	into Symbols. There is no layout change. Answer the mutated data.

	Version 0 Package		-->		Version 1 Package
	1	name						1	name
	2	packagePathname			2	packagePathname
	3	comment					3	comment
	4	classNames				4	classNames
	5	methodNames				5	methodNames
	6	globalNames				6	globalNames
	7	prerequisiteNames			7	prerequisiteNames
	8	preinstall				8	preinstall
	9	postinstall				9	postinstall
	10	singleFile				10	singleFile"

	| classNames globalNames |
	classNames := data instVarAt: 4.
	classNames become: (classNames collect: [:n | n asSymbol]).
	classNames becomeA: IdentitySet.
	globalNames := data instVarAt: 6.
	globalNames becomeA: IdentitySet.
	^data!

stbConvertFromVersion1: anArray 
	"Private - Convert version 1 packages  to version2. The preinstall and
	postinstall instance variables are replaced by a dictionary which holds
	those scripts and any more we define. Answer the mutated data.

	Version 1 Package		-->		Version 2 Package
	1	name						1	name
	2	packagePathname			2	packagePathname
	3	comment					3	comment
	4	classNames				4	classNames
	5	methodNames				5	methodNames
	6	globalNames				6	globalNames
	7	prerequisiteNames			7	prerequisiteNames
	8	preinstall				8	singleFile
	9	postinstall				9	scripts
	10	singleFile"

	| preinstall postinstall newData scripts |
	preinstall := anArray at: 8.
	postinstall := anArray at: 9.
	"need to temporarily convert data Array into a Package so we can
	use public methods to add preinstall/postinstall scripts"
	newData := Array new: 9.
	1 to: 7 do: [:index | newData at: index put: (anArray at: index)].
	newData at: 8 put: (anArray at: 10).
	scripts := IdentityDictionary new.
	(preinstall notNil and: [preinstall notEmpty]) ifTrue: [scripts at: #preinstall put: preinstall].
	(postinstall notNil and: [postinstall notEmpty]) 
		ifTrue: [scripts at: #postinstall put: postinstall].
	newData at: 9 put: scripts.
	^newData!

stbConvertFromVersion2: anArray 
	"Private - Convert version 2 packages to version3. The only change is the
	addition of a list of resources owned by a packkage which doesn't also
	own the class which the resource is from. This is similar to the methodNames
	support.

	Version 2 Package		-->		Version 3 Package
	1	name						1	name
	2	packagePathname			2	packagePathname
	3	comment					3	comment
	4	classNames				4	classNames
	5	methodNames				5	methodNames
	6	globalNames				6	globalNames
	7	prerequisiteNames			7	prerequisiteNames
	8	singleFile				8	singleFile
	9	scripts					9	scripts
								10 resourceNames"

	^anArray copyWith: Set new!

stbConvertFromVersion3: anArray 
	"Private - Convert version 3 packages to version 4. The main change is the
	addition of an imageStripperBytes instance variable to hold a filed imageStripper
	to be associated with the package. We hold the image stripper in this form to allow
	filing of the package into images that do not have ImageStripper installed. 
	Additionally we must convert the full stored pathname of the package to a
	name relative to the image base."

	"Note that this is currently the last converter in the chain and answers the
	coverted Package object rather than an Array. This will need to be changed
	to answer an Array if an additional converter is added."

	"Version 3 Package		-->		Version 4 Package
	1	name						1	name
	2	packagePathname			2	packagePathname
	3	comment					3	comment
	4	classNames				4	classNames
	5	methodNames				5	methodNames
	6	globalNames				6	globalNames
	7	prerequisiteNames			7	prerequisiteNames
	8	singleFile					8	singleFile
	9	scripts					9	scripts
	10 	resourceNames				10	resourceNames
								11 imageStripperBytes"

	"Copy over adding a nil imageStripperBytes slot"
	| newData packagePathName |
	newData := anArray copyWith: nil.

	"Convert the imagePathName to a relative path"
	packagePathName := File relativePathOf: (anArray at: 2) to: SessionManager current imageBase.
	newData at: 2 put: packagePathName.
	^newData!

stbConvertFromVersion4: anArray 
	"Private - Convert version 4 packages (Dolphin 3.0) to version 5 (Dolphin 3.05).
	Adds an aboutBlock (12) and versionString (13) instance variables."

	^(Array new: 13)
		replaceFrom: 1
			to: 11
			with: anArray
			startingAt: 1;
		yourself!

stbConvertFromVersion5: anArray 
	"Private - Convert version 5 (Dolphin 3.05) packages to version 6 (new PAX format).
	singleFile instance variable is no longer used."

	"Version 5 Package		-->		Version 4 Package
	1	name						1	name
	2	packagePathname			2	packagePathname
	3	comment					3	comment
	4	classNames				4	classNames
	5	methodNames				5	methodNames
	6	globalNames				6	globalNames
	7	prerequisiteNames			7	prerequisiteNames
	8	singleFile					8	events
	9	scripts					9	scripts
	10 	resourceNames				10	doNotReuse
	11 	imageStripperBytes			11	imageStripperBytes
	12 	aboutBlock				12	aboutBlock
	13 	packageVersion			13	packageVersion
								14	manualPrerequisites
								15	timestamp
								16	untracedGlobals"

	| newPackage |
	anArray at: 8 put: nil.	"singleFile"
	anArray at: 10 put: nil.
	"Last converter in the chain, so return a package instance"
	newPackage := self new.
	anArray keysAndValuesDo: [:eachKey :eachValue | newPackage instVarAt: eachKey put: eachValue].
	^newPackage!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^6!

uncommitted
	"Answer the special package used to 'hold' uncommitted classes and other globals."

	^_Uncommitted!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	ChangedIcon := _Uncommitted := nil!

unsaveableSignal
	"Private - Answer the <Signal> which is raised should an attempt be made to save
	a package with uncommitted or cyclic pre-requisites."

	^UnsaveableSignal! !
!Package class categoriesFor: #binaryGlobalExtension!constants!private! !
!Package class categoriesFor: #clashSignal!constants!private! !
!Package class categoriesFor: #defaultSortBlock!constants!public! !
!Package class categoriesFor: #errorInvalidPACFile:!exceptions!private! !
!Package class categoriesFor: #errorInvalidPAXFile:!exceptions!private! !
!Package class categoriesFor: #fromFile:!instance creation!private! !
!Package class categoriesFor: #fromPACFile:!instance creation!private! !
!Package class categoriesFor: #fromPAXFile:!instance creation!private! !
!Package class categoriesFor: #icon!constants!public! !
!Package class categoriesFor: #initialize!initializing!private! !
!Package class categoriesFor: #manager!accessing!public! !
!Package class categoriesFor: #name:!instance creation!public! !
!Package class categoriesFor: #nameForMethod:!mapping!private! !
!Package class categoriesFor: #new!instance creation!public! !
!Package class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!Package class categoriesFor: #packageExtension!constants!private! !
!Package class categoriesFor: #packageFileVersion!constants!public! !
!Package class categoriesFor: #paxVersion!constants!private! !
!Package class categoriesFor: #readFrom:!instance creation!private! !
!Package class categoriesFor: #sourceGlobalExtension!constants!private! !
!Package class categoriesFor: #sourcePackageExtension!constants!private! !
!Package class categoriesFor: #stbConvertFrom:!binary filing!public! !
!Package class categoriesFor: #stbConvertFromVersion0:!binary filing!private! !
!Package class categoriesFor: #stbConvertFromVersion1:!binary filing!private! !
!Package class categoriesFor: #stbConvertFromVersion2:!binary filing!private! !
!Package class categoriesFor: #stbConvertFromVersion3:!binary filing!private! !
!Package class categoriesFor: #stbConvertFromVersion4:!binary filing!private! !
!Package class categoriesFor: #stbConvertFromVersion5:!binary filing!private! !
!Package class categoriesFor: #stbVersion!binary filing!public! !
!Package class categoriesFor: #uncommitted!accessing!public! !
!Package class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!Package class categoriesFor: #unsaveableSignal!constants!private! !

