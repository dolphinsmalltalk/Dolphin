"Filed out from Dolphin Smalltalk"!

Object subclass: #ClassBuilder
	instanceVariableNames: 'currentClass className instanceVariables superclass instanceSpec classVariables sharedPools comment flags categories'
	classVariableNames: 'FixedInitialLayout FixedLayout IgnoreInstsMask RecompileMask Unsubclassable'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ClassBuilder guid: (GUID fromString: '{87b4c461-026e-11d3-9fd7-00a0cc3e4a32}')!

ClassBuilder addClassConstant: 'IgnoreInstsMask' value: 16r2!
ClassBuilder addClassConstant: 'RecompileMask' value: 16r1!

ClassBuilder comment: ''!

!ClassBuilder categoriesForClass!System-Support! !

!ClassBuilder methodsFor!

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
			self errorInvalidRemove: ((String writeStream)
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
			[self errorInvalidRemove: ((String writeStream)
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

className: aString
	"Private - Set the className inst var to aString."

	className := aString ifNotNil: [aString asSymbol]!

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
	"Private - Create, install and answer a new class from the
	details contained in the receiver."

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
		setName: className;
		superclass: superclass.

	"In order to sort the metaclass subclasses, we need the instance class name, so we
	leave addition to the superclass subclasses list until the instance class has been created."
	self installInSuperclass: currentClass.
	self
		setInstanceVariablesOf: currentClass;
		setClassVariablesOf: currentClass;
		setSharedPoolsOf: currentClass;
		setCommentOf: currentClass!

currentClass
	"Answer the currentClass inst var."

	^currentClass!

environment
	"Private - Answer the namespace environment for the class being modified."

	^self class environment!

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

initialize
	"Private - Initialize the instance."

	instanceSpec := 0.
	self beFixed.
	flags := 0!

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
		subclasses: nil;
		superclass: aSuperclass;
		addToSuper.
	aClass == currentClass
		ifTrue: [self setInstanceVariablesOf: aClassDescriptionCopy].

	aClassDescriptionCopy compileAll.
	^aClassDescriptionCopy!

install: aClassDescription 
	"Private - Install aClassDescription into its environment."

	| binding env |
	aClassDescription requiresInstallation ifFalse: [^self].
	env := self environment.
	binding := env bindingFor: aClassDescription name.
	binding 
		ifNil: 
			[env at: aClassDescription name put: aClassDescription.
			binding := env bindingFor: aClassDescription name]
		ifNotNil: 
			[binding isImmutable: false.
			binding value: aClassDescription].
	binding isImmutable: true!

installInSuperclass: aClass
	aClass addToSuper!

installNewClass
	"Private - Install aClassDescription into its environment."

	self
		install: currentClass;
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
	"Private - Answer true if the combination of information provided to
	the receiver suggests that this is a class modification operation."

	currentClass isNil
		ifTrue: [
			currentClass := self environment at: className ifAbsent: [^false].
			(currentClass isKindOf: Behavior)
				ifFalse: [
					currentClass := nil.
					^false]].
	^true!

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

modifyPrivate
	"Private - Modify and answer an existing class using the details
	in the receiver. The class is excluded from its superclasses'
	subclasses collection."

	self
		validateForModify;
		modifyProper.
	^self currentClass removeFromSuper; yourself!

modifyProper
	"Private - Modify an existing class using the details contained in the receiver.
	Implementation Note: If the receiver is attempting to modify itself, then
	any direct accesses to instance variables following mutation may fail (if
	the instance variable set is changed, the compiled methods in the stack
	will still be referring to the old inst. var offsets), therefore we must use 
	inst. var accessors."

	| current |
	self requiresMutation ifTrue: [
		self canMutateInSitu
			ifTrue: [self mutateInSitu]
			ifFalse: [self mutateToNewClass]].

	"After this point, must not access inst vars directly in case mutated the receiver."
	current := self currentClass.
	current isMeta ifFalse: [
		self
			setClassVariablesOf: current;
			setSharedPoolsOf: current;
			setCommentOf: current].

	self recompilationRequired ifTrue: [current recompileAll].

	self superclassIsBeingChanged ifTrue: [self removeUnimplementedProtocols]
!

mutateClass: oldClass toBeASubclassOf: newSuperclass
	"Private - Create a new class with the appropriate features and mutate	all instances of oldClass to new instances of the new class and then recursively make the same change to the subclasses of aClass. Finally, remove the oldClass and if appropriate its metaclass from their respective superclasses and do a #oneWayBeome: on oldClass to newClass.
	Implementation Note: We must not access any instance variables after mutation, in case the receiver is being mutated and the inst. var offsets change."

	| newClass mutatingClassItself oldMeta newMeta |
	mutatingClassItself := oldClass == Class.
	newClass := self newClassLike: oldClass superclass: newSuperclass.
	self install: newClass.
	self
		mutateInstances: oldClass primAllInstances
		of: oldClass
		toBeInstancesOf: newClass.
	mutatingClassItself
		ifTrue: 
			["In Dolphin Object class et al are not in the subclasses collection of Class, so need special case handling"
			Smalltalk allRoots do: [:each | self mutateClass: each class toBeASubclassOf: newClass]]
		ifFalse: [oldClass subclasses do: [:cls | self mutateClass: cls toBeASubclassOf: newClass]].
	oldClass removeFromSuper.
	oldMeta := oldClass class.
	newMeta := newClass class.
	oldMeta become: newMeta.
	newMeta oneWayBecome: oldMeta.
	oldClass become: newClass.
	newClass oneWayBecome: oldClass.
	self updateVMRegistryWith: newClass!

mutateInSitu
	"Private - Mutate the class being modified without mutating its instances.
	We may need to change the superclass or instance variables.
	N.B. We cannot change instance variables without changing superclass, as this always requires a full mutation."

	self superclassIsBeingChanged ifTrue: 
			[currentClass class setSuperclass: (self class classOf: superclass).
			currentClass setSuperclass: superclass.
			self instanceVariablesAreBeingChanged ifTrue: [self setInstanceVariablesOf: currentClass].
			self recompilationRequired: true].!

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
	oldMetaclass subclasses do: [:metaclass | self mutateMetaclass: metaclass toBeASubclassOf: newMetaclass].
	oldMetaclass removeFromSuper.
	oldMetaclass become: newMetaclass.
	newMetaclass oneWayBecome: oldMetaclass!

mutateToNewClass
	"Private - Set currentClass to a mutation of itself based on the information
	in the receiver. The instances of the new currentClass are mutations of the
	instances of the old currentClass."

	currentClass isMeta
		ifTrue: [self mutateMetaclass: currentClass toBeASubclassOf: superclass]
		ifFalse: [self mutateClass: currentClass toBeASubclassOf: superclass]!

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

	self environment classAdded: currentClass!

notifyClassRenamed
	self notifyClassUpdated!

notifyClassUpdated
	"Private - Use the trigger mechanism to notify interested parties that a class has been renamed, 
	and mark all its immediate subclasses as changed since these will need to be filed
	out to record the change in their source definition."

	self environment classUpdated: self currentClass.
	self currentClass subclasses do: [:each | each isChanged: true]!

recompilationRequired
	"Private - Answer whether recompilation of a modified class is required."

	^flags allMask: RecompileMask!

recompilationRequired: aBoolean 
	flags := flags mask: RecompileMask set: aBoolean!

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
			x resignalAs: ((self class invalidRemoveError new)
						originalError: x;
						messageText: 'Error uninitializing ' , currentClass name , ': ' , x description;
						tag: currentClass)].
	self validateForRemove.
	self environment removeClass: currentClass!

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
	currentClass rename: className.
	self notifyClassRenamed!

requiresMutation
	"Private - Answer whether the class being modified needs to have its instances mutated.
	Mutation is required if any of the following aspects of the class are being changed:
		its superclass,
		its instance spec or
		its instance variables."

	^self superclassIsBeingChanged
		or: [self instanceShapeIsBeingChanged
		or: [self instanceVariablesAreBeingChanged]]!

setClassVariablesOf: aClass
	"Private - Set class variables of aClass to those described by
	the receiver's classVariables inst var."

	(classVariables notNil and: [aClass setClassVarNames: self classVariables])
		ifTrue: [self recompilationRequired: true]!

setCommentOf: aClass
	"Private - Set the comment of aClass to the receiver's comment inst var unless it
	is nil in which case make no change."

	comment notNil
		ifTrue: [aClass comment: comment]!

setInstanceVariablesOf: aClass
	"Private - Set the instance variable layout of aClass to those described by the receiver's
	instanceVariables inst var, or those of currentClass if no changes have been proposed."

	aClass setInstanceVariables: self instanceVariables!

setNewClassCategories
	currentClass classCategories: self categories!

setSharedPoolsOf: aClass
	"Private - Set the shared pools of aClass to those described by
	the receiver's sharedPools inst var."

	| oldPoolNames newPoolNames |
	oldPoolNames := aClass sharedPoolNames.
	newPoolNames := self sharedPools.
	(newPoolNames noDifference: oldPoolNames)
		ifFalse: 
			[aClass setSharedPoolNames: newPoolNames.
			self recompilationRequired: true]!

sharedPools
	"Private - Answer an Array of proposed pool dictionary names."

	^sharedPools ifNil: [{}]!

sharedPools: anArray
	"Set the receiver's sharedPools inst var to anArray."

	sharedPools := anArray asArray!

sharedPoolString: aString
	"Set the receiver's sharedPools from the pool name list aString.
	Any duplicate names in the list are dropped."

	self sharedPools: (aString subStrings distinct collect: [:each | each asSymbol])!

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

	currentClass isNil
		ifTrue: [self error: 'Class not found.'].
	(currentClass isKindOf: Behavior)
		ifFalse: [self error: 'Class must be a kind of Behavior.']
!

validateClassForRename
	"Private - Ensure that we are permitted to rename the class."

	self validateClass.
	((FixedLayout includes: currentClass) or: [FixedInitialLayout includes: currentClass])
		ifTrue: [self error: ('<1p> must not be renamed.' expandMacrosWith: currentClass) ].!

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

	classVariables notNil
		ifTrue: [
			self class
				validateClassVars: self classVariables
				againstSuperclass: superclass]!

validateClassVarsForModify
	"Private - Ensure that the proposed class variable name list does not
	contain a reserved word or a duplicate name defined either in the list
	itself or anywhere in the proposed superclass or subclass chain."

	| classVarSet |
	classVarSet := self class
		validateClassVars: self classVariables
		againstSuperclass: superclass.
	currentClass allSubclasses do: [:cls |
		cls classVarNames do: [:name | self class validateClassVarName: name using: classVarSet]]!

validateForCreate
	"Private - Ensure that the proposed class creation would result in a valid new class."

	self
		validateClassName;
		validateSuperclassIsSubclassable;
		validateSuperclassChainForCreate;
		validateInstanceSpec;
		validateInstanceVarsForCreate;
		validateClassVarsForCreate;
		validatePoolNames!

validateForModify
	"Private - Ensure that the proposed class modification would result in a valid class."

	self
		validateClass;
		validateSuperclassForModify;
		validateSuperclassChainForModify;
		validateInstanceSpecForModify;
		validateInstanceVarsForModify;
		validateSubclassInstanceSpecs.
	currentClass isMeta ifFalse: [
		self
			validateClassInstanceVars;
			validateClassVarsForModify;
			validatePoolNames]!

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
		ifTrue: [self error: ('<1s> already exists.' expandMacrosWith: className)]!

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
		ifTrue: [self error: ('You may not change the subclass type of <1p>' expandMacrosWith: currentClass)]
	!

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
			(self isFixedInitialLayout
				and: [(proposedInstVarArray indexOfSubCollection: currentClass instVarNames) ~~ 1])
					ifTrue: [self error: 'New inst vars must come after those already in ' , currentClass name]].
	currentClass allSubclasses
		do: [:cls | cls instVarNames do: [:name | self class validateInstVarName: name using: instVarSet]]!

validatePoolNames
	"Private - Ensure that the proposed pool dictionary names exists in the environment
	and warn if they don't start with an uppercase letter."

	self sharedPools do: 
			[:poolName | 
			| firstChar |
			self environment at: poolName
				ifAbsentPut: 
					[Warning 
						signal: ('Pool dictionary <1p> does not exist.<n>Proceed to create it as an empty constants pool.' 
								expandMacrosWith: poolName).
					PoolConstantsDictionary named: poolName].
			firstChar := poolName first.
			(firstChar isUppercase or: [firstChar == $_]) 
				ifFalse: 
					[Warning 
						signal: ('Pool dictionary <1p> should start with an uppercase letter.' expandMacrosWith: poolName)]]!

validateSubclassesOf: aClass againstInstanceSpec: instSpec 
	"Private - Ensure that if the proposed change to the instance spec of aClass
	is acceptable to all subclasses."

	| dummyClass |
	(dummyClass := Behavior new) instanceSpec: instSpec.
	aClass subclasses do: 
			[:cls | 
			| validatedInstSpec |
			validatedInstSpec := self class 
						validateInstanceSpec: cls instanceSpec
						size: cls instVarNames size
						superclass: dummyClass.
			(self class fundamentalTypeOf: validatedInstSpec) 
				= (self class fundamentalTypeOf: cls instanceSpec) 
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
		ifTrue: [
			((superclass isKindOf: Class) not or: [Unsubclassable includes: superclass])
				ifTrue: [self error: 'Proposed superclass is not subclassable.']].! !

!ClassBuilder categoriesForMethods!
beBytes!class type!private! !
beFixed!class type!private! !
beIndirectBytes!class type!private! !
beNullTerminatedBytes!class type!private! !
beVariable!class type!private! !
canMutateInSitu!mutating!private! !
categories!accessing!private! !
categories:!accessing!private! !
categoryNames:!accessing!public! !
checkNoInstances!private!validation! !
checkNoSubclasses!private!validation! !
class:!accessing!private! !
classCategoryClass!accessing!private! !
className:!accessing!private! !
classVariables!class variables!private! !
classVariables:!class variables!public! !
classVariableString:!class variables!public! !
comment:!comments!private! !
createNewClass!operations!private! !
createProper!helpers!private! !
currentClass!accessing!public! !
environment!environment!private! !
errorInvalidRemove:!exceptions!private! !
fundamentalTypeIsBeingChanged!private!testing! !
generateGUID!operations!private! !
generateInstanceSpecFor:superclass:!class type!private! !
generateMapFrom:to:!mutating!private! !
ignoreInstances!accessing!private! !
ignoreInstances:!accessing!private! !
initialize!initializing!private! !
initializeCopy:fromClass:superclass:!mutating!private! !
install:!environment!private! !
installInSuperclass:!helpers!private! !
installNewClass!environment!private! !
instanceShapeIsBeingChanged!private!testing! !
instanceSpec:!class type!private! !
instanceVariables!instance variables!private! !
instanceVariables:!instance variables!public! !
instanceVariablesAreBeingChanged!private!testing! !
instanceVariableString:!instance variables!public! !
isFixedInitialLayout!public!testing! !
isFixedLayout!public!testing! !
isFixedType!public!testing! !
isModifyAction!private!testing! !
modifyExistingClass!operations!private! !
modifyOrCreate!operations!public! !
modifyPrivate!operations!private! !
modifyProper!private! !
mutateClass:toBeASubclassOf:!mutating!private! !
mutateInSitu!mutating!private! !
mutateInstances:of:toBeInstancesOf:!mutating!private! !
mutateMetaclass:toBeASubclassOf:!mutating!private! !
mutateToNewClass!mutating!private! !
newClassLike:superclass:!mutating!private! !
newMetaclassLike:superclass:!mutating!private! !
notifyClassCreated!public!updating! !
notifyClassRenamed!operations!private! !
notifyClassUpdated!private!updating! !
recompilationRequired!accessing!private! !
recompilationRequired:!accessing!private! !
remove!operations!private! !
removeUnimplementedProtocols!helpers!private! !
rename!operations!private! !
requiresMutation!mutating!private! !
setClassVariablesOf:!class variables!private! !
setCommentOf:!comments!private! !
setInstanceVariablesOf:!instance variables!private! !
setNewClassCategories!helpers!public! !
setSharedPoolsOf:!pool dictionaries!private! !
sharedPools!pool dictionaries!private! !
sharedPools:!pool dictionaries!public! !
sharedPoolString:!pool dictionaries!public! !
superclass:!accessing!private! !
superclassIsBeingChanged!private!testing! !
translateInstance:intoANewInstanceOf:via:!mutating!private! !
updateVMRegistryWith:!mutating!private! !
validateClass!private!validation! !
validateClassForRename!private!validation! !
validateClassInstanceVars!private!validation! !
validateClassName!private!validation! !
validateClassVarsForCreate!private!validation! !
validateClassVarsForModify!private!validation! !
validateForCreate!private!validation! !
validateForModify!private!validation! !
validateForRemove!private!validation! !
validateForRename!private!validation! !
validateInstanceSpec!private!validation! !
validateInstanceSpecForModify!private!validation! !
validateInstanceVarsForCreate!private!validation! !
validateInstanceVarsForModify!private!validation! !
validatePoolNames!private!validation! !
validateSubclassesOf:againstInstanceSpec:!private!validation! !
validateSubclassInstanceSpecs!private!validation! !
validateSuperclassChainForCreate!private!validation! !
validateSuperclassChainForModify!private!validation! !
validateSuperclassForModify!private!validation! !
validateSuperclassIsSubclassable!private!validation! !
!

!ClassBuilder class methodsFor!

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

	^(self new)
		class: aClass;
		superclass: aClass superclass;
		instanceVariables: aClass instVarNames;
		classVariables: aClass classVarNames;
		sharedPools: aClass sharedPoolNames;
		yourself!

fundamentalTypeOf: anInstanceSpec
	"Private - Answer the combined settings of the isVariable and isPointers flags of anInstanceSpec."

	^anInstanceSpec bitAnd: Behavior._VariableMask + Behavior._PointersMask!

initialize
	"Initialize the receiver's class variables.
		ClassBuilder initialize
	"

	self addClassConstant: 'Unsubclassable'
		value: ((Set new)
				add: Character;
				add: SmallInteger;
				shrink;
				isImmutable: true;
				yourself).
	self addClassConstant: 'FixedLayout'
		value: ((Set new)
				add: true class;
				add: false class;
				add: Array;
				add: VariableBinding;
				add: Character;
				add: SmallInteger;
				add: BlockClosure;
				add: Context;
				add: ExternalMethod;
				add: ExternalAddress;
				add: Message;
				add: MethodDictionary;
				add: UndefinedObject;
				add: Object;
				shrink;
				isImmutable: true;
				yourself).
	"add: ProtoObject;"
	self addClassConstant: 'FixedInitialLayout'
		value: ((Set new)
				add: Class;
				add: Metaclass;
				add: PositionableStream;
				add: Semaphore;
				add: Process;
				add: ProcessorScheduler;
				shrink;
				isImmutable: true;
				yourself).
	self addClassConstant: 'RecompileMask' value: 1.
	self addClassConstant: 'IgnoreInstsMask' value: 2!

instanceSpecIsBytes: anInstanceSpec
	"Private - Answer whether anInstanceSpec represents a byte subclass."

	^(anInstanceSpec anyMask: Behavior._PointersMask) not!

instanceSpecWithFixedPointers: anInteger
	"Private - Answer an instance spec based on anInteger but adjusted to represent instances
	containing named instance vars only."

	^Behavior._PointersMask bitOr: (anInteger bitAnd: Behavior._SizeMask)!

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

	^(self isValidIdentifier: aString) and: [aString first == $_ or: [aString first isUppercase]]!

isValidIdentifier: aString 
	(aString isEmpty or: [self isValidInitialIdentifierChar: aString first]) ifFalse: [^false].
	2 to: aString size do: [:i | (self isValidIdentifierChar: (aString at: i)) ifFalse: [^false]].
	^(##(Set withAll: #('self' 'super' 'nil' 'true' 'false' 'thisContext' '_')) includes: aString asString) not!

isValidIdentifierChar: aCharacter 
	^(self isValidInitialIdentifierChar: aCharacter) or: [aCharacter isDigit]!

isValidInitialIdentifierChar: aCharacter 
	^aCharacter == $_ or: [aCharacter isLetter]!

moveClass: aClass toSuperclass: aSuperclass
	"Move aClass to be subclassed from aSuperclass."

	self new
		class: aClass;
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
		rename
!

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
	Warning signal: ('Proposed class variable <1p> should start with an uppercase letter.'
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
		ifTrue: [spec := self validateSpecAsVariableBytes: spec size: anInteger superclass: proposedSuperclass].
	fundamentalType = Behavior._PointersMask
		ifTrue: [spec := self validateSpecAsFixedPointers: spec size: anInteger superclass: proposedSuperclass].
	fundamentalType = (Behavior._VariableMask + Behavior._PointersMask)
		ifTrue: [spec := self validateSpecAsVariablePointers: spec size: anInteger superclass: proposedSuperclass].
	fixedSize := anInteger + (self instSizeOf: proposedSuperclass).
	fixedSize > Behavior._SizeMask
		ifTrue: [self error: ('Classes are allowed a maximum of <1d> instance variables.' expandMacrosWith: Behavior._SizeMask)].
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

!ClassBuilder class categoriesForMethods!
allClassVarNamesOf:!helpers!private! !
allInstVarNamesOf:!helpers!private! !
classOf:!helpers!private! !
forModifying:!instance creation!public! !
fundamentalTypeOf:!class type!private! !
initialize!development!initializing!public! !
instanceSpecIsBytes:!class type!private! !
instanceSpecWithFixedPointers:!class type!private! !
instanceSpecWithIndirectBytes!class type!private! !
instanceSpecWithNullTerminatedBytes!class type!private! !
instanceSpecWithVariableBytes:!class type!private! !
instanceSpecWithVariablePointers:!class type!private! !
instSizeOf:!helpers!private! !
invalidRemoveError!constants!private! !
isFixedLayout:!enquiries!public! !
isValidClassName:!private!testing! !
isValidIdentifier:!private!testing! !
isValidIdentifierChar:!private!testing! !
isValidInitialIdentifierChar:!private!testing! !
moveClass:toSuperclass:!operations!public! !
new!instance creation!public! !
removeClass:!operations!public! !
removeClass:ignoreInstances:!operations!public! !
renameClass:to:!operations!public! !
validateClassVarName:using:!private!validation! !
validateClassVars:againstSuperclass:!private!validation! !
validateInstanceSpec:size:superclass:!private!validation! !
validateInstanceVars:againstSuperclass:!private!validation! !
validateInstVarName:using:!private!validation! !
validateSpecAsFixedPointers:size:superclass:!private!validation! !
validateSpecAsVariableBytes:size:superclass:!private!validation! !
validateSpecAsVariablePointers:size:superclass:!private!validation! !
!

