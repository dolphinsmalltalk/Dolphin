"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Refactory.Browser.RBAbstractClass'
	instanceVariableNames: 'newMethods instanceVariableNames removedSelectors scope'
	classVariableNames: 'LookupSuperclass'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBAbstractClass guid: (Core.GUID fromString: '{99469076-f20a-4a7f-91f1-c2d06d948a14}')!
Refactory.Browser.RBAbstractClass isNonInstantiable: true!
Refactory.Browser.RBAbstractClass comment: 'RBAbstractClass is an abstract class. It represents classes in the system. Refactorings operate on these objects, producing change objects. These change objects are then performed on the real code.

Subclasses must implement the following messages:
	accessing
		allClassVariableNames
		allPoolDictionaryNames
	testing
		directlyDefinesClassVariable:
		directlyDefinesPoolDictionary:
		isAbstract
		isMeta

Instance Variables:
	instanceVariableNames	<SequenceableCollection of: String>	instance variables that the class defines
	model	<RBNamespace>	where the class is defined
	name	<ByteSymbol>	the class'' name for metaclasses it is the name of the nonMetaclass
	newMethods	<Dictionary of: RBMethod>	methods that have been added to the class
	realClass	<Behavior>	if the class already exists in the system, then this variable holds that class
	removedMethods	<Collection of: Symbol>	method names that have been removed
	subclasses	<Collection of: RBAbstractClass>	my subclasses
	superclass	<RBAbstractClass>	the superclass (or LookupSuperclass if we haven''t assigned it yet).

Class Variables:
	LookupSuperclass	<Object>	a special object denoting that our superclass hasn''t been assigned yet

'!
!Refactory.Browser.RBAbstractClass categoriesForClass!Refactory-Model! !
!Refactory.Browser.RBAbstractClass methodsFor!

= aRBClass
	^self == aRBClass
		or: [self class == aRBClass class and: [self name = aRBClass name and: [self model = aRBClass model]]]!

>> aSymbol
	^self methodFor: aSymbol!

addInstanceVariable: aString
	instanceVariableNames := self instanceVariableNames copyWith: aString.
	self model addInstanceVariable: aString to: self!

addMethod: aRBMethod
	| selector |
	selector := aRBMethod selector.
	newMethods
		ifNil: [newMethods := IdentityDictionary new]
		ifNotNil: [(newMethods lookup: selector) ifNotNil: [:method | ^method]].
	removedSelectors ifNotNil: [removedSelectors remove: selector ifAbsent: nil].
	newMethods at: selector put: aRBMethod!

addMethodChange: anAddMethodChange
	| selector |
	selector := anAddMethodChange selector.
	((newMethods ifNil: [newMethods := IdentityDictionary new]) lookup: selector)
		ifNil: [newMethods at: selector put: (RBMethod for: self change: anAddMethodChange)]
		ifNotNil: [:method | method source: anAddMethodChange source].
	removedSelectors notNil ifTrue: [removedSelectors remove: selector ifAbsent: nil].
	^anAddMethodChange!

allBindingsDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the bindings in the receiver, including aliases, and recursively in any of the nested namespaces."

	self bindingsDo: 
			[:each |
			aMonadicValuable value: each.
			each isClassBinding ifTrue: [each value bindingsDo: aMonadicValuable]]!

allClassVariableNames
	^self subclassResponsibility!

allImports
	"Answer a <sequencedReadableCollection> of <BindingReference> being the imports that are specified in the receiver and each of its superclasses."

	| all seen |
	all := Array writeStream: 5.
	seen := Set new.
	self
		withAllSuperclassesDo: [:c | c imports do: [:each | (seen addNewElement: each) ifTrue: [all nextPut: each]]].
	^all contents!

allInstanceVariableNames
	^self modelSuperclass
		ifNil: [self instanceVariableNames]
		ifNotNil: [:sprClass | sprClass allInstanceVariableNames , self instanceVariableNames]!

allSelectors
	| class selectors |
	class := self.
	selectors := Set new.
	[class notNil] whileTrue: 
			[selectors addAll: class selectors.
			class := class superclass].
	^selectors!

allSubclasses
	"Answer a <collection> of the receiver's subclasses in breadth-first order, with the immediate subclasses first. "

	| answer i |
	answer := OrderedCollection withAll: self subclasses.
	i := 1.
	[i <= answer size] whileTrue: 
			[answer addAllLast: (answer at: i) subclasses.
			i := i + 1].
	^answer!

allSuperclasses
	| supers sprClass |
	supers := OrderedCollection new.
	sprClass := self superclass.
	[sprClass notNil] whileTrue: 
			[supers add: sprClass.
			sprClass := sprClass superclass].
	^supers!

allSuperclassesDo: aMonadicValuable
	"Private - Evaluate the monadic valuable argument for each of the receiver's 
	superclasses."

	| class current |
	class := self.
	
	[current := class superclass.
	class := current.
	current isNil] 
			whileFalse: [aMonadicValuable value: current]!

asQualifiedReference
	^self fullyQualifiedReference!

baseEnvironment
	"Private - Answer the default environment for new subclasses of the receiver that the ClassBuilder should use when the provided subclass name is unqualified."

	^self subclassResponsibility!

baseEnvironmentName
	"See Class>>baseEnvironment"
	
	^self baseEnvironment name!

basicEnvironment
	^self subclassResponsibility!

binding
	^self bindingOrNil ifNil: [self globalScope errorNotFound: self name asQualifiedReference]!

bindingFor: aString
	"Answer a variable binding for the named variable in the scope of this class (not including imports). If there is no such variable, then answer nil."

	^(self hierarchyBindingFor: aString)
		ifNil: [self environment ifNotNil: [:env | env bindingFor: aString]]!

bindingOrNil
	"Resolve the binding for the receiver's real class, if any. The name is always a fully qualified name"

	^self subclassResponsibility!

bindings
	^self classPool associations!

bindingsDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the receiver's localled defined <VariableBinding>s."

	self classPool associationsDo: aMonadicValuable!

canUnderstand: aSymbol 
	^(self lookupMethod: aSymbol) notNil!

classBindingNames
	^self definedBindings collect: [:each | each key]!

classConstants
	"The answer is a temporary value representing a subset of the class variable bindings collection, so mark it immutable to catch errors of attempting to modify it"

	^(self definedBindings select: [:each | each isImmutable and: [each value isSelfEvaluating]])
		beImmutableObject;
		yourself!

classInModel: aRBModel
	^self!

classPool
	"Answer the dictionary of class variables."

	^self subclassResponsibility!

classVariableNames
	^(self definedBindings reject: [:each | each isImmutable and: [each value isSelfEvaluating]])
		collect: [:each | each key]!

classVariables
	"Answer a <collection> of <VariableBinding>s, being the class variables of the receiver, but not including class constants."

	^self bindings reject: [:each | each isImmutable and: [each value isSelfEvaluating]]!

compile: aString 
	#rbFix. "Support multiple method categories for Dolphin"
	^self compile: aString
		categories: (self protocolsFor: (Parser parseMethodPattern: aString))!

compile: aString categories: aCollection
	^self addMethodChange: (self model
				compile: aString
				in: self
				categories: aCollection)!

compile: aString classified: aSymbol
	#deprecated.
	^self compile: aString categories: {aSymbol}!

compile: aString environment: aNamespace categories: aSymbolCollection package: aPackage
	^self addMethodChange: (self model
				compile: aString
				in: self
				environment: aNamespace
				categories: aSymbolCollection
				package: aPackage)!

compiledMethodAt: aSelector ifAbsent: aNiladicValuable
	^(self methodFor: aSelector) ifNil: [aNiladicValuable value]!

compileTree: aBRMethodNode environment: aRBNamespaceClass categories: aSymbolCollection package: aPackage
	^self
		compile: aBRMethodNode formattedCode
		environment: aRBNamespaceClass
		categories: aSymbolCollection
		package: aPackage!

conformsToProtocol: aSymbol
	| class |
	class := self realClass.
	^class notNil and: [class conformsToProtocol: aSymbol]!

definedBindings
	"Private - Answer a <collection> of the receiver's <RBVariableBinding>s that are defined as part of the receiver's class definition (as opposed to externally).
	For most classes this is all the class variables, including constants. For namespaces, this does not include any of the classes in the namespace as these are added to the namespace implicitly as part of their own definition."

	^self bindings select: [:each | each isClassVariable]!

definesClassVariable: aSymbol
	| sprClass |
	(self directlyDefinesClassVariable: aSymbol) ifTrue: [^true].
	sprClass := self superclass.
	^sprClass notNil and: [sprClass definesClassVariable: aSymbol]!

definesInstanceVariable: aString
	| sprClass |
	(self directlyDefinesInstanceVariable: aString) ifTrue: [^true].
	sprClass := self superclass.
	^sprClass notNil and: [sprClass definesInstanceVariable: aString]!

definesMethod: aSelector
	| sprClass |
	(self directlyDefinesMethod: aSelector) ifTrue: [^true].
	sprClass := self superclass.
	^sprClass notNil and: [sprClass definesMethod: aSelector]!

definesStaticVariable: aString
	| sprClass |
	(self directlyDefinesStaticVariable: aString) ifTrue: [^true].
	sprClass := self superclass.
	^sprClass notNil and: [sprClass definesStaticVariable: aString]!

definesVariable: aVariableName 
	^(self definesStaticVariable: aVariableName) 
		or: [self definesInstanceVariable: aVariableName]!

directlyDefinesClassVariable: aString
	| var |
	var := self localBindingFor: aString.
	^var notNil and: [var isClassVariable]!

directlyDefinesInstanceVariable: aString 
	^self instanceVariableNames includes: aString!

directlyDefinesMethod: aSymbol
	self realClass
		ifNotNil: 
			[:realClass |
			(removedSelectors notNil and: [removedSelectors includes: aSymbol]) ifTrue: [^false].
			(realClass includesSelector: aSymbol) ifTrue: [^true]].
	^newMethods notNil and: [newMethods includesKey: aSymbol]!

directlyDefinesStaticVariable: aString
	^self classPool includesKey: aString!

directlyDefinesVariable: aVariableName 
	^(self directlyDefinesClassVariable: aVariableName) 
		or: [self directlyDefinesInstanceVariable: aVariableName]!

directlyImportsNamespace: aBindingReference
	"Namespace imports must always be absolute binding references, but they may be private, so we just compare the paths"

	| pathString |
	pathString := aBindingReference asString.
	^self imports anySatisfy: [:each | each pathString = pathString]!

environment
	"Answer the receiver's namespace (i.e. an instance of RBNamespaceClass). This is the RBClass' environment as the term is used the Behavior/ClassDescription/Class/Metaclass hierarchy, and not a BrowserEnvironment (another type of scope) environment of the RBModel (Refactoring model) class."

	^self basicEnvironment!

environmentName
	| parts count stream |
	parts := BindingReference.PathSeparator split: self fullName.
	(count := parts size) < 2 ifTrue: [^self baseEnvironmentName].
	stream := String writeStream: 32.
	stream nextPutAll: (parts at: 1).
	2 to: count - 1
		do: 
			[:i |
			stream
				nextPut: BindingReference.PathSeparator;
				nextPutAll: (parts at: i)].
	^stream contents!

existingMethodAt: aSymbol
	^self realClass ifNotNil: [:class | class compiledMethodAt: aSymbol ifAbsent: nil]!

existingMethodPackageAndEnvironment: aSymbol
	^(self existingMethodAt: aSymbol)
		ifNil: [Pair first: nil second: self environment]
		ifNotNil: 
			[:method |
			| package |
			package := method owningPackage.
			Pair first: package
				second: ((method customEnvironment ifNil: [package ifNotNil: [package environment]])
						ifNotNil: [:namespace | namespace classInModel: self model]
						ifNil: [self basicEnvironment])]!

existingMethodsReferencingExternals
	| class rejects |
	class := self realClass.
	class ifNil: [^#()].
	"The answer must not include methods updated or removed in the model."
	rejects := self newMethods keys
				addAll: self removedSelectors;
				yourself.
	^class selectMethods: 
			[:each |
			(rejects includes: each selector) not
				and: [each hasLiteralMatching: [:literal | self isExternalReference: literal in: each]]]!

existingMethodsThatReferTo: anObject
	| existingMethods |
	existingMethods := self realClass whichMethodsReferTo: anObject.
	"Convoluted, but this can be called an awful lot"
	^newMethods
		ifNil: 
			[removedSelectors
				ifNil: [existingMethods]
				ifNotNil: [existingMethods reject: [:each | removedSelectors includes: each selector]]]
		ifNotNil: 
			[removedSelectors
				ifNil: [existingMethods reject: [:each | newMethods includesKey: each selector]]
				ifNotNil: 
					[| rejects |
					rejects := newMethods keys
								addAll: removedSelectors;
								yourself.
					existingMethods reject: [:each | rejects includes: each selector]]]!

fullBindingFor: aString
	"Answer a variable binding for the named variable in the scope of this class, and failing that in the receiver's environment. If there is no such variable, then answer nil."

	^self fullBindingFor: aString environment: self environment!

fullBindingFor: aString environment: aRBNamespaceClass
	"Answer a variable binding for the named variable in the scope of this class, and failing that in the receiver's environment. If there is no such variable, then answer nil."

	^self instanceClass resolvePathString: aString environment: aRBNamespaceClass!

fullName
	"Answer the <String> fully qualified name of the receiver, which is a dot-separated path that binds to the receiver from the global namespace, Root.
	Note that these names will also be bindable within the legacy Smalltalk namespace, because it is itself an immediate child of root, and so any of its siblings is bindable using that sibling's unqualified name."

	^self name!

fullyQualifiedReference
	^self subclassResponsibility!

globalScope
	"Answer the <RBNamespaceClass> to use as the binding root for fully-qualified names in the receiver."

	^self model smalltalkNamespace!

hash
	^self name hash bitXor: self class hash!

hasRemoved: aSelector
	^removedSelectors notNil and: [removedSelectors includes: aSelector]!

hierarchyBindingFor: aString
	"Answer a variable binding for the named variable in the scope of this class, i.e. one of its own class variables or those of its superclasses. The imported namespaces and enclosing environment are not searched. If there is no such variable defined in the hierarchy answer nil."

	^(self localBindingFor: aString)
		ifNil: [self superclass ifNotNil: [:sprClass | sprClass hierarchyBindingFor: aString]]!

hierarchyDefinesInstanceVariable: aString
	(self definesInstanceVariable: aString) ifTrue: [^true].
	^self allSubclasses anySatisfy: [:each | each directlyDefinesInstanceVariable: aString]!

hierarchyDefinesMethod: aSelector
	^(self definesMethod: aSelector) or: [self subclassRedefines: aSelector]!

hierarchyDefinesVariable: aString
	(self definesVariable: aString) ifTrue: [^true].
	^self allSubclasses anySatisfy: [:each | each directlyDefinesVariable: aString]!

hierarchyImportsNamespace: aBindingReference
	| ref |
	ref := aBindingReference asQualifiedReference.
	(self importsNamespace: ref) ifTrue: [^true].
	^self allSubclasses anySatisfy: [:each | each directlyImportsNamespace: aBindingReference]!

imports
	^self subclassResponsibility!

importsNamespace: aBindingReference
	| sprClass ref |
	ref := aBindingReference asQualifiedReference.
	(self directlyImportsNamespace: ref) ifTrue: [^true].
	sprClass := self superclass.
	^sprClass notNil and: [sprClass importsNamespace: ref]!

includesBehavior: aBehavior
	"Answer whether the receiver includes the behavior, aBehavior (i.e. is aBehavior the receiver or a superclass of the receiver)."

	| current |
	current := self.
	
	[current = aBehavior ifTrue: [^true].
	current isNil] whileFalse: [current := current superclass].
	^false!

includesClass: aRBClass 
	| currentClass |
	currentClass := self.
	[currentClass notNil and: [currentClass ~= aRBClass]] 
		whileTrue: [currentClass := currentClass superclass].
	^currentClass = aRBClass!

includesSelector: aSymbol 
	^self directlyDefinesMethod: aSymbol!

inheritsFrom: aBehavior
	"Answer whether the receiver is a subclass of the argument. This is the same as #includesBehavior:, but starts from the superclass of the receiver."

	"An iterative solution is not as elegant as recursion, but has a small performance advantage."

	| current |
	current := self superclass.
	
	[aBehavior = current ifTrue: [^true].
	current isNil] whileFalse: [current := current superclass].
	^false!

inheritsPoolDictionaries
	#rbFix.	"Dolphin inherits pool dictionaries"
	^true!

instanceClass
	^self subclassResponsibility!

instanceVariableNames
	instanceVariableNames
		ifNil: 
			[self realClass
				ifNotNil: [:realClass | self instanceVariableNames: realClass instanceVariableNames]
				ifNil: [instanceVariableNames := #()]].
	^instanceVariableNames!

instanceVariableNames: aCollectionOfStrings
	instanceVariableNames := aCollectionOfStrings!

isAbstract
	self realClass ifNotNil: [:real | real isNonInstantiable ifTrue: [^true]].
	(self whichMethodsReferToSymbol: #subclassResponsibility) notEmpty ifTrue: [^true].
	self model allReferencesToClass: self do: [:each | ^false].
	^true!

isBytes
	"Answer whether the variables of instances of the receiver are stored as bytes (8-bit integers)."

	^self isPointers not!

isDefined
	^self subclassResponsibility!

isExternalReference: literalObject in: aCompiledMethod
	(literalObject isKindOf: VariableBinding)
		ifTrue: 
			["We want to exlude any class variables defined in the local hierarchy"
			^(literalObject isClassVariable
				and: [aCompiledMethod methodClass instanceClass includesBehavior: literalObject environment]) not].
	(literalObject isKindOf: BindingReference)
		ifTrue: 
			["Fully qualified references should be unaffected by renames if they are not to the renamed class"
			^literalObject isRelative].
	"In some cases, e.g. FFI functions, methods may contain direct references to classes as literals, not the binding"
	^literalObject isBehavior!

isMeta
	self subclassResponsibility!

isPointers
	#rbFix. "Added"
	^self nearestRealClass ifNil: [true] ifNotNil: [:class | class isPointers]!

isVariable
	#rbFix. "Added"
	^self nearestRealClass ifNil: [true] ifNotNil: [:class | class isVariable]!

localBindingFor: aString
	"Answer a variable binding for the named variable directly in the scope of this class, i.e. one of its own class variables. If there is no such class variable, then answer nil."

	^self classPool bindingFor: aString!

localScope
	^self subclassResponsibility!

lookupMethod: aSymbol
	"Answer the method of the receiver, or inherited by the receiver, corresponding to the selector, aSymbol."

	^(self directlyDefinesMethod: aSymbol)
		ifTrue: [self methodFor: aSymbol]
		ifFalse: [self superclass ifNotNil: [:superclass | superclass lookupMethod: aSymbol]]!

metaclass
	^self subclassResponsibility!

methodFor: aSelector
	^self newMethods at: aSelector
		ifAbsent: 
			[(self hasRemoved: aSelector)
				ifFalse: 
					[(self existingMethodAt: aSelector) ifNotNil: [:method | RBMethod for: self fromMethod: method]]]!

methodsDo: aMonadicValuable
	self newMethods do: aMonadicValuable.
	self realClass
		ifNotNil: 
			[:class |
			| removed |
			removed := self removedSelectors.
			removed isEmpty
				ifTrue: 
					[self model environment selectorsForClass: class
						do: [:each | aMonadicValuable value: (self newMethodFor: (class compiledMethodAt: each))]]
				ifFalse: 
					[self model environment selectorsForClass: class
						do: 
							[:each |
							(removed includes: each)
								ifFalse: [aMonadicValuable value: (self newMethodFor: (class compiledMethodAt: each))]]]]!

methodsReferencingExternals
	| methods |
	#namespaceToDo.	"Filter the newMethods by a parse tree match to find external variable references"
	methods := self newMethods copy.
	self existingMethodsReferencingExternals do: 
			[:each |
			| selector |
			selector := each selector.
			methods at: selector put: (self newMethodFor: each)].
	^methods!

model
	^self subclassResponsibility!

modelSuperclass
	"Answer the model superclass of the receiver, whether or not it is defined in the model's environment."

	^self subclassResponsibility!

name
	"Answer the name of the non-metaclass. Note that in Dolphin 8 this is always a fully-qualified name. It does not include the ' class' suffix for metaclasses."

	^self fullName!

nearestRealClass
	^self subclassResponsibility!

newMethodFor: aCompiledMethod
	^RBMethod for: self fromMethod: aCompiledMethod!

newMethods
	^newMethods ?? ##(IdentityDictionary new
				beImmutableObject;
				yourself)!

owningPackage
	^self realClass ifNotNil: [:class | class owningPackage]!

parseTreeFor: aSelector 
	| class |
	class := self whoDefinesMethod: aSelector.
	class isNil ifTrue: [^nil].
	^(class methodFor: aSelector) parseTree!

primaryInstance
	^self instanceClass!

printOn: aStream 
	aStream nextPutAll: self shortName!

protocolsFor: aSelector
	#rbFix.	"Added to support Dolphin's multiple method categories"
	^(self model changes changeForClassNamed: self fullyQualifiedReference selector: aSelector)
		ifNil: 
			[self realClass
				ifNotNil: [:realClass | BrowserEnvironment new whichProtocolsInclude: aSelector in: realClass]
				ifNil: [#(#accessing)]]
		ifNotNil: [:change | change protocols]!

realClass
	^self subclassResponsibility!

removedSelectors
	^removedSelectors ?? ##(IdentitySet new
				beImmutableObject;
				yourself)!

removeInstanceVariable: aString
	instanceVariableNames := instanceVariableNames copyWithout: aString.
	self model removeInstanceVariable: aString from: self!

removeSelector: aSelector
	self newMethods removeKey: aSelector ifAbsent: nil.
	self model removeSelector: aSelector from: self.
	(removedSelectors ifNil: [removedSelectors := Set new]) add: aSelector!

renameInstanceVariable: oldName to: newName around: aBlock
	self instanceVariableNames isImmutable
		ifTrue: [instanceVariableNames := instanceVariableNames copy].
	instanceVariableNames at: (instanceVariableNames indexOf: oldName asString) put: newName asString.
	self model
		renameInstanceVariable: oldName
		to: newName
		in: self
		around: aBlock!

scope
	^scope ifNil: [scope := StClassScope methodClass: self]!

selectors
	| selectors |
	selectors := self newMethods keys.
	self realClass
		ifNotNil: 
			[:realClass |
			| removed |
			removed := self removedSelectors.
			removed isEmpty
				ifTrue: [selectors addAll: realClass selectors]
				ifFalse: [realClass selectorsDo: [:each | (removed includes: each) ifFalse: [selectors add: each]]]].
	^selectors!

selectorsDo: aMonadicValuable 
	^self selectors do: aMonadicValuable!

shortName
	"Answer the shorted <String> name of the receiver that is bindable from Smalltalk. i.e. for classes defined directly in Smalltalk, or in any of its imports, this will be an unqualified name. Otherwise it is the fully qualified name relative to Smalltalk."

	^self subclassResponsibility!

soleInstance
	^self instanceClass!

sourceCodeFor: aSelector 
	| class |
	class := self whoDefinesMethod: aSelector.
	class isNil ifTrue: [^nil].
	^(class methodFor: aSelector) source!

storeOn: aStream 
	aStream nextPutAll: self name!

subclasses
	^self subclassResponsibility!

subclassRedefines: aSelector
	"Return true, if one of your subclasses redefines the method with name, aMethod"

	^self allSubclasses anySatisfy: [:each | each directlyDefinesMethod: aSelector]!

superclass
	^self subclassResponsibility!

typeOfClassVariable: aSymbol
	^self model instanceClassFor: Object!

unqualifiedName
	"Answer the unqualified name of the class."

	^self subclassResponsibility!

whichClassDefinesInstVar: aString 
	^self whoDefinesInstanceVariable: aString!

whichClassIncludesSelector: selector
	"Answer the first class on the receiver's superclass chain (including the receiver) where 
	the argument, selector, can be founds as a message selector. Answer nil if no class includes
	the selector."

	^(self directlyDefinesMethod: selector)
		ifTrue: [self]
		ifFalse: [self superclass ifNotNil: [:superclass | superclass whichClassIncludesSelector: selector]]!

whichMethodsReferToBinding: aRBVariableBinding
	| methods binding |
	methods := IdentityDictionary new.
	newMethods
		ifNotNil: 
			[newMethods
				do: [:each | (each refersToBinding: aRBVariableBinding) ifTrue: [methods at: each selector put: each]]].
	(self isDefined and: [(binding := aRBVariableBinding realBinding) notNil])
		ifTrue: 
			[(self existingMethodsThatReferTo: binding) do: 
					[:each |
					| selector |
					selector := each selector.
					(methods includesKey: selector) ifFalse: [methods at: selector put: (self newMethodFor: each)]]].
	^methods!

whichMethodsReferToClass: aRBClass
	| methods class |
	methods := IdentityDictionary new.
	newMethods
		ifNotNil: 
			[newMethods
				do: [:each | (each refersToClass: aRBClass) ifTrue: [methods at: each selector put: each]]].
	(self isDefined and: [(class := aRBClass realClass) notNil])
		ifTrue: 
			[(self existingMethodsThatReferTo: class instanceClass) do: 
					[:each |
					| selector |
					selector := each selector.
					(methods includesKey: selector) ifFalse: [methods at: selector put: (self newMethodFor: each)]]].
	^methods!

whichMethodsReferToSymbol: aSymbol
	| methods |
	methods := Set new.
	self newMethods do: [:each | (each refersToSymbol: aSymbol) ifTrue: [methods add: each]].
	self isDefined
		ifTrue: 
			[(self existingMethodsThatReferTo: aSymbol) do: [:each | methods add: (self newMethodFor: each)]].
	^methods!

whichMethodsReferToVariable: aRBVariableBinding
	| methods variableName binding |
	methods := Set new.
	variableName := aRBVariableBinding key.
	self newMethods do: [:each | (each refersToVariable: variableName) ifTrue: [methods add: each]].
	(binding := aRBVariableBinding realBinding) ifNil: [^methods].
	methods
		addAll: (((self realClass whichMethodsReferTo: binding)
				reject: [:each | self hasRemoved: each selector]) collect: [:each | self methodFor: each selector]).
	^methods!

whichSelectorsReferToClassVariable: aString
	| selectors class binding |
	#rbFix.	"From John Brant, 2001-08-03, supercedes wiki patch"
	selectors := Set new.
	self newMethods
		do: [:each | (each refersToVariable: aString) ifTrue: [selectors add: each selector]].
	(class := self instanceClass realClass) ifNil: [^selectors].
	(class := class whichClassDefinesClassVar: aString asString) ifNil: [^selectors].
	(binding := (self model instanceClassFor: class) bindingFor: aString) ifNil: [^selectors].
	(binding := binding realBinding) ifNil: [^selectors].
	selectors
		addAll: ((self realClass whichSelectorsReferTo: binding) reject: [:each | self hasRemoved: each]).
	^selectors!

whichSelectorsReferToInstanceVariable: aString
	| selectors |
	selectors := Set new.
	self newMethods
		do: [:each | (each refersToVariable: aString) ifTrue: [selectors add: each selector]].
	self realClass
		ifNotNil: 
			[:realClass |
			selectors
				addAll: ((realClass whichSelectorsAccess: aString) reject: [:each | self hasRemoved: each])].
	^selectors!

whoDefinesClassVariable: aString
	(self directlyDefinesClassVariable: aString) ifTrue: [^self].
	^self superclass ifNotNil: [:sprClass | sprClass whoDefinesClassVariable: aString]!

whoDefinesInstanceVariable: aString
	(self directlyDefinesInstanceVariable: aString) ifTrue: [^self].
	^self superclass ifNotNil: [:sprClass | sprClass whoDefinesInstanceVariable: aString]!

whoDefinesMethod: aSelector
	(self directlyDefinesMethod: aSelector) ifTrue: [^self].
	^self superclass ifNotNil: [:sprClass | sprClass whoDefinesMethod: aSelector]!

withAllSubclasses
	^(self allSubclasses)
		add: self;
		yourself!

withAllSubclassesDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for the receiver and each of its subclasses using a depth-first traversal."

	aMonadicValuable value: self.
	self allSubclasses do: aMonadicValuable!

withAllSuperclasses
	#rbFix.	"Ensure in reverse hierarchy order"
	^(self allSuperclasses)
		addFirst: self;
		yourself!

withAllSuperclassesDo: aMonadicValuable
	"Evaluate the monadic valuable argument for the receiver and each 
	of its superclasses in reverse order of hierarchy."

	aMonadicValuable value: self.
	self allSuperclassesDo: aMonadicValuable! !
!Refactory.Browser.RBAbstractClass categoriesForMethods!
=!comparing!public! !
>>!accessing!public! !
addInstanceVariable:!public!variable accessing! !
addMethod:!compiling!public! !
addMethodChange:!compiling!public! !
allBindingsDo:!enumerating!public! !
allClassVariableNames!accessing!public! !
allImports!namespaces!public! !
allInstanceVariableNames!accessing!public! !
allSelectors!methods-accessing!public! !
allSubclasses!accessing!public! !
allSuperclasses!accessing!public! !
allSuperclassesDo:!accessing!public! !
asQualifiedReference!converting!public! !
baseEnvironment!constants!private! !
baseEnvironmentName!accessing!public! !
basicEnvironment!accessing!public! !
binding!accessing!public! !
bindingFor:!bindings!public! !
bindingOrNil!bindings!public! !
bindings!accessing!public! !
bindingsDo:!enumerating!public! !
canUnderstand:!methods-testing!public! !
classBindingNames!accessing!bindings!public! !
classConstants!accessing!public! !
classInModel:!converting!public! !
classPool!class variables!public! !
classVariableNames!accessing!public! !
classVariables!class variables!public! !
compile:!compiling!public! !
compile:categories:!compiling!public! !
compile:classified:!compiling!public! !
compile:environment:categories:package:!compiling!public! !
compiledMethodAt:ifAbsent:!methods-accessing!public! !
compileTree:environment:categories:package:!compiling!public! !
conformsToProtocol:!protocols!public! !
definedBindings!accessing!public! !
definesClassVariable:!public!testing! !
definesInstanceVariable:!public!testing! !
definesMethod:!public!testing! !
definesStaticVariable:!public!testing! !
definesVariable:!public!testing! !
directlyDefinesClassVariable:!public!testing! !
directlyDefinesInstanceVariable:!public!testing! !
directlyDefinesMethod:!public!testing! !
directlyDefinesStaticVariable:!public!testing! !
directlyDefinesVariable:!public!testing! !
directlyImportsNamespace:!public!testing! !
environment!accessing!public! !
environmentName!accessing!public! !
existingMethodAt:!methods-accessing!public! !
existingMethodPackageAndEnvironment:!methods-accessing!public! !
existingMethodsReferencingExternals!methods-accessing!private! !
existingMethodsThatReferTo:!methods-testing!private! !
fullBindingFor:!bindings!public! !
fullBindingFor:environment:!bindings!public! !
fullName!accessing!public! !
fullyQualifiedReference!accessing!private! !
globalScope!accessing!public! !
hash!comparing!public! !
hasRemoved:!public!testing! !
hierarchyBindingFor:!bindings!public! !
hierarchyDefinesInstanceVariable:!public!testing! !
hierarchyDefinesMethod:!public!testing! !
hierarchyDefinesVariable:!public!testing! !
hierarchyImportsNamespace:!public!testing! !
imports!accessing!public! !
importsNamespace:!public!testing! !
includesBehavior:!class hierarchy-testing!public! !
includesClass:!public!testing! !
includesSelector:!public! !
inheritsFrom:!class hierarchy-testing!public! !
inheritsPoolDictionaries!public!testing! !
instanceClass!accessing!public! !
instanceVariableNames!accessing!public! !
instanceVariableNames:!accessing!public! !
isAbstract!public!testing! !
isBytes!instance specification-testing!public! !
isDefined!public!testing! !
isExternalReference:in:!methods-testing!private! !
isMeta!public!testing! !
isPointers!public!testing! !
isVariable!public!testing! !
localBindingFor:!bindings!public! !
localScope!accessing!public! !
lookupMethod:!methods-accessing!public! !
metaclass!accessing!public! !
methodFor:!methods-accessing!public! !
methodsDo:!methods-enumerating!public! !
methodsReferencingExternals!methods-accessing!public! !
model!accessing!public! !
modelSuperclass!accessing!public! !
name!accessing!public! !
nearestRealClass!accessing!private! !
newMethodFor:!methods-accessing!private! !
newMethods!accessing!public! !
owningPackage!accessing!public! !
parseTreeFor:!methods-accessing!public! !
primaryInstance!accessing!public! !
printOn:!printing!public! !
protocolsFor:!accessing!public! !
realClass!accessing!public! !
removedSelectors!accessing!public! !
removeInstanceVariable:!public!variable accessing! !
removeSelector:!methods-removing!public! !
renameInstanceVariable:to:around:!public!variable accessing! !
scope!accessing!public! !
selectors!methods-accessing!public! !
selectorsDo:!enumerating!public! !
shortName!accessing!public! !
soleInstance!accessing!public! !
sourceCodeFor:!methods-accessing!public! !
storeOn:!printing!public! !
subclasses!accessing!public! !
subclassRedefines:!public!testing! !
superclass!accessing!public! !
typeOfClassVariable:!public!variable accessing! !
unqualifiedName!accessing!public! !
whichClassDefinesInstVar:!public!variable accessing! !
whichClassIncludesSelector:!public!testing! !
whichMethodsReferToBinding:!methods-testing!public! !
whichMethodsReferToClass:!methods-testing!public! !
whichMethodsReferToSymbol:!methods-testing!public! !
whichMethodsReferToVariable:!methods-testing!public! !
whichSelectorsReferToClassVariable:!methods-testing!public! !
whichSelectorsReferToInstanceVariable:!methods-testing!public! !
whoDefinesClassVariable:!public!variable accessing! !
whoDefinesInstanceVariable:!public!variable accessing! !
whoDefinesMethod:!methods-testing!public! !
withAllSubclasses!accessing!public! !
withAllSubclassesDo:!enumerating!public! !
withAllSuperclasses!accessing!public! !
withAllSuperclassesDo:!accessing!public! !
!

Refactory.Browser.RBAbstractClass methodProtocol: #classDescription attributes: #(#ansi #readOnly) selectors: #(#allSubclasses #allSuperclasses #name #subclasses #superclass)!

!Refactory.Browser.RBAbstractClass class methodsFor!

initialize
	LookupSuperclass := Object new! !
!Refactory.Browser.RBAbstractClass class categoriesForMethods!
initialize!class initialization!public! !
!

