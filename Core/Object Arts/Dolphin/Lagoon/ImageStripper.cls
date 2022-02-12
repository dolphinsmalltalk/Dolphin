"Filed out from Dolphin Smalltalk"!

BasicImageStripper subclass: #ImageStripper
	instanceVariableNames: 'rootPackageName executableName runtimeSessionManagerClass flags preStripScript versionResource _unused8 stubFilePath deploymentContext _unused11 _unused12 _unused13 snapshotType _unused15 _unused16 _unused17 _unused18 _unused19 _unused20 _unused21 _unused22'
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
ImageStripper guid: (Core.GUID fromString: '{87b4c667-026e-11d3-9fd7-00a0cc3e4a32}')!
ImageStripper comment: 'An ImageStripper holds deployment information that indicates how a Dolphin image should be stripped of redundant objects during deployment. ImageStripper is part of the Application Deployment Kit package.

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
!ImageStripper categoriesForClass!MVP-Models! !
!ImageStripper methodsFor!

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
			(pacman packageNamed: each ifNone: nil)
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
	aClass environment ifNotNil: [:namespace | self addClassesReferencedByClass: namespace to: aSet].
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
	refView := #{UI.ReferenceView} valueOrNil.
	stbProxy := #{UI.STBViewProxy} valueOrNil.
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
	deploymentContext rootClasses do: [:each | self addClassesReferencedByClass: each to: referencedClasses].
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
	deploymentContext setRunFlag: AllResourcesStripped.
	self finishedStrippingResources.
	self finishedWithAll: #(#logRemainingResources)!

appendManifestContent: manifest 
	self isConsoleApplication 
		ifFalse: 
			["GUI apps need common controls, console apps do not."
			manifest 
				nextPutAll: '<dependency><dependentAssembly><assemblyIdentity type="win32" name="Microsoft.Windows.Common-Controls" version="6.0.0.0" processorArchitecture="X86" publicKeyToken="6595b64144ccf1df" language="*"/></dependentAssembly></dependency>']!

basicDeleteMethod: aCompiledMethod
	| getSelector |
	super basicDeleteMethod: aCompiledMethod.
	"If removed a method that was previously identified as an aspect getter, we can stop preserving the corresponding setters"
	(deploymentContext aspectGetters identityIncludes: aCompiledMethod) ifFalse: [^true].
	deploymentContext aspectGetters remove: aCompiledMethod.
	getSelector := aCompiledMethod selector.
	(Symbol findInterned: (getSelector copyWith: $:))
		ifNotNil: 
			[:setSelector |
			aCompiledMethod methodClass withAllSubclassesDo: 
					[:each |
					(each canUnderstand: getSelector)
						ifFalse: 
							[(each compiledMethodAt: setSelector ifAbsent: nil)
								ifNotNil: [:setter | deploymentContext aspectSetters remove: setter ifAbsent: nil]]]].
	^true!

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

	deploymentContext := nil.
	super binaryStoreOn: aStream!

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
	self removeRedundantObjects: false id: 1.

	"Next we remove remaining development artefacts, and then perform another iterative cycle."
	self prepareCycle2: developmentMethods.
	developmentMethods := nil.
	self finishedWithAll: #(#prepareCycle2:).
	"Have another go at finding redundant stuff now dev. classes out of the picture, but
	 this time strip resources too"
	self removeRedundantObjects: true id: 2.
	self prepareCycle3.
	self finishedWithAll: #(#prepareCycle3).
	self removeRedundantObjects: true id: 3.
	self prepareCycle4.
	self finishedWithAll: #(#prepareCycle4).
	self removeRedundantObjects: false id: 4.
	self prepareCycle5.
	self finishedWithAll: #(#prepareCycle5).
	self removeRedundantObjects: false id: 5.
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

	| preservedMessages |
	preservedMessages := Set new.
	self requiredMethodCategories
		do: [:each | each asMethodCategory methods do: [:method | preservedMessages add: method selector]].
	"Currently we have to preserve all resources because they are referenced by string name
	(except from ReferenceViews in other resources). Resources will only be removed if the
	owning class is removed."
	ResourceIdentifier allResourceIdentifiers do: [:each | preservedMessages add: each selector].
	deploymentContext preservedMessages: preservedMessages!

buildSupersentMessageMap
	| supersentMethods |
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
	^(aBehavior compiledMethodAt: aSymbol ifAbsent: nil) notNil or: 
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
			"We must preserve the class of the value of shared variable bindings, e.g. the shared vars for DynamicLinkLibrary instances"
			value := (each isKindOf: VariableBinding) ifTrue: [each value] ifFalse: [each].
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

clearSharedPoolConstantsEnvironmentReferences
	SharedPool allSubclasses do: [:each | each bindingsDo: [:var | var environment: nil]].
	self finishedWithAll: #(#clearSharedPoolConstantsEnvironmentReferences)!

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
	User32 updateWindow: User32 getDesktopWindow.
	self collectGarbage: 3!

closeChangeLog
	"Private - Close the change log so that the activities of the image stripper do not bloat it."

	SourceManager default closeChangesFile!

closeExternalLibraries
	"Private - Close all default sub-instances of <ExternalLibrary>s."

	External.DynamicLinkLibrary closeAllDefaults!

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
		ifTrue: [OS.Kernel32 updateResourcesOf: exeFile do: [:hUpdate | self updateStubResources: hUpdate]].
	^exeFile!

defaultStubFilePath
	^FileLocator installRelative localFileSpecFor: self stubFile!

deleteClass: aClass
	"Private - Removes aClass from the image. Answer the number of classes that
	were actually removed (subclasses may be removed too)."

	(deploymentContext rootClasses includes: aClass)
		ifTrue: 
			[Warning
				signal: 'The class ' , aClass name , ' cannot be removed because it is a root of the application'.
			^0].
	^super deleteClass: aClass!

deploymentContext
	^deploymentContext!

developmentClasses
	"Answers a weak <collection> of all the classes that are in the basic development system.
	These are marked by being in the 'Development' category"

	^deploymentContext developmentClasses!

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
	deploymentContext closeLog]
			on: Error
			do: [:ex | self onError: ex].
	self
		finishedWithAll: #(#removeMyClass #finalActions #saveExecutable:keepImage: #logManifest #notify: #onError: #finishedWithAll:).
	deploymentContext  := nil!

findPotentialAspectAccessors: aCollection
	| behaviors excluded |
	self preserveAspectSetters
		ifFalse: 
			[deploymentContext
				aspectGetters: #();
				aspectSetters: #().
			^self].
	deploymentContext aspectGetters: WeakSet new.
	deploymentContext aspectSetters: WeakSet new.
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
				and: [each selector lastCodeUnit = $: and: [(aCollection includes: each selector) not]])
					ifTrue: 
						[(Symbol findInterned: (each selector first: each selector size - 1))
							ifNotNil: 
								[:getSelector |
								(aClass lookupMethod: getSelector)
									ifNotNil: 
										[:getter |
										deploymentContext aspectGetters add: getter.
										deploymentContext aspectSetters add: each]]]]!

finishedStrippingResources
	self
		finishedWithAll: #(#addReferencedViews:to: #allResourcesStripped #resourcesForClasses: #scanResourcesForViewReferences: #removeRedundantResources: #deleteResources:reason: #deleteResource:)!

finishedWithAll: aCollectionOfSymbols
	| methods |
	methods := deploymentContext class methodDictionary.
	aCollectionOfSymbols do: [:each | methods removeKey: each ifAbsent: nil].
	super finishedWithAll: aCollectionOfSymbols!

finishedWithStripping
	"Private - Pair away the stripping methods of the receiver's class that might still exist.
	These will mainly be methods that are used by the stripping algorithm itself, and which
	it cannot therefore remove."

	deploymentContext finishedWithStripping.
	self
		finishedWithAll: #(#allMethodsInClasses:do: #allResourcesStripped #basicDeleteMethod: #ignoreViewReferences #messagesSentByClasses: #resourcesForClasses: #deleteMethod: #deleteMethods: #removeMethods:reason:force: #logMethod: #preservedMessages #speciallySentMessages #finishedWithStripping).
	Set primAllSubinstances do: [:each | each shrink]!

foldDuplicateConstants
	"Private - Fold any duplicate objects that we can such as literals and strings."

	self foldDuplicateLiterals.
	self foldDuplicateBytecodes.
	self
		finishedWithAll: #(#stripDuplicateBytecodes #stripDuplicateStrings #foldDuplicateLiterals #foldDuplicateBytecodes #logFold:folded:total:)!

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
		finishedWithAll: #(#actualRequiredPackages #snapshotRootClasses #installRuntimeSessionManager #isConsoleApplication #logRemainingPackages #packagedClasses #removeRedundantPackages #requiredClasses #requiredPackageNames #rootPackage #runtimeSessionManagerClass #stripRedundantPackages #verifyRequiredPackages #vmReferencedClasses)!

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
	super logComment: aString!

logConfiguration: aString
	self
		startElement: 'Configuration' attributes: #();
		logElement: 'ImagePath'
			attributes: #()
			value: SessionManager current imagePath;
		logElement: 'TimeStamp'
			attributes: #()
			value: DateAndTime now printString;
		logElement: 'Target'
			attributes: #()
			value: aString.
	self logImageStats.
	self logDevelopmentCategories.
	self logRequiredMethodCategories.
	self endElement: true!

logDevelopmentCategories
	self startElement: 'DevelopmentMethodCategories' attributes: #().
	self class developmentMethodCategoryNames do: 
			[:each |
			self
				logElement: 'MethodCategory'
				attributes: #()
				value: each].
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

	self
		startElement: 'ImageStatistics' attributes: #();
		logElement: 'ObjectCount'
			attributes: #()
			value: MemoryManager current objectCount;
		logElement: 'ClassCount'
			attributes: #()
			value: Metaclass primAllInstances size;
		logElement: 'MethodCount'
			attributes: #()
			value: CompiledMethod primAllSubinstances size;
		logElement: 'SymbolCount'
			attributes: #()
			value: Symbol primAllInstances size;
		endElement: true!

logLiveClasses
	"Answer true if the stripping process will emit a list of live classes to the log before each strip cycle. 
	This can be useful in diagnosing why certain methods and classes may be getting removed unexpectedly, but it results it does rather bloat the log and so is off by default."

	^flags allMask: LogLiveClassesMask!

logManifest
	"Private - Logs a list of the remaining classes to the log stream (if any)."

	self startElement: 'Manifest' attributes: #().
	self logImageStats.
	self logRemainingClasses.
	self logRemainingSharedVariables.
	(deploymentContext runFlags allMask: AllResourcesStripped)
		ifFalse: [self logRemainingResources].
	self endElement: true.
	self finishedWithAll: #(#logImageStats #logRemainingClasses #logRemainingSharedVariables #logRemainingResources)!

logPackagePrerequisites
	"Answer whether the stripping log should include a package pre-requisites trace showing
	the package dependencies that exist for the deployed package."

	^flags allMask: LogReferencesMask!

logPreservedClasses
	"Private - Logs a list of the classes that form the root set for the application."

	| classes developmentRoots |
	classes := deploymentContext rootClasses.
	self startElement: 'RootClasses' attributes: #().
	developmentRoots := OrderedCollection new.
	classes asSortedArray do: 
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
				value: each fullName].
	deploymentContext basicDevelopmentClasses removeAll: developmentRoots.
	self endElement: true!

logPreservedMessages
	"Private - Logs a list of the classes that form the root set for the application."

	self startElement: 'RequiredMethodCategories' attributes: #().
	self requiredMethodCategories asSortedArray do: 
			[:each |
			self
				logElement: 'MethodCategory'
				attributes: #()
				value: each asString].
	self
		endElement: true;
		startElement: 'PreservedMessages' attributes: #().
	deploymentContext preservedMessages asSortedArray do: 
			[:each |
			self
				logElement: 'Selector'
				attributes: #()
				value: each].
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
				ifFalse: 
					[binding allReferences reject: [:r | r == binding environment or: [r == Processor activeProcess]]].
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
			self endElement: true].
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
	classes := Array writeStream: stats size.
	stats associationsDo: [:each | classes nextPut: each].
	stats := classes contents asSortedArray.
	(flags allMask: LogReferencesMask) ifTrue: [self collectGarbage: 2].
	devClasses := self developmentClasses.
	1 to: stats size
		do: 
			[:i |
			| each classStats attributes name count memory |
			each := stats at: i.
			classStats := each value.
			attributes := Array writeStream: 2.
			name := each key fullName.
			attributes nextPut: 'name' -> name.
			count := classStats at: 1.
			attributes nextPut: 'count' -> count.
			memory := classStats at: 2.
			attributes nextPut: 'memoryUsage' -> memory.
			each key bindingOrNil ifNil: [attributes nextPut: 'unbound' -> true].
			(devClasses includes: each key) ifTrue: [attributes nextPut: 'development' -> true].
			self
				startElement: 'Class' attributes: attributes contents;
				startElement: 'Methods' attributes: {'count' -> each key methodDictionary size}.
			selectors := WriteStream on: {}.
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
			(flags allMask: LogReferencesMask) ifTrue: [self logReferencesToClass: each].
			self endElement: true.
			totalInstances := totalInstances + count.
			totalMemory := totalMemory + memory.
			totalMethods := totalMethods + each key methodDictionary size.
			totalClassMethods := totalClassMethods + each key class methodDictionary size].
	#{Kernel.EventsCollection} valueOrNil
		ifNotNil: 
			[:ec |
			ec allInstances
				do: [:each | self logComment: each printString , ': ' , each allReferences printString]].
	self
		endElement: true;
		logElement: 'TotalInstances'
			attributes: #()
			value: totalInstances;
		logElement: 'TotalMemory'
			attributes: #()
			value: totalMemory;
		logElement: 'TotalMethods'
			attributes: #()
			value: totalMethods;
		logElement: 'TotalClassMethods'
			attributes: #()
			value: totalClassMethods!

logRemainingPackages
	"Private - Write a list of the remaining packages to the stripping log."

	self startElement: 'RetainedPackages' attributes: #().
	(self systemPackageManager packages collect: [:each | each name]) asSortedArray do: 
			[:each |
			self
				logElement: 'Package'
				attributes: #()
				value: each].
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
			self
				startElement: 'Resource' attributes: #();
				logElement: 'OwningClass'
					attributes: #()
					value: each owningClass fullName;
				logElement: 'Name'
					attributes: #()
					value: each name;
				logElement: 'ByteSize'
					attributes: #()
					value: each resource size;
				endElement: true.
			total := total + each resource size].
	self
		logElement: 'TotalResourcesSize'
			attributes: #()
			value: total;
		endElement: true!

logRemainingSharedVariables
	| sharedVars |
	self startElement: 'RemainingSharedVariables' attributes: #().
	sharedVars := OrderedCollection new.
	Root allBindingsDo: [:each | each isClassBinding not ifTrue: [sharedVars add: each]].
	sharedVars do: 
			[:each |
			self
				logElement: 'VariableBinding'
				attributes: #()
				value: each key].
	self endElement: true!

logRequiredMethodCategories
	"Private - Logs a list of the classes that form the root set for the application."

	self startElement: 'RequiredMethodCategories' attributes: #().
	self requiredMethodCategories asSortedArray do: 
			[:each |
			self
				logElement: 'MethodCategory'
				attributes: #()
				value: each asString].
	self endElement: true!

logSentMessages: aWeakIdentityDictionary
	"Log the messages preserved only because they are assumed to be aspect setters"

	| remainingClasses implemented originallySent allRefs diff sent |
	self startElement: 'SentMessages' attributes: #().
	originallySent := Set new.
	aWeakIdentityDictionary do: [:each | originallySent addAll: each].
	remainingClasses := Smalltalk allClasses reject: [:each | each includesBehavior: BasicImageStripper].
	allRefs := self messagesSentByClasses: remainingClasses.
	self finishedWithAll: #(#messagesSentByClasses:).
	sent := allRefs intersection: originallySent.
	sent asSortedArray do: 
			[:each |
			self
				logElement: 'Selector'
				attributes: #()
				value: each].
	self
		endElement: true;
		startElement: 'UnimplementedMessages' attributes: #().
	implemented := Set new: remainingClasses size * 10.
	self allMethodsInClasses: remainingClasses do: [:each | implemented add: each selector].
	diff := sent difference: implemented.
	diff asSortedArray do: 
			[:each |
			self
				logElement: 'Selector'
				attributes: #()
				value: each].
	self endElement: true.
	deploymentContext aspectSetters isEmpty ifTrue: [^self].
	self startElement: 'PreservedAspectSetters' attributes: #().
	deploymentContext aspectSetters asSortedArray
		do: [:each | (sent identityIncludes: each selector) ifFalse: [self logMethod: each]].
	self endElement: true.
	deploymentContext aspectSetters: nil.
	self finishedWithAll: #(#shouldPreserveMethod:)!

manifestResourceId
	^self runtimeSessionManagerClass asSessionManagerClass isDLL 
		ifTrue: [ISOLATIONAWARE_MANIFEST_RESOURCE_ID]
		ifFalse: [CREATEPROCESS_MANIFEST_RESOURCE_ID]!

messagesSentByClasses: aCollectionOfClasses
	^(super messagesSentByClasses: aCollectionOfClasses)
		addAll: deploymentContext preservedMessages;
		yourself!

nonAspectSetterCategories
	"Answer a collection of the <String> names of categories of methods that are known not to be
	aspect setters even if they appear to be (i.e. they are have 1 argument selectors, the stem
	of which is the selector of a zero-arg method that may be an aspect getter). For example
	Collection implements the 'converting' methods #asSortedCollection: and #asSortedCollection,
	but of course asSortedCollection is a conversion operation, not an aspect"

	^#('not an aspect' 'adding' 'comparing' 'converting' 'copying' 'dependency' 'enumerating' 'evaluating' 'exceptions' 'initializing' 'instance creation' 'operations' 'geometry' 'event handling' 'realizing/unrealizing' 'updating' 'transformations')!

notifyClassesOfCompletedStrip
	"Private - Inform all classes that the imagehas been stripped, by sending them an
	#onPostStripImage message if they implement it directly. This is an opportunity for classes
	to reverse any tentative uninitialization they may have done in a #onPreStripImage method in
	anticipation of being unloaded. Since the classes are still loaded, we give them the
	opportunity to reinitiatlize themselves."

	Class allClassesDo: 
			[:e |
			(e class compiledMethodAt: #onPostStripImage ifAbsent: nil)
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
			(e class compiledMethodAt: #onPreStripImage ifAbsent: nil)
				ifNotNil: 
					[:method |
					e onPreStripImage.
					self deleteMethod: method]].
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
	deploymentContext
		logStrippingError: anError;
		closeLog.
	text := 'The following error occurred while stripping. 
The image MUST exit immediately, but see crash dump (if configured).

'
				, anError description.
	User32
		messageBox: nil
		lpText: text
		lpCaption: SessionManager current applicationName
		uType: ##(MB_OK | MB_ICONERROR | MB_TASKMODAL | MB_SETFOREGROUND).
	SessionManager current
		logError: anError;
		primQuit: -1!

onNotification: aNotification
	self logComment: aNotification description!

openLogFile
	"Private - Open log stream if requested"

	| path |
	path := self writeLogFile
				ifTrue: 
					[File createDirectoryPath: (File splitPathFrom: self logFileName).
					self logFileName].
	deploymentContext openLogFile: path!

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
	"Having removed the packages we don't need, we can now look for messages that must be preserved and hopefully get a smaller set"
	self
		buildPreservedMessages;
		logPreservedMessages.
	"The environment pointers from the variable bindings of pool constants are not needed. We nil them out early while they are easier to reach, but only after determing package pre-requisites."
	self clearSharedPoolConstantsEnvironmentReferences.
	self snapshotRootClasses.
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
	self class class methodDictionary: nil!

prepareCycle2: developmentMethods
	self foldDuplicateConstants.
	self removeDevelopmentObjects: developmentMethods.
	"We can now remove abstract unreachable methods without concern that they may be made reachable by the removal of development methods."
	deploymentContext setRunFlag: RemoveAbstractUnreachable.
	"self emptySystemDictionary"!

prepareCycle3
	self destroyAndRemoveProgress.

	"Some of the libraries may no longer be required."
	self closeExternalLibraries.

	"Necessary to clear these before other class meta-info in order to allow GUID to be stripped."
	self removeClassGuids.
!

prepareCycle4
	(deploymentContext runFlags allMask: AllResourcesStripped)
		ifFalse: [self finishedStrippingResources].
	self shrinkEventsRegister.
	self finishedWithAll: #(#finishedStrippingResources)!

prepareCycle5
	deploymentContext supersentMethods: nil.	"Dispense with detection of unreachable methods of abstract classes, as these should be done now"
	#(#class:overrides: #unreachableMethodsOfNonInstantiablesIn: #removeRedundantMethodsOnceFrom:)
		do: [:each | ##(self) removeSelector: each ifAbsent: nil].
	self shrinkEventsRegister.
	self finishedWithAll: #(#shrinkEventsRegister)!

prepareCycle6: aWeakArrayOfMethods
	"Private - Prepare for the final cycle of removing unsent methods."

	"Class removal will no longer be possible after the next message is sent. This is the point to insert any 
	debug trace to determine why a class remains in the image"

	self removeClassUninstallation: (aWeakArrayOfMethods select: [:each | each ~~ DeadObject.Current]).
	self removeClassMetaInfo.
	self notifyClassesOfCompletedStrip.
	self finishedWithAll: #(#removeRedundantObjects:id:)!

prepareToDeployWith: stubFile to: path
	deploymentContext supersentMethods: self buildSupersentMessageMap.
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

	deploymentContext := DeploymentContext new.
	deploymentContext initialize.
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
		finishedWithAll: #(#appendManifestContent: #behaviorsWithIgnoredAspectSetters #binaryStoreOn: #buildManifest:description:version: #buildMessageMap #buildSupersentMessageMap #classBuildingMethods #classCategoriesToIgnoreAspectSetters #classRemovingMethods #closeAllDevelopmentTools #closeChangeLog #copyAndUpdateStub:to: #defaultStubFilePath #developmentMethodCategoryNames #developmentMethods #executableName #exeFileExtension #findPotentialAspectAccessors: #findPotentialAspectAccessorsIn:excluding: #ignoreViewReferences: #includeManifestResource #isResourceUpdatingRequired #isToGo #isUnattended #keepImageFile #logConfiguration: #logDevelopmentCategories #logFileExtension #logFileName #logReferencesToClasses: #manifestResourceId #nonAspectSetterCategories #notifyClassesOfImminentStrip #openLogFile #prepareToStrip #preserveAspectSetters #preStripCheck #preStripScript #preStripScript: #removeNotRequiredMethods #referencesFromObjectsInClasses: #retainInstVarNames: #rootPackage: #runPreStripScript #snapshotDevelopmentClasses #snapshotType #stripAndSave #stripAndSaveWithProgress #stripDeprecatedMethods #stripShouldNotImplement #stripSubclassResponsibility #stubFile #stubFilePath #updateIconResource: #updateStringTableResource: #updateStubResources: #updateVersionResource: #updateXPManifestResource: #versionResource #versionResource: #viewsToClose #writeLogFile)!

progressDialogClass
	^ImageStripperProgress!

purgeIcons
	"Private - If there are no open windows, then we can safely purge the icon image manager."

	(SessionManager inputState topLevelWindows
		reject: [:each | each isKindOf: ImageStripperProgress]) isEmpty
		ifTrue: [#{Graphics.Icon} ifDefined: [:iconClass | iconClass clear]]!

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
						remove: eachMethod selector ifAbsent: nil;
						yourself.
			messages isEmpty ifFalse: [messageMap at: eachMethod put: messages]].

	"Add all messages that can be triggered by events"
	_EventsRegister
		do: [:each | each do: [:mseq | mseq messages do: [:ms | messageMap at: ms put: {ms selector}]]].

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
			self deleteClass: ClassBuilder.
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
						value: each].
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
										force: true)]].
	self collectGarbage: 3.
	self stripDevelopmentClasses
		ifTrue: 
			[| removed |
			[(removed := self deleteClasses: self developmentClasses sort reason: 'development') > 0]
				whileTrue: 
					[self collectGarbage: 2.
					totalRemoved := totalRemoved + removed]].
	self endElement: totalRemoved > 0.
	self finishedWithAll: #(#stripDevelopmentClasses #stripDevelopmentMethods).
	"developmentClasses inst. var. must be nilled later as still needed for reporting purposes"
	^totalRemoved + 2!

removeMyClass
	"Private - As one of the last steps, remove the receiver's class from the system.
	It will still continue to exist while the instance is alive of course."

	| current superclass |
	current := self class.
	
	[superclass := current superclass.
	
	[self logComment: 'Attempting to remove ' , current fullName.
	self detachClass: current] on: Error
			do: 
				[:e |
				deploymentContext logStrippingError: e.
				e resume: true].
	current name == #BasicImageStripper]
			whileFalse: [current := superclass].
	self detachClass: deploymentContext class.
	self collectGarbage: 2!

removeRedundantMethods
	"Private - Removes redundant methods from the pseudo image.
	Answers the count of methods stripped"

	| sum classes |
	sum := 0.
	classes := Class allClasses.
	(flags allMask: LogLiveClassesMask)
		ifTrue: 
			[self startElement: 'LiveClasses' attributes: #().
			classes sort do: 
					[:each |
					self
						logElement: 'LiveClass'
						attributes: #()
						value: each fullName].
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
	(removed == 0 and: [deploymentContext runFlags allMask: ImageStripper.RemoveAbstractUnreachable])
		ifFalse: [^removed].
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
	^self deleteResources: deadResources reason: 'unreferenced'!

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

	^deploymentContext rootClasses!

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
	
	[| imageData size |
	size := imageFile size.
	imageData := ByteArray new: size.
	imageFile read: imageData count: size.
	OS.Kernel32 updateResourcesOf: exePath
		do: 
			[:hUpdate |
			(OS.Kernel32
				updateResource: hUpdate
				lpType: RT_RCDATA
				lpName: 100
				wLanguage: 0
				lpData: imageData
				cbData: size) ifFalse: [OS.Kernel32 systemError]]]
			ensure: 
				[imageFile close.
				retainImage ifFalse: [File delete: image]].
	unattended
		ifFalse: 
			[User32
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
	^deploymentContext aspectSetters identityIncludes: aCompiledMethod!

shouldRemoveResources
	^(flags allMask: StripResourcesMask)
		and: [(deploymentContext runFlags allMask: AllResourcesStripped) not]!

shrinkSymbolTable
	"Private - Resize symbol table. Must be performed at a very high priority to be
	safe."

	[Symbol resizeTable: 20] forkAt: Processor timingPriority!

snapshotDevelopmentClasses
	"Use a WeakArray to remove dependency on WeakSet"

	deploymentContext snapshotDevelopmentClasses!

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

snapshotRootClasses
	"Private - Build the <IdentitySet> of <Class>es that are considered the roots of the 
	application being deployed."

	| rootClasses |
	rootClasses := Set new.
	rootClasses addAll: self requiredClasses.
	rootClasses addAll: self rootPackage classes.
	deploymentContext rootClasses: rootClasses.
	"We can't discard the methods only used here at this stage, not until the runtime session manager is installed"
	^rootClasses!

snapshotType
	^snapshotType!

stripAndSave
	"Strips the image and saves an executable file according to the configuration held by the 
	receiver."

	self prepareToStrip ifTrue: [self buildApplication]!

stripAndSaveWithProgress
	"Strips the image and saves an executable file according to the configuration held by the receiver
	displaying progress in an ImageStripperProgress dialog."

	self prepareToStrip
		ifTrue: 
			[deploymentContext notifier: self progressDialogClass show.
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

uncheckedDeleteClass: aClass
	aClass fullName = 'UI.ResourceIdentifier'
		ifTrue: 
			[| resourceMessages preserved |
			"If ResourceIdentifier is removed, then there is no point preserving any resource methods as these are unusable."
			preserved := deploymentContext preservedMessages.
			resourceMessages := preserved select: [:each | each beginsWith: 'resource_'].
			self
				logComment: 'Discarding preserved resource messages: ' , resourceMessages asSortedArray printString.
			deploymentContext preservedMessages: (preserved difference: resourceMessages).
			##(self) removeSelector: #uncheckedDeleteClass: ifAbsent: nil].
	^super uncheckedDeleteClass: aClass!

unreachableMethodsOfNonInstantiablesIn: aCollectionOfClasses
	"Private - Any methods of non-instantiable classes overridden in all remaining subclasses are redundant if not supersent.
	Note that we only include instance side methods, as there is a class instance (i.e. the metaclasses are never non-instantiable)."

	| abstractClasses unreachable supersentMethods |
	unreachable := WriteStream on: {}.
	abstractClasses := aCollectionOfClasses select: [:each | each isNonInstantiable].
	supersentMethods := deploymentContext supersentMethods.
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
	file := (strings at: 'InternalName' ifAbsent: '') copyWithout: $..
	file isEmpty ifTrue: [file := File splitStemFrom: self executableName].
	assemblyName nextPutAll: file.
	manifest := self
				buildManifest: assemblyName contents
				description: (strings at: 'FileDescription' ifAbsent: [file , ' Application'])
				version: ver.
	(OS.Kernel32
		updateResource: anExternalHandle
		lpType: RT_MANIFEST
		lpName: self manifestResourceId
		wLanguage: ver languageId
		lpData: manifest
		cbData: manifest size) ifFalse: [OS.Kernel32 systemError]!

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

	^VM registry select: 
			[:each |
			each class isMeta and: [(#('GUID' 'PoolConstantsDictionary') includes: each name asString) not]]!

writeLogFile
	"Answer true if the receiver will write a log file during
	its stripping process"

	^flags allMask: WriteLogMask! !
!ImageStripper categoriesForMethods!
actualRequiredPackages!accessing!private! !
addClassesReferencedByClass:to:!helpers!private! !
addClassesReferencedByMethod:to:!helpers!private! !
addReferencedViews:to:!helpers!private! !
allReferencedClasses!operations!private! !
allResourcesStripped!operations!private! !
appendManifestContent:!helpers!private! !
basicDeleteMethod:!private!removing! !
behaviorsWithIgnoredAspectSetters!configuration!public! !
binaryStoreOn:!binary filing!public! !
buildApplication!must not strip!operations!private! !
buildManifest:description:version:!helpers!private! !
buildMessageMap!helpers!private! !
buildPreservedMessages!helpers!private! !
buildSupersentMessageMap!helpers!private! !
checkedStubFilePath!accessing!private! !
class:overrides:!private!testing! !
classBuildingMethods!accessing!private! !
classCategoriesToIgnoreAspectSetters!configuration!public! !
classesReferencedByMethod:!helpers!private! !
classReferencesToIgnore!configuration!private! !
classRemovingMethods!accessing!private! !
clearChangedProperties!operations!private! !
clearSharedPoolConstantsEnvironmentReferences!operations!private! !
closeAllDevelopmentTools!operations!private! !
closeChangeLog!helpers!private! !
closeExternalLibraries!operations!private! !
compileExternalStructures!accessing!public! !
copyAndUpdateStub:to:!operations!private! !
defaultStubFilePath!constants!private! !
deleteClass:!helpers!private! !
deploymentContext!accessing!private! !
developmentClasses!configuration!public! !
developmentMethods!accessing!public! !
developmentResources!configuration!public! !
disableClassChangeFlagging!operations!private! !
disableDevelopmentSystem!operations!private! !
emptyMethodDictionariesOfStubbornClasses!public!testing! !
executableName!accessing!public! !
executablePath!accessing!public! !
exeFileExtension!constants!public! !
externalStructureClasses!accessing!private! !
finalActions!helpers!private! !
findPotentialAspectAccessors:!helpers!private! !
findPotentialAspectAccessorsIn:excluding:!helpers!private! !
finishedStrippingResources!helpers!private! !
finishedWithAll:!operations!private! !
finishedWithStripping!operations!private! !
foldDuplicateConstants!operations!private! !
getClassInstanceStats!helpers!private! !
ignoreViewReferences!accessing!public! !
includeManifestResource!accessing!public!testing! !
initialTidy!helpers!private! !
installRuntimeSessionManager!operations!private! !
isConsoleApplication!public!testing! !
isResourceUpdatingRequired!private!testing! !
isToGo!accessing!public!testing! !
isUnattended!public!testing! !
keepImageFile!public!testing! !
logComment:!logging!private! !
logConfiguration:!operations!private! !
logDevelopmentCategories!operations!private! !
logFileExtension!constants!public! !
logFileName!accessing!public! !
logImageStats!logging!private! !
logLiveClasses!public!testing! !
logManifest!logging!private! !
logPackagePrerequisites!public!testing! !
logPreservedClasses!operations!private! !
logPreservedMessages!operations!private! !
logReference:!helpers!private! !
logReferencesToClass:!logging!private! !
logReferencesToClasses!public!testing! !
logRemainingClasses!logging!private! !
logRemainingPackages!operations!private! !
logRemainingResources!operations!private! !
logRemainingSharedVariables!operations!private! !
logRequiredMethodCategories!operations!private! !
logSentMessages:!helpers!private! !
manifestResourceId!constants!private! !
messagesSentByClasses:!helpers!private! !
nonAspectSetterCategories!configuration!public! !
notifyClassesOfCompletedStrip!operations!private! !
notifyClassesOfImminentStrip!operations!private! !
notRequiredMethodCategories!configuration!public! !
onError:!event handling!private! !
onNotification:!event handling!private! !
openLogFile!operations!private! !
packagedClasses!accessing!private! !
packageDrivenStage!operations!private! !
prepareCycle1:!operations!private! !
prepareCycle2:!operations!private! !
prepareCycle3!operations!private! !
prepareCycle4!operations!private! !
prepareCycle5!operations!private! !
prepareCycle6:!operations!private! !
prepareToDeployWith:to:!operations!private! !
prepareToStrip!operations!public! !
preserveAspectSetters!accessing!public! !
preStripCheck!operations!private! !
preStripScript!accessing!public! !
preStripTidy!operations!private! !
progressDialogClass!constants!public! !
purgeIcons!helpers!private! !
purgeStubbornClass:!operations!private! !
referencesFromObjectsInClasses:!helpers!private! !
removeClassBuilder:!operations!private! !
removeClassGuids!operations!private! !
removeDevelopmentObjects:!operations!private! !
removeMyClass!operations!private! !
removeRedundantMethods!operations!private! !
removeRedundantMethodsOnceFrom:!operations!private! !
removeRedundantPackages!operations!private! !
removeRedundantResources:!operations!private! !
requiredClasses!configuration!public! !
requiredMethodCategories!configuration!public! !
requiredPackageNames!accessing!public! !
resourcesForClasses:!helpers!private! !
retainInstVarNames!public!testing! !
rootClasses!accessing!private! !
rootPackage!accessing!public! !
runPreStripScript!operations!public! !
runtimeSessionManagerClass!accessing!public! !
saveBlock:!accessing!private! !
saveExecutable:keepImage:!operations!private! !
scanResourcesForViewReferences:!helpers!private! !
shouldPreserveMethod:!private!removing! !
shouldRemoveResources!private!removing! !
shrinkSymbolTable!operations!private! !
snapshotDevelopmentClasses!configuration!private! !
snapshotImage:!operations!private! !
snapshotRootClasses!helpers!private! !
snapshotType!accessing!public! !
stripAndSave!operations!public! !
stripAndSaveWithProgress!operations!public! !
stripClassBuilder!public!testing! !
stripClassGuids!accessing!public! !
stripClassInfo!public!testing! !
stripDeprecatedMethods!public!testing! !
stripDevelopmentClasses!accessing!public!testing! !
stripDevelopmentMethods!accessing!public!testing! !
stripDuplicateBytecodes!public!testing! !
stripDuplicateStrings!public!testing! !
stripRedundantClasses!public!testing! !
stripRedundantMethods!public!testing! !
stripRedundantPackages!public!testing! !
stripRedundantResources!public!testing! !
stripShouldNotImplement!accessing!public!testing! !
stripSubclassResponsibility!public!testing! !
stubFile!public!testing! !
stubFilePath!accessing!public! !
uncheckedDeleteClass:!helpers!private! !
unreachableMethodsOfNonInstantiablesIn:!operations!private! !
updateIconResource:!operations!public! !
updateStringTableResource:!operations!public! !
updateStubResources:!operations!private! !
updateVersionResource:!operations!public! !
updateXPManifestResource:!operations!private! !
verifyRequiredPackages!accessing!private! !
versionResource!accessing!private! !
viewsToClose!helpers!private! !
vmReferencedClasses!constants!public! !
writeLogFile!accessing!public!testing! !
!

!ImageStripper class methodsFor!

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
!ImageStripper class categoriesForMethods!
classBuildingMethodCategoryNames!constants!public! !
classRemovingMethodCategoryNames!constants!public! !
defaultOptions!constants!private! !
developmentMethodCategoryNames!constants!public! !
isSafeToEncryptWithProductProtection!development!public! !
!

