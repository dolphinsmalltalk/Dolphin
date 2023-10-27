"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RBAbstractClass
	subclass: #'Refactory.Browser.RBClass'
	instanceVariableNames: 'model name metaclass realClass superclass subclasses unqualifiedName classPool imports categoryNames comment environment binding instanceSpec'
	classVariableNames: 'LookupComment'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBClass guid: (Core.GUID fromString: '{e6a15c71-6c8c-437d-856c-42cd447df930}')!
Refactory.Browser.RBClass comment: 'RBClass represents a Class.

Instance Variables:
	category	<Symbol>	name of the category that the class should be compiled in
	classVariableNames	<SequenceableCollection of: Symbol>	class variables defined by the class
	poolDictionaryNames	<Collection of: Symbol>	pool variables included by the class'!
!Refactory.Browser.RBClass categoriesForClass!Refactory-Model! !
!Refactory.Browser.RBClass methodsFor!

<= aRBClass
	"Answer whether the receiver should sort before the argument, e.g. in a SortedCollection using the default sort block. We use a case sensitive comparison for stability. The class name is the primary sort order, but for equal names the namespace is then used.
	This provides a stable order that is reasonable for working with unqualified names, and which is therefore useful for backwards compatibility, but it doesn't necessarily make sense for fully qualified names. Generally it is preferable to specify one's own sort order comparison rather than relying on the default."

	| cmp |
	cmp := self unqualifiedName <==> aRBClass unqualifiedName.
	^cmp == 0 ifTrue: [self fullName <= aRBClass fullName] ifFalse: [cmp < 0]!

addBinding: aRBVariableBinding
	self assert: [aRBVariableBinding model == self model].
	aRBVariableBinding environment: self.
	self classPool add: aRBVariableBinding!

addClassConstant: aRBVariableBinding
	self addBinding: aRBVariableBinding.
	model addClassConstant: aRBVariableBinding to: self!

addClassVariable: aString
	self classPool add: (RBVariableBinding name: aString environment: self).
	model addClassVariable: aString to: self!

addImport: aString
	self changeImports: (self imports
				copyWith: (aString asQualifiedReference asNamespaceImport referenceInModel: model))!

addSubclass: aRBClass
	subclasses := self subclasses copyWith: aRBClass!

allBehaviorsDo: operation
	self allClassesDo: 
			[:class |
			operation value: class.
			operation value: class metaclass]!

allClassBindingNames
	^self superclass
		ifNil: [self classBindingNames]
		ifNotNil: [:sprClass | sprClass allClassBindingNames , self classBindingNames]!

allClassesDo: aMonadicValuable
	self bindingsDo: 
			[:each |
			each isClassBinding
				ifTrue: 
					[| class |
					aMonadicValuable value: (class := each value).
					class allClassesDo: aMonadicValuable]]!

allClassVariableNames
	^self superclass
		ifNil: [self classVariableNames]
		ifNotNil: [:sprClass | sprClass allClassVariableNames , self classVariableNames]!

baseEnvironment
	"Private - Answer the default environment for new subclasses of the receiver that the ClassBuilder should use when the provided subclass name is unqualified."

	^model smalltalkNamespace!

basicEnvironment
	"Answer the receiver's namespace (i.e. an instance of RBNamespaceClass). This is the RBClass' environment as the term is used the Behavior/ClassDescription/Class/Metaclass hierarchy, and not a BrowserEnvironment, which is another type of scope that defines the universe of the RBModel (Refactoring model) class."

	^environment ifNil: [environment := self getEnvironment]!

bindingOrNil
	"Answer the binding for the receiver in the model."

	^binding
		ifNil: 
			[binding := self globalScope fullBindingFor: self name.
			binding]!

buildClassPool
	"Private - Create a shadow copy of the real class' classPool with model static variables and classes in place of the real static variables and classes."

	"Implementation Note: To reduce the hashing overhead we make a shallow copy of the class pool and then update it in place. This works because the variable name hashes will remain the same. Such low-level hackery is excusable only because building out the namespace hierarchy is one of the most expensive operations when running refactorings. The alternative would be to store only the model differences in the model classes (deletions and additions), but generating a complete shadow copy on demand is simpler and seems to provide acceptable performance."

	| pool |
	pool := realClass classPool shallowCopy.
	1 to: pool basicSize
		do: 
			[:i |
			(pool basicAt: i)
				ifNotNil: 
					[:each |
					| var |
					var := pool basicAt: i put: (RBVariableBinding new realBinding: each environment: self).
					each isClassBinding ifTrue: [var setValue: (each value newClassInModel: model)]]].
	^pool!

categoryNames
	^categoryNames
		ifNil: [(model environment whichCategoriesInclude: self name) collect: [:each | each asString]]
		ifNotNil: [categoryNames]!

categoryNames: aCollectionOfStrings
	categoryNames := aCollectionOfStrings!

changeImports: anArray
	imports := anArray.
	model import: anArray into: self!

classCategories
	^categoryNames
		ifNil: [model environment whichCategoriesInclude: self name]
		ifNotNil: [categoryNames collect: [:each | ClassCategory name: each]]!

classConstants: aCollectionOfAssociations
	| pool |
	pool := self classPool.
	aCollectionOfAssociations do: 
			[:each |
			pool add: ((RBVariableBinding name: each key environment: self)
						value: each value;
						isImmutable: true;
						yourself)]!

classInstanceVariableNames
	^self metaclass instanceVariableNames!

classPool
	^classPool ifNil: [classPool := self buildClassPool]!

classVariableNames: aCollectionOfStrings
	classPool := Dictionary new: aCollectionOfStrings size.
	aCollectionOfStrings do: [:each | classPool add: (RBVariableBinding name: each environment: self)]!

comment
	^comment == LookupComment
		ifTrue: [comment := realClass ifNotNil: [realClass comment]]
		ifFalse: [comment]!

comment: aString
	model comment: (comment := aString) in: self!

defaultInstanceSpec
	^Behavior._PointersMask!

definition
	| definitionStream |
	definitionStream := (String writeStream: 256)
				locale: SmalltalkLocale.Hex;
				yourself.
	self printDefinitionOn: definitionStream.
	^definitionStream contents!

details
	^ClassDetails fromClass: self!

fullName: aString
	name = aString ifTrue: [^self].
	name := aString.
	"Any change to the fullName means that this class becomes 'new' in the model, and can't be looked up by its real class' name any more"
	self subclasses do: [:each | each setSuperclass: self]!

fullNameFor: aString 
	| stream |
	stream := String writeStream: 32.
	stream
		nextPutAll: name;
		nextPut: $.;
		nextPutAll: aString.
	^stream contents!

fullyQualifiedReference
	^(BindingReference fullPathString: name) referenceInModel: model!

getEnvironment
	^(realClass notNil and: [realClass fullName = name])
		ifTrue: [realClass basicEnvironment classInModel: model]
		ifFalse: 
			[| ref |
			ref := self fullyQualifiedReference.
			ref isQualifiedName ifTrue: [ref environment] ifFalse: [self baseEnvironment]]!

getInstanceSpec
	^self nearestRealClass ifNil: [self defaultInstanceSpec] ifNotNil: [:class | class instanceSpec]!

guid
	^self realClass ifNotNil: [realClass guid]!

importedNamespacesDo: aMonadicValuable
	self imports do: [:each | each valueOrNil ifNotNil: [:ns | aMonadicValuable value: ns]]!

imports
	imports
		ifNil: 
			[imports := realClass
						ifNotNil: [realClass imports collect: [:each | each referenceInModel: model]]
						ifNil: [#()]].
	^imports!

imports: aCollection
	imports := (aCollection
				collect: [:each | each asQualifiedReference asFullyQualifiedReference referenceInModel: model])
					asArray!

includesEnvironment: aClass
	"Answer whether the receiver includes the namespace argument (i.e. is it nested within it somewhere in its environment chain)."

	^self == aClass or: [self environment includesEnvironment: aClass]
!

includesNamespace: aRBClass
	"Answer whether the receiver includes the namespace argument (i.e. is it a sub-namespace, or is it nested within it somewhere in its environment chain)."

	^self == aRBClass
		or: [(self inheritsFrom: aRBClass) or: [self environment includesEnvironment: aRBClass]]!

instanceClass
	^self!

instanceSpec
	^instanceSpec
		ifNil: 
			[self nearestRealClass ifNil: [self defaultInstanceSpec] ifNotNil: [:class | class instanceSpec]]!

instanceSpec: anInteger 
	instanceSpec := anInteger!

isDefined
	^realClass notNil!

isInBaseEnvironment
	^(BindingReference isQualifiedName: self fullName) not!

isMeta
	^false!

isNonInstantiable
	^self instanceSpec anyMask: Behavior._NonInstantiableMask!

isNonInstantiable: aBoolean
	"Set whether the class described by the receiver should not be instantiated, e.g. it is abstract."

	instanceSpec := self instanceSpec mask: Behavior._NonInstantiableMask set: aBoolean!

isNullTerminated
	"Answer true if the instances of the receiver are Null Terminated (that is they include 
	an extra byte with the value zero at their end, which is not included in the reported size). 
	Only meaningful for variable byte classes (e.g. String)."

	^self instanceSpec allMask: Behavior._NullTermMask!

isPointers
	"Answer whether the variables of instances of the receiver contain object pointers (as
	opposed to uninterpreted bytes)."

	^self instanceSpec anyMask: Behavior._PointersMask!

isVariable
	^self instanceSpec anyMask: Behavior._VariableMask!

kindOfSubclass
	"Private - Answer a string describing the kind of subclassing method used to create the receiver 
	(part of its definition)."

	^self isVariable
		ifTrue: [self isPointers ifTrue: ['variableSubclass:'] ifFalse: ['variableByteSubclass:']]
		ifFalse: ['subclass:']!

localScope
	^self!

metaclass
	^metaclass!

metaSubclasses
	^realClass == Class ifTrue: [#()] ifFalse: [self subclasses collect: [:each | each metaclass]]!

model
	^model!

model: aRBModel
	model := aRBModel!

model: aRBModel existing: aClass
	model := aRBModel.
	name := (realClass := aClass) fullName.
	unqualifiedName := aClass unqualifiedName.
	(metaclass := RBMetaclass basicNew) instanceClass: self.
	superclass := LookupSuperclass.
	comment := LookupComment.
	instanceSpec := aClass instanceSpec.
	^self!

model: aRBModel named: aSymbol
	model := aRBModel.
	name := aSymbol.
	(metaclass := RBMetaclass basicNew) instanceClass: self.
	comment := LookupComment.
	^self!

modelSuperclass
	"Answer the model superclass of the receiver, whether or not it is defined in the model's environment."

	^superclass == LookupSuperclass
		ifTrue: [self realClass superclass ifNotNil: [:sprClass | sprClass classInModel: model]]
		ifFalse: [superclass]!

name
	"Answer the name of the non-metaclass. Note that in Dolphin 8 this is always a fully-qualified name."

	^name!

name: aString
	self fullName: aString.
	unqualifiedName := environment := scope := nil!

nearestRealClass
	#rbFix.	"Added"
	^realClass ifNil: [superclass ifNotNil: [superclass nearestRealClass]]!

newBindingContextForIdentifier: aString environment: aRBClass
	^BindingContext
		methodClass: self
		environment: aRBClass
		identifier: aString!

printDefinitionOn: aPuttableStream
	(Object sourceFilerClass on: aPuttableStream) printBasicDefinitionOfClass: self!

printFullNameOn: aWriteStream
	aWriteStream nextPutAll: self fullName!

realClass
	^realClass!

realClass: aClass 
	realClass := aClass.
	superclass isNil ifTrue: [superclass := LookupSuperclass]!

removeBindingFor: aString
	^self classPool removeAssociationAt: aString!

removeClassConstant: anAssociation
	| var |
	var := self removeBindingFor: anAssociation key.
	model removeClassConstant: var from: self!

removeClassVariable: aString
	| var |
	var := self localBindingFor: aString.
	var isNil ifTrue: [^self errorNotFound: aString].
	var isClassBinding
		ifTrue: [^self error: 'Cannot remove class binding <1s> from <2p>' << {aString. self}].
	self removeBindingFor: aString.
	model removeClassVariable: var.
	^var!

removeImport: aString
	self
		changeImports: (self imports copyWithout: (aString asQualifiedReference referenceInModel: model))!

removeSubclass: aRBClass
	subclasses := self subclasses copyWithout: aRBClass!

renameClassVariable: oldName to: newName around: aBlock
	self classPool changeKey: oldName to: newName.
	model
		renameClassVariable: oldName
		to: newName
		in: self
		around: aBlock!

replaceImport: oldBindingReference with: newBindingReference
	"Replace an existing import with a new one, maintaining the existing order. This is typically used when renaming classes/namespaces that might be imported elsewhere."

	self changeImports: (self imports copyReplacing: oldBindingReference
				withObject: (newBindingReference referenceInModel: model) asNamespaceImport)!

resolveBindingPath: anArray
	"Private - Attempt to resolve a <VariableBinding> by walking the names in the argument through nested namespaces."

	^self resolveBindingPath: anArray environment: self environment!

resolveBindingPath: anArray environment: aNamespace
	"Private - Attempt to resolve a <VariableBinding> by walking the names in the <Array> first argument through nested namespaces."

	| length var |
	length := anArray size.
	length == 0 ifTrue: [^self binding].
	var := self resolveUnqualifiedName: (anArray at: 1) environment: aNamespace.
	2 to: length
		do: 
			[:i |
			"We don't want to attempt to drill into normal class variables"
			(var isNil or: [var isClassVariable]) ifTrue: [^nil].
			var := var value
						resolvePublicBinding: (self newBindingContextForIdentifier: (anArray at: i) environment: aNamespace).
			var ifNil: [^nil]].
	^var!

resolveImportedBinding: aBindingContext
	"Private - Search imported namespaces for a binding that matches the identifier in the <BindingContext> supplied. The search proceeds up through the class hierarchy (i.e. imports in the class hierarchy are inherited), and then out to the imports of the enclosing namespace. Imports into the enclosing namespaces of superclasses are not searched."

	"Identical to Class>>resolveImportedBinding:"

	| current |
	current := self.
	
	[(current resolveLocallyImportedBinding: aBindingContext) ifNotNil: [:var | ^var].
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

	| length var |
	length := anArray size.
	length == 0 ifTrue: [^self binding].
	var := self localBindingFor: (anArray at: 1).
	2 to: length
		do: 
			[:i |
			"We don't want to attempt to drill into normal class variables"
			(var isNil or: [var isClassVariable]) ifTrue: [^nil].
			var := var value localBindingFor: (anArray at: i).
			var ifNil: [^nil]].
	^var!

resolveLocallyImportedBinding: aBindingContext
	"Private - Search the directly imported namespaces for a binding that matches the identifier in the <BindingContext> argument."

	1 to: self imports size
		do: 
			[:i |
			(aBindingContext visitImport: (imports at: i) from: self)
				ifNotNil: [:namespace | (namespace resolvePublicBinding: aBindingContext) ifNotNil: [:var | ^var]]].
	^nil!

resolvePathString: aString environment: aRBNamespaceClass
	(BindingReference isQualifiedName: aString)
		ifFalse: [^self resolveUnqualifiedName: aString environment: aRBNamespaceClass].
	^self resolveBindingPath: (BindingReference.PathSeparator split: aString)
		environment: aRBNamespaceClass!

resolvePublicBinding: aBindingContext
	"Private - Resolve a binding with public visibility in the receiver's hierarchy, or among its local imports.
	This is used to find bindings for second and subsequent components of qualified names."

	(self hierarchyBindingFor: aBindingContext identifier)
		ifNotNil: 
			[:var |
			(var isPrivate not or: [aBindingContext includesNamespace: var environment]) ifTrue: [^var]].
	"Search only the local imports, not the imports of the imports."
	^self resolveLocallyImportedBinding: aBindingContext!

resolveUnqualifiedName: aString environment: aRBNamespaceClass
	"Private - Attempt to find a binding for the specified unqualified name in the scope of the receiver. Variables defined in the class hierarchy should bind more tightly than those in the namespace (environment) hierarchy. Only after exhausting these hierarchies should the imports be searched, again with the same rule that imports into the class hierarchy bind more tightly than those into the environment hierarchy. In other words the binding resolution rules are:
		1. Variables defined in the class hierarchy, search first the local class variables, then those of the superclass, and so on up to a root class.
		2. Variables defined in the enclosing namespace hierarchy (i.e. the class' environment, the environment of the environment, and so on up to the Root namespace).
		3. The hierarchy and superclass variables of imported namespaces (shared pools in old money), then of the imports into the enclosing environment, and so on.
	The search for a variables defined in the class hierarchy cannot encounter cycles. Once the imported namespaces are brought into the mix, however, we can end up revisiting the same namespace more than once because the imports form a directed graph that may have cycles, not necessarily a tree. Obviously there is no point searching any reachable namespace more than once, and we also need the search to terminate, both of which conditions are achieved by maintaining a visited set in a BindingContext object.
	Namespace imports can be public or private. Private imports are only visited for searches initiated in the importee. Variables can also be private, in which case they can only be resolved locally."

	^((self hierarchyBindingFor: aString)
		ifNil: [aRBNamespaceClass ifNotNil: [aRBNamespaceClass bindingFor: aString]])
			ifNil: 
				[self
					resolveImportedBinding: (self newBindingContextForIdentifier: aString environment: aRBNamespaceClass)]!

setModel: aRBModel name: anObject realClass: aClassDescription
	model := aRBModel.
	name := anObject.
	(metaclass := RBMetaclass basicNew) instanceClass: self.
	comment := LookupComment.
	aClassDescription
		ifNotNil: 
			[realClass := aClassDescription.
			unqualifiedName := aClassDescription unqualifiedName.
			superclass := LookupSuperclass]!

setSuperclass: aRBClass
	superclass := aRBClass!

shortName
	"Answer the shortest <String> name of the receiver that is bindable from Smalltalk. i.e. for classes defined directly in Smalltalk, or in any of its imports, this will be an unqualified name. Otherwise it is the fully qualified name relative to Smalltalk."

	^(self environment ifNil: [self model smalltalkNamespace]) shortNameFor: self unqualifiedName!

shortNameFor: aString
	"Private - Answer the short name for the receiver's variable named, aString. The short name is the shortest name that binds to variable starting from the Smalltalk namespace. This may be unqualified, partially qualified, or fully-qualified."

	^self model smalltalkNamespace shortNameFor: aString in: self!

subclasses
	^subclasses
		ifNil: 
			[subclasses := realClass
						ifNil: [#()]
						ifNotNil: 
							[| subs stream |
							subs := realClass subBehaviors.
							stream := WriteStream on: (Array new: subs size).
							subs do: [:each | (model classFor: each) ifNotNil: [:class | stream nextPut: class]].
							stream grabContents]]!

superclass
	^superclass == LookupSuperclass
		ifTrue: [self realClass superclass ifNotNil: [:sprClass | model instanceClassFor: sprClass]]
		ifFalse: [superclass]!

superclass: aRBClass
	self superclass ifNotNil: [:sprClass | sprClass removeSubclass: self].
	(superclass := aRBClass)
		ifNil: [(model classFor: Class) addSubclass: self metaclass]
		ifNotNil: [aRBClass addSubclass: self]!

unqualifiedName
	"Answer the unqualified name of the class."

	^unqualifiedName
		ifNil: [unqualifiedName := (BindingReference.PathSeparator split: name) last asSymbol]! !
!Refactory.Browser.RBClass categoriesForMethods!
<=!comparing!public! !
addBinding:!bindings!public! !
addClassConstant:!public!variable accessing! !
addClassVariable:!public!variable accessing! !
addImport:!namespaces!public! !
addSubclass:!class hierarchy-adding!private! !
allBehaviorsDo:!enumerating!public! !
allClassBindingNames!accessing!public! !
allClassesDo:!enumerating!public! !
allClassVariableNames!accessing!public! !
baseEnvironment!constants!private! !
basicEnvironment!accessing!public! !
bindingOrNil!bindings!public! !
buildClassPool!private! !
categoryNames!accessing!public! !
categoryNames:!accessing!public! !
changeImports:!namespaces!private! !
classCategories!accessing!public! !
classConstants:!accessing!public! !
classInstanceVariableNames!accessing!public! !
classPool!accessing!public! !
classVariableNames:!accessing!public! !
comment!accessing!public! !
comment:!accessing!public! !
defaultInstanceSpec!constants!private! !
definition!accessing!public! !
details!accessing!public! !
fullName:!accessing!private! !
fullNameFor:!helpers!private! !
fullyQualifiedReference!accessing!namespaces!public! !
getEnvironment!accessing!public! !
getInstanceSpec!accessing!private! !
guid!accessing!public! !
importedNamespacesDo:!public! !
imports!accessing!public! !
imports:!accessing!public! !
includesEnvironment:!namespaces!public!testing! !
includesNamespace:!public!testing! !
instanceClass!accessing!public! !
instanceSpec!accessing!public! !
instanceSpec:!public! !
isDefined!public!testing! !
isInBaseEnvironment!public!testing! !
isMeta!public!testing! !
isNonInstantiable!public!testing! !
isNonInstantiable:!instance specification-accessing!public! !
isNullTerminated!instance specification-testing!public! !
isPointers!public!testing! !
isVariable!public!testing! !
kindOfSubclass!class hierarchy-testing!private! !
localScope!accessing!public! !
metaclass!accessing!public! !
metaSubclasses!accessing!private! !
model!accessing!public! !
model:!initialize/release!private! !
model:existing:!private! !
model:named:!private! !
modelSuperclass!public! !
name!accessing!public! !
name:!accessing!public! !
nearestRealClass!accessing!private! !
newBindingContextForIdentifier:environment:!bindings!private! !
printDefinitionOn:!accessing!public! !
printFullNameOn:!printing!public! !
realClass!accessing!public! !
realClass:!accessing!public! !
removeBindingFor:!bindings!public! !
removeClassConstant:!public!variable accessing! !
removeClassVariable:!public!variable accessing! !
removeImport:!public!variable accessing! !
removeSubclass:!accessing!public! !
renameClassVariable:to:around:!public!variable accessing! !
replaceImport:with:!namespaces!public! !
resolveBindingPath:!bindings!private! !
resolveBindingPath:environment:!bindings!private! !
resolveImportedBinding:!bindings!private! !
resolveImportedEnvironmentBinding:!bindings!private! !
resolveLocalBindingPath:!bindings!private! !
resolveLocallyImportedBinding:!bindings!private! !
resolvePathString:environment:!bindings!private! !
resolvePublicBinding:!bindings!private! !
resolveUnqualifiedName:environment:!bindings!private! !
setModel:name:realClass:!accessing!initializing!private! !
setSuperclass:!initializing!private! !
shortName!accessing!public! !
shortNameFor:!enquiries!private! !
subclasses!accessing!public! !
superclass!accessing!public! !
superclass:!accessing!private! !
unqualifiedName!accessing!public! !
!

Refactory.Browser.RBClass methodProtocol: #importableNamespace attributes: #(#readOnly) selectors: #(#asQualifiedReference #fullName #includesEnvironment: #resolveLocalBindingPath: #resolvePublicBinding:)!

!Refactory.Browser.RBClass class methodsFor!

initialize
	LookupComment := Object new!

model: aRBModel named: aSymbol
	^self basicNew model: aRBModel named: aSymbol! !
!Refactory.Browser.RBClass class categoriesForMethods!
initialize!class initialization!public! !
model:named:!instance creation!public! !
!

