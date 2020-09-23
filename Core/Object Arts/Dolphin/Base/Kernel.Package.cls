"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Kernel.Package'
	instanceVariableNames: 'name packagePathname comment classNames methodNames variableNames prerequisiteNames events scripts doNotReuse imageStripperBytes aboutBlock packageVersion manualPrerequisites timestamp untracedVariables changeIndex properties preDeclareClassesOnLoad'
	classVariableNames: '_Uncommitted BinaryPacLoader ChangedIcon CheckTimestamps ClashSignal PreDeclareClassesOnLoad SourcePackageIcon UnsaveableSignal'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Package guid: (Core.GUID fromString: '{87b4c4a6-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.Package comment: ''!
!Kernel.Package categoriesForClass!Development! !
!Kernel.Package methodsFor!

about
	"Displays an about screen for the receiver using the aboutBlock if any has been set."

	self aboutBlock notNil ifTrue: [self aboutBlock value: self]!

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

	aboutBlock := Object fromBinaryStoreBytes: aByteArray!

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

addLooseMethod: method
	"Private - Add the <CompiledMethod>, method, to the set of loose methods
	owned by the receiver."

	self assert: [(self includesClass: method methodClass) not].
	self methodNames add: method name!

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

	method methodClass methodChanged: method!

addResourceIdentifier: rid
	"Add the <ResourceIdentifier>, rid, to the list of resources owned by the
	receiver. Answer the argument."

	self manager addResourceIdentifier: rid to: self.
	^rid!

addVariableNamed: aBindingReference
	"Add the named shared variable to those owned by the receiver. Answer a <BindingReference> for the named variable."

	^self manager addVariableNamed: aBindingReference to: self!

aliasVariableNames
	"Private - Answer a <collection> of <Symbol>s, being the names of global variables owned by the receiver that are just aliases to other globals."

	^self variableNames select: [:var | self isAlias: var]!

allDependentPackages
	"Answer a <collection> of the packages which are directly dependant on the receiver."

	^self manager allDependentPackagesOf: self visited: Set new!

allMethods
	"Answer an <IdentitySet> of all the <CompiledMethod>s directly owned by
	the receiver or by owning the class in which it is situated."

	| answer |
	answer := IdentitySet new: classNames size * 20.	"On average, about 10 methods per behaviour"
	self allMethodsDo: [:m | answer add: m].
	^answer!

allMethodsDo: aMonadicValuable
	"Private - Evaluate the <monadicValuable>, operation, for Answer an <IdentitySet> of all the <CompiledMethod>s 
	directly owned by the receiver or by owning the class in which it is situated."

	| loose |
	loose := self manager looseMethods.
	self behaviorsDo: 
			[:eachBehavior |
			eachBehavior methodDictionary do: ((loose lookup: eachBehavior)
						ifNil: [aMonadicValuable]
						ifNotNil: 
							[:selectors |
							[:eachMethod | (selectors includesKey: eachMethod selector) ifFalse: [aMonadicValuable value: eachMethod]]])].

	"Finally evaluate the operation for all the package's own loose methods"
	self methodsDo: aMonadicValuable!

allPrerequisites
	"Private - Answer a collection of all the Packages objects which must be loaded in before the
	receiver may be loaded in."

	| answer |
	answer := IdentitySet new.
	self addAllPrerequisitesTo: answer.
	^answer!

allResourceIdentifiers
	"Answer a Set of all the ResourceIdentifiers directly owned by
	the receiver or by owning the class in which it is situated."

	| resources |
	resources := Set new.
	self classesDo: [:each | each resourceIdentifiersDo: [:eachResId | resources add: eachResId]].
	self looseResourceIdentifiersDo: [:each | resources add: each].
	^resources!

allResourceNames
	"Private - Answer a <Collection> of all the resource names directly owned by the receiver or by its owned classes."

	^self propertyAt: #allResourceNames ifAbsent: [^OrderedCollection new]!

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
	self sourceVariableNames do: [:each | operation value: each value].
	"Note that the package itself is always enumerated last - this is important"
	operation value: self!

basicAddClass: aClass
	"Private - Add aClass to the list of classes owned by the receiver. A class can only be owned by a single package. Answer aClass. Note that it is assumed that the class is _not_ currently packaged. To correctly add a class regardless of packaging use PackageManager>>addClass:to:"

	"ignore any methods of aClass which we own as they are included by our new ownership of aClass"

	(self methods
		select: [:aMethod | aMethod methodClass == aClass or: [aMethod methodClass == aClass class]])
			do: [:method | self removeLooseMethod: method].
	classNames add: aClass fullyQualifiedReference.

	"Although the class hasn't changed in itself, it will need to be filed out to its new location, if using .PAX format"
	aClass isChanged: true.
	^aClass!

basicAddVariableNamed: aBindingReference
	"Private - Include the variable referenced by the <BindingReference> argument in those owned by the receiver. Answer the argument.
	 Note that it is assumed that the variable is _not_ currently packaged. To correctly add a class regardless of packaging use the PackageManager."

	| binding |
	variableNames add: aBindingReference.

	"The global's value has not changed, but it may now need filing out to a new location"
	binding := aBindingReference value.
	(self isSourceObject: binding) ifTrue: [binding isChanged: true].
	^aBindingReference!

basicComment: aString
	"Private - Set the comment of the receiver."

	comment := aString!

basicPackageVersion: aString
	"Private - Sets the package version identification to aStringOrNil."

	packageVersion := (aString isNil or: [aString isEmpty]) ifFalse: [aString]!

basicRemoveClass: aClass
	"Private - Remove aClass from the list of Classes owned by the receiver.
	Answer aClass."

	self removeClassName: aClass fullyQualifiedReference.
	^aClass!

basicRemoveVariableNamed: aBindingReference
	"Private - Remove the <BindingReference> from the list of variables owned by the receiver.
	Answer the argument."

	variableNames remove: aBindingReference ifAbsent: [].
	^aBindingReference!

basicResetPrerequisites
	"Private - Mark that the prerequisite packages for the receiver have changed. The packages will be recalculated the next time the #prerequsiteNames accessor is sent."

	prerequisiteNames := nil!

basicScriptAt: scriptSymbol put: aString 
	"Private - Set the script String associated with scriptSymbol."

	scripts := self scripts.
	aString isEmpty 
		ifTrue: 
			[scripts removeKey: scriptSymbol ifAbsent: [].
			scripts isEmpty ifTrue: [scripts := nil]]
		ifFalse: [scripts at: scriptSymbol put: aString]!

behaviorFromName: aBindingReference ifAbsent: exceptionHandler
	| index |
	index := aBindingReference identityIndexOf: $\x20.
	^index == 0
		ifTrue: [self classFromName: aBindingReference ifAbsent: exceptionHandler]
		ifFalse: 
			[(self classFromName: (aBindingReference copyFrom: 1 to: index - 1) ifAbsent: [])
				ifNil: [exceptionHandler value]
				ifNotNil: [:class | class class]]!

behaviors
	"Answer an <IdentitySet> of the <Behavior>s owned by the receiver."

	| answer |
	answer := IdentitySet new: (classNames size + 1) * 2.	"Avoid need to grow set by presizing"
	self behaviorsDo: [:b | answer add: b].
	^answer!

behaviorsDo: operation
	"Evaluate the monadicValuable, operation, for each and every <Behavior> owned
	by the receiver."

	self classesDo: [:aClass | operation value: aClass; value: aClass class].
!

binaryGlobalNames: aCollectionOfSymbols
	"Private - Used in pre-v2 packages to set the symbolic names of binary variables owned by the package in the system dictionary.
	We will convert these at version upgrade time to BindingReferences."

	aCollectionOfSymbols notEmpty ifTrue: [self setBinaryVariableNames: (aCollectionOfSymbols collect: [:each | each asQualifiedReference])]!

binaryVariableNames
	"Private - Answer a <Collection> of <BindingReference>s, being the names of all binary global variables in this package."

	^self variableNames reject: [:e | self isSourceObject: e value]!

bindingRefToLiteral: anObject
	"Private - Answer a <BindingRef> to the argument, anObject, extracted from a CompiledMethods literal frame, or nil if it is not a bindable object."

	^(anObject isKindOf: VariableBinding)
		ifTrue: 
			["For class variables the dependency is on the class owning the variable, not the referenced thing"
			anObject isClassVariable
				ifTrue: [anObject environment fullyQualifiedReference]
				ifFalse: 
					[| ref |
					ref := anObject fullyQualifiedReference.
					ref bindingOrNil == anObject ifTrue: [ref]]]
		ifFalse: 
			[anObject class isMeta
				ifTrue: 
					[| ref |
					ref := anObject fullyQualifiedReference.
					ref bindingOrNil ifNotNil: [ref]]]!

buildPrerequisiteNames
	"Private - Calculate the names of the receiver's prerequisite packages."

	| prereqs |
	prereqs := Set new.
	self calculatePrerequisites do: [:each | prereqs add: each name].
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

	^File
		composePath: self path
		stem: self name , 'Classes'
		extension: 'st'!

classes
	"Answer a Set of the Classes owned by the receiver."

	^classNames collect: [:className | self classFromName: className]!

classesDo: operation 
	"Evaluate the <monadicValuable>, operation, for each of the classes owned by the receiver. 
	Note that this does not include the classes of the receiver's loose methods."

	^classNames do: [:each | operation value: each value]!

classesInHierarchyOrder
	"Private - Answer an <sequencedReadableCollection> of the
	receiver's ownded classes in the order that they would be
	visited by a depth-first traversal of the class hierarchy."

	^self hierarchyOrderOfClasses: self classes!

classFromName: className
	"Private - Answer the Class object which className encodes.

	See Package>>nameForClass: for the reverse transformation."

	^className asQualifiedReference value!

classFromName: aSymbol ifAbsent: aNiladicValuable
	"Private - Answer the Class object to which aSymbol refers, or if not defined the result of evaluating aNiladicValuable."

	^aSymbol asQualifiedReference valueOrDo: aNiladicValuable!

classNames
	"Answer a <collection> of <BindingReference>s naming all the classes owned by the receiver."

	^classNames!

classNames: anObject
	classNames := anObject!

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

convertOldMethodNames
	| names classes |
	(methodNames notNil and: [methodNames notEmpty and: [methodNames anyOne isKindOf: Association]])
		ifFalse: [^self].
	classes := Set new.
	names := Set new: methodNames size.
	methodNames do: 
			[:each |
			| parts className |
			parts := each key subStrings.
			className := classes addIfAbsent: (BindingReference pathString: parts first).
			parts size > 1 ifTrue: [className := classes addIfAbsent: className meta].
			names add: (MethodName className: className selector: each value)].
	methodNames := names!

convertOldNames: aCollectionOfSymbols
	^aCollectionOfSymbols
		ifNotNil: 
			[| refs |
			refs := Set new: aCollectionOfSymbols size.
			aCollectionOfSymbols do: [:each | refs add: each asQualifiedReference].
			refs]!

convertOldNamesProperty: aSymbol
	(self propertyAt: aSymbol ifAbsent: [])
		ifNotNil: 
			[:names |
			| aCollectionOfBindingReferences |
			aCollectionOfBindingReferences := self convertOldNames: names.
			self propertyAt: aSymbol put: aCollectionOfBindingReferences]!

convertPoolDictionariesToSharedPools
	#{PoolDictionary} ifDefined: 
			[:pcClass |
			(self variableNames select: [:each | each valueOrNil isKindOf: pcClass]) do: 
					[:each |
					| poolClass |
					poolClass := each value convertToSharedPool.
					self basicRemoveVariableNamed: each.
					classNames add: poolClass fullyQualifiedReference]]!

declareClasses
	"Private - Predefine global variables for each of the classes in the package prior to those classes
	being loaded. Only required for PAX (not PAC) loading"

	(self classNames reject: [:each | each isDefined]) do: 
			[:each |
			Object
				subclass: each
				instanceVariableNames: ''
				classVariableNames: ''
				imports: #()]!

declareVariable: aBindingReference
	| namespace path |
	namespace := Namespace baseEnvironment.
	path := aBindingReference path.
	1 to: path size - 1
		do: 
			[:i |
			| identifier |
			identifier := path at: i.
			namespace := (namespace localBindingFor: identifier)
						ifNil: 
							[| baseClass subNs |
							baseClass := (namespace == Root or: [namespace == Smalltalk])
										ifTrue: [Namespace]
										ifFalse: [namespace].
							subNs := baseClass
										subclass: (namespace fullNameFor: identifier)
										instanceVariableNames: ''
										classVariableNames: ''
										imports: #().
							subNs owningPackage: self.
							subNs]
						ifNotNil: [:binding | binding value]].
	^aBindingReference declare!

declareVariables
	"Private - Create bindings for each of the shared variables in the package prior to those variable values being loaded. Later (after the classes in the package have been defined - in case the variables are instances of any of those classes) these will be loaded from their individual STB files."

	self variableNames do: [:each | self declareVariable: each]!

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

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: self name!

ensureNamesFullyQualified
	self paxVersion >= 2.1 ifTrue: [^self].
	classNames := classNames collect: [:each | each binding fullyQualifiedReference].
	variableNames := variableNames collect: [:each | each binding fullyQualifiedReference]!

errorFileCorrupt
	"Private - Filing in the receivers owned objects has failed because the
	file is corrupt."

	self error: ('FileIn of <1s> package has failed, file is corrupt' expandMacrosWith: self name)!

evaluateScript: aSymbol source: aString
	| filer |
	filer := self sourceManager chunkFilerOn: aString readStream.
	filer evaluationContext: self.
	[filer fileIn] on: Compiler errorClass
		do: 
			[:x |
			| msg |
			msg := 'Error: Script for <1p> at line <2p>: <3s>'
						expandMacrosWith: aSymbol
						with: x line
						with: x errorMessage.
			Notification signal: msg.
			x
				beep;
				resume]!

fileInClasses
	"Private - Load all packaged classes from external files"

	self classesInHierarchyOrder do: [:each | self sourceManager fileIn: each fileOutName]!

fileInScript: aSymbol
	"Private - 'File in' the named script."

	| aString |
	aString := self scriptAt: aSymbol.
	aString isEmpty ifTrue: [^self].

	"If the AnonymousClassBuilder is defined, then create an anonymous package class in which to run the script. This allows us to load legacy scripts with Smalltalk on the binding path so that legacy class names will be found. The alternative would be to compile the script in the context of a class in Smalltalk, but we want 'self' in the script to be this package."
	#{AnonymousClassBuilder} ifDefined: 
			[:builder |
			| originalClass anon |
			originalClass := self class.
			anon := (builder new
						superclass: originalClass;
						yourself) createNewClass.
			anon setName: nil environment: Smalltalk.
			
			[self becomeA: anon.
			self evaluateScript: aSymbol source: aString]
					ensure: [self becomeA: originalClass]]
		ifNotDefined: [self evaluateScript: aSymbol source: aString]!

fileNameForBinaryVariable: globalName
	"Private - Answer a filename for storing the binary globalName."

	^File
		composePath: self path
		stem: globalName asString
		extension: self class binaryVariableExtension!

fileNameForSourceGlobal: globalName
	"Private - Answer a filename for storing the source globalObject."

	^File
		composePath: self path
		stem: globalName asString
		extension: self class sourceGlobalExtension!

fileOutName
	"Answer the pathname used to store the PAX file for the sources of the receiver"

	^File
		composePath: self path
		stem: self name
		extension: self class sourcePackageExtension!

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

globalAliases: aCollectionOfSymbols
	"Private - Pre-v2 packages used this setter to initialize the names of all variables owned by this package when reading the package description.
	This is only used during legacy package loading. The names will be translated to binding references during the later version upgrade."

	self propertyAt: #aliasVariables put: aCollectionOfSymbols!

globalNames
	"Pre-v2 packages use this accessor to add the Symbolic names of variables in the system dictionary when reading the package description.
	We return the variableNames collection, which will be patched up by the version upgrade to convert the Symbols to BindingReferences."

	^variableNames!

hasCyclicPrerequisites
	"Private - Answer whether any of the receivers prerequisites or their
	prerequisites are cyclic. So two packages rely on each other to be
	loaded before they can be loaded. The package system does not currently
	handle this smoothly though it is possible to load in such a thing by
	repeatedly trying to load in all packages until it works..."

	^self hasCyclicPrerequisites: IdentitySet new safe: IdentitySet new!

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

	^Smalltalk allClasses intersection: aCollection!

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
	"Answer whether the receiver owns aClass. aClass's metaclass is automatically owned as well."

	^(self includesClassNamed: aClass asQualifiedReference) and: [(self isImportedClass: aClass) not]!

includesClassNamed: aBindingReference
	^classNames includes: aBindingReference instance!

includesMethod: aCompiledMethod
	"Answer whether the receiver owns aMethod."

	^methodNames notNil and: 
			[(self isImportedClass: aCompiledMethod methodClass) not
				and: [methodNames includes: aCompiledMethod name]]!

includesResourceIdentifier: aResourceIdentifier 
	"Private - Answer whether the receiver directly owns aResourceIdentifier.
	Implementation Note: Avoid the lookup in the table of imported classes if
	possible, as that is a relatively expensive operation."

	^aResourceIdentifier owningPackage == self 
		and: [(self isImportedClass: aResourceIdentifier owningClass) not]!

includesVariableNamed: aBindingReference
	"Answer whether the receiver owns the named shared variable."

	^self variableNames includes: aBindingReference asQualifiedReference!

initialize
	"Private - Initialize the state of the receiver."

	classNames := Set new.
	timestamp := 0.
	variableNames := Set new!

initializeClasses
	"Private - Initialize all loaded classes."

	self classesInHierarchyOrder do: [:aClass | aClass initializeAfterLoad]!

initializeGlobals
	"Private - Initialize all globals (including classes) that require it."

	self initializeClasses.
	self variableNames do: 
			[:each |
			each valueOrNil
				ifNotNil: [:value | (value respondsTo: #initializeAfterLoad) ifTrue: [value initializeAfterLoad]]].
	(self propertyAt: #variableAliases ifAbsent: [#()]) do: 
			[:each |
			| target |
			target := each value.
			target class isMeta ifTrue: [ClassLocator addAlias: each asSymbol forClass: target]]!

initializeLegacyResources
	"Private - For old (pre-D6) packages, we have to make sure that the resources loaded by this package actually
	below to it. Obviously, those resources that already belong to classes in the package will be ok, so really
	we are only concerned with loose resources"

	self allResourceNames do: 
			[:each |
			| rid |
			rid := UI.ResourceIdentifier class: each key asQualifiedReference value name: each value.
			rid owningPackage == self ifFalse: [self manager addLooseMethod: rid compiledMethod to: self]]!

initializeOldSourcePackage
	(self respondsTo: #loadLegacyResources) 
		ifTrue: [self perform: #loadLegacyResources]
		ifFalse: [self error: 'Unable to load package (Legacy package importer is not loaded)']	"Initialize old style (pre D6) binary resources"!

isAlias: aBindingReference
	| target |
	target := aBindingReference value.
	^(self isSourceObject: target) and: [aBindingReference ~= target fullyQualifiedReference]!

isBasePackage
	"Answer true if the receiver is a basic component of Dolphin. This is usually an indication that
	it was present at the time the image was booted and may be used as a hint that
	you may not need to version the package into an external repository such as STS."

	^self class manager basePackages includes: self!

isChanged
	"Answer true if the receiver or any of it's contents have been changed since their changed flag was last reset."

	^self changeIndex notNil!

isChanged: aBoolean
	"Set the changed flag for the receiver to aBoolean"

	self isChanged = aBoolean ifTrue: [^self].
	self changeIndexValue: (aBoolean ifTrue: [[Package sourceManager changesFileSize]]).
	self trigger: #changed!

isDefaultPackage
	"Answer whether the receiver is the default package to which all newly defined classes and methods are added."

	^self manager defaultPackage == self!

isImportedClass: aClass
	"Private - Answer true if aClass is an imported binary class"

	^ClassLocator isImportedClass: aClass!

isInstalled
	"Answer whether the receiver is currently installed in the system."

	^self manager includesPackage: self!

isSourceObject: anObject
	"Private - Answer true if anObject can be filed out as an external source file"

	^anObject class conformsToProtocol: #sourceObject!

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

loadBinaryVariables
	"Private - Load each of the receiver's binary variables from their individual STB files."

	(self propertyAt: #binaryVariables ifAbsent: [#()]) do: 
			[:each |
			| globalStream |
			globalStream := FileStream read: (self fileNameForBinaryVariable: each) text: false.
			each declare: (Object binaryReadFrom: globalStream).
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
	self declareVariables.

	"File in the definitions of the package's members (pools, classes, methods, globals, resources, etc)"
	filer fileIn.
	self ensureNamesFullyQualified.
	self postLoadInitialization: [self initializeLegacyResources]!

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
	
	[| none |
	"Initialize old style (pre D6) binary resources"
	filer nextChunk.	"Skip the first chunk since it represents the receiver."
	self fileInScript: #preinstall.

	"Define any globals that might be referenced from source code, but don't load them as yet as they
		 may be instances of one of the classes in the package."
	self declareVariables.

	"Optionally declare all classes in the package for the case where classes are referenced by source globals or other class definitions (other than the class hierarchy relationship)"
	self preDeclareClassesOnLoad ifTrue: [self declareClasses].

	"Load source globals"
	none := [#()].
	self variableNames - (self propertyAt: #binaryVariables ifAbsent: none)
		- (self propertyAt: #aliasVariables ifAbsent: none)
			do: [:each | self sourceManager fileIn: (self fileNameForSourceGlobal: each)].

	"Load class definitions, aliases, and loose methods from the remainder of the PAX file"
	filer fileIn.
	self ensureNamesFullyQualified.
	self fileInClasses.
	self loadBinaryVariables.
	self postLoadInitialization: [self initializeOldSourcePackage]]
			ensure: [filer close]!

looseResourceIdentifiers
	| rids |
	rids := Set new.
	self looseResourceIdentifiersDo: [:each | rids add: each].
	^rids!

looseResourceIdentifiersDo: aMonadicValuable
	self methodNames do: 
			[:each |
			(each selector beginsWith: UI.ResourceIdentifier.SelectorPrefix)
				ifTrue: 
					[each className valueOrNil
						ifNotNil: 
							[:methodClass |
							aMonadicValuable
								value: (UI.ResourceIdentifier class: methodClass instanceClass selector: each selector)]]]!

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

methodNames
	"Answer a <Set> of <Association>s, naming the methods owned by the
	receiver. Note that this only includes loose methods that extend classes in other 
	packages, not the name of methods defined in classes owned by this package."

	^methodNames ifNil: [methodNames := Set new]!

methods
	"Answer an <IdentitySet> of the <CompiledMethod>s owned by the receiver."

	| newIdentitySet |
	newIdentitySet := IdentitySet new: self methodNames size.
	self methodsDo: [:each | newIdentitySet add: each].
	^newIdentitySet!

methodsDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the loose methods owned by the receiver."

	self methodNames do: [:each | each valueOrNil ifNotNil: [:method | aMonadicValuable value: method]]!

methodsOfClass: aClass
	"Answer a Collection of the methods of aClass which the receiver either directly owns (as loose methods) or through owning aClass."

	| className |
	className := aClass fullyQualifiedReference.
	^(self includesClassNamed: className)
		ifTrue: 
			[(self manager looseMethods lookup: aClass)
				ifNil: [aClass methodDictionary values]
				ifNotNil: 
					[:loose |
					| all owned |
					"We own the class, so we own all of its methods that are not loose (those belong to other packages)"
					all := aClass methodDictionary.
					owned := IdentitySet new: all size.
					all
						keysAndValuesDo: [:eachSelector :eachMethod | (loose includesKey: eachSelector) ifFalse: [owned add: eachMethod]].
					owned]]
		ifFalse: 
			[| ownedExtensions |
			"Just pick out any loose methods we own in the class"
			ownedExtensions := IdentitySet new.
			self methodNames
				do: [:each | each className = className ifTrue: [ownedExtensions add: each valueOrNil]].
			ownedExtensions]!

name
	"Answer the name of the receiver. This must always be the same as the stem of the package's
	file name, and must be unique amongst all loaded packages in the system."

	^name!

nameForResourceIdentifier: aResourceIdentifier
	"Private - Answer an <Association> that uniquely identifies the <ResourceIdentifier> argument."

	^aResourceIdentifier owningClass name -> aResourceIdentifier name!

okToSaveOrDeploy
	"Private - Prior to saving or deploying the receiver, check that all is consistent and answer whether the
	receiver should be saved. Raise Errors that describe any problems."

	self isSystemPackage ifTrue: [^Smalltalk developmentSystem isOAD].
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

	| className ownedChanged |
	className := aClass fullyQualifiedReference.
	ownedChanged := false.

	"remove any directly owned methods from aClass"
	methodNames
		ifNotNil: 
			[| removed |
			removed := methodNames select: [:methodName | methodName className instance = className].
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

onVariableRenamed: aVariableBinding from: oldName
	"Private - React to oldName global being renamed. Note that this
	is sent only for non-Class globals."

	| names |
	names := self variableNames.
	(names includes: oldName) ifFalse: [^self].
	names
		remove: oldName;
		add: aVariableBinding fullyQualifiedReference.
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

paxVersion: aNumber
	"Private - Temporarily record the PAX format version in which the package being loaded
	was saved. This may be used for loading old format source packages in future."

	self propertyAt: #paxVersion put: aNumber!

postLoadInitialization: aNiladicValuable
	self paxVersion < 2.1 ifTrue: [self updateMethodNamesToFullyQualified].
	self initializeGlobals.
	self paxVersion < 1
		ifTrue: 
			["Load/Initialize old style (pre D6) binary resources"
			aNiladicValuable value].
	self convertPoolDictionariesToSharedPools.
	^self fileInScript: #postinstall!

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

	^prerequisiteNames
		ifNil: 
			["To save time make a special case of the system package"
			self isSystemPackage ifTrue: [Set new] ifFalse: [prerequisiteNames := self buildPrerequisiteNames]]!

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
	"Answer a <collection> of the classes that are still present (i.e. ignore missing classes)"

	^classNames collect: [:each | each valueOrNil]!

removeClass: aClass
	"Remove aClass from the list of Classes owned by the receiver.
	Answer aClass."

	self manager addClass: aClass to: nil.
	^aClass!

removeClassName: aSymbol
	classNames remove: aSymbol!

removeGlobalNamed: globalName
	#deprecated.
	^self removeVariableNamed: globalName!

removeLooseMethod: aCompiledMethod
	"Private - Remove the <CompiledMethod> argument which is directly owned by the receiver
	(i.e. a loose method) from this package. Do not fire any events."

	self assert: [(self includesClass: aCompiledMethod methodClass) not].
	self removeMethodNames: {aCompiledMethod name}!

removeMethod: aCompiledMethod
	"Remove the <CompiledMethod> argument from the list of loose methods owned by  the receiver, and answer that method.
	Note that the method is _not_ being removed from the system, just this package."

	self manager addMethod: aCompiledMethod to: nil.
	^aCompiledMethod!

removeMethodNames: aCollection 
	methodNames removeAll: aCollection.
	methodNames isEmpty ifTrue: [methodNames := nil]!

removePackagedMethod: aCompiledMethod
	"Private - Remove the <CompiledMethod> argument, which is a method of one of the classes
	owned by the receiver (i.e. not a loose method) from this package."

	self assert: [self includesClass: aCompiledMethod methodClass].
	aCompiledMethod methodClass isChanged: true!

removePAXProperties
	"Private - Throw away any info cached to load the package, and make sure not marked as changed"

	#(#allResourceNames #binaryVariables #aliasVariables #paxVersion)
		do: [:each | self removePropertyAt: each ifAbsent: []].
	changeIndex := nil!

removeVariableNamed: aBindingReference
	"Remove the named shared variable from the list of shared variables owned by the receiver.
	Answer a <BindingReference> to the shared variable."

	^self manager addVariableNamed: aBindingReference to: nil!

renameLooseMethodsOf: oldBindingReference to: newBindingReference
	| renamed |
	methodNames ifNil: [^false].
	renamed := methodNames select: [:each | each className instance = oldBindingReference].
	^renamed notEmpty and: 
			[| newMetaRef |
			methodNames removeAll: renamed.
			newMetaRef := newBindingReference meta.
			renamed do: 
					[:each |
					each className: (each className isMeta ifTrue: [newMetaRef] ifFalse: [newBindingReference]).
					methodNames add: each].
			true]!

resetChangeFlags
	self allSourceObjectsDo: [:each | each isChanged: false].
	self isChanged: false!

resetPrerequisites
	"Private - Mark that the prerequisite packages for the receiver have changed. The packages will be recalculated the next time the #prerequsiteNames accessor is sent. An event is triggered iff the pre-reqs are actually reset, in case any tool (such as a PackagePrerequisitesShell) is monitoring them."

	prerequisiteNames isNil ifTrue: [^self].
	self basicResetPrerequisites.
	self trigger: #prerequisitesReset!

resourceIdentifiers
	"Answer a collection of <ResourceIdentifier> objects owned by the receiver."

	^self allResourceIdentifiers!

scriptAt: scriptName 
	"Set the script <String> associated with the <Symbol>, scriptName.

	The currently used scripts are: #preinstall, #postinstall, #preuninstall and
	#postuninstall."

	^self scripts at: scriptName ifAbsent: ['']!

scriptAt: scriptSymbol put: aString
	"Set the script String associated with scriptSymbol."

	self basicScriptAt: scriptSymbol put: aString.
	self isChanged: true.!

scripts
	^scripts ifNil: [IdentityDictionary new]!

setAliasVariableNames: aCollectionOfBindingReferences
	"Private - Record the <Collection> of <BindingReference>s argument as the names of all shared variables in this package. 
	that alias another shared variable. This information is recorded only temporarily during package loading so is stored in a property."

	self propertyAt: #aliasVariables put: aCollectionOfBindingReferences!

setBinaryVariableNames: aCollectionOfBindingReferences
	"Private - Record the <Collection> of <BindingReference>s argument as the names of all binary shared variables in this package. 
	This information is recorded only temporarily during package loading so is stored in a property."

	self propertyAt: #binaryVariables put: aCollectionOfBindingReferences!

setClassNames: aCollectionOfBindingReferences
	"Private - Record the <Collection> of <BindingReference>s as the names of all classes owned by this package."

	classNames := aCollectionOfBindingReferences asSet!

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

setMethodNames: anCollectionOfPairs
	"Private - Record the <Collection> of {<BindingReference>. <Symbol>} pairs as the names of all loose methods owned by this package."

	methodNames := anCollectionOfPairs isEmpty
				ifFalse: 
					[(anCollectionOfPairs collect: [:each | MethodName className: each first selector: each second])
						asSet]!

setPackageFileName: aString
	^self packagePathname: (FileLocator imageRelative
				relativePathTo: (File default: aString extension: self class packageExtension))!

setPrerequisites: aCollectionOfStrings
	"Private - Set the pre-computed pre-requisites of the receiver to specified Set of package names. 
	**Note that this is sent from the chunks which define a package in .PAC and .PAX files
	and should not be deleted**."

	prerequisiteNames := aCollectionOfStrings!

setUntracedVariables: aCollectionOfBindingReferences
	untracedVariables := aCollectionOfBindingReferences
				ifNotNil: [aCollectionOfBindingReferences isEmpty ifFalse: [aCollectionOfBindingReferences asSet]]!

setVariableNames: aCollectionOfBindingReferences
	variableNames := aCollectionOfBindingReferences asSet!

shrink
	properties ifNotNil: [properties register isEmpty ifTrue: [properties := nil]]!

sourceDescriptor
	^comment isInteger ifTrue: [comment]!

sourceDescriptor: anObject
	comment := anObject!

sourceManager
	"Answer the receiver's source manager."

	^self class sourceManager!

sourceVariableNames
	"Private - Answer a <collection> of <BindingReferences>'s, being the shared variables owned by the receiver with values that can be filed out as separate source objects."

	^self variableNames select: [:var | (self isSourceObject: var value) and: [(self isAlias: var) not]]!

stbSaveOn: anSTBOutFiler
	"Output the receiver to anSTBOutFiler. We must ensure that the local events collection
	is NOT saved to the filer"

	anSTBOutFiler override: events with: nil.
	super stbSaveOn: anSTBOutFiler.!

storeComment
	self assert: [comment isKindOf: String].
	self sourceManager storeCommentString: comment forPackage: self!

synchronizeNames
	"Private - Classes in the package may have been renamed (or otherwise refactored) and aliased over, so we want to sync up to the current names."

	methodNames ifNil: [^self].
	methodNames := methodNames collect: 
					[:each |
					each valueOrNil
						ifNil: [each]
						ifNotNil: 
							[:method |
							| currentName |
							currentName := method name.
							currentName = each ifTrue: [each] ifFalse: [currentName]]]!

timestamp
	"Answer a <FILETIME> that represents the last write time of the receiver (i.e. the
	modification time of the file from which the package was loaded, or the time when the
	package was last saved) expressed as the number of 100-nanosecond intervals since 12:00 A.M.
	January 1, 1601 UTC. The <integer> value of the FILETIME will be 0 if the package is new and
	has not been written to disk."

	^FILETIME fromInteger: timestamp!

timestamp: anObject
	timestamp := anObject!

trace: anIdentityDictionary prerequisite: aPackage from: fromObject to: toObject dependency: aString
	"Private - Append the supplied details of a prerequisite link to the trace <IdentityDictionary>, which is keyed by <Package>."

	| targetPackage |
	aPackage == self ifTrue: [^self].
	targetPackage := aPackage ?? _Uncommitted.
	(anIdentityDictionary at: targetPackage ifAbsentPutClean: [OrderedCollection new: 16])
		addLast: {fromObject. toObject. aString. targetPackage}!

tracePrerequisites
	"Private - Answer an IdentityDictionary of prerequisite package keys against an
	OrderedCollection of traces of the owned objects which forced a prerequisite link
	and the reason why. See #tracePrerequisites for further details."

	"Notification signal: 'Tracing prerequisites of ', self name."
	^self tracePrerequisites: self manager packagedVariables!

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
		tracePrerequisitesOfClasses: trace packagedVariables: anIdentityDictionary;
		tracePrerequisitesOfVariables: trace packagedVariables: anIdentityDictionary;
		tracePrerequisitesOfMethods: trace;
		tracePrerequisitesOfImageStripper: trace;
		tracePrerequisitesOfLiterals: trace packagedVariables: anIdentityDictionary.
	^trace!

tracePrerequisitesOfClasses: anIdentityDictionary packagedVariables: aLookupTable
	"Private - Trace the prerequisites of the receiver's owned classes."

	| manager |
	manager := self manager.
	self classesDo: 
			[:aClass |
			| base prereq env |
			base := aClass superclass.
			"Have to account specially for subclasses of nil to avoid dependency on _Uncommitted"
			prereq := base isNil ifTrue: [manager systemPackage] ifFalse: [manager packageOfClass: base].
			self
				trace: anIdentityDictionary
				prerequisite: prereq
				from: aClass
				to: base
				dependency: 'is a subclass of'.
			env := aClass environment ?? Root.
			self
				trace: anIdentityDictionary
				prerequisite: env owningPackage
				from: aClass
				to: env
				dependency: 'is defined in namespace'.
			aClass imports do: 
					[:import |
					import bindingOrNil
						ifNotNil: 
							[:binding |
							self
								trace: anIdentityDictionary
								prerequisite: (manager packageOfVariableNamed: binding fullyQualifiedReference)
								from: aClass
								to: import
								dependency: ((binding value inheritsFrom: SharedPool)
										ifTrue: ['imports the shared pool']
										ifFalse: ['imports the namespace'])]]]!

tracePrerequisitesOfImageStripper: anIdentityDictionary
	"Only possible to trace the stripper prereqs in DPRO"

	| stream hiddenObjects |
	(imageStripperBytes isNil or: [#{ImageStripper} isDefined not]) ifTrue: [^self].
	stream := imageStripperBytes readStream.
	hiddenObjects := 
			[(STBInFiler on: stream)
				basicNext;
				readMap] ensure: [stream close].
	hiddenObjects do: 
			[:each |
			(each class isMeta and: 
					[| imageStripperClass lagoonPackage |
					"We only trace prerequisite objects that are NOT in the
					Lagoon package. After all, we know that Lagoon must be
					present if an ImageStripper is ever loaded into memory"
					imageStripperClass := #{ImageStripper} value.
					lagoonPackage := imageStripperClass owningPackage.
					each owningPackage ~= lagoonPackage])
				ifTrue: 
					[self
						trace: anIdentityDictionary
						prerequisite: each owningPackage
						from: self
						to: each
						dependency: 'references class']]!

tracePrerequisitesOfLiterals: anIdentityDictionary packagedVariables: aLookupTable
	"Private - Trace the prerequisites of the receiver that are from method literals."

	self allMethodsDo: 
			[:eachMethod |
			eachMethod literalReferencesDo: 
					[:eachLiteral |
					(self bindingRefToLiteral: eachLiteral)
						ifNotNil: 
							[:ref |
							self
								trace: anIdentityDictionary
								prerequisite: (aLookupTable lookup: ref)
								from: eachMethod
								to: ref
								dependency: 'references global']]]!

tracePrerequisitesOfMethods: anIdentityDictionary
	"Private - Trace the prerequisite method classes of the receiver's loose methods (i.e. the extended classes)."

	| manager |
	manager := self manager.
	self methodsDo: 
			[:each |
			| class |
			class := each methodClass.
			self
				trace: anIdentityDictionary
				prerequisite: (manager packageOfClass: class)
				from: each
				to: class
				dependency: 'is a method of']!

tracePrerequisitesOfVariables: anIdentityDictionary packagedVariables: aLookupTable
	"Private - Trace the prerequisites of the receiver's shared variables."

	| untraced |
	untraced := self untracedVariables.
	self variableNames do: 
			[:each |
			(untraced includes: each)
				ifFalse: 
					[| value target |
					value := each value.
					((self isSourceObject: value) and: [each ~= (target := value fullyQualifiedReference)])
						ifTrue: 
							["The variable is an alias for something else, so the target is a prereq."
							self
								trace: anIdentityDictionary
								prerequisite: (aLookupTable lookup: target)
								from: each
								to: each value
								dependency: 'is an alias for']
						ifFalse: 
							["The variable is not an alias, so the package is dependent on the class of the variables value."
							self
								trace: anIdentityDictionary
								prerequisite: (aLookupTable lookup: value class fullyQualifiedReference)
								from: each value
								to: each value class
								dependency: 'is an instance of']]]!

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
			aClass bindingOrNil isNil
				ifTrue: 
					[aClass class methodDictionary: nil.
					aClass methodDictionary: nil]]!

uninstallGlobals
	"Private - Uninstall the globals owned by the receiver. Should be done before classes 
	in case globals hold onto instances of any of the classes."

	self variableNames
		do: [:globalName | [globalName undeclare] on: Error do: [:ignoredException | ignoredException notify]]!

uninstallMethods
	"Private - Uninstall the methods owned by the receiver that belong to classes which are not
	owned by the receiver (i.e. methods installed into classes outside this package)."

	self methodNames
		do: [:methodName | methodName valueOrNil ifNotNil: [:method | method methodClass removeSelector: method selector]]!

untracedGlobals: aCollectionOfSymbols
	"For loading of pre-V2 packages."

	untracedVariables := aCollectionOfSymbols!

untracedVariables
	"Answer a <Set> of <BindingReference>s, being the names of the shared variables which should be ignored when tracing prerequisites. This allows a shared variable to reference an object from another package without creating a dependency on that package. An example of where this is useful is that the Transcript global owned by the the base package is assigned an instance of TranscriptShell by the Transcript development package when the latter is loaded. "

	^untracedVariables ifNil: [Set new]!

untracedVariables: aCollectionOfBindingReferences
	self setUntracedVariables: aCollectionOfBindingReferences.
	self resetPrerequisites!

upateFileNames
	"Private - Update the package filename to match the package name and to be a PAC."

	self setPackageFileName: (File
				composePath: self path
				stem: self name
				extension: self class packageExtension).
	"The prereqs may be out of date due to changes since last load, also the pre-reqs set at package load time
	include relative paths, so just toss them away"
	prerequisiteNames := nil!

updateMethodNamesToFullyQualified
	methodNames do: 
			[:each |
			| fullyQualified |
			fullyQualified := each className binding fullyQualifiedReference.
			each className: (each className isMeta ifTrue: [fullyQualified meta] ifFalse: [fullyQualified])]!

updateNamesToFullyQualified
	classNames := classNames collect: [:each | each binding fullyQualifiedReference].
	variableNames := variableNames collect: [:each | each binding fullyQualifiedReference]!

upgrade
	self paxVersion < 2 ifTrue: [self upgradeToVersion2]!

upgradeToVersion2
	classNames := self convertOldNames: classNames.
	variableNames := self convertOldNames: variableNames.
	untracedVariables := self convertOldNames: untracedVariables.
	prerequisiteNames := prerequisiteNames asArray.
	self convertOldNamesProperty: #binaryVariables.
	self convertOldNamesProperty: #aliasVariables.
	self convertOldMethodNames!

validate
	"Private - Validate the internal structure repairing any errors"

	methodNames := self methodNames select: [:each | each valueOrNil notNil].
	methodNames isEmpty ifTrue: [methodNames := nil]!

variableNames
	"Answer a <Collection> of <BindingReferences>s, naming all shared variable objects (including pools but excluding classes) owned by the receiver."

	^variableNames!

variableNames: aSet 
	variableNames := aSet!

variables
	"Private - Answer a <collection> of <VariableBindings>s, being the receiver's shared variables."

	^self variableNames collect: 
			[:each |
			each bindingOrNil
				ifNil: 
					[(VariableBinding key: each asSymbol value: nil)
						environment: each namespace;
						yourself]]!

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
!Kernel.Package categoriesFor: #about!commands!public! !
!Kernel.Package categoriesFor: #aboutBlock!accessing!public! !
!Kernel.Package categoriesFor: #aboutBlock:!accessing!public! !
!Kernel.Package categoriesFor: #aboutBlockBytes:!accessing!private! !
!Kernel.Package categoriesFor: #addAllPrerequisitesTo:!accessing!private! !
!Kernel.Package categoriesFor: #addClass:!adding!public! !
!Kernel.Package categoriesFor: #addLooseMethod:!adding!private! !
!Kernel.Package categoriesFor: #addMethod:!adding!public! !
!Kernel.Package categoriesFor: #addPackagedMethod:!adding!private! !
!Kernel.Package categoriesFor: #addResourceIdentifier:!adding!public! !
!Kernel.Package categoriesFor: #addVariableNamed:!adding!public! !
!Kernel.Package categoriesFor: #aliasVariableNames!accessing!private! !
!Kernel.Package categoriesFor: #allDependentPackages!accessing!public! !
!Kernel.Package categoriesFor: #allMethods!accessing!public! !
!Kernel.Package categoriesFor: #allMethodsDo:!enumerating!private! !
!Kernel.Package categoriesFor: #allPrerequisites!accessing!private! !
!Kernel.Package categoriesFor: #allResourceIdentifiers!accessing!public! !
!Kernel.Package categoriesFor: #allResourceNames!accessing!private! !
!Kernel.Package categoriesFor: #allSourceObjects!accessing!public!source filing! !
!Kernel.Package categoriesFor: #allSourceObjectsDo:!enumerating!public!source filing! !
!Kernel.Package categoriesFor: #basicAddClass:!adding!private! !
!Kernel.Package categoriesFor: #basicAddVariableNamed:!adding!private! !
!Kernel.Package categoriesFor: #basicComment:!accessing!private! !
!Kernel.Package categoriesFor: #basicPackageVersion:!accessing!private! !
!Kernel.Package categoriesFor: #basicRemoveClass:!private!removing! !
!Kernel.Package categoriesFor: #basicRemoveVariableNamed:!private!removing! !
!Kernel.Package categoriesFor: #basicResetPrerequisites!initializing!private! !
!Kernel.Package categoriesFor: #basicScriptAt:put:!accessing!private! !
!Kernel.Package categoriesFor: #behaviorFromName:ifAbsent:!mapping!private! !
!Kernel.Package categoriesFor: #behaviors!enumerating!public! !
!Kernel.Package categoriesFor: #behaviorsDo:!enumerating!public! !
!Kernel.Package categoriesFor: #binaryGlobalNames:!accessing!legacy package loading!private! !
!Kernel.Package categoriesFor: #binaryVariableNames!accessing!private! !
!Kernel.Package categoriesFor: #bindingRefToLiteral:!helpers!private! !
!Kernel.Package categoriesFor: #buildPrerequisiteNames!helpers!private! !
!Kernel.Package categoriesFor: #calculatePrerequisites!helpers!private! !
!Kernel.Package categoriesFor: #canShowAbout!public!testing! !
!Kernel.Package categoriesFor: #changedFrom:!initializing!public! !
!Kernel.Package categoriesFor: #changeIndex!accessing!private! !
!Kernel.Package categoriesFor: #changeIndexValue:!accessing!private! !
!Kernel.Package categoriesFor: #classDefinitionsFileName!accessing!private! !
!Kernel.Package categoriesFor: #classes!accessing!public! !
!Kernel.Package categoriesFor: #classesDo:!enumerating!public! !
!Kernel.Package categoriesFor: #classesInHierarchyOrder!enumerating!private! !
!Kernel.Package categoriesFor: #classFromName:!helpers!private! !
!Kernel.Package categoriesFor: #classFromName:ifAbsent:!helpers!private! !
!Kernel.Package categoriesFor: #classNames!accessing!public! !
!Kernel.Package categoriesFor: #classNames:!accessing!private! !
!Kernel.Package categoriesFor: #comment!accessing!public! !
!Kernel.Package categoriesFor: #comment:!accessing!public! !
!Kernel.Package categoriesFor: #convertOldMethodNames!legacy package loading!private! !
!Kernel.Package categoriesFor: #convertOldNames:!legacy package loading!private! !
!Kernel.Package categoriesFor: #convertOldNamesProperty:!legacy package loading!private! !
!Kernel.Package categoriesFor: #convertPoolDictionariesToSharedPools!legacy package loading!private! !
!Kernel.Package categoriesFor: #declareClasses!helpers!private! !
!Kernel.Package categoriesFor: #declareVariable:!helpers!private! !
!Kernel.Package categoriesFor: #declareVariables!helpers!private! !
!Kernel.Package categoriesFor: #dependentPackages!accessing!public! !
!Kernel.Package categoriesFor: #depthOfClass:!helpers!public! !
!Kernel.Package categoriesFor: #displayOn:!displaying!public! !
!Kernel.Package categoriesFor: #ensureNamesFullyQualified!loading!private! !
!Kernel.Package categoriesFor: #errorFileCorrupt!exceptions!private! !
!Kernel.Package categoriesFor: #evaluateScript:source:!private!source filing! !
!Kernel.Package categoriesFor: #fileInClasses!private!source filing! !
!Kernel.Package categoriesFor: #fileInScript:!private!source filing! !
!Kernel.Package categoriesFor: #fileNameForBinaryVariable:!helpers!private! !
!Kernel.Package categoriesFor: #fileNameForSourceGlobal:!helpers!private! !
!Kernel.Package categoriesFor: #fileOutName!public!source filing! !
!Kernel.Package categoriesFor: #getEvents!accessing!private! !
!Kernel.Package categoriesFor: #getPrerequisites!accessing!private! !
!Kernel.Package categoriesFor: #globalAliases:!legacy package loading!private! !
!Kernel.Package categoriesFor: #globalNames!legacy package loading!public! !
!Kernel.Package categoriesFor: #hasCyclicPrerequisites!private!testing! !
!Kernel.Package categoriesFor: #hasCyclicPrerequisites:safe:!private!testing! !
!Kernel.Package categoriesFor: #hasUncommittedPrerequisites!private!testing! !
!Kernel.Package categoriesFor: #hierarchyOrderOfClasses:!helpers!private! !
!Kernel.Package categoriesFor: #imageStripper:!accessing!public! !
!Kernel.Package categoriesFor: #imageStripperBytes!accessing!private! !
!Kernel.Package categoriesFor: #imageStripperBytes:!accessing!private! !
!Kernel.Package categoriesFor: #includesClass:!public!testing! !
!Kernel.Package categoriesFor: #includesClassNamed:!public!testing! !
!Kernel.Package categoriesFor: #includesMethod:!public!testing! !
!Kernel.Package categoriesFor: #includesResourceIdentifier:!private!testing! !
!Kernel.Package categoriesFor: #includesVariableNamed:!public!testing! !
!Kernel.Package categoriesFor: #initialize!initializing!private! !
!Kernel.Package categoriesFor: #initializeClasses!initializing!private! !
!Kernel.Package categoriesFor: #initializeGlobals!initializing!private! !
!Kernel.Package categoriesFor: #initializeLegacyResources!initializing!private! !
!Kernel.Package categoriesFor: #initializeOldSourcePackage!initializing!private! !
!Kernel.Package categoriesFor: #isAlias:!initializing!private! !
!Kernel.Package categoriesFor: #isBasePackage!public!testing! !
!Kernel.Package categoriesFor: #isChanged!public!testing! !
!Kernel.Package categoriesFor: #isChanged:!accessing!public! !
!Kernel.Package categoriesFor: #isDefaultPackage!public!testing! !
!Kernel.Package categoriesFor: #isImportedClass:!initializing!private! !
!Kernel.Package categoriesFor: #isInstalled!public!testing! !
!Kernel.Package categoriesFor: #isSourceObject:!initializing!private! !
!Kernel.Package categoriesFor: #isSystemPackage!public!testing! !
!Kernel.Package categoriesFor: #load!initializing!private! !
!Kernel.Package categoriesFor: #loadBinaryVariables!initializing!private! !
!Kernel.Package categoriesFor: #loadPAC!loading!private! !
!Kernel.Package categoriesFor: #loadPAC:!loading!private! !
!Kernel.Package categoriesFor: #loadPAX!loading!private! !
!Kernel.Package categoriesFor: #looseResourceIdentifiers!initializing!public! !
!Kernel.Package categoriesFor: #looseResourceIdentifiersDo:!initializing!public! !
!Kernel.Package categoriesFor: #manager!initializing!public! !
!Kernel.Package categoriesFor: #manualPrerequisites!initializing!public! !
!Kernel.Package categoriesFor: #manualPrerequisites:!initializing!public! !
!Kernel.Package categoriesFor: #membershipChanged!initializing!private! !
!Kernel.Package categoriesFor: #membershipChangedAt:!events!private! !
!Kernel.Package categoriesFor: #memberUpdatedAt:!events!private! !
!Kernel.Package categoriesFor: #methodNames!accessing!public! !
!Kernel.Package categoriesFor: #methods!accessing!public! !
!Kernel.Package categoriesFor: #methodsDo:!enumerating!public! !
!Kernel.Package categoriesFor: #methodsOfClass:!accessing!public! !
!Kernel.Package categoriesFor: #name!accessing!public! !
!Kernel.Package categoriesFor: #nameForResourceIdentifier:!helpers!private! !
!Kernel.Package categoriesFor: #okToSaveOrDeploy!private!testing! !
!Kernel.Package categoriesFor: #okToUninstall!private!testing! !
!Kernel.Package categoriesFor: #onClassRemoved:!events!private! !
!Kernel.Package categoriesFor: #onClassRenamed:from:to:!events!private! !
!Kernel.Package categoriesFor: #onVariableRenamed:from:!events!private! !
!Kernel.Package categoriesFor: #owningPackage!adding!public! !
!Kernel.Package categoriesFor: #packageFileName!accessing!public! !
!Kernel.Package categoriesFor: #packageFileName:!accessing!private! !
!Kernel.Package categoriesFor: #packageFolder!accessing!public! !
!Kernel.Package categoriesFor: #packagePathname!accessing!private! !
!Kernel.Package categoriesFor: #packagePathname:!accessing!private! !
!Kernel.Package categoriesFor: #packageVersion!accessing!public! !
!Kernel.Package categoriesFor: #packageVersion:!accessing!public! !
!Kernel.Package categoriesFor: #path!accessing!public! !
!Kernel.Package categoriesFor: #paxVersion!accessing!private! !
!Kernel.Package categoriesFor: #paxVersion:!initializing!private! !
!Kernel.Package categoriesFor: #postLoadInitialization:!loading!private! !
!Kernel.Package categoriesFor: #preDeclareClassesOnLoad!accessing!public! !
!Kernel.Package categoriesFor: #preDeclareClassesOnLoad:!accessing!public! !
!Kernel.Package categoriesFor: #prerequisiteNames!accessing!private! !
!Kernel.Package categoriesFor: #prerequisites!accessing!public! !
!Kernel.Package categoriesFor: #printOn:!initializing!public! !
!Kernel.Package categoriesFor: #privateUninstall!initializing!private! !
!Kernel.Package categoriesFor: #propertyAt:ifAbsent:!initializing!public! !
!Kernel.Package categoriesFor: #propertyManager!initializing!private! !
!Kernel.Package categoriesFor: #rebaseTo:!initializing!public! !
!Kernel.Package categoriesFor: #remainingClasses!initializing!public! !
!Kernel.Package categoriesFor: #removeClass:!initializing!public! !
!Kernel.Package categoriesFor: #removeClassName:!initializing!private! !
!Kernel.Package categoriesFor: #removeGlobalNamed:!initializing!public! !
!Kernel.Package categoriesFor: #removeLooseMethod:!initializing!private! !
!Kernel.Package categoriesFor: #removeMethod:!initializing!public! !
!Kernel.Package categoriesFor: #removeMethodNames:!initializing!private! !
!Kernel.Package categoriesFor: #removePackagedMethod:!initializing!private! !
!Kernel.Package categoriesFor: #removePAXProperties!initializing!private! !
!Kernel.Package categoriesFor: #removeVariableNamed:!initializing!public! !
!Kernel.Package categoriesFor: #renameLooseMethodsOf:to:!initializing!private! !
!Kernel.Package categoriesFor: #resetChangeFlags!initializing!public! !
!Kernel.Package categoriesFor: #resetPrerequisites!initializing!private! !
!Kernel.Package categoriesFor: #resourceIdentifiers!accessing!public! !
!Kernel.Package categoriesFor: #scriptAt:!accessing!public! !
!Kernel.Package categoriesFor: #scriptAt:put:!accessing!public! !
!Kernel.Package categoriesFor: #scripts!accessing!private! !
!Kernel.Package categoriesFor: #setAliasVariableNames:!initializing!private! !
!Kernel.Package categoriesFor: #setBinaryVariableNames:!initializing!private! !
!Kernel.Package categoriesFor: #setClassNames:!initializing!private! !
!Kernel.Package categoriesFor: #setEvents:!events!private! !
!Kernel.Package categoriesFor: #setManualPrerequisites:!initializing!private! !
!Kernel.Package categoriesFor: #setMethodNames:!initializing!private! !
!Kernel.Package categoriesFor: #setPackageFileName:!initializing!private! !
!Kernel.Package categoriesFor: #setPrerequisites:!initializing!private! !
!Kernel.Package categoriesFor: #setUntracedVariables:!initializing!private! !
!Kernel.Package categoriesFor: #setVariableNames:!initializing!private! !
!Kernel.Package categoriesFor: #shrink!private! !
!Kernel.Package categoriesFor: #sourceDescriptor!accessing!private! !
!Kernel.Package categoriesFor: #sourceDescriptor:!accessing!private! !
!Kernel.Package categoriesFor: #sourceManager!accessing!public! !
!Kernel.Package categoriesFor: #sourceVariableNames!accessing!private! !
!Kernel.Package categoriesFor: #stbSaveOn:!binary filing!public! !
!Kernel.Package categoriesFor: #storeComment!helpers!private! !
!Kernel.Package categoriesFor: #synchronizeNames!helpers!private! !
!Kernel.Package categoriesFor: #timestamp!accessing!public! !
!Kernel.Package categoriesFor: #timestamp:!accessing!private! !
!Kernel.Package categoriesFor: #trace:prerequisite:from:to:dependency:!helpers!private! !
!Kernel.Package categoriesFor: #tracePrerequisites!operations!private! !
!Kernel.Package categoriesFor: #tracePrerequisites:!operations!private! !
!Kernel.Package categoriesFor: #tracePrerequisitesOfClasses:packagedVariables:!operations!private! !
!Kernel.Package categoriesFor: #tracePrerequisitesOfImageStripper:!operations!private! !
!Kernel.Package categoriesFor: #tracePrerequisitesOfLiterals:packagedVariables:!operations!private! !
!Kernel.Package categoriesFor: #tracePrerequisitesOfMethods:!operations!private! !
!Kernel.Package categoriesFor: #tracePrerequisitesOfVariables:packagedVariables:!operations!private! !
!Kernel.Package categoriesFor: #uninstall!public!removing! !
!Kernel.Package categoriesFor: #uninstallClasses!class hierarchy-removing!private!removing! !
!Kernel.Package categoriesFor: #uninstallGlobals!private!removing! !
!Kernel.Package categoriesFor: #uninstallMethods!private!removing! !
!Kernel.Package categoriesFor: #untracedGlobals:!legacy package loading!private! !
!Kernel.Package categoriesFor: #untracedVariables!accessing!public! !
!Kernel.Package categoriesFor: #untracedVariables:!accessing!public! !
!Kernel.Package categoriesFor: #upateFileNames!operations!private! !
!Kernel.Package categoriesFor: #updateMethodNamesToFullyQualified!loading!private! !
!Kernel.Package categoriesFor: #updateNamesToFullyQualified!loading!private! !
!Kernel.Package categoriesFor: #upgrade!helpers!private! !
!Kernel.Package categoriesFor: #upgradeToVersion2!helpers!private! !
!Kernel.Package categoriesFor: #validate!operations!private! !
!Kernel.Package categoriesFor: #variableNames!accessing!public! !
!Kernel.Package categoriesFor: #variableNames:!private! !
!Kernel.Package categoriesFor: #variables!private!source filing! !
!Kernel.Package categoriesFor: #versionIfRequired!public! !
!Kernel.Package categoriesFor: #vmVersionCheck:!constants!private! !

!Kernel.Package class methodsFor!

binaryPacLoader: aDyadicValuable
	BinaryPacLoader := aDyadicValuable!

binaryVariableExtension
	"Private - Answer the file extension for the files to which binary globals are stored."

	^'stb'!

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
	1 - D6.0 format with implicit literal (i.e. not embedded binary) resources
	2 - Early D7.2 format, using BindingReferences
	2.1 - D7.2 format with fully qualified names"

	^2.1!

preDeclareClassesOnLoad
	"Answer whether Package loading from a .pax should, by default, declare classes before loading any code. This is generally not necessary except in circumstances where one or more of the source globals in the package as dependencies on classes in the package, or where classes in the package are being used in the role of pool dictionaries by other classes in the package. The historic behaviour was to declare classes, but as of 7.2 this is now off by default. The reason for this is that pre-declaration is relatively expensive (causing a class mutation when the actual class declaration is subsequently loaded), and so worth avoiding when not required. The setting can either be changed globally (i.e. `Package declareClassesOnLoad: true`) or for individual packages using the `preDeclareClassesOnLoad` property on the instance side. If the property is set, then it will be persisted to the package file and respected by future loads. "

	^PreDeclareClassesOnLoad ?? false!

preDeclareClassesOnLoad: aBoolean
	PreDeclareClassesOnLoad := aBoolean!

readFrom: pacStream
	"Private - Answer a new instance of the receiver created from the .PAX (source 
	text) format representation in the <readableStream>, pacStream."

	| chunk |
	chunk := (ChunkSourceFiler on: pacStream) nextChunk.
	^(Compiler evaluate: chunk) upgrade!

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

	Notification
		signal: 'Converting package from version ' , anSTBClassFormat version printString , ' to: '
				, self stbVersion printString.
	^
	[:data |
	(anSTBClassFormat version to: self stbVersion - 1) inject: data
		into: [:inject :version | self perform: ('stbConvertFromVersion' , version displayString , ':') asSymbol with: inject]]!

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

	anArray at: 8 put: nil.	"singleFile"
	anArray at: 10 put: nil.
	^anArray!

stbConvertFromVersion6: anArray
	"Private - Convert version 6 to 7: Adds changeIndex and paxVersion instance variables."

	"We don't need to do anything as the subsequent converter will cope with the absence of the new variables in the data Array"

	^anArray!

stbConvertFromVersion7: anArray
	"Private - Convert version 7 to 8: New format package using BindingReferences."

	| newPackage |
	"Last converter in the chain"
	newPackage := self new.
	anArray keysAndValuesDo: [:eachKey :eachValue | newPackage instVarAt: eachKey put: eachValue].
	newPackage upgradeToVersion2.
	^newPackage!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^8!

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
!Kernel.Package class categoriesFor: #binaryPacLoader:!accessing!private! !
!Kernel.Package class categoriesFor: #binaryVariableExtension!constants!private! !
!Kernel.Package class categoriesFor: #clashSignal!constants!private! !
!Kernel.Package class categoriesFor: #defaultSortBlock!constants!public! !
!Kernel.Package class categoriesFor: #errorInvalidPACFile:!exceptions!private! !
!Kernel.Package class categoriesFor: #errorInvalidPAXFile:!exceptions!private! !
!Kernel.Package class categoriesFor: #fromFile:!instance creation!private! !
!Kernel.Package class categoriesFor: #fromPACFile:!instance creation!private! !
!Kernel.Package class categoriesFor: #fromPAXFile:!instance creation!private! !
!Kernel.Package class categoriesFor: #initialize!initializing!private! !
!Kernel.Package class categoriesFor: #manager!accessing!public! !
!Kernel.Package class categoriesFor: #name:!instance creation!public! !
!Kernel.Package class categoriesFor: #new!instance creation!public! !
!Kernel.Package class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!Kernel.Package class categoriesFor: #packageExtension!constants!private! !
!Kernel.Package class categoriesFor: #packageFileVersion!constants!public! !
!Kernel.Package class categoriesFor: #paxVersion!constants!private! !
!Kernel.Package class categoriesFor: #preDeclareClassesOnLoad!accessing!public! !
!Kernel.Package class categoriesFor: #preDeclareClassesOnLoad:!accessing!public! !
!Kernel.Package class categoriesFor: #readFrom:!instance creation!private! !
!Kernel.Package class categoriesFor: #sourceGlobalExtension!constants!private! !
!Kernel.Package class categoriesFor: #sourcePackageExtension!constants!private! !
!Kernel.Package class categoriesFor: #stbConvertFrom:!binary filing!public! !
!Kernel.Package class categoriesFor: #stbConvertFromVersion0:!binary filing!private! !
!Kernel.Package class categoriesFor: #stbConvertFromVersion1:!binary filing!private! !
!Kernel.Package class categoriesFor: #stbConvertFromVersion2:!binary filing!private! !
!Kernel.Package class categoriesFor: #stbConvertFromVersion3:!binary filing!private! !
!Kernel.Package class categoriesFor: #stbConvertFromVersion4:!binary filing!private! !
!Kernel.Package class categoriesFor: #stbConvertFromVersion5:!binary filing!private! !
!Kernel.Package class categoriesFor: #stbConvertFromVersion6:!binary filing!private! !
!Kernel.Package class categoriesFor: #stbConvertFromVersion7:!binary filing!private! !
!Kernel.Package class categoriesFor: #stbVersion!binary filing!public! !
!Kernel.Package class categoriesFor: #uncommitted!accessing!public! !
!Kernel.Package class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!Kernel.Package class categoriesFor: #unsaveableSignal!constants!private! !

