"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.Package'
	instanceVariableNames: 'name packagePathname comment classNames methodNames variableNames prerequisiteNames events scripts doNotReuse imageStripperBytes aboutBlock packageVersion manualPrerequisites timestamp untracedVariables changeIndex properties preDeclareClassesOnLoad'
	classVariableNames: '_Uncommitted ChangedIcon CheckTimestamps ClashSignal PreDeclareClassesOnLoad SourcePackageIcon UnsaveableSignal'
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
	"Answer the <monadicValuable> that will display an About screen or nil if there is none. The receiver is passed as the parameter to the block when evaluated."

	aboutBlock ifNil: [^nil].
	^#{Kernel.STLInFiler} valueOrNil ifNotNil: [:filer | (filer on: aboutBlock readStream) next]!

aboutBlockLiteralStoreArray
	^aboutBlock!

aboutBlockLiteralStoreArray: anArray
	"Private - Set the receiver's about block by rehydrating that in serialized form in the <ByteArray> argument."

	aboutBlock := anArray!

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

addLooseMethod: aCompiledMethod
	"Private - Add the <CompiledMethod>, method, to the set of loose methods
	owned by the receiver."

	self assert: [(self includesClass: aCompiledMethod methodClass) not].
	self methodNames
		add: (MethodName class: aCompiledMethod methodClass selector: aCompiledMethod selector)!

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
			eachBehavior methodsDo: ((loose lookup: eachBehavior)
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
	"Answer a Set of all the ResourceIdentifiers directly owned by the receiver or by owning the class in which it is situated and the resource method is not a loose method of another package."

	| resources |
	resources := Set new.
	self classesDo: 
			[:each |
			each
				resourceIdentifiersDo: [:eachResId | eachResId owningPackage == self ifTrue: [resources add: eachResId]]].
	self looseResourceIdentifiersDo: [:each | resources add: each].
	^resources!

allResourceNames
	"Private - Answer a <Collection> of all the resource names directly owned by the receiver or by its owned classes."

	^self propertyAt: #allResourceNames ifAbsent: [OrderedCollection new]!

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

	variableNames add: aBindingReference.
	((self isAlias: aBindingReference) not and: [self isSourceObject: aBindingReference value])
		ifTrue: 
			["The global's value has not changed, but it may now need filing out to a new location."
			aBindingReference value isChanged: true].
	^aBindingReference!

basicComment: aString
	"Private - Set the comment of the receiver."

	comment := aString!

basicPackageVersion
	^packageVersion!

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

	variableNames remove: aBindingReference ifAbsent: nil.
	^aBindingReference!

basicResetPrerequisites
	"Private - Mark that the prerequisite packages for the receiver have changed. The packages will be recalculated the next time the #prerequsiteNames accessor is sent."

	prerequisiteNames := nil!

basicScriptAt: scriptSymbol put: aString
	"Private - Set the script String associated with scriptSymbol."

	scripts := self scripts.
	aString isEmpty
		ifTrue: 
			[scripts removeKey: scriptSymbol ifAbsent: nil.
			scripts isEmpty ifTrue: [scripts := nil]]
		ifFalse: [scripts at: scriptSymbol put: aString]!

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

	aCollectionOfSymbols notEmpty ifTrue: [self setBinaryVariableNames: aCollectionOfSymbols]!

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
		do: [:each | (self manager packageNamed: each ifNone: nil) notNil ifTrue: [prereqs add: each]].
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

	| classes |
	classes := IdentitySet new: classNames size.
	classNames do: [:className | classes add: className value].
	^classes!

classesDo: operation 
	"Evaluate the <monadicValuable>, operation, for each of the classes owned by the receiver. 
	Note that this does not include the classes of the receiver's loose methods."

	^classNames do: [:each | operation value: each value]!

classesInHierarchyOrder
	"Private - Answer an <sequencedReadableCollection> of the receiver's owned classes in the order that they would be visited by a depth-first traversal of the class hierarchy."

	| classes |
	classes := self classes.
	classes size < 2 ifTrue: [^classes].
	^Smalltalk allClasses select: [:each | classes includes: each]!

classFromName: className
	"Private - Answer the Class object which className encodes.

	See Package>>nameForClass: for the reverse transformation."

	^className asQualifiedReference value!

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
			className := classes addIfAbsent: (BindingReference path: { #Smalltalk. parts first }).
			parts size > 1 ifTrue: [className := classes addIfAbsent: className meta].
			names add: (MethodName className: className selector: each value)].
	methodNames := names!

convertOldNames: aCollectionOfSymbols
	^aCollectionOfSymbols
		ifNotNil: 
			[| refs |
			refs := Set new: aCollectionOfSymbols size.
			aCollectionOfSymbols do: [:each | refs add: (BindingReference path: { #Smalltalk. each })].
			refs]!

convertOldNamesProperty: aSymbol
	(self propertyAt: aSymbol ifAbsent: nil)
		ifNotNil: 
			[:names |
			| aCollectionOfBindingReferences |
			aCollectionOfBindingReferences := self convertOldNames: names.
			self propertyAt: aSymbol put: aCollectionOfBindingReferences]!

convertPoolDictionariesToSharedPools
	^(self variableNames select: [:each | each valueOrNil isKindOf: PoolDictionary]) collect: 
			[:each |
			| poolClass |
			poolClass := each value convertToSharedPool.
			self basicRemoveVariableNamed: each.
			poolClass fullyQualifiedReference]!

declareClasses
	"Private - Predefine global variables for each of the classes in the package prior to those classes
	being loaded. Only required for PAX (not PAC) loading"

	(self classNames reject: [:each | each isDefined]) do: 
			[:each |
			Object
				subclass: each pathString
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
	self isLegacySourceFormat ifFalse: [^self].
	classNames := classNames collect: [:each | each binding fullyQualifiedReference].
	variableNames := variableNames collect: [:each | each binding fullyQualifiedReference]!

environment
	"Answer the default environment for the package, in the context of which any loose (extension) methods should be compiled, or nil if there is no default environment for loose methods and the extended class' own environment should be used for resolving static variable references in the method source."

	^self isLegacySourceFormat
		ifTrue: [Smalltalk]
		ifFalse: [(self propertyAt: #environmentName ifAbsent: nil) ifNotNil: [:ref | ref valueOrNil]]!

environment: aNamespace
	"Set the default environment for the package, in the context of which any loose (extension) methods should be compiled, or nil if there is no default environment for loose methods and the extended class' own environment should be used for resolving static variable references in the method source."

	| ref failures |
	"Cannot be here if current namespace is nil and new namespace is nil, due to earlier guard"
	self environment == aNamespace ifTrue: [^self].
	(self isLegacySourceFormat and: [aNamespace ~~ Smalltalk])
		ifTrue: 
			[self
				error: 'Legacy format packages can only use Smalltalk as the default environment for compiling scripts and extension methods'].
	ref := aNamespace notNil
				ifTrue: 
					[aNamespace owningPackage = self
						ifTrue: [self error: 'The default namespace for a package cannot be one of its own classes'].
					aNamespace fullyQualifiedReference].
	#todo. "Add a refactoring to update the namespace safely. The capability exists add extra qualification, or remove unnecessary qualification, from class/static variable refs, as used in rename class/namespace refactoring. Until then, warn that it might generate compilation errors."
	self warnChangingDefaultNamespaceFrom: self environment to: aNamespace.
	self environmentName: ref.
	failures := SortedCollection new.
	self methodsDo: 
			[:each |
			| compilationResult |
			compilationResult := each methodClass recompileMethod: each environment: aNamespace.
			compilationResult method
				ifNil: [failures add: each]
				ifNotNil: 
					[compilationResult
						oldMethod: each;
						fireSystemUpdateEvent]].
	failures isEmpty
		ifFalse: 
			[Warning
				signal: ('One or more extension methods of <1d> failed to compile in <2p>, see Transcript for details.'
						expandMacrosWith: self
						with: aNamespace)].
	self isChanged: true!

environmentName: aBindingReference
	"Private - Record the name of the <Namespace> to be used as the default environment for compiling scripts and extension (aka loose) methods of the package."

	aBindingReference isNil
		ifTrue: [self removePropertyAt: #environmentName]
		ifFalse: [self propertyAt: #environmentName put: aBindingReference]!

evaluateScript: aSymbol source: aString
	| filer |
	filer := self sourceFilerOn: aString readStream.
	filer
		evaluationContext: self;
		environment: self environment ?? Smalltalk.
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
	self evaluateScript: aSymbol source: aString!

fileNameForBinaryVariable: aBindingReference
	"Private - Answer a filename for storing the named binary global object."

	^self isLegacySourceFormat
		ifTrue: 
			[File
				composePath: self path
				stem: aBindingReference path last
				extension: 'stb']
		ifFalse: 
			[File
				composePath: self path
				stem: aBindingReference asString
				extension: 'ston']!

fileNameForSourceVariable: aBindingReference
	"Private - Answer a filename for storing the named source global object."

	^File
		composePath: self path
		stem: (self isLegacySourceFormat ifTrue: [aBindingReference path last] ifFalse: [aBindingReference asString])
		extension: self sourceVariableExtension!

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
	"Private - Answer whether any of the receiver's prerequisites or their
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
	"Private - Answer whether any of the receiver's prerequisites or their
	prerequisites are current uncomitted. If so the package should not be saved
	as it will not be reloadable into an image without the uncommitted objects."

	^self allPrerequisites includes: _Uncommitted.!

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
			[| methodClass |
			methodClass := aCompiledMethod methodClass.
			(self isImportedClass: methodClass) not
				and: [methodNames includes: (MethodName class: methodClass selector: aCompiledMethod selector)]]!

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
			(self isAlias: each)
				ifFalse: 
					[| value |
					value := each valueOrNil.
					(value respondsTo: #initializeAfterLoad) ifTrue: [value initializeAfterLoad]]].
	(self propertyAt: #variableAliases ifAbsent: #()) do: 
			[:each |
			| target |
			target := each value.
			target class isMeta ifTrue: [ClassLocator addAlias: each forClass: target]]!

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
	^target class isMeta and: [aBindingReference ~= target fullyQualifiedReference]!

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

isLegacySourceFormat
	^self paxVersion < 2.1!

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

	| varNames ston |
	varNames := self propertyAt: #binaryVariables ifAbsent: nil.
	varNames isNil ifTrue: [^self].
	self isLegacySourceFormat
		ifTrue: 
			[| filer |
			filer := #{Kernel.STBInFiler} value.
			varNames do: 
					[:each |
					| globalStream |
					globalStream := FileStream read: (File
										composePath: self path
										stem: each path last
										extension: 'stb')
								text: false.
					each declare: (filer on: globalStream) next.
					globalStream close]]
		ifFalse: 
			["We have a chicken-and-egg problem in that we need STON to load packages with binary variables, but STON is not part of the base system. This means that any packages loaded up to and including the STON packages cannot contain any binary variables."
			ston := #{STON} value.
			varNames do: 
					[:each |
					| globalStream |
					globalStream := FileStream read: (File
										composePath: self path
										stem: each asString
										extension: 'ston')
								text: true.
					each declare: (ston readFrom: globalStream).
					globalStream close]]!

loadPAC
	"Private - Load all the objects owned by the receiver. This assumes that all prerequisite
	packages are currently loaded."

	| filename stream |
	filename := self packageFileName.
	Notification signal: ('Loading package <1p> from: <2s>' expandMacrosWith: self name with: filename).
	stream := FileStream read: filename text: true.
	timestamp := stream file lastWriteTime asInteger.
	(stream nextAvailable: 4) = '!!STB'
		ifTrue: 
			[stream close.
			self class binaryPackageLoader loadPackage: self]
		ifFalse: [
			[stream reset.
			self loadPAC: stream] ensure: [stream close]]!

loadPAC: aReadStream
	"Private - Load a chunked source text .PAC from the <readableStream> argument."

	| filer |
	filer := self sourceFilerOn: aReadStream.
	filer environment: self environment.

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

	| filename filer stream oldPools |
	filename := self packageFileName.
	Notification
		signal: ('Loading source package <1p> from: <2s>' expandMacrosWith: self name with: filename).
	stream := FileStream read: filename.
	timestamp := stream file lastWriteTime asInteger.
	filer := self sourceFilerOn: stream.
	filer environment: self environment.
	
	["Initialize old style (pre D6) binary resources"
	filer nextChunk.	"Skip the first chunk since it represents the receiver."
	self fileInScript: #preinstall.

	"Define any globals that might be referenced from source code, but don't load them as yet as they
		 may be instances of one of the classes in the package."
	self declareVariables.

	"Optionally declare all classes in the package for the case where classes are referenced by source globals or other class definitions (other than the class hierarchy relationship)"
	self preDeclareClassesOnLoad ifTrue: [self declareClasses].

	"Load source globals"
	self variableNames - (self propertyAt: #binaryVariables ifAbsent: #())
		- (self propertyAt: #aliasVariables ifAbsent: #())
			do: [:each | self sourceManager fileIn: (self fileNameForSourceVariable: each)].
	"We need the pool variables to be available in case there are references in the code we are about to file in"
	oldPools := self convertPoolDictionariesToSharedPools.

	"Load class definitions, aliases, and loose methods from the remainder of the PAX file"
	filer fileIn.
	self ensureNamesFullyQualified.
	self fileInClasses.
	"Now that we have loaded the classes, we can associate any newly created SharedPools (converted from PoolConstantsDictionary variables) with the package"
	oldPools do: [:each | classNames add: each].
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
			each isResourceMethod
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
				ifTrue: [aCollectionOfStrings asSortedArray copyWithout: self name].
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
	Ensure that none of the receiver's loaded packages refer to aClass
	or its methods now it has departed.

	N.B. We have to take care here when checking methods. As aClass is
	no longer tied into the system class tree we have to use the method
	names."

	| ownedChanged |
	ownedChanged := false.

	"remove any directly owned methods from aClass"
	methodNames
		ifNotNil: 
			[| className removed |
			className := aClass fullyQualifiedReference.
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
	Ensure that none of the receiver's loaded packages refer to aClass
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
	"Answer the full path to the directory holding the receiver's files."

	^File splitPathFrom: self packageFileName!

paxVersion
	"Private - Answer the PAX format version of this package."

	^self propertyAt: #paxVersion ifAbsent: [self class paxVersion]!

paxVersion: aNumber
	"Private - Record the PAX format version in which the package being loaded was saved. If the same as the current package version format, then forget the version."

	aNumber = self class paxVersion
		ifTrue: [self removePropertyAt: #paxVersion ifAbsent: nil]
		ifFalse: [self propertyAt: #paxVersion put: aNumber]!

postinstall
	doNotReuse := nil.
	self fileInScript: #postinstall!

postLoadInitialization: aNiladicValuable
	self isLegacySourceFormat ifTrue: [self updateMethodNamesToFullyQualified].
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

predeclareClassesSetting
	^preDeclareClassesOnLoad!

preinstall
	self fileInScript: #preinstall!

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
		uninstallVariables;
		uninstallClasses;
		uninstallMethods!

propertyAt: aSymbol ifAbsent: aBlock
	"Answers a property value of the receiver whose name matches aSymbol. If the object
	does not have such a property then aBlock is evaluated."

	^properties ifNil: [aBlock value] ifNotNil: [properties at: aSymbol ifAbsent: aBlock]!

propertyAt: aSymbol put: anObject
	"Sets a property value of the receiver whose name matches aSymbol."

	^(properties ifNil: [properties := IdentityDictionary new]) at: aSymbol put: anObject!

rebaseTo: basePathName
	"Rebase this package relative to the give base image directory"

	self packageFileName: (File
				relativePathOf: (File fullPathOf: self packagePathname relativeTo: basePathName)
				to: SessionManager current imagePath)!

remainingClasses
	"Answer a <collection> of the classes that are still present (i.e. ignore missing classes)"

	^classNames collect: [:each | each valueOrNil]!

removeAllProperties
	"Remove all the properties of the receiver."
	
	properties := nil!

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

	self
		removeMethodNames: {MethodName class: aCompiledMethod methodClass selector: aCompiledMethod selector}!

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

	| originalVersion |
	#(#allResourceNames #binaryVariables #aliasVariables)
		do: [:each | self removePropertyAt: each ifAbsent: nil].
	originalVersion := self paxVersion.
	self paxVersion: (originalVersion < 2.1 ifTrue: [1] ifFalse: [self class paxVersion]).
	changeIndex := nil!

removePropertyAt: aSymbol ifAbsent: aBlock
	"Removes a property of the receiver whose name matches aSymbol. If the object
	does not have such a property then aBlock is evaluated."

	^properties ifNil: [aBlock value] ifNotNil: [properties removeKey: aSymbol ifAbsent: aBlock]!

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

	^self scripts at: scriptName ifAbsent: ''!

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

sourceFilerClass
	^self isLegacySourceFormat ifTrue: [#{LegacyChunkSourceFiler} value] ifFalse: [ChunkSourceFiler]!

sourceFilerOn: stream
	^self sourceFilerClass on: stream!

sourceManager
	"Answer the receiver's source manager."

	^self class sourceManager!

sourceVariableExtension
	"Private - Answer the file extension for the files to which source globals are stored."

	^'st'!

sourceVariableNames
	"Private - Answer a <collection> of <BindingReferences>'s, being the shared variables owned by the receiver with values that can be filed out as separate source objects."

	^self variableNames select: [:var | (self isSourceObject: var value) and: [(self isAlias: var) not]]!

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
							currentName := MethodName class: method methodClass selector: method selector.
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

tracePrerequisites: aLookupTable
	"Private - Answer an <IdentityDictionary> of prerequisite package keys against an <OrderedCollection> of traces of the owned objects which forced a prerequisite link and the reason why. The argument is a <LookupTable>, the keys of which are <FullBindingReference> repreenting the  names of all packaged variables, with the associated values being the owning <Package> of the variable.

	1	from	The owned object of the receiver
	2	to		The object belonging to a prerequsite package which from references
	3	reason	String description of how from references to.

	There are quite a few reasons for a prequisite being generated:

	*	'from' is a Class which is a subclass of the Class 'to'.
	*	'from' is a directly owned CompiledMethod which is a method of the Class 'to'.
	*	'from' is a CompiledMethod which references the shared variable 'to'.
	*	'from' is a Class whose shared pools includes the shared variable 'to'.
	*	'from' is a shared variable that aliases the class 'to'
	*	'from' is a shared variable that references an instance of the class 'to'."

	| trace |
	trace := IdentityDictionary new: 16.
	self
		tracePrerequisitesOfEnvironment: trace;
		tracePrerequisitesOfClasses: trace packagedVariables: aLookupTable;
		tracePrerequisitesOfVariables: trace packagedVariables: aLookupTable;
		tracePrerequisitesOfMethods: trace;
		tracePrerequisitesOfImageStripper: trace;
		tracePrerequisitesOfLiterals: trace packagedVariables: aLookupTable;
		tracePrerequisitesOfResources: trace packagedVariables: aLookupTable;
		tracePrerequisitesOfScripts: trace.
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

tracePrerequisitesOfEnvironment: anIdentityDictionary
	"Private - Trace the prerequisites of the receiver's environment, if any."

	self environment
		ifNotNil: 
			[:ns |
			self
				trace: anIdentityDictionary
				prerequisite: ns owningPackage
				from: self
				to: ns
				dependency: 'has default namespace']!

tracePrerequisitesOfImageStripper: anIdentityDictionary
	"Only possible to trace the stripper prereqs in DPRO"

	| stream hiddenObjects filer |
	(imageStripperBytes isNil or: [#{Smalltalk.ImageStripper} isDefined not]) ifTrue: [^self].
	filer := #{Kernel.STBInFiler} valueOrNil.
	filer ifNil: [^self].
	stream := imageStripperBytes readStream.
	hiddenObjects := 
			[(filer on: stream)
				basicNext;
				elements] ensure: [stream close].
	hiddenObjects do: 
			[:each |
			(each class isMeta and: 
					[| imageStripperClass lagoonPackage |
					"We only trace prerequisite objects that are NOT in the
					Lagoon package. After all, we know that Lagoon must be
					present if an ImageStripper is ever loaded into memory"
					imageStripperClass := #{Smalltalk.ImageStripper} value.
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
			"Resource methods are processed separately"
			eachMethod isResourceMethod
				ifFalse: 
					[eachMethod literalReferencesDo: 
							[:eachLiteral |
							(self bindingRefToLiteral: eachLiteral)
								ifNotNil: 
									[:ref |
									self
										trace: anIdentityDictionary
										prerequisite: (aLookupTable lookup: ref)
										from: eachMethod
										to: ref
										dependency: 'references variable']]]]!

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

tracePrerequisitesOfResources: anIdentityDictionary packagedVariables: aLookupTable
	"Private - Trace the prerequisite method classes of the receiver's loose methods (i.e. the extended classes)."

	| collectorClass |
	collectorClass := #{Kernel.STLClassCollector} valueOrNil.
	collectorClass ifNil: [^self].
	self allResourceIdentifiers do: 
			[:each |
			each resource
				ifNotNil: 
					[:array |
					| collector method |
					method := each compiledMethod.
					collector := collectorClass on: array readStream.
					collector classes do: 
							[:eachClass |
							| ref |
							ref := eachClass fullyQualifiedReference.
							self
								trace: anIdentityDictionary
								prerequisite: (aLookupTable lookup: ref)
								from: method
								to: ref
								dependency: 'references variable'].
					collector resourceIdentifiers do: 
							[:rid |
							self
								trace: anIdentityDictionary
								prerequisite: rid owningPackage
								from: method
								to: rid
								dependency: 'references resource']]]!

tracePrerequisitesOfScripts: anIdentityDictionary
	| filer |
	(scripts isNil or: [scripts isEmpty]) ifTrue: [^self].
	self isLegacySourceFormat ifFalse: [^self].
	filer := #{LegacyChunkSourceFiler} valueOrNil.
	filer ifNil: [^self].
	scripts keysDo: 
			[:each |
			self
				trace: anIdentityDictionary
				prerequisite: filer owningPackage
				from: each , ' script'
				to: filer
				dependency: 'legacy format script']!

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
	classes := classes asSortedArray: [:a :b | (self depthOfClass: a) > (self depthOfClass: b)].
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

uninstallMethods
	"Private - Uninstall the methods owned by the receiver that belong to classes which are not
	owned by the receiver (i.e. methods installed into classes outside this package)."

	"Note that we can enumerate over the methodNames collection while removing methods only because the PackageManager will not be forwarding events, so the collection will not be modified as the methods are removed."

	self methodNames
		do: [:methodName | methodName valueOrNil ifNotNil: [:method | method methodClass removeSelector: method selector]]!

uninstallVariables
	"Private - Uninstall the static variables owned by the receiver. Should be done before classes in case variables hold onto instances of any of the classes."

	self variableNames
		do: [:varName | [varName undeclare] on: Error do: [:ignoredException | ignoredException notify]]!

untracedGlobals: aCollectionOfSymbols
	"For loading of pre-V2 packages."

	untracedVariables := aCollectionOfSymbols!

untracedVariables
	"Answer a <Set> of <BindingReference>s, being the names of the static variables which should be ignored when tracing prerequisites. This allows a static variable to reference an object from another package without creating a dependency on that package. An example of where this is useful is that the Transcript global owned by the base package is assigned an instance of TranscriptShell by the Transcript development package when the latter is loaded. "

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
	"Answer a <Collection> of <BindingReferences>s, naming all shared variable objects (excluding classes) owned by the receiver."

	^variableNames!

variableNames: aSet 
	variableNames := aSet!

variables
	"Private - Answer a <collection> of <VariableBindings>s, being the receiver's owned static variables."

	^self variableNames collect: 
			[:each |
			each bindingOrNil
				ifNil: 
					[(VariableBinding key: each asSymbol value: nil)
						environment: each environment;
						yourself]]!

versionIfRequired
	Package manager versionPackageIfRequired: self!

warnChangingDefaultNamespaceFrom: currentNamespace to: newNamespace
	| preamble |
	preamble := currentNamespace isNil
				ifTrue: 
					["Cannot be here if current namespace is nil and new namespace is nil, due to earlier guard"
					'The namespace for extension methods of ''<1d>'' will be set to <3p><n>Setting a package''s default namespace requires that extension methods be recompiled.']
				ifFalse: 
					[newNamespace isNil
						ifTrue: 
							['The namespace for extension methods of ''<1d>'' will be reset<n>Resetting a package''s default namespace requires that its extension methods be recompiled in the scope of the classes they extend.']
						ifFalse: 
							['The namespace for extension methods of ''<1d>'' will be changed from <2p> to <3p><n>Changing a package''s default namespace requires that its extension methods be recompiled.']].
	Warning
		signal: (preamble
				, '<n><n>Methods may fail to recompile if they contain static variable references that are not resolvable in their new scope. This may render the system unstable if the methods that fail to compile are critical to system operation.'
					expandMacrosWith: self
					with: currentNamespace
					with: newNamespace)! !

!Kernel.Package categoriesForMethods!
about!commands!public! !
aboutBlock!accessing!public! !
aboutBlockLiteralStoreArray!accessing!public! !
aboutBlockLiteralStoreArray:!accessing!private! !
addAllPrerequisitesTo:!accessing!private! !
addClass:!adding!public! !
addLooseMethod:!adding!private! !
addMethod:!adding!public! !
addPackagedMethod:!adding!private! !
addResourceIdentifier:!adding!public! !
addVariableNamed:!adding!public! !
aliasVariableNames!accessing!private! !
allDependentPackages!accessing!public! !
allMethods!accessing!public! !
allMethodsDo:!enumerating!private! !
allPrerequisites!accessing!private! !
allResourceIdentifiers!accessing!public! !
allResourceNames!accessing!private! !
allSourceObjects!accessing!public!source filing! !
allSourceObjectsDo:!enumerating!public!source filing! !
basicAddClass:!adding!private! !
basicAddVariableNamed:!adding!private! !
basicComment:!accessing!private! !
basicPackageVersion!accessing!private! !
basicPackageVersion:!accessing!private! !
basicRemoveClass:!private!removing! !
basicRemoveVariableNamed:!private!removing! !
basicResetPrerequisites!initializing!private! !
basicScriptAt:put:!accessing!private! !
behaviors!enumerating!public! !
behaviorsDo:!enumerating!public! !
binaryGlobalNames:!accessing!legacy package loading!private! !
binaryVariableNames!accessing!private! !
bindingRefToLiteral:!helpers!private! !
buildPrerequisiteNames!helpers!private! !
calculatePrerequisites!helpers!private! !
canShowAbout!public!testing! !
changedFrom:!initializing!public! !
changeIndex!accessing!private! !
changeIndexValue:!accessing!private! !
classDefinitionsFileName!accessing!private! !
classes!accessing!public! !
classesDo:!enumerating!public! !
classesInHierarchyOrder!enumerating!private! !
classFromName:!helpers!private! !
classNames!accessing!public! !
classNames:!accessing!private! !
comment!accessing!public! !
comment:!accessing!public! !
convertOldMethodNames!legacy package loading!private! !
convertOldNames:!legacy package loading!private! !
convertOldNamesProperty:!legacy package loading!private! !
convertPoolDictionariesToSharedPools!legacy package loading!private! !
declareClasses!helpers!private! !
declareVariable:!helpers!private! !
declareVariables!helpers!private! !
dependentPackages!accessing!public! !
depthOfClass:!helpers!public! !
displayOn:!displaying!public! !
ensureNamesFullyQualified!loading!private! !
environment!helpers!private! !
environment:!helpers!private! !
environmentName:!initializing!private! !
evaluateScript:source:!private!source filing! !
fileInClasses!private!source filing! !
fileInScript:!private!source filing! !
fileNameForBinaryVariable:!helpers!private! !
fileNameForSourceVariable:!helpers!private! !
fileOutName!public!source filing! !
getEvents!accessing!private! !
getPrerequisites!accessing!private! !
globalAliases:!legacy package loading!private! !
globalNames!legacy package loading!public! !
hasCyclicPrerequisites!private!testing! !
hasCyclicPrerequisites:safe:!private!testing! !
hasUncommittedPrerequisites!private!testing! !
imageStripperBytes!accessing!private! !
imageStripperBytes:!accessing!private! !
includesClass:!public!testing! !
includesClassNamed:!public!testing! !
includesMethod:!public!testing! !
includesResourceIdentifier:!private!testing! !
includesVariableNamed:!public!testing! !
initialize!initializing!private! !
initializeClasses!initializing!private! !
initializeGlobals!initializing!private! !
initializeLegacyResources!initializing!private! !
initializeOldSourcePackage!initializing!private! !
isAlias:!initializing!private! !
isBasePackage!public!testing! !
isChanged!public!testing! !
isChanged:!accessing!public! !
isDefaultPackage!public!testing! !
isImportedClass:!initializing!private! !
isInstalled!public!testing! !
isLegacySourceFormat!public!testing! !
isSourceObject:!initializing!private! !
isSystemPackage!public!testing! !
load!initializing!private! !
loadBinaryVariables!initializing!private! !
loadPAC!loading!private! !
loadPAC:!loading!private! !
loadPAX!loading!private! !
looseResourceIdentifiers!initializing!public! !
looseResourceIdentifiersDo:!initializing!public! !
manager!initializing!public! !
manualPrerequisites!initializing!public! !
manualPrerequisites:!initializing!public! !
membershipChanged!initializing!private! !
membershipChangedAt:!events!private! !
memberUpdatedAt:!events!private! !
methodNames!accessing!public! !
methods!accessing!public! !
methodsDo:!enumerating!public! !
methodsOfClass:!accessing!public! !
name!accessing!public! !
nameForResourceIdentifier:!helpers!private! !
okToSaveOrDeploy!private!testing! !
okToUninstall!private!testing! !
onClassRemoved:!events!private! !
onClassRenamed:from:to:!events!private! !
onVariableRenamed:from:!events!private! !
owningPackage!adding!public! !
packageFileName!accessing!public! !
packageFileName:!accessing!private! !
packageFolder!accessing!public! !
packagePathname!accessing!private! !
packagePathname:!accessing!private! !
packageVersion!accessing!public! !
packageVersion:!accessing!public! !
path!accessing!public! !
paxVersion!accessing!private! !
paxVersion:!initializing!private! !
postinstall!operations!private! !
postLoadInitialization:!loading!private! !
preDeclareClassesOnLoad!accessing!public! !
preDeclareClassesOnLoad:!accessing!public! !
predeclareClassesSetting!accessing!private! !
preinstall!operations!private! !
prerequisiteNames!accessing!private! !
prerequisites!accessing!public! !
printOn:!initializing!public! !
privateUninstall!initializing!private! !
propertyAt:ifAbsent:!initializing!public! !
propertyAt:put:!properties!public! !
rebaseTo:!initializing!public! !
remainingClasses!initializing!public! !
removeAllProperties!properties!public! !
removeClass:!initializing!public! !
removeClassName:!initializing!private! !
removeGlobalNamed:!initializing!public! !
removeLooseMethod:!initializing!private! !
removeMethod:!initializing!public! !
removeMethodNames:!initializing!private! !
removePackagedMethod:!initializing!private! !
removePAXProperties!initializing!private! !
removePropertyAt:ifAbsent:!properties!public! !
removeVariableNamed:!initializing!public! !
renameLooseMethodsOf:to:!initializing!private! !
resetChangeFlags!initializing!public! !
resetPrerequisites!initializing!private! !
resourceIdentifiers!accessing!public! !
scriptAt:!accessing!public! !
scriptAt:put:!accessing!public! !
scripts!accessing!private! !
setAliasVariableNames:!initializing!private! !
setBinaryVariableNames:!initializing!private! !
setClassNames:!initializing!private! !
setEvents:!events!private! !
setManualPrerequisites:!initializing!private! !
setMethodNames:!initializing!private! !
setPackageFileName:!initializing!private! !
setPrerequisites:!initializing!private! !
setUntracedVariables:!initializing!private! !
setVariableNames:!initializing!private! !
shrink!operations!private! !
sourceDescriptor!accessing!private! !
sourceDescriptor:!accessing!private! !
sourceFilerClass!private!source filing-class definition! !
sourceFilerOn:!loading!private! !
sourceManager!accessing!public! !
sourceVariableExtension!constants!private! !
sourceVariableNames!accessing!private! !
storeComment!helpers!private! !
synchronizeNames!helpers!private! !
timestamp!accessing!public! !
timestamp:!accessing!private! !
trace:prerequisite:from:to:dependency:!helpers!private! !
tracePrerequisites!operations!private! !
tracePrerequisites:!operations!private! !
tracePrerequisitesOfClasses:packagedVariables:!operations!private! !
tracePrerequisitesOfEnvironment:!operations!private! !
tracePrerequisitesOfImageStripper:!operations!private! !
tracePrerequisitesOfLiterals:packagedVariables:!operations!private! !
tracePrerequisitesOfMethods:!operations!private! !
tracePrerequisitesOfResources:packagedVariables:!operations!private! !
tracePrerequisitesOfScripts:!operations!private! !
tracePrerequisitesOfVariables:packagedVariables:!operations!private! !
uninstall!public!removing! !
uninstallClasses!class hierarchy-removing!private!removing! !
uninstallMethods!private!removing! !
uninstallVariables!private!removing! !
untracedGlobals:!legacy package loading!private! !
untracedVariables!accessing!public! !
untracedVariables:!accessing!public! !
upateFileNames!operations!private! !
updateMethodNamesToFullyQualified!loading!private! !
updateNamesToFullyQualified!loading!private! !
upgrade!helpers!private! !
upgradeToVersion2!helpers!private! !
validate!operations!private! !
variableNames!accessing!public! !
variableNames:!accessing!private! !
variables!private!source filing! !
versionIfRequired!operations!private! !
warnChangingDefaultNamespaceFrom:to:!helpers!private! !
!

!Kernel.Package class methodsFor!

binaryPackageLoader
	^#{Kernel.LegacyBinaryPackageLoader} valueOrNil
		ifNil: [self error: 'Legacy binary package loading support is not available']!

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
			[(pacStream nextAvailable: 4) = '!!STB'
				ifTrue: 
					[pacStream close.
					pacStream := FileStream read: pathname text: false.
					self binaryPackageLoader readFrom: pacStream]
				ifFalse: 
					[pacStream reset.
					self readFrom: pacStream]]
					ensure: [pacStream close].
	answer ifNil: [self errorInvalidPACFile: pathname].
	^answer!

fromPAXFile: pathname
	"Private - Answer a new instance of the receiver created from the .PAX file at the
	specified <readableString> path, pathname, or raise an error if the file does not contain a
	package in source text representation."

	| paxStream answer |
	paxStream := FileStream read: pathname.
	answer := [self readFrom: paxStream] ensure: [paxStream close].
	answer ifNil: [self errorInvalidPAXFile: pathname].
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
				description: 'Package cannot be saved (check for cyclic dependencies or unpackaged prerequisites)'.
	CheckTimestamps := true!

manager
	"Answer the object responsible for managing the collection of installed packages."

	^PackageManager current!

name: nameString
	"Answer a new instance of the receiver with the <readableString> name, nameString."

	^self new
		setPackageFileName: nameString;
		yourself
!

named: aString
	"Answer an existing  instance of the receiver with the <readableString> name, aString."

	^self manager packageNamed: aString!

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
	2 - Early D8 format, using BindingReferences
	2.1 - D8 format with fully qualified names"

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

sourcePackageExtension
	"Private - Answer the file extension for the file to which sources for an instance of the
	receiver is filed out to."

	^ 'pax'!

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

!Kernel.Package class categoriesForMethods!
binaryPackageLoader!loading!private! !
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
named:!instance creation!public! !
new!instance creation!public! !
onPreStripImage!class hierarchy-removing!private! !
packageExtension!constants!private! !
packageFileVersion!constants!public! !
paxVersion!constants!private! !
preDeclareClassesOnLoad!accessing!public! !
preDeclareClassesOnLoad:!accessing!public! !
readFrom:!instance creation!private! !
sourcePackageExtension!constants!private! !
uncommitted!accessing!public! !
uninitialize!class hierarchy-removing!private! !
unsaveableSignal!constants!private! !
!

