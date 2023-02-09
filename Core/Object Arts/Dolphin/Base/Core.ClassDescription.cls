"Filed out from Dolphin Smalltalk"!

Core.Behavior subclass: #'Core.ClassDescription'
	instanceVariableNames: 'instanceVariables methodsCatalogue protocols'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.ClassDescription guid: (Core.GUID fromString: '{87b4c4fa-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.ClassDescription isNonInstantiable: true!
Core.ClassDescription comment: 'ClassDescription is an abstract class which adds descriptive information such as instance variable names and method categories to Behavior. This additional state and behaviour is generally not required or used by the VM, but is important for the development environment, the compiler in particular.

Instance Variables:
	instanceVariables		<String>. A space separated list of instance variable names.
	methodsCatalogue		<IdentityDictionary> mapping <MethodCategory>s to <Array>s of <Symbol>
	protocols			<Set> of <MethodProtocol>s implemented by (sub-)instances.'!
!Core.ClassDescription categoriesForClass!Kernel-Classes! !
!Core.ClassDescription methodsFor!

<= aClassDescription
	"Answer whether the receiver should sort before the argument, e.g. in a SortedCollection using the default sort block. We use a case sensitive comparison for stability. The class name is the primary sort order, but for equal names the namespace is then used.
	This provides a stable order that is reasonable for working with unqualified names, and which is therefore useful for backwards compatibility, but it doesn't necessarily make sense for fully qualified names. Generally it is preferable to specify one's own sort order comparison rather than relying on the default."

	^self == aClassDescription or: 
			[| cmp |
			cmp := self name <==> aClassDescription name.
			cmp == 0 ifTrue: [self fullName <==> aClassDescription fullName <= 0] ifFalse: [cmp < 0]]!

<==> aClassDescription
	"Answer the receiver's <integer> collation order with respect to the <ClassDescription> argument, based on case-sensitive comparison of the class name."

	| cmp |
	cmp := self name <==> aClassDescription name.
	^cmp == 0 ifTrue: [self fullName <==> aClassDescription fullName] ifFalse: [cmp]!

<=> aClassDescription
	"Answer the receiver's <integer> collation order with respect to the <ClassDescription> argument, based on case-insensitive comparison of the class name."

	| cmp |
	cmp := self name <=> aClassDescription name.
	^cmp == 0 ifTrue: [self fullName <=> aClassDescription fullName] ifFalse: [cmp]!

>> aSymbol
	^self compiledMethodAt: aSymbol!

absoluteReference
	"Answer a <BindingReference> representing a path from Root to the receiver."

	^self subclassResponsibility!

addInstVarName: aString
	"Add a new instance variable to the receiver with the specified <readableString> name."

	| newClass |
	newClass := (ClassBuilder forModifying: self)
				instanceVariables: (self instanceVariableNames copyWith: aString asUtf8String);
				modifyExistingClass.
	newClass notNil ifTrue: [newClass logDefinition].
	^newClass!

addProtocol: protocol
	"Private - Add the specified method protocol to the list implemented by the receiver.
	Implementation Note: The protocols are stored by symbolic name in order not to
	require that the <MethodProtocol> objects be present at run-time. Note further
	that this method only adds the protocol to the list directly supported by this class,
	and should not be called directly or the integrity of the protocol will be impaired."

	| protName |
	protName := protocol asSymbol.
	protocols isNil ifTrue: [protocols := IdentitySet new].
	protocols add: protName.
	self allSubclassesDo: [:q | q removeProtocol: protName ifAbsent: nil]!

allClassVarNames
	"Answer a <Set> of the <readableString> names of the receiver's and the 
	receiver's superclasses' class variables."

	| answer |
	answer := Set new.
	self withAllSuperclassesDo: [:c | answer addAll: c classBindingNames].
	^answer!

allGettersDo: aMonadicAvaluable
	"Private - Evaluate the <monadicValuable> argument for each of the instance variable getter methods in the receiver."

	self withAllSuperclassesDo: 
			[:eachClass |
			eachClass
				methodsDo: [:eachMethod | eachMethod isGetter ifTrue: [aMonadicAvaluable value: eachMethod]]]!

allInstances
	"Answer an <Array> of all direct instances of the receiver."

	MemoryManager current collectGarbage.
	^self primAllInstances!

allMethodsDo: operation
	"Evaluate the monadic valuable, operation, for each and every method defined in the hierarchy rooted in the receiver."

	self withAllSubclassesDo: [:behavior | behavior methodsDo: operation]!

allProtocols
	"Answer a <collection> of all the <MethodProtocol>s implemented by the receiver's
	instances, including those inherited from superclasses."

	| answer |
	answer := IdentitySet new.
	self withAllSuperclassesDo: [:c | answer addAll: c protocols].
	^answer!

allSelectors
	"Answer a <Set> of <Symbol>s, being all the message selectors to which the receiver 
	is able to respond (this includes messages understood by superclasses)."

	| answer accumulate |
	answer := IdentitySet new.
	accumulate := [:s | answer add: s].
	self withAllSuperclassesDo: [:each | each understoodSelectorsDo: accumulate].
	^answer!

allSubclasses
	"Answer a <collection> of the receiver's subclasses in breadth-first order, with the immediate subclasses first. 
	Breadth-first traversal is slightly less efficient, but results in a more useful ordering (the standard does not specify the order). 

	N.B. The original Smalltalk-80 definition specified that this method should answer a Set, and the draft ANSI standard specifiesonly <collection>. The defacto standard (e.g. See IBM Common Base) is now an OrderedCollection, and we follow suit as this maintains the ordering, which is often useful."

	| answer |
	answer := OrderedCollection new.
	self allSubclassesBreadthFirstDo: [:each | answer addLast: each].
	^answer!

allSubclassesBreadthFirstDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument with each of the receiver's subclasses in breadth-first order. The standard #allSubclassesDo: method performs a depth-first traversal (which is quicker as it does not need to enumerate the subclasses collection twice).
	We also enumerate the subclasses in name order."

	| subbies size |
	subbies := self subclasses.
	size := subbies size.
	"~70% of classes are leaves"
	size == 0 ifTrue: [^self].
	"~40% of non-leaf classes have only one subclass"
	size > 1 ifTrue: [subbies := (subbies copyFrom: 1 to: size) sort].
	subbies do: aMonadicValuable.
	subbies do: [:each | each allSubclassesBreadthFirstDo: aMonadicValuable]!

allSubclassesDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the receiver's subclasses using a pre-order depth first traversal."

	self allSubclassesPreOrderDo: aMonadicValuable!

allSubclassesEndOrderDo: aMonadicValuable
	"Private - Evaluate the <monadicValuable> argument for each  of the receiver's subclasses, visiting the receiver AFTER its subclasses (i.e. an end-order traversal)."

	self subclassesDo: 
			[:each |
			each allSubclassesEndOrderDo: aMonadicValuable.
			aMonadicValuable value: each]!

allSubclassesPreOrderDo: aMonadicValuable
	"Private - Evaluate the <monadicValuable> argument for each of the receiver's subclasses, visiting the receiver before its subclasses (i.e. a pre-order traversal)."

	self subclassesDo: 
			[:each |
			aMonadicValuable value: each.
			each allSubclassesPreOrderDo: aMonadicValuable]!

allSubinstances
	"Answer an <Array> containing all instances of the receiver and its subclasses."

	MemoryManager current collectGarbage.
	^self primAllSubinstances!

asQualifiedReference
	"Answer a <BindingReference> to this class."

	^self fullyQualifiedReference!

baseEnvironment
	"Private - Answer the default environment for new subclasses of the receiver that the ClassBuilder should use when the provided subclass name is unqualified."

	^Smalltalk!

basicEnvironment
	"Answer the receiver's <Namespace>."

	^self subclassResponsibility!

bindingNames
	"Answer a Set of the names of all the bindings in the receiver. The answer will include constant names, if any."

	^self classPool keys!

bindings
	"Answer the receiver's localled defined <VariableBinding>s."

	^self classPool associations!

bindingsChanged
	BindingReference clearCachedBindings!

bindingsDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the receiver's localled defined <VariableBinding>s."

	self classPool associationsDo: aMonadicValuable!

canUnderstandProtocol: protName
	"Answer whether the receiver can understand the named <MethodProtocol>, even if it does not necessarily claim to implement it. See also #conformsToProtocol:"

	^(#{Kernel.MethodProtocol} value name: protName asSymbol) selectors
		allSatisfy: [:each | self canUnderstand: each]!

categoriesFor: selector
	"Answer a chunk reader which will include the selector in
	each of the method category names to be read in.
	If the receiver doesn't actually include the selector, then just stream 
	over the categories and ignore them"

	^(self compiledMethodAt: selector ifAbsent: nil)
		ifNil: [ChunkReader null]
		ifNotNil: 
			[:method |
			| categories |
			categories := OrderedCollection new.
			ChunkReader do: [:chunk :filer | categories addLast: chunk asMethodCategory]
				atEnd: 
					[method categories: categories.
					method storeCategories]]!

categoriesForMethods
	"Answer a chunk reader to read all the categories for the receiver's methods."

	^ChunkReader
		do: [:selector :filer | (self categoriesFor: selector asSymbol) fileInFrom: filer]
		inContext: self
		atEnd: []!

categoriesOfMethod: aCompiledMethod
	"Private - Answer a <Set> of all the <methodCategory> objects in the receiver
	of which the <CompiledMethod> (assumed to belong to the receiver), 
	method, is a member."

	"Implementation Note: There is a much simpler implementation for this method,
	but we want to avoid running the Unclassified category's inclusion test because
	it is slow and duplicates work we already have to do in enumerating the method
	catalogue. Performance is important as emitting the method categories constitutes
	a large proportion of file-out time. Unfortunately this optimized implementation
	does break encapsulation a little since it relies on the current implementation of
	the methods catalogue."

	"The simple implementation - about one third the speed
	^self methodCategories select: [:category | category includesMethod: method]"

	| answer unclassified aSelector |
	unclassified := MethodCategory unclassified.
	aSelector := aCompiledMethod selector.
	answer := self whichNonVirtualCategoriesIncludeSelector: aSelector.
	answer isEmpty ifTrue: [answer add: unclassified].
	MethodCategory pseudoCategories
		do: [:each | (each ~~ unclassified and: [each includesMethod: aCompiledMethod]) ifTrue: [answer add: each]].
	answer add: aCompiledMethod privacyCategory.
	^answer!

changeIndex
	^nil!

changeIndexValue: aBlock 
	"Ignored"!

classBindingNames
	"Answer a <Set> of <String>s, being the names of all the class variables of the receiver, including constants."

	^self subclassResponsibility!

classCategoryClass
	"Private - Answer the class of object used to categorize classes.
	Answer nil if the category system is not present."

	^#{ClassCategory} valueOrNil!

classPool
	"Answer the dictionary of class variables."

	^self subclassResponsibility!

classVariableNames
	"Answer a <collection> of <String>s, being the names of the receiver's class variables (not including class constants)."

	^self classVariables collect: [:each | each key]!

classVariables
	"Answer a <collection> of <VariableBindings>s, being the class variables of the receiver, but not including class constants."

	^self subclassResponsibility!

classVariableString
	"Answer a space separated string of the names of the receiver's class variables. Note for legacy reasons this will include class constant names too."

	^$\x20 join: self classPool keys asSortedArray!

comment
	"Answer the class comment for the receiver"

	^self subclassResponsibility!

comment: aString
	"Set the class comment for the receiver to aString"

	self subclassResponsibility!

compile: aString categories: aCollection
	"Compile the <readableString> argument, aString,  as source code in the context of the receiver
	and add the resulting method to the receiver's method dictionary, in the 
	categories in the <collection> of <MethodCategory>s.
	If the collection of categories does not include a privacy category, then the
	suggestion made by the default <MethodCategorizationPolicy> is chosen.
	If a compile error occurs then a <CompilerNotification> is signalled. 
	Answers the new method or nil if it failed to compile."

	^self 
		compile: aString
		categories: aCollection
		package: nil!

compile: aString categories: categories package: aPackageOrNil 
	"Compile the <readableString> argument, aString, as source code in the context of the
	receiver with the default compilation flags, and add the resulting method to the receiver's
	method dictionary, in the <collection> of <MethodCategory>s, categories. A #methodAdded: or
	#methodUpdated: event (depending on whether the resulting method is new or replaces an
	existing method) is fired with the <CompilationResult> as its argument. Note that a
	#methodCategorized: event will not be generated, even if the set of categories of a
	pre-existing method are changed, because all the necessary information is available with a
	#methodUpdated: event. If the collection of categories does not include a privacy category,
	then the suggestion made by the default MethodCategorizationPolicy is chosen. If a compile
	error occurs then a <CompilerNotification> is signalled. Answers the new method or nil."

	^self 
		compile: aString
		categories: categories
		package: aPackageOrNil
		flags: self defaultCompilationFlags!

compile: aString categories: categories package: aPackageOrNil flags: anInteger
	"Compile the <readableString> argument, aString, as source code in the context of the
	receiver with the specified compilation flags, and add the resulting method to the
	receiver's method dictionary, in the <collection> of <MethodCategory>s, categories. A
	#methodAdded: or #methodUpdated: event (depending on whether the resulting method is new or
	replaces an existing method) is fired with the <CompilationResult> as its argument. Note
	that a #methodCategorized: event will not be generated, even if the set of categories of a
	pre-existing method are changed, because all the necessary information is available with a
	#methodUpdated: event. If the collection of categories does not include a privacy category,
	then the suggestion made by the default MethodCategorizationPolicy is chosen. If a compile
	error occurs then a <CompilerNotification> is signalled. Answers the new method or nil."

	^self compile: aString environment: self environment categories: categories package: aPackageOrNil flags: anInteger!

compile: codeString classified: categoryString
	"Compile the argument, code, as source code in the context of the receiver
	and add the resulting method to the receiver's method dictionary.
	The newly compiled method is added to the category identified by the <readableString>,
	cat. If the new method replaces an existing one then the original categorization is maintained.
	If a compile error occurs then a CompilerNotification is signalled. 
	Answers the new method or nil if the compilation failed.
	N.B. This method is present primarily as part of the original ST-80 ClassDescription
	protocol, but is of limited use in a multi-category system like Dolphin. We recommend that
	#compile:categories: be used in preference."

	^(self basicCompile: codeString environment: self environment)
		ifNotNil: 
			[:result |
			| method |
			method := result method.
			result isNew
				ifTrue: [categoryString asMethodCategory addMethodSilently: method]
				ifFalse: [categoryString asMethodCategory addMethod: method].
			method storeCategories.
			result fireSystemUpdateEvent.
			method]!

compile: aString environment: aNamespaceOrNil categories: categories package: aPackageOrNil 
	"Compile the <readableString> argument, aString, as source code in the context of the
	receiver with the default compilation flags, and add the resulting method to the receiver's
	method dictionary, in the <collection> of <MethodCategory>s, categories. A #methodAdded: or
	#methodUpdated: event (depending on whether the resulting method is new or replaces an
	existing method) is fired with the <CompilationResult> as its argument. Note that a
	#methodCategorized: event will not be generated, even if the set of categories of a
	pre-existing method are changed, because all the necessary information is available with a
	#methodUpdated: event. If the collection of categories does not include a privacy category,
	then the suggestion made by the default MethodCategorizationPolicy is chosen. If a compile
	error occurs then a <CompilerNotification> is signalled. Answers the new method or nil."

	^self 
		compile: aString
		environment: aNamespaceOrNil
		categories: categories
		package: aPackageOrNil
		flags: self defaultCompilationFlags!

compile: aString environment: aNamespaceOrNil categories: categories package: aPackageOrNil flags: anInteger
	"Compile the <readableString> argument, aString, as source code in the context of the
	receiver with the specified compilation flags, and add the resulting method to the
	receiver's method dictionary, in the <collection> of <MethodCategory>s, categories. A
	#methodAdded: or #methodUpdated: event (depending on whether the resulting method is new or
	replaces an existing method) is fired with the <CompilationResult> as its argument. Note
	that a #methodCategorized: event will not be generated, even if the set of categories of a
	pre-existing method are changed, because all the necessary information is available with a
	#methodUpdated: event. If the collection of categories does not include a privacy category,
	then the suggestion made by the default MethodCategorizationPolicy is chosen. If a compile
	error occurs then a <CompilerNotification> is signalled. Answers the new method or nil."

	^(self
		basicCompile: aString
		flags: anInteger
		environment: aNamespaceOrNil)
			ifNotNil: 
				[:result |
				| allCats method |
				result package: aPackageOrNil.
				allCats := categories collect: [:each | each asMethodCategory].
				method := result method.
				(allCats anySatisfy: [:c | c isPrivacy])
					ifFalse: 
						[(self suggestedPrivacyFor: method)
							ifNotNil: [:privacy | allCats := allCats asArray copyWith: privacy]].
				"To avoid generating a recategorization event we eschew CompiledMethod>>categories:"
				MethodCategory setMethod: method categories: allCats.
				method storeCategories.
				"Now we can safely trigger #methodAdded/Updated: since the source and categories are now available"
				result fireSystemUpdateEvent.
				method]!

compileAllSubclasses
	"Compile all the methods in the receiver's subclasses' method dictionaries."

	self allSubclassesDo: [:each | each compileAll]!

conformsToProtocol: protocol
	"Answer whether the receiver conforms to the named <MethodProtocol>."

	| protName |
	protName := protocol asSymbol.
	^(protocols notNil and: [protocols includes: protName]) or: [
		superclass notNil and: [superclass conformsToProtocol: protName]]
!

definedBindings
	"Private - Answer a <collection> of the receiver's <VariableBinding>s that are defined as part of the receiver's class definition (as opposed to externally).
	For most classes this is all the class variables, including constants. For namespaces, this does not include any of the classes in the namespace as these are added to the namespace implicitly as part of their own definition."

	^self bindings select: [:each | each isClassVariable]!

definition
	"Answer the <readableString> definition message, which, when evaluated, will define the
	receiver."

	| strm |
	strm := (WriteStream on: (Utf8String new: 256))
				locale: SmalltalkLocale.Hex;
				yourself.
	self printDefinitionOn: strm.
	^strm contents!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	self printFullNameOn: aPuttableStream!

fullBindingFor: aString
	"Answer a variable binding for the named variable in the scope of this class, and failing that in the receiver's environment. If there is no such variable, then answer nil."

	^self instanceClass fullBindingFor: aString environment: self environment!

fullBindingFor: aString environment: aNamespace
	"Answer a variable binding for the named variable in the scope of this class, and failing that in the specified environment (or the receiver's environment if aNamespace is nil). If there is no such variable, then answer nil."

	^self subclassResponsibility!

fullName
	"Answer the <String> fully qualified name of the receiver, which is a dot-separated path that binds to the receiver from the global namespace, Root.
	Note that these names will also be bindable within the legacy Smalltalk namespace, because it is itself an immediate child of root, and so any of its siblings is bindable using that sibling's unqualified name."

	^'a subclass of ' , superclass fullName!

fullyQualifiedReference
	"Answer a <BindingReference> that represents a fully qualified reference to the receiver relative to Smalltalk. If the Class is not in the hierarchy below Smalltalk (i.e. it is in Root, or another namespace hierarchy under Root), then it will be an absolute binding reference."

	^self subclassResponsibility!

globalScope
	"Answer the <Namespace> to use as the binding root for fully-qualified names in the receiver."

	^Smalltalk
!

hasCompilationFailures
	"Answer whether any of the methods in the receiver or any of its subclasses have previously failed to compile."

	^(self methodDictionary anySatisfy: [:each | each isCompilationFailure])
		or: [self subclasses anySatisfy: [:each | each hasCompilationFailures]]!

hierarchyBindingFor: aString
	"Answer a variable binding for the named variable in the scope of this class, i.e. one of its own class variables or those of its superclasses. The imported namespaces and enclosing environment are not searched. If there is no such variable defined in the hierarchy answer nil."

	^(self localBindingFor: aString) ifNil: [super hierarchyBindingFor: aString]!

imports
	"Answer a <sequencedReadableCollection> of the <Namespaces> imported into the receiver's scope."

	^self subclassResponsibility!

includesCategory: category
	"Answer whether the receiver includes the named category."

	^methodsCatalogue notNil and: [methodsCatalogue includesKey: category asMethodCategory]!

includeSelector: aSelector inCategory: categoryObject
	"Add aSelector to aCategoryString while leaving it in its existing set of categories."

	| category catalogue selectors |
	category := categoryObject asMethodCategory.

	"Ensure a methods catalogue entry exists for the requested category"
	catalogue := self methodsCatalogue.
	(self includesCategory: category) ifFalse: [catalogue at: category put: {}].

	"Now add to the category if not already present therein"
	((selectors := catalogue at: category) identityIncludes: aSelector)
		ifFalse: [catalogue at: category put: (selectors copyWith: aSelector)].
	self methodsCatalogue: catalogue!

indexOfInstVar: aString
	"Answer the index of the specified inst. var in the receiver, or
	if no matching instance variable, raise a NotFoundError."

	^self indexOfInstVar: aString ifAbsent: [self errorNotFound: aString]!

indexOfInstVar: aString ifAbsent: aNiladicValuable
	"Answer the <integer> index of the inst. var of the receiver identified by the
	<readableString> name, aString, or if no matching instance variable, the result of
	evaluating the <niladicValuable>, aNiladicValuable."

	| index |
	index := self instanceVariableNames indexOf: aString asString.
	^index == 0
		ifTrue: 
			[superclass
				ifNil: [aNiladicValuable value]
				ifNotNil: [superclass indexOfInstVar: aString ifAbsent: aNiladicValuable]]
		ifFalse: [index + (superclass ifNil: [0] ifNotNil: [superclass instSize])]!

instanceClass
	"Answer the receiver's singleton instance (the actual class object)."

	^self subclassResponsibility!

instanceVariableNames
	"Answer a <sequencedReadableCollection> of the receiver's instance variable names."

	instanceVariables ifNil: [^#()].
	^instanceVariables isString ifTrue: [instanceVariables subStrings] ifFalse: [instanceVariables]!

instanceVariableString
	"Answer a string containing the names of the instance variables in instances of the
	receiver, in the order they appear in those instances. The names are separated by spaces."

	instanceVariables isNil ifTrue: [^''].
	instanceVariables isString ifTrue: [^instanceVariables].
	^$\x20 join: instanceVariables!

instanceVariableString: aString
	"Private - Set the receiver's instanceVariables inst var to the <String> argument."

	instanceVariables := (aString notNil and: [aString notEmpty]) ifTrue: [aString]!

instVarName: anInteger
	"Answer the name of the receiver's instance variable with the specified index."

	| current ancestor |
	current := self.
	
	[ancestor := current superclass.
	ancestor isNil or: [anInteger > ancestor instSize]]
			whileFalse: [current := ancestor].
	^current instanceVariableNames at: anInteger - ancestor instSize!

isAnonymous
	"Answer whether this is an anonymous (unbound) class."

	^self subclassResponsibility!

isAtomic
	"Answer whether or not the receiver has a single unique instance for any individual value it
	can represent."

	"Each class is the singleton instance of a unique metaclass."

	^true!

isChanged
	"Answer true if the receiver or any of it's contents have been changed since
	their changed flag was last reset."

	^self changeIndex notNil!

isChanged: aBoolean
	"Flag the receiver as changed or not changed, according to the value 
	of the <Boolean> argument."

	"When not running in a development system, changes are not tracked"!

isInBaseEnvironment
	^self environment == self baseEnvironment!

localBindingFor: aString
	"Answer a variable binding for the named variable directly in the scope of this class, i.e. one of its own class variables. If there is no such class variable, then answer nil."

	^self subclassResponsibility!

localEnvironment
	"Private - Answer the enclosing <Namespace> scope."

	^self environment
!

localScope
	"Answer the nearest name scope."

	^self instanceClass
!

logDefinition
	self sourceManager logEvaluate: self definition!

logRemoveSelector: aSymbol 
	self sourceManager 
		logEvaluate: self name , ' removeSelector: ' , aSymbol fullPrintString , ' ifAbsent: []'!

logRemoveSelectors: aCollection
	| stream |
	stream := String smalltalkWriteStream: 128.
	stream
		print: self;
		space;
		display: #removeSelectors:;
		nextPutAll: ' #('.
	aCollection do: [:each | stream print: each] separatedBy: [stream space].
	stream nextPut: $).
	self sourceManager logEvaluate: stream contents!

metaclass
	"Answer the <Metaclass> of the Class/Metaclass pair."

	^self subclassResponsibility!

methodCategories
	"Answer a <collection> of all the <methodCategory>s in which 
	the receiver's methods are classified."

	^self realMethodCategories
		addAll: MethodCategory pseudoCategories;
		yourself!

methodChanged: aCompiledMethod
	"Private - Flag the receiver as changed or not changed, according to the value 
	of the <Boolean> argument. If the receiver is marked as changed, then
	its owning package (if any) is also so marked."

	"Ignored if the development system is not present."
!

methodProtocol: protocolName attributes: attributes selectors: selectors
	"Instantiate and install the MethodProtocol named by the <Symbol>, protocolName, with the attributes named in the <Array> of <Symbol>s, attributes, with the selectors in the <Array> of <Symbol>s selectors."

	"Note that this is primarily used as part of the chunk source format, e.g. in .cls files. It may not be sent in the image."

	(#{Kernel.MethodProtocol} value name: protocolName)
		attributes: attributes;
		addAllSelectors: selectors;
		addClass: self!

methods
	"For compatibility with Visual Smalltalk/Smalltalk Express
	 file out format (both bereft of categories)."

	^self methodsFor!

methodsCatalogue
	"Private - Answer an IdentityDictionary which stores Arrays of selectors
	keyed by category objects."

	^methodsCatalogue ifNil: [IdentityDictionary new]!

methodsCatalogue: mapOrNil
	"Private - Sets the methods catalogue to mapOrNil which stores Arrays of selectors
	keyed by category objects. If the map is empty, then it is reduced to nil to save space."

	methodsCatalogue := (mapOrNil notNil and: [mapOrNil notEmpty]) ifTrue: [mapOrNil]!

methodsFor
	"Answer a chunk reader to read and compile method chunks for the receiver.
	New methods are classified into the default category (''unclassified'')."

	^ChunkReader
		do: [:chunkString :filer | self compile: chunkString environment: filer environment]
		inContext: self
		atEnd: []!

name
	"Answer a <readableString> that is the name of the receiver."

	^'a subclass of ', self superclass name!

owningPackage
	^nil!

packageManager
	^self subclassResponsibility!

printDefinitionOn: puttableStream 
	"Private - Append the textual definition of the receiver to the <puttableStream> argument."

	puttableStream
		nextPutAll: self superclass fullName;
		space;
		nextPutAll: self kindOfSubclass;
		space;
		print: self fullName;
		crtab;
		nextPutAll: 'instanceVariableNames: ';
		print: self instanceVariableString;
		crtab;
		nextPutAll: 'classVariableNames: ';
		print: self classVariableString;
		crtab;
		nextPutAll: 'imports: ';
		print: self imports!

printFullNameOn: aPuttableStream
	self subclassResponsibility!

protocolNames
	"Private - Answer a <collection> of <Symbol>s, being the names of the
	<MethodProtocol>s  implemented directly by the receiver's instances (i.e. 
	excluding inherited protocols)."

	^protocols ifNil: [##(IdentitySet new)]!

protocols
	"Private - Answer the <collection> of <MethodProtocol>s  implemented directly by the receiver's instances (i.e. excluding inherited protocols)."

	^protocols
		ifNil: [##(IdentitySet new)]
		ifNotNil: 
			[| protocolClass |
			protocolClass := #{Kernel.MethodProtocol} value.
			protocols collect: [:each | protocolClass name: each]]!

protocols: anIdentitySetOrNil
	"Private - Set the protocols collection to anIdentitySetOrNil"

	protocols := anIdentitySetOrNil
!

realMethodCategories
	"Answer a <collection> of all the <methodCategory>s in which 
	the receiver's methods are classified, but excluding pseudo-categories.
	Note, though, that public/private categories are included since
	these are not 'calculated' as such, but based on a flag in the method header."

	^self methodsCatalogue keys
		add: 'public' asMethodCategory;
		add: 'private' asMethodCategory;
		yourself!

recompileAll
	"Recompile this class and all its subclasses. The methods are not logged to the change log, but the sources are re-used from the originals. N.B. In order to recompile all methods in the system it is necessary to avoid the process being interrupted or the system may crash.
	To achieve this evaluate an expression such as:
		[Object recompileAll] forkAt: Processor userInterruptPriority
	"

	self withAllSubclassesDo: 
			[:each |
			each class compileAll.
			each compileAll]!

recompileAllReferencesToLiteral: anObject
	"Private - Recompile any methods in the receiver's hierarchy that reference the specified object from their literal frame."

	self instanceClass withAllSubclassesDo: 
			[:each |
			each recompileReferencesToLiteral: anObject.
			each class recompileReferencesToLiteral: anObject]!

removeCategory: category
	"Remove the Category from the receiver. N.B. All the methods belonging to the
	category are removed even if the method belongs to any other categories.
	In other words this removes a category of methods, not just the category."

	self removeSelectors: ((category asMethodCategory methodsInBehavior: self)
				collect: [:method | method selector])!

removeImport: aBindingReference
	self setImports: (self imports copyWithout: aBindingReference)!

removeInstVarName: aString
	"Remove the instance variable of the receiver with the specified <readableString> name."

	| newClass |
	newClass := (ClassBuilder forModifying: self)
				instanceVariables: (self instanceVariableNames copyWithout: aString);
				modifyExistingClass.
	newClass notNil ifTrue: [newClass logDefinition].
	^newClass!

removeMethodFromNonVirtualCategories: aCompiledMethod 
	"Private - Remove the specified method (assumed to be of the receiver)
	from all the categories under which it is currently classified."

	(self whichNonVirtualCategoriesIncludeSelector: aCompiledMethod selector) 
		do: [:each | each removeMethodSilently: aCompiledMethod]!

removeProtocol: protocol
	"Private - Remove the specified method protocol from the list implemented by the receiver."

	self removeProtocol: protocol ifAbsent: [self protocols errorNotFound: protocol]!

removeProtocol: protocol ifAbsent: exceptionHandler
	"Private - Remove the specified method protocol from the list implemented by the receiver."

	(protocols isNil or: [(protocols remove: protocol asSymbol ifAbsent: nil) isNil])
		ifTrue: [^exceptionHandler value].
	protocols isEmpty ifTrue: [protocols := nil]!

removeSelector: aSymbol fromCategory: aMethodCategory
	"Private - Remove the selector, aSymbol, from the method category, aMethodCategory, in the receiver. If no selectors are associated with category as the outcome of this, then category is removed from the receiver's catalogue."

	| catalogue |
	catalogue := self methodsCatalogue.
	(catalogue lookup: aMethodCategory)
		ifNotNil: 
			[:selectors |
			| index count |
			index := selectors
						nextIdentityIndexOf: aSymbol
						from: 1
						to: (count := selectors size).
			index == 0 ifTrue: [^self].
			count == 1
				ifTrue: [catalogue removeKey: aMethodCategory]
				ifFalse: [catalogue at: aMethodCategory put: (selectors copyWithoutIndex: index)].
			self methodsCatalogue: catalogue]!

removeSelector: aSymbol ifAbsent: aBlock
	"Remove the method with selector, selector, from the receiver's method dictionary, answering
	the removed method. If it is not in the receiver's method dictionary, then answer the 
	result of evaluating aBlock."

	| method |
	method := super removeSelector: aSymbol ifAbsent: [^aBlock value].
	self logRemoveSelector: aSymbol.
	(self canUnderstand: aSymbol)
		ifFalse: [self removeUnsupportedProtocols: IdentitySet new selector: aSymbol].
	self removeMethodFromNonVirtualCategories: method.
	^method!

removeSelectors: aCollection
	"Remove each of the <Symbol> selectors in the <collection> argument from the receiver's
	message dictionary. If any of the selectors are not present, they are simply ignored. Answer
	a <collection> of the methods which were actually removed."

	| methods |
	methods := super removeSelectors: aCollection.
	self logRemoveSelectors: aCollection.
	aCollection do: 
			[:each |
			(self canUnderstand: each)
				ifFalse: [self removeUnsupportedProtocols: IdentitySet new selector: each]].
	methods do: [:each | self removeMethodFromNonVirtualCategories: each].
	^methods!

removeUnsupportedProtocols: aCollectionOfMethodProtocols selector: aSymbol
	"Private - Remove any protocols that are no longer supported after the removal of the <selector>, aSymbol, from the receiver. Any removed protocols still  supported by subclasses are migrated down."

	| unsupported |
	unsupported := self protocols select: [:each | each includesSelector: aSymbol].
	unsupported do: [:each | each removeClass: self].
	unsupported addAll: aCollectionOfMethodProtocols.
	self subclassesDo: 
			[:eachSubclass |
			"If the subclass has its own implementation for the selector, then it can still support the protocol, otherwise it might need to remove further protocols"
			(eachSubclass canUnderstand: aSymbol)
				ifTrue: [unsupported do: [:eachProtocol | eachProtocol addClass: eachSubclass]]
				ifFalse: [eachSubclass removeUnsupportedProtocols: unsupported selector: aSymbol]]!

resourceIdentifiers
	| identifiers |
	identifiers := OrderedCollection new.
	self resourceIdentifiersDo: [:each | identifiers addLast: each].
	^identifiers!

resourceIdentifiersDo: aMonadicValuable
	self metaclass selectorsDo: 
			[:each |
			(each beginsWith: UI.ResourceIdentifier.SelectorPrefix)
				ifTrue: [aMonadicValuable value: (UI.ResourceIdentifier newClass: self selector: each)]]!

resourceNames
	| names |
	names := Array writeStream.
	self resourceSelectorsDo: [:each | names nextPut: (UI.ResourceIdentifier nameFromSelector: each)].
	^names contents sort!

resources
	| resources |
	resources := OrderedCollection new.
	self resourceIdentifiersDo: [:each | resources addLast: each resource].
	^resources!

resourceSelectorsDo: aMonadicValuable
	self metaclass selectorsDo: 
			[:each |
			(each beginsWith: UI.ResourceIdentifier.SelectorPrefix) ifTrue: [aMonadicValuable value: each]]!

selectorsInCategory: category
	"Answer a <Collection> of selector <Symbol>s, of the receiver's methods which are included in the <methodCategory>, category."

	^methodsCatalogue ifNil: [#()] ifNotNil: [(methodsCatalogue lookup: category) ?? #()]!

setImports: anArray
	self subclassResponsibility!

setInstanceVariables: aCollection
	"Private - Set the instance variable string of the receiver to be the list
	of names in aCollection, separated by spaces."

	instanceVariables := aCollection isEmpty
				ifFalse: 
					[aCollection asArray
						isImmutable: true;
						yourself]!

setShapeFlags: anIntegerMask to: aBoolean
	"Private - Set/Reset the receiver's shape/structure flags (as defined by anIntegerMask)
	according to the argument aBoolean."

	| oldSpec |
	oldSpec := instanceSpec.
	super setShapeFlags: anIntegerMask to: aBoolean.
	oldSpec = instanceSpec ifFalse: [self isChanged: true]!

shortName
	"Answer the shorted <String> name of the receiver that is bindable from Smalltalk. i.e. for classes defined directly in Smalltalk, or in any of its imports, this will be an unqualified name. Otherwise it is the fully qualified name relative to Smalltalk."

	^self subclassResponsibility!

sourceFilerClass
	^ChunkSourceFiler!

sourceManager
	"Answer the receiver's source manager. Answer a DeafObject if none is available."

	^#{SourceManager} valueOrNil ifNil: [DeafObject current] ifNotNil: [:sm | sm default]!

stbReadFrom: anSTBInFiler format: anSTBClassConversion
	"Read an instance of the receiver from the binary filer, aSTBInFiler.
	Classes in D8 now override the new stbReadFrom:format:size: method, in order to avoid dealing with the complexities of the object size value. In older STB streams there is always a size. From STB v3, the size is only present for indexable classes (i.e. indexable pointer objects, variable byte objects). The filer still sends this message to the class being read for backwards compatibility."

	^self
		stbReadFrom: anSTBInFiler
		format: anSTBClassConversion
		size: (anSTBInFiler readSizeOf: self)!

stbReadFrom: anSTBInFiler format: anSTBClassConversion size: anInteger
	"Read an instance of the receiver from the binary filer, aSTBInFiler. In most cases we can just bat this right back to the in-filer, and let it read its standard format from the stream. Custom format (or read routines) are useful where the standard STB format, and/or reader, is too inefficient in terms of space, or time, or both. It can also be used to avoid the need to create a proxy class; an example of this is the filing of symbols, which relegates the old STBSymbolProxy class to use only for reading older STB files."

	^anSTBInFiler
		readObjectOfClass: self
		format: anSTBClassConversion
		size: anInteger!

storeClassCategories
	"Private - Record the categories of the receiver to the change log."

	"Ignored in the absence of the development system"!

storeOn: aStream
	"Append to the <puttableStream> argument an expression which when evaluated will answer the receiver."

	self printFullNameOn: aStream!

subclasses
	"Answer a <collection> containing the receiver's immediate subclasses."

	| stream |
	stream := WriteStream on: {}.
	self subclassesDo: [:each | stream nextPut: each].
	^stream contents!

subclassesDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the receiver's subclasses."

	self subclassResponsibility!

subclassInstVarNames
	"Answer a <Set> of the instance variable names specified in the receiver's subclasses"

	| answer |
	answer := Set new.
	self allSubclassesDo: [:each | answer addAll: each instanceVariableNames].
	^answer!

suggestedPrivacyFor: aCompiledMethod
	^#{Tools.MethodCategorizationPolicy}
		ifDefined: [:policy | policy default suggestedPrivacyFor: aCompiledMethod]!

unqualifiedName
	"Answer a <readableString> that is the name of the receiver in it's environment."

	^self subclassResponsibility!

variableAdded: aVariableBinding
	self bindingsChanged!

variableRemoved: aVariableBinding
	self bindingsChanged!

whichCategoriesIncludeSelector: aSelector
	"Private - Answer a <collection> of the 'real' (i.e. non-pseudo or virtual) categories in the 
	receiver's method catalogue which include the specified selector."

	| answer |
	answer := self whichNonVirtualCategoriesIncludeSelector: aSelector.
	"The privacy category is considered 'real' because it is not calculated but based on a flag in the method header."
	(self compiledMethodAt: aSelector ifAbsent: nil)
		ifNotNil: [:method | answer add: method privacyCategory].
	^answer!

whichClassDefinesClassVar: aString
	"Answer which <Class> in the receiver's inheritance chain, including the receiver,
	defines the named class variable."

	^self instanceClass whichClassSatisfies: [:each | each classBindingNames includes: aString]!

whichClassImplementsProtocol: aMethodProtocol
	"Answer which <Class> in the receiver's inheritance chain, including the receiver, implements the specified <MethodProtocol>."

	| protocolName |
	protocolName := aMethodProtocol asSymbol.
	self withAllSuperclassesDo: [:each | (each protocolNames includes: protocolName) ifTrue: [^each]].
	^nil!

whichNonVirtualCategoriesIncludeSelector: aSelector
	| answer |
	answer := IdentitySet new: 5.
	self methodsCatalogue
		keysAndValuesDo: [:eachCategory :eachSelectors | (eachSelectors identityIncludes: aSelector) ifTrue: [answer add: eachCategory]].
	^answer!

withAllSubclasses
	"Answer an <OrderedCollection> containing the receiver, and all of the receiver''s subclasses in breadth-first order, with the immediate subclasses first."

	^self allSubclasses
		addFirst: self;
		yourself!

withAllSubclassesDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for the receiver and each of its subclasses using a depth-first traversal."

	aMonadicValuable value: self.
	self allSubclassesDo: aMonadicValuable! !
!Core.ClassDescription categoriesForMethods!
<=!comparing!public! !
<==>!comparing!public! !
<=>!comparing!public! !
>>!accessing!public! !
absoluteReference!accessing!namespaces!public! !
addInstVarName:!class hierarchy-mutating!instance variables!public! !
addProtocol:!private!protocols! !
allClassVarNames!class variables!public! !
allGettersDo:!accessing!private! !
allInstances!instances!public! !
allMethodsDo:!enumerating!public! !
allProtocols!protocols!public! !
allSelectors!methods-accessing!public! !
allSubclasses!class hierarchy-accessing!public! !
allSubclassesBreadthFirstDo:!class hierarchy-accessing!enumerating!public! !
allSubclassesDo:!class hierarchy-accessing!enumerating!public! !
allSubclassesEndOrderDo:!class hierarchy-accessing!private! !
allSubclassesPreOrderDo:!class hierarchy-accessing!private! !
allSubinstances!instances!public! !
asQualifiedReference!converting!public! !
baseEnvironment!constants!private! !
basicEnvironment!accessing!public! !
bindingNames!bindings!public! !
bindings!accessing!public! !
bindingsChanged!adding!private! !
bindingsDo:!enumerating!public! !
canUnderstandProtocol:!methods-testing!public! !
categoriesFor:!public!source filing-methods! !
categoriesForMethods!public!source filing-methods! !
categoriesOfMethod:!categories-accessing!private! !
changeIndex!accessing!private! !
changeIndexValue:!accessing!private! !
classBindingNames!class variables!public! !
classCategoryClass!constants!private! !
classPool!class variables!public! !
classVariableNames!class variables!public! !
classVariables!class variables!public! !
classVariableString!accessing!public! !
comment!accessing!public! !
comment:!accessing!public! !
compile:categories:!compiling!development!public! !
compile:categories:package:!compiling!development!public! !
compile:categories:package:flags:!compiling!development!public! !
compile:classified:!compiling!public! !
compile:environment:categories:package:!compiling!development!public! !
compile:environment:categories:package:flags:!compiling!development!public! !
compileAllSubclasses!compiling!development!public! !
conformsToProtocol:!protocols!public! !
definedBindings!accessing!private! !
definition!public!source filing-class definition! !
displayOn:!displaying!public! !
fullBindingFor:!binding!public! !
fullBindingFor:environment:!binding!public! !
fullName!accessing!namespaces!public! !
fullyQualifiedReference!accessing!public! !
globalScope!accessing!public! !
hasCompilationFailures!public!testing! !
hierarchyBindingFor:!bindings!public! !
imports!pool variables!public! !
includesCategory:!categories-testing!public! !
includeSelector:inCategory:!categories-testing!public! !
indexOfInstVar:!instance variables!public! !
indexOfInstVar:ifAbsent:!instance variables!public! !
instanceClass!accessing!public! !
instanceVariableNames!instance variables!public! !
instanceVariableString!accessing!public! !
instanceVariableString:!accessing!private! !
instVarName:!accessing!public! !
isAnonymous!public!testing! !
isAtomic!public!testing! !
isChanged!public!source filing!testing! !
isChanged:!accessing!public! !
isInBaseEnvironment!private!testing! !
localBindingFor:!binding!public! !
localEnvironment!accessing!private! !
localScope!accessing!public! !
logDefinition!class hierarchy-mutating!instance variables!private! !
logRemoveSelector:!development!helpers!private! !
logRemoveSelectors:!development!helpers!private! !
metaclass!accessing!public! !
methodCategories!categories-accessing!public! !
methodChanged:!helpers!private! !
methodProtocol:attributes:selectors:!development!public!source filing-methods! !
methods!public!source filing-methods! !
methodsCatalogue!categories-accessing!private! !
methodsCatalogue:!categories-accessing!private! !
methodsFor!public!source filing-methods! !
name!accessing!public! !
owningPackage!accessing!public! !
packageManager!development!public!source filing! !
printDefinitionOn:!development!private!source filing-class definition! !
printFullNameOn:!helpers!private! !
protocolNames!private!protocols! !
protocols!private!protocols! !
protocols:!private!protocols! !
realMethodCategories!categories-accessing!public! !
recompileAll!compiling!development!public! !
recompileAllReferencesToLiteral:!development!private! !
removeCategory:!categories-removing!public! !
removeImport:!namespaces!public! !
removeInstVarName:!class hierarchy-mutating!instance variables!public! !
removeMethodFromNonVirtualCategories:!development!helpers!private! !
removeProtocol:!private!protocols! !
removeProtocol:ifAbsent:!private!protocols! !
removeSelector:fromCategory:!categories-removing!private! !
removeSelector:ifAbsent:!development!methods-removing!must strip!public! !
removeSelectors:!development!methods-removing!public! !
removeUnsupportedProtocols:selector:!development!methods-removing!private!protocols! !
resourceIdentifiers!accessing!public! !
resourceIdentifiersDo:!enumerating!public! !
resourceNames!accessing!public! !
resources!accessing!public! !
resourceSelectorsDo:!enumerating!public! !
selectorsInCategory:!categories-accessing!public! !
setImports:!accessing!private! !
setInstanceVariables:!instance variables!private! !
setShapeFlags:to:!class hierarchy-mutating!instance specification-accessing!private! !
shortName!accessing!public! !
sourceFilerClass!private!source filing-class definition! !
sourceManager!accessing!public! !
stbReadFrom:format:!binary filing!public! !
stbReadFrom:format:size:!binary filing!public! !
storeClassCategories!private!source filing-methods! !
storeOn:!printing!public! !
subclasses!class hierarchy-accessing!public! !
subclassesDo:!class hierarchy-accessing!public! !
subclassInstVarNames!instance variables!public! !
suggestedPrivacyFor:!compiling!private! !
unqualifiedName!accessing!public! !
variableAdded:!class variables!private! !
variableRemoved:!class variables!private! !
whichCategoriesIncludeSelector:!categories-accessing!private! !
whichClassDefinesClassVar:!class variables!public! !
whichClassImplementsProtocol:!class variables!public! !
whichNonVirtualCategoriesIncludeSelector:!categories-accessing!private! !
withAllSubclasses!class hierarchy-accessing!public! !
withAllSubclassesDo:!enumerating!public! !
!

Core.ClassDescription methodProtocol: #bindingScope attributes: #(#readOnly) selectors: #(#environment #fullBindingFor: #localScope)!
Core.ClassDescription methodProtocol: #classDescription attributes: #(#ansi #readOnly) selectors: #(#allSubclasses #allSuperclasses #name #subclasses #superclass)!
Core.ClassDescription methodProtocol: #'Object class' attributes: #(#ansi #readOnly) selectors: #(#allSubclasses #allSuperclasses #name #new #subclasses #superclass)!

