"Filed out from Dolphin Smalltalk 7"!

Model subclass: #BasicImageStripper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BasicImageStripper guid: (GUID fromString: '{51ce4971-61e8-431f-9823-437cf7293e8a}')!
BasicImageStripper isAbstract: true!
BasicImageStripper comment: 'Base image stripping methods. These can safely be encrypted during release.'!
!BasicImageStripper categoriesForClass!MVP-Models! !
!BasicImageStripper methodsFor!

actualRequiredPackages
	"Private - Answer the <collection> of  <Package>s to be included in the deployed application."

	^self systemPackageManager packages!

allMethodsInClasses: classes do: operation 
	"Private - Evaluate the <monadicValuable>, operation, for each and every method
	in the <collection> of <Class>es, classes."

	classes do: 
			[:eachClass | 
			eachClass methodDictionary do: [:eachMethod | operation value: eachMethod].
			eachClass class methodDictionary do: [:eachMethod | operation value: eachMethod]]!

allReferencedClasses
	^Class allClasses!

basicRemoveClass: aClass notifying: notifier
	"Private - Remove the specified class from the system. Note that we do not use the ClassBuilder for this purpose."

	| subs |
	[aClass uninitializeBeforeRemove] on: Error
		do: 
			[:x |
			self
				logElement: 'Error'
				attributes: {'class' -> x class name}
				value: 'Error uninitializing ' , aClass name , ': ' , x description].
	subs := aClass subclasses.
	subs notEmpty
		ifTrue: 
			[Notification signal: (String writeStream
						print: aClass;
						nextPutAll: ' has ';
						display: subs size;
						nextPutAll: ' subclasses';
						contents)].
	Smalltalk removeClass: aClass!

collectGarbage: iterations
	"Private - Perform a few GC's to clear away old stuff.
	Note that we explicitly clear down the finalization queue each time."

	| memMan |
	Smalltalk clearCachedClasses.
	memMan := MemoryManager current.
	iterations timesRepeat: [memMan collectGarbage; administerLastRites].!

compileExternalStructures
	^false!

compileExternalStructures: aCollection notifying: notifier
	"Private - Fully compile all ExternalStructure subclasses so that the template definitions and
	the AttributeDescriptor subclasses may be removed. In order to do this we forcibly and
	fully compile all the ExternalStructure accessor methods before removing the templates. If we
	do not, the templates will be required when #doesNotUnderstand: handles an accessor
	message for a field that is not normally compiled."

	self notify: notifier status: 'Fully compiling ExternalStructures'.
	self startElement: 'CompileExternalStructures' attributes: #().
	self systemPackageManager noEventsDo: 
			[aCollection do: [:each | each fullyCompileDefinition].

			"Remove template in a second pass"
			aCollection do: [:each | each newTemplate].
			"ExternalStructure DNU processing is no longer needed since fully compiled"
			self
				removeSelectors: #(#doesNotUnderstand:)
				of: ExternalStructure
				notifying: notifier.
			"Lazy template definition is not required"
			ExternalStructure class compile: 'ensureDefined'].
	"Field meta-data classes are no longer required"
	self assert: [self systemPackageManager isProcessingEvents].
	self uncheckedRemoveClass: (Smalltalk at: #AttributeDescriptor) notifying: notifier.
	self endElement: true!

defineExternalStructures: aCollection notifying: notifier
	"Private - Ensure that all external structures are fully defined to avoid any recompilation that might
	otherwise be triggered in a run-time image should the size be lazily determined."

	self notify: notifier status: 'Building all ExternalStructure templates'.
	self
		logElement: 'DefineExternalStructures'
		attributes: #()
		value: nil.
	self systemPackageManager noEventsDo: [aCollection do: [:each | each byteSize]]!

destroyAndRemoveProgressNotifying: notifier
	"Private - Destroy the progress view and remove its class if possible."

	self
		logElement: 'CloseProgressDialog'
		attributes: #()
		value: nil.
	
	[notifier first destroy.
	SessionManager inputState
		pumpMessages;
		processDeferredActions.
	"We remove the only reference to the notifier, which is why we have held it indirectly inside an Array, it should then
	be removable on the next class stripping cycle"
	notifier at: 1 put: DeafObject current.
	SessionManager current isConsoleApplication
		ifTrue: [self stripForConsoleApplicationNotifying: notifier].

	"Ensure RichText converter is not hanging around unecessarily"
	Smalltalk at: #RichText ifPresent: [:rt | rt uninitialize].
	SessionManager inputState purgeDeadWindows]
			on: Error
			do: 
				[:e |
				self logStrippingError: e.
				VMLibrary default crashDump: e description].
	self collectGarbage: 3.
	self
		finishedWithAll: #(#progressDialogClass #stripForConsoleApplicationNotifying: #destroyAndRemoveProgressNotifying:)!

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

endElement: aBoolean
	!

endTag
!

externalStructureClasses
	^ExternalStructure withAllSubclasses!

finishedWithAll: aCollectionOfSymbols
	"Private - The receiver has finished with its method identified by the selectors in the <collection> argument, so they can be stripped. We do this by removing them up the inheritance chain, but stopping at BasicImageStripper."

	aCollectionOfSymbols do: 
			[:each |
			| current |
			current := self class.
			[current name == #Model] whileFalse: 
					[current methodDictionary removeKey: each ifAbsent: [].
					current := current superclass]]!

foldDuplicateBytecodesNotifying: notifier 
	"Private - Eliminate duplicate byte code arrays"

	| byteCodes total |
	self stripDuplicateBytecodes ifFalse: [^self].
	self notify: notifier status: 'Folding duplicate byte codes'.
	total := 0.
	byteCodes := Set new.
	self allMethodsInClasses: Class allClasses
		do: 
			[:each | 
			each isPacked 
				ifFalse: 
					[each whileMutableDo: 
							[
							| bytes |
							total := total + 1.
							bytes := each byteCodes.
							byteCodes add: bytes.
							each setByteCodes: (byteCodes find: bytes)]]].
	self 
		logFold: 'FoldBytecodes'
		folded: total - byteCodes size
		total: total!

foldDuplicateStringsNotifying: notifier 
	| a |
	self stripDuplicateStrings ifFalse: [^self].
	self notify: notifier status: 'Folding duplicate strings'.
	a := Class foldLiteralStrings.
	self 
		logFold: 'FoldStrings'
		folded: a first - a second
		total: a first!

logElement: aString attributes: aCollection value: anObject 
	self startTag: aString attributes: aCollection.
	anObject notNil ifTrue: [self logValue: anObject].
	self endTag!

logFold: aString folded: count total: total
	self startElement: aString attributes: #().
	self
		logElement: 'Total'
		attributes: #()
		value: total.
	self
		logElement: 'Folded'
		attributes: #()
		value: count.
	self endElement: true!

logMethod: aCompiledMethod
	self
		logElement: 'Method'
		attributes: {'methodClass' -> aCompiledMethod methodClass name}
		value: aCompiledMethod selector!

logStrippingError: anError
	!

logValue: anObject 
!

messagesSentByClasses: aCollectionOfClasses
	| sent |
	sent := (IdentitySet new: aCollectionOfClasses size * 10)
				addAll: self speciallySentMessages;
				yourself.	"presize for an average of 10 unique sends per class"
	self allMethodsInClasses: aCollectionOfClasses
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
	Object._EventsRegister
		do: [:each | each do: [:mseq | mseq messagesDo: [:ms | sent add: ms selector]]].
	^sent!

notify: notifier status: aString 
!

notRequiredClasses
	"Answer an IdentitySet of Classes that are known to be not required and that
	should be forcibly dropped during an image strip. Can be overridden by subclasses 
	to alter the stripping strategy"

	^IdentitySet new
!

notRequiredMethodCategories
	"Answer an IdentitySet of MethodCategorys whose methods are known to be not required
	and should be forcibly dropped during an image strip. Can be overridden by subclasses to 
	alter the stripping strategy"

	^#()

!

onNotification: aNotification notifier: notifier
	self notify: notifier status: aNotification description!

prepareExternalStructuresNotifying: notifier
	"Private - Fully compile all ExternalStructure subclasses if required. They must already
	have fully defined templates."

	| structs |
	structs := self externalStructureClasses.
	self defineExternalStructures: structs notifying: notifier.
	self startElement: 'PrepareExternalStructures' attributes: #().
	self compileExternalStructures
		ifTrue: [self compileExternalStructures: structs notifying: notifier].
	structs do: 
			[:each |
			"Access the byteSize to ensure set, especially important if not compiling external structures"
			each byteSize.
			each class methodDictionary removeKey: #defineFields ifAbsent: []].

	"Having defined all the templates, we can now remove the methods used to create them"
	"We can now remove the structure template definition mechanism"
	structs do: 
			[:each |
			self
				removeSelectors: #(#shrink #defineTemplate #byteSize:)
				of: each class
				notifying: notifier].
	self compileExternalStructures
		ifTrue: 
			[self
				removeSelectors: #('offsetOf:')
				of: ExternalStructure class
				notifying: notifier].
	self endElement: true.
	self
		finishedWithAll: #(#compileExternalStructures #compileExternalStructures: #compileExternalStructures:notifying: #defineExternalStructures:notifying: #prepareExternalStructuresNotifying: #externalStructureClasses)!

preStripTidy
	"Private - Remove any methods of ImageStripper that are no longer required to ensure these don't impact the calculated package pre-reqs when they are determined"

	self
		finishedWithAll: #(#initialize #notRequiredMethodCategories #preStripTidy #stripNotRequiredMethodsNotifying:)!

purgeStubbornClass: aClass notifying: notifier
	"Private - Remove what we can of a stubborn class that refuses to uninstall for some reason."
!

removeClass: aClass notifying: notifier
	"Private - Removes aClass from the image. Answer the number of classes that
	were actually removed (subclasses may be removed too)."

	(aClass environment includesKey: aClass name) ifFalse: [^0].
	^self uncheckedRemoveClass: aClass notifying: notifier!

removeClasses: aCollection notifying: notifier
	| count |
	aCollection isEmpty ifTrue: [^0].
	count := 0.
	self startElement: 'StripClasses' attributes: #().
	aCollection reverseDo: [:each | count := count + (self removeClass: each notifying: notifier)].
	self endElement: count > 0.
	self shrinkEventsRegister.
	^count!

removeClassNamed: classNameSymbol notifying: notifier
	"Private - Removes the named class from the image, if it exists.
	Answer the number of classes actually removed."

	^(Smalltalk lookup: classNameSymbol)
		ifNil: [0]
		ifNotNil: [:class | self removeClass: class notifying: notifier]!

removeMethod: aCompiledMethod notifying: notifier
	self logMethod: aCompiledMethod.
	aCompiledMethod methodClass methodDictionary removeKey: aCompiledMethod selector
		ifAbsent: 
			["Could be in a weakly held development class which has evaporated"
			]!

removeMethods: aCollection reason: aString force: aBoolean notifying: notifier
	"Private - Removes the <collection> of <CompiledMethod>s, methods, from the image."

	| removed |
	aCollection isEmpty ifTrue: [^0].
	self startElement: 'StripMethods' attributes: {'reason' -> aString}.
	removed := aCollection asArray sort.
	aBoolean
		ifTrue: [removed do: [:each | self removeMethod: each notifying: notifier]]
		ifFalse: [removed := removed select: [:each | self removeMethodSoft: each notifying: notifier]].
	self endElement: true.
	^removed size!

removeMethodSoft: aCompiledMethod notifying: notifier
	^false!

removeSelectors: aCollectionOfSelectors of: aBehavior notifying: notifier
	aCollectionOfSelectors do: 
			[:each |
			(aBehavior compiledMethodAt: each asSymbol ifAbsent: [])
				ifNotNil: [:method | self removeMethod: method notifying: notifier]]!

retainInstVarNames
	"Answer whether the stripping process should preserve instance variable names.
	Normally these are not required unless certain reflective messages are used."

	^true!

rootClasses
	^#()!

shrinkEventsRegister
	Object._EventsRegister keys do: [:each | each setEvents: each getEvents shrink]!

speciallySentMessages
	"Private - A number of messages can be sent without  appearing in the literal
	frame of any method. Answer a Set of these selectors here."

	^WeakSet withAll: (VMLibrary default registry select: [:each | each class == Symbol])!

startElement: aString attributes: anArray 
!

startTag: aString attributes: aCollection 
!

stripCategoryManagementNotifying: notifier
	"Private - Remove categories information"

	self notify: notifier status: 'Removing category management'.
	self
		logElement: 'RemoveCategoryManagement'
		attributes: #()
		value: nil.
	Behavior allSubinstances do: [:each | each methodsCatalogue: nil].
	Class allSubinstances do: 
			[:each |
			each
				classCategories: #();
				sourceDescriptor: nil].

	"Uninitialize the category management system. Make this compatible with
	older versions of the image where categories were managed by CategoryManager"
	(Smalltalk lookup: #CategoryManager)
		ifNil: 
			[Smalltalk at: #Category ifPresent: [:c | c uninitialize].
			Smalltalk at: #MethodCategory ifPresent: [:c | c uninitialize]]
		ifNotNil: [:catman | catman current initialize]!

stripClassBuilder
	^false!

stripClassBuilder: anArray notifying: notifier
	"Private - Remove the ClassBuilder if so configured."

	!

stripClassInfo
	"Answer true if the stripping process will remove class information such as
	instance variable names, pools names and comments"

	^false!

stripClassInfoNotifying: notifier
	"Private - Remove all (presumably) redundant class info"

	self stripClassInfo
		ifTrue: 
			[| keepInstVars |
			self startElement: 'RemoveClassMetaInfo' attributes: #().
			keepInstVars := self retainInstVarNames.
			Class allClassesDo: 
					[:each |
					each
						basicClassPool: nil;
						basicSharedPools: nil.
					"If retaining inst vars, they are collapsed into a string for compactness"
					each instanceVariableString: (keepInstVars ifTrue: [each instanceVariableString])].
			self endTag].
	self finishedWithAll: #(#stripClassInfo #retainInstVarNames #stripClassInfoNotifying:)!

stripClassRemoval: aCollection notifying: notifier
	"Private - Removal of classes has finished. If the image doesn't have the ClassBuilder in it, 
	remove any uninitializers as they will not be needed."

	self startElement: 'StripClassRemoval' attributes: #().
	(Smalltalk includesKey: #ClassBuilder)
		ifTrue: [Notification signal: 'ClassBuilder still present, no action taken']
		ifFalse: 
			[aCollection do: [:each | self removeMethod: each notifying: notifier].
			"Remove any remaining class uninitialize methods that may be miscategorized"
			Class allClassesDo: 
					[:each |
					self
						removeSelectors: #('uninitialize' 'uninitializeBeforeRemove')
						of: each class
						notifying: notifier]].
	self endElement: true.
	self
		finishedWithAll: #(#addClassesReferencedByClass:to: #addClassesReferencedByMethod:to: #allReferencedClasses #basicRemoveClass:notifying: #classesReferencedByMethod: #classReferencesToIgnore #emptyMethodDictionariesOfStubbornClasses #notRequiredClasses #purgeStubbornClass:notifying: #removeClass:notifying: #removeClasses:notifying: #removeClassNamed:notifying: #removeSelectors:of:notifying: #shrinkEventsRegister #stripClassRemoval:notifying: #stripRedundantClasses #uncheckedRemoveClass:notifying:).
	self collectGarbage: 3!

stripDevelopmentInfoNotifying: notifier
	"Private - Remove development structures, etc."

	self startElement: 'StripDevelopmentInfo' attributes: #().
	self stripCategoryManagementNotifying: notifier.
	self stripProtocolManagementNotifying: notifier.
	Smalltalk developmentSystem perform: #clearSystemFolder.
	Class allSubinstances do: 
			[:b |
			b removePropertyAt: #changeIndex ifAbsent: [].
			"Remove all source references (may be LargeIntegers)"
			b methodDictionary do: [:m | m sourceDescriptor: nil].
			b class methodDictionary do: [:m | m sourceDescriptor: nil]].
	self collectGarbage: 3.
	self endElement: true.
	self finishedWithAll: #(#stripCategoryManagementNotifying: #stripProtocolManagementNotifying:)!

stripDevelopmentResourcesNotifying: notifier
	"Private - Remove development classes resources. We can't actually remove the
	classes themselves yet since some are required by the remainder of the 
	stripping process. By removing the resources we give the  class/method strip
	that follows the best chance of isolating redundant items."

	self developmentResources do: [:ri | ResourceIdentifier removeResource: ri].
	self finishedWithAll: #(#developmentResources)!

stripDevelopmentSystemNotifying: notifier 
	"Private - Remove all the development stuff that we can."

	"First Remove development classes resources. We can't actually remove the
	classes themselves yet since some are required by the remainder of the 
	stripping process. By removing the resources we give the  class/method strip
	that follows the best chance of isolating redundant items"

	self stripDevelopmentResourcesNotifying: notifier.

	"Before attempting to remove any classes, clear away any development instances and refs"
	self stripDevelopmentInfoNotifying: notifier.
	self stripPackageManagementNotifying: notifier.
	self stripNotRequiredClassesNotifying: notifier.
	self 
		finishedWithAll: #(#stripDevelopmentResourcesNotifying: #stripDevelopmentInfoNotifying: #stripPackageManagementNotifying: #stripNotRequiredClassesNotifying: #stripClassBuilderNotifying:)!

stripDuplicateBytecodes
	"Answer true if the stripping process will fold instances of duplicate byte code arrays 
	into one common instance"

	^false!

stripDuplicateStrings
	"Answer true if the stripping process will fold instances of duplicate strings
	into one common instance"

	^false!

stripForConsoleApplicationNotifying: notifier
	"Private - A console application is being deployed, so uninitialize parts of the GUI system
	that will allow the entire View hierarchy, etc, to be removed."

	self startElement: 'StripConsoleApplication' attributes: #().
	#(#ImageRelativeFileLocator #InstallRelativeFileLocator)
		do: [:each | Smalltalk at: each ifPresent: [:class | class uninitialize]].
	(Smalltalk includesKey: #View)
		ifFalse: [VMLibrary default unregisterObject: #wndProc:message:wParam:lParam:cookie:].
	self collectGarbage: 3.
	self endElement: true!

stripNotRequiredClassesNotifying: notifier
	"Private - Strip the classes that are explicitly listed as not being required,
	but only if the 'strip redundant classes' option was selected."

	self notRequiredClasses do: [:each | self removeClass: each notifying: notifier].
!

stripNotRequiredMethodsNotifying: notifier
	"Private - Strip the methods that must be removed due to membership of one of
	the special 'must strip' categories. Note that we collect all first before removing
	any to avoid any problems caused by the categories being out of date with
	respect to the actual selectors in the class."

	"This method must be run BEFORE package pre-requisites are calculated in order to
	be sure that all methods causing undesirable dependencies are removed first."

	| methods |
	methods := IdentitySet new: 100.
	self notify: notifier status: 'Removing methods that are not required or which must be stripped'.
	self startElement: 'ForcedStripMethods' attributes: #().
	self notRequiredMethodCategories do: [:each | methods addAll: each asMethodCategory contents].

	"We don't go through #removeMethods:notifying:, since we want the packages to be updated to reflect the lost
	methods so that when their pre-requisites are recalculated the removed methods do not affect the result."
	(methods asSortedCollection: 
			[:a :b |
			a methodClass name < b methodClass name
				or: [a methodClass == b methodClass and: [a selector < b selector]]])
		do: 
			[:each |
			self logMethod: each.
			each methodClass removeSelector: each selector ifAbsent: []].
	self endElement: true.
	self preStripTidy!

stripPackageManagementNotifying: notifier
	"Private - Remove packages structure."

	self startElement: 'StripPackageManagement' attributes: #().
	self systemPackageManager class reset.
	"Note that we must leave the #owningPackage definition in Class for potential runtime STB use"
	#(#PoolDictionary #PoolConstantsDictionary #ResourceIdentifier #CompiledMethod) do: 
			[:each |
			Smalltalk at: each
				ifPresent: 
					[:class |
					self
						removeSelectors: #('owningPackage')
						of: class
						notifying: notifier.
					self]].
	self finishedWithAll: #(#systemPackageManager).
	self endElement: true!

stripProtocolManagementNotifying: notifier
	"Private - Remove protocol information. Note that only the MethodProtocol objects
	themselves are removed, not the list of protocol names stored in each
	class."

	self
		logElement: 'RemoveMethodProtocols'
		attributes: #()
		value: nil.
	Smalltalk at: #MethodProtocol ifPresent: [:p | p initializeProtocols]!

stripRedundantClasses
	"Answer true if the receiver will attempt to remove redundant classes not
	required in the deployed application."

	^false!

stripRedundantClassesAndResources: stripResources notifying: notifier 
	"Private - Removes redundant classes from the current image. A redundant class is one
	that has no current instances in the image and is not referenced by any of the root classes
	of the receiver. Answer the number of classes that were actually removed."

	| referencedClasses count msg |
	self stripRedundantClasses ifFalse: [^0].
	count := 0.

	"Find classes that are redundant"
	msg := 'Removing redundant classes'.
	stripResources ifTrue: [msg := msg , ' and resources'].
	self notify: notifier status: msg , '...'.
	self collectGarbage: 3.
	referencedClasses := self allReferencedClasses.
	stripResources 
		ifTrue: [count := count + (self stripRedundantResources: referencedClasses notifying: notifier)].
	^count + (self removeClasses: (Class allClasses difference: referencedClasses) notifying: notifier)!

stripRedundantMethods
	"Answer true if the receiver will attempt to remove methods that will not be
	referenced in the deployed application."

	^false!

stripRedundantMethodsNotifying: notifier 
	"Private - Removes redundant methods from the pseudo image.
	Answers the count of methods stripped"

	^0!

stripRedundantMethodsOnceFrom: aCollectionOfClasses notifying: notifier
	"Private - Removes redundant methods from the pseudo image.
	Answers the count of methods stripped"

	| redundantMessages redundantMethods sent implemented |
	self notify: notifier status: 'Removing redundant methods...'.
	self collectGarbage: 1.
	sent := self messagesSentByClasses: aCollectionOfClasses.
	implemented := IdentitySet new: aCollectionOfClasses size * 12.
	self allMethodsInClasses: aCollectionOfClasses do: [:each | implemented add: each selector].
	redundantMessages := implemented difference: sent.
	redundantMessages isEmpty ifTrue: [^0].
	redundantMethods := OrderedCollection new.
	self allMethodsInClasses: aCollectionOfClasses
		do: [:each | (redundantMessages includes: each selector) ifTrue: [redundantMethods addLast: each]].
	^self
		removeMethods: redundantMethods
		reason: 'unsent'
		force: false
		notifying: notifier!

stripRedundantObjects: stripResources notifying: notifier
	"Cycle around removing redundant classes and methods until all remaining
	classes and methods appear to be required to complete the deployed image."

	
	[| continue |
	self startElement: 'StripCycle' attributes: #().
	continue := (self
				stripRedundantClassesAndResources: (stripResources and: [self stripRedundantResources])
				notifying: notifier) + (self stripRedundantMethodsNotifying: notifier)
				> 0.
	self endElement: continue.
	continue]
			whileTrue!

stripRedundantPackages
	"Answer true if the receiver will attempt to remove redundant packages not
	referenced from a root package during its stripping process."

	^false!

stripRedundantPackagesNotifying: notifier
	"Private - Strips the unwanted packages from the image."

	| redundantPackages required pacman |
	self stripRedundantPackages ifFalse: [^0].
	required := self actualRequiredPackages.
	pacman := self systemPackageManager.
	redundantPackages := pacman packages difference: required.
	"Turn off events to prevent repeated tracing of pre-reqs as each of the redundant packages
	 is uninstalled."
	pacman beNotProcessingEvents.
	"We don't want to uninstall the DevelopmentSessionManager until it has been replaced by the run-time session manager"
	pacman addClass: SessionManager current class to: nil.
	self startElement: 'RedundantPackages' attributes: #().
	(redundantPackages asSortedCollection: [:a :b | a name < b name]) do: 
			[:each |
			self
				logElement: 'Package'
				attributes: #()
				value: each.
			self].
	self endElement: true.
	self notify: notifier status: 'Removing unwanted packages'.
	self startElement: 'StripPackages' attributes: #().
	[redundantPackages do: 
			[:each |
			pacman uninstall: each.
			self collectGarbage: 2]]
		on: ClassBuilder invalidRemoveError
		do: 
			[:e |
			self onNotification: e notifier: notifier.
			self purgeStubbornClass: e tag notifying: notifier.
			e resume: true].	"Remove classes regardless"
	self endElement: true.
	pacman beProcessingEvents!

stripRedundantResources
	"Answer true if the receiver will attempt to remove resources that are not required in the
	deployed application."

	^false!

stripRedundantResources: referencedClasses notifying: notifier 
!

stripSystemDictionaryNotifying: notifier
	"Private - Remove all non-class globals from the SystemDictionary.
	This should only be performed if the application does not intend
	to look up objects dynamically by name in Smalltalk.

	Note that we cannot remove classes from Smalltalk since these
	ARE looked up by name by the STBFiler mechanism, though we
	do remove global aliases for classes as their is a separate mechanism
	in place to ensure STB can still loate the appropriate class for these."

	| globals |
	self startElement: 'EmptySystemDictionary' attributes: #().
	globals := OrderedCollection new.
	Smalltalk associationsDo: 
			[:each |
			(each value class isMeta not or: [each value name ~~ each key]) ifTrue: [globals add: each key]].
	globals do: 
			[:each |
			self
				logElement: 'Global'
				attributes: #()
				value: each.
			Smalltalk removeKey: each].
	self collectGarbage: 3.
	self finishedWithAll: #(#stripSystemDictionaryNotifying:).
	self endElement: true!

systemPackageManager
	"Private - Answer the package manager to be used by the receiver.
	N.B. All references to PackageManager must be through this accessor
	to prevent the PackageManager and Package classes remaining in the
	deployed image."

	^(Smalltalk at: #Package ifAbsent: [DeafObject current]) manager!

uncheckedRemoveClass: aClass notifying: notifier
	| removed |
	removed := aClass allSubclasses inject: 0
				into: [:sum :each | sum + (self removeClass: each notifying: notifier)].	"First remove subclasses"
	self
		logElement: 'RemoveClass'
		attributes: #()
		value: aClass name.
	^
	[self basicRemoveClass: aClass notifying: notifier.
	aClass clearGuid.
	removed + 1] on: Error
			do: 
				[:ex |
				self logStrippingError: ex.
				"self notify: notifier detail: (x stackTrace: 10)."
				aClass primAllInstances do: [:each | Notification signal: each printString].
				self purgeStubbornClass: aClass notifying: notifier.
				removed]! !
!BasicImageStripper categoriesFor: #actualRequiredPackages!accessing!private! !
!BasicImageStripper categoriesFor: #allMethodsInClasses:do:!helpers!private! !
!BasicImageStripper categoriesFor: #allReferencedClasses!operations!private! !
!BasicImageStripper categoriesFor: #basicRemoveClass:notifying:!helpers!private! !
!BasicImageStripper categoriesFor: #collectGarbage:!operations!private! !
!BasicImageStripper categoriesFor: #compileExternalStructures!public!testing! !
!BasicImageStripper categoriesFor: #compileExternalStructures:notifying:!operations!private! !
!BasicImageStripper categoriesFor: #defineExternalStructures:notifying:!operations!private! !
!BasicImageStripper categoriesFor: #destroyAndRemoveProgressNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #developmentResources!accessing!public! !
!BasicImageStripper categoriesFor: #emptyMethodDictionariesOfStubbornClasses!public!testing! !
!BasicImageStripper categoriesFor: #endElement:!operations-logging!private! !
!BasicImageStripper categoriesFor: #endTag!operations-logging!private! !
!BasicImageStripper categoriesFor: #externalStructureClasses!accessing!private! !
!BasicImageStripper categoriesFor: #finishedWithAll:!operations!private! !
!BasicImageStripper categoriesFor: #foldDuplicateBytecodesNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #foldDuplicateStringsNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #logElement:attributes:value:!operations-logging!private! !
!BasicImageStripper categoriesFor: #logFold:folded:total:!operations!private! !
!BasicImageStripper categoriesFor: #logMethod:!operations!private! !
!BasicImageStripper categoriesFor: #logStrippingError:!operations-logging!private! !
!BasicImageStripper categoriesFor: #logValue:!operations-logging!private! !
!BasicImageStripper categoriesFor: #messagesSentByClasses:!helpers!private! !
!BasicImageStripper categoriesFor: #notify:status:!operations!private! !
!BasicImageStripper categoriesFor: #notRequiredClasses!configuration!public! !
!BasicImageStripper categoriesFor: #notRequiredMethodCategories!configuration!public! !
!BasicImageStripper categoriesFor: #onNotification:notifier:!event handling!private! !
!BasicImageStripper categoriesFor: #prepareExternalStructuresNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #preStripTidy!operations!private! !
!BasicImageStripper categoriesFor: #purgeStubbornClass:notifying:!operations!private! !
!BasicImageStripper categoriesFor: #removeClass:notifying:!helpers!private! !
!BasicImageStripper categoriesFor: #removeClasses:notifying:!operations!private! !
!BasicImageStripper categoriesFor: #removeClassNamed:notifying:!helpers!private! !
!BasicImageStripper categoriesFor: #removeMethod:notifying:!private!removing! !
!BasicImageStripper categoriesFor: #removeMethods:reason:force:notifying:!private!removing! !
!BasicImageStripper categoriesFor: #removeMethodSoft:notifying:!private!removing! !
!BasicImageStripper categoriesFor: #removeSelectors:of:notifying:!operations!private! !
!BasicImageStripper categoriesFor: #retainInstVarNames!public!testing! !
!BasicImageStripper categoriesFor: #rootClasses!accessing!private! !
!BasicImageStripper categoriesFor: #shrinkEventsRegister!private! !
!BasicImageStripper categoriesFor: #speciallySentMessages!configuration!private! !
!BasicImageStripper categoriesFor: #startElement:attributes:!operations-logging!private! !
!BasicImageStripper categoriesFor: #startTag:attributes:!operations-logging!private! !
!BasicImageStripper categoriesFor: #stripCategoryManagementNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripClassBuilder!public!testing! !
!BasicImageStripper categoriesFor: #stripClassBuilder:notifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripClassInfo!public!testing! !
!BasicImageStripper categoriesFor: #stripClassInfoNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripClassRemoval:notifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripDevelopmentInfoNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripDevelopmentResourcesNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripDevelopmentSystemNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripDuplicateBytecodes!public!testing! !
!BasicImageStripper categoriesFor: #stripDuplicateStrings!public!testing! !
!BasicImageStripper categoriesFor: #stripForConsoleApplicationNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripNotRequiredClassesNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripNotRequiredMethodsNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripPackageManagementNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripProtocolManagementNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripRedundantClasses!public!testing! !
!BasicImageStripper categoriesFor: #stripRedundantClassesAndResources:notifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripRedundantMethods!public!testing! !
!BasicImageStripper categoriesFor: #stripRedundantMethodsNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripRedundantMethodsOnceFrom:notifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripRedundantObjects:notifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripRedundantPackages!public!testing! !
!BasicImageStripper categoriesFor: #stripRedundantPackagesNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripRedundantResources!public!testing! !
!BasicImageStripper categoriesFor: #stripRedundantResources:notifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripSystemDictionaryNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #systemPackageManager!accessing!private! !
!BasicImageStripper categoriesFor: #uncheckedRemoveClass:notifying:!helpers!private! !

