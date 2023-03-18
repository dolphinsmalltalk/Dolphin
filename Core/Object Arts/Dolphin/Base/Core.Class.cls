"Filed out from Dolphin Smalltalk"!

Core.ClassDescription
	subclass: #'Core.Class'
	instanceVariableNames: 'subclasses name fullName classPool imports environment comment classCategories _guid'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Class guid: (Core.GUID fromString: '{87b4c4fb-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.Class comment: '"Instances" of `Class` describe the representation and behavior of objects. `Class` adds more comprehensive programming support facilities to the basic ones provided in the abstract superclass `Behavior` and more descriptive facilities to the ones provided in the abstract superclass `ClassDescription`. In particular `Class` adds the representation for class variable names and shared (pool) variables.

In reality, `Class` has no instances. All classes in the system are actually instances of a parallel hierarchy of `Metaclass` instances, but they do have the same shape as `Class` and are logically, if not physically, instances of it.

## Instance Variables:

  `subclasses`		`Array` of `Behavior`''s which are the subclasses of the instance
 `name`			`Symbol` which is the name of the class
 `classPool`		`PoolDictionary` mapping class variable name <String>s to values
 `sharedPools`		`Array` of `Symbol` names of shared variable pools
 `environment`		`Namespace` in which the class is defined.
 `comment`		`String` comment about the class (like this one), or nil if none.
 `classCategories`	`Array` of `ClassCategory`. The categories of the class, if any.
 `_guid`			`GUID`. Unique identifier for the class.
'!
!Core.Class categoriesForClass!Kernel-Classes! !
!Core.Class methodsFor!

_rename: aString in: aNamespace
	"Private - Rename the receiver to aString.
	This will change the receiver's key in the specified Namespace whilst maintaining the binding. This means that any existing references will be maintained but method source code will still contain the old name and will subsequently fail to compile unless edited.

	We Remove the receiver from the subclass collection of its superclass for the	duration of the rename just in case the subclass collection is ordered by name."

	| oldName binding |
	self removeFromSuper.
	oldName := name.
	
	[binding := aNamespace changeKey: oldName to: aString.
	self setName: binding key asSymbol environment: binding environment]
			ensure: [self addToSuper].
	"Note how the event is delayed until the class is correctly wired in"
	aNamespace variableRenamed: binding from: oldName!

absoluteName
	"Answer the <String> absolute qualified name of this class, inclusive of 'Root'. This is guaranteed to be unambiguous."

	| stream |
	stream := WriteStream on: (Utf8String new: 40).
	self printAbsoluteNameOn: stream.
	^stream contents!

absoluteNameFor: aString
	"Private - Answer the fully qualified name of the (supposed) identifier in this namespace, aString, inclusive of 'Root'"

	| stream |
	stream := String writeStream: 32.
	self printAbsoluteNameOn: stream.
	stream
		nextPut: $.;
		nextPutAll: aString.
	^stream contents!

absoluteReference
	"Answer a <BindingReference> representing a path from Root to the receiver."

	^BindingReference path: (self pathFrom: nil)!

addBinding: aVariableBinding
	^(self basicAddBinding: aVariableBinding) and: 
			[self variableAdded: aVariableBinding.
			true]!

addClassConstant: anAssociation
	self addClassConstant: anAssociation key value: anAssociation value!

addClassConstant: aString value: anObject
	"Define a constant binding in the receiver's class pool with the specified name. If the
	variable already exists, it is marked as constant, and if its existing value is different
	from anObject, then anObject is assigned to the underlying variable and any methods that may
	reference the constant are recompiled to pick up the new value. If the variable does not
	exist, a constant binding is added with initial value nil."

	| binding count requiresRecompile |
	count := classPool ifNil: [0] ifNotNil: [classPool size].
	binding := self addClassVarNamed: aString.
	"We need to recompile if we are modifying an existing binding and either:
		- the binding was not constant, and the new constant value is inlineable
		- the binding was constant, but the value has changed, and either the previous or new value are inlineable"
	requiresRecompile := classPool size = count and: 
					[binding isImmutable
						ifFalse: 
							["Wasn't constant, recompile if it can be inlined"
							VMLibrary hasBytecodeRepresentation: anObject]
						ifTrue: 
							[| oldValue |
							"Was constant, recompile if changed and was inlined, or can be inlined"
							oldValue := binding value.
							oldValue == anObject
								ifTrue: 
									["Unchanged constant - no change"
									^binding].
							(VMLibrary hasBytecodeRepresentation: oldValue) or: [VMLibrary hasBytecodeRepresentation: anObject]]].
	requiresRecompile
		ifTrue: 
			[requiresRecompile := self canModifyBinding: binding newValue: anObject.
			"If aborted by user, don't set the value."
			requiresRecompile ifNil: [^binding]].
	binding
		setValue: anObject;
		isImmutable: true.
	self isChanged: true.
	requiresRecompile ifTrue: [Object recompileAllReferencesToLiteral: binding].
	^binding!

addClassVariable: aString value: anObject
	"Define a variable binding in the receiver's class pool with the specified name. If the
	variable already exists, this is a no-op. If the variable does not exist, a new binding is
	added with initial value nil."

	| binding count requiresRecompile |
	count := classPool ifNil: [0] ifNotNil: [classPool size].
	binding := self addClassVarNamed: aString.
	"We need to recompile if we are modifying an existing binding and the binding was constant and its value was inlineable"
	requiresRecompile := classPool size = count
				and: [binding isImmutable and: [VMLibrary hasBytecodeRepresentation: binding value]].
	binding
		setValue: anObject;
		isImmutable: false.
	self isChanged: true.
	requiresRecompile ifTrue: [Object recompileAllReferencesToLiteral: binding].
	^binding!

addClassVarNamed: aString
	"Answer the binding for a new or existing class variable in the receiver with the specified
	<readableString>. Note: This is a low-level operation and does not recompile affected
	classes. Generally speaking any modification to a class should be made through a
	<ClassBuilder>. It is not considered an error to re-add a class variable that already exists
	in the class, but it is an error to attempt to add a class variable already defined
	somewhere in the hierarchy below the class. "

	| newVar |
	classPool isNil ifTrue: [classPool := Dictionary new].
	(classPool bindingFor: aString) ifNotNil: [:existingVar | ^existingVar].
	(self allSubclasses detect: [:each | (each localBindingFor: aString) notNil] ifNone: nil)
		ifNotNil: 
			[:existingClass |
			^self error: ('<1p> is already used as a variable name in class <2p>' expandMacrosWith: aString
						with: existingClass)].
	newVar := VariableBinding key: aString value: nil.
	newVar isClassVariable: true.
	self addBinding: newVar.
	^newVar!

addImport: aBindingReference
	(imports includes: aBindingReference)
		ifFalse: [self imports: (imports copyWith: aBindingReference asNamespaceImport)]!

addSubclass: aClass
	"Private - Include the argument, aClass, as a subclass of the receiver."

	aClass class isMeta ifFalse: [^self error: '<1p> is not a Class' << aClass].
	aClass superclass == self
		ifFalse: [^self error: ('I am not <1p>''s superclass' expandMacrosWith: aClass)].
	"With the advent of namespaces there may be multiple subclasses with the same unqualified name, so we no longer maintain the array in sorted order."
	(subclasses identityIndexOf: aClass) == 0 ifTrue: [subclasses := subclasses copyWith: aClass]!

addToSuper
	"Private - Add the receiver as a subclass of its superclass."

	superclass ifNotNil: [superclass addSubclass: self]!

allBindingsDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the bindings in the receiver, including aliases, and recursively in any of the nested namespaces."

	self allBindingsDo: aMonadicValuable visited: (IdentitySet with: self)!

allBindingsDo: aMonadicValuable visited: aSet
	self bindingsDo: 
			[:each |
			| value |
			aMonadicValuable value: each.
			each isClassVariable
				ifFalse: 
					[value := each value.
					(value class isMeta and: [aSet addNewElement: value])
						ifTrue: [value allBindingsDo: aMonadicValuable visited: aSet]]]!

allClasses
	"Answer a <collection> of all the <Class>es that are values of bindings in the receiver, including aliases, and recursively in any of the nested namespaces."

	| classes |
	classes := Array writeStream: 256.
	self allClassesDo: [:each | classes nextPut: each].
	^classes contents!

allClassesDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the <Class>es that are values of bindings in the receiver, excluding aliases, and recursively in any of the nested namespaces."

	self allBindingsDo: 
			[:each |
			each isClassVariable
				ifFalse: 
					[| value |
					value := each value.
					(value class isMeta and: [value name == each key and: [value environment == each environment]])
						ifTrue: [aMonadicValuable value: value]]]!

allEnvironments
	"Answer a <sequencedReadableCollection> of the receiver's environment and in turn its environment, and so on, to the top of the namespace tree. The last entry should always be Root, apart from for Root itself (which has no enclosing environments)."

	| answer |
	answer := Array writeStream: 3.
	self allEnvironmentsDo: [:each | answer nextPut: each].
	^answer grabContents!

allEnvironmentsDo: aMonadicValuable
	"Private - Evaluate the monadic valuable argument for each of the receiver's enclosing environments."

	| current |
	current := self environment.
	[current isNil] whileFalse: 
			[aMonadicValuable value: current.
			current := current environment]!

allImports
	"Answer a <sequencedReadableCollection> of <BindingReference> being the imports that are specified in the receiver and each of its superclasses."

	| all seen |
	all := Array writeStream: 5.
	seen := Set new.
	self
		withAllSuperclassesDo: [:c | c imports do: [:each | (seen addNewElement: each) ifTrue: [all nextPut: each]]].
	^all contents!

basicAddBinding: aVariableBinding
	^((classPool ifNil: [classPool := Dictionary new]) addNewElement: aVariableBinding) and: 
			[aVariableBinding environment: self.
			true]!

basicClassPool: aDictionaryOrNil
	"Private - Set or nil out the receiver's class pool (dictionary of class variables). As the majority of classes do not have any class variables, the Dictionary is only stored if non-empty.
	The VariableBindings in this Dictionary are those referenced from CompiledMethod's literal frame - if you are calling this method make certain you understand what you're doing!!"

	classPool := aDictionaryOrNil ifNotNil: [aDictionaryOrNil isEmpty ifFalse: [aDictionaryOrNil]]!

basicEnvironment
	^environment!

basicRemoveBinding: aVariableBinding
	classPool removeKey: aVariableBinding key ifAbsent: nil!

binding
	"Answer the <VariableBinding> of this namespace within it's environment."

	"It should always be the case that the actual binding for a class is a directly held variable of it's environment. This applies even to the distinguished namespaces Smalltalk. Root is an exception in that it's environment is logically nil, however it's physical environment is itself and it contains its own binding."

	^self bindingOrNil
		ifNil: 
			[self
				error: ('Binding for <1p> not found in <2p>' expandMacrosWith: self unqualifiedName with: environment)]!

bindingFor: aString
	"Answer a variable binding for the named variable in the scope of this class (not including imports). If there is no such variable, then answer nil."

	^(self hierarchyBindingFor: aString) ifNil: [environment bindingFor: aString]!

bindingFor: aString environment: aNamespace
	"Answer a variable binding for the named variable in the scope of this class (not including imports). If there is no such variable, then answer nil."

	^(self hierarchyBindingFor: aString) ifNil: [aNamespace ifNotNil: [aNamespace bindingFor: aString]]!

bindingOrNil
	"Answer the receiver's variable binding, or nil if unbound"

	^environment localBindingFor: self unqualifiedName!

bindingsDo: aMonadicValuable
	classPool ifNotNil: [classPool associationsDo: aMonadicValuable]!

canModifyBinding: aVariableBinding newValue: anObject
	^true!

categories
	"Answer a <Array> of <ClassCategory>s in which the receiver is included.
	This will always contains at least one entry ('Unclassified' if there are no others)."

	^classCategories ifNil: [{self classCategoryClass unclassified}]!

categories: aCollection
	"Set the Categories of the receiver to those in the specified <collection> of <ClassCategory>s.
	Remove from any other categories."

	| unclassified newCategories oldCategories |
	unclassified := self classCategoryClass unclassified.
	newCategories := aCollection reject: [:c | c = unclassified].
	oldCategories := self classCategories ?? #().
	(newCategories symmetricDifference: oldCategories) notEmpty ifFalse: [^self].
	self classCategories: newCategories.
	self isChanged: true.
	self storeClassCategories.
	Smalltalk trigger: #classCategorized: with: self!

categoriesForClass
	"Private - Answer an <ChunkReader> configured for reading the receiver's
	<ClassCategory>s."

	| catclass cats |
	catclass := self classCategoryClass.
	cats := OrderedCollection new.
	^ChunkReader do: [:chunkString :filer | cats addLast: (catclass name: chunkString)]
		atEnd: [self categories: cats]!

category
	"Answer the <ClassCategory> of the receiver or nil if it does not have one.

	If the receiver is associated with a number of category objects then the alphabetically
	first one is answered (the list is maintained in sort order)."

	| categories |
	categories := self categories.
	^categories notEmpty ifTrue: [categories first]!

category: category
	"Set the category of the receiver to be the <ClassCategory> category, or the
	<ClassCategory> named by the <readableString>, category.
	The receiver is removed from any existing categories."

	self categories: {self classCategoryClass name: category asString}!

classBindingNames
	"Answer a <collection> of <String>s that contains the class variable names of the receiver. The answer will include constant names, if any. It does not include any non-class variables defined in the receiver (usually only relevant for Namespaces)."

	^self definedBindings collect: [:each | each key]!

classCategories
	"Private - Answer a <collection> of <ClassCategory> objects representing the 
	class categories of which the receiver is a member, or nil if unclassified."

	^classCategories!

classCategories: categoryCollection
	"Private - Set the class categories of the receiver to categoryCollection."

	classCategories := categoryCollection isEmpty ifFalse: [categoryCollection asSortedArray]!

classConstants
	"Answer a <Set> of <VariableBinding>s, being the class constants of the receiver."

	^self definedBindings select: [:each | each isImmutable and: [each value isSelfEvaluating]]!

classInstanceVariableNames
	^self class instanceVariableNames!

classPool
	"Answer the Dictionary of class variables belonging to the receiver.
	N.B. This should not be modified as it may not be the actual class pool
	(though it is guaranteed to have identical contents)."

	^classPool ifNil: [Dictionary new]!

classUpdated
	self logDefinition.
	Smalltalk classUpdated: self!

classVariableRemoved: aString
	self logDefinition.
	Smalltalk classUpdated: self!

classVariables
	"Answer a <collection> of <VariableBinding>s, being the class variables of the receiver, but not including class constants."

	^self definedBindings reject: [:each | each isImmutable and: [each value isSelfEvaluating]]!

clearGuid
	"Private - Set the receiver's GUID to be the null <GUID>.
	Might be overridden by subclasses which must retain their GUIDs (e.g. COMInterfaces)."

	_guid := nil!

comment
	"Answer the class comment for the receiver."

	^String readFrom: (self sourceManager getSourceFromDescriptor: comment) readStream!

comment: blahBlah
	"Set the class comment for the receiver to the readableString, blahBlah."

	self sourceManager storeCommentString: blahBlah forClass: self.
	self isChanged: true.
	"No need to clear the class caches in this case"
	Smalltalk trigger: #classCommented: with: self!

environment
	"Answer the receiver's <Namespace>."

	^environment!

environment: anObject
	environment := anObject!

fileIn
	"File in the receiver's definition from a class file in the receiver's
	package directory."

	self sourceManager fileInPackagedClass: self!

fileOutName
	"Private - Answer the default file name for the class to file out on."

	^self sourceFilerClass fileOutNameForClass: self!

fileOutNameForClass: aClass
	"Private - Answer the default file name for the class to file out on."

	^self sourceFilerClass fileOutNameForClass: self!

fileOutStem
	"Private - Answer the default file name stem for the class to file out on."

	"Preserve original names for classes in Smalltalk to avoid causing source control churn."

	^environment == Smalltalk ifTrue: [self unqualifiedName] ifFalse: [self fullName]!

fullBindingFor: aString environment: aNamespace
	"Answer a variable binding for the named variable in the scope of this class, and failing that in the specified environment (or the receiver's environment if aNamespace is nil). If there is no such variable, then answer nil."

	^self resolvePathString: aString environment: (aNamespace ifNil: [self environment])!

fullName
	"Answer the <String> fully qualified name of the receiver, which is a dot-separated path that binds to the receiver from the global namespace, Root."

	^fullName!

fullNameFor: aString
	"Private - Answer the full name  of a variable with the specified local identifier, assumed to be in this namespace. This will be a (potentially) dot-separated path string that is bindable from any top-level namespace, including Smalltalk."

	| stream |
	stream := String writeStream: 32.
	self printFullNameOn: stream.
	stream
		nextPut: $.;
		nextPutAll: aString.
	^stream contents!

fullPath
	^self pathFrom: Root!

fullyQualifiedReference
	"Answer a <BindingReference> that represents a fully qualified reference to the receiver relative to the Root namespace. Classes in the legacy 'flat' Smalltalk namespace will have Smalltalk as the first element of the binding path."

	^BindingReference fullPathString: self fullName!

getFullName
	| stream |
	name isNil ifTrue: [^super fullName].
	(environment isNil or: [environment == Root]) ifTrue: [^self name].
	stream := WriteStream on: (Utf8String new: 32).
	self printNameOn: stream relativeTo: Root.
	^stream contents!

guid
	"Answer the receiver's globally unique id (a 128-bit number allocated/set 
	when the receiver was created or filed in)."

	^_guid ifNil: [GUID null]!

guid: id
	"Private - Set the value of the receiver's 'guid' instance variable to the 
	<GUID>, id.
	N.B. A classes GUID should not normally be changed after the class has
	been created, but should remain with it throughout its life."

	self setGuid: id.
	self storeGUID!

importedNamespacesDo: aMonadicValuable
	imports do: [:each | each valueOrNil ifNotNil: [:ns | aMonadicValuable value: ns]]!

imports
	"Answer a <sequencedReadableCollection> of the <Namespaces> imported into the receiver's scope."

	^imports!

imports: anArray
	| newImports |
	newImports := anArray asArray.
	newImports = imports ifTrue: [^self].
	(ClassBuilder forModifying: self)
		imports: newImports;
		modifyExistingClass!

importsFromPoolsString: poolDictString
	^poolDictString subStrings distinct collect: [:each | each asQualifiedReference]!

includeInCategory: category
	"Add the receiver to the ClassCategory with specified name, while leaving it in its existing
	set of categories."

	self categories: (self categories asSet add: (self classCategoryClass name: category asString); yourself)!

includesEnvironment: aClass
	"Answer whether the receiver includes the namespace argument (i.e. is it nested within it somewhere in its environment chain)."

	^self == aClass or: [self environment includesEnvironment: aClass]
!

includesNamespace: aClass
	"Answer whether the receiver includes the namespace argument (i.e. is it a sub-namespace, or is it nested within it somewhere in its environment chain)."

	^self == aClass or: [(self inheritsFrom: aClass) or: [self environment includesEnvironment: aClass]]!

initializeAfterLoad
	"Perform any post-load initialisation for the class. This includes any specific #initialize
	implementation (but not that #initialize is only sent to classes which directly implement
	#initialize, otherwise we'd end up re-initializing the class variables of the superclass
	every time a new subclass was added).
	There may be some circumstances where an entire hierarchy of classes requires some
	common initialization after load, in which case this message can be overridden."

	"Initialize if necessary"
	(self class includesSelector: #initialize) ifTrue: [self initialize].

	"Flag as not changed"
	self isChanged: false!

instanceClass
	"Answer the receiver's singleton instance (the actual class object)."

	^self!

isAbstract: aBoolean
	"Set/reset the receiver's status as an abstract class. Note that a class may still answer
	true to #isAbstract even after setting this to false if it contains abstract methods (see
	#hasAbstractMethods)."

	self isNonInstantiable: aBoolean!

isAnonymous
	"Answer whether this is an anonymous (unbound) class."

	^name isNil!

isSelfEvaluating
	"Private - Answer whether or not the receiver has a printed representation which is directly recognised by the Compiler"

	^name notNil!

legacySourceFilerClass
	^#{LegacyChunkSourceFiler} valueOrNil ifNil: [ChunkSourceFiler]!

localBindingFor: aString
	"Answer a variable binding for the named variable directly in the scope of this class, i.e. one of its own class variables. If there is no such class variable, then answer nil."

	^classPool bindingFor: aString!

metaclass
	"Answer the <Metaclass> of the Class/Metaclass pair."

	^self class!

name
	"Answer a <readableString> that is the name of the receiver
	Implementation Note: For compatibility reasons, the answer is actually a Symbol."

	^name ifNil: [super name]!

nestedClasses
	"Answer a <collection> of all the <Class>es that are directly nested within this class when considered as a namespace, excluding any that are only aliased here."

	| classes |
	classes := Array writeStream: 8.
	self nestedClassesDo: [:each | classes nextPut: each].
	^classes contents!

nestedClassesDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the <Class>es that are values of bindings in the receiver, excluding classes that are aliased into this namespace."

	self bindingsDo: 
			[:each |
			each isClassVariable
				ifFalse: 
					[| value |
					value := each value.
					(value class isMeta and: [value environment == self]) ifTrue: [aMonadicValuable value: value]]]!

newBindingContextForIdentifier: aString environment: aNamespace
	^BindingContext
		methodClass: self
		environment: aNamespace
		identifier: aString!

newClassBuilder: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString imports: anArrayOfBindingReferences
	^ClassBuilder new
		superclass: self;
		className: aClassSymbol;
		instanceVariableString: instVarString;
		classVariableString: classVarString;
		imports: anArrayOfBindingReferences;
		yourself!

owningPackage
	"Answers the package that owns the receiver or nil if it is not yet owned by any package."

	"Anonymous classes cannot be packaged"

	name isNil ifTrue: [^nil].

	"We use an indirect reference to Package to avoid referencing this development class in a runtime image. The answer should always be nil in a runtime application."
	^self packageManager ifNotNil: [:pkgmgr | pkgmgr packageOfClass: self]!

owningPackage: aPackageOrNil
	"Set the receiver's <Package> to be the argument. Any current package association is replaced.
	Note that setting the owning package of a class to the distinguished '_Uncommitted' package is the same as setting it to nil, and the class becomes unpackaged."

	self packageManager addClass: self to: aPackageOrNil!

packageManager
	"We use an indirect reference to Package to avoid referencing this development class in a runtime image. The answer should always be nil in a runtime application."

	^#{PackageManager} valueOrNil ifNotNil: [:pkgMgrClass | pkgMgrClass current]!

pathFrom: aNamespace
	"Private - Answer an <Array> of <String> representing the identifier path from the specified namespace to the receiver through any intervening namespaces.
	If the namespace is not one of the outer environments then the path will be that from (but not including) Root."

	| stream current |
	self isAnonymous ifTrue: [^#()].
	stream := Array writeStream: 4.
	current := self.
	[current == aNamespace or: [current isNil]] whileFalse: 
			[stream nextPut: current unqualifiedName.
			current := current environment].
	^stream reverseContents!

printAbsoluteNameOn: aPuttableStream
	name
		ifNil: [self printOn: aPuttableStream]
		ifNotNil: [self printNameOn: aPuttableStream relativeTo: nil]!

printFullNameOn: aPuttableStream
	name
		ifNil: [self printOn: aPuttableStream]
		ifNotNil: [aPuttableStream nextPutAll: fullName]!

printNameOn: aPuttableStream relativeTo: outerNamespace
	(self environment isNil or: [environment == outerNamespace])
		ifFalse: 
			[environment printNameOn: aPuttableStream relativeTo: outerNamespace.
			aPuttableStream nextPut: $.].
	aPuttableStream nextPutAll: self unqualifiedName!

printOn: aStream
	"Append, to the <puttableStream> argument a string that describes the receiver as a developer would expect.
	If the receiver is resolvable in Smalltalk using its unqualified name then print that, otherwise print the fully qualified name."

	aStream nextPutAll: self shortName!

printString
	"Answer a <String> that describes the receiver as a developer would expect. If the receiver is resolvable in Smalltalk this is the class' unqualified name, otherwise the fully qualified name."

	^self shortName!

refersTo: anObject asLiteralOf: aCompiledCode
	"Private - Answer whether the receiver, a literal of the <CompiledCode> 2nd argument, is a reference to the <Object> first argument."

	^(self class == anObject class and: [self = anObject])
		or: [(anObject isKindOf: VariableBinding) and: [anObject value == self and: [anObject isClassBinding]]]!

removeBindingFor: aString
	^(self localBindingFor: aString)
		ifNotNil: 
			[:binding |
			self basicRemoveBinding: binding.
			self variableRemoved: binding.
			binding]!

removeClassConstant: anAssociation
	self removeClassVarName: anAssociation key!

removeClassVarName: aString
	"Remove the class variable from the receiver with the specified <readableString> name.
	Note: This is a low-level operation and does not recompile affected classes. Generally 
	speaking any modification to a class should be made through a <ClassBuilder>."

	self removeBindingFor: aString.
	(classPool notNil and: [classPool isEmpty]) ifTrue: [classPool := nil]!

removeFromCategory: category
	"Remove the receiver from the aCategoryOrString, while leaving it in any other
	class categories."

	| classCat |
	classCat := self classCategoryClass name: category asString.
	self categories: (self categories asSet remove: classCat; yourself)!

removeFromSuper
	"Private - Remove the receiver as a subclass of its superclass and do the same for the receiver's metaclass buddy."

	superclass ifNotNil: [superclass removeSubclass: self].
	^superclass!

removeFromSystem
	"Private - Remove the receiver from the system. This method will fail if the class has instances or subclasses so these must be removed first where ever  possible, which should be done in an #uninitialize method. #unitialize is sent immediately before the class is removed, but (like #initialize) only if directly implemented by the class - i.e. it will not be sent if the implementation
	is inherited. N.B. Do not supersend #uninitialize from an override, as you may damage a superclass which is not being removed."

	self subclassesDo: [:each | each removeFromSystem].
	self sourceManager logEvaluate: self name , ' removeFromSystem'.
	ClassBuilder removeClass: self!

removeImport: aBindingReference
	self imports: (imports copyWithout: aBindingReference)!

removeSubclass: aClass
	"Private - Remove the argument, aClass, from the subclasses of the receiver.
	WARNING: This method does not completely remove a class from the system."

	| index |
	index := subclasses identityIndexOf: aClass.
	index == 0 ifFalse: [subclasses := subclasses copyWithoutIndex: index]!

rename: aString
	"Private - Change the name of the receiver to aString.
	N.B. This is the low-level rename operation, and does not rename any references
	to the class."

	| currentName |
	currentName := self absoluteName.
	self _rename: aString in: self environment.
	self sourceManager logEvaluate: (String writeStream
				nextPutAll: currentName;
				space;
				nextPutAll: #rename:;
				space;
				print: aString;
				contents)!

replaceImport: oldBindingReference with: newBindingReference
	"Private - Replace an existing import with a new one, maintaining the existing order."

	self imports: (self imports copyReplacing: oldBindingReference withObject: newBindingReference)!

requiresInstallation
	"Answer whether the receiver requires 'installing' into its environment."

	^name notNil!

resolveBindingPath: anArray
	"Private - Attempt to resolve a <VariableBinding> by walking the names in the argument through nested namespaces."

	^self resolveBindingPath: anArray environment: self environment!

resolveBindingPath: anArray environment: aNamespace
	"Private - Attempt to resolve a <VariableBinding> by walking the names in the argument through nested namespaces."

	| length |
	length := anArray size.
	length == 0 ifTrue: [^self binding].
	^(self resolveUnqualifiedName: (anArray at: 1) environment: aNamespace)
		ifNotNil: 
			[:rootBinding |
			| binding namespace |
			binding := rootBinding.
			2 to: length
				do: 
					[:i |
					| identifier |
					"We don't want to attempt to drill into normal class variables"
					binding isClassVariable ifTrue: [^nil].
					namespace := binding value.
					namespace class isMeta ifFalse: [^nil].
					identifier := anArray at: i.
					binding := namespace
								resolvePublicBinding: (self newBindingContextForIdentifier: identifier environment: aNamespace).
					binding isNil ifTrue: [^nil]].
			binding]!

resolveImportedBinding: aBindingContext
	"Private - Search imported namespaces for a binding that matches the identifier in the <BindingContext> supplied. The search proceeds up through the class hierarchy (i.e. imports in the class hierarchy are inherited), and then out to the imports of the enclosing namespace. Imports into the enclosing namespaces of superclasses are not searched."

	| current |
	current := self.
	
	[(current resolveLocallyImportedBinding: aBindingContext) ifNotNil: [:binding | ^binding].
	current := current superclass.
	current isNil]
			whileFalse.
	^aBindingContext environment
		ifNotNil: [:env | env resolveImportedEnvironmentBinding: aBindingContext]!

resolveImportedEnvironmentBinding: aBindingContext
	"Private - Search imported namespaces for a binding that matches the identifier in the <BindingContext> supplied searching the localling imported namespaces, and then recursively up through the enclosing environments."

	(self resolveLocallyImportedBinding: aBindingContext) ifNotNil: [:var | ^var].
	^self environment ifNotNil: [:env | env resolveImportedEnvironmentBinding: aBindingContext]!

resolveLocalBindingPath: anArray
	"Private - Attempt to resolve a <VariableBinding> by walking the names in the argument through nested namespaces, but considering only the directly defined variables.
	This is used for deterministic resolution of namespace imports."

	| length |
	length := anArray size.
	length == 0 ifTrue: [^self binding].
	^(self localBindingFor: (anArray at: 1))
		ifNotNil: 
			[:rootBinding |
			| binding namespace |
			binding := rootBinding.
			2 to: length
				do: 
					[:i |
					| identifier |
					"We don't want to attempt to drill into normal class variables"
					binding isClassVariable ifTrue: [^nil].
					namespace := binding value.
					namespace class isMeta ifFalse: [^nil].
					identifier := anArray at: i.
					binding := namespace localBindingFor: identifier.
					binding isNil ifTrue: [^nil]].
			binding]!

resolveLocallyImportedBinding: aBindingContext
	"Private - Search the directly imported namespaces for a binding that matches the identifier in the <BindingContext> argument."

	1 to: imports size
		do: 
			[:i |
			(aBindingContext visitImport: (imports at: i) from: self)
				ifNotNil: [:namespace | (namespace resolvePublicBinding: aBindingContext) ifNotNil: [:var | ^var]]].
	^nil!

resolvePathString: aString environment: aNamespace
	(BindingReference isQualifiedName: aString)
		ifFalse: [^self resolveUnqualifiedName: aString environment: aNamespace].
	^self resolveBindingPath: (BindingReference.PathSeparator split: aString) environment: aNamespace!

resolvePublicBinding: aBindingContext
	"Private - Resolve a binding with public visibility in the receiver's hierarchy, or among its local imports.
	This is used to find bindings for second and subsequent components of qualified names."

	(self hierarchyBindingFor: aBindingContext identifier)
		ifNotNil: [:binding | binding isPrivate ifFalse: [^binding]].
	"Search only the local imports, not the imports of the imports."
	^self resolveLocallyImportedBinding: aBindingContext!

resolveUnqualifiedName: aString environment: aNamespace
	"Private - Attempt to find a binding for the specified unqualified name in the scope of the receiver. Variables defined in the class hierarchy should bind more tightly than those in the namespace (environment) hierarchy. Only after exhausting these hierarchies should the imports be searched, again with the same rule that imports into the class hierarchy bind more tightly than those into the environment hierarchy. In other words the binding resolution rules are:
		1. Variables defined in the class hierarchy, search first the local class variables, then those of the superclass, and so on up to a root class.
		2. Variables defined in the enclosing namespace hierarchy (i.e. the class' environment, the environment of the environment, and so on up to the Root namespace).
		3. The hierarchy and superclass variables of imported namespaces (shared pools in old money), then of the imports into the enclosing environment, and so on.
	The search for a variables defined in the class hierarchy cannot encounter cycles. Once the imported namespaces are brought into the mix, however, we can end up revisiting the same namespace more than once because the imports form a directed graph that may have cycles, not necessarily a tree. Obviously there is no point searching any reachable namespace more than once, and we also need the search to terminate, both of which conditions are achieved by maintaining a visited set in a BindingContext object.
	Namespace imports can be public or private. Private imports are only visited for searches initiated in the importee. Variables can also be private, in which case they can only be resolved locally."

	^((self hierarchyBindingFor: aString)
		ifNil: [aNamespace ifNotNil: [aNamespace bindingFor: aString]])
			ifNil: 
				[self resolveImportedBinding: (self newBindingContextForIdentifier: aString environment: aNamespace)]!

setClassVarNames: anArray
	"Private - Change the set of class variables to be those specified in anArray. Existing
	variables which are still required are left untouched, those no longer required are deleted,
	and new ones may be added (initialised to nil). Answer whether any class variables were
	added (which may shadow existing bindings to spool or global variables) or removed as this
	indicates that a recompilation is required."

	| removed added original classVars |
	classVars := self classPool.
	original := self definedBindings collect: [:each | each key].
	removed := original difference: anArray asSet.
	added := anArray difference: original asSet.
	^(added notEmpty or: [removed notEmpty]) and: 
			[removed do: [:each | classVars removeKey: each].
			added do: 
					[:each |
					classVars add: ((VariableBinding key: each value: nil)
								environment: self;
								isClassVariable: true;
								yourself)].
			classPool := classVars notEmpty ifTrue: [classVars].
			true]!

setGuid: id
	"Private - Set the value of the receiver's 'guid' instance variable to the 
	<GUID>, id.
	N.B. A classes GUID should not normally be changed after the class has
	been created, but should remain with it throughout its life."

	_guid := id.
!

setImports: anArray
	imports := anArray collect: [:each | each asNamespaceImport]!

setName: aSymbolOrNil environment: aNamespace
	"Private - Set the name of the receiver to be the <Symbol> or nil argument. The name can be nil for anonymous classes."

	(aSymbolOrNil notNil and: [BindingReference isQualifiedName: aSymbolOrNil])
		ifTrue: [self error: 'Invalid simple name ' , aSymbolOrNil].
	name := aSymbolOrNil.
	environment := aNamespace.
	fullName := self getFullName!

shortName
	"Answer the shortest <String> name of the receiver that is bindable from Smalltalk. i.e. for classes defined directly in Smalltalk, or in any of its imports, this will be an unqualified name. Otherwise it is the fully qualified name relative to Smalltalk."

	^name
		ifNil: [super name]
		ifNotNil: 
			[self isInBaseEnvironment ifTrue: [name] ifFalse: [Smalltalk shortNameFor: name in: environment]]!

simpleName
	"Answer the receiver's name within it's environment.
	This is defined for compatibility. Use #unqualifiedName by preference."

	^self unqualifiedName!

sourceDescriptor
	"Answer the source descriptor for the receiver's comment."

	^comment!

sourceDescriptor: sourceDes
	"Private - Set the class comment source descriptor for the receiver 
	to sourceDes, the format of which only the SourceManager understands."

	comment := sourceDes!

sourceFilerClass
	^self owningPackage
		ifNil: [environment == Smalltalk ifTrue: [self legacySourceFilerClass] ifFalse: [ChunkSourceFiler]]
		ifNotNil: [:package | package sourceFilerClass]!

stbConvertFrom: anSTBClassFormat
	"Private - Answer a block that answers a new instance initialised from the block's single
	parameter, an Array or ByteArray representing the old object whose format is
	described by anSTBClassFormat.

	By default, classes only know about the current format."

	^nil!

stbModifyExportProxy: anSTBImportedClassProxy
	"Private - This is an opportunity to modifiy the classes' binary export proxy just before it is
	output (to an STC file). The default is to do nothing - the standard STBImportedClassProxy is
	generally sufficient for nearly all cases."!

stbSaveOn: anSTBOutFiler
	"Save out a binary representation of the receiver to anSTBOutFiler."

	"Note that the STL filer does not use this - Classes are stored as literal references in the literal store array"

	anSTBOutFiler saveObject: self as: (STBClassProxy forClass: self)!

stbVersion
	"If instances of a class are saved out to an STBOutFiler and must
	remain loadable even if the class format changes then we need to be able
	to distinguish between the different formats. A new binary format is
	created whenever the number or order of instance variables in a class
	are changed. All classes initially answer a version number of zero.

	This identification of a changed format is achieved by overriding this
	class method in the changed subclass to answer a new SmallInteger.
	Also, in order to 'upgrade' an old instance to a new one, you must
	provide or amend the class method #stbConvertFrom:."

	^0!

storeGUID
	"Private - Record the receiver's GUID to the change log."

	self sourceManager storeGUIDForClass: self
!

subclass: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString imports: anArrayOfBindingReferences
	^(self
		newClassBuilder: aClassSymbol
		instanceVariableNames: instVarString
		classVariableNames: classVarString
		imports: anArrayOfBindingReferences) modifyOrCreate!

subclass: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString imports: anArrayOfBindingReferences classInstanceVariableNames: classInstVarString classConstants: anArrayOfAssociations
	"Create or modify the class, classSymbol, to be a subclass of the receiver with the specified instance variables, class pool, pool dictionaries, class instance variables, and class constants."

	| subclass |
	subclass := (self
				newClassBuilder: aClassSymbol
				instanceVariableNames: instVarString
				classVariableNames: classVarString
				imports: anArrayOfBindingReferences)
				classConstants: anArrayOfAssociations;
				modifyOrCreate.
	subclass class instanceVariableNames: classInstVarString.
	^subclass!

subclass: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString poolDictionaries: poolDictString category: aCategoryOrString
	"If aClassSymbol is not an existing class then create and answer a new fixed pointer subclass, otherwise modify the class with name aClassSymbol to have the indicated features and answer it.
	Primarily present for backwards compatibility with Smalltalk-80 and used by the Refactory Browser classes."

	^(self
		subclass: aClassSymbol
		instanceVariableNames: instVarString
		classVariableNames: classVarString
		imports: (self importsFromPoolsString: poolDictString))
		categories: {ClassCategory name: aCategoryOrString};
		yourself!

subclasses
	"Answer a <collection> containing the receiver's immediate subclasses.

	Note that the answer is actually a <sequencedReadableCollection>, but that sequenceability should not be relied upon in portable code because the ANSI standard specifies only <collection>."

	^subclasses!

subclasses: aCollection
	"Set the receiver's subclasses to the specified collection. The subclasses are maintained as an immutable array."

	subclasses := aCollection asArray
				isImmutable: true;
				yourself!

subclassesDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the receiver's subclasses."

	subclasses do: aMonadicValuable!

unaliasedName
	"Answer the shortest name for the receiver that is bindable from Smalltalk without using an alias."

	^self isInBaseEnvironment
		ifTrue: [name]
		ifFalse: 
			[| binding |
			binding := Smalltalk fullBindingFor: name.
			(binding notNil and: [binding environment == environment]) ifTrue: [name] ifFalse: [fullName]]!

uninitialize
	"Private - Perform any uninitialisation for the class - typically clearing down class variables - in
	preparation for removal from the system. You should override this method if, for example,
	your class maintains a registry of its own instances in a class variable.
	This message will only be sent to a class which directly implements it, i.e. it will not be
	sent if the implementation is inherited."

	^self error: 'Do not supersend #uninitialize'!

uninitializeBeforeRemove
	"Perform any pre-removal uninitialisation for the class. This includes any specific #uninitialize
	implementation (but note that #uninitialize is only sent to classes which directly implement
	#uninitialize, otherwise we'd probably end up damaging superclasses which are not being
	removed).
	There may be some circumstances where an entire hierarchy of classes requires some
	common uninitialization prior to removal, in which case this message can be overridden."

	(self class includesSelector: #uninitialize) ifTrue: [self uninitialize].
!

unqualifiedName
	"Answer a <Symbol> that is the name of the receiver in it's environment."

	^name!

variableAdded: aVariableBinding
	super variableAdded: aVariableBinding.
	aVariableBinding isClassVariable ifTrue: [self classUpdated]!

variableByteSubclass: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString imports: anArray
	^(self
		newClassBuilder: aClassSymbol
		instanceVariableNames: instVarString
		classVariableNames: classVarString
		imports: anArray)
		beBytes;
		modifyOrCreate!

variableByteSubclass: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString imports: anArray classInstanceVariableNames: classInstVarString classConstants: anArrayOfAssociations
	"Create or modify the class named, classSymbol, to be a variable-byte subclass (has indexable byte-size nonpointer variables) of the receiver with the specified class pool, and pool dictionaries, and class instance variables. Note that variable byte classes cannot have any named instance variables, and therefore the instVarString must be empty."

	| subclass |
	subclass := (self
				newClassBuilder: aClassSymbol
				instanceVariableNames: instVarString
				classVariableNames: classVarString
				imports: anArray)
				classConstants: anArrayOfAssociations;
				beBytes;
				modifyOrCreate.
	subclass class instanceVariableNames: classInstVarString.
	^subclass!

variableRemoved: aVariableBinding
	super variableRemoved: aVariableBinding.
	aVariableBinding isClassVariable
		ifTrue: 
			[self logDefinition.
			Smalltalk classUpdated: self]
		ifFalse: [Smalltalk staticVariableRemoved: aVariableBinding]!

variableSubclass: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString imports: anArray
	^(self
		newClassBuilder: aClassSymbol
		instanceVariableNames: instVarString
		classVariableNames: classVarString
		imports: anArray)
		beVariable;
		modifyOrCreate!

variableSubclass: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString imports: anArray classInstanceVariableNames: classInstVarString classConstants: anArrayOfAssociations
	"Create or modify the class named classSymbol to be a variable subclass (has indexable pointer variables) of the receiver with the specified instance variables, class variables, class constants, pool dictionaries, and class instance variables."

	| subclass |
	subclass := (self
				newClassBuilder: aClassSymbol
				instanceVariableNames: instVarString
				classVariableNames: classVarString
				imports: anArray)
				classConstants: anArrayOfAssociations;
				beVariable;
				modifyOrCreate.
	subclass class instanceVariableNames: classInstVarString.
	^subclass! !
!Core.Class categoriesForMethods!
_rename:in:!class hierarchy-mutating!private! !
absoluteName!accessing!namespaces!public! !
absoluteNameFor:!public! !
absoluteReference!accessing!namespaces!public! !
addBinding:!class variables!public! !
addClassConstant:!class variables!development!public! !
addClassConstant:value:!class variables!development!public! !
addClassVariable:value:!class hierarchy-mutating!class variables!public! !
addClassVarNamed:!class hierarchy-mutating!class variables!public! !
addImport:!namespaces!public! !
addSubclass:!class hierarchy-adding!private! !
addToSuper!class hierarchy-adding!private! !
allBindingsDo:!enumerating!public! !
allBindingsDo:visited:!enumerating!private! !
allClasses!accessing!public! !
allClassesDo:!enumerating!public! !
allEnvironments!class hierarchy-accessing!public! !
allEnvironmentsDo:!class hierarchy-accessing!enumerating!private! !
allImports!namespaces!public! !
basicAddBinding:!class variables!private! !
basicClassPool:!class variables!private! !
basicEnvironment!accessing!public! !
basicRemoveBinding:!bindings!private! !
binding!bindings!public! !
bindingFor:!bindings!public! !
bindingFor:environment:!bindings!public! !
bindingOrNil!bindings!public! !
bindingsDo:!bindings!enumerating!public! !
canModifyBinding:newValue:!bindings!private! !
categories!categories-accessing!public! !
categories:!categories-accessing!public! !
categoriesForClass!private!source filing-class definition! !
category!categories-accessing!public! !
category:!categories-accessing!public! !
classBindingNames!accessing!class variables!public! !
classCategories!categories-accessing!private!source filing! !
classCategories:!categories-accessing!private! !
classConstants!class variables!public! !
classInstanceVariableNames!public! !
classPool!accessing!class variables!public! !
classUpdated!class hierarchy-mutating!class variables!private! !
classVariableRemoved:!class hierarchy-mutating!class variables!private! !
classVariables!class variables!public! !
clearGuid!accessing!private! !
comment!accessing!development!public! !
comment:!accessing!development!public! !
environment!accessing!public! !
environment:!accessing!private! !
fileIn!development!public!source filing! !
fileOutName!development!private!source filing! !
fileOutNameForClass:!development!private!source filing! !
fileOutStem!development!private!source filing! !
fullBindingFor:environment:!binding!public! !
fullName!accessing!namespaces!public! !
fullNameFor:!helpers!namespaces!private! !
fullPath!accessing!namespaces!private! !
fullyQualifiedReference!accessing!namespaces!public! !
getFullName!helpers!private! !
guid!constants!public! !
guid:!class hierarchy-adding!private! !
importedNamespacesDo:!namespaces!public! !
imports!namespaces!public! !
imports:!class hierarchy-mutating!public! !
importsFromPoolsString:!class hierarchy-adding!private! !
includeInCategory:!categories-adding!public! !
includesEnvironment:!public!testing! !
includesNamespace:!public!testing! !
initializeAfterLoad!class initialization!public! !
instanceClass!accessing!public! !
isAbstract:!instance specification-accessing!public! !
isAnonymous!public!testing! !
isSelfEvaluating!public!testing! !
legacySourceFilerClass!development!private!source filing-class definition! !
localBindingFor:!bindings!public! !
metaclass!accessing!public! !
name!accessing!public! !
nestedClasses!accessing!public! !
nestedClassesDo:!enumerating!public! !
newBindingContextForIdentifier:environment:!bindings!private! !
newClassBuilder:instanceVariableNames:classVariableNames:imports:!class hierarchy-adding!private! !
owningPackage!development!public!source filing! !
owningPackage:!accessing!development!public! !
packageManager!development!public!source filing! !
pathFrom:!accessing!private! !
printAbsoluteNameOn:!public! !
printFullNameOn:!helpers!private! !
printNameOn:relativeTo:!printing!private! !
printOn:!printing!public! !
printString!printing!public! !
refersTo:asLiteralOf:!private!testing! !
removeBindingFor:!bindings!public! !
removeClassConstant:!class variables!development!public! !
removeClassVarName:!class hierarchy-mutating!class variables!public! !
removeFromCategory:!categories-removing!public! !
removeFromSuper!operations!private! !
removeFromSystem!class hierarchy-removing!private! !
removeImport:!class hierarchy-mutating!namespaces!public! !
removeSubclass:!helpers!private! !
rename:!class hierarchy-mutating!private! !
replaceImport:with:!applying!private! !
requiresInstallation!public!testing! !
resolveBindingPath:!bindings!private! !
resolveBindingPath:environment:!bindings!private! !
resolveImportedBinding:!bindings!private! !
resolveImportedEnvironmentBinding:!binding!private! !
resolveLocalBindingPath:!bindings!private! !
resolveLocallyImportedBinding:!bindings!private! !
resolvePathString:environment:!bindings!private! !
resolvePublicBinding:!bindings!private! !
resolveUnqualifiedName:environment:!bindings!private! !
setClassVarNames:!class variables!private! !
setGuid:!accessing!private! !
setImports:!accessing!private! !
setName:environment:!accessing!private! !
shortName!accessing!public! !
simpleName!accessing!public! !
sourceDescriptor!accessing!public!source filing! !
sourceDescriptor:!accessing!private!source filing! !
sourceFilerClass!development!private!source filing-class definition! !
stbConvertFrom:!binary filing!private! !
stbModifyExportProxy:!binary filing!private! !
stbSaveOn:!binary filing!public! !
stbVersion!binary filing!public! !
storeGUID!private!source filing-class definition! !
subclass:instanceVariableNames:classVariableNames:imports:!class hierarchy-adding!public! !
subclass:instanceVariableNames:classVariableNames:imports:classInstanceVariableNames:classConstants:!class hierarchy-adding!public! !
subclass:instanceVariableNames:classVariableNames:poolDictionaries:category:!class hierarchy-adding!public! !
subclasses!class hierarchy-accessing!public! !
subclasses:!class hierarchy-mutating!public! !
subclassesDo:!class hierarchy-accessing!public! !
unaliasedName!public!ston! !
uninitialize!class hierarchy-removing!development!private! !
uninitializeBeforeRemove!class hierarchy-removing!public! !
unqualifiedName!accessing!public! !
variableAdded:!class hierarchy-mutating!class variables!private! !
variableByteSubclass:instanceVariableNames:classVariableNames:imports:!class hierarchy-adding!public! !
variableByteSubclass:instanceVariableNames:classVariableNames:imports:classInstanceVariableNames:classConstants:!class hierarchy-adding!public! !
variableRemoved:!class hierarchy-mutating!class variables!private! !
variableSubclass:instanceVariableNames:classVariableNames:imports:!class hierarchy-adding!public! !
variableSubclass:instanceVariableNames:classVariableNames:imports:classInstanceVariableNames:classConstants:!class hierarchy-adding!public! !
!

Core.Class methodProtocol: #importableNamespace attributes: #(#readOnly) selectors: #(#asQualifiedReference #fullName #includesEnvironment: #resolveLocalBindingPath: #resolvePublicBinding:)!
Core.Class methodProtocol: #namespace attributes: #(#readOnly) selectors: #(#addBinding: #addImport: #environment #fullBindingFor:environment: #fullName #hierarchyBindingFor: #imports #includesNamespace: #localBindingFor: #removeBindingFor: #removeImport: #unqualifiedName)!

!Core.Class class methodsFor!

allBehaviors
	"Private - Answer a Set of all of the Behaviors contained in the system.
	N.B. There is currently no specified ordering (hence the answer is a Set)."

	| answer |
	answer := Set new: 1000.
	self allBehaviorsDo: [:behavior | answer add: behavior].
	^answer!

allBehaviorsDo: operation
	"Private - Evaluate the monadic valuable, operation, for each of the Behaviors in the system.
	N.B. No guarantee is made about ordering, except that the operation is evaluated
	for a subclass after its superclass."

	self allClassesDo: [ :class |
		operation value: class.
		operation value: class class]!

allClasses
	"Private - Answer an OrderedCollection of all of the classes in the system, in breadth-first order.
	There is no particular ordering at a particular depth.
	N.B. Do not change this ordering to depth-first without careful thought about the
	implications for the rest of the system (even though it might be faster)."

	| answer roots |
	roots := self allRoots.
	answer := Array writeStream: 3000.
	roots do: [:each | answer nextPut: each].
	roots do: [:root | root allSubclassesBreadthFirstDo: [:each | answer nextPut: each]].
	^answer contents!

allClassesDo: operation
	"Private - Evaluate the monadic valuable, operation, for each of the classes in the system.
	N.B. No guarantee is made about ordering, except that the block is evaluated
	for a subclass after its superclass."

	self allRoots do: [:root | root withAllSubclassesDo: operation]!

allMethodsDo: operation
	"Private - Evaluate the monadic valuable, operation, for each and every method in the system
	which is connected into the class hierarchy. No ordering should be assumed."

	self allBehaviorsDo: [:behavior | behavior methodsDo: operation]!

allRoots
	"Private - Answer a Collection of all global root classes - ie. those that are subclasses of nil.
	The answered collection will include only global classes. We do a bit of shuffling to ensure that
	Object will be the first class."

	| roots i |
	roots := self basicAllRoots select: 
					[:each |
					| binding |
					binding := each bindingOrNil.
					binding notNil and: [binding value == each]].
	i := roots identityIndexOf: Object.
	i == 1
		ifFalse: 
			[roots at: i put: (roots at: 1).
			roots at: 1 put: Object].
	^roots!

basicAllRoots
	"Private - Answer a Collection of all root classes - ie. those that are subclasses of nil."

	^(Metaclass primAllInstances select: [:meta | meta instanceClass superclass isNil])
		collect: [:meta | meta instanceClass]!

foldLiterals
	"Fold literals of certain types to save space. This is should be a safe operation in Dolphin because method literals are immutable."

	| totalStrings literalStrings annotations totalAnnotations |
	literalStrings := Set new.
	annotations := Set new.
	totalStrings := 0.
	totalAnnotations := 0.
	self allMethodsDo: 
			[:each |
			| count |
			count := each size.
			count > 0
				ifTrue: 
					[each whileMutableDo: 
							[| literal |
							1 to: count
								do: 
									[:i |
									literal := each at: i.
									(literal isString and: [literal isSymbol not])
										ifTrue: 
											[totalStrings := totalStrings + 1.
											each at: i put: (literalStrings addIfAbsent: literal)]].
							(literal isKindOf: MethodAnnotations)
								ifTrue: 
									[totalAnnotations := totalAnnotations + 1.
									each at: count put: (annotations addIfAbsent: literal)]]]].
	^LookupTable new
		at: #strings put: {totalStrings. literalStrings size};
		at: #annotations put: {totalAnnotations. annotations size};
		yourself! !
!Core.Class class categoriesForMethods!
allBehaviors!class hierarchy-accessing!private! !
allBehaviorsDo:!enumerating!private! !
allClasses!class hierarchy-accessing!private! !
allClassesDo:!enumerating!private! !
allMethodsDo:!enumerating!private! !
allRoots!class hierarchy-accessing!private! !
basicAllRoots!class hierarchy-accessing!private! !
foldLiterals!operations!public! !
!

