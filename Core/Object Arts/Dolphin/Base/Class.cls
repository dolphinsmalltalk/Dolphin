"Filed out from Dolphin Smalltalk 7"!

ClassDescription subclass: #Class
	instanceVariableNames: 'subclasses name classPool imports environment comment classCategories _guid'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Class guid: (GUID fromString: '{87b4c4fb-026e-11d3-9fd7-00a0cc3e4a32}')!
Class comment: '"Instances" of `Class` describe the representation and behavior of objects. `Class` adds more comprehensive programming support facilities to the basic ones provided in the abstract superclass `Behavior` and more descriptive facilities to the ones provided in the abstract superclass `ClassDescription`. In particular `Class` adds the representation for class variable names and shared (pool) variables.

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
!Class categoriesForClass!Kernel-Classes! !
!Class methodsFor!

absoluteName
	"Answer the <String> fully qualified name of this namespace, inclusive of 'Root'"

	| stream |
	stream := String writeStream: 32.
	self printNameOn: stream relativeTo: nil.
	^stream contents!

absoluteNameOfIdentifier: aString
	"Private - Answer the fully qualified name of the (supposed) identifier in this namespace, aString, inclusive of 'Root'"

	| stream |
	stream := String writeStream: 32.
	self printNameOn: stream relativeTo: nil.
	stream
		nextPut: $.;
		nextPutAll: aString.
	^stream contents!

absoluteReference
	"Answer a <BindingReference> representing a path from Root to the receiver."

	^self fullyQualifiedReferenceFrom: nil!

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

	| varName var |
	varName := aString trimBlanks.	"Allow symbolic names too"
	classPool := self classPool.
	(classPool bindingFor: varName) ifNotNil: [:existingVar | ^existingVar].
	(self allSubclasses detect: [:each | (each classPool bindingFor: varName) notNil] ifNone: [])
		ifNotNil: 
			[:existingClass |
			^self error: ('<1p> is already used as a variable name in class <2p>' expandMacrosWith: aString
						with: existingClass)].
	var := classPool newAssociation: varName value: nil.
	classPool add: var.
	self logDefinition.
	Smalltalk classUpdated: self.
	^var!

addSubclass: aClass
	"Private - Include the argument, aClass, as a subclass of the receiver."

	| subs count index |
	aClass superclass == self
		ifFalse: [^self error: ('I am not <1p>''s superclass' expandMacrosWith: aClass)].
	subs := self subclasses.
	count := subs size.
	count == 0
		ifTrue: 
			[subclasses := {aClass}.
			^self].
	"Maintain the array in sorted order as saves sorting on access - speed is important to minimize class creation time"
	index := subs binarySearchFor: aClass using: [:a :b | a name <=> b name <= 0].
	(index > 1 and: [(subs at: index - 1) == aClass]) ifTrue: [^self].
	subclasses := subs copyWith: aClass atIndex: index!

addToSuper
	"Private - Add the receiver as a subclass of its superclass."

	superclass ifNotNil: [superclass addSubclass: self]!

allImports
	"Answer a <sequencedReadableCollection> of <BindingReference> being the imports that are specified in the receiver and each of its superclasses."

	| pools seen |
	pools := Array writeStream: 5.
	seen := IdentitySet new.
	self withAllSuperclassesDo: 
			[:c |
			c imports do: [:each | (seen addNewElement: each) ifTrue: [pools nextPut: each]]].
	^pools contents!

allInstances
	"Answer an <Array> of all direct instances of the receiver."

	MemoryManager current collectGarbage.
	^self primAllInstances!

allInstVarNames
	"Answer an <Array> of the <readableString> names of the receiver's instance variables, 
	those specified in the receiver and in all of its superclasses. The array ordering is the order 
	in which the variables are stored and accessed by the interpreter."

	^superclass isNil
		ifTrue: [self instVarNames]
		ifFalse: [superclass allInstVarNames , self instVarNames]!

allMethodsDo: operation
	"Evaluate the monadic valuable, operation, for each and every method defined in the hierarchy rooted in the receiver."

	self withAllSubclassesDo: [:behavior | behavior methodDictionary do: operation]!

allProtocols
	"Answer a <collection> of all the <MethodProtocol>s implemented by the receiver's
	instances, including those inherited from superclasses."

	| answer |
	answer := IdentitySet new.
	self withAllSuperclassesDo: [ :c | answer addAll: c protocols].
	^answer!

allSelectors
	"Answer a <Set> of <Symbol>s, being all the message selectors to which the receiver 
	is able to respond (this includes messages understood by superclasses)."

	| answer |
	answer := IdentitySet new.
	self withAllSuperclassesDo: [:each | answer addAll: each selectors].
	^answer!

basicClassPool
	"Private - Answer the receiver's class pool (dictionary of class variables)."

	^classPool
!

basicClassPool: aDictionaryOrNil
	"Private - Set the receiver's class pool (dictionary of class variables).
	The Associations in this Dictionary are those referenced from CompiledMethod's
	literal frame - if you are calling this method make certain you understand what
	you're doing!!"

	classPool := aDictionaryOrNil!

binding
	"Answer the <VariableBinding> of this namespace within it's enclosing <Namespace>."

	^self environment bindingAt: self simpleName!

bindingFor: aString
	"Answer a variable binding for the named variable in the scope of this class (i.e. one of its own class variables), or one of the shared pools it references, or the result of attempting the same binding resolution up the receiver's superclass chain (i.e. shared pools are inherited just like class variables). The receiver's environment, and that of its superclasses, is not searched.  If there is no such variable, then answer nil."

	classPool isNil ifFalse: [(classPool bindingFor: aString) ifNotNil: [:classVar | ^classVar]].
	imports
		do: [:each | (each valueOrNil ifNotNil: [:ns | ns bindingFor: aString]) ifNotNil: [:sharedVar | ^sharedVar]].
	^superclass bindingFor: aString!

bindingOrNil
	"Answer the receiver's variable binding, or nil if unbound"

	^self environment bindingAt: self simpleName ifAbsent: []!

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
	^ChunkReader 
		do: [:chunkString | cats addLast: (catclass name: chunkString)]
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

classBinding
	^self environment bindingFor: self name!

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

	^classPool ifNil: [PoolDictionary forClass: self]!

classVariables
	"Answer a <collection> of <VariableBinding>s, being the class variables of the receiver, but not including class constants."

	^self bindings reject: [:each | each isImmutable and: [each value isSelfEvaluating]]!

classVarNames
	"Answer a Set of the class variable names of the receiver."

	^classPool isNil ifTrue: [Set new] ifFalse: [classPool keys]!

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

environment: aNamespace
	"Set the receiver's <Namespace>."

	environment := aNamespace!

fileIn
	"File in the receiver's definition from a class file in the receiver's
	package directory."

	self sourceManager fileInPackagedClass: self!

fileOutName
	"Private - Answer the default file name for the class to file out on."

	| path package |
	path := File composeStem: self fileOutStem extension: 'cls'.
	self owningPackage
		ifNil: [Notification signal: 'Warning: ', self printString, ' is unpackaged']
		ifNotNil: [:package | path := File replacePath: path with: package path].
	^path!

fileOutStem
	"Private - Answer the default file name stem for the class to file out on."

	^self name!

fullName
	"Answer the <String> fully qualified name of the receiver, which is a dot-separated path from (but not including) Smalltalk."

	| stream |
	stream := String writeStream: 32.
	self printNameOn: stream relativeTo: Smalltalk.
	^stream contents!

fullNameOfIdentifier: aString
	"Private - Answer the full name (i.e. a dot-separated path from Smalltalk) of a variable with the specified local identifier, assumed to be in this namespace."

	| stream |
	stream := String writeStream: 32.
	self printNameOn: stream relativeTo: Smalltalk.
	stream
		nextPut: $.;
		nextPutAll: aString.
	^stream contents!

fullyQualifiedReference
	"Answer a <BindingReference> that represents a fully qualified reference to the receiver."

	^self fullyQualifiedReferenceFrom: Smalltalk!

fullyQualifiedReferenceFrom: aNamespace
	"Answer a <BindingReference> that represents the path from the specified <Namespace>, assumed to be a parent namespace, to the receiver."

	| outer |
	outer := self environment.
	^(self == aNamespace or: [outer isNil or: [outer == aNamespace]])
		ifTrue: [BindingReference pathString: self name home: aNamespace]
		ifFalse: [(outer fullyQualifiedReferenceFrom: aNamespace) append: self name]!

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
	imports := anArray!

importsFromPoolsString: poolDictString
	^poolDictString subStrings distinct collect: [:each | each asQualifiedReference]!

includeInCategory: category
	"Add the receiver to the ClassCategory with specified name, while leaving it in its existing
	set of categories."

	self categories: (self categories asSet add: (self classCategoryClass name: category asString); yourself)!

includesNamespace: aClass
	"Answer whether the receiver includes the namespace argument (i.e. is it nested within it somewhere in its environment chain)."

	^Error notYetImplemented!

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
	"Private - Answer whether or not the receiver has a literal representation (probably its
	printString) which is directly recognised by the Compiler"

	^true!

name
	"Answer a <readableString> that is the name of the receiver
	Implementation Note: For compatibility reasons, the answer is actually a Symbol."

	^name ifNil: [super name]!

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
	^#{Package} valueOrNil ifNotNil: [:pkgClass | pkgClass manager packageOfClass: self]!

owningPackage: aPackageOrNil
	"Set the receiver's <Package> to be the argument. Any current package association is lost.
	Note that setting the owning package of a class to the distinguished '_Uncommitted' package
	is exactly the same as setting it to nil."

	#{Package} valueOrNil
		ifNotNil: [:pkgClass | pkgClass manager addClass: self to: aPackageOrNil]!

printDefinitionOn: puttableStream
	"Private - Append the textual definition of the receiver to the <puttableStream>,
	target. Note that this includes the definition of the receiver's metaclass since
	we now define the whole caboodle using a single message."

	| classConstants classVariables |
	puttableStream
		nextPutAll: self superclass name;
		space;
		nextPutAll: self kindOfSubclass;
		space;
		print: self name;
		crtab;
		nextPutAll: 'instanceVariableNames: ';
		print: self instanceVariableString;
		crtab;
		nextPutAll: 'classVariableNames: '''.
	classConstants := OrderedCollection new.
	classVariables := OrderedCollection new.
	self bindings asSortedCollection do: 
			[:each |
			((each isImmutable and: [each value isSelfEvaluating])
				ifTrue: [classConstants]
				ifFalse: [classVariables]) addLast: each].
	classVariables do: [:var | puttableStream nextPutAll: var key] separatedBy: [puttableStream space].
	puttableStream
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
					| value |
					puttableStream
						crtab: 2;
						print: each key;
						nextPutAll: ' -> '.
					value := each value.
					value isInteger
						ifTrue: 
							[value
								printOn: puttableStream
								base: 16
								showRadix: true]
						ifFalse: [value printOn: puttableStream]]
				separatedBy: [puttableStream nextPut: $.].
			puttableStream crtab].
	puttableStream nextPut: $}!

printNameOn: aPuttableStream relativeTo: aNamespace
	| outer |
	self isAnonymous ifTrue: [^super printOn: aPuttableStream].
	outer := self environment.
	outer == aNamespace
		ifFalse: 
			[outer printNameOn: aPuttableStream relativeTo: aNamespace.
			aPuttableStream nextPut: $.].
	aPuttableStream nextPutAll: self simpleName!

removeClassVarName: aString
	"Remove the class variable from the receiver with the specified <readableString> name.
	Note: This is a low-level operation and does not recompile affected classes. Generally 
	speaking any modification to a class should be made through a <ClassBuilder>."

	| varName |
	varName := aString asSymbol.
	self classPool removeKey: varName.
	classPool isEmpty ifTrue: [classPool := nil].
	self logDefinition.
	Smalltalk classUpdated: self!

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

removeSubclass: aClass
	"Private - Remove the argument, aClass, from the subclasses of the receiver.
	WARNING: This method does not completely remove a class from the system."

	subclasses isEmpty ifFalse: [subclasses := subclasses copyWithout: aClass]!

rename: aString
	"Private - Change the name of the receiver to aString.
	N.B. This is the low-level rename operation, and does not rename any references
	to the class."

	| currentName |
	currentName := self name.
	self rename: aString in: self environment.
	self sourceManager logEvaluate: ((String writeStream)
				nextPutAll: currentName;
				space;
				nextPutAll: #rename:;
				space;
				print: aString;
				contents)!

rename: aString in: aNamespace
	"Private - Rename the receiver to aString.
	This will change the receiver's key in the specified Namespace whilst maintaining the binding.
	This means that any existing references will be maintained but method source code will still
	contain the old name and will subsequently fail to compile unless edited.

	We Remove the receiver from the subclass collection of its superclass for the
	duration of the rename just in case the subclass collection is key-sensitive."

	| newName oldName binding |
	self removeFromSuper.
	oldName := name.
	newName := aString asSymbol.
	binding := aNamespace changeKey: oldName to: newName.
	name := newName.
	self addToSuper.
	"Note how the event is delayed until the class is correctly wired in"
	aNamespace triggerVariableRenamed: binding from: oldName!

requiresInstallation
	"Answer whether the receiver requires 'installing' into its environment."

	^name notNil!

resolvePublicBinding: aBindingContext
	"Private - Resolve a binding with public visibility in the receiver's hierarchy, or among its local imports.
	This is used to find bindings for second and subsequent components of qualified names."

	^Error notYetImplemented!

setClassVarNames: anArray
	"Private - Change the set of class variables to be those specified in anArray. Existing
	variables which are still required are left untouched, those no longer required are deleted,
	and new ones may be added (initialised to nil). Answer whether any class variables were
	added (which may shadow existing bindings to spool or global variables) or removed as this
	indicates that a recompilation is required."

	| removed added original classVars |
	classVars := self classPool.
	original := classVars keys.
	removed := original difference: anArray.
	added := anArray difference: original.
	^(added notEmpty or: [removed notEmpty]) and: 
			[removed do: [:each | classVars removeKey: each].
			added do: [:each | classVars at: each put: nil].
			classPool := classVars notEmpty ifTrue: [classVars].
			true]!

setGuid: id
	"Private - Set the value of the receiver's 'guid' instance variable to the 
	<GUID>, id.
	N.B. A classes GUID should not normally be changed after the class has
	been created, but should remain with it throughout its life."

	_guid := id.
!

setName: aSymbol
	"Private - Set the name of the receiver to be aSymbol."

	name := aSymbol!

simpleName
	^self name!

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
	"Create or modify the class, classSymbol, to be a subclass of the receiver with the specified instance variables, class pool, pool dictionaries, class instance variables, and class constants."

	#deprecated.
	^self
		subclass: aClassSymbol
		instanceVariableNames: instVarString
		classVariableNames: classVarString
		imports: (self importsFromPoolsString: poolDictString)
		classInstanceVariableNames: classInstVarString
		classConstants: anArrayOfAssociations!

subclasses
	"Answer a <collection> containing the receiver's immediate subclasses.

	Note that the answer is actually a <sequencedReadableCollection>, but that sequenceability should not be relied upon in portable code because the ANSI standard specifies only <collection>."

	^subclasses!

subclasses: aCollection
	"Set the receivers subclasses to the specified collection. The subclasses are maintained as a sorted array."

	subclasses := aCollection asArray sort!

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

variableByteSubclass: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString poolDictionaries: poolDictString classInstanceVariableNames: classInstVarString classConstants: anArrayOfAssociations
	"Create or modify the class named, classSymbol, to be a variable-byte subclass (has indexable byte-size nonpointer variables) of the receiver with the specified class pool, and pool dictionaries, and class instance variables. Note that variable byte classes cannot have any named instance variables, and therefore the instVarString must be empty."

	#deprecated.
	^self
		variableByteSubclass: aClassSymbol
		instanceVariableNames: instVarString
		classVariableNames: classVarString
		imports: (self importsFromPoolsString: poolDictString)
		classInstanceVariableNames: classInstVarString
		classConstants: anArrayOfAssociations!

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
	^subclass!

variableSubclass: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString poolDictionaries: poolDictString classInstanceVariableNames: classInstVarString classConstants: anArrayOfAssociations
	"Create or modify the class named classSymbol to be a variable subclass (has indexable pointer variables) of the receiver with the specified instance variables, class variables, class constants, pool dictionaries, and class instance variables."

	#deprecated.
	^self
		variableSubclass: aClassSymbol
		instanceVariableNames: instVarString
		classVariableNames: classVarString
		imports: (self importsFromPoolsString: poolDictString)
		classInstanceVariableNames: classInstVarString
		classConstants: anArrayOfAssociations! !
!Class categoriesFor: #absoluteName!accessing!public! !
!Class categoriesFor: #absoluteNameOfIdentifier:!accessing!private! !
!Class categoriesFor: #absoluteReference!accessing!public! !
!Class categoriesFor: #addClassConstant:value:!class variables!development!public! !
!Class categoriesFor: #addClassVariable:value:!class hierarchy-mutating!class variables!public! !
!Class categoriesFor: #addClassVarNamed:!class hierarchy-mutating!class variables!public! !
!Class categoriesFor: #addSubclass:!class hierarchy-adding!private! !
!Class categoriesFor: #addToSuper!class hierarchy-adding!private! !
!Class categoriesFor: #allImports!pool variables!public! !
!Class categoriesFor: #allInstances!instances!public! !
!Class categoriesFor: #allInstVarNames!instance variables!public! !
!Class categoriesFor: #allMethodsDo:!enumerating!public! !
!Class categoriesFor: #allProtocols!protocols!public! !
!Class categoriesFor: #allSelectors!methods-accessing!public! !
!Class categoriesFor: #basicClassPool!class variables!private! !
!Class categoriesFor: #basicClassPool:!class variables!private! !
!Class categoriesFor: #binding!binding!public! !
!Class categoriesFor: #bindingFor:!binding!public! !
!Class categoriesFor: #bindingOrNil!binding!public! !
!Class categoriesFor: #canModifyBinding:newValue:!binding!private! !
!Class categoriesFor: #categories!categories-accessing!public! !
!Class categoriesFor: #categories:!categories-accessing!public! !
!Class categoriesFor: #categoriesForClass!private!source filing-class definition! !
!Class categoriesFor: #category!categories-accessing!public! !
!Class categoriesFor: #category:!categories-accessing!public! !
!Class categoriesFor: #classBinding!binding!public! !
!Class categoriesFor: #classCategories!categories-accessing!private!source filing! !
!Class categoriesFor: #classCategories:!categories-accessing!private! !
!Class categoriesFor: #classConstants!class variables!public! !
!Class categoriesFor: #classPool!accessing!class variables!public! !
!Class categoriesFor: #classVariables!class variables!public! !
!Class categoriesFor: #classVarNames!accessing!class variables!public! !
!Class categoriesFor: #clearGuid!accessing!private! !
!Class categoriesFor: #comment!accessing!development!public! !
!Class categoriesFor: #comment:!accessing!development!public! !
!Class categoriesFor: #environment!accessing!public! !
!Class categoriesFor: #environment:!accessing!public! !
!Class categoriesFor: #fileIn!development!public!source filing! !
!Class categoriesFor: #fileOutName!development!private!source filing! !
!Class categoriesFor: #fileOutStem!development!private!source filing! !
!Class categoriesFor: #fullName!accessing!public! !
!Class categoriesFor: #fullNameOfIdentifier:!accessing!private! !
!Class categoriesFor: #fullyQualifiedReference!accessing!public! !
!Class categoriesFor: #fullyQualifiedReferenceFrom:!binding!public! !
!Class categoriesFor: #guid!constants!public! !
!Class categoriesFor: #guid:!class hierarchy-adding!private! !
!Class categoriesFor: #importedNamespacesDo:!pool variables!public! !
!Class categoriesFor: #imports!pool variables!public! !
!Class categoriesFor: #imports:!pool variables!public! !
!Class categoriesFor: #importsFromPoolsString:!class hierarchy-adding!private! !
!Class categoriesFor: #includeInCategory:!categories-adding!public! !
!Class categoriesFor: #includesNamespace:!public! !
!Class categoriesFor: #initializeAfterLoad!class initialization!public! !
!Class categoriesFor: #instanceClass!accessing!public! !
!Class categoriesFor: #isAbstract:!instance specification-accessing!public! !
!Class categoriesFor: #isAnonymous!public!testing! !
!Class categoriesFor: #isAtomic!public!testing! !
!Class categoriesFor: #isLiteral!public!testing! !
!Class categoriesFor: #name!accessing!public! !
!Class categoriesFor: #newClassBuilder:instanceVariableNames:classVariableNames:imports:!class hierarchy-adding!private! !
!Class categoriesFor: #owningPackage!development!public!source filing! !
!Class categoriesFor: #owningPackage:!accessing!development!public! !
!Class categoriesFor: #printDefinitionOn:!private!source filing-class definition! !
!Class categoriesFor: #printNameOn:relativeTo:!printing!public! !
!Class categoriesFor: #removeClassVarName:!class hierarchy-mutating!class variables!public! !
!Class categoriesFor: #removeFromCategory:!categories-removing!public! !
!Class categoriesFor: #removeFromSuper!class hierarchy-removing!private! !
!Class categoriesFor: #removeFromSystem!class hierarchy-removing!private! !
!Class categoriesFor: #removeSubclass:!class hierarchy-removing!private! !
!Class categoriesFor: #rename:!class hierarchy-mutating!private! !
!Class categoriesFor: #rename:in:!class hierarchy-mutating!private! !
!Class categoriesFor: #requiresInstallation!public!testing! !
!Class categoriesFor: #resolvePublicBinding:!binding!private! !
!Class categoriesFor: #setClassVarNames:!class variables!private! !
!Class categoriesFor: #setGuid:!accessing!private! !
!Class categoriesFor: #setName:!accessing!private! !
!Class categoriesFor: #simpleName!accessing!public! !
!Class categoriesFor: #sourceDescriptor!accessing!public!source filing! !
!Class categoriesFor: #sourceDescriptor:!accessing!private!source filing! !
!Class categoriesFor: #stbConvertFrom:!binary filing!private! !
!Class categoriesFor: #stbModifyExportProxy:!binary filing!private! !
!Class categoriesFor: #stbSaveOn:!binary filing!public! !
!Class categoriesFor: #stbVersion!binary filing!public! !
!Class categoriesFor: #storeGUID!private!source filing-class definition! !
!Class categoriesFor: #subclass:instanceVariableNames:classVariableNames:imports:!class hierarchy-adding!public! !
!Class categoriesFor: #subclass:instanceVariableNames:classVariableNames:imports:classInstanceVariableNames:classConstants:!class hierarchy-adding!public! !
!Class categoriesFor: #subclass:instanceVariableNames:classVariableNames:poolDictionaries:classInstanceVariableNames:classConstants:!class hierarchy-adding!public! !
!Class categoriesFor: #subclasses!class hierarchy-accessing!public! !
!Class categoriesFor: #subclasses:!class hierarchy-mutating!public! !
!Class categoriesFor: #subclassesDo:!class hierarchy-accessing!public! !
!Class categoriesFor: #uninitialize!class hierarchy-removing!development!private! !
!Class categoriesFor: #uninitializeBeforeRemove!class hierarchy-removing!public! !
!Class categoriesFor: #variableByteSubclass:instanceVariableNames:classVariableNames:imports:!class hierarchy-adding!public! !
!Class categoriesFor: #variableByteSubclass:instanceVariableNames:classVariableNames:imports:classInstanceVariableNames:classConstants:!class hierarchy-adding!public! !
!Class categoriesFor: #variableByteSubclass:instanceVariableNames:classVariableNames:poolDictionaries:classInstanceVariableNames:classConstants:!class hierarchy-adding!public! !
!Class categoriesFor: #variableSubclass:instanceVariableNames:classVariableNames:imports:!class hierarchy-adding!public! !
!Class categoriesFor: #variableSubclass:instanceVariableNames:classVariableNames:imports:classInstanceVariableNames:classConstants:!class hierarchy-adding!public! !
!Class categoriesFor: #variableSubclass:instanceVariableNames:classVariableNames:poolDictionaries:classInstanceVariableNames:classConstants:!class hierarchy-adding!public! !

!Class class methodsFor!

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
					binding := each classBinding.
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
!Class class categoriesFor: #allBehaviors!class hierarchy-accessing!private! !
!Class class categoriesFor: #allBehaviorsDo:!enumerating!private! !
!Class class categoriesFor: #allClasses!class hierarchy-accessing!private! !
!Class class categoriesFor: #allClassesDo:!enumerating!private! !
!Class class categoriesFor: #allMethodsDo:!enumerating!private! !
!Class class categoriesFor: #allRoots!class hierarchy-accessing!private! !
!Class class categoriesFor: #basicAllRoots!class hierarchy-accessing!private! !
!Class class categoriesFor: #foldLiteralStrings!operations!public! !

