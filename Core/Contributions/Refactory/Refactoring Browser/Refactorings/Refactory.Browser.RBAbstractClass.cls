"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'Refactory.Browser.RBAbstractClass'
	instanceVariableNames: 'name newMethods instanceVariableNames model superclass subclasses removedMethods realClass'
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
	^self class = aRBClass class 
		and: [self name = aRBClass name and: [self model = aRBClass model]]!

addInstanceVariable: aString 
	self privateInstanceVariableNames add: aString.
	model addInstanceVariable: aString to: self!

addMethod: aRBMethod
	(newMethods ifNil: [newMethods := IdentityDictionary new]) at: aRBMethod selector put: aRBMethod.
	removedMethods notNil ifTrue: [removedMethods remove: aRBMethod selector ifAbsent: []]!

addSubclass: aRBClass 
	self subclasses add: aRBClass!

allClassVariableNames
	^self subclassResponsibility!

allImports
	^self subclassResponsibility!

allInstanceVariableNames
	| sprClass |
	sprClass := self superclass.
	^sprClass isNil 
		ifTrue: [self instanceVariableNames]
		ifFalse: [sprClass allInstanceVariableNames , self instanceVariableNames]!

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

baseEnvironmentName
	"See Class>>baseEnvironment"
	
	^#Smalltalk!

binding
	^self bindingOrNil ifNil: [Smalltalk errorNotFound: self name asQualifiedReference]!

bindingFor: aString
	"Answer a variable binding for the named variable in the scope of this class (not including imports). If there is no such variable, then answer nil."

	^(self hierarchyBindingFor: aString)
		ifNil: [self environment ifNotNil: [:env | env bindingFor: aString]]!

bindingOrNil
	"Resolve the binding for the receiver's real class, if any. The name is always a fully qualified name"

	^Smalltalk resolveBindingPath: ($. split: self name)!

compile: aString 
	#rbFix. "Support multiple method categories for Dolphin"
	^self compile: aString
		classified: (self protocolsFor: (RBParser parseMethodPattern: aString))!

compile: aString classified: aSymbolCollection
	| change method |
	change := model
				compile: aString
				in: self
				classified: aSymbolCollection.
	method := RBMethod
				for: self
				source: aString
				selector: change selector.
	self addMethod: method.
	#rbFix.	"Return the AddMethodChange object"
	^change!

compileTree: aBRMethodNode 
	^self compileTree: aBRMethodNode
		classified: (self protocolsFor: aBRMethodNode selector)!

compileTree: aBRMethodNode classified: aSymbolCollection 
	| source |
	source := aBRMethodNode formattedCode.
	^self compile: source classified: aSymbolCollection!

definesClassVariable: aSymbol 
	(self directlyDefinesClassVariable: aSymbol) ifTrue: [^true].
	^self superclass notNil 
		and: [self superclass definesClassVariable: aSymbol]!

definesInstanceVariable: aString 
	(self directlyDefinesInstanceVariable: aString) ifTrue: [^true].
	^self superclass notNil 
		and: [self superclass definesInstanceVariable: aString]!

definesMethod: aSelector 
	(self directlyDefinesMethod: aSelector) ifTrue: [^true].
	^self superclass notNil and: [self superclass definesMethod: aSelector]!

definesVariable: aVariableName 
	^(self definesClassVariable: aVariableName) 
		or: [self definesInstanceVariable: aVariableName]!

directlyDefinesClassVariable: aString 
	self subclassResponsibility!

directlyDefinesInstanceVariable: aString 
	^self instanceVariableNames includes: aString!

directlyDefinesMethod: aSelector 
	self isDefined 
		ifTrue: 
			[(self hasRemoved: aSelector) ifTrue: [^false].
			(self realClass includesSelector: aSelector) ifTrue: [^true]].
	^newMethods notNil and: [newMethods includesKey: aSelector]!

directlyDefinesVariable: aVariableName 
	^(self directlyDefinesClassVariable: aVariableName) 
		or: [self directlyDefinesInstanceVariable: aVariableName]!

directlyImportsNamespace: aString
	^self subclassResponsibility!

environment
	^self subclassResponsibility!

environmentName
	| parts count stream first |
	parts := $. split: self fullName.
	(count := parts size) < 2 ifTrue: [^self baseEnvironmentName].
	first := true.
	stream := String writeStream.
	1 to: count - 1
		do: 
			[:i |
			first ifTrue: [first := false] ifFalse: [stream nextPut: $.].
			stream nextPutAll: (parts at: i)].
	^stream contents!

existingMethodsThatReferTo: anObject
	| existingMethods |
	existingMethods := self realClass whichSelectorsReferTo: anObject.
	(newMethods isNil and: [removedMethods isNil]) ifTrue: [^existingMethods].
	^existingMethods reject: [:each | (self hasRemoved: each) or: [self newMethods includesKey: each]]!

existingMethodsThatReferToAnyOf: aCollection
	| existingMethods |
	existingMethods := self realClass whichSelectorsReferToAnyOf: aCollection.
	(newMethods isNil and: [removedMethods isNil]) ifTrue: [^existingMethods].
	^existingMethods reject: [:each | (self hasRemoved: each) or: [self newMethods includesKey: each]]!

fullBindingFor: aString
	"Answer a variable binding for the named variable in the scope of this class, and failing that in the receiver's environment. If there is no such variable, then answer nil."

	^self nonMetaclass resolvePathString: aString!

fullName
	^name!

fullyQualifiedReference
	^self subclassResponsibility!

hash
	^self name hash bitXor: self class hash!

hasRemoved: aSelector 
	^removedMethods notNil and: [removedMethods includes: aSelector]!

hierarchyBindingFor: aString
	"Answer a variable binding for the named variable in the scope of this class, i.e. one of its own class variables or those of its superclasses. The imported namespaces and enclosing environment are not searched. If there is no such variable defined in the hierarchy answer nil."

	^(self localBindingFor: aString)
		ifNil: [self superclass ifNotNil: [:superc | superc hierarchyBindingFor: aString]]!

hierarchyDefinesClassVariable: aString 
	(self definesClassVariable: aString) ifTrue: [^true].
	^self allSubclasses anySatisfy: [:each | each directlyDefinesClassVariable: aString]!

hierarchyDefinesInstanceVariable: aString 
	(self definesInstanceVariable: aString) ifTrue: [^true].
	^self allSubclasses anySatisfy: [:each | each directlyDefinesInstanceVariable: aString]!

hierarchyDefinesMethod: aSelector 
	(self definesMethod: aSelector) ifTrue: [^true].
	^self subclassRedefines: aSelector!

hierarchyDefinesVariable: aString 
	(self definesVariable: aString) ifTrue: [^true].
	^self allSubclasses anySatisfy: [:each | each directlyDefinesVariable: aString]!

hierarchyImportsNamespace: aString
	(self importsNamespace: aString) ifTrue: [^true].
	^self allSubclasses anySatisfy: [:each | each directlyImportsNamespace: aString]!

importsNamespace: aSymbol
	(self directlyImportsNamespace: aSymbol) ifTrue: [^true].
	^self inheritsPoolDictionaries
		and: [self superclass notNil and: [self superclass importsNamespace: aSymbol]]!

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
	^self privateInstanceVariableNames copy!

instanceVariableNames: aCollectionOfStrings
	instanceVariableNames := OrderedCollection withAll: aCollectionOfStrings!

isAbstract
	self realClass ifNotNil: [:real | real isNonInstantiable ifTrue: [^true]].
	(self whichMethodsReferToSymbol: #subclassResponsibility) notEmpty ifTrue: [^true].
	model allReferencesToClass: self do: [:each | ^false].
	^true!

isBytes
	"Answer whether the variables of instances of the receiver are stored as bytes (8-bit integers)."

	^self isPointers not!

isDefined
	^self realClass notNil!

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

metaclass
	^model metaclassNamed: self name!

methodFor: aSelector
	^self newMethods at: aSelector
		ifAbsent: 
			[| compiledMethod class |
			(self hasRemoved: aSelector) ifTrue: [^nil].
			class := self realClass.
			class isNil ifTrue: [^nil].
			compiledMethod := class compiledMethodAt: aSelector ifAbsent: [nil].
			compiledMethod isNil
				ifTrue: [nil]
				ifFalse: 
					[RBMethod
						for: self
						fromMethod: compiledMethod
						andSelector: aSelector]]!

model
	^model!

model: aRBNamespace 
	model := aRBNamespace!

name
	"Answer the fully-qualified name of the non-metaclass."

	^name!

name: aString
	name := aString!

nearestRealClass
	#rbFix.	"Added"
	^self realClass isNil 
		ifTrue: [superclass notNil ifTrue: [superclass nearestRealClass]]
		ifFalse: [self realClass]!

newMethods
	^newMethods
		ifNil: 
			[##(IdentityDictionary new
				isImmutable: true;
				yourself)]!

nonMetaclass
	^model classNamed: self fullName!

parseTreeFor: aSelector 
	| class |
	class := self whoDefinesMethod: aSelector.
	class isNil ifTrue: [^nil].
	^(class methodFor: aSelector) parseTree!

primaryInstance
	^self nonMetaclass!

printOn: aStream 
	aStream nextPutAll: self name!

privateInstanceVariableNames
	instanceVariableNames isNil
		ifTrue: 
			[self isDefined
				ifTrue: [self instanceVariableNames: self realClass instVarNames]
				ifFalse: [instanceVariableNames := OrderedCollection new]].
	^instanceVariableNames!

protocolsFor: aSelector
	| change |
	#rbFix.	"Added to support Dolphin's multiple method categories"
	change := self isMeta
				ifTrue: [model changes changeForMetaclass: name selector: aSelector]
				ifFalse: [model changes changeForClass: name selector: aSelector].
	^change isNil
		ifTrue: 
			[self isDefined
				ifTrue: [BrowserEnvironment new whichProtocolsInclude: aSelector in: self realClass]
				ifFalse: [#(#accessing)]]
		ifFalse: [change protocols]!

realClass
	^realClass!

realClass: aClass 
	realClass := aClass.
	superclass isNil ifTrue: [superclass := LookupSuperclass]!

removedMethods
	^removedMethods isNil ifTrue: [removedMethods := Set new] ifFalse: [removedMethods]!

removeInstanceVariable: aString 
	self privateInstanceVariableNames remove: aString.
	model removeInstanceVariable: aString from: self!

removeMethod: aSelector 
	self newMethods removeKey: aSelector ifAbsent: [].
	model removeMethod: aSelector from: self.
	self removedMethods add: aSelector!

removeSubclass: aRBClass 
	self subclasses remove: aRBClass ifAbsent: []!

renameInstanceVariable: oldName to: newName around: aBlock 
	self privateInstanceVariableNames 
		at: (self privateInstanceVariableNames indexOf: oldName asString)
		put: newName asString.
	model 
		renameInstanceVariable: oldName
		to: newName
		in: self
		around: aBlock!

selectors
	| selectors |
	selectors := Set new.
	selectors addAll: self newMethods keys.
	self isDefined
		ifTrue: 
			[selectors addAll: self realClass selectors.
			removedMethods notNil ifTrue: [removedMethods do: [:each | selectors remove: each ifAbsent: []]]].
	^selectors!

setName: aSymbol 
	name := aSymbol!

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
	#rbFix.	"Dolphin doesn't include Object class as a subclass of class, so we implement #subBehaviors which does"
	subclasses isNil
		ifTrue: 
			[#rbFix.	"If the model's environment doesn't include all the subclasses, then the original code ends up with nils in the collection"
			subclasses := OrderedCollection new.
			self isDefined
				ifTrue: 
					[self realClass subBehaviors
						do: [:each | (model classFor: each) ifNotNil: [:class | subclasses addLast: class]]]].
	^subclasses!

subclassRedefines: aSelector 
	"Return true, if one of your subclasses redefines the method with name, aMethod"

	self allSubclasses 
		do: [:each | (each directlyDefinesMethod: aSelector) ifTrue: [^true]].
	^false!

superclass
	^superclass == LookupSuperclass 
		ifTrue: [model classFor: self realClass superclass]
		ifFalse: [superclass]!

superclass: aRBClass 
	self superclass notNil ifTrue: [self superclass removeSubclass: self].
	superclass := aRBClass.
	superclass notNil ifTrue: [superclass addSubclass: self].!

typeOfClassVariable: aSymbol
	^model classNamed: #'Core.Object'!

unqualifiedName
	"Answer the unqualified name of the non-metaclass."

	^self subclassResponsibility!

whichMethodsReferToSymbol: aSymbol
	| selectors |
	selectors := Set new.
	self newMethods do: [:each | (each refersToSymbol: aSymbol) ifTrue: [selectors add: each selector]].
	self isDefined ifTrue: [selectors addAll: (self existingMethodsThatReferTo: aSymbol)].
	^selectors collect: [:sel | self methodFor: sel]!

whichSelectorsReferToClass: aRBClass
	| selectors |
	selectors := IdentitySet new.
	self newMethods do: [:each | (each refersToClass: aRBClass) ifTrue: [selectors add: each selector]].
	(self isDefined and: [aRBClass isDefined])
		ifTrue: 
			[| literals |
			#namespaceToDo.	"Bodge to search for unqualified name symbols"
			literals := aRBClass realClass
						ifNil: [{aRBClass name asSymbol. aRBClass unqualifiedName}]
						ifNotNil: 
							[:class | | instClass |
							instClass := class instanceClass.
							{instClass. instClass binding. aRBClass name asSymbol. aRBClass unqualifiedName}].
			selectors addAll: (self existingMethodsThatReferToAnyOf: literals)].
	^selectors!

whichSelectorsReferToClassVariable: aString
	| selectors |
	#rbFix.	"From John Brant, 2001-08-03, supercedes wiki patch"
	selectors := Set new.
	self newMethods
		do: [:each | (each refersToVariable: aString) ifTrue: [selectors add: each selector]].
	self nonMetaclass isDefined
		ifTrue: 
			[| binding definingClass |
			definingClass := self nonMetaclass realClass whichClassDefinesClassVar: aString asString.
			definingClass notNil ifTrue: [binding := (model classFor: definingClass) bindingFor: aString].
			binding isNil ifTrue: [^selectors].
			selectors
				addAll: ((self realClass whichSelectorsReferTo: binding) reject: [:each | self hasRemoved: each])].
	^selectors!

whichSelectorsReferToInstanceVariable: aString
	| selectors |
	selectors := Set new.
	self newMethods
		do: [:each | (each refersToVariable: aString) ifTrue: [selectors add: each selector]].
	self isDefined
		ifTrue: 
			[selectors
				addAll: ((self realClass whichSelectorsAccess: aString) reject: [:each | self hasRemoved: each])].
	^selectors!

whoDefinesClassVariable: aString 
	| sprClass |
	(self directlyDefinesClassVariable: aString) ifTrue: [^self].
	sprClass := self superclass.
	^sprClass isNil 
		ifTrue: [nil]
		ifFalse: [sprClass whoDefinesClassVariable: aString]!

whoDefinesInstanceVariable: aString 
	| sprClass |
	(self directlyDefinesInstanceVariable: aString) ifTrue: [^self].
	sprClass := self superclass.
	^sprClass isNil 
		ifTrue: [nil]
		ifFalse: [sprClass whoDefinesInstanceVariable: aString]!

whoDefinesMethod: aSelector 
	| sprClass |
	(self directlyDefinesMethod: aSelector) ifTrue: [^self].
	sprClass := self superclass.
	^sprClass isNil 
		ifTrue: [nil]
		ifFalse: [sprClass whoDefinesMethod: aSelector]!

withAllSubclasses
	^(self allSubclasses)
		add: self;
		yourself!

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
addSubclass:!class hierarchy-adding!private! !
allClassVariableNames!accessing!public! !
allImports!accessing!public! !
allInstanceVariableNames!accessing!public! !
allSelectors!method accessing!public! !
allSubclasses!accessing!public! !
allSubclassesBreadthFirstDo:!accessing!public! !
allSuperclasses!accessing!public! !
allSuperclassesDo:!accessing!public! !
baseEnvironmentName!accessing!public! !
binding!accessing!public! !
bindingFor:!bindings!public! !
bindingOrNil!bindings!public! !
compile:!method accessing!public! !
compile:classified:!method accessing!public! !
compileTree:!method accessing!public! !
compileTree:classified:!method accessing!public! !
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
existingMethodsThatReferTo:!method accessing!public! !
existingMethodsThatReferToAnyOf:!method accessing!public! !
fullBindingFor:!binding!public! !
fullName!accessing!public! !
fullyQualifiedReference!accessing!private! !
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
metaclass!accessing!public! !
methodFor:!method accessing!public! !
model!accessing!public! !
model:!initialize/release!public! !
name!accessing!public! !
name:!accessing!public! !
nearestRealClass!accessing!private! !
newMethods!accessing!public! !
nonMetaclass!accessing!public! !
parseTreeFor:!method accessing!public! !
primaryInstance!accessing!public! !
printOn:!printing!public! !
privateInstanceVariableNames!accessing!private! !
protocolsFor:!accessing!public! !
realClass!accessing!public! !
realClass:!accessing!public! !
removedMethods!accessing!public! !
removeInstanceVariable:!public!variable accessing! !
removeMethod:!method accessing!public! !
removeSubclass:!accessing!public! !
renameInstanceVariable:to:around:!public!variable accessing! !
selectors!method accessing!public! !
setName:!initializing!private! !
soleInstance!accessing!public! !
sourceCodeFor:!method accessing!public! !
storeOn:!printing!public! !
subclasses!accessing!public! !
subclassRedefines:!public!testing! !
superclass!accessing!public! !
superclass:!accessing!private! !
typeOfClassVariable:!public!variable accessing! !
unqualifiedName!accessing!public! !
whichMethodsReferToSymbol:!method accessing!public! !
whichSelectorsReferToClass:!method accessing!public! !
whichSelectorsReferToClassVariable:!method accessing!public! !
whichSelectorsReferToInstanceVariable:!method accessing!public! !
whoDefinesClassVariable:!public!variable accessing! !
whoDefinesInstanceVariable:!public!variable accessing! !
whoDefinesMethod:!method accessing!public! !
withAllSubclasses!accessing!public! !
withAllSuperclasses!accessing!public! !
withAllSuperclassesDo:!accessing!public! !
!

!Refactory.Browser.RBAbstractClass class methodsFor!

existing: aBehavior
	^self subclassResponsibility!

existingNamed: aSymbol 
	^(self named: aSymbol)
		realName: aSymbol;
		yourself!

initialize
	LookupSuperclass := Object new!

named: aSymbol
	^self basicNew
		setName: aSymbol;
		yourself!

new
	"RBClasses must always be #named:"

	^self shouldNotImplement! !
!Refactory.Browser.RBAbstractClass class categoriesForMethods!
existing:!instance creation!public! !
existingNamed:!instance creation!public! !
initialize!class initialization!public! !
named:!instance creation!public! !
new!instance creation!public! !
!

