"Filed out from Dolphin Smalltalk 7"!

ClassDescription subclass: #Class
	instanceVariableNames: 'name classPool sharedPools comment classCategories _guid'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Class guid: (GUID fromString: '{87b4c4fb-026e-11d3-9fd7-00a0cc3e4a32}')!
Class comment: '"Instances" of Class describe the representation and behavior of objects. Class adds more comprehensive programming support facilities to the basic ones provided in the abstract superclass Behavior and more descriptive facilities to the ones provided in the abstract superclass ClassDescription. In particular Class adds the representation for class variable names and shared (pool) variables.

In reality, Class has no instances. All classes in the system are actually instances of a parallel hierarchy of Metaclass instances, but they do have the same shape as Class and are logically, if not physically, instances of it.

Instance Variables:

	name		<Symbol> which is the name of the class
	classPool		<PoolDictionary> mapping class variable name <String>s to values
	sharedPools	<Array> of <Symbol> names of shared variable pools
	comment		<String> comment about the class (like this one), or nil if none.
	classCategories	<Array> of <ClassCategory>. The categories of the class, if any.
	_guid		<GUID>. Unique identifier for the class.
	'!
!Class categoriesForClass!Kernel-Classes! !
!Class methodsFor!

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
							oldValue ~~ anObject and: 
									[(VMLibrary hasBytecodeRepresentation: oldValue) or: [VMLibrary hasBytecodeRepresentation: anObject]]]].
	binding isImmutable: false.
	[binding value: anObject] ensure: [binding isImmutable: true].
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
		ifNotNil: [:existingClass | ^self error: ('<1p> is already used as a variable name in class <2p>' expandMacrosWithArguments: {aString. existingClass})].
	var := classPool newAssociation: varName value: nil.
	classPool add: var.
	self logDefinition.
	self environment classUpdated: self.
	^var!

addToSuper
	"Private - Add the receiver as a subclass of its superclass
	and do the same for the receiver's metaclass buddy, but not
	if a root class."

	superclass notNil ifTrue: [
		super addToSuper.
		self class addToSuper]!

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

basicSharedPools: aCollection
	"Private - Set the receiver's shared pools collection."

	sharedPools := aCollection!

binding
	"Answer the receiver's variable binding, raising an error if the receiver is unbound."

	^self fullyQualifiedReference binding!

bindingFor: aString 
	"Answer a variable binding for the named variable in the scope of this class. 
	If there is no such variable, then answer nil.
	Note that in Dolphin pools are inherited."

	classPool isNil ifFalse: [(classPool bindingFor: aString) ifNotNil: [:classVar | ^classVar]].
	self sharedPoolsDo: [:each | (each bindingFor: aString) ifNotNil: [:sharedVar | ^sharedVar]].
	^superclass bindingFor: aString!

bindingOrNil
	"Answer the receiver's variable binding, or nil if unbound"

	^self fullyQualifiedReference bindingOrNil!

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
	self class environment trigger: #classCategorized: with: self!

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
	^self environment associationAt: self name ifAbsent: []!

classCategories
	"Private - Answer a <collection> of <ClassCategory> objects representing the 
	class categories of which the receiver is a member, or nil if unclassified."

	^classCategories!

classCategories: categoryCollection 
	"Private - Set the class categories of the receiver to categoryCollection."

	classCategories := categoryCollection notEmpty 
				ifTrue: [categoryCollection asArray sort]!

classPool
	"Answer the Dictionary of class variables belonging to the receiver.
	N.B. This should not be modified as it may not be the actual class pool
	(though it is guaranteed to have identical contents)."

	^classPool ifNil: [PoolDictionary new]!

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
	self environment trigger: #classCommented: with: self!

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

fullyQualifiedReference
	"Answer a <BindingReference> that represents a fully qualified reference to the receiver."

	^BindingReference pathString: self fullName!

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

includeInCategory: category
	"Add the receiver to the ClassCategory with specified name, while leaving it in its existing
	set of categories."

	self categories: (self categories asSet add: (self classCategoryClass name: category asString); yourself)!

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

newClassBuilder: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString poolDictionaries: poolDictString
	^(ClassBuilder new)
		superclass: self;
		className: aClassSymbol;
		instanceVariableString: instVarString;
		classVariableString: classVarString;
		sharedPoolString: poolDictString;
		yourself!

owningPackage
	"Answers the package that owns the receiver or nil if it is not yet owned by any package."

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
		nextPutAll: 'classVariableNames: ';
		print: self classVariableString;
		crtab;
		nextPutAll: 'poolDictionaries: ';
		print: self sharedVariableString;
		crtab;
		nextPutAll: 'classInstanceVariableNames: ';
		print: self class instanceVariableString!

removeClassVarName: aString
	"Remove the class variable from the receiver with the specified <readableString> name.
	Note: This is a low-level operation and does not recompile affected classes. Generally 
	speaking any modification to a class should be made through a <ClassBuilder>."

	| varName |
	varName := aString asSymbol.
	self classPool removeKey: varName.
	classPool isEmpty ifTrue: [classPool := nil].
	self logDefinition.
	self environment classUpdated: self!

removeFromCategory: category
	"Remove the receiver from the aCategoryOrString, while leaving it in any other
	class categories."

	| classCat |
	classCat := self classCategoryClass name: category asString.
	self categories: (self categories asSet remove: classCat; yourself)!

removeFromSuper
	"Private - Remove the receiver as a subclass of its superclass
	and do the same for the receiver's metaclass buddy."

	super removeFromSuper.
	self class removeFromSuper!

removeFromSystem
	"Private - Remove the receiver from the system. This method will fail if the class has instances
	or subclasses so these must be removed first where ever  possible, which should be done in
	an #uninitialize method. #unitialize is sent immediately before the class is removed, but (like
	#initialize) only if directly implemented by the class - i.e. it will not be sent if the implementation
	is inherited. N.B. Do not supersend #uninitialize from an override, as you may damage a
	superclass which is not being removed."

	self subclasses do: [:each | each removeFromSystem].
	self sourceManager logEvaluate: self name, ' removeFromSystem'.
	ClassBuilder removeClass: self!

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

setSharedPoolNames: aCollection
	"Private - Set the shared variable pool to include the names in aCollection, ignoring any duplicates."

	sharedPools := aCollection notEmpty
				ifTrue: [aCollection distinct asArray collect: [:poolName | poolName asSymbol]]!

sharedPoolNames
	"Answer a <sequencedReadableCollection> of <Symbol>s, being the names of the shared pool
	dictionaries that are specified locally in the receiver (pools are inherited in Dolphin), in
	order of precedence."

	^sharedPools ?? #()!

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

subclass: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString poolDictionaries: poolDictString
	^(self 
		newClassBuilder: aClassSymbol
		instanceVariableNames: instVarString
		classVariableNames: classVarString
		poolDictionaries: poolDictString) modifyOrCreate!

subclass: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString poolDictionaries: poolDictString category: aCategoryOrString
	"If aClassSymbol is not an existing class then create and answer a new fixed pointer subclass,
	otherwise modify the class with name aClassSymbol to have the indicated features and answer it.
	Primarily present for backwards compatibility with Smalltalk-80."

	^(self
		newClassBuilder: aClassSymbol
		instanceVariableNames: instVarString
		classVariableNames: classVarString
		poolDictionaries: poolDictString)
		categoryNames: {aCategoryOrString};
		modifyOrCreate!

subclass: aClassSymbol
		instanceVariableNames: instVarString
		classVariableNames: classVarString
		poolDictionaries: poolDictString
		classInstanceVariableNames: classInstVarString
	"Create or modify the class, classSymbol, to be a subclass of the receiver
	with the specified instance variables, class pool, and pool dictionaries,
	and class instance variables."

	| subclass |
	subclass := self 
				subclass: aClassSymbol
				instanceVariableNames: instVarString
				classVariableNames: classVarString
				poolDictionaries: poolDictString.
	subclass class instanceVariableNames: classInstVarString.
	^subclass!

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

variableByteSubclass: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString poolDictionaries: poolDictString
	^(self 
		newClassBuilder: aClassSymbol
		instanceVariableNames: instVarString
		classVariableNames: classVarString
		poolDictionaries: poolDictString)
		beBytes;
		modifyOrCreate!

variableByteSubclass: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString poolDictionaries: poolDictString category: aCategoryOrString
	"If aClassSymbol is not an existing class then create an answer a new variable byte subclass,
	otherwise modify the class with name aClassSymbol to have the indicated features and answer 
	it. Primarily present for backwards compatibility with Smalltalk-80."

	^(self
		newClassBuilder: aClassSymbol
		instanceVariableNames: instVarString
		classVariableNames: classVarString
		poolDictionaries: poolDictString)
		beBytes;
		categoryNames: {aCategoryOrString};
		modifyOrCreate!

variableByteSubclass: aClassSymbol
		instanceVariableNames: instVarString
		classVariableNames: classVarString
		poolDictionaries: poolDictString
		classInstanceVariableNames: classInstVarString
	"Create or modify the class, classSymbol, to be a variable-byte subclass 
	(has indexable byte-size nonpointer variables) of the receiver
	with the specified class pool, and pool dictionaries, and class instance
	variables. Note that variable byte classes cannot have any named
	instance variables, and therefore the instVarString must be empty."

	| subclass |
	subclass := self 
				variableByteSubclass: aClassSymbol
				instanceVariableNames: instVarString
				classVariableNames: classVarString
				poolDictionaries: poolDictString.
	subclass class instanceVariableNames: classInstVarString.
	^subclass
!

variableSubclass: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString poolDictionaries: poolDictString
	^(self 
		newClassBuilder: aClassSymbol
		instanceVariableNames: instVarString
		classVariableNames: classVarString
		poolDictionaries: poolDictString)
		beVariable;
		modifyOrCreate!

variableSubclass: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString poolDictionaries: poolDictString category: aCategoryOrString
	"If aClassSymbol is not an existing class then create and answer a new variable pointer 
	subclass, otherwise modify the class with name aClassSymbol to have the indicated features and 
	answer it. Primarily intended for backwards compatibility with Smalltalk-80."

	^(self
		newClassBuilder: aClassSymbol
		instanceVariableNames: instVarString
		classVariableNames: classVarString
		poolDictionaries: poolDictString)
		beVariable;
		categoryNames: {aCategoryOrString};
		modifyOrCreate!

variableSubclass: aClassSymbol
		instanceVariableNames: instVarString
		classVariableNames: classVarString
		poolDictionaries: poolDictString
		classInstanceVariableNames: classInstVarString
	"Create or modify the class classSymbol to be a variable subclass (has
	indexable pointer variables) of the receiver with the specified
	instance variables, class pool, pool dictionaries, and class instance
	variables."

	| subclass |
	subclass := self 
				variableSubclass: aClassSymbol
				instanceVariableNames: instVarString
				classVariableNames: classVarString
				poolDictionaries: poolDictString.
	subclass class instanceVariableNames: classInstVarString.
	^subclass

! !
!Class categoriesFor: #addClassConstant:value:!class variables!development!public! !
!Class categoriesFor: #addClassVariable:value:!class hierarchy-mutating!class variables!public! !
!Class categoriesFor: #addClassVarNamed:!class hierarchy-mutating!class variables!public! !
!Class categoriesFor: #addToSuper!class hierarchy-adding!private! !
!Class categoriesFor: #basicClassPool!class variables!private! !
!Class categoriesFor: #basicClassPool:!class variables!private! !
!Class categoriesFor: #basicSharedPools:!accessing!private! !
!Class categoriesFor: #binding!public! !
!Class categoriesFor: #bindingFor:!binding!public! !
!Class categoriesFor: #bindingOrNil!public! !
!Class categoriesFor: #categories!categories-accessing!public! !
!Class categoriesFor: #categories:!categories-accessing!public! !
!Class categoriesFor: #categoriesForClass!private!source filing-class definition! !
!Class categoriesFor: #category!categories-accessing!public! !
!Class categoriesFor: #category:!categories-accessing!public! !
!Class categoriesFor: #classBinding!binding!public! !
!Class categoriesFor: #classCategories!categories-accessing!private!source filing! !
!Class categoriesFor: #classCategories:!categories-accessing!private! !
!Class categoriesFor: #classPool!accessing!class variables!public! !
!Class categoriesFor: #classVarNames!accessing!class variables!public! !
!Class categoriesFor: #clearGuid!accessing!private! !
!Class categoriesFor: #comment!accessing!development!public! !
!Class categoriesFor: #comment:!accessing!development!public! !
!Class categoriesFor: #fileIn!development!public!source filing! !
!Class categoriesFor: #fileOutName!development!private!source filing! !
!Class categoriesFor: #fileOutStem!development!private!source filing! !
!Class categoriesFor: #fullyQualifiedReference!accessing!public! !
!Class categoriesFor: #guid!constants!public! !
!Class categoriesFor: #guid:!class hierarchy-adding!private! !
!Class categoriesFor: #includeInCategory:!categories-adding!public! !
!Class categoriesFor: #initializeAfterLoad!class initialization!public! !
!Class categoriesFor: #instanceClass!accessing!public! !
!Class categoriesFor: #isAbstract:!instance specification-accessing!public! !
!Class categoriesFor: #isAtomic!public!testing! !
!Class categoriesFor: #isLiteral!public!testing! !
!Class categoriesFor: #name!accessing!public! !
!Class categoriesFor: #newClassBuilder:instanceVariableNames:classVariableNames:poolDictionaries:!class hierarchy-adding!private! !
!Class categoriesFor: #owningPackage!development!public!source filing! !
!Class categoriesFor: #owningPackage:!accessing!development!public! !
!Class categoriesFor: #printDefinitionOn:!private!source filing-class definition! !
!Class categoriesFor: #removeClassVarName:!class hierarchy-mutating!class variables!public! !
!Class categoriesFor: #removeFromCategory:!categories-removing!public! !
!Class categoriesFor: #removeFromSuper!class hierarchy-removing!private! !
!Class categoriesFor: #removeFromSystem!class hierarchy-removing!private! !
!Class categoriesFor: #rename:!class hierarchy-mutating!private! !
!Class categoriesFor: #rename:in:!class hierarchy-mutating!private! !
!Class categoriesFor: #requiresInstallation!public!testing! !
!Class categoriesFor: #setClassVarNames:!class variables!private! !
!Class categoriesFor: #setGuid:!accessing!private! !
!Class categoriesFor: #setName:!accessing!private! !
!Class categoriesFor: #setSharedPoolNames:!pool variables!private! !
!Class categoriesFor: #sharedPoolNames!pool variables!public! !
!Class categoriesFor: #sourceDescriptor!accessing!public!source filing! !
!Class categoriesFor: #sourceDescriptor:!accessing!private!source filing! !
!Class categoriesFor: #stbConvertFrom:!binary filing!private! !
!Class categoriesFor: #stbModifyExportProxy:!binary filing!private! !
!Class categoriesFor: #stbSaveOn:!binary filing!public! !
!Class categoriesFor: #stbVersion!binary filing!public! !
!Class categoriesFor: #storeGUID!private!source filing-class definition! !
!Class categoriesFor: #subclass:instanceVariableNames:classVariableNames:poolDictionaries:!class hierarchy-adding!public! !
!Class categoriesFor: #subclass:instanceVariableNames:classVariableNames:poolDictionaries:category:!class hierarchy-adding!public! !
!Class categoriesFor: #subclass:instanceVariableNames:classVariableNames:poolDictionaries:classInstanceVariableNames:!class hierarchy-adding!public! !
!Class categoriesFor: #uninitialize!class hierarchy-removing!development!private! !
!Class categoriesFor: #uninitializeBeforeRemove!class hierarchy-removing!public! !
!Class categoriesFor: #variableByteSubclass:instanceVariableNames:classVariableNames:poolDictionaries:!class hierarchy-adding!public! !
!Class categoriesFor: #variableByteSubclass:instanceVariableNames:classVariableNames:poolDictionaries:category:!class hierarchy-adding!public! !
!Class categoriesFor: #variableByteSubclass:instanceVariableNames:classVariableNames:poolDictionaries:classInstanceVariableNames:!class hierarchy-adding!public! !
!Class categoriesFor: #variableSubclass:instanceVariableNames:classVariableNames:poolDictionaries:!class hierarchy-adding!public! !
!Class categoriesFor: #variableSubclass:instanceVariableNames:classVariableNames:poolDictionaries:category:!class hierarchy-adding!public! !
!Class categoriesFor: #variableSubclass:instanceVariableNames:classVariableNames:poolDictionaries:classInstanceVariableNames:!class hierarchy-adding!public! !

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
	roots := self basicAllRoots select: [:each | (self environment lookup: each name) == each].
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

