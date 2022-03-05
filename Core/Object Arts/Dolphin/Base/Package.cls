"Filed out from Dolphin Smalltalk"!

Object subclass: #Package
	instanceVariableNames: 'name packagePathname comment classNames methodNames globalNames prerequisiteNames events scripts doNotReuse imageStripperBytes aboutBlock packageVersion manualPrerequisites timestamp untracedGlobals changeIndex properties preDeclareClassesOnLoad'
	classVariableNames: '_Uncommitted BinaryPacLoader ChangedIcon CheckTimestamps ClashSignal PreDeclareClassesOnLoad SourcePackageIcon UnsaveableSignal'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Package guid: (GUID fromString: '{87b4c4a6-026e-11d3-9fd7-00a0cc3e4a32}')!
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

addAllPrerequisitesTo: aSet
	"Private - Add to <aSet> all those Packages which must be loaded in
	before the receiver may be loaded in."

	self prerequisites
		do: [:each | (aSet addNewElement: each) ifTrue: [each addAllPrerequisitesTo: aSet]]!

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
	self methodsDo: operation!

allPrerequisites
	"Private - Answer a collection of all the Packages objects which must be loaded in before the
	receiver may be loaded in."

	| answer |
	answer := IdentitySet new.
	self addAllPrerequisitesTo: answer.
	^answer.!

allResourceIdentifiers
	"Answer a Set of all the ResourceIdentifiers directly owned by
	the receiver or by owning the class in which it is situated."

	| resources |
	resources := Set new.
	self classesDo: [:each | each resourceIdentifiersDo: [:eachResId | resources add: eachResId]].
	self looseResourceIdentifiersDo: [:each | resources add: each].
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
	self allSourceObjectsDo: [:each | answer addLast: each].
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
	className := aClass name.
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

	self removeClassName: aClass name.
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
	index := aString identityIndexOf: $\x20.
	^index == 0
		ifTrue: [self classFromName: aString ifAbsent: exceptionHandler]
		ifFalse: 
			[(self classFromName: (aString copyFrom: 1 to: index - 1) ifAbsent: [])
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

canShowAbout
	"Answer true if we can show an about box for the receiver, i.e. we have an aboutBlock"

	^self aboutBlock notNil!

changedFrom: aMonadicValuable 
	"Set the changed flag for the receiver to aBoolean"

	self isChanged ifTrue: [^self].
	self changeIndexValue: aMonadicValuable.
	self trigger: #changed!

changeIndex
	^changeIndex!

changeIndexValue: aBlock
	aBlock isNil
		ifTrue: [changeIndex := nil]
		ifFalse: [changeIndex isNil ifTrue: [changeIndex := aBlock value]]!

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
				ifTrue: [Utf8String readFrom: (self sourceManager getSourceFromDescriptor: comment) readStream]
				ifFalse: [comment]]!

comment: aString 
	"Set the comment of the receiver, and flag as changed."

	self basicComment: aString.
	self storeComment.
	self isChanged: true!

declareClasses
	"Private - Predefine global variables for each of the classes in the package prior to those classes
	being loaded. Only required for PAX (not PAC) loading"

	(self classNames reject: [:each | self environment includesKey: each]) do: 
			[:each |
			Object
				subclass: each
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

environment
	"Private - Answer the global name associated with the receiver."

	^Smalltalk!

errorFileCorrupt
	"Private - Filing in the receivers owned objects has failed because the
	file is corrupt."

	self error: ('FileIn of <1s> package has failed, file is corrupt' expandMacrosWith: self name)!

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

fileNameForBinaryGlobal: globalName
	"Private - Answer a filename for storing the binary globalName."

	^File composePath: self path stem: globalName extension: self class binaryGlobalExtension
!

fileNameForSourceGlobal: globalName
	"Private - Answer a filename for storing the source globalObject."

	^File composePath: self path stem: globalName extension: self class sourceGlobalExtension
!

fileOutName
	"Answer the pathname used to store the PAX file for the sources of the receiver"

	^File composePath: self path stem: self name extension: self class sourcePackageExtension!

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
			"Avoid interning symbols for all the string Pool variable names by checking first if the var name is a symbol"
			(key isKindOf: Symbol)
				ifTrue: 
					[(self environment associationAt: key ifAbsent: []) ifNotNil: [:v | v == anObject ifTrue: [key]]]]
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

	^self hasCyclicPrerequisites: IdentitySet new safe: IdentitySet new.!

hasCyclicPrerequisites: trail safe: safe
	"Private - Walk the package pre-requisite net looking for a cyclic dependency.
	The <collection> trail includes all those packages already visited.
	The <collection> safe includes all those packages which were already checked
	and found not to have cyclic prerequisites, and thus do not need to be checked again.
	If we find a duplicate package on the path then we know a cycle exists."

	| answer |
	(safe includes: self) ifTrue: [^false].
	trail add: self.
	answer := self prerequisites
				anySatisfy: [:prereq | (trail includes: prereq) or: [prereq hasCyclicPrerequisites: trail safe: safe]].
	trail remove: self.
	answer ifFalse: [safe add: self].
	^answer.!

hasUncommittedPrerequisites
	"Private - Answer whether any of the receivers prerequisites or their
	prerequisites are current uncomitted. If so the package should not be saved
	as it will not be reloadable into an image without the uncommitted objects."

	^self allPrerequisites includes: _Uncommitted.!

hierarchyOrderOfClasses: aCollection 
	"Private - Answer an OrderedCollection of all the Classes owned
	by the receiver intersected with the collection in classes. 
	The classes are ordered by their depth in the class hierarchy, with Object
	being first if it is owned by the receiver."

	^self environment allClasses intersection: aCollection!

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

	^(classNames includes: aClass instanceClass name) and: [(ClassLocator isImportedClass: aClass) not]!

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

initializeLegacyResources
	"Private - For old (pre-D6) packages, we have to make sure that the resources loaded by this package actually
	below to it. Obviously, those resources that already belong to classes in the package will be ok, so really
	we are only concerned with loose resources"

	self allResourceNames do: 
			[:each | 
			| rid |
			rid := ResourceIdentifier class: (self environment at: each key) name: each value.
			rid owningPackage == self ifFalse: [self manager addLooseMethod: rid compiledMethod to: self]]!

initializeOldSourcePackage
	(self respondsTo: #loadLegacyResources) 
		ifTrue: [self perform: #loadLegacyResources]
		ifFalse: [self error: 'Unable to load package (Legacy package importer is not loaded)']	"Initialize old style (pre D6) binary resources"!

isBaseImagePackage
	"Answer true if the receiver is a basic component of Dolphin "

	Notification deprecated.
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
	self changeIndexValue: (aBoolean ifTrue: [[Package sourceManager changesFileSize]]).
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

	^ClassLocator isImportedClass: aClass!

isInstalled
	"Answer whether the receiver is currently installed in the system."

	^self manager includesPackage: self!

isSourceGlobal: aGlobal
	"Private - Answer true if aGlobal can be filed out as an external source file"

	^aGlobal class conformsToProtocol: #sourceObject
!

isSystemPackage
	"Answer whether the receiver is the system package"

	^self manager systemPackage == self!

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
	stream := FileStream read: filename text: true.
	
	[timestamp := stream file lastWriteTime asInteger.
	(STBInFiler peekForSignatureIn: stream)
		ifTrue: 
			[stream reset.
			BinaryPacLoader
				ifNil: [self error: 'Legacy binary package loading support is not available']
				ifNotNil: [:loader | loader value: self value: stream]]
		ifFalse: [self loadPAC: stream]]
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
	self paxVersion < 1 ifTrue: [self initializeLegacyResources].
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

	"Define any globals that might be referenced from source code, but don't load them as yet as they may be instances of one of the classes in the package."
	self declareGlobals.
	"Optionally declare all classes in the package for the case where classes are referenced by source globals or other class definitions (other than the class hierarchy relationship)"
	self preDeclareClassesOnLoad ifTrue: [self declareClasses].
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

looseResourceIdentifiers
	| rids |
	rids := Set new.
	self looseResourceIdentifiersDo: [:each | rids add: each].
	^rids!

looseResourceIdentifiersDo: aMonadicValuable
	self methodNames do: 
			[:each |
			(each value beginsWith: ResourceIdentifier.SelectorPrefix)
				ifTrue: 
					[(self behaviorFromName: each key ifAbsent: [])
						ifNotNil: 
							[:methodClass |
							aMonadicValuable value: (ResourceIdentifier class: methodClass instanceClass selector: each value)]]]!

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

	^methodNames ifNil: [methodNames := PluggableSet searchPolicy: SearchPolicy association]!

methods
	"Answer an <IdentitySet> of the <CompiledMethod>s owned by the receiver."

	| newIdentitySet |
	newIdentitySet := IdentitySet new: 16.
	self methodsDo: [:each | newIdentitySet add: each].
	^newIdentitySet!

methodsDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the loose methods owned by the receiver."

	self methodNames
		do: [:each | (self methodFromName: each ifAbsent: []) ifNotNil: [:method | aMonadicValuable value: method]]!

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

nameForMethod: aMethod
	"Private - Answer an Association of the method class name String -> methods selector Symbol.
	See: Package>>methodFromName for the reverse transformation."

	^Association key: aMethod methodClass name value: aMethod selector!

nameForResourceIdentifier: aResourceIdentifier
	"Private - Answer an <Association> that uniquely identifies the <ResourceIdentifier> argument."

	^aResourceIdentifier owningClass name -> aResourceIdentifier name!

okToSaveOrDeploy
	"Private - Prior to saving or deploying the receiver, check that all is consistent and answer whether the
	receiver should be saved. Raise Errors that describe any problems."

	self isSystemPackage ifTrue: [^Smalltalk developmentSystem isOAD].
	self hasCyclicPrerequisites ifTrue: 
			[self class unsaveableSignal
				signal: ('The package <1p> has cyclic prerequisites.' expandMacrosWith: self name).
			^false].

	"N.B. This must be done after the above, as it will go infinitely recursive if there are cycles."
	self hasUncommittedPrerequisites ifTrue: 
			[self class unsaveableSignal
				signal: ('The package <1p> has prerequisites which are not currently assigned to any other package, or it is dependent on other packages which in turn have uncommitted prerequisites.'
						expandMacrosWith: self name).
			^false].
	self validate.
	^true.!

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

	(self setPackageFileName: pathname)
		ifTrue: 
			[self isChanged: true.
			"If a package is renamed, then the dependent packages need to be resaved to update their pre-requisite information"
			self dependentPackages do: [:each | each isChanged: true]]!

packageFolder
	^File splitPathFrom: self packagePathname!

packagePathname
	^packagePathname!

packagePathname: aString
	"Private - Set the receiver's path and name. Answer whether the name was changed."

	| oldname |
	packagePathname := aString.
	"The name cannot be independent of the file name, and is in fact just cached from the file stem"
	oldname := name.
	name := File splitStemFrom: aString.
	^oldname isNil or: [(oldname sameAs: name) not]!

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

preDeclareClassesOnLoad
	"Answer whether Package loading from a .pax should, by default, declare classes before loading any code. See the class side implementation of this message for further details."

	^preDeclareClassesOnLoad ifNil: [self class preDeclareClassesOnLoad]!

preDeclareClassesOnLoad: aBoolean
	preDeclareClassesOnLoad == aBoolean
		ifFalse: 
			[preDeclareClassesOnLoad := aBoolean.
			self isChanged: true]!

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

propertyAt: aSymbol ifAbsent: aBlock
	"Answers a property value of the receiver whose name matches aSymbol. If the object
	does not have such a property then aBlock is evaluated."

	^properties
		ifNil: [aBlock value]
		ifNotNil: 
			[properties
				propertyOf: self
				at: aSymbol
				ifAbsent: aBlock]!

propertyManager
	^properties ifNil: [properties := PropertyManager new]!

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

removeClassName: aSymbol
	classNames remove: aSymbol!

removeGlobalNamed: globalName
	"Remove globalName from the list of globals owned by the receiver.
	Answer globalName."

	self manager addGlobalNamed: globalName to: nil.
	^globalName!

removeLooseMethod: aCompiledMethod
	"Private - Remove the <CompiledMethod> argument which is directly owned by the receiver
	(i.e. a loose method) from this package. Do not fire any events."

	self assert: [(self includesClass: aCompiledMethod methodClass) not].
	self removeMethodNames: {self nameForMethod: aCompiledMethod}!

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

	#(#allResourceNames #binaryGlobalNames #globalAliases #paxVersion) 
		do: [:each | self removePropertyAt: each ifAbsent: []].
	changeIndex := nil!

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

	^self allResourceIdentifiers!

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

setPackageFileName: aString
	^self packagePathname: (FileLocator imageRelative
				relativePathTo: (File default: aString extension: self class packageExtension))!

setPrerequisites: aCollectionOfStrings
	"Private - Set the pre-computed pre-requisites of the receiver to specified Set of package names. 
	**Note that this is sent from the chunks which define a package in .PAC and .PAX files
	and should not be deleted**."

	prerequisiteNames := aCollectionOfStrings!

shrink
	properties ifNotNil: [properties register isEmpty ifTrue: [properties := nil]]!

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

timestamp: anObject
	timestamp := anObject!

trace: trace prerequisite: aPackage from: from to: to type: type
	"Private - Append the supplied details of a prerequisite link
	to trace."

	aPackage == self ifTrue: [^self].
	(trace at: (aPackage ?? _Uncommitted) ifAbsentPut: [OrderedCollection new: 16])
		addLast: {from. to. type}!

tracePrerequisiteGlobals: trace packagedGlobals: globalLookup
	"Private - Trace the prerequisites of the receiver that come about because of
	references to globals from methods."

	self allMethodsDo: 
			[:aMethod |
			aMethod literalReferencesDo: 
					[:literal |
					| global |
					global := self globalNameOfLiteral: literal.
					global notNil
						ifTrue: 
							[| prereq |
							prereq := globalLookup lookup: global.
							self
								trace: trace
								prerequisite: prereq
								from: aMethod
								to: global
								type: 'references global']]]!

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
	trace := IdentityDictionary new: 16.
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
	self classesDo: 
			[:aClass |
			| base prereq |
			base := aClass superclass.
			"Have to account specially for subclasses of nil to avoid dependency on _Uncommitted"
			prereq := base isNil ifTrue: [manager systemPackage] ifFalse: [manager packageOfClass: base].
			self
				trace: trace
				prerequisite: prereq
				from: aClass
				to: base
				type: 'is a subclass of'.

			"Look for references to pool dictionaries"
			aClass sharedPoolNames do: 
					[:poolName |
					self
						trace: trace
						prerequisite: (globalLookup lookup: poolName)
						from: aClass
						to: poolName
						type: 'uses the shared pool']]!

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
	self methodsDo: 
			[:each |
			self
				trace: trace
				prerequisite: (manager packageOfClass: each methodClass)
				from: each
				to: each methodClass
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

	| classes |
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
	classes do: 
			[:aClass |
			(aClass environment includesKey: aClass name)
				ifFalse: 
					[aClass class methodDictionary: nil.
					aClass methodDictionary: nil]]!

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
			(self methodFromName: methodName ifAbsent: [])
				ifNotNil: [:method | method methodClass removeSelector: method selector]]!

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

	self setPackageFileName: (File
				composePath: self path
				stem: self name
				extension: self class packageExtension).
	"The prereqs may be out of date due to changes since last load, also the pre-reqs set at package load time
	include relative paths, so just toss them away"
	prerequisiteNames := nil!

validate
	"Private - Validate the internal structure repairing any errors"

	methodNames := self methodNames select: [:each | (self methodFromName: each ifAbsent: []) notNil].
	methodNames isEmpty ifTrue: [methodNames := nil]!

variableSortBlock
	"Private - Answer a <dyadicValuable> sort block suitable for sorting global variable <Association>s
	into alphabetic order."

	^[:a :b | (a key <==> b key) <= 0]!

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
!Package categoriesForMethods!
about!commands!public! !
aboutBlock!accessing!public! !
aboutBlock:!accessing!public! !
aboutBlockBytes:!accessing!private! !
addAllPrerequisitesTo:!accessing!private! !
addClass:!adding!public! !
addGlobalNamed:!adding!public! !
addLooseMethod:!adding!private! !
addMethod:!adding!public! !
addPackagedMethod:!adding!private! !
addResourceIdentifier:!adding!public! !
allDependentPackages!accessing!public! !
allMethods!accessing!public! !
allMethodsDo:!enumerating!private! !
allPrerequisites!accessing!private! !
allResourceIdentifiers!accessing!public! !
allResourceNames!accessing!public! !
allResourceNames:!private!source filing! !
allSourceObjects!accessing!public!source filing! !
allSourceObjectsDo:!enumerating!public!source filing! !
basicAddClass:!adding!private! !
basicAddGlobalNamed:!adding!private! !
basicComment:!accessing!private! !
basicPackageVersion:!accessing!private! !
basicRemoveClass:!private!removing! !
basicRemoveGlobalNamed:!private!removing! !
basicScriptAt:put:!accessing!private! !
behaviorFromName:ifAbsent:!mapping!private! !
behaviors!enumerating!public! !
behaviorsDo:!enumerating!public! !
binaryGlobalNames!accessing!private! !
binaryGlobalNames:!accessing!private! !
binaryGlobalVariables!private!source filing! !
buildPrerequisiteNames!helpers!private! !
calculatePrerequisites!operations!private! !
canShowAbout!public!testing! !
changedFrom:!public!source filing! !
changeIndex!accessing!development!private! !
changeIndexValue:!accessing!development!private! !
classDefinitionsFileName!constants!private! !
classes!enumerating!public! !
classesDo:!enumerating!public! !
classesInHierarchyOrder!enumerating!private! !
classFromName:!mapping!private! !
classFromName:ifAbsent:!mapping!private! !
classNames!accessing!public! !
comment!accessing!public! !
comment:!accessing!public! !
declareClasses!helpers!private! !
declareGlobals!helpers!private! !
dependentPackages!accessing!public! !
depthOfClass:!helpers!public! !
displayOn:!displaying!public! !
environment!constants!private! !
errorFileCorrupt!exceptions!private! !
fileInClasses!development!private!source filing! !
fileInScript:!private!source filing! !
fileNameForBinaryGlobal:!mapping!private! !
fileNameForSourceGlobal:!mapping!private! !
fileOutName!public!source filing! !
getEvents!events!private! !
getPrerequisites!enumerating!private! !
globalAliases!private!source filing! !
globalAliases:!accessing!private! !
globalAliasVariables!accessing!private!source filing! !
globalFromName:!mapping!private! !
globalNameOfLiteral:!enumerating!private! !
globalNames!accessing!public! !
globals!accessing!private! !
globalVariables!private!source filing! !
hasCyclicPrerequisites!private!testing! !
hasCyclicPrerequisites:safe:!private!testing! !
hasUncommittedPrerequisites!private!testing! !
hierarchyOrderOfClasses:!helpers!private! !
imageStripper:!accessing!public! !
imageStripperBytes!accessing!private! !
imageStripperBytes:!accessing!private! !
includesClass:!public!searching! !
includesGlobalNamed:!public!searching! !
includesMethod:!public!searching! !
includesResourceIdentifier:!private!searching! !
initialize!initializing!private! !
initializeClasses!initializing!private! !
initializeGlobals!initializing!private! !
initializeLegacyResources!helpers!private! !
initializeOldSourcePackage!private!source filing-pax! !
isBaseImagePackage!public! !
isBasePackage!public! !
isChanged!development!public!source filing!testing! !
isChanged:!public!source filing! !
isDefaultPackage!public!testing! !
isGlobalAlias:!private!testing! !
isImportedClass:!private!testing! !
isInstalled!public!testing! !
isSourceGlobal:!private!testing! !
isSystemPackage!public!testing! !
load!operations!private! !
loadBinaryGlobals!binary filing!private! !
loadPAC!private!source filing! !
loadPAC:!private!source filing! !
loadPAX!private!source filing-pax! !
looseResourceIdentifiers!accessing!public! !
looseResourceIdentifiersDo:!enumerating!public! !
manager!accessing!public! !
manualPrerequisites!accessing!public! !
manualPrerequisites:!accessing!public! !
membershipChanged!event handling!private! !
membershipChangedAt:!helpers!private! !
memberUpdatedAt:!event handling!private! !
methodFromName:ifAbsent:!mapping!private! !
methodNames!accessing!public! !
methods!enumerating!public! !
methodsDo:!enumerating!public! !
methodsOfClass:!enumerating!public! !
name!accessing!public! !
nameForMethod:!mapping!private! !
nameForResourceIdentifier:!mapping!private! !
okToSaveOrDeploy!helpers!private! !
okToUninstall!helpers!private! !
onClassRemoved:!event handling!private! !
onClassRenamed:from:to:!event handling!private! !
onGlobalRenamed:from:!event handling!private! !
owningPackage!public!source filing! !
packageFileName!accessing!public! !
packageFileName:!accessing!private! !
packageFolder!instance creation!public! !
packagePathname!accessing!private! !
packagePathname:!accessing!private! !
packageVersion!accessing!public! !
packageVersion:!accessing!public! !
path!accessing!public! !
paxVersion!accessing!private! !
paxVersion:!accessing!private! !
preDeclareClassesOnLoad!accessing!public! !
preDeclareClassesOnLoad:!accessing!public! !
prerequisiteNames!accessing!private! !
prerequisites!enumerating!public! !
printOn:!printing!public! !
privateUninstall!private!removing! !
propertyAt:ifAbsent:!properties!public! !
propertyManager!private!properties! !
rebaseTo:!public!testing! !
remainingClasses!accessing!public! !
removeClass:!public!removing! !
removeClassName:!private!removing! !
removeGlobalNamed:!public!removing! !
removeLooseMethod:!private!removing! !
removeMethod:!public!removing! !
removeMethodNames:!event handling!private! !
removePackagedMethod:!private!removing! !
removePAXProperties!operations!private! !
renameLooseMethodsOf:to:!event handling!private! !
resetChangeFlags!public!source filing! !
resetPrerequisites!operations!private! !
resourceIdentifiers!accessing!public! !
scriptAt:!accessing!public! !
scriptAt:put:!accessing!public! !
scripts!accessing!private! !
setEvents:!events!private! !
setManualPrerequisites:!accessing!private! !
setPackageFileName:!accessing!private! !
setPrerequisites:!accessing!private! !
shrink!private! !
sourceDescriptor!accessing!private! !
sourceDescriptor:!accessing!private! !
sourceGlobalNames!accessing!private! !
sourceGlobalVariables!accessing!private! !
sourceManager!accessing!public! !
stbSaveOn:!binary filing!public! !
storeComment!helpers!private! !
synchronizeNames!helpers!private! !
systemGlobalRenamed:to:!event handling!private! !
timestamp!accessing!public! !
timestamp:!accessing!private! !
trace:prerequisite:from:to:type:!helpers!private! !
tracePrerequisiteGlobals:packagedGlobals:!operations!private! !
tracePrerequisites!operations!private! !
tracePrerequisites:!operations!private! !
tracePrerequisitesOfClasses:packagedGlobals:!operations!private! !
tracePrerequisitesOfGlobals:packagedGlobals:!operations!private! !
tracePrerequisitesOfImageStripper:!operations!private! !
tracePrerequisitesOfMethods:!operations!private! !
uninstall!public!removing! !
uninstallClasses!class hierarchy-removing!private!removing! !
uninstallGlobals!private!removing! !
uninstallMethods!private!removing! !
untracedGlobals!accessing!public! !
untracedGlobals:!accessing!public! !
upateFileNames!operations!private! !
validate!operations!private! !
variableSortBlock!constants!private! !
versionIfRequired!public! !
vmVersionCheck:!constants!private! !
!

!Package class methodsFor!

binaryGlobalExtension
	"Private - Answer the file extension for the files to which binary globals are stored."

	^ 'stb'!

binaryPacLoader: aDyadicValuable
	BinaryPacLoader := aDyadicValuable!

clashSignal
	"Private - Answer the <Signal> which is raised should overlapping/clashing membership
	be detected when attempting to install a package."

	^ClashSignal!

defaultSortBlock
	^[:a :b | a name < b name]!

errorInvalidPACFile: pathString 
	"Private - Raise an <Error> to the effect that the file with the specified path is
	not a valid .PAC file."

	^self error: ('Invalid PAC file: <1s>' expandMacrosWith: pathString)!

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
	answer setPackageFileName: pathname.
	^answer!

fromPACFile: pathname
	"Private - Answer a new instance of the receiver created from the .PAC file at the
	specified <readableString> path, pathname, or raise an error if the file does not contain a
	package."

	| pacStream answer |
	pacStream := FileStream read: pathname text: true.
	answer := 
			[(STBInFiler peekForSignatureIn: pacStream)
				ifTrue: 
					[pacStream close.
					pacStream := FileStream read: pathname text: false.
					self binaryReadFrom: pacStream]
				ifFalse: [self readFrom: pacStream]]
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

initialize
	"Private - Initialize the receiver's class variables.
		Package initialize
	"

	_Uncommitted := self basicNew
				initialize;
				packagePathname: '<Unpackaged>';
				yourself.
	ClashSignal := Signal resumableDescription: 'Package contents clash'.
	UnsaveableSignal := Signal
				description: 'Package cannot be saved (check for cyclic dependencies or unpackaged prereqs)'.
	CheckTimestamps := true.
	BinaryPacLoader := nil!

manager
	"Answer the object responsible for managing the collection of installed packages."

	^PackageManager current!

name: nameString
	"Answer a new instance of the receiver with the <readableString> name, nameString."

	^self new
		setPackageFileName: nameString;
		yourself
!

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

preDeclareClassesOnLoad
	"Answer whether Package loading from a .pax should, by default, declare classes before loading any code. This is generally not necessary except in circumstances where one or more of the source globals in the package as dependencies on classes in the package, or where classes in the package are being used in the role of pool dictionaries by other classes in the package. However, the historic behaviour was to declare classes, so for the time being this is still on by default. The setting can either be changed globally (i.e. `Package declareClassesOnLoad: false`) or for individual packages using the `preDeclareClassesOnLoad` property on the instance side. If the property is set, then it will be persisted to the package file and respected by future loads. In the next major release of Dolphin, this property will default to 'false'. The reason for this is that pre-declaration is relatively expensive (causing a class mutation when the actual class declaration is subsequently loaded), and so worth avoiding when not required."

	^PreDeclareClassesOnLoad ?? true!

preDeclareClassesOnLoad: aBoolean
	PreDeclareClassesOnLoad := aBoolean!

readFrom: pacStream
	"Private - Answer a new instance of the receiver created from the .PAX (source 
	text) format representation in the <readableStream>, pacStream."

	| chunk |
	chunk := (ChunkSourceFiler on: pacStream) nextChunk.
	^Compiler evaluate: chunk!

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
	^anArray!

stbConvertFromVersion6: anArray 
	"Private - Convert version 6 to 7: Adds changeIndex and paxVersion instance variables."

	| newPackage |
	"Last converter in the chain"
	newPackage := self new.
	anArray keysAndValuesDo: [:eachKey :eachValue | newPackage instVarAt: eachKey put: eachValue].
	^newPackage!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^7!

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
!Package class categoriesForMethods!
binaryGlobalExtension!constants!private! !
binaryPacLoader:!accessing!private! !
clashSignal!constants!private! !
defaultSortBlock!constants!public! !
errorInvalidPACFile:!exceptions!private! !
errorInvalidPAXFile:!exceptions!private! !
fromFile:!instance creation!private! !
fromPACFile:!instance creation!private! !
fromPAXFile:!instance creation!private! !
initialize!initializing!private! !
manager!accessing!public! !
name:!instance creation!public! !
new!instance creation!public! !
onPreStripImage!class hierarchy-removing!private! !
packageExtension!constants!private! !
packageFileVersion!constants!public! !
paxVersion!constants!private! !
preDeclareClassesOnLoad!accessing!public! !
preDeclareClassesOnLoad:!accessing!public! !
readFrom:!instance creation!private! !
sourceGlobalExtension!constants!private! !
sourcePackageExtension!constants!private! !
stbConvertFrom:!binary filing!public! !
stbConvertFromVersion0:!binary filing!private! !
stbConvertFromVersion1:!binary filing!private! !
stbConvertFromVersion2:!binary filing!private! !
stbConvertFromVersion3:!binary filing!private! !
stbConvertFromVersion4:!binary filing!private! !
stbConvertFromVersion5:!binary filing!private! !
stbConvertFromVersion6:!binary filing!private! !
stbVersion!binary filing!public! !
uncommitted!accessing!public! !
uninitialize!class hierarchy-removing!private! !
unsaveableSignal!constants!private! !
!

