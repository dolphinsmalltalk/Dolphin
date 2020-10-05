"Filed out from Dolphin Smalltalk 7"!

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
	self newMethods at: aRBMethod selector put: aRBMethod.
	removedMethods notNil 
		ifTrue: [removedMethods remove: aRBMethod selector ifAbsent: []]!

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

binding
	^self name asQualifiedReference binding!

bindingFor: aString
	^self realClass bindingFor: aString!

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

fullName
	^name!

fullyQualifiedReference
	^self subclassResponsibility!

hash
	^self name hash bitXor: self class hash!

hasRemoved: aSelector 
	^removedMethods notNil and: [removedMethods includes: aSelector]!

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
	^name!

name: aSymbol 
	name := aSymbol!

nearestRealClass
	#rbFix.	"Added"
	^self realClass isNil 
		ifTrue: [superclass notNil ifTrue: [superclass nearestRealClass]]
		ifFalse: [self realClass]!

newMethods
	^newMethods isNil ifTrue: [newMethods := IdentityDictionary new] ifFalse: [newMethods]!

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

shortName
	^name!

shortName: aString
	name := aString!

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
			[#namespaceToDo.	"Bodge to search for unqualified name symbols"
			selectors
				addAll: (self existingMethodsThatReferToAnyOf: {aRBClass binding.
								aRBClass name asSymbol.
								aRBClass unqualifiedName asSymbol})].
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
!Refactory.Browser.RBAbstractClass categoriesFor: #=!comparing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #addInstanceVariable:!public!variable accessing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #addMethod:!method accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #addSubclass:!private! !
!Refactory.Browser.RBAbstractClass categoriesFor: #allClassVariableNames!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #allImports!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #allInstanceVariableNames!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #allSelectors!method accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #allSubclasses!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #allSubclassesBreadthFirstDo:!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #allSuperclasses!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #allSuperclassesDo:!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #binding!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #bindingFor:!method accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #compile:!method accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #compile:classified:!method accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #compileTree:!method accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #compileTree:classified:!method accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #definesClassVariable:!public!testing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #definesInstanceVariable:!public!testing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #definesMethod:!public!testing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #definesVariable:!public!testing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #directlyDefinesClassVariable:!public!testing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #directlyDefinesInstanceVariable:!public!testing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #directlyDefinesMethod:!public!testing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #directlyDefinesVariable:!public!testing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #directlyImportsNamespace:!public!testing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #existingMethodsThatReferTo:!method accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #existingMethodsThatReferToAnyOf:!method accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #fullName!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #fullyQualifiedReference!private! !
!Refactory.Browser.RBAbstractClass categoriesFor: #hash!comparing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #hasRemoved:!public!testing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #hierarchyDefinesClassVariable:!public!testing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #hierarchyDefinesInstanceVariable:!public!testing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #hierarchyDefinesMethod:!public!testing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #hierarchyDefinesVariable:!public!testing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #hierarchyImportsNamespace:!public!testing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #importsNamespace:!public!testing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #includesClass:!public!testing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #inheritsPoolDictionaries!public!testing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #instanceClass!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #instanceVariableNames!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #instanceVariableNames:!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #isAbstract!public!testing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #isBytes!instance specification-testing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #isDefined!public!testing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #isMeta!public!testing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #isPointers!public!testing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #isVariable!public!testing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #metaclass!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #methodFor:!method accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #model!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #model:!initialize/release!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #name!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #name:!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #nearestRealClass!accessing!private! !
!Refactory.Browser.RBAbstractClass categoriesFor: #newMethods!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #nonMetaclass!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #parseTreeFor:!method accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #primaryInstance!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #printOn:!printing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #privateInstanceVariableNames!accessing!private! !
!Refactory.Browser.RBAbstractClass categoriesFor: #protocolsFor:!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #realClass!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #realClass:!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #removedMethods!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #removeInstanceVariable:!public!variable accessing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #removeMethod:!method accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #removeSubclass:!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #renameInstanceVariable:to:around:!public!variable accessing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #selectors!method accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #setName:!initializing!private! !
!Refactory.Browser.RBAbstractClass categoriesFor: #shortName!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #shortName:!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #soleInstance!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #sourceCodeFor:!method accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #storeOn:!printing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #subclasses!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #subclassRedefines:!public!testing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #superclass!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #superclass:!accessing!private! !
!Refactory.Browser.RBAbstractClass categoriesFor: #typeOfClassVariable:!public!variable accessing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #whichMethodsReferToSymbol:!method accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #whichSelectorsReferToClass:!method accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #whichSelectorsReferToClassVariable:!method accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #whichSelectorsReferToInstanceVariable:!method accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #whoDefinesClassVariable:!public!variable accessing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #whoDefinesInstanceVariable:!public!variable accessing! !
!Refactory.Browser.RBAbstractClass categoriesFor: #whoDefinesMethod:!method accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #withAllSubclasses!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #withAllSuperclasses!accessing!public! !
!Refactory.Browser.RBAbstractClass categoriesFor: #withAllSuperclassesDo:!accessing!public! !

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
!Refactory.Browser.RBAbstractClass class categoriesFor: #existing:!instance creation!public! !
!Refactory.Browser.RBAbstractClass class categoriesFor: #existingNamed:!instance creation!public! !
!Refactory.Browser.RBAbstractClass class categoriesFor: #initialize!class initialization!public! !
!Refactory.Browser.RBAbstractClass class categoriesFor: #named:!instance creation!public! !
!Refactory.Browser.RBAbstractClass class categoriesFor: #new!instance creation!public! !

