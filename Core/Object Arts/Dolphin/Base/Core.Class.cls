"Filed out from Dolphin Smalltalk 7"!

Core.ClassDescription subclass: #'Core.Class'
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

absoluteName
	"Answer the <String> fully qualified name of this namespace, inclusive of 'Root'. This is guaranteed to be unambiguous."

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
					[self isChanged: true.
					binding isImmutable
						ifFalse: 
							["Wasn't constant, recompile if it can be inlined"
							VMLibrary hasBytecodeRepresentation: anObject]
						ifTrue: 
							[| oldValue |
							"Was constant, recompile if changed and was inlined, or can be inlined"
							oldValue := binding value.
							oldValue ~~ anObject and: 
									[(VMLibrary hasBytecodeRepresentation: oldValue) or: [VMLibrary hasBytecodeRepresentation: anObject]]]].
	requiresRecompile
		ifTrue: 
			[requiresRecompile := self canModifyBinding: binding newValue: anObject.
			"If aborted by user, don't set the value."
			requiresRecompile isNil ifTrue: [^binding]].
	binding
		setValue: anObject;
		isImmutable: true.
	requiresRecompile ifTrue: [Object recompileAllReferencesToLiteral: binding].
	^binding!

addClassVariable: aString value: anObject
	"Define a variable binding in the receiver's class pool with the specified name. If the
	variable already exists, this is a no-op. If the variable does not exist, a new binding is
	added with initial value nil."

	^(self addClassVarNamed: aString)
		isImmutable: false;
		value: anObject;
		yourself!

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
	(self allSubclasses detect: [:each | (each localBindingFor: aString) notNil] ifNone: [])
		ifNotNil: 
			[:existingClass |
			^self error: ('<1p> is already used as a variable name in class <2p>' expandMacrosWith: aString
						with: existingClass)].
	newVar := VariableBinding key: aString value: nil.
	newVar isClassVariable: true.
	self addBinding: newVar.
	^newVar!

addImport: aBindingReference
	(imports includes: aBindingReference) ifFalse: [imports := imports copyWith: aBindingReference]!

addSubclass: aClass
	"Private - Include the argument, aClass, as a subclass of the receiver."

	aClass superclass == self
		ifFalse: [^self error: ('I am not <1p>''s superclass' expandMacrosWith: aClass)].
	#namespaceToDo.	"Can we use a Set instead? Probably yes as the VM never accesses the subclasses inst var."
	"With the advent of namespaces there may be multiple subclasses with the same unqualified name, so we no longer maintain the array in sorted order."
	(subclasses identityIndexOf: aClass) == 0 ifTrue: [subclasses := subclasses copyWith: aClass]!

addToSuper
	"Private - Add the receiver as a subclass of its superclass."

	superclass ifNotNil: [superclass addSubclass: self]!

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

basicRemoveBinding: aVariableBinding
	classPool removeKey: aVariableBinding key ifAbsent: []!

binding
	"Answer the <VariableBinding> of this namespace within it's environment."

	"It should always be the case that the actual binding for a class is a directly held variable of it's environment. This applies even to the distinguished namespaces Smalltalk. Root is an exception in that it's environment is logically nil, however it's physical environment is itself and it contains its own binding."

	^self bindingOrNil
		ifNil: 
			[self
				error: ('Binding for <1p> not found in <2p>' expandMacrosWith: self unqualifiedName with: environment)]!

bindingFor: aString
	"Answer a variable binding for the named variable in the scope of this class (not including imports). If there is no such variable, then answer nil."

	^(self hierarchyBindingFor: aString)
		ifNil: [self environment ifNotNil: [:env | env bindingFor: aString]]!

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
	^ChunkReader do: [:chunkString | cats addLast: (catclass name: chunkString)]
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
	"Answer a Set of the class variable names of the receiver. The answer will include constant names, if any."

	^(self bindings select: [:each | each isClassVariable]) collect: [:each | each key]!

classCategories
	"Private - Answer a <collection> of <ClassCategory> objects representing the 
	class categories of which the receiver is a member, or nil if unclassified."

	^classCategories!

classCategories: categoryCollection 
	"Private - Set the class categories of the receiver to categoryCollection."

	classCategories := categoryCollection notEmpty 
				ifTrue: [categoryCollection asArray sort]!

classConstants
	"Answer a <Set> of <VariableBinding>s, being the class variables of the receiver, but not including class constants."

	^self bindings select: [:each | each isImmutable and: [each value isSelfEvaluating]]!

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

	^self bindings reject: [:each | each isImmutable and: [each value isSelfEvaluating]]!

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

definedBindings
	"Private - Answer the bindings that are defined as part of the receiver's class definition (as opposed to externally).
	For most classes this is all the class variables. For namespaces, this does not include any of the classes in the namespace as these are added to the namespace implicitly as part of their own definition."

	| defined |
	defined := Set new.
	self bindingsDo: [:each | each isClassVariable ifTrue: [defined add: each]].
	^defined!

environment
	"Answer the receiver's <Namespace>."

	^environment!

fileIn
	"File in the receiver's definition from a class file in the receiver's
	package directory."

	self sourceManager fileInPackagedClass: self!

fileOutName
	"Private - Answer the default file name for the class to file out on."

	| path |
	path := File composeStem: self fileOutStem extension: 'cls'.
	self owningPackage
		ifNil: [Notification signal: 'Warning: ' , self printString , ' is unpackaged']
		ifNotNil: [:package | path := File replacePath: path with: package path].
	^path!

fileOutStem
	"Private - Answer the default file name stem for the class to file out on."

	"Preserve original names for classes in Smalltalk to avoid causing source control churn."

	^environment == Smalltalk ifTrue: [self unqualifiedName] ifFalse: [self fullName]!

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

	^BindingReference pathString: self fullName!

getFullName
	| stream |
	(name isNil or: [environment isNil]) ifTrue: [^super fullName].
	environment == Root ifTrue: [^self name].
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
	imports := anArray.
	anArray isImmutable: true!

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
	"Answer whether the receiver includes the namespace argument (i.e. is it nested within it somewhere in its environment chain)."

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
	"Set/reset the receivers status as an abstract class. Note that a class may still answer
	true to #isAbstract even after setting this to false if it contains abstract methods (see
	#hasAbstractMethods)."

	self isNonInstantiable: aBoolean!

isAnonymous
	"Answer whether this is an anonymous (unbound) class."

	^name isNil!

isAtomic
	"Answer whether or not the receiver has a single unique instance for any individual value it
	can represent."

	"Each class is the singleton instance of a unique metaclass."

	^true!

isLiteral
	"Private - Answer whether or not the receiver has a literal representation (probably its	printString) which is directly recognised by the Compiler"

	^name notNil!

localBindingFor: aString
	"Answer a variable binding for the named variable directly in the scope of this class, i.e. one of its own class variables. If there is no such class variable, then answer nil."

	^classPool bindingFor: aString!

name
	"Answer a <readableString> that is the name of the receiver
	Implementation Note: For compatibility reasons, the answer is actually a Symbol."

	^name ifNil: [super name]!

newBindingContextForIdentifier: aString
	^Kernel.BindingContext source: self identifier: aString!

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
	If the namespace is not one of the outer environments the the path will be that from (but not including) Root."

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

printDefinitionOn: aPuttableStream
	"Private - Append the textual definition of the receiver to the <puttableStream> argument. Note that this includes the definition of the receiver's metaclass since we now define the whole caboodle using a single message."

	| classConstants classVariables |
	self superclass
		ifNil: [aPuttableStream nextPutAll: 'nil']
		ifNotNil: 
			[:base |
			base environment == base baseEnvironment
				ifTrue: [aPuttableStream nextPutAll: base name]
				ifFalse: [base printFullNameOn: aPuttableStream]].
	aPuttableStream
		space;
		nextPutAll: self kindOfSubclass;
		space;
		print: (self environment == self baseEnvironment
					ifTrue: [self unqualifiedName]
					ifFalse: [self fullName asSymbol]);
		crtab;
		nextPutAll: 'instanceVariableNames: ';
		print: self instanceVariableString;
		crtab;
		nextPutAll: 'classVariableNames: '''.
	classConstants := OrderedCollection new.
	classVariables := OrderedCollection new.
	self definedBindings asSortedCollection do: 
			[:each |
			((each isImmutable and: [each value isSelfEvaluating])
				ifTrue: [classConstants]
				ifFalse: [classVariables]) addLast: each].
	classVariables do: [:var | aPuttableStream nextPutAll: var key] separatedBy: [aPuttableStream space].
	aPuttableStream
		nextPut: $';
		crtab;
		nextPutAll: 'imports: ';
		print: self imports;
		crtab;
		nextPutAll: 'classInstanceVariableNames: ';
		print: self class instanceVariableString;
		crtab;
		nextPutAll: 'classConstants: {'.
	classConstants isEmpty
		ifFalse: 
			[classConstants do: 
					[:each |
					aPuttableStream
						crtab: 2;
						print: each]
				separatedBy: [aPuttableStream nextPut: $.].
			aPuttableStream crtab].
	aPuttableStream nextPut: $}!

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

removeClassVarName: aString
	"Remove the class variable from the receiver with the specified <readableString> name.
	Note: This is a low-level operation and does not recompile affected classes. Generally 
	speaking any modification to a class should be made through a <ClassBuilder>."

	self removeLocalBindingFor: aString.
	classPool isEmpty ifTrue: [classPool := nil]!

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
	imports := imports copyWithout: aBindingReference!

removeLocalBindingFor: aString
	^(self localBindingFor: aString)
		ifNotNil: 
			[:binding |
			self basicRemoveBinding: binding.
			self variableRemoved: binding.
			binding]!

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
	self rename: aString in: self environment.
	self sourceManager logEvaluate: (String writeStream
				nextPutAll: currentName;
				space;
				nextPutAll: #rename:;
				space;
				print: aString;
				contents)!

rename: aString in: aNamespace
	"Private - Rename the receiver to aString.
	This will change the receiver's key in the specified Namespace whilst maintaining the binding. This means that any existing references will be maintained but method source code will still contain the old name and will subsequently fail to compile unless edited.

	We Remove the receiver from the subclass collection of its superclass for the	duration of the rename just in case the subclass collection is ordered by name."

	| oldName binding |
	self removeFromSuper.
	oldName := name.
	binding := aNamespace changeKey: oldName to: aString.
	self setName: binding key asSymbol environment: binding environment.
	self addToSuper.
	"Note how the event is delayed until the class is correctly wired in"
	aNamespace variableRenamed: binding from: oldName!

requiresInstallation
	"Answer whether the receiver requires 'installing' into its environment."

	^name notNil!

resolveBindingPath: anArray
	"Private - Attempt to resolve a <VariableBinding> by walking the names in the argument through nested namespaces."

	| length |
	length := anArray size.
	length == 0 ifTrue: [^self binding].
	^(self resolveUnqualifiedName: (anArray at: 1))
		ifNotNil: 
			[:rootBinding |
			| binding namespace |
			binding := rootBinding.
			2 to: length
				do: 
					[:i |
					| identifier |
					namespace := binding value.
					identifier := anArray at: i.
					binding := namespace resolvePublicBinding: (self newBindingContextForIdentifier: identifier).
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
	^self environment
		ifNotNil: [:env | env resolveImportedBinding: aBindingContext]!

resolveLocallyImportedBinding: aBindingContext
	"Private - Search the directly imported namespaces for a binding that matches the identifier in the <BindingContext> argument."

	1 to: imports size
		do: 
			[:i |
			| each |
			each := imports at: i.
			(aBindingContext visitImport: each from: self)
				ifNotNil: [:namespace | (namespace resolvePublicBinding: aBindingContext) ifNotNil: [:binding | ^binding]]].
	^nil!

resolvePathString: aString
	(BindingReference isQualifiedName: aString) ifFalse: [^self resolveUnqualifiedName: aString].
	^self resolveBindingPath: ($. split: aString)!

resolvePublicBinding: aBindingContext
	"Private - Resolve a binding with public visibility in the receiver's hierarchy, or among its local imports.
	This is used to find bindings for second and subsequent components of qualified names."

	(self hierarchyBindingFor: aBindingContext identifier)
		ifNotNil: [:binding | binding isPrivate ifFalse: [^binding]].
	"Search only the local imports, not the imports of the imports."
	^self resolveLocallyImportedBinding: aBindingContext!

resolveUnqualifiedName: aString
	"Private - Attempt to find a binding for the specified unqualified name in the scope of the receiver. Variables defined in the class hierarchy should bind more tightly than those in the namespace (environment) hierarchy. Only after exhausting these hierarchies should the imports be searched, again with the same rule that imports into the class hierarchy bind more tightly than those into the environment hierarchy. In other words the binding resolution rules are:
		1. Variables defined in the class hierarchy, search first the local class variables, then those of the superclass, and so on up to a root class.
		2. Variables defined in the enclosing namespace hierarchy (i.e. the class' environment, the environment of the environment, and so on up to the Root namespace).
		3. The hierarchy and superclass variables of imported namespaces (shared pools in old money), then of the imports into the enclosing environment, and so on.
	The search for a variables defined in the class hierarchy cannot encounter cycles. Once the imported namespaces are brought into the mix, however, we can end up revisiting the same namespace more than once because the imports form a directed graph that may have cycles, not necessarily a tree. Obviously there is no point searching any reachable namespace more than once, and we also need the search to terminate, both of which conditions are achieved by maintaining a visited set in a BindingContext object.
	Namespace imports can be public or private. Private imports are only visited for searches initiated in the importee. Variables can also be private, in which case they can only be resolved locally."

	#namespaceToDo. "Private variables"
	^(self bindingFor: aString)
		ifNil: [self resolveImportedBinding: (self newBindingContextForIdentifier: aString)]!

setClassVarNames: anArray
	"Private - Change the set of class variables to be those specified in anArray. Existing
	variables which are still required are left untouched, those no longer required are deleted,
	and new ones may be added (initialised to nil). Answer whether any class variables were
	added (which may shadow existing bindings to spool or global variables) or removed as this
	indicates that a recompilation is required."

	| removed added original classVars |
	classVars := self classPool.
	original := self definedBindings collect: [:each | each key].
	removed := original difference: anArray.
	added := anArray difference: original.
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

setName: aSymbolOrNil environment: aNamespace
	"Private - Set the name of the receiver to be the <Symbol> or nil argument. The name can be nil for anonymous classes."

	(aSymbolOrNil notNil and: [BindingReference isQualifiedName: aSymbolOrNil])
		ifTrue: [self error: 'Invalid simple name ' , aSymbolOrNil].
	name := aSymbolOrNil.
	environment := aNamespace.
	fullName := self getFullName!

shortName
	"Answer the shorted <String> name of the receiver that is bindable from Smalltalk. i.e. for classes defined directly in Smalltalk, or in any of its imports, this will be an unqualified name. Otherwise it is the fully qualified name relative to Smalltalk."

	^name ifNil: [super name] ifNotNil: [Smalltalk shortNameFor: name in: self environment]!

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
	"Private - Record the receivers GUID to the change log."

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

subclass: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString poolDictionaries: poolDictString classInstanceVariableNames: classInstVarString classConstants: anArrayOfAssociations
	"For loading early 7.2 packages that didn't have fully qualified class names."

	| subclass |
	#namespaceToDo. "Remove this"
	subclass := (self
				newClassBuilder: aClassSymbol
				instanceVariableNames: instVarString
				classVariableNames: classVarString
				imports: (self importsFromPoolsString: poolDictString))
				classConstants: anArrayOfAssociations;
				modifyOrCreate.
	subclass class instanceVariableNames: classInstVarString.
	^subclass!

subclasses
	"Answer a <collection> containing the receiver's immediate subclasses.

	Note that the answer is actually a <sequencedReadableCollection>, but that sequenceability should not be relied upon in portable code because the ANSI standard specifies only <collection>."

	^subclasses!

subclasses: aCollection
	"Set the receivers subclasses to the specified collection. The subclasses are maintained as an immutable array."

	subclasses := aCollection asArray
				isImmutable: true;
				yourself!

subclassesDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the receiver's subclasses."

	subclasses do: aMonadicValuable!

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
		ifFalse: [Smalltalk trigger: #variableRemoved: with: aVariableBinding]!

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
!Core.Class categoriesFor: #absoluteName!accessing!namespaces!public! !
!Core.Class categoriesFor: #absoluteNameFor:!public! !
!Core.Class categoriesFor: #absoluteReference!accessing!namespaces!public! !
!Core.Class categoriesFor: #addBinding:!class variables!private! !
!Core.Class categoriesFor: #addClassConstant:value:!class variables!development!public! !
!Core.Class categoriesFor: #addClassVariable:value:!class hierarchy-mutating!class variables!public! !
!Core.Class categoriesFor: #addClassVarNamed:!class hierarchy-mutating!class variables!public! !
!Core.Class categoriesFor: #addImport:!namespaces!public! !
!Core.Class categoriesFor: #addSubclass:!class hierarchy-adding!private! !
!Core.Class categoriesFor: #addToSuper!class hierarchy-adding!private! !
!Core.Class categoriesFor: #allBindingsDo:visited:!enumerating!private! !
!Core.Class categoriesFor: #allEnvironments!class hierarchy-accessing!public! !
!Core.Class categoriesFor: #allEnvironmentsDo:!class hierarchy-accessing!enumerating!private! !
!Core.Class categoriesFor: #allImports!namespaces!public! !
!Core.Class categoriesFor: #basicAddBinding:!class variables!private! !
!Core.Class categoriesFor: #basicClassPool:!class variables!private! !
!Core.Class categoriesFor: #basicRemoveBinding:!bindings!private! !
!Core.Class categoriesFor: #binding!bindings!public! !
!Core.Class categoriesFor: #bindingFor:!bindings!public! !
!Core.Class categoriesFor: #bindingOrNil!bindings!public! !
!Core.Class categoriesFor: #bindingsDo:!bindings!enumerating!public! !
!Core.Class categoriesFor: #canModifyBinding:newValue:!bindings!private! !
!Core.Class categoriesFor: #categories!categories-accessing!public! !
!Core.Class categoriesFor: #categories:!categories-accessing!public! !
!Core.Class categoriesFor: #categoriesForClass!private!source filing-class definition! !
!Core.Class categoriesFor: #category!categories-accessing!public! !
!Core.Class categoriesFor: #category:!categories-accessing!public! !
!Core.Class categoriesFor: #classBindingNames!accessing!class variables!public! !
!Core.Class categoriesFor: #classCategories!categories-accessing!private!source filing! !
!Core.Class categoriesFor: #classCategories:!categories-accessing!private! !
!Core.Class categoriesFor: #classConstants!class variables!public! !
!Core.Class categoriesFor: #classPool!accessing!class variables!public! !
!Core.Class categoriesFor: #classUpdated!class hierarchy-mutating!class variables!private! !
!Core.Class categoriesFor: #classVariableRemoved:!class hierarchy-mutating!class variables!private! !
!Core.Class categoriesFor: #classVariables!class variables!public! !
!Core.Class categoriesFor: #clearGuid!accessing!private! !
!Core.Class categoriesFor: #comment!accessing!development!public! !
!Core.Class categoriesFor: #comment:!accessing!development!public! !
!Core.Class categoriesFor: #definedBindings!accessing!private! !
!Core.Class categoriesFor: #environment!accessing!public! !
!Core.Class categoriesFor: #fileIn!development!public!source filing! !
!Core.Class categoriesFor: #fileOutName!development!private!source filing! !
!Core.Class categoriesFor: #fileOutStem!development!private!source filing! !
!Core.Class categoriesFor: #fullName!accessing!namespaces!public! !
!Core.Class categoriesFor: #fullNameFor:!helpers!namespaces!private! !
!Core.Class categoriesFor: #fullPath!accessing!namespaces!private! !
!Core.Class categoriesFor: #fullyQualifiedReference!accessing!namespaces!public! !
!Core.Class categoriesFor: #getFullName!helpers!private! !
!Core.Class categoriesFor: #guid!constants!public! !
!Core.Class categoriesFor: #guid:!class hierarchy-adding!private! !
!Core.Class categoriesFor: #importedNamespacesDo:!namespaces!public! !
!Core.Class categoriesFor: #imports!namespaces!public! !
!Core.Class categoriesFor: #imports:!pool variables!public! !
!Core.Class categoriesFor: #importsFromPoolsString:!class hierarchy-adding!private! !
!Core.Class categoriesFor: #includeInCategory:!categories-adding!public! !
!Core.Class categoriesFor: #includesEnvironment:!private!testing! !
!Core.Class categoriesFor: #includesNamespace:!private!testing! !
!Core.Class categoriesFor: #initializeAfterLoad!class initialization!public! !
!Core.Class categoriesFor: #instanceClass!accessing!public! !
!Core.Class categoriesFor: #isAbstract:!instance specification-accessing!public! !
!Core.Class categoriesFor: #isAnonymous!public!testing! !
!Core.Class categoriesFor: #isAtomic!public!testing! !
!Core.Class categoriesFor: #isLiteral!public!testing! !
!Core.Class categoriesFor: #localBindingFor:!bindings!public! !
!Core.Class categoriesFor: #name!accessing!public! !
!Core.Class categoriesFor: #newBindingContextForIdentifier:!bindings!private! !
!Core.Class categoriesFor: #newClassBuilder:instanceVariableNames:classVariableNames:imports:!class hierarchy-adding!private! !
!Core.Class categoriesFor: #owningPackage!development!public!source filing! !
!Core.Class categoriesFor: #owningPackage:!accessing!development!public! !
!Core.Class categoriesFor: #packageManager!development!public!source filing! !
!Core.Class categoriesFor: #pathFrom:!accessing!private! !
!Core.Class categoriesFor: #printAbsoluteNameOn:!public! !
!Core.Class categoriesFor: #printDefinitionOn:!private!source filing-class definition! !
!Core.Class categoriesFor: #printFullNameOn:!helpers!private! !
!Core.Class categoriesFor: #printNameOn:relativeTo:!printing!private! !
!Core.Class categoriesFor: #printOn:!printing!public! !
!Core.Class categoriesFor: #printString!printing!public! !
!Core.Class categoriesFor: #removeClassVarName:!class hierarchy-mutating!class variables!public! !
!Core.Class categoriesFor: #removeFromCategory:!categories-removing!public! !
!Core.Class categoriesFor: #removeFromSuper!class hierarchy-removing!private! !
!Core.Class categoriesFor: #removeFromSystem!class hierarchy-removing!private! !
!Core.Class categoriesFor: #removeImport:!namespaces!public! !
!Core.Class categoriesFor: #removeLocalBindingFor:!bindings!public! !
!Core.Class categoriesFor: #removeSubclass:!class hierarchy-removing!private! !
!Core.Class categoriesFor: #rename:!class hierarchy-mutating!private! !
!Core.Class categoriesFor: #rename:in:!class hierarchy-mutating!private! !
!Core.Class categoriesFor: #requiresInstallation!public!testing! !
!Core.Class categoriesFor: #resolveBindingPath:!bindings!private! !
!Core.Class categoriesFor: #resolveImportedBinding:!bindings!private! !
!Core.Class categoriesFor: #resolveLocallyImportedBinding:!bindings!private! !
!Core.Class categoriesFor: #resolvePathString:!bindings!private! !
!Core.Class categoriesFor: #resolvePublicBinding:!bindings!private! !
!Core.Class categoriesFor: #resolveUnqualifiedName:!bindings!private! !
!Core.Class categoriesFor: #setClassVarNames:!class variables!private! !
!Core.Class categoriesFor: #setGuid:!accessing!private! !
!Core.Class categoriesFor: #setName:environment:!accessing!private! !
!Core.Class categoriesFor: #shortName!accessing!public! !
!Core.Class categoriesFor: #simpleName!accessing!public! !
!Core.Class categoriesFor: #sourceDescriptor!accessing!public!source filing! !
!Core.Class categoriesFor: #sourceDescriptor:!accessing!private!source filing! !
!Core.Class categoriesFor: #stbConvertFrom:!binary filing!private! !
!Core.Class categoriesFor: #stbModifyExportProxy:!binary filing!private! !
!Core.Class categoriesFor: #stbSaveOn:!binary filing!public! !
!Core.Class categoriesFor: #stbVersion!binary filing!public! !
!Core.Class categoriesFor: #storeGUID!private!source filing-class definition! !
!Core.Class categoriesFor: #subclass:instanceVariableNames:classVariableNames:imports:!class hierarchy-adding!public! !
!Core.Class categoriesFor: #subclass:instanceVariableNames:classVariableNames:imports:classInstanceVariableNames:classConstants:!class hierarchy-adding!public! !
!Core.Class categoriesFor: #subclass:instanceVariableNames:classVariableNames:poolDictionaries:classInstanceVariableNames:classConstants:!class hierarchy-adding!public! !
!Core.Class categoriesFor: #subclasses!class hierarchy-accessing!public! !
!Core.Class categoriesFor: #subclasses:!class hierarchy-mutating!public! !
!Core.Class categoriesFor: #subclassesDo:!class hierarchy-accessing!public! !
!Core.Class categoriesFor: #uninitialize!class hierarchy-removing!development!private! !
!Core.Class categoriesFor: #uninitializeBeforeRemove!class hierarchy-removing!public! !
!Core.Class categoriesFor: #unqualifiedName!accessing!public! !
!Core.Class categoriesFor: #variableAdded:!class hierarchy-mutating!class variables!private! !
!Core.Class categoriesFor: #variableByteSubclass:instanceVariableNames:classVariableNames:imports:!class hierarchy-adding!public! !
!Core.Class categoriesFor: #variableByteSubclass:instanceVariableNames:classVariableNames:imports:classInstanceVariableNames:classConstants:!class hierarchy-adding!public! !
!Core.Class categoriesFor: #variableRemoved:!class hierarchy-mutating!class variables!private! !
!Core.Class categoriesFor: #variableSubclass:instanceVariableNames:classVariableNames:imports:!class hierarchy-adding!public! !
!Core.Class categoriesFor: #variableSubclass:instanceVariableNames:classVariableNames:imports:classInstanceVariableNames:classConstants:!class hierarchy-adding!public! !

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
	answer := Array writeStream: 2500.
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

	self allBehaviorsDo: [:behavior | behavior methodDictionary do: operation]!

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

foldLiteralStrings
	"Fold duplicate literal strings so that there is only a single literal string for each unique character sequence in the image.
	This is should be a safe operation in Dolphin 6 because method literals are immutable.
		Class foldLiteralStrings
	"

	| after total literalStrings |
	literalStrings := Set new.
	total := 0.
	self allMethodsDo: 
			[:each |
			each whileMutableDo: 
					[1 to: each literalCount
						do: 
							[:i |
							| literal |
							literal := each literalAt: i.
							(literal isString and: [literal isSymbol not])
								ifTrue: 
									[total := total + 1.
									literalStrings add: literal.
									each literalAt: i put: (literalStrings find: literal)]]]].
	after := literalStrings size.
	^{total. after}! !
!Core.Class class categoriesFor: #allBehaviors!class hierarchy-accessing!private! !
!Core.Class class categoriesFor: #allBehaviorsDo:!enumerating!private! !
!Core.Class class categoriesFor: #allClasses!class hierarchy-accessing!private! !
!Core.Class class categoriesFor: #allClassesDo:!enumerating!private! !
!Core.Class class categoriesFor: #allMethodsDo:!enumerating!private! !
!Core.Class class categoriesFor: #allRoots!class hierarchy-accessing!private! !
!Core.Class class categoriesFor: #basicAllRoots!class hierarchy-accessing!private! !
!Core.Class class categoriesFor: #foldLiteralStrings!operations!public! !

