"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'Refactory.Browser.RBAbstractClass'
	instanceVariableNames: 'newMethods instanceVariableNames removedMethods scope'
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
	(newMethods ifNil: [newMethods := IdentityDictionary new]) at: aRBMethod selector put: aRBMethod.
	removedMethods notNil ifTrue: [removedMethods remove: aRBMethod selector ifAbsent: nil]!

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
	| change method |
	change := self model
				compile: aString
				in: self
				categories: aCollection.
	method := RBMethod
				for: self
				source: aString
				selector: change selector.
	self addMethod: method.
	^change!

compile: aString classified: aSymbol
	#deprecated.
	^self compile: aString categories: {aSymbol}!

compile: aString environment: aNamespace categories: aSymbolCollection package: aPackage
	| change method |
	change := self model
				compile: aString
				in: self
				environment: aNamespace
				categories: aSymbolCollection
				package: aPackage.
	method := RBMethod
				for: self
				source: aString
				selector: change selector.
	self addMethod: method.
	#rbFix.	"Return the AddMethodChange object"
	^change!

compileTree: aBRMethodNode
	| selector packageAndEnvironment |
	selector := aBRMethodNode selector.
	packageAndEnvironment := self existingMethodPackageAndEnvironment: selector.
	^self
		compileTree: aBRMethodNode
		environment: packageAndEnvironment second
		categories: (self protocolsFor: selector)
		package: packageAndEnvironment first!

compileTree: aBRMethodNode categories: aCollection
	| packageAndEnv  |
	Notification deprecated.
	packageAndEnv := (self existingMethodPackageAndEnvironment: aBRMethodNode selector).
	^self
		compileTree: aBRMethodNode
		environment: packageAndEnv second
		categories: aCollection
		package: packageAndEnv first!

compileTree: aBRMethodNode classified: aSymbol
	Notification deprecated.
	^self compile: aBRMethodNode formattedCode classified: aSymbol!

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

directlyDefinesMethod: aSelector
	self realClass
		ifNotNil: 
			[:realClass |
			(self hasRemoved: aSelector) ifTrue: [^false].
			(realClass includesSelector: aSelector) ifTrue: [^true]].
	^newMethods notNil and: [newMethods includesKey: aSelector]!

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
	| class excluded |
	class := self realClass.
	class ifNil: [^#()].
	excluded := self newMethods keys addAll: self removedMethods.
	^class selectMethods: 
			[:each |
			(excluded includes: each selector) not and: 
					[each hasLiteralMatching: 
							[:literal |
							(literal isKindOf: VariableBinding)
								ifTrue: 
									["We want to exlude any class variables defined in the local hierarchy"
									(literal isClassVariable and: [each methodClass instanceClass includesBehavior: literal environment])
										not]
								ifFalse: 
									[(literal isKindOf: BindingReference) and: 
											["Fully qualified references should be unaffected by renames if they are not to the renamed class"
											literal isRelative]]]]]!

existingMethodsThatReferTo: anObject
	| existingMethods rejects |
	existingMethods := self realClass whichMethodsReferTo: anObject.
	(newMethods isNil and: [removedMethods isNil]) ifTrue: [^existingMethods].
	rejects := self newMethods keys
				addAll: self removedMethods;
				yourself.
	^existingMethods reject: [:each | rejects includes: each selector]!

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
	^removedMethods notNil and: [removedMethods includes: aSelector]!

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
					[(self existingMethodAt: aSelector)
						ifNotNil: 
							[:method |
							RBMethod
								for: self
								fromMethod: method
								andSelector: aSelector]]]!

methodsReferencingExternals
	| methods |
	methods := IdentitySet new.
	#namespaceToDo.	"Filter the newMethods by a parse tree match to find external variable references"
	methods addAll: self newMethods.
	self existingMethodsReferencingExternals do: [:each | methods add: (self newMethodFor: each)].
	^methods!

model
	^self subclassResponsibility!

name
	"Answer the name of the non-metaclass. Note that in Dolphin 8 this is always a fully-qualified name. It does not include the ' class' suffix for metaclasses."

	^self fullName!

nearestRealClass
	^self subclassResponsibility!

newMethodFor: each
	^RBMethod
		for: self
		fromMethod: each
		andSelector: each selector!

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

removedMethods
	^removedMethods ?? ##(IdentitySet new
				isImmutable: true;
				yourself)!

removeInstanceVariable: aString
	instanceVariableNames := instanceVariableNames copyWithout: aString.
	self model removeInstanceVariable: aString from: self!

removeMethod: aSelector
	self newMethods removeKey: aSelector ifAbsent: nil.
	self model removeMethod: aSelector from: self.
	(removedMethods ifNil: [removedMethods := Set new]) add: aSelector!

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
			selectors addAll: realClass selectors.
			removedMethods ifNotNil: [removedMethods do: [:each | selectors remove: each ifAbsent: nil]]].
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
	methods := IdentitySet new.
	newMethods ifNotNil: [newMethods do: [:each | (each refersToClass: aRBClass) ifTrue: [methods add: each]]].
	(self isDefined and: [(class := aRBClass realClass) notNil])
		ifTrue: 
			[(self existingMethodsThatReferTo: class instanceClass)
				do: [:each | methods add: (self newMethodFor: each)]].
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
addMethod:!method accessing!public! !
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
compileTree:!compiling!public! !
compileTree:categories:!compiling!public! !
compileTree:classified:!compiling!public! !
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
removedMethods!accessing!public! !
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

