"Filed out from Dolphin Smalltalk 7"!

Tools.BasicImageStripper subclass: #'Tools.ImageStripper'
	instanceVariableNames: 'rootPackageName executableName runtimeSessionManagerClass flags preStripScript versionResource potentialAspectSetters stubFilePath logStream elementStack developmentClasses preservedMessages snapshotType rootClasses supersentMethods potentialAspectGetters notifier runFlags _unused20 _unused21 _unused22'
	classVariableNames: ''
	imports: #(#{OS.MessageBoxConstants} #{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {
		'AllResourcesStripped' -> 16r1.
		'ClearGuidsMask' -> 16r1.
		'CompileStructsMask' -> 16r100.
		'EmptyMethodDictsMask' -> 16r800.
		'FoldBytecodesMask' -> 16r1000.
		'FoldMethodDictsMask' -> 16r200.
		'FoldStringsMask' -> 16r2.
		'IgnoreViewReferencesMask' -> 16r80000.
		'KeepImageMask' -> 16r2000000.
		'LogLiveClassesMask' -> 16r8000000.
		'LogPrerequisitesMask' -> 16r40000.
		'LogReferencesMask' -> 16r2000.
		'NoXPManifestMask' -> 16r200000.
		'PreserveAspectsMask' -> 16r4.
		'PurgeStubbornClassesMask' -> 16r4000000.
		'RemoveAbstractUnreachable' -> 16r2.
		'RetainDevSysMask' -> 16r10000000.
		'RetainInstVarNamesMask' -> 16r8.
		'RetainSubclassRespMask' -> 16r800000.
		'StripClassBuilderMask' -> 16r4000.
		'StripClassesMask' -> 16r10.
		'StripClassInfoMask' -> 16r20.
		'StripDeprecatedMask' -> 16r10000.
		'StripMethodsMask' -> 16r40.
		'StripPackagesMask' -> 16r20000.
		'StripResourcesMask' -> 16r80.
		'StripShouldNotImplMask' -> 16r8000.
		'ToGoMask' -> 16r100000.
		'UnattendedMask' -> 16r1000000.
		'WriteLogMask' -> 16r400
	}!
Tools.ImageStripper guid: (Core.GUID fromString: '{87b4c667-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.ImageStripper comment: 'An ImageStripper holds deployment information that indicates how a Dolphin image should be stripped of redundant objects during deployment. ImageStripper is part of the Application Deployment Kit package.

Instance Variables:
	rootPackageName			<readableString> or nil, indicating the root package on which stripping should be based.
	executableName			<readableString> holding the deployed EXE name.
	runtimeSessionManagerClass		<RuntimeSessionManager class> that should be installed to manage the runtime image.
	stripRedundantClasses		<boolean> indicating whether redundant classes should be stripped.
	stripRedundantMethods		<boolean> indicating whether redundant methods should be stripped.
	preserveAspectSetters		<boolean> indicating whether aspect set/get pairs of methods should be retained.
	stripDuplicateStrings			<boolean> indicating whether duplicate strings should be folded.
	compileExternalStructures		<boolean> indicating whether external structure classes should be fully compiled.
	writeLogFile			<boolean> indicating whether a log file to be written.
	stripClassInfo			<boolean> indicating whether class information should be stripped.
	developmentClasses			<IdentitySet> used to cache the development classes.
	logStream				<FileStream> or nil, holding the FileStream to which a log should be written.
	retainPachydermInfo			<boolean> indicating whether Pachyderm meta-information is required.
	rootClasses			<IdentitySet> used to cache the classes in the root package.

'!
!Tools.ImageStripper categoriesForClass!MVP-Models! !
!Tools.ImageStripper methodsFor!

actualRequiredPackages
	"Private - Answers a <Set> of the actual Packages required by the application taking account 
	of those that are prerequisites of those explicitly listed as required."

	| names required pacman |
	names := self requiredPackageNames.
	names add: 'Lagoon Image Stripper'.	"Not a good idea to uninstall this"
	pacman := self systemPackageManager.
	required := Set new.
	names do: 
			[:each |
			(pacman packageNamed: each ifNone: [])
				ifNotNil: 
					[:package |
					required
						add: package;
						addAll: package allPrerequisites]].
	^required!

addClassesReferencedByClass: aClass to: aSet 
	| addMethodRefs |
	((aSet includes: aClass) or: [self classReferencesToIgnore includes: aClass]) ifTrue: [^aSet].
	aSet add: aClass.
	aClass allSuperclasses do: [:each | self addClassesReferencedByClass: each to: aSet].
	addMethodRefs := [:method | self addClassesReferencedByMethod: method to: aSet].
	aClass methodDictionary do: addMethodRefs.
	aClass class methodDictionary do: addMethodRefs.
	^aSet!

addClassesReferencedByMethod: aCompiledMethod to: aSet 
	(self classesReferencedByMethod: aCompiledMethod) 
		do: [:each | self addClassesReferencedByClass: each to: aSet].
	^aSet!

addReferencedViews: resid to: referenced
	"Private - Recursively add any ReferenceViews referenced by the <Resource>, res, to the
	<Set> argument, referenced."

	| proxies idIndex refView stbProxy |
	refView := #{ReferenceView} valueOrNil.
	stbProxy := #{STBViewProxy} valueOrNil.
	(refView isNil or: [stbProxy isNil]) ifTrue: [^self].
	idIndex := refView superclass instSize - 1.
	proxies := resid hiddenObjects
				select: [:each | (each isKindOf: stbProxy) and: [each viewClass == refView]].
	proxies do: 
			[:each |
			| id |
			id := each instVars at: idIndex.
			(referenced includes: id)
				ifFalse: 
					[referenced add: id.
					self addReferencedViews: id to: referenced]]!

allReferencedClasses
	"Private - Answer a <Set> of all the classes in the image which are referenced from the
	image. Note that classes with instances are considered to be referenced too."

	| referencedClasses |
	referencedClasses := Set new.
	rootClasses do: [:each | self addClassesReferencedByClass: each to: referencedClasses].
	"Now add any classes which are not referenced but which have instances"
	(Class allClasses difference: referencedClasses) do: 
			[:each |
			each primAllSubinstances notEmpty
				ifTrue: 
					[self addClassesReferencedByClass: each to: referencedClasses.
					"Class might be in 'ignored' set, but we can't remove it anyway because it has instances, so add regardless"
					referencedClasses add: each]].
	^referencedClasses!

allResourcesStripped
	self logComment: 'All resources stripped'.
	runFlags := runFlags maskSet: AllResourcesStripped.
	self finishedStrippingResources.
	self finishedWithAll: #(#logRemainingResources)!

appendManifestContent: manifest 
	self isConsoleApplication 
		ifFalse: 
			["GUI apps need common controls, console apps do not."
			manifest 
				nextPutAll: '<dependency><dependentAssembly><assemblyIdentity type="win32" name="Microsoft.Windows.Common-Controls" version="6.0.0.0" processorArchitecture="X86" publicKeyToken="6595b64144ccf1df" language="*"/></dependentAssembly></dependency>']!

behaviorsWithIgnoredAspectSetters
	"Answer a weak <collection> of <Behavior>s to be excluded from aspect-setter preservation."

	| answer addBehaviors |
	answer := Set new.
	addBehaviors := 
			[:eachClass |
			answer
				add: eachClass;
				add: eachClass class].
	BasicImageStripper withAllSubclassesDo: addBehaviors.
	self classCategoriesToIgnoreAspectSetters
		do: [:each | (ClassCategory name: each) classes do: addBehaviors].
	{Symbol. Interval} do: addBehaviors.
	^answer!

binaryStoreOn: aStream
	"Stores the receiver in a binary form on aStream that can be reconstituted using 
	Object class>>binaryReadFrom:. Clear down some caching instance variables
	first to minimize file size."

	elementStack := logStream := rootClasses := developmentClasses := preservedMessages := nil.
	super binaryStoreOn: aStream.!

buildApplication
	"Private - Strips the image and saves an executable file according to the configuration held by the
	receiver. Notification messages are sent to notifier in the form of #status: messages. N.B.
	This method is in the 'must not strip' category to prevent the receiver pulling the rug out
	from under its own feet!!"

	| stubFile path saveBlock |
	"Check stub file exists before we get too far"
	stubFile := self checkedStubFilePath.
	path := self executablePath.
	saveBlock := self saveBlock: path.
	rootClasses := #().
	self finishedWithAll: #(#checkedStubFilePath #executablePath).
	
	[
	[| developmentMethods messageMap classBuildingMethods classRemovingMethods |
	self snapshotDevelopmentClasses.
	developmentMethods := self developmentMethods.
	classBuildingMethods := self classBuildingMethods.
	classRemovingMethods := self classRemovingMethods.
	self findPotentialAspectAccessors: self behaviorsWithIgnoredAspectSetters.
	"Save down a collection of all sent messages for use later in determining unimplemented
	messages which are still sent - these can arise, for example, where the package stripping
	process removes loose methods."
	messageMap := self buildMessageMap.
	self prepareToDeployWith: stubFile to: path.
	self finishedWithAll: #(#prepareToDeployWith:to:).

	"The first stage is driven by the package dependency graph, and unloads packages not reachable from the root package."
	self packageDrivenStage.
	self finishedWithAll: #(#packageDrivenStage).

	"Next we start to iteratively walk the call graph from root classes, finding references to classes and called methods, removing any that are unreachable, and repeating until there are no more unreferenced classes or methods."
	self prepareCycle1: classBuildingMethods.
	classBuildingMethods := nil.
	self finishedWithAll: #(#prepareCycle1:).
	"First cycle of walking transitive closure from roots, but not removing any resources"
	self removeRedundantObjects: false.

	"Next we remove remaining development artefacts, and then perform another iterative cycle."
	self prepareCycle2: developmentMethods.
	developmentMethods := nil.
	self finishedWithAll: #(#prepareCycle2:).
	"Have another go at finding redundant stuff now dev. classes out of the picture, but
	 this time strip resources too"
	self removeRedundantObjects: true.
	self prepareCycle3.
	self finishedWithAll: #(#prepareCycle3).
	self removeRedundantObjects: true.
	self prepareCycle4.
	self finishedWithAll: #(#prepareCycle4).
	self removeRedundantObjects: false.
	self prepareCycle5.
	self finishedWithAll: #(#prepareCycle5).
	self removeRedundantObjects: false.
	self prepareCycle6: classRemovingMethods.
	classRemovingMethods := nil.
	self finishedWithAll: #(#prepareCycle6:).
	self removeRedundantMethods.
	self
		finishedWithAll: #(#stripRedundantMethods #removeRedundantMethods #removeRedundantMethodsOnceFrom: #saveBlock:).
	self logSentMessages: messageMap.
	messageMap := nil.
	self finishedWithAll: #(#logSentMessages:).

	"Remove as much as we can of the remainder of ImageStripper in case it hangs around"
	self finishedWithStripping.
	self finishedWithAll: #(#finishedWithStripping).
	self shrinkSymbolTable]
			on: Notification
			do: 
				[:ex |
				self onNotification: ex.
				ex resume]]
			on: Error
			do: [:ex | self onError: ex].
	SessionManager inputState queueDeferredAction: saveBlock.
	self finishedWithAll: #(#shrinkSymbolTable #buildApplication)!

buildManifest: assemblyNameString description: assemblyDescriptionString version: aVersionResource
	"GUI apps need common controls, console apps do not."

	| manifest |
	manifest := String writeStream.
	manifest locale: Locale invariant.
	manifest nextPutAll: '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'.
	'%<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">%<assemblyIdentity name="<1s>" version="<3s>" processorArchitecture="X86" type="win32" />%<description><2s>%</description>'
		expandMacrosWithArguments: {assemblyNameString.
				assemblyDescriptionString.
				aVersionResource fileVersion}
		on: manifest.
	self appendManifestContent: manifest.
	manifest nextPutAll: '</assembly>'.
	^manifest contents!

buildMessageMap
	^self
		referencesFromObjectsInClasses: (Class allClasses difference: BasicImageStripper withAllSubclasses)!

buildPreservedMessages
	"Private - Build the set of all the message selectors that are to be preserved due, for example, to
	membership of one of the requiredMethodCategories."

	preservedMessages := Set new.
	self requiredMethodCategories
		do: [:each | each asMethodCategory methods do: [:method | preservedMessages add: method selector]].
	"Currently we have to preserve all resources because they are referenced by string name
	(except from ReferenceViews in other resources). Resources will only be removed if the
	owning class is removed."
	ResourceIdentifier allResourceIdentifiers do: [:each | preservedMessages add: each selector]!

buildRootClasses
	"Private - Build the <IdentitySet> of <Class>es that are considered the roots of the 
	application being deployed."

	rootClasses := Set new.
	rootClasses addAll: self requiredClasses.
	rootClasses addAll: self rootPackage classes

	"We can't discard the methods only used here at this stage, not until the runtime session manager is installed"!

buildSupersentMessageMap
	supersentMethods := WeakIdentityDictionary newWithWeakKeys: 1500.
	self allMethodsInClasses: Class allClasses
		do: 
			[:each |
			each superMessages do: 
					[:selector |
					| target |
					target := each methodClass superclass lookupMethod: selector.
					target isNil ifFalse: [(supersentMethods at: target ifAbsentPut: [WeakSet new]) add: each]]].
	^supersentMethods!

checkedStubFilePath
	"Private - Answer the full path to the stub file. 
	Check that it exists, and if not raise an error."

	| stubFile |
	stubFile := self stubFilePath.
	^(File exists: stubFile)
		ifTrue: [stubFile]
		ifFalse: [self error: 'Stub file not found: ''' , stubFile , '''']!

class: aBehavior overrides: aSymbol
	^(aBehavior compiledMethodAt: aSymbol ifAbsent: []) notNil or: 
			[aBehavior instanceClass isNonInstantiable
				and: [aBehavior subclasses allSatisfy: [:sub | self class: sub overrides: aSymbol]]]!

classBuildingMethods
	^self class classBuildingMethodCategoryNames
		collect: [:each | {each. WeakArray withAll: each asMethodCategory methods}]!

classCategoriesToIgnoreAspectSetters
	"Answer a <collection> of <String> names of the categories of class to be excluded from
	aspect-setter preservation."

	^#('Collections-Streams' 'Collections-Support' 'External-Data-Unstructured' 'External-Libraries' 'External-Libraries-Win32' 'Kernel-Classes' 'Kernel-Exception Handling' 'Kernel-Methods' 'Kernel-Processes' 'Kernel-Support' 'Magnitude-Numbers' 'System-Exception Handling' 'System-Support' 'System-Binary storage')!

classesReferencedByMethod: aCompiledMethod
	"Private - Answers a Set of all the  classes referred to by aCompiledMethod's literal
	frame"

	| classes |
	classes := Set new: 5.
	aCompiledMethod literalReferencesDo: 
			[:each |
			| value |
			value := (each isMemberOf: VariableBinding) ifTrue: [each value] ifFalse: [each].
			"Don't add a class just because it is referenced by one of its own methods"
			(value class isMeta and: [value ~~ aCompiledMethod methodClass instanceClass])
				ifTrue: [classes add: value]].
	^classes!

classReferencesToIgnore
	"Private - Answer an IdentitySet of Classes that should not be considered to
	be referenced in the final stripped image"

	^(Set withAll: self notRequiredClasses)
		addAll: self developmentClasses;
		yourself!

classRemovingMethods
	| methods |
	methods := Set new: 200.
	self class classRemovingMethodCategoryNames
		do: [:each | methods addAll: each asMethodCategory methods].
	^WeakArray withAll: methods!

clearChangedProperties
	"Private - Remove development change flags."

	Class allSubinstances do: [:b | b isChanged: false]!

closeAllDevelopmentTools
	"Private - Forcibly close all development tools so that they may be stripped from the image."

	"Ensure any junk or sensitive information in the Transcript is removed."

	| devShells |
	Transcript clear.
	devShells := self viewsToClose.
	devShells do: [:each | each destroy].
	SessionManager current
		closeConsole;
		perform: #closeAllHelp.
	SessionManager inputState
		pumpMessages;
		processDeferredActions;
		purgeDeadWindows.

	"Update the desktop to redraw under removed windows"
	OS.UserLibrary default updateWindow: OS.UserLibrary default getDesktopWindow.
	self collectGarbage: 3!

closeChangeLog
	"Private - Close the change log so that the activities of the image stripper do not bloat it."

	SourceManager default closeChangesFile!

closeExternalLibraries
	"Private - Close all default sub-instances of <ExternalLibrary>s."

	External.DynamicLinkLibrary closeAllDefaults!

closeLog
	[elementStack isEmpty] whileFalse: 
			[self endElement: true.
			self].
	logStream close.
	logStream := nil!

compileExternalStructures
	"Answer whether the stripping process will  attempt to compile all
	ExternalStructures so that the template definitions may be removed"

	^flags allMask: CompileStructsMask!

copyAndUpdateStub: stubFile to: exeFile
	"Private - Copy over the stub and update it if required. Answer the name of the
	new stub file."

	self logComment: 'Creating executable stub: ' , exeFile.
	File createDirectoryPath: (File splitPathFrom: exeFile).
	File copy: stubFile to: exeFile.
	File isWriteable: exeFile set: true.
	self isResourceUpdatingRequired
		ifTrue: 
			[OS.KernelLibrary default updateResourcesOf: exeFile do: [:hUpdate | self updateStubResources: hUpdate]].
	^exeFile!

defaultStubFilePath
	^FileLocator installRelative localFileSpecFor: self stubFile!

destroyNotifier
	notifier destroy.
	notifier := DeafObject.Current!

developmentClasses
	"Answers a weak <collection> of all the classes that are in the basic development system.
	These are marked by being in the 'Development' category"

	^developmentClasses select: [:each | each ~~ DeadObject.Current]!

developmentMethods
	"Answer a <dictionary> mapping the names of development categories to <CompiledMethod>s in those categories, for all categories which are considered part of the development system, and which, therefore, are not normally required in a deployed application. The methods are stored in WeakArrays to allow them to be GC'd if they are removed for other reasons."

	^self class developmentMethodCategoryNames
		collect: [:name | {name. WeakArray withAll: name asMethodCategory methods}]!

developmentResources
	"Answer a <collection> of <ResourceIdentifier>s representing any development system resources that
	are not owned directly by development classes."

	| devres |
	devres := OrderedCollection new.
	#(#{UI.Dialog} #{UI.Presenter} #{UI.AXControlSite} #{UI.AXValueConvertingControlSite})
		do: [:s | s ifDefined: [:d | devres add: (ResourceIdentifier class: d name: 'Default view')]].
	^devres!

disableClassChangeFlagging
	"Private - Disable class change recording - the properties consume a lot of space."

	Smalltalk removeEventsTriggeredFor: Smalltalk developmentSystem!

disableDevelopmentSystem
	"Private - Before removing anything, prevent the package manager from reacting to events, also
	We don't need categories, etc, maintained, so unwire SmalltalkSystem from dev. events"

	self systemPackageManager onPreStripImage.
	Smalltalk removeEventsTriggeredFor: Smalltalk developmentSystem!

emptyMethodDictionariesOfStubbornClasses
	"Answer whether the method dictionaries of classes that refuse to uninstall with their
	owning package should be emptied. Although this is somewhat of a risky option, it does
	help one to track down the root of stripping problems since it helps to remove the knock
	on effects of the original source of the problem."

	^flags allMask: PurgeStubbornClassesMask!

endElement: aBoolean 
	aBoolean ifTrue: [logStream crtab: elementStack size - 1].
	self endTag!

endTag
	logStream
		nextPutAll: '</';
		nextPutAll: elementStack removeLast;
		nextPut: $>;
		flush!

executableName
	"Answer the executable name to which the resultant stripped image will
	be saved"

	^executableName!

executablePath
	"Answer the full path of the executable to which the resultant stripped image will
	be saved"

	^self executableName notEmpty
		ifTrue: [FileLocator imageRelative localFileSpecFor: self executableName]
		ifFalse: ['Please choose an executable name']!

exeFileExtension
	"Answer the extension to use for the executable file"

	^self runtimeSessionManagerClass asSessionManagerClass imageExtension!

externalStructureClasses
	| packagedClasses |
	packagedClasses := self packagedClasses.
	^super externalStructureClasses intersection: packagedClasses!

finalActions
	"Private - Perform the last few steps before the image is saved."

	
	[self removeMyClass.
	self collectGarbage: 3.
	self logManifest.
	self closeLog] on: Error
			do: [:ex | self onError: ex].
	self
		finishedWithAll: #(#removeMyClass #finalActions #saveExecutable:keepImage: #logManifest #notify:status: #closeLog #onError: #logStrippingError: #finishedWithAll:)!

findPotentialAspectAccessors: aCollection
	| behaviors excluded |
	self preserveAspectSetters
		ifFalse: 
			[potentialAspectGetters := potentialAspectSetters := #().
			^self].
	potentialAspectGetters := WeakSet new.
	potentialAspectSetters := WeakSet new.
	excluded := self nonAspectSetterCategories collect: [:each | each asMethodCategory].
	behaviors := Class allBehaviors difference: aCollection.
	behaviors do: 
			[:each |
			each hasMethods
				ifTrue: 
					[| nonAspectSetters catalogue |
					nonAspectSetters := Set new.
					catalogue := each methodsCatalogue.
					excluded do: 
							[:eachCat |
							(catalogue lookup: eachCat)
								ifNotNil: [:selectors | selectors do: [:eachSelector | nonAspectSetters add: eachSelector]]].
					self findPotentialAspectAccessorsIn: each excluding: nonAspectSetters]]!

findPotentialAspectAccessorsIn: aClass excluding: aCollection
	"Private - Add to the <Set> argument all those methods of the <Behavior>, aClass, that
	_might_ be aspect setters. These are judged as those with one-argument keyword selectors for
	which there is a corresponding unary selector implemented in the class or its superclasses.
	This is, of course, a conservative judgement and will tend to result in more methods being
	preserved than are strictly required. Methods matching this criteria that are known not to
	be aspect setters can be added to one of the categories listed in #nonAspectSetters."

	aClass methodDictionary do: 
			[:each |
			"Assume all one argument keyword messages are potentially setters if a
			corresponding zero argument 'getter' exists"
			(each argumentCount == 1
				and: [each selector last = $: and: [(aCollection includes: each selector) not]])
					ifTrue: 
						[(Symbol findInterned: (each selector first: each selector size - 1))
							ifNotNil: 
								[:getSelector |
								(aClass lookupMethod: getSelector)
									ifNotNil: 
										[:getter |
										potentialAspectGetters add: getter.
										potentialAspectSetters add: each]]]]!

finishedStrippingResources
	self
		finishedWithAll: #(#addReferencedViews:to: #allResourcesStripped #resourcesForClasses: #scanResourcesForViewReferences: #removeRedundantResources: #removeResources:reason: #removeResource:)!

finishedWithStripping
	"Private - Pair away the stripping methods of the receiver's class that might still exist.
	These will mainly be methods that are used by the stripping algorithm itself, and which
	it cannot therefore remove."

	potentialAspectGetters := potentialAspectSetters := #().
	self
		finishedWithAll: #(#allMethodsInClasses:do: #allResourcesStripped #ignoreViewReferences #messagesSentByClasses: #resourcesForClasses: #removeMethod: #removeMethods:reason:force: #logMethod: #speciallySentMessages #finishedWithStripping).
	self shrinkHashedCollections!

foldDuplicatesConstants
	"Private - Fold any duplicate objects that we can such as literals and strings."

	self foldDuplicateStrings.
	self foldDuplicateBytecodes.
	self
		finishedWithAll: #(#stripDuplicateBytecodes #stripDuplicateStrings #foldDuplicateStrings #foldDuplicateBytecodes #logFold:folded:total:)!

getClassInstanceStats
	| stats classes totalInstances totalMemory |
	stats := MemoryManager current primInstanceStats: nil.
	classes := IdentityDictionary new: stats size // 6.
	totalInstances := 0.
	totalMemory := 0.
	1 to: stats size
		by: 3
		do: 
			[:i |
			(stats at: i) isMeta
				ifTrue: 
					[| instClass |
					totalInstances := totalInstances + (stats at: i + 1).
					totalMemory := totalMemory + (stats at: i + 2).
					instClass := (stats at: i) instanceClass.
					(classes includesKey: instClass) ifFalse: [classes at: instClass put: #(0 0)]]
				ifFalse: [classes at: (stats at: i) put: {stats at: i + 1. stats at: i + 2}]].
	classes at: Class put: {totalInstances. totalMemory}.
	^classes!

ignoreViewReferences
	"Answer whether view resources should NOT be scanned for references to other
	view resources."

	^flags allMask: IgnoreViewReferencesMask!

includeManifestResource
	"Answer whether the resulting executable will include a Windows XP application manifest
	resource. This resource allows the application to adopt Windows XP look and feel when
	running on Windows XP without shipping a separate manifest file (which remains an
	option, since it will override the resource)."

	^(flags allMask: NoXPManifestMask) not!

initialTidy
	"Private - Discard methods of the receiver that are no longer required now that early processing is finished
	and the runtime session manager has been installed."

	self logReferencesToClasses
		ifFalse: [self finishedWithAll: #(#logReferencesToClass: #logReference:)].
	self
		finishedWithAll: #(#actualRequiredPackages #buildRootClasses #disableDevelopmentSystem  #installRuntimeSessionManager #isConsoleApplication #logPreservedClasses #logRemainingPackages #packagedClasses #removeRedundantPackages #requiredClasses #requiredPackageNames #rootClasses #rootPackage #runtimeSessionManagerClass #stripRedundantPackages #verifyRequiredPackages #vmReferencedClasses)!

installRuntimeSessionManager
	"Private - Install the application <SessionManager>. For an application deployed with its
	main window open this can often be just <RuntimeSessionManager> itself."

	self runtimeSessionManagerClass installNew!

isConsoleApplication
	^self runtimeSessionManagerClass asSessionManagerClass isConsoleApplication!

isResourceUpdatingRequired
	"Answer whether this <ImageStripper> would like to update any resources in the executable stub."

	^true!

isToGo
	"Answer whether the resulting executable is to be deployed standalone (that is without
	a separate VM DLL). This is the default."

	^flags allMask: ToGoMask!

isUnattended
	^flags allMask: UnattendedMask!

keepImageFile
	"Answer whether the raw image file (which has the same name as the deployed exe/dll but with
	no extension) should be retained. By default it is deleted, but it can be useful for debugging
	purposes, or (if a plug-in image) for use with IMAGE tag."

	^flags allMask: KeepImageMask!

logComment: aString
	self notify: aString.
	logStream
		crtab: elementStack size;
		nextPutAll: '<!!-- ';
		nextPutAll: aString;
		nextPutAll: ' -->';
		flush!

logConfiguration: aString
	self startElement: 'Configuration' attributes: #().
	self
		logElement: 'ImagePath'
		attributes: #()
		value: SessionManager current imagePath.
	self
		logElement: 'TimeStamp'
		attributes: #()
		value: DateAndTime now printString.
	self
		logElement: 'Target'
		attributes: #()
		value: aString.
	self logImageStats.
	self logDevelopmentCategories.
	self logPreservedMessages.
	self endElement: true!

logDevelopmentCategories
	self startElement: 'DevelopmentMethodCategories' attributes: #().
	self class developmentMethodCategoryNames do: 
			[:each |
			self
				logElement: 'MethodCategory'
				attributes: #()
				value: each.
			self].
	self endElement: true!

logFileExtension
	"Answer the extension to use for the log file"

	^'xml'!

logFileName
	"Answers the file name to use for logging strip info"

	^File path: self executablePath extension: self logFileExtension!

logImageStats
	"Private - Dump some stats about the image to the log file to help determine
	the effectiveness of the stripping process."

	self startElement: 'ImageStatistics' attributes: #().
	self
		logElement: 'ObjectCount'
		attributes: #()
		value: MemoryManager current objectCount.
	self
		logElement: 'ClassCount'
		attributes: #()
		value: Metaclass primAllInstances size.
	self
		logElement: 'MethodCount'
		attributes: #()
		value: CompiledMethod primAllSubinstances size.
	self
		logElement: 'SymbolCount'
		attributes: #()
		value: Symbol primAllInstances size.
	self endElement: true!

logLiveClasses
	"Answer true if the stripping process will emit a list of live classes to the log before each strip cycle. 
	This can be useful in diagnosing why certain methods and classes may be getting removed unexpectedly, but it results it does rather bloat the log and so is off by default."

	^flags allMask: LogLiveClassesMask!

logManifest
	"Private - Logs a list of the remaining classes to the log stream (if any)."

	self startElement: 'Manifest' attributes: #().
	self logImageStats.
	self logRemainingClasses.
	developmentClasses := nil.
	(runFlags allMask: AllResourcesStripped) ifFalse: [self logRemainingResources].
	self endElement: true.
	self
		finishedWithAll: #(#logImageStats #logRemainingResources #logRemainingClasses #logReferencesToClasses)!

logPackagePrerequisites
	"Answer whether the stripping log should include a package pre-requisites trace showing
	the package dependencies that exist for the deployed package."

	^flags allMask: LogReferencesMask!

logPreservedClasses
	"Private - Logs a list of the classes that form the root set for the application."

	| classes developmentRoots |
	classes := rootClasses.
	self startElement: 'RootClasses' attributes: #().
	developmentRoots := OrderedCollection new.
	classes asArray sort do: 
			[:each |
			| attributes |
			attributes := (self developmentClasses includes: each)
						ifTrue: 
							[developmentRoots add: each.
							{'development' -> true}]
						ifFalse: [#()].
			self
				logElement: 'RootClass'
				attributes: attributes
				value: each name].
	developmentClasses removeAll: developmentRoots.
	self endElement: true!

logPreservedMessages
	"Private - Logs a list of the classes that form the root set for the application."

	self startElement: 'RequiredMethodCategories' attributes: #().
	self requiredMethodCategories asArray sort do: 
			[:each |
			self
				logElement: 'MethodCategory'
				attributes: #()
				value: each asString.
			self].
	self endElement: true.
	self startElement: 'PreservedMessages' attributes: #().
	preservedMessages asArray sort do: 
			[:each |
			self
				logElement: 'Selector'
				attributes: #()
				value: each.
			self].
	self endElement: true!

logReference: anObject
	self
		logElement: 'Reference'
		attributes: {'identityHash' -> anObject identityHash}
		value: ([anObject printString] on: Error , StackOverflow do: [:ex | anObject basicPrintString])!

logReferencesToClass: anAssociation
	| refs fugitive instances binding |
	binding := anAssociation key bindingOrNil.
	fugitive := binding isNil.
	refs := fugitive
				ifTrue: 
					[anAssociation key allReferences reject: 
							[:r |
							r == anAssociation key class
								or: [r == anAssociation or: [(r isKindOf: CompiledMethod) and: [r methodClass == anAssociation key]]]]]
				ifFalse: [binding allReferences reject: [:r | r == Smalltalk or: [r == Processor activeProcess]]].
	refs isEmpty
		ifFalse: 
			[self startElement: 'References' attributes: #().
			refs do: [:ref | self logReference: ref].
			self endElement: true].
	(fugitive and: [(anAssociation value at: 1) > 0]) ifFalse: [^self].
	self startElement: 'Instances' attributes: #().
	instances := anAssociation key allInstances.
	1 to: instances size
		do: 
			[:i |
			| inst |
			inst := instances at: i.
			self startElement: 'Instance' attributes: {'identityHash' -> inst identityHash}.
			inst allReferences
				do: [:ref | (ref == instances or: [ref == Processor activeProcess]) ifFalse: [self logReference: ref]].
			self endElement: true.
			self].
	self endElement: true!

logReferencesToClasses
	"Answer whether the log of classes remaining in the image should include a column to
	show all the references to those classes. This can be useful in determining why a class
	remains in the image after stripping."

	^flags allMask: LogReferencesMask!

logRemainingClasses
	"Private - Logs a list of the remaining classes to the log stream (if any)."

	"N.B. This method is deliberately constructed not to use any full blocks to simplify debug reference tracing to the classes. It also uses some verbose code constructs to minimize the amount of code it adds to the referenced set."

	| stats statsForClass totalInstances totalMemory totalMethods totalClassMethods classes selectors devClasses |
	stats := self getClassInstanceStats.
	statsForClass := stats at: Class.
	totalInstances := statsForClass at: 1.
	totalMemory := statsForClass at: 2.
	totalMethods := 0.
	totalClassMethods := 0.
	self startElement: 'Classes' attributes: {'count' -> stats size}.
	classes := Array writeStream.
	stats associationsDo: [:each | classes nextPut: each].
	stats := classes contents asArray sort.
	self logReferencesToClasses ifTrue: [self collectGarbage: 2].
	devClasses := self developmentClasses.
	1 to: stats size
		do: 
			[:i |
			| each classStats attributes name count memory |
			each := stats at: i.
			classStats := each value.
			attributes := Array writeStream.
			name := each key name.
			attributes nextPut: 'name' -> name.
			count := classStats at: 1.
			attributes nextPut: 'count' -> count.
			memory := classStats at: 2.
			attributes nextPut: 'memoryUsage' -> memory.
			name asQualifiedReference isDefined ifFalse: [attributes nextPut: 'unbound' -> true].
			(devClasses includes: each key) ifTrue: [attributes nextPut: 'development' -> true].
			self startElement: 'Class' attributes: attributes contents.
			self startElement: 'Methods' attributes: {'count' -> each key methodDictionary size}.
			selectors := Array writeStream.
			each key methodDictionary keysDo: [:selector | selectors nextPut: selector].
			selectors contents sort do: 
					[:selector |
					self
						logElement: 'Method'
						attributes: #()
						value: selector].
			self endElement: true.
			self startElement: 'ClassMethods' attributes: {'count' -> each key class methodDictionary size}.
			selectors reset.
			each key class methodDictionary keysDo: [:selector | selectors nextPut: selector].
			selectors contents sort do: 
					[:selector |
					self
						logElement: 'Method'
						attributes: #()
						value: selector].
			self endElement: true.
			self logReferencesToClasses ifTrue: [self logReferencesToClass: each].
			self endElement: true.
			totalInstances := totalInstances + count.
			totalMemory := totalMemory + memory.
			totalMethods := totalMethods + each key methodDictionary size.
			totalClassMethods := totalClassMethods + each key class methodDictionary size].
	self endElement: true.
	self
		logElement: 'TotalInstances'
		attributes: #()
		value: totalInstances.
	self
		logElement: 'TotalMemory'
		attributes: #()
		value: totalMemory.
	self
		logElement: 'TotalMethods'
		attributes: #()
		value: totalMethods.
	self
		logElement: 'TotalClassMethods'
		attributes: #()
		value: totalClassMethods!

logRemainingPackages
	"Private - Write a list of the remaining packages to the stripping log."

	self startElement: 'RetainedPackages' attributes: #().
	(self systemPackageManager packages collect: [:each | each name]) asArray sort do: 
			[:each |
			self
				logElement: 'Package'
				attributes: #()
				value: each.
			self].
	self endElement: true!

logRemainingResources
	"Private - Logs a list of the remaining classes to the log stream (if any).
	N.B. This method is deliberately constructed not to use any true blocks
	to simplify debug reference tracing to the classes.."

	| total resman |
	self startElement: 'RemainingResources' attributes: #().
	total := 0.
	resman := ResourceIdentifier.
	resman allResourceIdentifiersDo: 
			[:each |
			self startElement: 'Resource' attributes: #().
			self
				logElement: 'OwningClass'
				attributes: #()
				value: each owningClass name.
			self
				logElement: 'Name'
				attributes: #()
				value: each name.
			self
				logElement: 'ByteSize'
				attributes: #()
				value: each resource size.
			self endElement: true.
			total := total + each resource size].
	self
		logElement: 'TotalResourcesSize'
		attributes: #()
		value: total.
	self endElement: true!

logSentMessages: aWeakIdentityDictionary
	"Log the messages preserved only because they are assumed to be aspect setters"

	| remainingClasses implemented originallySent allRefs diff sent |
	self startElement: 'SentMessages' attributes: #().
	originallySent := Set new.
	aWeakIdentityDictionary do: [:each | originallySent addAll: each].
	#{BasicImageStripper} valueOrNil
		ifNil: 
			["This shouldn't be possible, but..."
			remainingClasses := Class allClasses]
		ifNotNil: 
			[:basicImageStripper |
			remainingClasses := Set new.
			Class
				allClassesDo: [:each | (each includesBehavior: basicImageStripper) ifFalse: [remainingClasses add: each]]].
	allRefs := self messagesSentByClasses: remainingClasses.
	self finishedWithAll: #(#messagesSentByClasses:).
	sent := allRefs intersection: originallySent.
	sent asArray sort do: 
			[:each |
			self
				logElement: 'Selector'
				attributes: #()
				value: each.
			self].
	self endElement: true.
	self startElement: 'UnimplementedMessages' attributes: #().
	implemented := Set new: remainingClasses size * 10.
	self allMethodsInClasses: remainingClasses do: [:each | implemented add: each selector].
	diff := sent difference: implemented.
	diff asArray sort do: 
			[:each |
			self
				logElement: 'Selector'
				attributes: #()
				value: each.
			self].
	self endElement: true.
	potentialAspectSetters isEmpty ifTrue: [^self].
	self startElement: 'PreservedAspectSetters' attributes: #().
	potentialAspectSetters asArray sort
		do: [:each | (sent identityIncludes: each selector) ifFalse: [self logMethod: each]].
	self endElement: true.
	potentialAspectSetters := nil!

logStrippingError: anError
	logStream isNil ifTrue: [^self].
	self
		logElement: 'Error'
		attributes: {'class' -> anError class name}
		value: anError description.
	logStream flush!

logValue: anObject
	| string |
	string := anObject displayString.
	(string includesAnyOf: '<>
	&')
		ifTrue: 
			[string do: 
					[:each |
					(##(LookupTable new
						at: $& put: '&amp;';
						at: $< put: '&lt;';
						at: $> put: '&gt;';
						at: $" put: '&quot;';
						shrink
					"						at: Character tab put: '&#9';
						at: Character lf put: '&#10';
						at: Character cr put: '&#13';")
							at: each
							ifAbsent: []) ifNil: [logStream nextPut: each] ifNotNil: [:quoted | logStream nextPutAll: quoted]
					"						at: Character tab put: '&#9';
						at: Character lf put: '&#10';
						at: Character cr put: '&#13';"]]
		ifFalse: [logStream nextPutAll: string]!

manifestResourceId
	^self runtimeSessionManagerClass asSessionManagerClass isDLL 
		ifTrue: [ISOLATIONAWARE_MANIFEST_RESOURCE_ID]
		ifFalse: [CREATEPROCESS_MANIFEST_RESOURCE_ID]!

messagesSentByClasses: aCollectionOfClasses
	^(super messagesSentByClasses: aCollectionOfClasses)
		addAll: preservedMessages;
		yourself!

nonAspectSetterCategories
	"Answer a collection of the <String> names of categories of methods that are known not to be
	aspect setters even if they appear to be (i.e. they are have 1 argument selectors, the stem
	of which is the selector of a zero-arg method that may be an aspect getter). For example
	Collection implements the 'converting' methods #asSortedCollection: and #asSortedCollection,
	but of course asSortedCollection is a conversion operation, not an aspect"

	^#('not an aspect' 'adding' 'comparing' 'converting' 'copying' 'dependency' 'enumerating' 'evaluating' 'exceptions' 'initializing' 'instance creation' 'operations' 'geometry' 'event handling' 'realizing/unrealizing' 'updating' 'transformations')!

notify: aStringMessage
	notifier status: aStringMessage!

notifyClassesOfCompletedStrip
	"Private - Inform all classes that the imagehas been stripped, by sending them an
	#onPostStripImage message if they implement it directly. This is an opportunity for classes
	to reverse any tentative uninitialization they may have done in a #onPreStripImage method in
	anticipation of being unloaded. Since the classes are still loaded, we give them the
	opportunity to reinitiatlize themselves."

	Class allClassesDo: 
			[:e |
			(e class compiledMethodAt: #onPostStripImage ifAbsent: [])
				ifNotNil: [:method | method value: e withArguments: #()]]!

notifyClassesOfImminentStrip
	"Private - Inform all classes that the image is about to be stripped, by sending them an
	#onPreStripImage message if they implement it directly. This is an opportunity for the
	classes to contribute to the stripping process, for example by minimizing lazily initialized
	state. The fewer classes there are with instances in the image, the smaller the set of roots
	from which the retained functionality need be calculated."

	self startElement: 'PreStrip' attributes: #().
	Class allClassesDo: 
			[:e |
			(e class compiledMethodAt: #onPreStripImage ifAbsent: [])
				ifNotNil: 
					[:method |
					e onPreStripImage.
					self removeMethod: method]].
	self endElement: true!

notRequiredMethodCategories
	"Answer an IdentitySet of MethodCategorys whose methods are known to be not required
	and should be forcibly dropped during an image strip. Can be overridden by subclasses to 
	alter the stripping strategy"

	| categoryNames |
	categoryNames := Set with: 'examples' with: 'must strip'.
	self stripDeprecatedMethods ifTrue: [categoryNames add: 'deprecated'].
	self stripSubclassResponsibility
		ifTrue: 
			["It should be safe to remove these methods in a properly tested application
			 as they are errors intended for the developer."
			categoryNames add: 'subclass responsibility'].
	self stripShouldNotImplement
		ifTrue: 
			["Ditto"
			categoryNames add: 'should not implement'].
	^categoryNames!

onError: anError
	"Private - An error occur while stripping. Heaven knows what state the image may be in
	now so just report the error and forcibly exit"

	| text |
	self logStrippingError: anError.
	self closeLog.
	text := 'The following error occurred while stripping. 
The image MUST exit immediately, but see crash dump (if configured).

'
				, anError description.
	OS.UserLibrary default
		messageBox: nil
		lpText: text
		lpCaption: SessionManager current applicationName
		uType: ##(MB_OK | MB_ICONERROR | MB_TASKMODAL | MB_SETFOREGROUND).
	VMLibrary default crashDump: anError description.
	SessionManager current primQuit: -1!

onNotification: aNotification
	self logComment: aNotification description!

openLogFile
	"Private - Open log stream if requested"

	elementStack := OrderedCollection new.
	logStream := self writeLogFile
				ifTrue: 
					[File createDirectoryPath: (File splitPathFrom: self logFileName).
					FileStream write: self logFileName text: true]
				ifFalse: [String writeStream].
	logStream
		nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>';
		cr.
	self startElement: 'Lagoon'
		attributes: {'xmlns:xsi' -> 'http://www.w3.org/2001/XMLSchema-instance'.
				'xsi:noNamespaceSchemaLocation' -> 'Lagoon.xsd'}!

packagedClasses
	| packagedClasses |
	packagedClasses := Set new.
	self actualRequiredPackages
		do: [:eachPackage | eachPackage classesDo: [:eachClass | packagedClasses add: eachClass]].
	^packagedClasses!

packageDrivenStage
	self prepareExternalStructures.
	"These methods must be stripped BEFORE redundant packages, as they may cause pre-requisites
	we don't want in the deployed application"
	self removeNotRequiredMethods.
	self installRuntimeSessionManager.
	self removeRedundantPackages.
	self logRemainingPackages.
	self buildRootClasses.
	self logPreservedClasses.
	self collectGarbage: 3!

prepareCycle1: aWeakArrayOfMethods
	self disableDevelopmentSystem.
	self assert: [SessionManager current isRuntime].
	self initialTidy.

	"Before we can remove any classes, we must ensure isChanged properties are removed"
	self clearChangedProperties.
	self disableClassChangeFlagging.
	self removeDevelopmentSystemResidue.
	self removeClassBuilder: aWeakArrayOfMethods.
	self purgeIcons.
	"Empty the receiver's class' method dictionary"
	self class class methodDictionary: nil.
	self
		finishedWithAll: #(#disableDevelopmentSystem #initialTidy #clearChangedProperties #disableClassChangeFlagging #removeDevelopmentSystemResidue #removeClassBuilder: #purgeIcons:)!

prepareCycle2: developmentMethods
	self foldDuplicatesConstants.
	self removeDevelopmentObjects: developmentMethods.
	"We can now remove abstract unreachable methods without concern that they may be made reachable by the removal of development methods."
	runFlags := runFlags bitOr: RemoveAbstractUnreachable.
	self emptySystemDictionary.
	self finishedWithAll: #(#foldDuplicatesConstants #removeDevelopmentObjects: #emptySystemDictionary)!

prepareCycle3
	self destroyAndRemoveProgress.

	"Some of the libraries may no longer be required."
	self closeExternalLibraries.

	"Necessary to clear these before other class meta-info in order to allow GUID to be stripped."
	self removeClassGuids.
	self finishedWithAll: #(#destroyAndRemoveProgress #closeExternalLibraries #removeClassGuids)!

prepareCycle4
	(runFlags noMask: AllResourcesStripped) ifTrue: [self finishedStrippingResources].
	self finishedWithAll: #(#finishedStrippingResources)!

prepareCycle5
	supersentMethods := nil.	"Dispense with detection of unreachable methods of abstract classes, as these should be done now"
	#(#class:overrides: #unreachableMethodsOfNonInstantiablesIn: #removeRedundantMethodsOnceFrom:)
		do: [:each | ##(self) removeSelector: each]!

prepareCycle6: aWeakArrayOfMethods
	"Private - Prepare for the final cycle of removing unsent methods."

	"Class removal will no longer be possible after the next message is sent. This is the point to insert any 
	debug trace to determine why a class remains in the image"

	self removeClassUninstallation: (aWeakArrayOfMethods select: [:each | each ~~ DeadObject.Current]).
	self removeClassMetaInfo.
	self notifyClassesOfCompletedStrip.
	self
		finishedWithAll: #(#notifyClassesOfCompletedStrip #removeClassMetaInfo #removeRedundantObjects: #removeRedundantClassesAndResources: #shouldRemoveResources #stripRedundantResources)!

prepareToDeployWith: stubFile to: path
	supersentMethods := self buildSupersentMessageMap.
	self buildPreservedMessages.
	self logConfiguration: path.
	self copyAndUpdateStub: stubFile to: path.
	self
		closeChangeLog;
		closeAllDevelopmentTools;
		runPreStripScript.
	self notifyClassesOfImminentStrip.
	self collectGarbage: 3!

prepareToStrip
	"Perform pre-image stripping actions, such as opening the log file.
	This is invoked before even the development tools have been closed.
	Answer whether to proceed with the application deployment."

	runFlags := 0.
	self openLogFile.
	^self preStripCheck!

preserveAspectSetters
	"Answers true if we should preseve methods used as aspect setters (#blah:) if it is likely 
	that their selectors are	are composed programmatically. If this is the case their messages 
	will be sent via a #perform: and may	not appear to be  referenced by any method's literal 
	frame. Subclasses may override this method to answer false if can be guaranteed that an an
	application does not compose selectors in this way, or if the methods have been explicitly
	placed in a 'must not strip' category."

	^flags allMask: PreserveAspectsMask!

preStripCheck
	"Private - Perform pre-image stripping checks, such as whether any packages have cyclic
	pre-requisites.
	Answer whether the checks passed and it is OK to continue with the deployment."

	^true!

preStripScript
	"Answer the pre-image stripping script which allows for custom image stripping actions
	such as removing classes from the development category if one wishes to preserve them
	or perhaps forcibly removing stubborn methods."

	^preStripScript ?? ''!

preStripTidy
	"Private - Remove any methods of ImageStripper that are no longer required to ensure these don't impact the calculated package pre-reqs when they are determined"

	super preStripTidy.
	"We have have done the resource updating."
	versionResource := nil.
	self
		finishedWithAll: #(#appendManifestContent: #behaviorsWithIgnoredAspectSetters #binaryStoreOn: #buildManifest:description:version: #buildMessageMap #buildPreservedMessages #buildSupersentMessageMap #classBuildingMethods #classCategoriesToIgnoreAspectSetters #classRemovingMethods #closeAllDevelopmentTools #closeChangeLog #copyAndUpdateStub:to: #defaultStubFilePath #developmentMethodCategoryNames #developmentMethods #executableName #exeFileExtension #findPotentialAspectAccessors: #findPotentialAspectAccessorsIn:excluding: #ignoreViewReferences: #includeManifestResource #isResourceUpdatingRequired #isToGo #isUnattended #keepImageFile #logConfiguration: #logDevelopmentCategories #logFileExtension #logFileName #logPackagePrerequisites #logPreservedMessages #logReferencesToClasses: #manifestResourceId #nonAspectSetterCategories #notifyClassesOfImminentStrip #openLogFile #prepareToStrip #preserveAspectSetters #preStripCheck #preStripScript #preStripScript: #referencesFromObjectsInClasses: #requiredMethodCategories #retainInstVarNames: #rootPackage: #runPreStripScript #snapshotDevelopmentClasses #snapshotType #stripAndSave #stripAndSaveWithProgress #stripDeprecatedMethods #stripShouldNotImplement #stripSubclassResponsibility #stubFile #stubFilePath #updateIconResource: #updateStringTableResource: #updateStubResources: #updateVersionResource: #updateXPManifestResource: #versionResource #versionResource: #viewsToClose #writeLogFile)!

progressDialogClass
	^ImageStripperProgress!

purgeIcons
	"Private - If there are no open windows, then we can safely purge the icon image manager."

	(SessionManager inputState topLevelWindows
		reject: [:each | each isKindOf: ImageStripperProgress]) isEmpty
		ifTrue: [#{Icon} ifDefined: [:iconClass | iconClass clear]]!

purgeStubbornClass: aClass
	"Private - Remove what we can of a stubborn class that refuses to uninstall for some reason."

	self emptyMethodDictionariesOfStubbornClasses ifFalse: [^self].
	self logComment: 'Purging class ' , aClass name.
	aClass clearGuid.
	aClass class methodDictionary: nil.
	aClass methodDictionary: nil!

referencesFromObjectsInClasses: aCollection
	"Private - Build a dictionary that maps code objects in the collection of classes,
	aCollection, to the symbols and classes that they references. This is used to construct an
	initial picture of true (or probably true) message sends in the image so that later we can
	compare this against the symbolic references remaining and therefore distinguish between
	actual (or probable) message sends, and ordinary symbol literals."

	| messageMap |
	messageMap := WeakIdentityDictionary newWithWeakKeys: aCollection size * 20.
	messageMap at: VMLibrary put: self speciallySentMessages.
	self allMethodsInClasses: aCollection
		do: 
			[:eachMethod |
			| messages |
			messages := eachMethod messages
						remove: eachMethod selector ifAbsent: [];
						yourself.
			messages isEmpty ifFalse: [messageMap at: eachMethod put: messages]].

	"Add all messages that can be triggered by events"
	_EventsRegister
		do: [:each | each do: [:mseq | mseq messagesDo: [:ms | messageMap at: ms put: {ms selector}]]].

	"Note that we don't add the preserved aspect setters to the sent messages as this would prevent removal of non-aspect setter 
	methods with the same selectors. Rather we prebuild a collection of potential aspect setters, and block deletion of these."

	"Finally add any that may be sent from resources in the remaining classes"
	(self resourcesForClasses: aCollection) do: 
			[:eachResId |
			| objects res hiddenSymbols hiddenClassNames |
			hiddenSymbols := Set new.
			hiddenClassNames := Set new.
			res := eachResId resource.
			objects := eachResId hiddenObjects.
			objects do: 
					[:eachObject |
					eachObject class isMeta
						ifTrue: [hiddenClassNames add: eachObject name]
						ifFalse: 
							[(eachObject class conformsToProtocol: #messageSender)
								ifTrue: 
									[| messages |
									messages := eachObject messages.
									hiddenSymbols addAll: messages]]].
			messageMap at: res put: hiddenSymbols].
	^messageMap!

removeClass: aClass
	"Private - Removes aClass from the image. Answer the number of classes that
	were actually removed (subclasses may be removed too)."

	(rootClasses includes: aClass)
		ifTrue: 
			[Warning
				signal: 'The class ' , aClass name , ' cannot be removed because it is a root of the application'.
			^0].
	^super removeClass: aClass!

removeClassBuilder: aCollection
	"Private - Remove the ClassBuilder and associated class adding/renaming methods if so configured."

	self stripClassBuilder
		ifTrue: 
			[self startElement: 'StripClassBuilder' attributes: #().
			aCollection do: 
					[:pair |
					self
						removeMethods: ((pair at: 2) select: [:method | method ~~ DeadObject.Current]) sort
						reason: (pair at: 1)
						force: true].
			self removeClassNamed: #ClassBuilder.
			self endElement: true].
	self finishedWithAll: #(#stripClassBuilder)!

removeClassGuids
	"Private - Remove all (presumably) redundant class info"

	(self stripClassInfo and: [self stripClassGuids])
		ifTrue: 
			[| guids |
			self notify: 'Removing class GUIDs'.
			Class allClassesDo: [:each | each clearGuid].
			guids := GUID allSubinstances.
			self startElement: 'RemainingGUIDs' attributes: {'count' -> guids size}.
			guids do: 
					[:each |
					self
						logElement: 'GUID'
						attributes: #()
						value: each.
					self].
			self endElement: true].
	self finishedWithAll: #(#stripClassGuids)!

removeDevelopmentObjects: devMethods
	"Private - Remove any remaining vestiges of the development system.
	Answer the number of development classes removed."

	| totalRemoved |
	self startElement: 'StripDevelopmentObjects' attributes: #().
	self notify: 'Removing remaining development classes and methods'.
	"Remove the methods first in case they reference the development classes"
	totalRemoved := 0.
	self stripDevelopmentMethods
		ifTrue: 
			[devMethods do: 
					[:pair |
					| live |
					live := (pair at: 2) select: [:each | each ~~ DeadObject.Current].
					totalRemoved := totalRemoved + (self
										removeMethods: live
										reason: (pair at: 1)
										force: true)]]
		ifFalse: [0].
	self collectGarbage: 3.
	self stripDevelopmentClasses
		ifTrue: 
			[| removed |
			[(removed := self removeClasses: self developmentClasses sort reason: 'development') > 0]
				whileTrue: 
					[self collectGarbage: 2.
					totalRemoved := totalRemoved + removed]].
	self endElement: totalRemoved > 0.
	self finishedWithAll: #(#stripDevelopmentClasses #stripDevelopmentMethods).
	"developmentClasses inst. var. must be nilled later as still needed for reporting purposes"
	^totalRemoved + 2!

removeMethod: aCompiledMethod
	| getSelector |
	super removeMethod: aCompiledMethod.
	"If removed a method that was previously identified as an aspect getter, we can stop preversing the corresponding setters"
	(potentialAspectGetters identityIncludes: aCompiledMethod) ifFalse: [^true].
	potentialAspectGetters remove: aCompiledMethod.
	getSelector := aCompiledMethod selector.
	(Symbol findInterned: (getSelector copyWith: $:))
		ifNotNil: 
			[:setSelector |
			aCompiledMethod methodClass withAllSubclassesDo: 
					[:each |
					(each canUnderstand: getSelector)
						ifFalse: 
							[(each compiledMethodAt: setSelector ifAbsent: [])
								ifNotNil: [:setter | potentialAspectSetters remove: setter ifAbsent: []]]]].
	^true!

removeMyClass
	"Private - As one of the last steps, remove the receiver's class from the system.
	It will still continue to exist while the instance is alive of course."

	| current superclass |
	preservedMessages := potentialAspectSetters := nil.
	current := self class.
	
	[superclass := current superclass.
	[current environment removeClass: current] on: Error do: [:e | e resume: true].
	current == BasicImageStripper]
			whileFalse: [current := superclass].
	self collectGarbage: 2!

removeRedundantMethods
	"Private - Removes redundant methods from the pseudo image.
	Answers the count of methods stripped"

	| sum classes |
	sum := 0.
	classes := Class allClasses.
	self logLiveClasses
		ifTrue: 
			[self startElement: 'LiveClasses' attributes: #().
			classes sort do: 
					[:each |
					self
						logElement: 'LiveClass'
						attributes: #()
						value: each name].
			self endElement: true].
	
	[| count |
	count := self removeRedundantMethodsOnceFrom: classes.
	sum := sum + count.
	count > 0]
			whileTrue.
	^sum!

removeRedundantMethodsOnceFrom: aCollectionOfClasses
	| removed unreachable |
	removed := super removeRedundantMethodsOnceFrom: aCollectionOfClasses.
	(removed ~~ 0 or: [runFlags noMask: RemoveAbstractUnreachable]) ifTrue: [^removed].
	unreachable := self unreachableMethodsOfNonInstantiablesIn: aCollectionOfClasses.
	"As the methods are unreachable, we can safely remove them whether or not they are potentially aspect setters"
	^self
		removeMethods: unreachable
		reason: 'abstract unreachable'
		force: true!

removeRedundantPackages
	| required |
	required := super removeRedundantPackages.
	#{SmalltalkSystem} isDefined ifTrue: [flags := flags bitOr: RetainDevSysMask].
	^required!

removeRedundantResources: referencedClasses
	| liveResources deadResources |
	liveResources := self resourcesForClasses: referencedClasses.
	liveResources isEmpty
		ifTrue: 
			[self allResourcesStripped.
			^0].

	"Remove all but the live resources"
	deadResources := ResourceIdentifier allResourceIdentifiers difference: liveResources.
	^self removeResources: deadResources reason: 'unreferenced'!

requiredClasses
	"Answer a <set> of Classes that are known to be required and that
	should be preserved during an image strip. Can be overridden by subclasses to alter the stripping
	strategy"

	^(Set new: 32)
		add: Process;
		add: ProcessorScheduler;
		add: self runtimeSessionManagerClass asSessionManagerClass;
		addAll: self vmReferencedClasses;
		yourself!

requiredMethodCategories
	"Answer a collection of method categories whose methods are known to be required
	and should be preserved during an image strip. Can be overridden by subclasses to 
	alter the stripping strategy"

	"By default we preserve only the 'must not strip' and the view resource categories"

	^#('must not strip')

	!

requiredPackageNames
	"Answers a <Set> of the names of the packages required by application. These should already 
	have been loaded into the image."

	^Set new
		add: rootPackageName;
		yourself!

resourcesForClasses: classes
	"Private - Answer a <collection> of the <ResourceIdentifiers> for all resources that are potentially 
	referenced from the specified <Set> of classes"

	"Implementation Note: Use a very dumb brute force approach to avoid incorrectly removing
	resources based on locating all literal strings. The only type of resource reference that
	will not be detected is that where the name is constructed dynamically (e.g. 'My', ' view'),
	or where the string has been stored into an instance or class variable imperatively. If
	either technique has been used, then either the stripping of resources should be disabled,
	or a passive expression should be inserted into a method known to be retained containing the
	names of the view resources of its class to retain."

	| resourceIds literalStrings |
	literalStrings := Set new.
	self allMethodsInClasses: classes
		do: [:m | m literalsDo: [:l | l class == AnsiString ifTrue: [literalStrings add: l]]].
	resourceIds := Set new.
	classes do: 
			[:class |
			class resourceIdentifiersDo: 
					[:each |
					(literalStrings includes: each name)
						ifTrue: [resourceIds add: (ResourceIdentifier class: class name: each name)]]].
	self ignoreViewReferences
		ifFalse: [resourceIds addAll: (self scanResourcesForViewReferences: resourceIds)].
	^resourceIds!

retainInstVarNames
	"Answer whether the stripping process should preserve instance variable names.
	Normally these are not required unless certain reflective messages are used."

	^flags allMask: RetainInstVarNamesMask!

rootClasses
	"Private - Answer an IdentitySet of the classes that must be preserved by the receiver's
	stripping process. This includes all of the classes in the receiver's associated package
	together with the known required classes"

	rootClasses isNil ifTrue: [self buildRootClasses].
	^rootClasses!

rootPackage
	"Answers the root package associated with the receiver, or nil if none. We hold the 
	package name rather than the package to avoid saving the latter out as part of a 
	binary file out"

	^rootPackageName notNil 
		ifTrue: [self systemPackageManager packageNamed: rootPackageName ifNone: [rootPackageName := nil]]!

runPreStripScript
	"Run the user strip script (if any). This is invoked after the development tools 
	have been closed, but before any destructive actions have been performed. 
	However the script itself may contain destructive actions, and therefore the 
	stripping cannot, in general, be aborted after this point."

	| script filer |
	script := self preStripScript.
	script notEmpty ifFalse: [^self].
	filer := self class sourceManager chunkFilerOn: script readStream.
	filer evaluationContext: self.
	[filer fileIn] on: Compiler errorClass
		do: 
			[:x |
			self logComment: ('Error in pre-strip script at line <1p>: <2s>' expandMacrosWith: x line
						with: x errorMessage).
			x resume]!

runtimeSessionManagerClass
	"Answer the class of runtime session manager to install into
	a stripped image"

	^runtimeSessionManagerClass!

saveBlock: aString
	^[self saveExecutable: aString keepImage: (flags allMask: KeepImageMask)]!

saveExecutable: exePath keepImage: retainImage
	"Private - Save a snapshot of the current image to an executable. This is appended to the
	executable stub at the <readableString> path, exePath.
	Following the completion of this process the development system MUST exit"

	| image imageFile unattended |
	unattended := flags allMask: UnattendedMask.
	self finalActions.
	image := File path: exePath extension: 'tmp'.
	self snapshotImage: image.

	"We can't send any more messages to the receiver after this point as its method dictionary
	 has been removed."
	imageFile := File open: image mode: #read.
	
	[| imageData |
	imageData := ByteArray new: imageFile size.
	imageFile read: imageData.
	OS.KernelLibrary default updateResourcesOf: exePath
		do: 
			[:hUpdate |
			(OS.KernelLibrary default
				updateResource: hUpdate
				lpType: RT_RCDATA
				lpName: 100
				wLanguage: 0
				lpData: imageData
				cbData: imageData size) ifFalse: [OS.KernelLibrary default systemError]]]
			ensure: 
				[imageFile close.
				retainImage ifFalse: [File delete: image]].
	unattended
		ifFalse: 
			[OS.UserLibrary default
				messageBox: nil
				lpText: 'The image has been stripped and deployed to the executable file:
' , exePath
						, '

The development system will now exit.'
				lpCaption: 'Dolphin Lagoon'
				uType: ##(MB_ICONINFORMATION | MB_TASKMODAL | MB_SETFOREGROUND)].

	"No arguments - just exit"
	SessionManager current primQuit: 0!

scanResourcesForViewReferences: aCollectionOfResourceIdentifiers
	"Private - Scan the <Set> of <ResourceIdentifier>s, resourceIds, for references to other resources, and answer
	a further set of them. Any newly added resources are recursively scanned for further references."

	| refd |
	refd := Set new.
	aCollectionOfResourceIdentifiers
		do: [:each | (refd includes: each) ifFalse: [self addReferencedViews: each to: refd]].
	^refd!

shouldPreserveMethod: aCompiledMethod
	^(potentialAspectSetters identityIncludes: aCompiledMethod) !

shouldRemoveResources
	^self stripRedundantResources and: [runFlags noMask: AllResourcesStripped]!

shrinkHashedCollections
	"Private - Minimize set of hashed collections."

	Set primAllSubinstances do: [:each | each shrink]!

shrinkSymbolTable
	"Private - Resize symbol table. Must be performed at a very high priority to be
	safe."

	[Symbol resizeTable: 20] forkAt: Processor timingPriority!

snapshotDevelopmentClasses
	"Use a WeakArray to remove dependency on WeakSet"

	developmentClasses := WeakArray withAll: (Object classCategoryClass name: 'Development') classes!

snapshotImage: anImageFilename
	"Private - Save the current stripped image out to anImageFilename"

	"We can now empty the method dictionary as every method still required
	 is on the stack."

	self class methodDictionary: nil.
	"Flush out the garbage again"
	self collectGarbage: 2.
	SessionManager current
		onPreSaveImage;
		primSnapshot: anImageFilename
			backup: false
			type: snapshotType ?? 6
			maxObjects: nil;
		onPostSaveImage!

snapshotType
	^snapshotType!

startElement: aString attributes: aCollection
	self startTag: aString attributes: aCollection.	
	logStream flush!

startTag: aString attributes: aCollection 
	logStream
		crtab: elementStack size;
		nextPut: $<;
		nextPutAll: aString.
	aCollection do: 
			[:each | 
			logStream
				space;
				display: each key;
				nextPut: $=;
				nextPut: $";
				display: each value;
				nextPut: $"].
	logStream nextPut: $>.
	elementStack addLast: aString!

stripAndSave
	"Strips the image and saves an executable file according to the configuration held by the 
	receiver."

	self prepareToStrip
		ifTrue: 
			[notifier := DeafObject.Current.
			self buildApplication]!

stripAndSaveWithProgress
	"Strips the image and saves an executable file according to the configuration held by the receiver
	displaying progress in an ImageStripperProgress dialog."

	self prepareToStrip
		ifTrue: 
			[notifier := self progressDialogClass show.
			self buildApplication]!

stripClassBuilder
	"Answer true if the stripping process will remove the class builder.
	This is normally safe, unless run-time construction of classes, etc, is
	anticipated. The class builder has to be removed separately because
	it is intimately involved in the stripping of other classes."

	^(flags bitAnd: StripClassBuilderMask | RetainDevSysMask) == StripClassBuilderMask!

stripClassGuids
	"Answer whether the class GUIDs should be nulled at the end of the stripping process.
	This is appropriate unless the application makes use of these to uniquely identify classes.
	Note that guids of COMInterface's subclasses will not be nulled, as these are in fact the
	IIDs of the corresponding interfaces."

	^flags allMask: ClearGuidsMask!

stripClassInfo
	"Answer true if the stripping process will remove class information such as
	instance variable names, pools names and comments"

	^flags allMask: StripClassInfoMask!

stripDeprecatedMethods
	"Answer true if the stripping process will remove those methods which
	have been deprecated. This option may need to be turned off for an
	older application."

	^flags allMask: StripDeprecatedMask!

stripDevelopmentClasses
	"Answer true if the stripping process will forcibly remove those classes in development categories (e.g. the 'Development' category)."

	^flags noMask: RetainDevSysMask!

stripDevelopmentMethods
	"Answer true if the stripping process will forcibly remove those methods in the development-only categories, e.g. the 'development' category."

	^flags noMask: RetainDevSysMask!

stripDuplicateBytecodes
	"Answer true if the stripping process will fold instances of duplicate byte code arrays 
	into one common instance"

	^flags allMask: FoldBytecodesMask!

stripDuplicateStrings
	"Answer true if the stripping process will fold instances of duplicate strings
	into one common instance"

	^flags allMask: FoldStringsMask!

stripRedundantClasses
	"Answer true if the receiver will attempt to remove redundant classes not
	referenced from a root package during its stripping process."

	^flags allMask: StripClassesMask!

stripRedundantMethods
	"Answer true if the receiver will attempt to remove redundant methods during
	its stripping process"

	^flags allMask: StripMethodsMask!

stripRedundantPackages
	"Answer true if the receiver will attempt to remove redundant packages not
	referenced from a root package during its stripping process."

	^flags allMask: StripPackagesMask!

stripRedundantResources
	"Answer true if the receiver will attempt to remove redundant resources not referenced from
	a root package during its stripping process. Note that class stripping must be enabled too."

	^flags allMask: StripResourcesMask!

stripShouldNotImplement
	"Answer true if the stripping process will remove those methods which
	consist of a 'self shouldNotImplement' error report. It should be safe to
	remove such methods in a properly tested application, since they are
	intended as an indication of a logic error for the developer."

	^flags allMask: StripShouldNotImplMask!

stripSubclassResponsibility
	"Answer true if the stripping process will remove those methods which consist of a 'self
	subclassResponsibility' error report. It should be safe to remove such methods in a properly
	tested application, since they are intended as an indication of a logic error for the
	developer."

	^flags noMask: RetainSubclassRespMask!

stubFile
	"Answers the name of the standard stub file to be used by the receiver if no stubFilePath is explicitly set."

	^self isConsoleApplication 
		ifTrue: [self isToGo ifTrue: ['ConsoleToGo.exe'] ifFalse: ['ConsoleStub.exe']]
		ifFalse: [self isToGo ifTrue: ['GUIToGo.exe'] ifFalse: ['GUIStub.exe']]!

stubFilePath
	"Answer the full path to the stub file. "

	^stubFilePath isNil
		ifTrue: [self defaultStubFilePath]
		ifFalse: [FileLocator imageRelative localFileSpecFor: stubFilePath]!

unreachableMethodsOfNonInstantiablesIn: aCollectionOfClasses
	"Private - Any methods of non-instantiable classes overridden in all remaining subclasses are redundant if not supersent.
	Note that we only include instance side methods, as there is a class instance (i.e. the metaclasses are never non-instantiable)."

	| abstractClasses unreachable |
	unreachable := Array writeStream.
	abstractClasses := aCollectionOfClasses select: [:each | each isNonInstantiable].
	abstractClasses do: 
			[:each |
			each subclasses isEmpty
				ifTrue: [unreachable nextPutAll: each methodDictionary]
				ifFalse: 
					[each methodDictionary do: 
							[:method |
							| supersends |
							supersends := supersentMethods lookup: method.
							(each subclasses allSatisfy: [:sub | self class: sub overrides: method selector])
								ifTrue: 
									[(supersends isNil or: [supersends isEmpty])
										ifTrue: [unreachable nextPut: method]
										ifFalse: 
											["Notification signal: method printString , ' is supersent'"
											]]]]].
	^unreachable contents!

updateIconResource: anExternalHandle
	"Update the Icon resource of the exe/dll stub through the supplied resource update
	handle. This is the icon that is displayed by Windows as the default for a .EXE"

	#todo. "67: Update the icon resource - this is non-trivial"
!

updateStringTableResource: anExternalHandle
	"Update the String Table resource of the exe/dll stub through the supplied resource update
	handle."
!

updateStubResources: anExternalHandle
	"Private - Update the resources of the exe/dll stub through the supplied resource update
	handle."

	self
		updateIconResource: anExternalHandle;
		updateVersionResource: anExternalHandle;
		updateStringTableResource: anExternalHandle;
		updateXPManifestResource: anExternalHandle.
	"Version resource is no longer needed"
	versionResource := nil.
	OS.VersionLibrary closeDefault!

updateVersionResource: anExternalHandle
	"Update the Version resource of the exe/dll stub through the supplied resource update
	handle."

	self versionResource ifNotNil: [:version | version updateResource: anExternalHandle]!

updateXPManifestResource: anExternalHandle
	"Private - Update the Windows XP application manifest resource."

	| ver strings file manifest assemblyName |
	self includeManifestResource ifFalse: [^self].
	ver := self versionResource.
	ver isNil ifTrue: [^nil].
	strings := ver stringTables at: '040904e4' ifAbsent: [ver stringTables values lookup: 1].
	strings isNil ifTrue: [^nil].
	assemblyName := String writeStream.
	#('CompanyName' 'ProductName') do: 
			[:each |
			(strings lookup: each)
				ifNotNil: 
					[:string |
					assemblyName
						nextPutAll: (string copyWithout: $.);
						nextPut: $.]].
	file := (strings at: 'InternalName' ifAbsent: ['']) copyWithout: $..
	file isEmpty ifTrue: [file := File splitStemFrom: self executableName].
	assemblyName nextPutAll: file.
	manifest := self
				buildManifest: assemblyName contents
				description: (strings at: 'FileDescription' ifAbsent: [file , ' Application'])
				version: ver.
	(OS.KernelLibrary default
		updateResource: anExternalHandle
		lpType: RT_MANIFEST
		lpName: self manifestResourceId
		wLanguage: ver languageId
		lpData: manifest
		cbData: manifest size) ifFalse: [OS.KernelLibrary default systemError]!

verifyRequiredPackages
	| packages required found missing |
	packages := super verifyRequiredPackages.
	found := packages collect: [:each | each name].
	required := self requiredPackageNames.
	(missing := required - found) notEmpty
		ifTrue: 
			[| message |
			"There were some required packages missing from the image"
			message := String new writeStream.
			message
				nextPutAll: 'Not all of the packages required to deploy the application were present in the image. 
The following packages were missing: ';
				cr;
				cr.
			missing do: 
					[:each |
					message
						display: each;
						cr].
			message
				cr;
				nextPutAll: 'Click Ignore to continue with the deployment.'.
			Warning signal: message contents].
	^packages!

versionResource
	"Answer the <VersionResource> describing the version resource to be built into	
	the deployed application/dll."

	| originalFilename |
	versionResource isNil
		ifTrue: 
			[versionResource := OS.VersionResource forPath: self stubFilePath.
			"Stub might not contain a version resource"
			versionResource isNil ifTrue: [^nil]].
	originalFilename := File splitFilenameFrom: self executableName.
	versionResource stringTables do: 
			[:each |
			(each includesKey: 'OriginalFilename') ifTrue: [each at: 'OriginalFilename' put: originalFilename]].
	^versionResource!

viewsToClose
	| topViews shellClasses packagedClasses |
	topViews := SessionManager inputState topLevelWindows.
	self isConsoleApplication ifTrue: [^topViews].
	shellClasses := Set new.
	#(#{SmalltalkToolShell} #{SmalltalkWorkspaceDocument} #{TestRunner}) do: 
			[:each |
			each ifDefined: [:class | class withAllSubclassesDo: [:shellClass | shellClasses add: shellClass]]].
	"We want to close all views/presenters that are not in the required packages"
	packagedClasses := self packagedClasses.
	^topViews select: 
			[:each |
			| presenterType |
			presenterType := each presenter class.
			(shellClasses includes: presenterType) or: [(packagedClasses includes: presenterType) not]]!

vmReferencedClasses
	"Answer a <collection> of all the classes referenced directly by the VM.
	These must not be stripped!!"

	^VMLibrary default registry select: 
			[:each |
			each class isMeta and: [(#('GUID' 'PoolConstantsDictionary') includes: each name asString) not]]!

writeLogFile
	"Answer true if the receiver will write a log file during
	its stripping process"

	^flags allMask: WriteLogMask! !
!Tools.ImageStripper categoriesFor: #actualRequiredPackages!accessing!private! !
!Tools.ImageStripper categoriesFor: #addClassesReferencedByClass:to:!helpers!private! !
!Tools.ImageStripper categoriesFor: #addClassesReferencedByMethod:to:!helpers!private! !
!Tools.ImageStripper categoriesFor: #addReferencedViews:to:!helpers!private! !
!Tools.ImageStripper categoriesFor: #allReferencedClasses!operations!private! !
!Tools.ImageStripper categoriesFor: #allResourcesStripped!operations!private! !
!Tools.ImageStripper categoriesFor: #appendManifestContent:!helpers!private! !
!Tools.ImageStripper categoriesFor: #behaviorsWithIgnoredAspectSetters!configuration!public! !
!Tools.ImageStripper categoriesFor: #binaryStoreOn:!binary filing!public! !
!Tools.ImageStripper categoriesFor: #buildApplication!must not strip!operations!private! !
!Tools.ImageStripper categoriesFor: #buildManifest:description:version:!helpers!private! !
!Tools.ImageStripper categoriesFor: #buildMessageMap!helpers!private! !
!Tools.ImageStripper categoriesFor: #buildPreservedMessages!helpers!private! !
!Tools.ImageStripper categoriesFor: #buildRootClasses!helpers!private! !
!Tools.ImageStripper categoriesFor: #buildSupersentMessageMap!helpers!private! !
!Tools.ImageStripper categoriesFor: #checkedStubFilePath!accessing!private! !
!Tools.ImageStripper categoriesFor: #class:overrides:!private!testing! !
!Tools.ImageStripper categoriesFor: #classBuildingMethods!accessing!private! !
!Tools.ImageStripper categoriesFor: #classCategoriesToIgnoreAspectSetters!configuration!public! !
!Tools.ImageStripper categoriesFor: #classesReferencedByMethod:!helpers!private! !
!Tools.ImageStripper categoriesFor: #classReferencesToIgnore!configuration!private! !
!Tools.ImageStripper categoriesFor: #classRemovingMethods!accessing!private! !
!Tools.ImageStripper categoriesFor: #clearChangedProperties!operations!private! !
!Tools.ImageStripper categoriesFor: #closeAllDevelopmentTools!operations!private! !
!Tools.ImageStripper categoriesFor: #closeChangeLog!helpers!private! !
!Tools.ImageStripper categoriesFor: #closeExternalLibraries!operations!private! !
!Tools.ImageStripper categoriesFor: #closeLog!operations!private! !
!Tools.ImageStripper categoriesFor: #compileExternalStructures!accessing!public! !
!Tools.ImageStripper categoriesFor: #copyAndUpdateStub:to:!operations!private! !
!Tools.ImageStripper categoriesFor: #defaultStubFilePath!constants!private! !
!Tools.ImageStripper categoriesFor: #destroyNotifier!operations!private! !
!Tools.ImageStripper categoriesFor: #developmentClasses!configuration!public! !
!Tools.ImageStripper categoriesFor: #developmentMethods!accessing!public! !
!Tools.ImageStripper categoriesFor: #developmentResources!configuration!public! !
!Tools.ImageStripper categoriesFor: #disableClassChangeFlagging!operations!private! !
!Tools.ImageStripper categoriesFor: #disableDevelopmentSystem!operations!private! !
!Tools.ImageStripper categoriesFor: #emptyMethodDictionariesOfStubbornClasses!public!testing! !
!Tools.ImageStripper categoriesFor: #endElement:!helpers!private! !
!Tools.ImageStripper categoriesFor: #endTag!helpers!private! !
!Tools.ImageStripper categoriesFor: #executableName!accessing!public! !
!Tools.ImageStripper categoriesFor: #executablePath!accessing!public! !
!Tools.ImageStripper categoriesFor: #exeFileExtension!constants!public! !
!Tools.ImageStripper categoriesFor: #externalStructureClasses!accessing!private! !
!Tools.ImageStripper categoriesFor: #finalActions!helpers!private! !
!Tools.ImageStripper categoriesFor: #findPotentialAspectAccessors:!helpers!private! !
!Tools.ImageStripper categoriesFor: #findPotentialAspectAccessorsIn:excluding:!helpers!private! !
!Tools.ImageStripper categoriesFor: #finishedStrippingResources!helpers!private! !
!Tools.ImageStripper categoriesFor: #finishedWithStripping!operations!private! !
!Tools.ImageStripper categoriesFor: #foldDuplicatesConstants!operations!private! !
!Tools.ImageStripper categoriesFor: #getClassInstanceStats!helpers!private! !
!Tools.ImageStripper categoriesFor: #ignoreViewReferences!accessing!public! !
!Tools.ImageStripper categoriesFor: #includeManifestResource!accessing!public!testing! !
!Tools.ImageStripper categoriesFor: #initialTidy!helpers!private! !
!Tools.ImageStripper categoriesFor: #installRuntimeSessionManager!operations!private! !
!Tools.ImageStripper categoriesFor: #isConsoleApplication!public!testing! !
!Tools.ImageStripper categoriesFor: #isResourceUpdatingRequired!private!testing! !
!Tools.ImageStripper categoriesFor: #isToGo!accessing!public!testing! !
!Tools.ImageStripper categoriesFor: #isUnattended!public!testing! !
!Tools.ImageStripper categoriesFor: #keepImageFile!public!testing! !
!Tools.ImageStripper categoriesFor: #logComment:!event handling!private! !
!Tools.ImageStripper categoriesFor: #logConfiguration:!operations!private! !
!Tools.ImageStripper categoriesFor: #logDevelopmentCategories!operations!private! !
!Tools.ImageStripper categoriesFor: #logFileExtension!constants!public! !
!Tools.ImageStripper categoriesFor: #logFileName!accessing!public! !
!Tools.ImageStripper categoriesFor: #logImageStats!helpers!private! !
!Tools.ImageStripper categoriesFor: #logLiveClasses!public!testing! !
!Tools.ImageStripper categoriesFor: #logManifest!operations!private! !
!Tools.ImageStripper categoriesFor: #logPackagePrerequisites!public!testing! !
!Tools.ImageStripper categoriesFor: #logPreservedClasses!operations!private! !
!Tools.ImageStripper categoriesFor: #logPreservedMessages!operations!private! !
!Tools.ImageStripper categoriesFor: #logReference:!helpers!private! !
!Tools.ImageStripper categoriesFor: #logReferencesToClass:!operations!private! !
!Tools.ImageStripper categoriesFor: #logReferencesToClasses!public!testing! !
!Tools.ImageStripper categoriesFor: #logRemainingClasses!operations!private! !
!Tools.ImageStripper categoriesFor: #logRemainingPackages!operations!private! !
!Tools.ImageStripper categoriesFor: #logRemainingResources!operations!private! !
!Tools.ImageStripper categoriesFor: #logSentMessages:!helpers!private! !
!Tools.ImageStripper categoriesFor: #logStrippingError:!operations-logging!private! !
!Tools.ImageStripper categoriesFor: #logValue:!helpers!private! !
!Tools.ImageStripper categoriesFor: #manifestResourceId!constants!private! !
!Tools.ImageStripper categoriesFor: #messagesSentByClasses:!helpers!private! !
!Tools.ImageStripper categoriesFor: #nonAspectSetterCategories!configuration!public! !
!Tools.ImageStripper categoriesFor: #notify:!operations!private! !
!Tools.ImageStripper categoriesFor: #notifyClassesOfCompletedStrip!operations!private! !
!Tools.ImageStripper categoriesFor: #notifyClassesOfImminentStrip!operations!private! !
!Tools.ImageStripper categoriesFor: #notRequiredMethodCategories!configuration!public! !
!Tools.ImageStripper categoriesFor: #onError:!event handling!private! !
!Tools.ImageStripper categoriesFor: #onNotification:!event handling!private! !
!Tools.ImageStripper categoriesFor: #openLogFile!operations!private! !
!Tools.ImageStripper categoriesFor: #packagedClasses!accessing!private! !
!Tools.ImageStripper categoriesFor: #packageDrivenStage!must not strip!operations!private! !
!Tools.ImageStripper categoriesFor: #prepareCycle1:!must not strip!operations!private! !
!Tools.ImageStripper categoriesFor: #prepareCycle2:!must not strip!operations!private! !
!Tools.ImageStripper categoriesFor: #prepareCycle3!must not strip!operations!private! !
!Tools.ImageStripper categoriesFor: #prepareCycle4!must not strip!operations!private! !
!Tools.ImageStripper categoriesFor: #prepareCycle5!must not strip!operations!private! !
!Tools.ImageStripper categoriesFor: #prepareCycle6:!must not strip!operations!private! !
!Tools.ImageStripper categoriesFor: #prepareToDeployWith:to:!must not strip!operations!private! !
!Tools.ImageStripper categoriesFor: #prepareToStrip!operations!public! !
!Tools.ImageStripper categoriesFor: #preserveAspectSetters!accessing!public! !
!Tools.ImageStripper categoriesFor: #preStripCheck!operations!private! !
!Tools.ImageStripper categoriesFor: #preStripScript!accessing!public! !
!Tools.ImageStripper categoriesFor: #preStripTidy!operations!private! !
!Tools.ImageStripper categoriesFor: #progressDialogClass!constants!public! !
!Tools.ImageStripper categoriesFor: #purgeIcons!helpers!private! !
!Tools.ImageStripper categoriesFor: #purgeStubbornClass:!operations!private! !
!Tools.ImageStripper categoriesFor: #referencesFromObjectsInClasses:!helpers!private! !
!Tools.ImageStripper categoriesFor: #removeClass:!helpers!private! !
!Tools.ImageStripper categoriesFor: #removeClassBuilder:!operations!private! !
!Tools.ImageStripper categoriesFor: #removeClassGuids!operations!private! !
!Tools.ImageStripper categoriesFor: #removeDevelopmentObjects:!operations!private! !
!Tools.ImageStripper categoriesFor: #removeMethod:!private!removing! !
!Tools.ImageStripper categoriesFor: #removeMyClass!operations!private! !
!Tools.ImageStripper categoriesFor: #removeRedundantMethods!operations!private! !
!Tools.ImageStripper categoriesFor: #removeRedundantMethodsOnceFrom:!operations!private! !
!Tools.ImageStripper categoriesFor: #removeRedundantPackages!must not strip!operations!private! !
!Tools.ImageStripper categoriesFor: #removeRedundantResources:!operations!private! !
!Tools.ImageStripper categoriesFor: #requiredClasses!configuration!public! !
!Tools.ImageStripper categoriesFor: #requiredMethodCategories!configuration!public! !
!Tools.ImageStripper categoriesFor: #requiredPackageNames!accessing!public! !
!Tools.ImageStripper categoriesFor: #resourcesForClasses:!helpers!private! !
!Tools.ImageStripper categoriesFor: #retainInstVarNames!public!testing! !
!Tools.ImageStripper categoriesFor: #rootClasses!accessing!private! !
!Tools.ImageStripper categoriesFor: #rootPackage!accessing!public! !
!Tools.ImageStripper categoriesFor: #runPreStripScript!operations!public! !
!Tools.ImageStripper categoriesFor: #runtimeSessionManagerClass!accessing!public! !
!Tools.ImageStripper categoriesFor: #saveBlock:!accessing!private! !
!Tools.ImageStripper categoriesFor: #saveExecutable:keepImage:!operations!private! !
!Tools.ImageStripper categoriesFor: #scanResourcesForViewReferences:!helpers!private! !
!Tools.ImageStripper categoriesFor: #shouldPreserveMethod:!private!removing! !
!Tools.ImageStripper categoriesFor: #shouldRemoveResources!private!removing! !
!Tools.ImageStripper categoriesFor: #shrinkHashedCollections!operations!private! !
!Tools.ImageStripper categoriesFor: #shrinkSymbolTable!operations!private! !
!Tools.ImageStripper categoriesFor: #snapshotDevelopmentClasses!configuration!private! !
!Tools.ImageStripper categoriesFor: #snapshotImage:!operations!private! !
!Tools.ImageStripper categoriesFor: #snapshotType!accessing!public! !
!Tools.ImageStripper categoriesFor: #startElement:attributes:!helpers!private! !
!Tools.ImageStripper categoriesFor: #startTag:attributes:!helpers!private! !
!Tools.ImageStripper categoriesFor: #stripAndSave!operations!public! !
!Tools.ImageStripper categoriesFor: #stripAndSaveWithProgress!operations!public! !
!Tools.ImageStripper categoriesFor: #stripClassBuilder!public!testing! !
!Tools.ImageStripper categoriesFor: #stripClassGuids!accessing!public! !
!Tools.ImageStripper categoriesFor: #stripClassInfo!public!testing! !
!Tools.ImageStripper categoriesFor: #stripDeprecatedMethods!public!testing! !
!Tools.ImageStripper categoriesFor: #stripDevelopmentClasses!accessing!public!testing! !
!Tools.ImageStripper categoriesFor: #stripDevelopmentMethods!accessing!public!testing! !
!Tools.ImageStripper categoriesFor: #stripDuplicateBytecodes!public!testing! !
!Tools.ImageStripper categoriesFor: #stripDuplicateStrings!public!testing! !
!Tools.ImageStripper categoriesFor: #stripRedundantClasses!public!testing! !
!Tools.ImageStripper categoriesFor: #stripRedundantMethods!public!testing! !
!Tools.ImageStripper categoriesFor: #stripRedundantPackages!public!testing! !
!Tools.ImageStripper categoriesFor: #stripRedundantResources!public!testing! !
!Tools.ImageStripper categoriesFor: #stripShouldNotImplement!accessing!public!testing! !
!Tools.ImageStripper categoriesFor: #stripSubclassResponsibility!public!testing! !
!Tools.ImageStripper categoriesFor: #stubFile!public!testing! !
!Tools.ImageStripper categoriesFor: #stubFilePath!accessing!public! !
!Tools.ImageStripper categoriesFor: #unreachableMethodsOfNonInstantiablesIn:!operations!private! !
!Tools.ImageStripper categoriesFor: #updateIconResource:!operations!public! !
!Tools.ImageStripper categoriesFor: #updateStringTableResource:!operations!public! !
!Tools.ImageStripper categoriesFor: #updateStubResources:!operations!private! !
!Tools.ImageStripper categoriesFor: #updateVersionResource:!operations!public! !
!Tools.ImageStripper categoriesFor: #updateXPManifestResource:!operations!private! !
!Tools.ImageStripper categoriesFor: #verifyRequiredPackages!accessing!private! !
!Tools.ImageStripper categoriesFor: #versionResource!accessing!private! !
!Tools.ImageStripper categoriesFor: #viewsToClose!helpers!private! !
!Tools.ImageStripper categoriesFor: #vmReferencedClasses!constants!public! !
!Tools.ImageStripper categoriesFor: #writeLogFile!accessing!public!testing! !

!Tools.ImageStripper class methodsFor!

classBuildingMethodCategoryNames
	"Answer a <collection> of the names of <MethodCategory>s containing methods required only to support building classes.
	These can be removed from the deployed application if the ClassBuilder is being removed."

	^#('class hierarchy-adding' 'class hierarchy-mutating')!

classRemovingMethodCategoryNames
	"Answer a <collection> of the names of <MethodCategory>s containing methods associated with removing classes. These can be stripped from the deployed application if the ClassBuilder is being removed, but only after the deployment process has finished removing classes."

	^#('class hierarchy-removing')!

defaultOptions
	"Private - Answer the default set of flags set up in new of converted instances of the receiver."

	^ClearGuidsMask | StripResourcesMask | StripClassesMask 
		| StripPackagesMask | StripClassBuilderMask 
		| StripMethodsMask | StripShouldNotImplMask 
		| PreserveAspectsMask | FoldStringsMask 
		| FoldMethodDictsMask | FoldBytecodesMask 
		| StripClassInfoMask | CompileStructsMask 
		| WriteLogMask | EmptyMethodDictsMask 
		| ToGoMask!

developmentMethodCategoryNames
	"Answer a <collection> of the names of <MethodCategory>s containing only development methods which must therefore be stripped from the image when it is deployed."

	^#('development' 'class hierarchy-adding')
!

isSafeToEncryptWithProductProtection
	"Answer whether it is save to encrypt the receiver's methods as part of the
	the deployment of a Protected Product application"

	^false! !
!Tools.ImageStripper class categoriesFor: #classBuildingMethodCategoryNames!constants!public! !
!Tools.ImageStripper class categoriesFor: #classRemovingMethodCategoryNames!constants!public! !
!Tools.ImageStripper class categoriesFor: #defaultOptions!constants!private! !
!Tools.ImageStripper class categoriesFor: #developmentMethodCategoryNames!constants!public! !
!Tools.ImageStripper class categoriesFor: #isSafeToEncryptWithProductProtection!development!public! !

