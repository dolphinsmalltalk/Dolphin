"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Kernel.ClassBuilder'
	instanceVariableNames: 'currentClass className instanceVariables superclass instanceSpec classVariables imports comment flags categories classConstants environment'
	classVariableNames: 'FixedInitialLayout FixedLayout Unsubclassable'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'IgnoreInstsMask' -> 16r2.
		'RecompileMask' -> 16r1
	}!
Kernel.ClassBuilder guid: (Core.GUID fromString: '{87b4c461-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.ClassBuilder comment: ''!
!Kernel.ClassBuilder categoriesForClass!System-Support! !
!Kernel.ClassBuilder methodsFor!

beBytes
	"Private - Set the class type to variable bytes."

	instanceSpec := self class instanceSpecWithVariableBytes: instanceSpec!

beFixed
	"Private - Set the class type to pointers containing named instance vars only."

	instanceSpec := self class instanceSpecWithFixedPointers: instanceSpec!

beIndirectBytes
	"Private - Set the class type to indirect bytes."

	instanceSpec := self class instanceSpecWithIndirectBytes!

beNullTerminatedBytes
	"Private - Set the class type to null-terminated variable bytes."

	instanceSpec := self class instanceSpecWithNullTerminatedBytes!

beVariable
	"Private - Set the class type to indexable pointers and named instance vars."

	instanceSpec := self class instanceSpecWithVariablePointers: instanceSpec!

canMutateInSitu
	"Private - Answer whether the class being modified can be changed without
	mutating its instances. Class only mutation is possible providing that the
	following remain unchanged:
		the instance spec,
		the instance variable layout and
		the class instance variable layout."

	self instanceShapeIsBeingChanged ifTrue: [^false].
	self superclassIsBeingChanged ifFalse: [^self instanceVariablesAreBeingChanged not].

	"The class is being moved."
	((self class allInstVarNamesOf: superclass) , self instanceVariables) = currentClass allInstVarNames
		ifFalse: [^false].
	(self class classOf: superclass) allInstVarNames = currentClass class superclass allInstVarNames
		ifFalse: [^false].
	^true!

categories
	categories isNil ifTrue: [self categoryNames: #('')].
	^categories!

categories: aCollectionOfClassCategories
	categories := aCollectionOfClassCategories!

categoryNames: aCollectionOfStrings
	self categories: (self classCategoryClass isNil 
				ifTrue: [#()]
				ifFalse: 
					[aCollectionOfStrings collect: [:each | self classCategoryClass name: each]])!

checkNoInstances
	| instCount |
	self ignoreInstances ifTrue: [^self].
	"Try first without a full GC to avoid hit if we can"
	instCount := currentClass primAllInstances size.
	instCount > 0
		ifTrue: 
			["Seem to be a few hangers on, so try with a GC"
			instCount := currentClass instanceCount].
	instCount > 0
		ifTrue: 
			["Oh dear still extant instances - raise an error"
			self errorInvalidRemove: (String writeStream
						print: self currentClass;
						nextPutAll: ' has ';
						display: instCount;
						nextPutAll: ' instances';
						contents)]!

checkNoSubclasses
	| subs |
	subs := currentClass subclasses.
	subs notEmpty
		ifTrue: 
			[self errorInvalidRemove: (String writeStream
						print: self currentClass;
						nextPutAll: ' has ';
						display: subs size;
						nextPutAll: ' subclasses';
						contents)]!

class: aClass
	"Private - Set the currentClass inst var to the class to be modified, aClass."

	currentClass := aClass.
	self instanceSpec: aClass instanceSpec.!

classCategoryClass
	^(superclass ifNil: [superclass class]) classCategoryClass!

classConstants
	^classConstants ?? #()!

classConstants: anArrayOfAssociations
	classConstants := anArrayOfAssociations!

className: aString
	"Private - Set the className inst var to aString."

	| path len |
	(className := aString) ifNil: [^self].
	path := $. split: aString.
	len := path size.
	len == 1
		ifTrue: 
			[className := aString asSymbol.
			environment := (superclass ifNil: [currentClass superclass]) baseEnvironment]
		ifFalse: 
			[className := (path at: len) asSymbol.
			environment := (BindingReference path: (path copyFrom: 1 to: len - 1) context: Root) value]!

classVariables
	"Private - Answer an Array of proposed class variable names."

	^classVariables ifNil: [{}]!

classVariables: aClassVarNamesArray
	"Set the receiver's classVariables inst var to aClassVarNamesArray."

	classVariables := aClassVarNamesArray asArray!

classVariableString: aClassVarNamesString
	"Set the receiver's proposed class variable list from aString."

	self classVariables: aClassVarNamesString subStrings!

comment: aString
	"Private - Set the comment to apply to the class being modified."

	comment := aString!

createNewClass
	"Private - Create, install and answer a new class from the details contained in the receiver."

	self
		validateForCreate;
		createProper;
		setNewClassCategories;
		generateGUID;
		installNewClass.
	^currentClass!

createProper
	"Private - Create a new class from the details contained in the receiver.
	First, create an instance of Metaclass then send this new instance a #new
	message to create its single instance class. Save the answer in the
	receiver's currentClass inst var."

	| metaSuperclass newMetaclass |
	metaSuperclass := self class classOf: superclass.
	(newMetaclass := Metaclass new)
		instanceSpec: metaSuperclass instanceSpec;
		superclass: metaSuperclass.
	(currentClass := newMetaclass new)
		instanceSpec: instanceSpec;
		superclass: superclass;
		setName: className environment: self environment;
		subclasses: #().

	"In order to sort the metaclass subclasses, we need the instance class name, so we
	leave addition to the superclass subclasses list until the instance class has been created."
	self installInSuperclass: currentClass.
	self
		setInstanceVariablesOf: currentClass;
		declareClassVariablesOf: currentClass;
		setImportsOf: currentClass;
		setCommentOf: currentClass!

currentClass
	"Answer the currentClass inst var."

	^currentClass!

declareClassVariablesOf: aClass
	| pool |
	pool := Dictionary new.
	classVariables do: 
			[:each |
			pool add: ((VariableBinding key: each value: nil)
						environment: aClass;
						isClassVariable: true;
						yourself)].
	self classConstants do: 
			[:each |
			pool add: ((VariableBinding key: each key value: each value)
						environment: aClass;
						isClassVariable: true;
						isConstant: true;
						yourself)].
	aClass basicClassPool: pool!

environment
	"Answer the environment (Namespace) for the class being created/modified.
	Usually this is deduced from a qualified class name. Note that the environment must exist for class creation to succeed."

	^environment!

environment: aNamespace
	"Set the environment of the class to the <Namespace> argument."

	environment := aNamespace!

errorInvalidRemove: messageText
	"Private - An error has occurred removing the receiver's current class. Raise an 
	appropriate exception."

	^self class invalidRemoveError
		signal: messageText
		with: self currentClass!

fundamentalTypeIsBeingChanged
	"Private - Answer whether the fundamental class type (ie. Pointers/Bytes, Indexed/Fixed)
	is being changed."

	^(self class fundamentalTypeOf: instanceSpec) ~~ (self class fundamentalTypeOf: currentClass instanceSpec)			!

generateGUID
	"Private - Generate a GUID for a new class and assign it to that class."

	currentClass setGuid: GUID newUnique!

generateInstanceSpecFor: aClass superclass: aSuperclass
	"Private - Answer an instance spec based on aClass, the information in the receiver
	and the proposed superclass aSuperclass."

	^aClass == currentClass
		ifTrue: [
			self class
				validateInstanceSpec: instanceSpec
				size: self instanceVariables size
				superclass: aSuperclass]
		ifFalse: [
			self class
				validateInstanceSpec: aClass instanceSpec
				size: aClass instVarNames size 
				superclass: aSuperclass].!

generateMapFrom: oldClass to: newClass
	"Private - Answer an array with an element corresponding to each named
	instance variables in newClass. The elements contain the index of the
	instance variable index of instances of oldClass that have the same
	name in newClass. If there is no match the element will be zero."

	| oldInstVarNamesArray |
	oldInstVarNamesArray := oldClass allInstVarNames.
	^newClass allInstVarNames collect: [:name | oldInstVarNamesArray indexOf: name]!

ignoreInstances
	"Private - Answer whether extant instances of a class should be ignored when validating it
	for removal."

	^flags allMask: IgnoreInstsMask!

ignoreInstances: aBoolean 
	"Private - Set whether extant instances of a class should be ignored when validating it
	for removal."

	flags := flags mask: IgnoreInstsMask set: aBoolean!

imports
	"Private - Answer an Array of proposed imports (BindingReferences to Namespaces)."

	^imports ?? #()!

imports: anArrayOfBindingReferences
	"Set the receiver's sharedPools from the pool name list aString.
	Any duplicate names in the list are dropped, but we must preserve the import order."

	| seen |
	seen := Set new.
	imports := anArrayOfBindingReferences select: [:each | seen addNewElement: each]!

initialize
	"Private - Initialize the instance."

	instanceSpec := 0.
	self beFixed.
	flags := 0.
	classVariables := #().
	environment := Smalltalk!

initializeCopy: aClassDescriptionCopy fromClass: aClass superclass: aSuperclass
	"Private - Adjust the invalid inst vars of aClassDescription. Its method
	dictionary should be a copy of that in aClass, its instanceSpec may
	require reconstruction, it should have no subclasses, it should be made
	a subclass of aSuperclass, it may require its instanceVariables inst var
	to be adjusted and should then be recompiled to correct any invalid
	references in the copied method dictionary.
	Answer the adjusted ClassDescription."

	| instSpec |
	instSpec := self generateInstanceSpecFor: aClass superclass: aSuperclass.
	aClassDescriptionCopy
		methodDictionary: aClass methodDictionary copy;
		instanceSpec: instSpec;
		superclass: aSuperclass;
		addToSuper.
	aClass == currentClass
		ifTrue: [self setInstanceVariablesOf: aClassDescriptionCopy].

	aClassDescriptionCopy compileAll.
	^aClassDescriptionCopy!

install: aClassDescription in: aNamespace
	"Private - Install aClassDescription into its environment."

	| binding |
	aClassDescription requiresInstallation ifFalse: [^self].
	binding := aNamespace localBindingFor: aClassDescription name.
	binding
		ifNil: 
			[binding := aNamespace declareVariable: aClassDescription name.
			binding isConstant: true].
	binding setValue: aClassDescription!

installInSuperclass: aClass
	aClass addToSuper!

installNewClass
	"Private - Install aClassDescription into its environment."

	self
		install: currentClass in: self environment;
		notifyClassCreated!

instanceShapeIsBeingChanged
	"Private - Answer whether the instance spec is being changed."

	^(instanceSpec bitAnd: Behavior._ShapeMask) ~= (currentClass instanceSpec bitAnd: Behavior._ShapeMask)
			!

instanceSpec: anInteger
	"Private - Set the instance specification flags of the receiver to anInteger."

	instanceSpec := anInteger!

instanceVariables
	"Private - Answer an Array of proposed instance variable names."

	^instanceVariables notNil
		ifTrue: [instanceVariables]
		ifFalse: [currentClass isNil ifTrue: [{}] ifFalse: [currentClass instVarNames]]!

instanceVariables: anInstVarNamesArray
	"Set the receiver's instanceVariables inst var to anInstVarNamesArray."

	instanceVariables := anInstVarNamesArray!

instanceVariablesAreBeingChanged
	"Private - Answer whether the instance variable layout is changing."

	^instanceVariables notNil and: [instanceVariables ~= currentClass instVarNames]!

instanceVariableString: anInstVarNamesString
	"Set the receiver's proposed instance variable list from aString."

	self instanceVariables: anInstVarNamesString subStrings!

isFixedInitialLayout
	"Answer whether the class being modified has a fixed initial layout."

	^FixedInitialLayout includes: currentClass!

isFixedLayout
	"Answer whether the class being modified is of fixed layout."

	^self class isFixedLayout: currentClass!

isFixedType
	"Answer whether the class being modified can be changed to be
	different type of subclass."

	^self isFixedLayout or: [self isFixedInitialLayout]!

isModifyAction
	"Private - Answer true if the combination of information provided to the receiver suggests that this is a class modification operation."

	currentClass isNil
		ifTrue: 
			[| binding |
			binding := (environment localBindingFor: className) ifNil: [^false].
			binding value class isMeta ifFalse: [^false].
			currentClass := binding value].
	^true!

modifyClassVariablesOf: aClass
	| removed classVars addedVariables originalNames newNames existingClassVariables |
	"If classConstants are not specified, then one of the legacy class creation messages has been used, in which case we can't distinguish between constants and variables."
	classConstants
		ifNil: 
			[| changed |
			changed := aClass setClassVarNames: self classVariables.
			changed
				ifTrue: 
					[self recompilationRequired: true
						reason: 'Recompilation of ' , aClass name , ' required because class variables are being changed'].
			^self].
	"We now segregate the class variables into those that are literal constants, and those that are not.
	First we want to determine if any of these bindings are being added or removed to give us a broad idea of whether there are changes
	that may require recompilation. We don't consider changes from constant to non-constant or vice versa at this point."
	classVars := aClass definedBindings.
	newNames := classVariables union: (classConstants collect: [:each | each key]).
	originalNames := classVars collect: [:each | each key].
	"If there are any additions or removals, then assume we need to recompile"
	removed := originalNames difference: newNames.
	removed notEmpty
		ifTrue: 
			[self recompilationRequired: true reason: 'Recompilation of ' , aClass name , ' required because class variables/constants are being removed'.
			removed do: [:each | aClass classPool removeKey: each].
			aClass classPool isEmpty ifTrue: [aClass basicClassPool: nil]].

	"Any completely new variables, we'll recompile the class"
	(newNames difference: originalNames) notEmpty
		ifTrue: 
			[Notification signal: 'Recompilation of ' , aClass name
						, ' required because class variables/constants are being added'.
			self recompilationRequired: true reason: String new].

	"Now add any new class variables, or those changing from constants to vars"
	existingClassVariables := classVars
				reject: [:each | each isImmutable and: [each value isSelfEvaluating]].
	addedVariables := classVariables difference: (existingClassVariables collect: [:each | each key]).
	addedVariables do: [:each | aClass addClassVarNamed: each].

	"Add all the constants:
		- existing constants with unchanged value will have no effect
		- existing constants with changed value may cause a recompile, but only if the new or old value had an immediate representation.
		- new constants will require a recompile.
	For constants with immediate (i.e. bytecode) representations the recompilation is across the entire image."
	classConstants do: [:each | aClass addClassConstant: each key value: each value]!

modifyExistingClass
	"Private - Modify and answer an existing class using the details
	contained in the receiver.
	Implementation Note: If the receiver is attempting to modify itself, then
	any direct accesses to instance variables following mutation may fail (if
	the instance variable set is changed, the compiled methods in the stack
	will still be referring to the old inst. var offsets), therefore we must use 
	inst. var accessors."

	self
		validateForModify;
		modifyProper;
		notifyClassUpdated.
	^self currentClass!

modifyImportsOf: aClass
	| newImports |
	newImports := self imports.
	newImports fullPrintString = aClass imports fullPrintString
		ifFalse: 
			[| reason |
			reason := 'Recompilation required to update imports of ' , aClass name , ' from :'
						, aClass imports fullPrintString , ', to:'
						, newImports fullPrintString.
			aClass imports: newImports.
			self recompilationRequired: true reason: reason]!

modifyOrCreate
	"Ascertain and execute the appropriate action depending on which pieces
	of information have been provided.
	If this is a class modify action we take this opportunity to maintain
	its NullTerm and Indirect flags as these are not specified in the
	standard class definition methods and would otherwise be lost."

	^self isModifyAction
		ifFalse: [self createNewClass]
		ifTrue: [
			instanceSpec := instanceSpec maskSet: (currentClass instanceSpec 
											maskClear: Behavior._FundamentalShapeMask).
			(self class instanceSpecIsBytes: instanceSpec)
				ifFalse: [instanceSpec := instanceSpec maskClear: Behavior._BytesSubMask].
			self modifyExistingClass]!

modifyProper
	"Private - Modify an existing class using the details contained in the receiver.
	Implementation Note: If the receiver is attempting to modify itself, then
	any direct accesses to instance variables following mutation may fail (if
	the instance variable set is changed, the compiled methods in the stack
	will still be referring to the old inst. var offsets), therefore we must use 
	inst. var accessors."

	| current |
	self requiresMutation
		ifTrue: [self canMutateInSitu ifTrue: [self mutateInSitu] ifFalse: [self mutateToNewClass]].

	"After this point, must not access inst vars directly in case mutated the receiver."
	current := self currentClass.
	current isMeta
		ifFalse: 
			[self
				modifyClassVariablesOf: current;
				modifyImportsOf: current;
				setCommentOf: current].
	self recompilationRequired ifTrue: [current recompileAll].
	self superclassIsBeingChanged ifTrue: [self removeUnimplementedProtocols]!

mutateClass: oldClass toBeASubclassOf: newSuperclass in: aNamespace
	"Private - Create a new class with the appropriate features and mutate	all instances of oldClass to new instances of the new class and then recursively make the same change to the subclasses of aClass. Finally, remove the oldClass and if appropriate its metaclass from their respective superclasses and do a #oneWayBeome: on oldClass to newClass.
	Implementation Note: We must not access any instance variables after mutation, in case the receiver is being mutated and the inst. var offsets change."

	| newClass mutatingClassItself |
	mutatingClassItself := oldClass == Class.
	newClass := self newClassLike: oldClass superclass: newSuperclass.
	self install: newClass in: aNamespace.
	self
		mutateInstances: oldClass primAllInstances
		of: oldClass
		toBeInstancesOf: newClass.
	mutatingClassItself
		ifTrue: 
			["In Dolphin Object class et al are not in the subclasses collection of Class, so need special case handling"
			Smalltalk allRoots do: 
					[:each |
					self
						mutateClass: each class
						toBeASubclassOf: newClass
						in: each class environment]]
		ifFalse: 
			[oldClass subclassesDo: 
					[:cls |
					self
						mutateClass: cls
						toBeASubclassOf: newClass
						in: cls environment]].
	oldClass class removeFromSuper.
	oldClass removeFromSuper.
	oldClass become: newClass.
	newClass oneWayBecome: oldClass.
	self updateVMRegistryWith: newClass!

mutateInSitu
	"Private - Mutate the class being modified without mutating its instances.
	We may need to change the superclass or instance variables.
	N.B. We cannot change instance variables without changing superclass, as this always requires a full mutation."

	self superclassIsBeingChanged
		ifTrue: 
			[| reason |
			reason := 'Recompilation required because of change of superclass from '
						, currentClass superclass name , ' to '
						, superclass name.
			currentClass class setSuperclass: (self class classOf: superclass).
			currentClass setSuperclass: superclass.
			self instanceVariablesAreBeingChanged ifTrue: [self setInstanceVariablesOf: currentClass].
			self recompilationRequired: true reason: reason]!

mutateInstances: anArray of: oldClass toBeInstancesOf: newClass
	"Private - Mutate the instances of oldClass in anArray to be instances of newClass."

	| mappingArray count |
	count := anArray size.
	count == 0 ifTrue: [^self].
	mappingArray := self generateMapFrom: oldClass to: newClass.
	1 to: count
		do: 
			[:i |
			| oldInst newInst |
			oldInst := anArray at: i.
			newInst := self
						translateInstance: oldInst
						intoANewInstanceOf: newClass
						via: mappingArray.
			"We need to manually move the special behavior as #become: does not"
			newInst setSpecialBehavior: (oldInst setSpecialBehavior: 16rFF00).
			newInst isImmutable: oldInst isImmutable.
			oldInst become: newInst]!

mutateMetaclass: oldMetaclass toBeASubclassOf: newSuperclass
	"Private - Create a new Metaclass with the appropriate features and mutate all instances of oldClass to new instances of the new class and then recursively make the same change to the subclasses of aClass. Finally, remove the oldClass and if appropriate its metaclass from their respective superclasses and do a #oneWayBeome: on oldClass to newClass.
	Implementation Note: We must not access any instance variables after mutation, in case the receiver is being mutated and the inst. var offsets change."

	| newMetaclass |
	newMetaclass := self newMetaclassLike: oldMetaclass superclass: newSuperclass.
	self
		mutateInstances: {oldMetaclass instanceClass}
		of: oldMetaclass
		toBeInstancesOf: newMetaclass.	"Mutate the instance class."
	self updateVMRegistryWith: newMetaclass instanceClass.
	oldMetaclass subclassesDo: [:metaclass | self mutateMetaclass: metaclass toBeASubclassOf: newMetaclass].
	oldMetaclass removeFromSuper.
	oldMetaclass become: newMetaclass.
	newMetaclass oneWayBecome: oldMetaclass!

mutateToNewClass
	"Private - Set currentClass to a mutation of itself based on the information
	in the receiver. The instances of the new currentClass are mutations of the
	instances of the old currentClass."

	currentClass isMeta
		ifTrue: [self mutateMetaclass: currentClass toBeASubclassOf: superclass]
		ifFalse: 
			[self
				mutateClass: currentClass
				toBeASubclassOf: superclass
				in: self environment]!

newClassLike: aClass superclass: aSuperclass
	"Private - Answer a new class based on aClass with superclass aSuperclass.
	First, create a new metaclass and it to create its new instance class
	(there can be only one). The data from the old metaclass and class is
	mapped across to the new ones."

	| newMeta mappingArray newInstanceClass |
	newMeta := self
		newMetaclassLike: aClass class
		superclass: (self class classOf: aSuperclass).
	mappingArray := self generateMapFrom: aClass class to: newMeta.
	newInstanceClass := self
		translateInstance: aClass
		intoANewInstanceOf: newMeta
		via: mappingArray.
	newMeta instanceClass: newInstanceClass.

	newInstanceClass subclasses: #().
	^self
		initializeCopy: newInstanceClass
		fromClass: aClass
		superclass: aSuperclass!

newMetaclassLike: aMetaclass superclass: metaSuperclass
	"Private - Answer a new metaclass based on aMetaclass with superclass metaSuperclass."

	^self
		initializeCopy: aMetaclass basicShallowCopy
		fromClass: aMetaclass
		superclass: metaSuperclass!

notifyClassCreated
	"Use the trigger mechanism to notify interested parties that a class has been added."

	Smalltalk classAdded: currentClass!

notifyClassRenamed
	self notifyClassUpdated!

notifyClassUpdated
	"Private - Use the trigger mechanism to notify interested parties that a class has been renamed, 
	and mark all its immediate subclasses as changed since these will need to be filed
	out to record the change in their source definition."

	Smalltalk classUpdated: self currentClass.
	self currentClass subclassesDo: [:each | each isChanged: true]!

recompilationRequired
	"Private - Answer whether recompilation of a modified class is required."

	^flags allMask: RecompileMask!

recompilationRequired: aBoolean reason: aString
	"Private - Record that recompilation is required if the argument is true. 
	Note this is not an accessor - if the argument is false, then leave the current setting unchanged."

	aBoolean ifTrue: [flags := flags bitOr: RecompileMask]!

remove
	"Private - Remove currentClass completely from the system."

	"Unitialize the class if necessary"

	[currentClass uninitializeBeforeRemove]
		on: self class invalidRemoveError
		do: [:x | x outer]
		on: Error
		do: 
			[:x |
			"Here we take advantage of Smallalk's powerful  exception system to resignal 
			 any errors that occur as special resumable errors that can be resumed by the 
			 enclosing scope to go on and remove the class regardless."
			x resignalAs: (self class invalidRemoveError new
						originalError: x;
						messageText: 'Error uninitializing ' , currentClass name , ': ' , x description;
						tag: currentClass)].
	self validateForRemove.
	Smalltalk removeClass: currentClass!

removeUnimplementedProtocols
	"Private - Remove any protocols of the modified class which are no longer fully implemented.
	This should only occur if the class has been moved in the hierarchy."

	| current |
	current := self currentClass.
	current protocols copy do: [:p |
		(current canUnderstandProtocol: p)
			ifFalse: [current removeProtocol: p]]!

rename
	"Private - Rename currentClass to className."

	self validateForRename.
	currentClass rename: (self environment absoluteNameFor: className).
	self notifyClassRenamed!

requiresMutation
	"Private - Answer whether the class being modified needs to have its instances mutated.
	Mutation is required if any of the following aspects of the class are being changed:
		its superclass,
		its instance spec or
		its instance variables."

	^self superclassIsBeingChanged
		or: [self instanceShapeIsBeingChanged or: [self instanceVariablesAreBeingChanged]]!

setCommentOf: aClass
	"Private - Set the comment of aClass to the receiver's comment inst var unless it
	is nil in which case make no change."

	comment notNil
		ifTrue: [aClass comment: comment]!

setImportsOf: aClass
	"Private - Set the shared pools of the newly created class, aClass, to those described by the receiver's sharedPools inst var."

	aClass imports: self imports!

setInstanceVariablesOf: aClass
	"Private - Set the instance variable layout of aClass to those described by the receiver's
	instanceVariables inst var, or those of currentClass if no changes have been proposed."

	aClass setInstanceVariables: self instanceVariables!

setNewClassCategories
	currentClass classCategories: self categories!

superclass: aClass
	"Private - Set the target superclass."

	superclass := aClass!

superclassIsBeingChanged
	"Private - Answer whether the a new superclass has been specified."

	^superclass ~= currentClass superclass
			!

translateInstance: oldInstance intoANewInstanceOf: newClass via: mappingArray 
	"Private - Answer a new instance of newClass initialised from the data
	in oldInstance via the mapping specified by mappingArray. The array
	contains as many elements as there are named instance variables in
	newClass and gives the instance variable index in oldInstance from
	which to copy the old inst var. If the element contains zero then
	the corresponding inst var in the new object should be left as nil."

	| newInstance |
	newClass isVariable 
		ifFalse: [newInstance := newClass basicNew]
		ifTrue: 
			[newInstance := newClass basicNew: oldInstance basicSize.
			1 to: oldInstance basicSize
				do: [:i | newInstance basicAt: i put: (oldInstance basicAt: i)]].
	1 to: newClass instSize
		do: 
			[:i | 
			| index |
			(index := mappingArray at: i) ~~ 0 
				ifTrue: [newInstance instVarAt: i put: (oldInstance instVarAt: index)]].
	^newInstance!

updateVMRegistryWith: aClass
	"Private - Ensure that if aClass is a VM registered class then the VM's entry is updated to the new class."

	| name |
	name := aClass name asSymbol.
	(VMLibrary.RegistryKeys lookup: name)
		ifNotNil: 
			[:index |
			| current |
			current := VMLibrary.Registry at: index.
			(current isNil or: [current class isMetaclass])
				ifTrue: [VMLibrary default registryAtIndex: index put: aClass]]!

validateClass
	"Private - Ensure that currentClass is a valid Behavior."

	currentClass isNil ifTrue: [self error: 'Class not found.'].
	(currentClass isKindOf: Behavior) ifFalse: [self error: 'Class must be a kind of Behavior.']!

validateClassForRename
	"Private - Ensure that we are permitted to rename the class."

	self validateClass.
	(SessionManager current isOAD
		or: [((FixedLayout includes: currentClass) or: [FixedInitialLayout includes: currentClass]) not])
			ifFalse: [self error: ('<1p> must not be renamed.' expandMacrosWith: currentClass)]!

validateClassInstanceVars
	"Private - Ensure that the proposed changes do not result in a duplicate name
	anywhere in the meta-superclass or meta-subclass chain."

	| instVarSet |
	instVarSet := self class
		validateInstanceVars: currentClass class instVarNames
		againstSuperclass: (self class classOf: superclass).
	currentClass class allSubclasses do: [:cls |
		cls instVarNames do: [:name | self class validateInstVarName: name using: instVarSet]]!

validateClassName
	"Private - Ensure that the proposed class name is valid."

	(self class isValidClassName: className)
		ifFalse: [self error: ('Invalid class name <1s>' expandMacrosWith: className)]!

validateClassVarsForCreate
	"Private - Ensure that the proposed class variable name list does not
	contain a reserved word or a duplicate name defined either in the list
	itself or anywhere in the proposed superclass chain."

	classVariables isEmpty
		ifFalse: [self class validateClassVars: self classVariables againstSuperclass: superclass]!

validateClassVarsForModify
	"Private - Ensure that the proposed class variable name list does not
	contain a reserved word or a duplicate name defined either in the list
	itself or anywhere in the proposed superclass or subclass chain."

	| classVarSet |
	classVarSet := self class validateClassVars: self classVariables againstSuperclass: superclass.
	currentClass allSubclasses
		do: [:cls | cls classBindingNames do: [:name | self class validateClassVarName: name using: classVarSet]]!

validateForCreate
	"Private - Ensure that the proposed class creation would result in a valid new class."

	self
		validateClassName;
		validateSuperclassIsSubclassable;
		validateSuperclassChainForCreate;
		validateInstanceSpec;
		validateInstanceVarsForCreate;
		validateClassVarsForCreate;
		validateImports!

validateForModify
	"Private - Ensure that the proposed class modification would result in a valid class."

	self
		validateClass;
		validateSuperclassForModify;
		validateSuperclassChainForModify;
		validateInstanceSpecForModify;
		validateInstanceVarsForModify;
		validateSubclassInstanceSpecs.
	currentClass isMeta
		ifFalse: 
			[self
				validateClassInstanceVars;
				validateClassVarsForModify;
				validateImports]!

validateForRemove
	"Private - Ensure that the proposed class removal is valid. Invalid class removal errors may
	be raised, but these are resumable and the enclosing scope is permitted to catch and resume
	these errors if it wishes to attempt to remove the class regardless."

	self validateClass.
	self checkNoInstances.
	self checkNoSubclasses!

validateForRename
	"Private - Ensure that the proposed class rename is valid."

	self
		validateClassForRename;
		validateClassName.
	(self environment includesKey: className)
		ifTrue: [self error: ('<1p>.<1s> already exists.' expandMacrosWith: self environment with: className)]!

validateImports
	"Private - Ensure that the proposed imports exist in the environment and ensure they are of canonical form."

	imports := self imports collect: 
					[:each |
					| namespace fullRef private |
					each isString
						ifTrue: 
							[fullRef := each asQualifiedReference.
							private := false]
						ifFalse: 
							[private := each isPrivate.
							fullRef := each asString asQualifiedReference].
					fullRef isDefined
						ifTrue: 
							[namespace := fullRef value.
							namespace class isMeta ifFalse: [self error: 'Invalid import: ' , each printString]]
						ifFalse: 
							[Warning signal: ('Imported namespace <1p> does not exist.' expandMacrosWith: fullRef asString).
							namespace := fullRef asSymbol].
					namespace asQualifiedReference
						isPrivate: private;
						yourself]!

validateInstanceSpec
	"Private - Validate and complete the instanceSpec inst var."

	instanceSpec := self class
		validateInstanceSpec: instanceSpec
		size: self instanceVariables size
		superclass: superclass.!

validateInstanceSpecForModify
	"Private - Validate the instanceSpec for a class modification."

	self validateInstanceSpec.
	(self fundamentalTypeIsBeingChanged and: [currentClass isMeta not and: [self isFixedType]])
		ifTrue: [self error: ('You may not change the subclass type of <1p>' expandMacrosWith: currentClass)]!

validateInstanceVarsForCreate
	"Private - Ensure that the proposed instance variable name list does not
	contain a reserved word or a duplicate name defined either in the list
	itself or anywhere in the proposed superclass chain."

	self class
		validateInstanceVars: self instanceVariables
		againstSuperclass: superclass!

validateInstanceVarsForModify
	"Private - Ensure that the proposed instance variable name list does not contain a reserved
	word or a duplicate name defined either in the list itself or anywhere in the proposed
	superclass or subclass chain."

	| instVarSet proposedInstVarArray |
	proposedInstVarArray := self instanceVariables.
	instVarSet := self class validateInstanceVars: proposedInstVarArray againstSuperclass: superclass.
	currentClass isMeta
		ifFalse: 
			[(self isFixedLayout and: [currentClass instVarNames ~= proposedInstVarArray])
				ifTrue: [self error: 'You must not change the instance variable layout of ' , currentClass name].
			(self isFixedInitialLayout and: 
					[| existing |
					existing := currentClass instVarNames.
					existing notEmpty and: [(proposedInstVarArray indexOfSubCollection: currentClass instVarNames) ~~ 1]])
				ifTrue: [self error: 'New inst vars must come after those already in ' , currentClass name]].
	currentClass allSubclasses
		do: [:cls | cls instVarNames do: [:name | self class validateInstVarName: name using: instVarSet]]!

validateSubclassesOf: aClass againstInstanceSpec: instSpec
	"Private - Ensure that if the proposed change to the instance spec of aClass
	is acceptable to all subclasses."

	| dummyClass |
	(dummyClass := Behavior new) instanceSpec: instSpec.
	aClass subclassesDo: 
			[:cls |
			| validatedInstSpec |
			validatedInstSpec := self class
						validateInstanceSpec: cls instanceSpec
						size: cls instVarNames size
						superclass: dummyClass.
			(self class fundamentalTypeOf: validatedInstSpec) = (self class fundamentalTypeOf: cls instanceSpec)
				ifFalse: [self validateSubclassesOf: cls againstInstanceSpec: validatedInstSpec]]!

validateSubclassInstanceSpecs
	"Private - Ensure that the proposed class modification would not result in
	any of the subclasses becoming invalid."

	self validateSubclassesOf: currentClass againstInstanceSpec: instanceSpec!

validateSuperclassChainForCreate
	"Private - Ensure that the proposed superclass chain doesn't already include
	a class of the same name as the proposed class."

	superclass isNil ifTrue: [^self].
	(superclass withAllSuperclasses anySatisfy: [:each | each name = className]) 
		ifTrue: [self error: 'Class cannot be a subclass of itself']!

validateSuperclassChainForModify
	"Private - Ensure that the proposed superclass chain doesn't already include
	the current class"

	superclass isNil ifTrue: [^self].
	(superclass withAllSuperclasses anySatisfy: [:each | each == currentClass]) 
		ifTrue: [self error: 'Class cannot be a subclass of itself']!

validateSuperclassForModify
	"Private - Ensure that no circularity is introduced into the hierarchy and
	that the superclass of a metaclass is not changed directly."

	self superclassIsBeingChanged ifFalse: [^self].
	currentClass isMeta
		ifTrue: [self error: 'It is invalid to directly change the superclass of a metaclass.'].
	self validateSuperclassIsSubclassable.
	(superclass notNil and: [superclass isKindOf: currentClass])
		ifTrue: [self error: ('<1p> is a subclass of the class being changed.' expandMacrosWith: superclass)]!

validateSuperclassIsSubclassable
	"Private - Ensure that the superclass is a subclassable object."

	superclass notNil
		ifTrue: 
			[((superclass isKindOf: Class) not or: [Unsubclassable includes: superclass])
				ifTrue: [self error: 'Proposed superclass is not subclassable.']]! !
!Kernel.ClassBuilder categoriesFor: #beBytes!class type!private! !
!Kernel.ClassBuilder categoriesFor: #beFixed!class type!private! !
!Kernel.ClassBuilder categoriesFor: #beIndirectBytes!class type!private! !
!Kernel.ClassBuilder categoriesFor: #beNullTerminatedBytes!class type!private! !
!Kernel.ClassBuilder categoriesFor: #beVariable!class type!private! !
!Kernel.ClassBuilder categoriesFor: #canMutateInSitu!mutating!private! !
!Kernel.ClassBuilder categoriesFor: #categories!accessing!private! !
!Kernel.ClassBuilder categoriesFor: #categories:!accessing!private! !
!Kernel.ClassBuilder categoriesFor: #categoryNames:!accessing!public! !
!Kernel.ClassBuilder categoriesFor: #checkNoInstances!private!validation! !
!Kernel.ClassBuilder categoriesFor: #checkNoSubclasses!private!validation! !
!Kernel.ClassBuilder categoriesFor: #class:!accessing!private! !
!Kernel.ClassBuilder categoriesFor: #classCategoryClass!accessing!private! !
!Kernel.ClassBuilder categoriesFor: #classConstants!accessing!public! !
!Kernel.ClassBuilder categoriesFor: #classConstants:!accessing!public! !
!Kernel.ClassBuilder categoriesFor: #className:!accessing!private! !
!Kernel.ClassBuilder categoriesFor: #classVariables!class variables!private! !
!Kernel.ClassBuilder categoriesFor: #classVariables:!class variables!public! !
!Kernel.ClassBuilder categoriesFor: #classVariableString:!class variables!public! !
!Kernel.ClassBuilder categoriesFor: #comment:!comments!private! !
!Kernel.ClassBuilder categoriesFor: #createNewClass!operations!private! !
!Kernel.ClassBuilder categoriesFor: #createProper!helpers!private! !
!Kernel.ClassBuilder categoriesFor: #currentClass!accessing!public! !
!Kernel.ClassBuilder categoriesFor: #declareClassVariablesOf:!private! !
!Kernel.ClassBuilder categoriesFor: #environment!accessing!public! !
!Kernel.ClassBuilder categoriesFor: #environment:!accessing!public! !
!Kernel.ClassBuilder categoriesFor: #errorInvalidRemove:!exceptions!private! !
!Kernel.ClassBuilder categoriesFor: #fundamentalTypeIsBeingChanged!private!testing! !
!Kernel.ClassBuilder categoriesFor: #generateGUID!operations!private! !
!Kernel.ClassBuilder categoriesFor: #generateInstanceSpecFor:superclass:!class type!private! !
!Kernel.ClassBuilder categoriesFor: #generateMapFrom:to:!mutating!private! !
!Kernel.ClassBuilder categoriesFor: #ignoreInstances!accessing!private! !
!Kernel.ClassBuilder categoriesFor: #ignoreInstances:!accessing!private! !
!Kernel.ClassBuilder categoriesFor: #imports!pool dictionaries!private! !
!Kernel.ClassBuilder categoriesFor: #imports:!pool dictionaries!public! !
!Kernel.ClassBuilder categoriesFor: #initialize!initializing!private! !
!Kernel.ClassBuilder categoriesFor: #initializeCopy:fromClass:superclass:!mutating!private! !
!Kernel.ClassBuilder categoriesFor: #install:in:!environment!private! !
!Kernel.ClassBuilder categoriesFor: #installInSuperclass:!helpers!private! !
!Kernel.ClassBuilder categoriesFor: #installNewClass!environment!private! !
!Kernel.ClassBuilder categoriesFor: #instanceShapeIsBeingChanged!private!testing! !
!Kernel.ClassBuilder categoriesFor: #instanceSpec:!class type!private! !
!Kernel.ClassBuilder categoriesFor: #instanceVariables!instance variables!private! !
!Kernel.ClassBuilder categoriesFor: #instanceVariables:!instance variables!public! !
!Kernel.ClassBuilder categoriesFor: #instanceVariablesAreBeingChanged!private!testing! !
!Kernel.ClassBuilder categoriesFor: #instanceVariableString:!instance variables!public! !
!Kernel.ClassBuilder categoriesFor: #isFixedInitialLayout!public!testing! !
!Kernel.ClassBuilder categoriesFor: #isFixedLayout!public!testing! !
!Kernel.ClassBuilder categoriesFor: #isFixedType!public!testing! !
!Kernel.ClassBuilder categoriesFor: #isModifyAction!private!testing! !
!Kernel.ClassBuilder categoriesFor: #modifyClassVariablesOf:!private! !
!Kernel.ClassBuilder categoriesFor: #modifyExistingClass!operations!private! !
!Kernel.ClassBuilder categoriesFor: #modifyImportsOf:!pool dictionaries!private! !
!Kernel.ClassBuilder categoriesFor: #modifyOrCreate!operations!public! !
!Kernel.ClassBuilder categoriesFor: #modifyProper!private! !
!Kernel.ClassBuilder categoriesFor: #mutateClass:toBeASubclassOf:in:!mutating!private! !
!Kernel.ClassBuilder categoriesFor: #mutateInSitu!mutating!private! !
!Kernel.ClassBuilder categoriesFor: #mutateInstances:of:toBeInstancesOf:!mutating!private! !
!Kernel.ClassBuilder categoriesFor: #mutateMetaclass:toBeASubclassOf:!mutating!private! !
!Kernel.ClassBuilder categoriesFor: #mutateToNewClass!mutating!private! !
!Kernel.ClassBuilder categoriesFor: #newClassLike:superclass:!mutating!private! !
!Kernel.ClassBuilder categoriesFor: #newMetaclassLike:superclass:!mutating!private! !
!Kernel.ClassBuilder categoriesFor: #notifyClassCreated!public!updating! !
!Kernel.ClassBuilder categoriesFor: #notifyClassRenamed!operations!private! !
!Kernel.ClassBuilder categoriesFor: #notifyClassUpdated!private!updating! !
!Kernel.ClassBuilder categoriesFor: #recompilationRequired!accessing!private! !
!Kernel.ClassBuilder categoriesFor: #recompilationRequired:reason:!accessing!private! !
!Kernel.ClassBuilder categoriesFor: #remove!operations!private! !
!Kernel.ClassBuilder categoriesFor: #removeUnimplementedProtocols!helpers!private! !
!Kernel.ClassBuilder categoriesFor: #rename!operations!private! !
!Kernel.ClassBuilder categoriesFor: #requiresMutation!mutating!private! !
!Kernel.ClassBuilder categoriesFor: #setCommentOf:!comments!private! !
!Kernel.ClassBuilder categoriesFor: #setImportsOf:!pool dictionaries!private! !
!Kernel.ClassBuilder categoriesFor: #setInstanceVariablesOf:!instance variables!private! !
!Kernel.ClassBuilder categoriesFor: #setNewClassCategories!helpers!private! !
!Kernel.ClassBuilder categoriesFor: #superclass:!accessing!private! !
!Kernel.ClassBuilder categoriesFor: #superclassIsBeingChanged!private!testing! !
!Kernel.ClassBuilder categoriesFor: #translateInstance:intoANewInstanceOf:via:!mutating!private! !
!Kernel.ClassBuilder categoriesFor: #updateVMRegistryWith:!mutating!private! !
!Kernel.ClassBuilder categoriesFor: #validateClass!private!validation! !
!Kernel.ClassBuilder categoriesFor: #validateClassForRename!private!validation! !
!Kernel.ClassBuilder categoriesFor: #validateClassInstanceVars!private!validation! !
!Kernel.ClassBuilder categoriesFor: #validateClassName!private!validation! !
!Kernel.ClassBuilder categoriesFor: #validateClassVarsForCreate!private!validation! !
!Kernel.ClassBuilder categoriesFor: #validateClassVarsForModify!private!validation! !
!Kernel.ClassBuilder categoriesFor: #validateForCreate!private!validation! !
!Kernel.ClassBuilder categoriesFor: #validateForModify!private!validation! !
!Kernel.ClassBuilder categoriesFor: #validateForRemove!private!validation! !
!Kernel.ClassBuilder categoriesFor: #validateForRename!private!validation! !
!Kernel.ClassBuilder categoriesFor: #validateImports!private!validation! !
!Kernel.ClassBuilder categoriesFor: #validateInstanceSpec!private!validation! !
!Kernel.ClassBuilder categoriesFor: #validateInstanceSpecForModify!private!validation! !
!Kernel.ClassBuilder categoriesFor: #validateInstanceVarsForCreate!private!validation! !
!Kernel.ClassBuilder categoriesFor: #validateInstanceVarsForModify!private!validation! !
!Kernel.ClassBuilder categoriesFor: #validateSubclassesOf:againstInstanceSpec:!private!validation! !
!Kernel.ClassBuilder categoriesFor: #validateSubclassInstanceSpecs!private!validation! !
!Kernel.ClassBuilder categoriesFor: #validateSuperclassChainForCreate!private!validation! !
!Kernel.ClassBuilder categoriesFor: #validateSuperclassChainForModify!private!validation! !
!Kernel.ClassBuilder categoriesFor: #validateSuperclassForModify!private!validation! !
!Kernel.ClassBuilder categoriesFor: #validateSuperclassIsSubclassable!private!validation! !

!Kernel.ClassBuilder class methodsFor!

allClassVarNamesOf: aClass
	"Private - Answer an array of the class var names of aClass.
	The Array will be empty if aClass is nil."

	^aClass isNil ifTrue: [{}] ifFalse: [aClass allClassVarNames]!

allInstVarNamesOf: aClass
	"Private - Answer an array of the inst var names of aClass.
	The Array will be empty if aClass is nil."

	^aClass isNil ifTrue: [{}] ifFalse: [aClass allInstVarNames]!

classOf: aClass
	"Private - Answer the class of aClass or Class if it is nil."

	^aClass ifNil: [Class] ifNotNil: [aClass class]!

forModifying: aClass
	"Answer a new instance of the receiver set up to modify the <Class>, aClass.
	The instance is initialized with all the current attributes of the class, so obviously
	one or more of these must be modified if any modification is actually to take place."

	| builder |
	builder := self new
				class: aClass;
				superclass: aClass superclass;
				instanceVariables: aClass instVarNames;
				yourself.
	aClass isMeta
		ifFalse: 
			[builder
				classVariables: aClass classVariableNames;
				imports: aClass imports;
				classConstants: aClass classConstants].
	^builder!

fundamentalTypeOf: anInstanceSpec
	"Private - Answer the combined settings of the isVariable and isPointers flags of anInstanceSpec."

	^anInstanceSpec bitAnd: Behavior._VariableMask + Behavior._PointersMask!

initialize
	"Initialize the receiver's class variables.
		ClassBuilder initialize
	"

	self addClassConstant: 'Unsubclassable'
		value: ({Character. SmallInteger} asSet
				isImmutable: true;
				yourself).
	self addClassConstant: 'FixedLayout'
		value: ({true class.
				false class.
				Array.
				Character.
				SmallInteger.
				BlockClosure.
				Context.
				External.ExternalMethod.
				External.Address.
				Message.
				MethodDictionary.
				UndefinedObject.
				Object} asSet
				isImmutable: true;
				yourself).
	"add: ProtoObject;"
	self addClassConstant: 'FixedInitialLayout'
		value: ({Class.
				Metaclass.
				PositionableStream.
				Semaphore.
				Process.
				ProcessorScheduler.
				VariableBinding} asSet
				isImmutable: true;
				yourself)!

instanceSpecIsBytes: anInstanceSpec
	"Private - Answer whether anInstanceSpec represents a byte subclass."

	^(anInstanceSpec anyMask: Behavior._PointersMask) not!

instanceSpecWithFixedPointers: anInteger
	"Private - Answer an instance spec based on anInteger but adjusted to represent instances
	containing named instance vars only."

	^Core.Behavior._PointersMask bitOr: (anInteger bitAnd: Core.Behavior._SizeMask)!

instanceSpecWithIndirectBytes
	"Private - Answer an instance spec to represent instances with no named instances variables,
	made of indexable bytes and interpreted by certain system primitives as an indirection to
	other data."

	^Behavior._VariableMask + Behavior._IndirectMask!

instanceSpecWithNullTerminatedBytes
	"Private - Answer an instance spec to represent instances with no named instances variables,
	made of indexable bytes and terminated by an extra byte initialized to null."

	^Behavior._VariableMask + Behavior._NullTermMask!

instanceSpecWithVariableBytes: anInteger
	"Private - Answer an instance spec based on anInteger but adjusted to represent instances
	with no named instances variables and made of indexable bytes."

	^Behavior._VariableMask
		bitOr: (anInteger bitAnd: Behavior._NullTermMask + Behavior._IndirectMask)!

instanceSpecWithVariablePointers: anInteger
	"Private - Answer an instance spec based on anInteger but adjusted to represent instances
	containing indexable pointers with or without named instance vars."

	^Behavior._VariableMask + Behavior._PointersMask
		bitOr: (anInteger bitAnd: Behavior._SizeMask)!

instSizeOf: aClass
	"Private - Answer the fixed size of aClass or zero if it is nil."

	^aClass isNil
		ifTrue: [0]
		ifFalse: [aClass instSize]!

invalidRemoveError
	"Answer the <exceptionSelector> that can be used to catch <Exception>s raised by the receiver
	when some error occurs removing a class, for example as a result of errors occuring while
	uninitializing the class or because it has extant instances or subclasses. The exceptions are resumable 
	(i.e. #resume: is a valid handler response, and allows the handler to ignore the exception and 
	forcibly remove the class)."

	^ClassRemovalError!

isFixedLayout: aClass 
	"Answer whether the <Class> argument is of fixed layout (i.e. its
	collection of instance variables cannot be changed in any way)."

	^aClass isBytes or: 
			[(FixedLayout anySatisfy: [:cls | cls includesBehavior: aClass]) 
				or: [FixedInitialLayout anySatisfy: [:cls | cls inheritsFrom: aClass]]]!

isValidClassName: aString
	"Private - Answer whether aString is a valid class name."

	| parts |
	parts := BindingReference splitQualifiedName: aString.
	^(parts allSatisfy: 
			[:each |
			each notEmpty
				and: [(self isValidIdentifier: each) and: [each first == $_ or: [each first isUppercase]]]])
		and: 
			[| ns |
			ns := (BindingReference path: parts allButLast) valueOrNil.
			ns notNil and: [ns class isMeta]]!

isValidIdentifier: aString
	(aString isEmpty or: [self isValidInitialIdentifierChar: aString first]) ifFalse: [^false].
	2 to: aString size do: [:i | (self isValidIdentifierChar: (aString at: i)) ifFalse: [^false]].
	^(##(Set withAll: #('self' 'super' 'nil' 'true' 'false' 'thisContext' '_'))
		includes: aString asString) not!

isValidIdentifierChar: aCharacter 
	^(self isValidInitialIdentifierChar: aCharacter) or: [aCharacter isDigit]!

isValidInitialIdentifierChar: aCharacter 
	^aCharacter == $_ or: [aCharacter isLetter]!

moveClass: aClass toSuperclass: aSuperclass
	"Move aClass to be subclassed from aSuperclass."

	(self forModifying: aClass)
		superclass: aSuperclass;
		modifyExistingClass
!

new
	"Answer a new initialized instance."

	^super new initialize!

removeClass: aClass 
	"Remove aClass."

	self removeClass: aClass ignoreInstances: false!

removeClass: aClass ignoreInstances: aBoolean 
	(self new)
		class: aClass;
		ignoreInstances: aBoolean;
		remove!

renameClass: aClass to: aString
	"Rename aClass to aString."

	self new
		class: aClass;
		className: aString;
		rename!

validateClassVarName: aString using: aCollection
	"Private - Ensure that the proposed class variable name is not a
	reserved word and does not duplicate a name defined in aCollecton."

	| first |
	(self isValidIdentifier: aString)
		ifFalse: 
			[self
				error: ('Proposed class variable <1p> is invalid as a local identifier.' expandMacrosWith: aString)].
	(aCollection includes: aString)
		ifTrue: [self error: ('Proposed class variable <1p> is multiply defined.' expandMacrosWith: aString)].
	first := aString first.
	(first isUppercase or: [first == $_]) ifTrue: [^self].
	Warning new
		isSuppressible: true;
		signal: ('Proposed class variable <1p> should start with an uppercase letter.'
					expandMacrosWith: aString)!

validateClassVars: classVarsArray againstSuperclass: aClass
	"Private - Ensure that the proposed class variable name list does not
	contain a reserved word or a duplicate name defined either in the list
	itself or anywhere in the proposed superclass chain.
	Answer a Set of the existing and proposed class vars of the class and its
	superclasses."

	| classVarSet |
	classVarSet := (self allClassVarNamesOf: aClass) asSet.
	classVarsArray do: [:classVar |
		self validateClassVarName: classVar using: classVarSet.
		classVarSet add: classVar].
	^classVarSet
!

validateInstanceSpec: anInstanceSpec size: anInteger superclass: proposedSuperclass
	"Private - Validate the proposed instance spec, fixed size and superclass
	and answer a completed instance spec."

	| spec fundamentalType fixedSize |
	spec := anInstanceSpec bitAnd: Behavior._SizeMask bitInvert.
	fundamentalType := self fundamentalTypeOf: spec.
	fundamentalType = Behavior._VariableMask
		ifTrue: 
			[spec := self
						validateSpecAsVariableBytes: spec
						size: anInteger
						superclass: proposedSuperclass].
	fundamentalType = Behavior._PointersMask
		ifTrue: 
			[spec := self
						validateSpecAsFixedPointers: spec
						size: anInteger
						superclass: proposedSuperclass].
	fundamentalType = (Behavior._VariableMask + Behavior._PointersMask)
		ifTrue: 
			[spec := self
						validateSpecAsVariablePointers: spec
						size: anInteger
						superclass: proposedSuperclass].
	fixedSize := anInteger + (self instSizeOf: proposedSuperclass).
	fixedSize > Behavior._SizeMask
		ifTrue: 
			[self error: ('Classes are allowed a maximum of <1p> instance variables.'
						expandMacrosWith: Behavior._SizeMask)].
	^spec bitOr: fixedSize!

validateInstanceVars: instVarsArray againstSuperclass: aClass
	"Private - Ensure that the proposed instance variable name list does not
	contain a reserved word or a duplicate name defined either in the list
	itself or anywhere in the proposed superclass chain.
	Answer a Set of the existing and proposed inst vars of the class and its
	superclasses."

	| instVarSet |
	instVarSet := (self allInstVarNamesOf: aClass) asSet.
	instVarsArray do: [:instVar |
		self validateInstVarName: instVar using: instVarSet.
		instVarSet add: instVar].
	^instVarSet
!

validateInstVarName: aString using: aCollection
	"Private - Ensure that the proposed instance variable name is not a
	reserved word and does not duplicate a name defined in aColecton."

	(self isValidIdentifier: aString)
		ifFalse: 
			[self
				error: ('Proposed instance variable <1p> is invalid as a local identifier.' expandMacrosWith: aString)].
	(aCollection includes: aString)
		ifTrue: 
			[self error: ('Proposed instance variable <1p> is multiply defined.' expandMacrosWith: aString)]!

validateSpecAsFixedPointers: spec size: anInteger superclass: proposedSuperclass
	"Private - Answer a validated instance spec. Signal an exception if spec is
	invalid as a fixed size pointer subclass of proposedSuperclass."

	proposedSuperclass notNil
		ifTrue: [
			proposedSuperclass isBytes
				ifTrue: [self validateSpecAsVariablePointers: spec size: anInteger superclass: proposedSuperclass].
			proposedSuperclass isVariable
				ifTrue: [self error: 'Subclasses of an indexed class must also be indexed.']].
	^spec
!

validateSpecAsVariableBytes: spec size: anInteger superclass: proposedSuperclass
	"Private - Answer a validated instance spec possibly containing indirect or
	nullTerminated bits inherited from the proposedSuperclass. Signal an exception
	if spec is invalid as a variable byte subclass of proposedSuperclass."

	| inheritedFlags validatedSpec |
	inheritedFlags := Behavior._IndirectMask + Behavior._NullTermMask.
	validatedSpec := spec.
	proposedSuperclass notNil
		ifTrue: [
			proposedSuperclass instSize > 0
				ifTrue: [self error: 'A byte subclass may not derive from a class containing named instance variables'].
			(proposedSuperclass isPointers and: [proposedSuperclass isVariable])
				ifTrue: [self error: 'A byte subclass may not derive from a class containing indexed instance variables'].
			validatedSpec := validatedSpec bitOr: (inheritedFlags bitAnd: proposedSuperclass instanceSpec)].

	(validatedSpec allMask: inheritedFlags)
		ifTrue: [self error: 'A byte subclass may not be both indirect and null-terminated.'].
	anInteger > 0
		ifTrue: [self error: 'A byte subclass may not contain named instance variables.'].
	^validatedSpec!

validateSpecAsVariablePointers: spec size: anInteger superclass: proposedSuperclass
	"Private - Answer a validated instance spec. Signal an exception if spec is
	invalid as a variable subclass of proposedSuperclass."

	(proposedSuperclass notNil and: [proposedSuperclass isBytes])
		ifTrue: [self error: 'A subclass containing pointers may not derive from a class containing bytes.'].
	(spec anyMask: Behavior._IndirectMask)
		ifTrue: [self error: 'Indirect subclasses must contain bytes.'].
	(spec anyMask: Behavior._NullTermMask)
		ifTrue: [self error: 'Null-terminated subclasses must contain bytes.'].
	^spec! !
!Kernel.ClassBuilder class categoriesFor: #allClassVarNamesOf:!helpers!private! !
!Kernel.ClassBuilder class categoriesFor: #allInstVarNamesOf:!helpers!private! !
!Kernel.ClassBuilder class categoriesFor: #classOf:!helpers!private! !
!Kernel.ClassBuilder class categoriesFor: #forModifying:!instance creation!public! !
!Kernel.ClassBuilder class categoriesFor: #fundamentalTypeOf:!class type!private! !
!Kernel.ClassBuilder class categoriesFor: #initialize!development!initializing!public! !
!Kernel.ClassBuilder class categoriesFor: #instanceSpecIsBytes:!class type!private! !
!Kernel.ClassBuilder class categoriesFor: #instanceSpecWithFixedPointers:!class type!private! !
!Kernel.ClassBuilder class categoriesFor: #instanceSpecWithIndirectBytes!class type!private! !
!Kernel.ClassBuilder class categoriesFor: #instanceSpecWithNullTerminatedBytes!class type!private! !
!Kernel.ClassBuilder class categoriesFor: #instanceSpecWithVariableBytes:!class type!private! !
!Kernel.ClassBuilder class categoriesFor: #instanceSpecWithVariablePointers:!class type!private! !
!Kernel.ClassBuilder class categoriesFor: #instSizeOf:!helpers!private! !
!Kernel.ClassBuilder class categoriesFor: #invalidRemoveError!constants!private! !
!Kernel.ClassBuilder class categoriesFor: #isFixedLayout:!enquiries!public! !
!Kernel.ClassBuilder class categoriesFor: #isValidClassName:!private!testing! !
!Kernel.ClassBuilder class categoriesFor: #isValidIdentifier:!private!testing! !
!Kernel.ClassBuilder class categoriesFor: #isValidIdentifierChar:!private!testing! !
!Kernel.ClassBuilder class categoriesFor: #isValidInitialIdentifierChar:!private!testing! !
!Kernel.ClassBuilder class categoriesFor: #moveClass:toSuperclass:!operations!public! !
!Kernel.ClassBuilder class categoriesFor: #new!instance creation!public! !
!Kernel.ClassBuilder class categoriesFor: #removeClass:!operations!public! !
!Kernel.ClassBuilder class categoriesFor: #removeClass:ignoreInstances:!operations!public! !
!Kernel.ClassBuilder class categoriesFor: #renameClass:to:!operations!public! !
!Kernel.ClassBuilder class categoriesFor: #validateClassVarName:using:!private!validation! !
!Kernel.ClassBuilder class categoriesFor: #validateClassVars:againstSuperclass:!private!validation! !
!Kernel.ClassBuilder class categoriesFor: #validateInstanceSpec:size:superclass:!private!validation! !
!Kernel.ClassBuilder class categoriesFor: #validateInstanceVars:againstSuperclass:!private!validation! !
!Kernel.ClassBuilder class categoriesFor: #validateInstVarName:using:!private!validation! !
!Kernel.ClassBuilder class categoriesFor: #validateSpecAsFixedPointers:size:superclass:!private!validation! !
!Kernel.ClassBuilder class categoriesFor: #validateSpecAsVariableBytes:size:superclass:!private!validation! !
!Kernel.ClassBuilder class categoriesFor: #validateSpecAsVariablePointers:size:superclass:!private!validation! !

