"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.RBAbstractClass subclass: #'Refactory.Browser.RBClass'
	instanceVariableNames: 'metaclass unqualifiedName classVariableNames imports category classConstants comment environment'
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

addClassConstant: anAssociation
	self classConstants add: anAssociation.
	model addClassConstant: anAssociation to: self!

addClassVariable: aString 
	self classVariableNames add: aString.
	model addClassVariable: aString to: self!

addImport: aString
	| ref |
	ref := aString asQualifiedReference.
	imports := self imports copyWith: ref.
	model addImport: ref to: self!

allClassVariableNames
	| sprClass |
	sprClass := self superclass.
	^sprClass isNil
		ifTrue: [self classVariableNames]
		ifFalse: [sprClass allClassVariableNames , self classVariableNames]!

allImports
	^self superclass ifNil: [self imports] ifNotNil: [:sprClass | sprClass allImports , self imports]!

category
	^category isNil 
		ifTrue: [model environment whichCategoryIncludes: self name]
		ifFalse: [category]!

category: aSymbol 
	category := aSymbol!

classBindingNames
	^self classVariableNames , (self classConstants collect: [:each | each key])!

classConstants
	classConstants
		ifNil: [self classConstants: (self isDefined ifTrue: [self realClass classConstants] ifFalse: [#()])].
	^classConstants!

classConstants: aCollectionOfVariableBindings
	classConstants := aCollectionOfVariableBindings asOrderedCollection!

classVariableNames
	(classVariableNames isNil and: [self isDefined])
		ifTrue: [self classVariableNames: self realClass classBindingNames].
	^classVariableNames!

classVariableNames: aCollectionOfStrings 
	classVariableNames := aCollectionOfStrings asOrderedCollection!

comment
	^comment == LookupComment
		ifTrue: [comment := self isDefined ifTrue: [self realClass comment]]
		ifFalse: [comment]!

comment: aString
	model comment: (comment := aString) in: self!

definitionString
	| definitionStream |
	definitionStream := (String writeStream: 256)
				locale: SmalltalkLocale.Hex;
				yourself.
	self printDefinitionOn: definitionStream.
	^definitionStream contents!

directlyDefinesClassVariable: aString
	^self classVariableNames includes: aString!

directlyImportsNamespace: aString
	"Namespace imports must always be absolute binding references, but they may be private, so we just compare the paths"

	^self imports anySatisfy: [:each | each pathString = aString]!

environment
	^environment ifNil: [environment := model classNamed: self environmentName]!

fullyQualifiedReference
	^BindingReference pathString: name!

getImports
	#rbFix.	"Dolphin stores the pool names in its classes, rather than the pools themselves."
	^self realClass imports
	"sharedPools collect: [:each | Smalltalk keyAtValue: each]"!

imports
	imports ifNil: [imports := self isDefined ifTrue: [self realClass imports] ifFalse: [#()]].
	^imports!

imports: aCollectionOfStrings
	imports := (aCollectionOfStrings collect: [:each | each asQualifiedReference]) asArray!

includesEnvironment: aClass
	"Answer whether the receiver includes the namespace argument (i.e. is it nested within it somewhere in its environment chain)."

	^self == aClass or: [self environment includesEnvironment: aClass]
!

includesNamespace: aClass
	"Answer whether the receiver includes the namespace argument (i.e. is it a sub-namespace, or is it nested within it somewhere in its environment chain)."

	^self == aClass or: [(self inheritsFrom: aClass) or: [self environment includesEnvironment: aClass]]!

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

	^self realClass localBindingFor: aString!

metaclass
	^metaclass!

metaclass: aRBMetaclass
	metaclass := aRBMetaclass!

name: aString
	super name: aString.
	unqualifiedName := environment := nil!

newBindingContextForIdentifier: aString
	^Kernel.BindingContext
		methodClass: self
		environment: self environment
		identifier: aString!

nonMetaclass
	^self!

printDefinitionOn: puttableStream
	| constants |
	puttableStream
		nextPutAll: self superclass name;
		space;
		nextPutAll: self kindOfSubclass;
		space;
		print: self name;
		crtab;
		nextPutAll: 'instanceVariableNames: '''.
	self instanceVariableNames do: [:each | puttableStream nextPutAll: each]
		separatedBy: [puttableStream space].
	puttableStream
		nextPut: $';
		crtab;
		nextPutAll: 'classVariableNames: '''.
	self classVariableNames do: [:each | puttableStream nextPutAll: each]
		separatedBy: [puttableStream space].
	puttableStream
		nextPut: $';
		crtab;
		nextPutAll: 'imports: ';
		print: self imports;
		crtab;
		nextPutAll: 'classInstanceVariableNames: '''.
	self metaclass instanceVariableNames do: [:each | puttableStream nextPutAll: each]
		separatedBy: [puttableStream space].
	puttableStream
		nextPut: $';
		crtab;
		nextPutAll: 'classConstants: {'.
	constants := self classConstants.
	constants isEmpty
		ifFalse: 
			[constants do: 
					[:each |
					puttableStream
						crtab: 2;
						print: each]
				separatedBy: [puttableStream nextPut: $.].
			puttableStream crtab].
	puttableStream nextPut: $}!

realName: aSymbol 
	self realClass: aSymbol asQualifiedReference value!

removeClassConstant: anAssociation
	| binding |
	binding := self classConstants remove: anAssociation.
	model removeClassConstant: binding from: self!

removeClassVariable: aString
	self classVariableNames remove: aString ifAbsent: [self classConstants remove: aString].
	model removeClassVariable: aString from: self!

removeImport: aString
	| ref |
	ref := aString asQualifiedReference.
	imports := self imports copyWithout: ref.
	model removeImport: ref from: self!

renameClassVariable: oldName to: newName around: aBlock
	| varNames |
	varNames := self classVariableNames.
	varNames at: (varNames indexOf: oldName) put: newName.
	model
		renameClassVariable: oldName
		to: newName
		in: self
		around: aBlock!

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
	^aBindingContext environment
		ifNotNil: [:env | env resolveImportedBinding: aBindingContext]!

resolveLocallyImportedBinding: aBindingContext
	"Private - Search the directly imported namespaces for a binding that matches the identifier in the <BindingContext> argument."

	1 to: self imports size
		do: 
			[:i |
			| each |
			each := imports at: i.
			(aBindingContext visitImport: each from: self)
				ifNotNil: [:namespace | ((model classFor: namespace) resolvePublicBinding: aBindingContext) ifNotNil: [:binding | ^binding]]].
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

	#namespaceToDo.	"Private variables"
	^(self bindingFor: aString)
		ifNil: [self resolveImportedBinding: (self newBindingContextForIdentifier: aString)]!

setName: aSymbol 
	name := aSymbol.
	comment := LookupComment!

unqualifiedName
	"Answer the fully-qualified name of the non-metaclass."

	^unqualifiedName ifNil: [unqualifiedName := ($. split: name) last asSymbol]! !
!Refactory.Browser.RBClass categoriesFor: #<=!public! !
!Refactory.Browser.RBClass categoriesFor: #addClassConstant:!public!variable accessing! !
!Refactory.Browser.RBClass categoriesFor: #addClassVariable:!public!variable accessing! !
!Refactory.Browser.RBClass categoriesFor: #addImport:!namespaces!public! !
!Refactory.Browser.RBClass categoriesFor: #allClassVariableNames!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #allImports!namespaces!public! !
!Refactory.Browser.RBClass categoriesFor: #category!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #category:!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #classBindingNames!public! !
!Refactory.Browser.RBClass categoriesFor: #classConstants!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #classConstants:!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #classVariableNames!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #classVariableNames:!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #comment!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #comment:!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #definitionString!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #directlyDefinesClassVariable:!public!testing! !
!Refactory.Browser.RBClass categoriesFor: #directlyImportsNamespace:!public!testing! !
!Refactory.Browser.RBClass categoriesFor: #environment!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #fullyQualifiedReference!accessing!namespaces!public! !
!Refactory.Browser.RBClass categoriesFor: #getImports!helpers!private! !
!Refactory.Browser.RBClass categoriesFor: #imports!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #imports:!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #includesEnvironment:!namespaces!private!testing! !
!Refactory.Browser.RBClass categoriesFor: #includesNamespace:!private!testing! !
!Refactory.Browser.RBClass categoriesFor: #isMeta!public!testing! !
!Refactory.Browser.RBClass categoriesFor: #kindOfSubclass!class hierarchy-testing!private! !
!Refactory.Browser.RBClass categoriesFor: #localBindingFor:!bindings!public! !
!Refactory.Browser.RBClass categoriesFor: #metaclass!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #metaclass:!initializing!private! !
!Refactory.Browser.RBClass categoriesFor: #name:!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #newBindingContextForIdentifier:!bindings!private! !
!Refactory.Browser.RBClass categoriesFor: #nonMetaclass!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #printDefinitionOn:!accessing!public! !
!Refactory.Browser.RBClass categoriesFor: #realName:!initialize/release!public! !
!Refactory.Browser.RBClass categoriesFor: #removeClassConstant:!public!variable accessing! !
!Refactory.Browser.RBClass categoriesFor: #removeClassVariable:!public!variable accessing! !
!Refactory.Browser.RBClass categoriesFor: #removeImport:!public!variable accessing! !
!Refactory.Browser.RBClass categoriesFor: #renameClassVariable:to:around:!public!variable accessing! !
!Refactory.Browser.RBClass categoriesFor: #resolveBindingPath:!bindings!private! !
!Refactory.Browser.RBClass categoriesFor: #resolveImportedBinding:!bindings!private! !
!Refactory.Browser.RBClass categoriesFor: #resolveLocallyImportedBinding:!bindings!private! !
!Refactory.Browser.RBClass categoriesFor: #resolvePathString:!bindings!private! !
!Refactory.Browser.RBClass categoriesFor: #resolvePublicBinding:!bindings!private! !
!Refactory.Browser.RBClass categoriesFor: #resolveUnqualifiedName:!bindings!private! !
!Refactory.Browser.RBClass categoriesFor: #setName:!initializing!private! !
!Refactory.Browser.RBClass categoriesFor: #unqualifiedName!public! !

!Refactory.Browser.RBClass class methodsFor!

existing: aBehavior
	| class |
	class := aBehavior instanceClass.
	^(self named: class fullName)
		realClass: class;
		yourself!

initialize
	LookupComment := Object new! !
!Refactory.Browser.RBClass class categoriesFor: #existing:!instance creation!public! !
!Refactory.Browser.RBClass class categoriesFor: #initialize!class initialization!public! !

