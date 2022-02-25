"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'Refactory.Browser.RBAbstractClass'
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
	^self class == aRBClass class 
		and: [self name = aRBClass name and: [self model = aRBClass model]]!

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
		ifNil: 
			[newMethods at: selector
				put: (RBMethod
						for: self
						source: anAddMethodChange source
						selector: selector)]
		ifNotNil: [:method | method source: anAddMethodChange source].
	removedSelectors notNil ifTrue: [removedSelectors remove: selector ifAbsent: nil].
	^anAddMethodChange!

allClassVariableNames
	^self subclassResponsibility!

allImports
	^self subclassResponsibility!

allInstanceVariableNames
	^self superclass
		ifNil: [self instanceVariableNames]
		ifNotNil: [:sprClass | sprClass allInstanceVariableNames , self instanceVariableNames]!

allInstVarNames
	"Required for StSemanticAnalyzer"

	^self allInstanceVariableNames!

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

	| answer |
	answer := OrderedCollection new.
	self allSubclassesBreadthFirstDo: [:each | answer addLast: each].
	^answer!

allSubclassesBreadthFirstDo: aMonadicValuable
	"Evaluate the monadic valuable argument with each of the receiver's subclasses in breadth-first order."

	self subclasses
		do: aMonadicValuable;
		do: [:each | each allSubclassesBreadthFirstDo: aMonadicValuable]!

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

classInModel: aRBModel
	^self!

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

compileTree: aBRMethodNode environment: aRBNamespaceClass categories: aSymbolCollection package: aPackage
	^self
		compile: aBRMethodNode formattedCode
		environment: aRBNamespaceClass
		categories: aSymbolCollection
		package: aPackage!

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

definesVariable: aVariableName 
	^(self definesClassVariable: aVariableName) 
		or: [self definesInstanceVariable: aVariableName]!

directlyDefinesClassVariable: aString 
	self subclassResponsibility!

directlyDefinesInstanceVariable: aString 
	^self instanceVariableNames includes: aString!

directlyDefinesMethod: aSymbol
	self realClass
		ifNotNil: 
			[:realClass |
			(removedSelectors notNil and: [removedSelectors includes: aSymbol]) ifTrue: [^false].
			(realClass includesSelector: aSymbol) ifTrue: [^true]].
	^newMethods notNil and: [newMethods includesKey: aSymbol]!

directlyDefinesVariable: aVariableName 
	^(self directlyDefinesClassVariable: aVariableName) 
		or: [self directlyDefinesInstanceVariable: aVariableName]!

directlyImportsNamespace: aString
	^self subclassResponsibility!

environment
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

	^self nonMetaclass resolvePathString: aString environment: aRBNamespaceClass!

fullName
	"Answer the <String> fully qualified name of the receiver, which is a dot-separated path that binds to the receiver from the global namespace, Root.
	Note that these names will also be bindable within the legacy Smalltalk namespace, because it is itself an immediate child of root, and so any of its siblings is bindable using that sibling's unqualified name."

	^self subclassResponsibility!

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

hierarchyDefinesClassVariable: aString
	(self definesClassVariable: aString) ifTrue: [^true].
	self
		allSubclassesBreadthFirstDo: [:each | (each directlyDefinesClassVariable: aString) ifTrue: [^true]].
	^false!

hierarchyDefinesInstanceVariable: aString 
	(self definesInstanceVariable: aString) ifTrue: [^true].
	self allSubclassesBreadthFirstDo: [:each | (each directlyDefinesInstanceVariable: aString) ifTrue: [^true]].
	^false!

hierarchyDefinesMethod: aSelector 
	(self definesMethod: aSelector) ifTrue: [^true].
	^self subclassRedefines: aSelector!

hierarchyDefinesVariable: aString
	(self definesVariable: aString) ifTrue: [^true].
	self allSubclassesBreadthFirstDo: [:each | (each directlyDefinesVariable: aString) ifTrue: [^true]].
	^false!

hierarchyImportsNamespace: aBindingReference
	| ref |
	ref := aBindingReference asQualifiedReference.
	(self importsNamespace: ref) ifTrue: [^true].
	self
		allSubclassesBreadthFirstDo: [:each | (each directlyImportsNamespace: aBindingReference) ifTrue: [^true]].
	^false!

importsNamespace: aBindingReference
	| sprClass ref |
	ref := aBindingReference asQualifiedReference.
	(self directlyImportsNamespace: ref) ifTrue: [^true].
	sprClass := self superclass.
	^sprClass notNil and: [sprClass importsNamespace: ref]!

includesClass: aRBClass 
	| currentClass |
	currentClass := self.
	[currentClass notNil and: [currentClass ~= aRBClass]] 
		whileTrue: [currentClass := currentClass superclass].
	^currentClass = aRBClass!

inheritsFrom: aBehavior
	"Answer whether the receiver is a subclass of the argument. This is the same as #includesBehavior:, but starts from the superclass of the receiver."

	"An iterative solution is not as elegant as recursion, but has a small performance advantage."

	| current |
	current := self superclass.
	
	[aBehavior == current ifTrue: [^true].
	current isNil] whileFalse: [current := current superclass].
	^false!

inheritsPoolDictionaries
	#rbFix.	"Dolphin inherits pool dictionaries"
	^true!

instanceClass
	#rbFix.	"Added because Dolphin uses this message rather than #soleInstance"
	^self nonMetaclass!

instanceVariableNames
	instanceVariableNames
		ifNil: 
			[self realClass
				ifNotNil: [:realClass | self instanceVariableNames: realClass instVarNames]
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

	^self subclassResponsibility!

localScope
	^self subclassResponsibility!

metaclass
	^self subclassResponsibility!

methodFor: aSelector
	^self newMethods at: aSelector
		ifAbsent: 
			[(self hasRemoved: aSelector)
				ifFalse: 
					[(self existingMethodAt: aSelector) ifNotNil: [:method | RBMethod for: self fromMethod: method]]]!

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

name
	"Answer the name of the non-metaclass. Note that in Dolphin 8 this is always a fully-qualified name. It does not include the ' class' suffix for metaclasses."

	^self fullName!

nearestRealClass
	^self subclassResponsibility!

newMethodFor: each
	^RBMethod for: self fromMethod: each!

newMethods
	^newMethods ?? ##(IdentityDictionary new
				isImmutable: true;
				yourself)!

nonMetaclass
	^self subclassResponsibility!

parseTreeFor: aSelector 
	| class |
	class := self whoDefinesMethod: aSelector.
	class isNil ifTrue: [^nil].
	^(class methodFor: aSelector) parseTree!

primaryInstance
	^self nonMetaclass!

printOn: aStream 
	aStream nextPutAll: self name!

protocolsFor: aSelector
	| change |
	#rbFix.	"Added to support Dolphin's multiple method categories"
	change := self isMeta
				ifTrue: [self model changes changeForMetaclass: self name selector: aSelector]
				ifFalse: [self model changes changeForClass: self name selector: aSelector].
	^change isNil
		ifTrue: 
			[self realClass
				ifNotNil: [:realClass | BrowserEnvironment new whichProtocolsInclude: aSelector in: realClass]
				ifNil: [#(#accessing)]]
		ifFalse: [change protocols]!

realClass
	^self subclassResponsibility!

removedSelectors
	^removedSelectors ?? ##(IdentitySet new
				isImmutable: true;
				yourself)!

removeInstanceVariable: aString
	instanceVariableNames := instanceVariableNames copyWithout: aString.
	self model removeInstanceVariable: aString from: self!

removeMethod: aSelector
	self newMethods removeKey: aSelector ifAbsent: nil.
	self model removeMethod: aSelector from: self.
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
	selectors := Set new.
	selectors addAll: self newMethods keys.
	self realClass
		ifNotNil: 
			[:realClass |
			| removed |
			removed := self removedSelectors.
			removed isEmpty
				ifTrue: [selectors addAll: realClass selectors]
				ifFalse: [realClass selectorsDo: [:each | (removed includes: each) ifFalse: [selectors add: each]]]].
	^selectors!

soleInstance
	^self nonMetaclass!

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

	self allSubclassesBreadthFirstDo: [:each | (each directlyDefinesMethod: aSelector) ifTrue: [^true]].
	^false!

superclass
	^self subclassResponsibility!

typeOfClassVariable: aSymbol
	^self model instanceClassFor: Object!

unqualifiedName
	"Answer the unqualified name of the class."

	^self subclassResponsibility!

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

whichSelectorsReferToClassVariable: aString
	| selectors class binding |
	#rbFix.	"From John Brant, 2001-08-03, supercedes wiki patch"
	selectors := Set new.
	self newMethods
		do: [:each | (each refersToVariable: aString) ifTrue: [selectors add: each selector]].
	(class := self nonMetaclass realClass) ifNil: [^selectors].
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
	self allSubclassesBreadthFirstDo: aMonadicValuable!

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
addInstanceVariable:!public!variable accessing! !
addMethod:!compiling!public! !
addMethodChange:!compiling!public! !
allClassVariableNames!accessing!public! !
allImports!accessing!public! !
allInstanceVariableNames!accessing!public! !
allInstVarNames!accessing!public! !
allSelectors!method accessing!public! !
allSubclasses!accessing!public! !
allSubclassesBreadthFirstDo:!accessing!public! !
allSuperclasses!accessing!public! !
allSuperclassesDo:!accessing!public! !
asQualifiedReference!converting!public! !
baseEnvironment!constants!private! !
baseEnvironmentName!accessing!public! !
basicEnvironment!accessing!public! !
binding!accessing!public! !
bindingFor:!bindings!public! !
bindingOrNil!bindings!public! !
classInModel:!public! !
compile:!compiling!public! !
compile:categories:!compiling!public! !
compile:classified:!compiling!public! !
compile:environment:categories:package:!compiling!public! !
compileTree:environment:categories:package:!compiling!public! !
definesClassVariable:!public!testing! !
definesInstanceVariable:!public!testing! !
definesMethod:!public!testing! !
definesVariable:!public!testing! !
directlyDefinesClassVariable:!public!testing! !
directlyDefinesInstanceVariable:!public!testing! !
directlyDefinesMethod:!public!testing! !
directlyDefinesVariable:!public!testing! !
directlyImportsNamespace:!public!testing! !
environment!accessing!public! !
environmentName!accessing!public! !
existingMethodAt:!method accessing!public! !
existingMethodPackageAndEnvironment:!method accessing!public! !
existingMethodsReferencingExternals!method accessing!private! !
existingMethodsThatReferTo:!method accessing!private! !
fullBindingFor:!binding!public! !
fullBindingFor:environment:!public! !
fullName!accessing!public! !
fullyQualifiedReference!accessing!private! !
globalScope!accessing!public! !
hash!comparing!public! !
hasRemoved:!public!testing! !
hierarchyBindingFor:!bindings!public! !
hierarchyDefinesClassVariable:!public!testing! !
hierarchyDefinesInstanceVariable:!public!testing! !
hierarchyDefinesMethod:!public!testing! !
hierarchyDefinesVariable:!public!testing! !
hierarchyImportsNamespace:!public!testing! !
importsNamespace:!public!testing! !
includesClass:!public!testing! !
inheritsFrom:!class hierarchy-testing!public! !
inheritsPoolDictionaries!public!testing! !
instanceClass!accessing!public! !
instanceVariableNames!accessing!public! !
instanceVariableNames:!accessing!public! !
isAbstract!public!testing! !
isBytes!instance specification-testing!public! !
isDefined!public!testing! !
isExternalReference:in:!method accessing!private! !
isMeta!public!testing! !
isPointers!public!testing! !
isVariable!public!testing! !
localBindingFor:!binding!public! !
localScope!accessing!public! !
metaclass!accessing!public! !
methodFor:!method accessing!public! !
methodsReferencingExternals!method accessing!public! !
model!accessing!public! !
name!accessing!public! !
nearestRealClass!accessing!private! !
newMethodFor:!method accessing!private! !
newMethods!accessing!public! !
nonMetaclass!accessing!public! !
parseTreeFor:!method accessing!public! !
primaryInstance!accessing!public! !
printOn:!printing!public! !
protocolsFor:!accessing!public! !
realClass!accessing!public! !
removedSelectors!accessing!public! !
removeInstanceVariable:!public!variable accessing! !
removeMethod:!method accessing!public! !
renameInstanceVariable:to:around:!public!variable accessing! !
scope!accessing!public! !
selectors!method accessing!public! !
soleInstance!accessing!public! !
sourceCodeFor:!method accessing!public! !
storeOn:!printing!public! !
subclasses!accessing!public! !
subclassRedefines:!public!testing! !
superclass!accessing!public! !
typeOfClassVariable:!public!variable accessing! !
unqualifiedName!accessing!public! !
whichMethodsReferToClass:!method accessing!public! !
whichMethodsReferToSymbol:!method accessing!public! !
whichSelectorsReferToClassVariable:!method accessing!public! !
whichSelectorsReferToInstanceVariable:!method accessing!public! !
whoDefinesClassVariable:!public!variable accessing! !
whoDefinesInstanceVariable:!public!variable accessing! !
whoDefinesMethod:!method accessing!public! !
withAllSubclasses!accessing!public! !
withAllSubclassesDo:!enumerating!public! !
withAllSuperclasses!accessing!public! !
withAllSuperclassesDo:!accessing!public! !
!

Refactory.Browser.RBAbstractClass methodProtocol: #classDescription attributes: #(#ansi #readOnly) selectors: #(#allSubclasses #allSuperclasses #name #subclasses #superclass)!

!Refactory.Browser.RBAbstractClass class methodsFor!

initialize
	LookupSuperclass := Object new!

new
	"RBClasses must always be #named:"

	^self shouldNotImplement! !
!Refactory.Browser.RBAbstractClass class categoriesForMethods!
initialize!class initialization!public! !
new!instance creation!public! !
!

