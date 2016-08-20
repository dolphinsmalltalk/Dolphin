"Filed out from Dolphin Smalltalk 7"!

Behavior subclass: #ClassDescription
	instanceVariableNames: 'instanceVariables methodsCatalogue protocols'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassDescription guid: (GUID fromString: '{87B4C4FA-026E-11D3-9FD7-00A0CC3E4A32}')!
ClassDescription comment: 'ClassDescription is an abstract class which adds descriptive information such as instance variable names and method categories to Behavior. This additional state and behaviour is generally not required or used by the VM, but is important for the development environment, the compiler in particular.

Instance Variables:
	instanceVariables		<String>. A space separated list of instance variable names.
	methodsCatalogue		<IdentityDictionary> mapping <MethodCategory>s to <Array>s of <Symbol>
	protocols			<Set> of <MethodProtocol>s implemented by (sub-)instances.'!
!ClassDescription categoriesForClass!Kernel-Classes! !
!ClassDescription methodsFor!

<= aClassDescription
	"Answer whether the receiver is 'less than' aClassDescription.
	By implementing this method, we enable Class objects to be stored
	in a SortedCollection with the default sort block."

	^self name <= aClassDescription name!

>> aSymbol
	^self compiledMethodAt: aSymbol!

addInstVarName: aString
	"Add a new instance variable to the receiver with the specified <readableString> name."

	| newClass |
	newClass := (ClassBuilder forModifying: self)
				instanceVariables: (self instVarNames copyWith: aString);
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
	self allSubclassesDo: [:q | q removeProtocol: protName ifAbsent: []]!

addSharedPool: aPoolDictionary
	"Add the argument, aPoolDictionary, as one of the pool dictionaries referenced by the
	receiver, but lower in precedence than any previously added pools. It is an error if the
	dictionary is already one of the pools.
	Note: This is a low-level operation and does not recompile affected classes. Generally 
	speaking any modification to a class should be made through a <ClassBuilder>."

	| poolName pools |
	poolName := aPoolDictionary name.
	pools := self sharedPoolNames.
	(pools includes: poolName) ifTrue: [^self error: 'Pool is already referenced by this class'].
	self setSharedPoolNames: (pools copyWith: poolName)!

allGetters
	"Private - Answer a <Set> of the instance variable getter methods in the receiver"

	^self withAllSuperclasses inject: Set new
		into: 
			[:getters :each | 
			getters addAll: each getters.
			getters]!

allProtocols
	"Answer a <collection> of all the <MethodProtocol>s implemented by the receiver's
	instances, including those inherited from superclasses."

	| answer |
	answer := IdentitySet new.
	self withAllSuperclassesDo: [ :c | answer addAll: c protocols].
	^answer!

canUnderstandProtocol: protName
	"Answer whether the receiver can understand the named <MethodProtocol>,
	even if it does not necessarily claim to implement it. See also #conformsToProtocol:"

	| protocol |
	protocol := self methodProtocolClass name: protName asSymbol.
	^protocol selectors allSatisfy: [:s | self canUnderstand: s]!

categoriesFor: selector 
	"Answer a chunk reader which will include the selector in
	each of the method category names to be read in.
	If the receiver doesn't actually include the selector, then just stream 
	over the categories and ignore them"

	^(self compiledMethodAt: selector ifAbsent: []) 
		ifNil: [ChunkReader null]
		ifNotNil: 
			[:method | 
			| categories |
			categories := OrderedCollection new.
			ChunkReader do: [:chunk | categories addLast: (self methodCategoryClass name: chunk)]
				atEnd: 
					[method categories: categories.
					method storeCategories]]!

categoriesFor: selector are: categories
	"Compatibility ith IBM Smalltalk fileIn format (which is of the form
	<class> categoriesFor: <selector> are: #([<categoryString>]*).
	Sets the additional categories of a selector if it exists."

	(self includesSelector: selector) ifTrue: [
		categories do: [:categoryString |
			self 
				includeSelector: selector 
				inCategory: (self methodCategoryClass name: categoryString)]]
!

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

	| answer catClass unclassified aSelector |
	catClass := self methodCategoryClass.
	unclassified := catClass unclassified.
	aSelector := aCompiledMethod selector.
	answer := self whichNonVirtualCategoriesIncludeSelector: aSelector.
	answer isEmpty ifTrue: [answer add: catClass unclassified].
	catClass pseudoCategories do: 
			[:each | 
			(each ~~ unclassified and: [each includesMethod: aCompiledMethod]) 
				ifTrue: [answer add: each]].
	answer add: aCompiledMethod privacyCategory.
	^answer!

classCategoryClass
	"Private - Answer the class of object used to categorize classes.
	Answer nil if the category system is not present."

	^Smalltalk at: #ClassCategory ifAbsent: []!

classPool
	"Answer the dictionary of class variables."

	^self subclassResponsibility!

classVariableString
	"Answer a space separated string of the names of the receiver's class variables"

	| aStream |
	aStream := String writeStream: 40.
	self classPool keys asSortedCollection 
		do: [ :key | aStream nextPutAll: key]
		separatedBy: [aStream space].
	^aStream contents!

comment
	"Answer the class comment for the receiver"

	^self subclassResponsibility!

comment: aString
	"Set the class comment for the receiver to aString"

	^self subclassResponsibility!

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

	| method result |
	result := self basicCompile: aString flags: anInteger.
	result notNil 
		ifTrue: 
			[| allCats |
			result package: aPackageOrNil.
			allCats := categories.
			method := result method.
			(allCats anySatisfy: [:c | c isPrivacy]) 
				ifFalse: 
					[(self suggestedPrivacyFor: method) 
						ifNotNil: 
							[:privacy | 
							allCats := (OrderedCollection
										withAll: categories)
										addLast: privacy;
										yourself]].
			"To avoid generating a recategorization event we eschew CompiledMethod>>categories:"
			self methodCategoryClass setMethod: method categories: allCats.
			method storeCategories.
			"Now we can safely trigger #methodAdded/Updated: since the source and categories are now available"
			result fireSystemUpdateEvent].
	^method!

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

	| method result |
	result := self basicCompile: codeString.
	result notNil 
		ifTrue: 
			[| category |
			method := result method.
			category := self methodCategoryClass name: categoryString asString.
			result isNew 
				ifTrue: [category addMethodSilently: method]
				ifFalse: [category addMethod: method].
			method storeCategories.
			result fireSystemUpdateEvent].
	^method!

conformsToProtocol: protocol
	"Answer whether the receiver conforms to the named <MethodProtocol>."

	| protName |
	protName := protocol asSymbol.
	^(protocols notNil and: [protocols includes: protName]) or: [
		superclass notNil and: [superclass conformsToProtocol: protName]]
!

copy: selector from: class
	"Copy the method with the selector <Symbol>, selector, in <ClassDescription>, 
	class, to the receiver's method dictionary, maintaining any existing categories.
	If a compile error occurs then a CompilerNotification is signalled. 
	Answers the new method or nil."

	^self copy: selector from: class categories: (class compiledMethodAt: selector) categories

!

copy: aSymbol from: aClass categories: aCollection 
	"Copy the method with the specified selector <Symbol>, in the <Behavior>, aClass, to the
	receiver's method dictionary, classifying it in each of the the <Collection> of
	<methodCategory>s specified by the last argument. If a compile error occurs then a
	CompilerNotification is signalled. Answers the new method or nil."

	| method |
	method := aClass compiledMethodAt: aSymbol.
	^self 
		compile: method getSource
		categories: aCollection
		package: method owningPackageIfLoose!

copy: aSymbol from: aClass classified: aString 
	"Copy the method with the specified selector <Symbol>, in the <Behavior>, aClass, to the
	receiver's method dictionary, adding it to the category identified by the final <String>
	argument."

	"This method is primarily present for Smalltalk-80 compatibility, but differs in that as
	Dolphin supports multiple categories, the existing method classifications are retained and
	'cat' is treated as a new classification. The method is recompiled in its new class. If a
	compile error occurs then a CompilerNotification is signalled. Answers the new method or
	nil."

	| categories |
	categories := (aClass compiledMethodAt: aSymbol) categories.
	categories add: (self methodCategoryClass name: aString asString).
	^self 
		copy: aSymbol
		from: aClass
		categories: categories!

copyAll: selectors from: class
	"Copy each of the methods with selectors in the <Collection> of <Symbol>s,
	selectors, from the <Behavior>, class, to the receiver's method dictionary, 
	maintaining the methods current categories.
	Answers whether all of the methods copied successfully."

	^selectors allSatisfy: [:selector | (self copy: selector from: class) notNil]!

copyAll: selectors from: class classified: cat
	"Copy each of the methods with selectors in the <Collection> of <Symbol>s,
	selectors, from the <Behavior>, class, to the receiver's method dictionary, 
	adding the new methods to the category with <readableString> name, cat,
	as well as the methods current categories.
	Answers whether all of the methods copied successfully."

	^selectors allSatisfy: [:selector | 
		(self copy: selector from: class classified: cat) notNil]!

copyAllCategoriesFrom: class
	"Copy all categories of method from the <Behavior>, class, to the receiver.
	Answers whether all of the methods copied successfully."
	
	^class selectors allSatisfy: [:selector | (self copy: selector from: class) notNil]!

copyCategory: category from: aClass
	"Copy all methods of the <ClassDescription> class, in the <MethodCategory>
	named by the <readableString>, category, to the receiver. Answers whether all 
	of the methods copied successfully."

	| cat |
	cat := self methodCategoryClass name: category asString.
	^(cat methodsInBehavior: self) 
		allSatisfy: [:m | (self copy: m selector from: aClass classified: cat) notNil]!

copyCategory: category from: aClass classified: newCategory
	"Copy all methods of the <ClassDescription> class, in the <MethodCategory>
	named by the <readableString>, category, to the receiver. Answers whether all 
	of the methods copied successfully. The methods are additionally classified
	under the <MethodCategory> named by the <readableString>, newCategory."

	| cat |
	cat := self methodCategoryClass name: category asString.
	^(cat methodsInBehavior: self) 
			allSatisfy: [:m | (self copy: m selector from: aClass classified: newCategory) notNil]!

defaultIcon
	"Answer a suitable default icon to use for this class. Not all classes use their 
	default icon; one must define an appropriate #icon method in each class where the 
	icon required differs from that of the superclass."

	^(self environment at: #Icon) fromId: self defaultIconName.

	!

defaultIconFrom: anExternalResourceLibrary
	"Answer a suitable default icon to use for this class. If anExternalResourceLibrary
	is, for some reason not open, then use the icon for the Object class."

	anExternalResourceLibrary asParameter isNull
		ifTrue: [^Object defaultIcon].
	^(self environment at: #Icon) fromId: self defaultIconName in: anExternalResourceLibrary.

	!

defaultIconName
	"Answer a filename to use for an icon of this class."

	^File composeStem: self name extension: 'ico'.!

defaultResourceIcon
	"Answer a suitable default icon resource to use for this class. Note that this method differs
	from #defaultIcon in that it uses the #resourceLocator of the class to locate the icon file"

	^(self environment at: #Icon) fromId: self defaultResourceIconName.

	!

defaultResourceIconName
	"Answer a filename to use for an icon of this class loaded from the class resources location."

	^self instanceClass resourcesLocator localFileSpecFor: self defaultIconName!

definition
	"Answer the <readableString> definition message, which, when evaluated, will define the
	receiver."

	| strm |
	strm := String writeStream: 256.
	self printDefinitionOn: strm.
	^strm contents!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: self name
!

getters
	"Private - Answer a <Set> of the instance variable getter methods in the receiver"

	^self methodDictionary values select: [:each | each isGetter]!

includesCategory: category
	"Answer whether the receiver includes the named category."

	^self methodsCatalogue includesKey: (self methodCategoryClass name: category)!

includeSelector: aSelector inCategory: category 
	"Add aSelector to aCategoryString while leaving it in its existing set of categories."

	| catalogue selectors |
	self assert: [category isKindOf: self methodCategoryClass].

	"Ensure a methods catalogue entry exists for the requested category"
	catalogue := self methodsCatalogue.
	(self includesCategory: category) ifFalse: [catalogue at: category put: Array new].

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
	index := self instVarNames indexOf: aString.
	^index == 0
		ifTrue: 
			[superclass
				ifNil: [aNiladicValuable value]
				ifNotNil: [superclass indexOfInstVar: aString ifAbsent: aNiladicValuable]]
		ifFalse: [index + (superclass ifNil: [0] ifNotNil: [superclass instSize])]!

instanceClass
	"Answer the receiver's singleton instance (the actual class object)."

	^self subclassResponsibility!

instanceVariableString
	"Answer a string containing the names of the instance variables in instances of the
	receiver, in the order they appear in those instances. The names are separated by spaces."

	| aStream |
	instanceVariables isNil ifTrue: [^''].
	instanceVariables isString ifTrue: [^instanceVariables].
	aStream := String writeStream: 64.
	instanceVariables 
		do: [:instVarName | aStream nextPutAll: instVarName]
		separatedBy: [aStream space].
	^aStream contents!

instanceVariableString: aString
	"Private - Set the receiver's instanceVariables inst var to the <String> argument."

	instanceVariables := (aString notNil and: [aString notEmpty]) ifTrue: [aString]!

instVarNames
	"Answer a <sequencedReadableCollection> of the receiver's instance variable 
	names."

	instanceVariables isNil ifTrue: [^#()].
	^instanceVariables isString
		ifTrue: 
			["N.B. This assumes that the names in the instance variable string are separated by exactly one space"
			instanceVariables subStrings: Character space]
		ifFalse: [instanceVariables]!

logDefinition
	self sourceManager logEvaluate: self definition!

logRemoveSelector: aSymbol 
	self sourceManager 
		logEvaluate: self name , ' removeSelector: ' , aSymbol printString , ' ifAbsent: []'!

logRemoveSelectors: aCollection 
	| stream |
	stream := String writeStream: 128.
	stream
		print: self;
		space;
		display: #removeSelectors:;
		nextPutAll: ' #('.
	aCollection do: [:each | stream print: each] separatedBy: [stream space].
	stream nextPut: $).
	self sourceManager logEvaluate: stream contents!

methodCategories
	"Answer a <collection> of all the <methodCategory>s in which 
	the receiver's methods are classified."

	^(self realMethodCategories)
		addAll: self methodCategoryClass pseudoCategories;
		yourself!

methodCategoryClass
	"Private - Answer the class of object used to categorize methods in the receiver.
	Implementation Note: This method cannot be stripped because it is required for
	compilation, but we want to allow the class to be stripped, and so answer a
	DeafObject if it has been."

	^Smalltalk at: #MethodCategory ifAbsent: [DeafObject current]!

methodChanged: aCompiledMethod
	"Private - Flag the receiver as changed or not changed, according to the value 
	of the <Boolean> argument. If the receiver is marked as changed, then
	its owning package (if any) is also so marked."

	self instanceClass methodChanged: aCompiledMethod!

methodProtocol: protocolName attributes: attributes selectors: selectors
	"Instantiate and install the MethodProtocol named by the <Symbol>, protocolName,
	with the attributes named in the <Array> of <Symbol>s, attributes, with the selectors 
	in the <Array> of <Symbol>s selectors."

	
	(self methodProtocolClass name: protocolName)
		attributes: attributes;
		addAllSelectors: selectors;
		addClass: self!

methodProtocolClass
	"Private - Answer the class of object used to represent method protocols for the receiver."

	^Smalltalk at: #MethodProtocol!

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

	methodsCatalogue := (mapOrNil notNil and: [mapOrNil notEmpty])
							ifTrue: [mapOrNil]
!

methodsFor
	"Answer a chunk reader to read and compile method chunks for the receiver.
	New methods are classified into the default category (''unclassified'')."

	^ChunkReader 
		do: [:chunkString | self compile: chunkString]
		inContext: self
		atEnd: []!

owningPackage
	^self instanceClass owningPackage!

printDefinitionOn: target
	"Private - Append the textual definition of the receiver to the <puttableStream>, target."

	^self subclassResponsibility!

printOn: aStream
	"Append the name of the receiver to aStream."

	aStream nextPutAll: self name.
!

protocolNames
	"Private - Answer a <collection> of <Symbol>s, being the names of the
	<MethodProtocol>s  implemented directly by the receiver's instances (i.e. 
	excluding inherited protocols)."

	^protocols ifNil: [IdentitySet new]!

protocols
	"Private - Answer the <collection> of <MethodProtocol>s  implemented 
	directly by the receiver's instances (i.e. excluding inherited protocols)."

	^protocols isNil
		ifTrue: [IdentitySet new]
		ifFalse: [ | mpc |
			mpc := self methodProtocolClass.
			protocols collect: [:p | mpc name: p]]!

protocols: anIdentitySetOrNil
	"Private - Set the protocols collection to anIdentitySetOrNil"

	protocols := anIdentitySetOrNil
!

realMethodCategories
	"Answer a <collection> of all the <methodCategory>s in which 
	the receiver's methods are classified, but excluding pseudo-categories.
	Note, though, that public/private categories are included since
	these are not 'calculated' as such, but based on a flag in the method header."

	| catClass |
	catClass := self methodCategoryClass.
	^self methodsCatalogue keys
		add: catClass public;
		add: catClass private;
		yourself!

recompileAllReferencesToVarNamed: aString
	"Private - Recompile any methods in the receiver's hierarchy which appear to reference the
	named variable."

	self instanceClass withAllSubclassesDo: 
			[:each |
			each recompileReferencesToVarNamed: aString.
			each class recompileReferencesToVarNamed: aString]!

removeCategory: category
	"Remove the Category from the receiver. N.B. All the methods belonging to the
	category are removed even if the method belongs to any other categories.
	In other words this removes a category of methods, not just the category."

	self removeSelectors: (((self methodCategoryClass name: category asString) methodsInBehavior: self) 
						collect: [:method | method selector])!

removeInstVarName: aString
	"Remove the instance variable of the receiver with the specified <readableString> name."

	| newClass |
	newClass := (ClassBuilder forModifying: self)
				instanceVariables: (self instVarNames copyWithout: aString);
				modifyExistingClass.
	newClass notNil ifTrue: [	newClass notNil ifTrue: [newClass logDefinition]].
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

	protocols isNil ifTrue: [^exceptionHandler value].
	protocols remove: protocol asSymbol ifAbsent: [^exceptionHandler value].
	protocols isEmpty ifTrue: [protocols := nil]!

removeSelector: aSelector fromCategory: category 
	"Private - Remove aSelector from aCategory. If no selectors are associated with
	aCategory as the outcome of this, then aCategory is removed"

	| catalogue |
	catalogue := self methodsCatalogue.
	(catalogue at: category ifAbsent: []) ifNotNil: 
			[:selectors | 
			| sels |
			(selectors identityIncludes: aSelector) ifFalse: [^self].
			sels := catalogue at: category put: (selectors copyWithout: aSelector).
			sels isEmpty ifTrue: [catalogue removeKey: category].
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

removeSharedPool: aPoolDictionary
	"Remove the argument, aPoolDictionary, as one of the receiver's pool dictionaries. 
	Note: This is a low-level operation and does not recompile affected classes. Generally 
	speaking any modification to a class should be made through a <ClassBuilder>."

	self setSharedPoolNames: (self sharedPoolNames copyWithout: aPoolDictionary name)!

removeUnsupportedProtocols: superUnsupported selector: removedSelector
	"Private - Remove any protocols that are no longer supported after the removal
	of the <selector>, removedSelector, from the receiver. Any removed protocols still 
	supported by subclasses are migrated down."

	| unsupported |
	unsupported := self protocols select: [:p | p includesSelector: removedSelector].
	unsupported do: [:p | p removeClass: self].
	unsupported addAll: superUnsupported.
	self subclasses do: [:s |
		"If the subclass has its own implementation for the selector, then it can still
		 support the protocol, otherwise it might need to remove further protocols"
		(s canUnderstand: removedSelector)
			ifTrue: [unsupported do: [:p | p addClass: s]]
			ifFalse: [s removeUnsupportedProtocols: unsupported selector: removedSelector]]!

renameInstVar: oldString to: newString
	"Private - Rename the instance variable of the receiver named by the <readableString>, oldString, to be
	named by the <readableString>, newString. The variable must be one of the receiver's own instance 
	variables , not of one of its superclasses.
	Note: This is a low-level operation that does not recompile any methods, however since the methods
	access instance variables by index they will remain valid until recompiled. It is the caller's responsibility
	to rewrite and recompile methods that reference the instance variable."

	self setInstanceVariables: (self instVarNames copyReplacing: oldString withObject: newString).
	self logDefinition.
	self environment classUpdated: self!

resourceIdentifierClass
	^Smalltalk at: #ResourceIdentifier!

resourceIdentifiers
	^self resourceSelectors collect: [:each | self resourceIdentifierClass class: self selector: each]!

resourceNames
	^(self resourceSelectors collect: [:each | self resourceIdentifierClass nameFromSelector: each]) 
		asSortedCollection!

resources
	^self resourceIdentifiers collect: [:each | each resource]!

resourceSelectors
	| answer |
	answer := IdentitySet new.
	self resourceSelectorsDo: [:each | answer add: each].
	^answer!

resourceSelectorsDo: aMonadicValuable 
	| prefix |
	prefix := self resourceIdentifierClass selectorPrefix.
	^self class methodDictionary 
		do: [:each | (each selector beginsWith: prefix) ifTrue: [aMonadicValuable value: each selector]]!

selectorsInCategory: category
	"Answer an <Collection> of selector <Symbol>s, of the receiver's methods 
	which are included in the <methodCategory>, category."

	^self methodsCatalogue at: category ifAbsent: [Array new]!

setInstanceVariables: aCollection
	"Private - Set the instance variable string of the receiver to be the list
	of names in aCollection, separated by spaces."

	instanceVariables := aCollection notEmpty ifTrue: [aCollection asArray]!

setSharedPoolNames: aCollection
	"Private - Set the <Symbol>ic names of the shared pool dictionaries that are declared as
	referenced locally in the receiver (pools are inherited in Dolphin)."

	self instanceClass setSharedPoolNames: aCollection
!

sharedPoolNames
	"Answer a <sequencedReadableCollection> of <Symbol>s, being the names of the shared pool
	dictionaries that are specified locally in the receiver (pools are inherited in Dolphin), in
	order of precedence."

	^self instanceClass sharedPoolNames!

sharedVariableString
	"Answer a String containing the names of the Pools accessable
	from the receiver and its instances. The names are separated
	by spaces."

	| aStream |
	aStream := String writeStream: 32.
	self sharedPoolNames asSortedCollection
		do: [:s | aStream nextPutAll: s]
		separatedBy: [aStream space].
	^aStream contents!

sourceManager
	"Answer the receiver's source manager. Answer a DeafObject if none is available."

	^(Smalltalk at: #SourceManager ifAbsent: []) 
		ifNil: [DeafObject current]
		ifNotNil: [:sm | sm default]!

stbReadFrom: anSTBInFiler format: anSTBClassConversion 
	"Read an instance of the receiver from the binary filer, aSTBInFiler. In most cases we can
	just bat this right back to the in-filer, and let it read its standard format from the
	stream. Custom format (or read routines) are useful where the standard STB format, and/or
	reader, is too inefficient in terms of space, or time, or both. It can also be used to avoid
	the need to create a proxy class; an example of this in D6 is the filing of symbols, which
	relegates the old STBSymbolProxy class to use only for reading older STB files."

	^anSTBInFiler readObjectOfClass: self format: anSTBClassConversion!

storeCategoriesOfMethod: aCompiledMethod
	aCompiledMethod storeCategories!

storeClassCategories
	"Private - Record the categories of the receiver to the change log.
	The job is simply delegated to the receiver's source manager (if available)."

	self sourceManager storeCategoriesForClass: self!

suggestedPrivacyFor: aCompiledMethod 
	| policy |
	policy := Smalltalk at: #MethodCategorizationPolicy ifAbsent: [].
	^policy notNil ifTrue: [policy default suggestedPrivacyFor: aCompiledMethod]!

whichCategoriesIncludeSelector: aSelector 
	"Private - Answer a <collection> of the 'real' (i.e. non-pseudo or virtual) categories in the 
	receiver's method catalogue which include the specified selector."

	| answer |
	answer := self whichNonVirtualCategoriesIncludeSelector: aSelector.
	"The privacy category is considered 'real' because it is not calculated but based on a flag in the method header."
	answer add: (self compiledMethodAt: aSelector) privacyCategory.
	^answer!

whichNonVirtualCategoriesIncludeSelector: aSelector 
	| answer |
	answer := IdentitySet new: 5.
	self methodsCatalogue keysAndValuesDo: 
			[:eachCategory :eachSelectors | 
			(eachSelectors identityIncludes: aSelector) ifTrue: [answer add: eachCategory]].
	^answer! !
!ClassDescription categoriesFor: #<=!comparing!public! !
!ClassDescription categoriesFor: #>>!accessing!public! !
!ClassDescription categoriesFor: #addInstVarName:!instance variables!public! !
!ClassDescription categoriesFor: #addProtocol:!private!protocols! !
!ClassDescription categoriesFor: #addSharedPool:!pool variables!public! !
!ClassDescription categoriesFor: #allGetters!accessing!private! !
!ClassDescription categoriesFor: #allProtocols!protocols!public! !
!ClassDescription categoriesFor: #canUnderstandProtocol:!methods-testing!public! !
!ClassDescription categoriesFor: #categoriesFor:!public!source filing-methods! !
!ClassDescription categoriesFor: #categoriesFor:are:!development!public!source filing-methods! !
!ClassDescription categoriesFor: #categoriesOfMethod:!categories-accessing!private! !
!ClassDescription categoriesFor: #classCategoryClass!constants!private! !
!ClassDescription categoriesFor: #classPool!class variables!public! !
!ClassDescription categoriesFor: #classVariableString!accessing!public! !
!ClassDescription categoriesFor: #comment!accessing!public! !
!ClassDescription categoriesFor: #comment:!accessing!public! !
!ClassDescription categoriesFor: #compile:categories:!compiling!development!public! !
!ClassDescription categoriesFor: #compile:categories:package:!compiling!development!public! !
!ClassDescription categoriesFor: #compile:categories:package:flags:!compiling!development!public! !
!ClassDescription categoriesFor: #compile:classified:!compiling!public! !
!ClassDescription categoriesFor: #conformsToProtocol:!protocols!public! !
!ClassDescription categoriesFor: #copy:from:!methods-copying!public! !
!ClassDescription categoriesFor: #copy:from:categories:!development!methods-copying!public! !
!ClassDescription categoriesFor: #copy:from:classified:!development!methods-copying!public! !
!ClassDescription categoriesFor: #copyAll:from:!methods-copying!public! !
!ClassDescription categoriesFor: #copyAll:from:classified:!methods-copying!public! !
!ClassDescription categoriesFor: #copyAllCategoriesFrom:!methods-copying!public! !
!ClassDescription categoriesFor: #copyCategory:from:!development!methods-copying!public! !
!ClassDescription categoriesFor: #copyCategory:from:classified:!development!methods-copying!public! !
!ClassDescription categoriesFor: #defaultIcon!constants!public! !
!ClassDescription categoriesFor: #defaultIconFrom:!constants!public! !
!ClassDescription categoriesFor: #defaultIconName!constants!public! !
!ClassDescription categoriesFor: #defaultResourceIcon!constants!public! !
!ClassDescription categoriesFor: #defaultResourceIconName!constants!public! !
!ClassDescription categoriesFor: #definition!development!public!source filing-class definition! !
!ClassDescription categoriesFor: #displayOn:!displaying!public! !
!ClassDescription categoriesFor: #getters!accessing!private! !
!ClassDescription categoriesFor: #includesCategory:!categories-testing!development!public! !
!ClassDescription categoriesFor: #includeSelector:inCategory:!categories-testing!development!public! !
!ClassDescription categoriesFor: #indexOfInstVar:!instance variables!public! !
!ClassDescription categoriesFor: #indexOfInstVar:ifAbsent:!instance variables!public! !
!ClassDescription categoriesFor: #instanceClass!accessing!public! !
!ClassDescription categoriesFor: #instanceVariableString!accessing!public! !
!ClassDescription categoriesFor: #instanceVariableString:!accessing!private! !
!ClassDescription categoriesFor: #instVarNames!instance variables!public! !
!ClassDescription categoriesFor: #logDefinition!instance variables!private! !
!ClassDescription categoriesFor: #logRemoveSelector:!helpers!private! !
!ClassDescription categoriesFor: #logRemoveSelectors:!helpers!private! !
!ClassDescription categoriesFor: #methodCategories!categories-accessing!public! !
!ClassDescription categoriesFor: #methodCategoryClass!constants!private! !
!ClassDescription categoriesFor: #methodChanged:!development!helpers!private! !
!ClassDescription categoriesFor: #methodProtocol:attributes:selectors:!development!public!source filing-methods! !
!ClassDescription categoriesFor: #methodProtocolClass!constants!private! !
!ClassDescription categoriesFor: #methods!public!source filing-methods! !
!ClassDescription categoriesFor: #methodsCatalogue!categories-accessing!private! !
!ClassDescription categoriesFor: #methodsCatalogue:!categories-accessing!private! !
!ClassDescription categoriesFor: #methodsFor!public!source filing-methods! !
!ClassDescription categoriesFor: #owningPackage!accessing!development!public! !
!ClassDescription categoriesFor: #printDefinitionOn:!development!private!source filing-class definition! !
!ClassDescription categoriesFor: #printOn:!printing!public! !
!ClassDescription categoriesFor: #protocolNames!private!protocols! !
!ClassDescription categoriesFor: #protocols!private!protocols! !
!ClassDescription categoriesFor: #protocols:!private!protocols! !
!ClassDescription categoriesFor: #realMethodCategories!categories-accessing!public! !
!ClassDescription categoriesFor: #recompileAllReferencesToVarNamed:!development!private! !
!ClassDescription categoriesFor: #removeCategory:!categories-removing!public! !
!ClassDescription categoriesFor: #removeInstVarName:!instance variables!public! !
!ClassDescription categoriesFor: #removeMethodFromNonVirtualCategories:!development!helpers!private! !
!ClassDescription categoriesFor: #removeProtocol:!private!protocols! !
!ClassDescription categoriesFor: #removeProtocol:ifAbsent:!private!protocols! !
!ClassDescription categoriesFor: #removeSelector:fromCategory:!categories-removing!private! !
!ClassDescription categoriesFor: #removeSelector:ifAbsent:!development!methods-removing!public! !
!ClassDescription categoriesFor: #removeSelectors:!development!methods-removing!public! !
!ClassDescription categoriesFor: #removeSharedPool:!pool variables!public! !
!ClassDescription categoriesFor: #removeUnsupportedProtocols:selector:!development!methods-removing!private!protocols! !
!ClassDescription categoriesFor: #renameInstVar:to:!instance variables!private! !
!ClassDescription categoriesFor: #resourceIdentifierClass!constants!private! !
!ClassDescription categoriesFor: #resourceIdentifiers!accessing!public! !
!ClassDescription categoriesFor: #resourceNames!accessing!public! !
!ClassDescription categoriesFor: #resources!accessing!public! !
!ClassDescription categoriesFor: #resourceSelectors!accessing!public! !
!ClassDescription categoriesFor: #resourceSelectorsDo:!enumerating!public! !
!ClassDescription categoriesFor: #selectorsInCategory:!categories-accessing!public! !
!ClassDescription categoriesFor: #setInstanceVariables:!instance variables!private! !
!ClassDescription categoriesFor: #setSharedPoolNames:!pool variables!private! !
!ClassDescription categoriesFor: #sharedPoolNames!pool variables!public! !
!ClassDescription categoriesFor: #sharedVariableString!accessing!public! !
!ClassDescription categoriesFor: #sourceManager!accessing!public! !
!ClassDescription categoriesFor: #stbReadFrom:format:!binary filing!public! !
!ClassDescription categoriesFor: #storeCategoriesOfMethod:!compiling!private! !
!ClassDescription categoriesFor: #storeClassCategories!private!source filing-methods! !
!ClassDescription categoriesFor: #suggestedPrivacyFor:!compiling!private! !
!ClassDescription categoriesFor: #whichCategoriesIncludeSelector:!categories-accessing!private! !
!ClassDescription categoriesFor: #whichNonVirtualCategoriesIncludeSelector:!categories-accessing!private! !

