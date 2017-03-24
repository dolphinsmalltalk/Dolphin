"Filed out from Dolphin Smalltalk 7"!

Model subclass: #BasicImageStripper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BasicImageStripper guid: (GUID fromString: '{51ce4971-61e8-431f-9823-437cf7293e8a}')!
BasicImageStripper comment: 'Base image stripping methods. These can safely be encrypted during release.'!
!BasicImageStripper categoriesForClass!MVP-Models! !
!BasicImageStripper methodsFor!

basicRemoveClass: aClass notifying: notifier 
	"Private - Remove the specified class from the system. Note that we do not use the ClassBuilder for this purpose."
	| subs |
	[aClass uninitializeBeforeRemove] on: Error
		do: 
			[:x | 
			self 
				logElement: 'Error'
				attributes: (Array with: 'class' -> x class name)
				value: 'Error uninitializing ' , aClass name , ': ' , x description].
	subs := aClass subclasses.
	subs notEmpty 
		ifTrue: 
			[Notification signal: ((String writeStream)
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

compileExternalStructuresNotifying: notifier 
	"Private - Fully compile all ExternalStructure subclasses so that the template definitions and
	the AttributeDescriptor subclasses may be removed. In order to do this we forcibly and
	fully compile all the ExternalStructure accessor methods before removing the templates. If we
	do not, the templates will be required when #doesNotUnderstand: handles an accessor
	message for a field that is not normally compiled."

	self notify: notifier status: 'Fully compiling ExternalStructures'.
	self startElement: 'CompileExternalStructures'.
	ExternalStructure withAllSubclasses do: [:each | each fullyCompileDefinition].

	"Remove template in a second pass"
	ExternalStructure withAllSubclasses do: [:each | each newTemplate].
	"ExternalStructure DNU processing is no longer needed since fully compiled"
	self 
		removeSelector: #doesNotUnderstand:
		of: ExternalStructure
		notifying: notifier.
	"Now we should be able to remove AttributeDescriptor and all its subclasses"
	self removeClassNamed: #AttributeDescriptor notifying: notifier.
	self endElement!

defineExternalStructuresNotifying: notifier 
	"Private - Ensure that all external structures are fully defined to avoid any recompilation that might
	otherwise be triggered in a run-time image should the size be lazily determined."

	self notify: notifier status: 'Building all ExternalStructure templates'.
	self logElement: 'DefineExternalStructures' value: nil.
	ExternalStructure withAllSubclasses do: [:each | each byteSize]!

destroyAndRemoveProgressNotifying: notifier
	"Private - Destroy the progress view and remove its class if possible."

	self logElement: 'CloseProgressDialog' value: nil.
	
	[notifier first destroy.
	(SessionManager inputState)
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
				self logError: e.
				VMLibrary default crashDump: e description].
	self collectGarbage: 3.
	self
		finishedWithAll: #(#progressDialogClass #stripForConsoleApplicationNotifying: #destroyAndRemoveProgressNotifying:)!

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
		total: total
	"	self notify: notifier
		status: (before - after) displayString 
				, ' duplicate byte code arrays were stripped leaving ' , after displayString
"!

foldDuplicateStringsNotifying: notifier 
	| a |
	self stripDuplicateStrings ifFalse: [^self].
	self notify: notifier status: 'Folding duplicate strings'.
	a := Class foldLiteralStrings.
	self 
		logFold: 'FoldStrings'
		folded: a first - a second
		total: a first!

prepareExternalStructuresNotifying: notifier
	"Private - Fully compile all ExternalStructure subclasses if required. They must already
	have fully defined templates."

	self startElement: 'PrepareExternalStructures'.
	self compileExternalStructures ifTrue: [self compileExternalStructuresNotifying: notifier].
	ExternalStructure withAllSubclasses do: 
			[:each |
			"Access the byteSize to ensure set, especially important if not compiling external structures"
			each byteSize.
			each class methodDictionary removeKey: #defineFields ifAbsent: []].

	"Having defined all the templates, we can now remove the methods used to create them"
	"We can now remove the structure template definition mechanism"
	ExternalStructure class withAllSubclasses do: 
			[:each |
			self
				removeSelectors: #(#shrink #defineTemplate #byteSize:)
				of: each
				notifying: notifier].
	self compileExternalStructures
		ifTrue: 
			[self
				removeSelector: #offsetOf:
				of: ExternalStructure class
				notifying: notifier].
	self endElement.

	"We no longer need this method. Referenced methods will become eligible to be stripped also"
	self
		finishedWithAll: #(#compileExternalStructures #compileExternalStructures: #compileExternalStructuresNotifying: #defineExternalStructuresNotifying: #prepareExternalStructuresNotifying:)!

purgeStubbornClass: aClass notifying: notifier
	"Private - Remove what we can of a stubborn class that refuses to uninstall for some reason."

	self emptyMethodDictionariesOfStubbornClasses ifFalse: [^self].
	Notification signal: 'Purging class ' , aClass name.
	aClass clearGuid.
	aClass class methodDictionary: nil.
	aClass methodDictionary: nil!

removeClass: aClass notifying: notifier 
	"Private - Removes aClass from the image. Answer the number of classes that
	were actually removed (subclasses may be removed too)."

	| removed className |
	className := aClass name.
	(aClass environment includesKey: className) ifFalse: [^0].
	(self rootClasses includes: aClass) 
		ifTrue: 
			[Warning 
				signal: 'The class ' , className , ' cannot be removed because it is a root of the application'.
			^0].
	"First remove subclasses"
	removed := aClass allSubclasses inject: 0
				into: [:sum :each | sum + (self removeClass: each notifying: notifier)].
	self logElement: 'RemoveClass' value: className.
	^
	[self basicRemoveClass: aClass notifying: notifier.
	aClass clearGuid.
	removed + 1] on: Error
			do: 
				[:ex | 
				self logError: ex.
				"self notify: notifier detail: (x stackTrace: 10)."
				aClass primAllInstances do: [:each | Notification signal: each printString].
				self purgeStubbornClass: aClass notifying: notifier.
				removed]!

removeClasses: aCollection notifying: notifier 
	| count |
	aCollection isEmpty ifTrue: [^0].
	count := 0.
	self startElement: 'StripClasses'.
	"Remove hierarchies from the bottom up."
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

removeMethods: aCollection force: aBoolean notifying: notifier
	"Private - Removes the <collection> of <CompiledMethod>s, methods, from the image."

	| removed |
	aCollection isEmpty ifTrue: [^0].
	self startElement: 'StripMethods'.
	removed := aCollection asSortedCollection select: 
					[:method |
					self
						removeMethod: method
						force: aBoolean
						notifying: notifier].
	self endElement.
	^removed size!

removeSelector: aSymbol of: aClass notifying: notifier 
	self 
		removeSelectors: (Array with: aSymbol)
		of: aClass
		notifying: notifier!

removeSelectors: aCollectionOfSelectors of: aBehavior notifying: notifier
	aCollectionOfSelectors do: 
			[:each |
			(aBehavior compiledMethodAt: each asSymbol ifAbsent: [])
				ifNotNil: 
					[:method |
					self
						removeMethod: method
						force: true
						notifying: notifier]]!

shrinkEventsRegister
	Object._EventsRegister keys do: [:each | each setEvents: each getEvents shrink]!

stripCategoryManagementNotifying: notifier
	"Private - Remove categories information"

	self notify: notifier status: 'Removing category management'.
	self logElement: 'RemoveCategoryManagement' value: nil.
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

stripClassBuilderNotifying: notifier 
	"Private - Remove the ClassBuilder if so configured."

	self stripClassBuilder ifTrue: [self removeClassNamed: #ClassBuilder notifying: notifier]!

stripClassInfoNotifying: notifier
	"Private - Remove all (presumably) redundant class info"

	self stripClassInfo
		ifTrue: 
			[| keepInstVars |
			self startElement: 'RemoveClassMetaInfo'.
			keepInstVars := self retainInstVarNames.
			Class allClassesDo: 
					[:each |
					each
						basicClassPool: nil;
						basicSharedPools: nil.
					each instanceVariableString: (keepInstVars ifTrue: [each instanceVariableString])].
			self endTag].
	self finishedWithAll: #(#stripClassInfo #retainInstVarNames #stripClassInfoNotifying:)!

stripClassRemovalNotifying: notifier 
	"Private - Removal of classes has finished. If the image doesn't have the ClassBuilder in it, 
	remove any uninitializers as they will not be needed."

	self startElement: 'StripClassRemoval'.
	(Smalltalk includesKey: #ClassBuilder) 
		ifTrue: [Notification signal: 'ClassBuilder still present, no action taken']
		ifFalse: 
			[Class allClassesDo: 
					[:each | 
					self 
						removeSelectors: #('uninitialize')
						of: each class
						notifying: notifier	"'uninitializeBeforeRemove'"].
			self 
				removeSelector: 'removeClass:'
				of: SystemDictionary
				notifying: notifier].
	self endElement.
	self 
		finishedWithAll: #(#removeClass:notifying: #removeClassNamed:notifying: #removeClasses:notifying:).
	self collectGarbage: 3!

stripDevelopmentInfoNotifying: notifier 
	"Private - Remove development structures, etc."

	self startElement: 'StripDevelopmentInfo'.
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
	self endElement.
	self finishedWithAll: #(#stripCategoryManagementNotifying: #stripProtocolManagementNotifying:)!

stripDevelopmentResourcesNotifying: notifier 
	"Private - Remove development classes resources. We can't actually remove the
	classes themselves yet since some are required by the remainder of the 
	stripping process. By removing the resources we give the  class/method strip
	that follows the best chance of isolating redundant items."

	self developmentResources do: [:ri | self resourceManager removeResource: ri].
	self finishedWith: #developmentResources!

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
	self stripClassBuilderNotifying: notifier.
	self 
		finishedWithAll: #(#stripDevelopmentResourcesNotifying: #stripDevelopmentInfoNotifying: #stripPackageManagementNotifying: #stripNotRequiredClassesNotifying: #stripClassBuilderNotifying:)!

stripForConsoleApplicationNotifying: notifier 
	"Private - A console application is being deployed, so uninitialize parts of the GUI system
	that will allow the entire View hierarchy, etc, to be removed."

	self startElement: 'StripConsoleApplication'.
	#(#ImageRelativeFileLocator #InstallRelativeFileLocator) 
		do: [:each | Smalltalk at: each ifPresent: [:class | class uninitialize]].
	(Smalltalk includesKey: #View) 
		ifFalse: [VMLibrary default unregisterObject: #wndProc:message:wParam:lParam:cookie:].
	self collectGarbage: 3.
	self endElement!

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
	self startElement: 'ForcedStripMethods'.
	self notRequiredMethodCategories
		do: [:each | methods addAll: (Object methodCategoryClass name: each) contents].

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
	self endElement!

stripPackageManagementNotifying: notifier 
	"Private - Remove packages structure."

	self startElement: 'StripPackageManagement'.
	self systemPackageManager class reset.
	"Note that we must leave the #owningPackage definition in Class for potential runtime STB use"
	#(#PoolDictionary #PoolConstantsDictionary #ResourceIdentifier #CompiledMethod) do: 
			[:each | 
			Smalltalk at: each
				ifPresent: 
					[:class | 
					self 
						removeSelector: 'owningPackage'
						of: class
						notifying: notifier]].
	self finishedWith: #systemPackageManager.
	self endElement!

stripProtocolManagementNotifying: notifier 
	"Private - Remove protocol information. Note that only the MethodProtocol objects
	themselves are removed, not the list of protocol names stored in each
	class."

	self logElement: 'RemoveMethodProtocols' value: nil.
	Smalltalk at: #MethodProtocol ifPresent: [:p | p initializeProtocols]!

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

stripRedundantMethodsNotifying: notifier 
	"Private - Removes redundant methods from the pseudo image.
	Answers the count of methods stripped"

	| sum classes |
	self stripRedundantMethods ifFalse: [^0].
	sum := 0.
	classes := Class allClasses.
	
	[| count |
	count := self stripRedundantMethodsOnceFrom: classes notifying: notifier.
	sum := sum + count.
	count > 0] 
			whileTrue.
	^sum!

stripRedundantMethodsOnceFrom: aCollectionOfClasses notifying: notifier
	"Private - Removes redundant methods from the pseudo image.
	Answers the count of methods stripped"

	| redundantMessages redundantMethods sent asc implemented |
	self notify: notifier status: 'Removing redundant methods...'.
	self collectGarbage: 1.
	sent := self messagesSentByClasses: aCollectionOfClasses.
	implemented := self messagesImplementedBy: aCollectionOfClasses.
	redundantMessages := implemented difference: sent.
	redundantMessages isEmpty ifTrue: [^0].
	redundantMethods := OrderedCollection new.
	self allMethodsInClasses: aCollectionOfClasses
		do: [:each | (redundantMessages includes: each selector) ifTrue: [redundantMethods addLast: each]].
	^self
		removeMethods: redundantMethods
		force: false
		notifying: notifier!

stripRedundantObjects: stripResources notifying: notifier 
	"Cycle around removing redundant classes and methods until all remaining
	classes and methods appear to be required to complete the deployed image."

	
	[| continue |
	self startElement: 'StripCycle'.
	continue := (self 
				stripRedundantClassesAndResources: (stripResources and: [self stripRedundantResources])
				notifying: notifier) + (self stripRedundantMethodsNotifying: notifier) 
				> 0.
	self endElement: continue.
	continue] 
			whileTrue!

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
	self startElement: 'RedundantPackages'.
	(redundantPackages asSortedCollection: [:a :b | a name < b name])
		do: [:each | self logElement: 'Package' value: each].
	self endElement.
	self notify: notifier status: 'Removing unwanted packages'.
	self startElement: 'StripPackages'.
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
	self endElement.
	pacman beProcessingEvents!

stripSystemDictionaryNotifying: notifier 
	"Private - Remove all non-class globals from the SystemDictionary.
	This should only be performed if the application does not intend
	to look up objects dynamically by name in Smalltalk.

	Note that we cannot remove classes from Smalltalk since these
	ARE looked up by name by the STBFiler mechanism, though we
	do remove global aliases for classes as their is a separate mechanism
	in place to ensure STB can still loate the appropriate class for these."

	| globals |
	self startElement: 'EmptySystemDictionary'.
	globals := OrderedCollection new.
	Smalltalk associationsDo: 
			[:each | 
			(each value class isMeta not or: [each value name ~~ each key]) ifTrue: [globals add: each key]].
	globals do: 
			[:each | 
			self logElement: 'Global' value: each.
			Smalltalk removeKey: each].
	self collectGarbage: 3.
	self finishedWith: #stripSystemDictionaryNotifying:.
	self endElement! !
!BasicImageStripper categoriesFor: #basicRemoveClass:notifying:!helpers!private! !
!BasicImageStripper categoriesFor: #collectGarbage:!operations!private! !
!BasicImageStripper categoriesFor: #compileExternalStructuresNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #defineExternalStructuresNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #destroyAndRemoveProgressNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #foldDuplicateBytecodesNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #foldDuplicateStringsNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #prepareExternalStructuresNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #purgeStubbornClass:notifying:!operations!private! !
!BasicImageStripper categoriesFor: #removeClass:notifying:!helpers!private! !
!BasicImageStripper categoriesFor: #removeClasses:notifying:!operations!private! !
!BasicImageStripper categoriesFor: #removeClassNamed:notifying:!helpers!private! !
!BasicImageStripper categoriesFor: #removeMethods:force:notifying:!private!removing! !
!BasicImageStripper categoriesFor: #removeSelector:of:notifying:!operations!private! !
!BasicImageStripper categoriesFor: #removeSelectors:of:notifying:!operations!private! !
!BasicImageStripper categoriesFor: #shrinkEventsRegister!private! !
!BasicImageStripper categoriesFor: #stripCategoryManagementNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripClassBuilderNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripClassInfoNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripClassRemovalNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripDevelopmentInfoNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripDevelopmentResourcesNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripDevelopmentSystemNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripForConsoleApplicationNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripNotRequiredClassesNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripNotRequiredMethodsNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripPackageManagementNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripProtocolManagementNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripRedundantClassesAndResources:notifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripRedundantMethodsNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripRedundantMethodsOnceFrom:notifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripRedundantObjects:notifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripRedundantPackagesNotifying:!operations!private! !
!BasicImageStripper categoriesFor: #stripSystemDictionaryNotifying:!operations!private! !

