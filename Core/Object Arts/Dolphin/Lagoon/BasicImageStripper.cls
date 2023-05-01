"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #BasicImageStripper
	instanceVariableNames: 'events'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
BasicImageStripper guid: (Core.GUID fromString: '{51ce4971-61e8-431f-9823-437cf7293e8a}')!
BasicImageStripper isNonInstantiable: true!
BasicImageStripper comment: 'Base image stripping methods. These can safely be encrypted during release.'!
!BasicImageStripper categoriesForClass!MVP-Models! !
!BasicImageStripper methodsFor!

_actualRequiredPackages
	"Private - Answer the <collection> of <Package>s to be included in the deployed application."

	^self _systemPackageManager packages!

_allMethodsInClasses: classes do: operation
	"Private - Evaluate the <monadicValuable>, operation, for each and every method
	in the <collection> of <Class>es, classes."

	classes do: 
			[:eachClass |
			eachClass methodDictionary do: operation.
			eachClass class methodDictionary do: operation]!

_allReferencedClasses
	^Class allClasses!

_basicDeleteClass: aClass
	"Private - Remove the specified class from the system. Note that we do not use the ClassBuilder for this purpose."

	| subs |
	[aClass uninitializeBeforeRemove] on: Error
		do: 
			[:x |
			| msg |
			msg := 'Error uninitializing ' , aClass fullName , ': ' , x description.
			VM dump: msg path: nil stackDepth: 0 walkbackDepth: -1.
			self
				_logElement: 'Error'
				attributes: {'class' -> x class fullName}
				value: msg].
	aClass classPool associationsDo: [:var | var environment: nil].
	aClass basicClassPool: nil.
	subs := aClass subclasses.
	subs notEmpty
		ifTrue: 
			[Notification signal: (String writeStream
						print: aClass;
						nextPutAll: ' has ';
						display: subs size;
						nextPutAll: ' subclasses';
						contents)].
	self _detachClass: aClass!

_basicDeleteMethod: aCompiledMethod
	self _logMethod: aCompiledMethod.
	aCompiledMethod methodClass methodDictionary removeKey: aCompiledMethod selector ifAbsent: nil	"Could be in a weakly held development class which has evaporated"!

_collectGarbage: iterations
	"Private - Perform a few GC's to clear away old stuff.
	Note that we explicitly clear down the finalization queue each time."

	| memMan |
	Smalltalk clearCachedClasses.
	BindingReference flushBindings.
	memMan := MemoryManager current.
	iterations timesRepeat: 
			[memMan
				collectGarbage;
				administerLastRites]!

_compileExternalStructuresNow: aCollection
	"Private - Fully compile all ExternalStructure subclasses so that the template definitions and
	the AttributeDescriptor subclasses may be removed. In order to do this we forcibly and
	fully compile all the ExternalStructure accessor methods before removing the templates. If we
	do not, the templates will be required when #doesNotUnderstand: handles an accessor
	message for a field that is not normally compiled."

	self _notify: 'Fully compiling ExternalStructures'.
	self _startElement: 'CompileExternalStructures' attributes: #().
	self _systemPackageManager noEventsDo: 
			[aCollection do: [:each | each fullyCompileDefinition].
			"Lazy template definition is not required (or possible), so stub it out"
			External.Structure class compile: 'ensureDefined ^nil'.
			External.Structure removeTemplate.
			aCollection do: [:each | each removeTemplate].
			"ExternalStructure DNU processing is no longer needed since fully compiled"
			self _removeSelectors: #(#getFieldNames #canUnderstand: #dynamicSelectorsDo: #offsetOf:)
				of: External.Structure class.
			self _removeSelectors: #(#doesNotUnderstand:) of: External.Structure].
	"Field meta-data classes are no longer required"
	self _deleteFieldClasses.
	self _endElement: true.
	self _finishedWithAll: #(#_deleteFieldClasses)!

_defineExternalStructures: aCollection
	"Private - Ensure that all external structures are fully defined to avoid any recompilation that might
	otherwise be triggered in a run-time image should the size be lazily determined."

	self _notify: 'Building all ExternalStructure templates'.
	self
		_logElement: 'DefineExternalStructures'
		attributes: #()
		value: nil.
	self _systemPackageManager noEventsDo: [aCollection do: [:each | each ensureDefined]]!

_deleteClass: aClass
	"Private - Removes aClass from the image. Answer the number of classes that
	were actually removed (subclasses may be removed too)."

	(aClass environment localBindingFor: aClass unqualifiedName) ifNil: [^0].
	^self _uncheckedDeleteClass: aClass!

_deleteClasses: aCollection reason: aString
	| count |
	aCollection isEmpty ifTrue: [^0].
	count := 0.
	self _startElement: 'StripClasses' attributes: {'reason' -> aString}.
	aCollection do: [:each | count := count + (self _deleteClass: each)].
	self _endElement: count > 0.
	^count!

_deleteFieldClasses
	self assert: [self _systemPackageManager isProcessingEvents].
	self _startElement: 'StripClasses' attributes: {'reason' -> 'structure field descriptors'}.
	#{Smalltalk.ExternalField} undeclare.
	#(#{External.Field} #{External.ArrayFieldLength})
		do: [:each | self _uncheckedDeleteClass: each value].
	self _endElement: true!

_deleteMethods: aCollection
	aCollection asArray sort do: [:each | self _basicDeleteMethod: each].
	Object flushMethodCache!

_deleteResource: aResourceIdentifier
	self
		_logElement: 'RemoveResource'
		attributes: {'owningClass' -> aResourceIdentifier owningClass fullName}
		value: aResourceIdentifier name.
	ResourceIdentifier removeResource: aResourceIdentifier!

_deleteResources: aCollection reason: aString
	aCollection isEmpty ifTrue: [^0].
	self _startElement: 'StripResources' attributes: {'reason' -> aString}.
	aCollection do: [:each | self _deleteResource: each].
	self _endElement: true.
	^aCollection size!

_deploymentContext
	^DeafObject.Current!

_destroyAndRemoveProgress
	"Private - Destroy the progress view and remove its class if possible."

	self
		_logElement: 'CloseProgressDialog'
		attributes: #()
		value: nil.
	
	[self _destroyNotifier.
	SessionManager inputState
		pumpMessages;
		processDeferredActions.
	SessionManager current isConsoleApplication ifTrue: [self _removeGuiForConsoleApplication].

	"Ensure RichText converter is not hanging around unecessarily"
	#{UI.RichText} ifDefined: [:rt | rt uninitialize].
	SessionManager inputState purgeDeadWindows]
			on: Error
			do: 
				[:e |
				self _deploymentContext _logStrippingError: e.
				VM crashDump: e description].
	self _collectGarbage: 3.
	self _finishedWithAll: #(#_destroyNotifier #progressDialogClass #_removeGuiForConsoleApplication)!

_destroyNotifier
	self _deploymentContext _destroyNotifier!

_detachClass: aClass
	Smalltalk removeClass: aClass.
	aClass environment: nil!

_endElement: aBoolean
	self _deploymentContext _endElement: aBoolean!

_endTag
	self _deploymentContext _endTag!

_externalStructureClasses
	^External.Structure allSubclasses!

_finishedWithAll: aCollectionOfSymbols
	"Private - The receiver has finished with its method identified by the selectors in the <collection> argument, so they can be stripped. We do this by removing them up the inheritance chain, but stopping at BasicImageStripper."

	aCollectionOfSymbols do: 
			[:each |
			| current removed |
			current := self class.
			removed := false.
			[current name == #Object] whileFalse: 
					[(current methodDictionary removeKey: each ifAbsent: nil) ifNotNil: [removed := true].
					current := current superclass].
			removed ifFalse: [self _notify: self class name , ' hierarchy does not define ' , each printString]].
	Object flushMethodCache!

_foldDuplicateBytecodes
	"Private - Eliminate duplicate byte code arrays"

	| byteCodes total |
	self stripDuplicateBytecodes ifFalse: [^self].
	self _notify: 'Folding duplicate byte codes'.
	total := 0.
	byteCodes := Set new.
	self _allMethodsInClasses: Class allClasses
		do: 
			[:each |
			each isPacked
				ifFalse: 
					[| bytes |
					total := total + 1.
					bytes := each byteCodes.
					byteCodes add: bytes.
					each setByteCodes: (byteCodes find: bytes)]].
	self
		_logFold: 'FoldBytecodes'
		folded: total - byteCodes size
		total: total!

_foldDuplicateLiterals
	| a |
	self stripDuplicateStrings ifFalse: [^self].
	self _notify: 'Folding duplicate strings'.
	a := Class foldLiterals at: #strings.
	self
		_logFold: 'FoldStrings'
		folded: a first - a second
		total: a first!

_logComment: aString
	self _deploymentContext _logComment: aString!

_logElement: aString attributes: aCollection value: anObject
	self _deploymentContext
		_logElement: aString
		attributes: aCollection
		value: anObject!

_logFold: aString folded: count total: total
	self
		_startElement: aString attributes: #();
		_logElement: 'Total'
			attributes: #()
			value: total;
		_logElement: 'Folded'
			attributes: #()
			value: count;
		_endElement: true!

_logMethod: aCompiledMethod
	self
		_logElement: 'Method'
		attributes: {'methodClass' -> aCompiledMethod methodClass fullName}
		value: aCompiledMethod selector!

_messagesSentByClasses: aCollectionOfClasses
	| sent |
	sent := (Set new: aCollectionOfClasses size * 10)
				addAll: self _speciallySentMessages;
				yourself.	"presize for an average of 10 unique sends per class"
	self _allMethodsInClasses: aCollectionOfClasses
		do: 
			[:eachMethod |
			| selector |
			selector := eachMethod selector.
			eachMethod allSymbolLiteralsDo: 
					[:eachSymbol |
					"Note that self references are now excluded to prevent this particular form of
					 circular reference preventing a method from being stripped"
					eachSymbol == selector ifFalse: [sent add: eachSymbol]]].

	"Add all messages that can be triggered by events"
	_EventsRegister do: [:each | each do: [:mseq | mseq messages do: [:ms | sent add: ms selector]]].
	^sent!

_notify: aStringMessage
	self _deploymentContext _notify: aStringMessage!

_onNotification: aNotification
	self _notify: aNotification description!

_prepareExternalStructures
	"Private - Fully compile all ExternalStructure subclasses if required. They must already
	have fully defined templates."

	| structs defineFields |
	structs := self _externalStructureClasses.
	self _defineExternalStructures: structs.
	self _startElement: 'PrepareExternalStructures' attributes: #().
	self compileExternalStructures ifTrue: [self _compileExternalStructuresNow: structs].
	"Having defined all the templates, we can now remove the methods used to define them"
	"Remove the structure template definition and compiling mechanisms"
	#('compiling' 'template definition') do: 
			[:each |
			self
				_removeMethods: (each asMethodCategory methodsInBehavior: External.Structure class)
				reason: 'structure definition: ' , each
				force: true].
	"Remove all Structure defineFields methods"
	defineFields := IdentitySet new.
	structs do: [:each | defineFields add: (each class compiledMethodAt: #defineFields ifAbsent: nil)].
	self
		_removeMethods: defineFields
		reason: 'structure definition: defineFields'
		force: true.
	self _endElement: true.
	self
		_finishedWithAll: #(#compileExternalStructures #_compileExternalStructuresNow: #_defineExternalStructures: #_prepareExternalStructures #_externalStructureClasses)!

_preStripTidy
	"Private - Remove any methods of ImageStripper that are no longer required to ensure these don't impact the calculated package pre-reqs when they are determined"

	self _finishedWithAll: #(#initialize #notRequiredMethodCategories #stbSaveOn:)!

_purgeStubbornClass: aClass
	"Private - Remove what we can of a stubborn class that refuses to uninstall for some reason."

	!

_removeCategoryManagement
	"Private - Remove categories information"

	self _notify: 'Removing code categories'.
	self
		_logElement: 'RemoveCategoryManagement'
		attributes: #()
		value: nil.
	Behavior allSubinstances do: 
			[:each |
			each methodsCatalogue: nil.
			each isMeta
				ifFalse: 
					[each
						classCategories: #();
						sourceDescriptor: nil]].

	"Uninitialize the category management system (don't remove it - it will be removed if unused, depending on stripping options)."
	#(#{Core.Category} #{Core.ClassCategory} #{Core.MethodCategory})
		do: [:each | each ifDefined: [:c | c uninitialize]]!

_removeClassBuilder: anArray
	"Private - Remove the ClassBuilder if so configured."

	!

_removeClassMetaInfo
	"Private - Remove all (presumably) redundant class info"

	self stripClassInfo
		ifTrue: 
			[| keepInstVars |
			self _startElement: 'RemoveClassMetaInfo' attributes: #().
			keepInstVars := self retainInstVarNames.
			Class allClassesDo: 
					[:each |
					| classPool newPool |
					"We used to empty the class pool entirely here, but it is certainly not safe to do that for Namespace classes.
					We now remove all the class vars and clear the environment back pointer."
					classPool := each classPool.
					newPool := classPool class new.
					classPool
						associationsDo: [:var | var isClassVariable ifTrue: [var environment: nil] ifFalse: [newPool add: var]].
					each basicClassPool: newPool.

					"We can't nil out the imports in general, as these are required to resolve BindingReferences that are not fully qualified."

					"each imports: #()."

					"If retaining inst vars, they are collapsed into a string for compactness"
					each instanceVariableString: (keepInstVars ifTrue: [each instanceVariableString])].
			self _endTag]!

_removeClassUninstallation: aCollection
	"Private - Removal of classes has finished. If the image doesn't have the ClassBuilder in it, 
	remove any uninitializers as they will not be needed."

	self _startElement: 'StripClassRemoval' attributes: #().
	(Kernel localBindingFor: 'ClassBuilder')
		ifNil: 
			[self _deleteMethods: aCollection.
			"Remove any remaining class uninitialize methods that may be miscategorized"
			Class
				allClassesDo: [:each | self _removeSelectors: #('uninitialize' 'uninitializeBeforeRemove') of: each class]]
		ifNotNil: [Notification signal: 'ClassBuilder still present, no action taken'].
	self _endElement: true.
	self
		_finishedWithAll: #(#_addClassesReferencedByClass:to: #_addClassesReferencedByMethod:to: #_allReferencedClasses #_basicDeleteClass: #_classesReferencedByMethod: #_classReferencesToIgnore #emptyMethodDictionariesOfStubbornClasses #notRequiredClasses #_purgeStubbornClass: #_deleteClass: #_deleteClasses:reason: #_removeSelectors:of: #_rootClasses #_removeClassUninstallation: #stripRedundantClasses #_uncheckedDeleteClass: #_hiddenClassReferencesInResourceMethod:).
	self _collectGarbage: 3!

_removeDevelopmentInfo
	"Private - Remove development structures, etc."

	self _startElement: 'StripDevelopmentInfo' attributes: #().
	self _removeCategoryManagement.
	self _removeProtocolManagement.
	#{SmalltalkSystem} ifDefined: [:smsys | smsys reset].
	Class allSubinstances do: 
			[:b |
			b removePropertyAt: #changeIndex ifAbsent: nil.
			"Remove all source references (may be LargeIntegers)"
			b methodDictionary do: [:m | m sourceDescriptor: nil].
			b class methodDictionary do: [:m | m sourceDescriptor: nil]].
	self _collectGarbage: 3.
	self _endElement: true.
	self _finishedWithAll: #(#_removeCategoryManagement #_removeProtocolManagement)!

_removeDevelopmentResources
	"Private - Remove development classes resources. We can't actually remove the classes themselves yet since some are required by the remainder of the stripping process. 
	By removing the resources we give the class/method strip that follows the best chance of isolating redundant items."

	self _deleteResources: self developmentResources reason: 'development'.
	self _finishedWithAll: #(#developmentResources)!

_removeDevelopmentSystemResidue
	"Private - Remove all the development stuff that we can."

	"First Remove development classes resources. We can't actually remove the
	classes themselves yet since some are required by the remainder of the 
	stripping process. By removing the resources we give the  class/method strip
	that follows the best chance of isolating redundant items"

	self _removeDevelopmentResources.

	"Before attempting to remove any classes, clear away any development instances and refs"
	self _removeDevelopmentInfo.
	self _removePackageManagement.
	self _removeNotRequiredClasses.
	self
		_finishedWithAll: #(#_removeDevelopmentResources #_removeDevelopmentInfo #_removePackageManagement #_removeNotRequiredClasses)!

_removeGuiForConsoleApplication
	"Private - A console application is being deployed, so uninitialize parts of the GUI system
	that will allow the entire View hierarchy, etc, to be removed."

	self _startElement: 'StripConsoleApplication' attributes: #().
	#(#{Kernel.ImageRelativeFileLocator} #{Kernel.InstallRelativeFileLocator})
		do: [:each | each ifDefined: [:class | class uninitialize]].
	#{UI.View} isDefined ifFalse: [VM unregisterObject: #wndProc:message:wParam:lParam:cookie:].
	self _collectGarbage: 3.
	self _endElement: true!

_removeMethods: aCollection reason: aString force: aBoolean
	"Private - Removes the <collection> of <CompiledMethod>s, methods, from the image."

	| toRemove |
	toRemove := aBoolean
				ifTrue: [aCollection]
				ifFalse: [aCollection reject: [:each | self _shouldPreserveMethod: each]].
	toRemove isEmpty ifTrue: [^0].
	self _startElement: 'StripMethods' attributes: {'reason' -> aString}.
	self _deleteMethods: toRemove.
	self _endElement: true.
	^toRemove size!

_removeNotRequiredClasses
	"Private - Strip the classes that are explicitly listed as not being required,
	but only if the 'strip redundant classes' option was selected."

	self _deleteClasses: self notRequiredClasses reason: 'not required'!

_removeNotRequiredMethods
	"Private - Strip the methods that must be removed due to membership of one of
	the special 'must strip' categories. Note that we collect all first before removing
	any to avoid any problems caused by the categories being out of date with
	respect to the actual selectors in the class."

	"This method must be run BEFORE package pre-requisites are calculated in order to
	be sure that all methods causing undesirable dependencies are removed first."

	| notRequired |
	self _notify: 'Removing methods that are not required or which must be stripped'.
	self _startElement: 'ForcedStripMethods' attributes: #().
	notRequired := self notRequiredMethodCategories
				collect: [:category | {category. category asMethodCategory methods}].
	self stripClassInitializers
		ifTrue: 
			[| initializers mustkeep |
			initializers := Set new.
			mustkeep := 'must not strip' asMethodCategory.
			Class allClasses do: 
					[:each |
					(each class compiledMethodAt: #initialize ifAbsent: nil)
						ifNotNil: [:method | (mustkeep includesMethod: method) ifFalse: [initializers add: method]]].
			notRequired add: {'class initializers'. initializers}].
	notRequired do: 
			[:pair |
			| methods |
			methods := pair at: 2.
			methods size > 0
				ifTrue: 
					["We don't go through #removeMethods:notifying:, since we want the packages to be updated to reflect the lost methods so that when their pre-requisites are recalculated the removed methods do not affect the result."
					self _startElement: 'StripMethods' attributes: {'reason' -> (pair at: 1)}.
					(methods asSortedArray: 
							[:a :b |
							a methodClass name < b methodClass name
								or: [a methodClass == b methodClass and: [a selector < b selector]]])
						do: 
							[:each |
							self _logMethod: each.
							each methodClass removeSelector: each selector ifAbsent: nil].
					self _endElement: true.
					self]].
	self _endElement: true.
	self _preStripTidy!

_removePackageManagement
	"Private - Remove packages structure."

	| methods |
	self _startElement: 'StripPackageManagement' attributes: #().
	self _systemPackageManager class reset.
	"Note that we must leave the #owningPackage definition in ClassDescription for potential runtime STB use"
	methods := Set new.
	#(#{PoolDictionary} #{ResourceIdentifier} #{CompiledMethod})
		do: [:each | each ifDefined: [:class | methods add: (class compiledMethodAt: #owningPackage ifAbsent: nil)]].
	self
		_removeMethods: methods
		reason: 'package management'
		force: true.
	self _finishedWithAll: #(#_systemPackageManager).
	self _endElement: true!

_removeProtocolManagement
	"Private - Remove protocol information. Note that only the MethodProtocol objects
	themselves are removed, not the list of protocol names stored in each
	class."

	self
		_logElement: 'RemoveMethodProtocols'
		attributes: #()
		value: nil.
	#{Kernel.MethodProtocol} ifDefined: [:p | p initializeProtocols]!

_removeRedundantClassesAndResources: stripResources
	"Private - Removes redundant classes from the current image. A redundant class is one
	that has no current instances in the image and is not referenced by any of the root classes
	of the receiver. Answer the number of classes that were actually removed."

	| referencedClasses count msg |
	self stripRedundantClasses ifFalse: [^0].
	count := 0.

	"Find classes that are redundant"
	msg := 'Removing redundant classes'.
	stripResources ifTrue: [msg := msg , ' and resources'].
	self _notify: msg , '…'.
	self _collectGarbage: 3.
	referencedClasses := self _allReferencedClasses.
	stripResources ifTrue: [count := count + (self _removeRedundantResources: referencedClasses)].
	^count + (self _deleteClasses: (Class allClasses reject: [:e | referencedClasses includes: e])
				reason: 'unreferenced')!

_removeRedundantMethods
	"Private - Removes redundant methods from the pseudo image.
	Answers the count of methods stripped"

	^0!

_removeRedundantMethodsOnceFrom: aCollectionOfClasses
	"Private - Removes redundant methods from the pseudo image.
	Answers the count of methods stripped"

	| redundantMessages redundantMethods sent implemented |
	self stripRedundantMethods ifFalse: [^0].
	self _notify: 'Removing redundant methods…'.
	self _collectGarbage: 1.
	sent := self _messagesSentByClasses: aCollectionOfClasses.
	implemented := Set new: aCollectionOfClasses size * 12.
	self _allMethodsInClasses: aCollectionOfClasses do: [:each | implemented add: each selector].
	redundantMessages := implemented reject: [:each | sent includes: each].
	redundantMessages isEmpty ifTrue: [^0].
	redundantMethods := OrderedCollection new.
	self _allMethodsInClasses: aCollectionOfClasses
		do: [:each | (redundantMessages includes: each selector) ifTrue: [redundantMethods addLast: each]].
	^self
		_removeMethods: redundantMethods
		reason: 'unsent'
		force: false!

_removeRedundantObjects: stripResources id: anInteger
	"Private - Cycle around removing redundant classes and methods until all remaining
	classes and methods appear to be required to complete the deployed image."

	
	[| continue |
	self _startElement: 'StripCycle' attributes: {'id' -> anInteger}.
	continue := (self
				_removeRedundantClassesAndResources: (stripResources and: [self _shouldRemoveResources]))
					+ self _removeRedundantMethods > 0.
	self _endElement: continue.
	continue]
			whileTrue!

_removeRedundantPackages
	"Private - Strips the unwanted packages from the image."

	| redundantPackages required pacman |
	[required := self _verifyRequiredPackages] on: Warning
		do: 
			[:warning |
			warning resume: (User32
						messageBox: nil
						lpText: warning description
						lpCaption: SessionManager current applicationName
						uType: ##(OS.MessageBoxConstants.MB_OK | OS.MessageBoxConstants.MB_TASKMODAL
								| OS.MessageBoxConstants.MB_SETFOREGROUND))].
	self stripRedundantPackages ifFalse: [^required].
	pacman := self _systemPackageManager.
	redundantPackages := pacman packages asArray reject: [:each | required includes: each].
	"Turn off events to prevent repeated tracing of pre-reqs as each of the redundant packages
	 is uninstalled."
	pacman beNotProcessingEvents.
	"We don't want to uninstall the DevelopmentSessionManager until it has been replaced by the run-time session manager"
	pacman addClass: SessionManager current class to: nil.
	self _startElement: 'RedundantPackages' attributes: #().
	(redundantPackages asSortedArray: [:a :b | a name < b name]) do: 
			[:each |
			self
				_logElement: 'Package'
				attributes: #()
				value: each].
	self _endElement: true.
	self _notify: 'Removing unwanted packages'.
	self _startElement: 'StripPackages' attributes: #().
	"Add the Legacy Source Filer last as a prereq of any legacy package with an uninstall script as it will need it to uninstall successfully"
	redundantPackages do: 
			[:each |
			(each scriptAt: #preuninstall) isEmpty
				ifFalse: 
					[each manualPrerequisites: (each manualPrerequisites
								addLast: 'Dolphin Legacy Package Support';
								yourself)]].
	[redundantPackages do: 
			[:each |
			pacman uninstall: each.
			self _collectGarbage: 2]]
		on: ClassBuilder invalidRemoveError
		do: 
			[:e |
			self _onNotification: e.
			self _purgeStubbornClass: e tag.
			e resume: true].	"Remove classes regardless"
	self _endElement: true.
	pacman beProcessingEvents.
	^required!

_removeRedundantResources: referencedClasses
	^0!

_removeSelectors: aCollectionOfSelectors of: aBehavior
	| methods |
	methods := Set new.
	aCollectionOfSelectors do: 
			[:each |
			(aBehavior compiledMethodAt: each asSymbol ifAbsent: nil) ifNotNil: [:method | methods add: method]].
	self
		_removeMethods: methods
		reason: 'explicit'
		force: true!

_rootClasses
	^#()!

_shouldPreserveMethod: aCompiledMethod
	^true!

_shouldRemoveResources
	^self stripRedundantResources!

_shrinkEventsOf: anObject
	anObject setEvents: (anObject getEvents ifNotNil: [:subs | subs shrink asMinimumRepresentation])!

_shrinkEventsRegister
	_EventsRegister keys do: [:each | self _shrinkEventsOf: each].
	self _shrinkEventsOf: SessionManager current!

_speciallySentMessages
	"Private - A number of messages can be sent without  appearing in the literal
	frame of any method. Answer a Set of these selectors here."

	^VMLibrary.Registry select: [:each | each ~~ #namespace: and: [each class == Symbol]]!

_startElement: aString attributes: aCollectionOfAttributes
	self _deploymentContext _startElement: aString attributes: aCollectionOfAttributes!

_systemPackageManager
	"Private - Answer the package manager to be used by the receiver.
	N.B. All references to PackageManager must be through this accessor
	to prevent the PackageManager and Package classes remaining in the
	deployed image."

	^(#{Kernel.Package} valueOrNil ?? DeafObject current) manager!

_uncheckedDeleteClass: aClass
	| removed |
	removed := aClass allSubclasses inject: 0 into: [:sum :each | sum + (self _deleteClass: each)].	"First remove subclasses"
	"Remove any nested classes"
	aClass bindingsDo: 
			[:each |
			| value |
			(each isClassVariable not and: 
					[value := each value.
					value class isMeta and: [value environment == aClass]])
				ifTrue: [removed := removed + (self _deleteClass: value)]].
	self
		_logElement: 'RemoveClass'
		attributes: #()
		value: aClass fullName.
	^
	[self _basicDeleteClass: aClass.
	aClass clearGuid.
	removed + 1] on: Error
			do: 
				[:ex |
				self _deploymentContext _logStrippingError: ex.
				aClass primAllInstances do: [:each | Notification signal: each printString].
				self _purgeStubbornClass: aClass.
				removed]!

_verifyRequiredPackages
	"Private - Answer the <collection> of <Package>s to be included in the deployed application, verifying that they are deployable."

	| packages |
	packages := self _actualRequiredPackages.
	packages do: [:each | each okToSaveOrDeploy].
	^packages!

compileExternalStructures
	^false!

developmentResources
	"Answer a <collection> of <ResourceIdentifier>s representing any development system resources that
	are not owned directly by development classes."

	^#()!

emptyMethodDictionariesOfStubbornClasses
	"Answer whether the method dictionaries of classes that refuse to uninstall with their
	owning package should be emptied. Although this is somewhat of a risky option, it does
	help one to track down the root of stripping problems since it helps to remove the knock
	on effects of the original source of the problem."

	^false.!

notRequiredClasses
	"Answer an <collection> of Classes that are known to be not required and that
	should be forcibly dropped during an image strip. Can be overridden by subclasses 
	to alter the stripping strategy"

	^Set new!

notRequiredMethodCategories
	"Answer an IdentitySet of MethodCategorys whose methods are known to be not required
	and should be forcibly dropped during an image strip. Can be overridden by subclasses to 
	alter the stripping strategy"

	^#()

!

retainInstVarNames
	"Answer whether the stripping process should preserve instance variable names.
	Normally these are not required unless certain reflective messages are used."

	^true!

stbSaveOn: anSTBOutFiler
	"Output the receiver to anSTBOutFiler. We must ensure that the local events collection
	is NOT saved to the filer"

	anSTBOutFiler override: events with: nil.
	super stbSaveOn: anSTBOutFiler.!

stripClassBuilder
	^false!

stripClassInfo
	"Answer true if the stripping process will remove class information such as instance variable names, pools names and comments"

	^false!

stripClassInitializers
	"Answer whether class-side initialize methods should be removed. By convention these are assumed to be used to initialize classes only as they are loaded, and therefore should not be required in a deployed application."

	^self stripRedundantMethods!

stripDuplicateBytecodes
	"Answer true if the stripping process will fold instances of duplicate byte code arrays 
	into one common instance"

	^false!

stripDuplicateStrings
	"Answer true if the stripping process will fold instances of duplicate strings
	into one common instance"

	^false!

stripRedundantClasses
	"Answer true if the receiver will attempt to remove redundant classes not
	required in the deployed application."

	^false!

stripRedundantMethods
	"Answer true if the receiver will attempt to remove methods that will not be
	referenced in the deployed application."

	^false!

stripRedundantPackages
	"Answer true if the receiver will attempt to remove redundant packages not
	referenced from a root package during its stripping process."

	^false!

stripRedundantResources
	"Answer true if the receiver will attempt to remove resources that are not required in the
	deployed application."

	^false! !
!BasicImageStripper categoriesForMethods!
_actualRequiredPackages!private! !
_allMethodsInClasses:do:!helpers!private! !
_allReferencedClasses!operations!private! !
_basicDeleteClass:!helpers!private! !
_basicDeleteMethod:!private!removing! !
_collectGarbage:!operations!private! !
_compileExternalStructuresNow:!operations!private! !
_defineExternalStructures:!operations!private! !
_deleteClass:!helpers!private! !
_deleteClasses:reason:!operations!private! !
_deleteFieldClasses!operations!private! !
_deleteMethods:!private!removing! !
_deleteResource:!operations!private! !
_deleteResources:reason:!operations!private! !
_deploymentContext!accessing!private! !
_destroyAndRemoveProgress!operations!private! !
_destroyNotifier!operations!private! !
_detachClass:!helpers!private! !
_endElement:!logging!private! !
_endTag!logging!private! !
_externalStructureClasses!accessing!private! !
_finishedWithAll:!operations!private! !
_foldDuplicateBytecodes!operations!private! !
_foldDuplicateLiterals!operations!private! !
_logComment:!logging!private! !
_logElement:attributes:value:!logging!private! !
_logFold:folded:total:!operations!private! !
_logMethod:!operations!private! !
_messagesSentByClasses:!helpers!private! !
_notify:!logging!private! !
_onNotification:!event handling!private! !
_prepareExternalStructures!operations!private! !
_preStripTidy!operations!private! !
_purgeStubbornClass:!operations!private! !
_removeCategoryManagement!operations!private! !
_removeClassBuilder:!operations!private! !
_removeClassMetaInfo!operations!private! !
_removeClassUninstallation:!operations!private! !
_removeDevelopmentInfo!operations!private! !
_removeDevelopmentResources!operations!private! !
_removeDevelopmentSystemResidue!operations!private! !
_removeGuiForConsoleApplication!operations!private! !
_removeMethods:reason:force:!private!removing! !
_removeNotRequiredClasses!operations!private! !
_removeNotRequiredMethods!operations!private! !
_removePackageManagement!operations!private! !
_removeProtocolManagement!operations!private! !
_removeRedundantClassesAndResources:!operations!private! !
_removeRedundantMethods!operations!private! !
_removeRedundantMethodsOnceFrom:!operations!private! !
_removeRedundantObjects:id:!operations!private! !
_removeRedundantPackages!operations!private! !
_removeRedundantResources:!operations!private! !
_removeSelectors:of:!operations!private! !
_rootClasses!accessing!private! !
_shouldPreserveMethod:!private!removing! !
_shouldRemoveResources!private!testing! !
_shrinkEventsOf:!operations!private! !
_shrinkEventsRegister!helpers!private! !
_speciallySentMessages!configuration!private! !
_startElement:attributes:!logging!private! !
_systemPackageManager!accessing!private! !
_uncheckedDeleteClass:!helpers!private! !
_verifyRequiredPackages!accessing!private! !
compileExternalStructures!public!testing! !
developmentResources!accessing!public! !
emptyMethodDictionariesOfStubbornClasses!public!testing! !
notRequiredClasses!configuration!public! !
notRequiredMethodCategories!configuration!public! !
retainInstVarNames!public!testing! !
stbSaveOn:!binary filing!public! !
stripClassBuilder!public!testing! !
stripClassInfo!public!testing! !
stripClassInitializers!public!testing! !
stripDuplicateBytecodes!public!testing! !
stripDuplicateStrings!public!testing! !
stripRedundantClasses!public!testing! !
stripRedundantMethods!public!testing! !
stripRedundantPackages!public!testing! !
stripRedundantResources!public!testing! !
!

BasicImageStripper methodProtocol: #model attributes: #(#readOnly) selectors: #()!

!BasicImageStripper class methodsFor!

new
	^super new initialize!

stbConvertFrom: anSTBClassFormat
	"Private - Convert from previous version resource. 
	Version Changes:
		1: Added 'events' instance variable to Model."

	^
	[:data |
	| answer instVars |
	instVars := anSTBClassFormat version < 1
				ifTrue: 
					[| c |
					c := data size + 1.
					(Array new: c)
						replaceFrom: 2
							to: c
							with: data
							startingAt: 1;
						yourself]
				ifFalse: [data].
	answer := self basicNew.
	1 to: instVars size do: [:i | answer instVarAt: i put: (instVars at: i)].
	answer]!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^1! !
!BasicImageStripper class categoriesForMethods!
new!development!instance creation!public! !
stbConvertFrom:!binary filing!development!private! !
stbVersion!binary filing!development!public! !
!

