"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RBAbstractClass subclass: #'Refactory.Browser.RBClass'
	instanceVariableNames: 'model name metaclass realClass superclass subclasses unqualifiedName classPool imports category comment environment binding'
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

addClassVariable: aString
	self classPool add: (RBVariableBinding name: aString environment: self).
	model addClassVariable: aString to: self!

addImport: aString
	| ref |
	ref := aString asQualifiedReference.
	self changeImports: (self imports copyWith: (ref referenceInModel: model))!

addSubclass: aRBClass
	subclasses := self subclasses copyWith: aRBClass!

allBehaviorsDo: operation
	self allClassesDo: 
			[:class |
			operation value: class.
			operation value: class metaclass]!

allBindingsDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the bindings in the receiver, including aliases, and recursively in any of the nested namespaces."

	self bindingsDo: 
			[:each |
			aMonadicValuable value: each.
			each isClassBinding ifTrue: [each value bindingsDo: aMonadicValuable]]!

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

allImports
	"Answer a <sequencedReadableCollection> of <BindingReference> being the imports that are specified in the receiver and each of its superclasses."

	| all seen |
	all := Array writeStream: 5.
	seen := Set new.
	self
		withAllSuperclassesDo: [:c | c imports do: [:each | (seen addNewElement: each) ifTrue: [all nextPut: each]]].
	^all contents!

baseEnvironment
	"Private - Answer the default environment for new subclasses of the receiver that the ClassBuilder should use when the provided subclass name is unqualified."

	^model smalltalkNamespace!

basicEnvironment
	"Rather confusingly, this is environment in the sense of being a namespace (i.e. an instance of RBNamespaceClass) and is compatible with the use of the term in the Behavior/ClassDescription/Class/Metaclass hierarchy.
	It's not the BrowserEnvironment (another type of scope) environment of the RBModel (Refactoring model) class."

	^environment ifNil: [environment := self getEnvironment]!

bindingOrNil
	"Answer the binding for the receiver in the model."

	^binding
		ifNil: 
			[binding := self globalScope fullBindingFor: self name.
			binding]!

bindings
	^self classPool associations!

bindingsDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the receiver's localled defined <VariableBinding>s."

	self classPool associationsDo: aMonadicValuable!

category
	^category isNil
		ifTrue: [model environment whichCategoryIncludes: self name]
		ifFalse: [category]!

category: aSymbol 
	category := aSymbol!

changeImports: anArray
	imports := anArray.
	model import: anArray into: self!

classBindingNames
	^self definedBindings collect: [:each | each key]!

classConstants
	"The answer is a temporary value representing a subset of the class variable bindings collection, so mark it immutable to catch errors of attempting to modify it"

	^(self definedBindings select: [:each | each isImmutable and: [each value isSelfEvaluating]])
		isImmutable: true;
		yourself!

classConstants: aCollectionOfAssociations
	| pool |
	pool := self classPool.
	aCollectionOfAssociations do: 
			[:each |
			pool add: ((RBVariableBinding name: each key environment: self)
						value: each value;
						isImmutable: true;
						yourself)]!

classInModel: aRBModel
	^self!

classInstanceVariableNames
	^self metaclass instanceVariableNames!

classPool
	^classPool
		ifNil: 
			[| realBindings |
			realBindings := realClass classPool.
			classPool := Dictionary new: realBindings size.
			realBindings associationsDo: 
					[:each |
					| var |
					var := RBVariableBinding new realBinding: each environment: self.
					each isClassBinding
						ifTrue: 
							[| class |
							var setValue: ((class := each value) rbClass model: model existing: class)].
					classPool add: var].
			classPool]!

classVariableNames
	^(self definedBindings reject: [:each | each isImmutable and: [each value isSelfEvaluating]])
		collect: [:each | each key]!

classVariableNames: aCollectionOfStrings
	classPool := Dictionary new: aCollectionOfStrings size.
	aCollectionOfStrings do: [:each | classPool add: (RBVariableBinding name: each environment: self)]!

classVariables
	"Answer a <collection> of <VariableBinding>s, being the class variables of the receiver, but not including class constants."

	^self bindings reject: [:each | each isImmutable and: [each value isSelfEvaluating]]!

comment
	^comment == LookupComment
		ifTrue: [comment := realClass ifNotNil: [realClass comment]]
		ifFalse: [comment]!

comment: aString
	model comment: (comment := aString) in: self!

definedBindings
	"Private - Answer a <collection> of the receiver's <RBVariableBinding>s that are defined as part of the receiver's class definition (as opposed to externally).
	For most classes this is all the class variables, including constants. For namespaces, this does not include any of the classes in the namespace as these are added to the namespace implicitly as part of their own definition."

	^self bindings select: [:each | each isClassVariable]!

definition
	| definitionStream |
	definitionStream := (String writeStream: 256)
				locale: SmalltalkLocale.Hex;
				yourself.
	self printDefinitionOn: definitionStream.
	^definitionStream contents!

directlyDefinesClassVariable: aString
	^self classPool includesKey: aString!

directlyImportsNamespace: aBindingReference
	"Namespace imports must always be absolute binding references, but they may be private, so we just compare the paths"

	| pathString |
	pathString := aBindingReference asString.
	^self imports anySatisfy: [:each | each pathString = pathString]!

environment
	"Rather confusingly, this is environment in the sense of being a namespace (i.e. an instance of RBNamespaceClass) and is compatible with the use of the term in the Behavior/ClassDescription/Class/Metaclass hierarchy.
	It's not the BrowserEnvironment (another type of scope) environment of the RBNamespace (Refactoring model) class. I think I might rename RBNamespace...."

	^self basicEnvironment!

fullName
	"Answer the <String> fully qualified name of the receiver, which is a dot-separated path that binds to the receiver from the global namespace, Root.
	Note that these names will also be bindable within the legacy Smalltalk namespace, because it is itself an immediate child of root, and so any of its siblings is bindable using that sibling's unqualified name."

	^name!

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
	^(FullBindingReference fullPathString: name) referenceInModel: model!

getEnvironment
	^(realClass notNil and: [realClass fullName = name])
		ifTrue: [realClass basicEnvironment classInModel: model]
		ifFalse: 
			[| ref |
			ref := self fullyQualifiedReference.
			ref isQualifiedName ifTrue: [ref environment] ifFalse: [self baseEnvironment]]!

getImports
	#rbFix.	"Dolphin stores the pool names in its classes, rather than the pools themselves."
	^self realClass imports
	"sharedPools collect: [:each | Smalltalk keyAtValue: each]"!

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

isDefined
	^realClass notNil!

isInBaseEnvironment
	^(BindingReference isQualifiedName: self fullName) not!

isMeta
	^false!

kindOfSubclass
	"Private - Answer a string describing the kind of subclassing method used to create the receiver 
	(part of its definition)."

	^self isVariable 
		ifTrue: [self isBytes ifTrue: ['variableByteSubclass:'] ifFalse: ['variableSubclass:']]
		ifFalse: ['subclass:']!

localBindingFor: aString
	"Answer a variable binding for the named variable directly in the scope of this class, i.e. one of its own class variables. If there is no such class variable, then answer nil."

	^self classPool bindingFor: aString!

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

nonMetaclass
	^self!

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

removeClassVariable: aString
	self removeBindingFor: aString.
	model removeClassVariable: aString from: self!

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
				withObject: (newBindingReference referenceInModel: model))!

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
		ifNotNil: [:var | var isPrivate ifFalse: [^var]].
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
	(metaclass := RBMetaclass basicNew) nonMetaclass: self.
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

	^self isInBaseEnvironment
		ifTrue: [name]
		ifFalse: [self model smalltalkNamespace shortNameFor: self unqualifiedName in: self environment]!

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
	(superclass := aRBClass) ifNotNil: [aRBClass addSubclass: self]!

unqualifiedName
	"Answer the unqualified name of the class."

	^unqualifiedName
		ifNil: [unqualifiedName := (BindingReference.PathSeparator split: name) last asSymbol]! !
!Refactory.Browser.RBClass categoriesForMethods!
<=!public! !
addBinding:!public! !
addClassVariable:!public!variable accessing! !
addImport:!namespaces!public! !
addSubclass:!class hierarchy-adding!private! !
allBehaviorsDo:!enumerating!public! !
allBindingsDo:!enumerating!public! !
allClassBindingNames!accessing!public! !
allClassesDo:!enumerating!public! !
allClassVariableNames!accessing!public! !
allImports!namespaces!public! !
baseEnvironment!constants!private! !
basicEnvironment!accessing!public! !
bindingOrNil!bindings!public! !
bindings!accessing!public! !
bindingsDo:!enumerating!public! !
category!accessing!public! !
category:!accessing!public! !
changeImports:!namespaces!private! !
classBindingNames!public! !
classConstants!accessing!public! !
classConstants:!accessing!public! !
classInModel:!public! !
classInstanceVariableNames!public! !
classPool!accessing!public! !
classVariableNames!accessing!public! !
classVariableNames:!accessing!public! !
classVariables!class variables!public! !
comment!accessing!public! !
comment:!accessing!public! !
definedBindings!accessing!public! !
definition!accessing!public! !
directlyDefinesClassVariable:!public!testing! !
directlyImportsNamespace:!public!testing! !
environment!accessing!public! !
fullName!accessing!public! !
fullName:!accessing!private! !
fullNameFor:!helpers!private! !
fullyQualifiedReference!accessing!namespaces!public! !
getEnvironment!accessing!public! !
getImports!helpers!private! !
imports!accessing!public! !
imports:!accessing!public! !
includesEnvironment:!namespaces!public!testing! !
includesNamespace:!public!testing! !
isDefined!public!testing! !
isInBaseEnvironment!public! !
isMeta!public!testing! !
kindOfSubclass!class hierarchy-testing!private! !
localBindingFor:!bindings!public! !
localScope!accessing!public! !
metaclass!accessing!public! !
metaSubclasses!accessing!private! !
model!accessing!public! !
model:!initialize/release!public! !
name!accessing!public! !
name:!accessing!public! !
nearestRealClass!accessing!private! !
newBindingContextForIdentifier:environment:!bindings!private! !
nonMetaclass!accessing!public! !
printDefinitionOn:!accessing!public! !
printFullNameOn:!public! !
realClass!accessing!public! !
realClass:!accessing!public! !
removeBindingFor:!public! !
removeClassVariable:!public!variable accessing! !
removeSubclass:!accessing!public! !
renameClassVariable:to:around:!public!variable accessing! !
replaceImport:with:!namespaces!public! !
resolveBindingPath:!bindings!private! !
resolveBindingPath:environment:!bindings!private! !
resolveImportedBinding:!bindings!private! !
resolveImportedEnvironmentBinding:!bindings!private! !
resolveLocallyImportedBinding:!bindings!private! !
resolvePathString:environment:!bindings!private! !
resolvePublicBinding:!bindings!private! !
resolveUnqualifiedName:environment:!bindings!private! !
setModel:name:realClass:!accessing!initializing!private! !
setSuperclass:!initializing!private! !
shortName!public! !
subclasses!accessing!public! !
superclass!accessing!public! !
superclass:!accessing!private! !
unqualifiedName!public! !
!

Refactory.Browser.RBClass methodProtocol: #importableNamespace attributes: #(#readOnly) selectors: #(#asQualifiedReference #includesEnvironment: #resolvePublicBinding:)!

!Refactory.Browser.RBClass class methodsFor!

initialize
	LookupComment := Object new!

model: aRBModel existing: aClass
	^self basicNew
		setModel: aRBModel
			name: aClass fullName
			realClass: aClass;
		yourself!

model: aRBModel named: aSymbol
	^self basicNew
		setModel: aRBModel name: aSymbol realClass: nil;
		yourself! !
!Refactory.Browser.RBClass class categoriesForMethods!
initialize!class initialization!public! !
model:existing:!instance creation!public! !
model:named:!instance creation!public! !
!

