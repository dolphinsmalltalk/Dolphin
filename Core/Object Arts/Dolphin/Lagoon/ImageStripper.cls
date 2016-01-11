"Filed out from Dolphin Smalltalk 7"!

BasicImageStripper subclass: #ImageStripper
	instanceVariableNames: 'rootPackageName executableName runtimeSessionManagerClass flags preStripScript versionResource termWnd stubFilePath logStream elementStack developmentClasses preservedMessages snapshotType rootClasses'
	classVariableNames: 'AllResourcesStripped ClearGuidsMask CompileStructsMask EmptyMethodDictsMask FoldBytecodesMask FoldMethodDictsMask FoldStringsMask IgnoreViewReferencesMask LogPrerequisitesMask LogReferencesMask NoXPManifestMask PreserveAspectsMask RetainInstVarNamesMask RetainSubclassRespMask StripClassBuilderMask StripClassesMask StripClassInfoMask StripDeprecatedMask StripMethodsMask StripPackagesMask StripResourcesMask StripShouldNotImplMask ToGoMask UnattendedMask WriteLogMask'
	poolDictionaries: 'MessageBoxConstants Win32Constants'
	classInstanceVariableNames: ''!
ImageStripper guid: (GUID fromString: '{87B4C667-026E-11D3-9FD7-00A0CC3E4A32}')!
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

	| required found missing reqs pacman |
	required := self requiredPackageNames.
	required add: 'Lagoon Image Stripper'.	"Not a good idea to uninstall this"
	pacman := self systemPackageManager.
	found := required select: [:each | pacman includesPackageNamed: each].
	(missing := required - found) notEmpty 
		ifTrue: 
			["There were some required packages missing from the image"
			| message |
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
	required := found collect: 
					[:each | 
					(pacman packageNamed: each)
						okToSaveOrDeploy;
						yourself].
	reqs := Set new.
	required do: 
			[:each | 
			reqs
				add: each;
				addAll: each allPrerequisites].
	^reqs!

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
	refView := Smalltalk at: #ReferenceView ifAbsent: [].
	stbProxy := Smalltalk at: #STBViewProxy ifAbsent: [].
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

allMethodsInClasses: classes do: operation 
	"Private - Evaluate the <monadicValuable>, operation, for each and every method
	in the <collection> of <Class>es, classes."

	classes do: 
			[:eachClass | 
			eachClass methodDictionary do: [:eachMethod | operation value: eachMethod].
			eachClass class methodDictionary do: [:eachMethod | operation value: eachMethod]]!

allReferencedClasses
	"Private - Answer a <Set> of all the classes in the image which are referenced from the
	image. Note that classes with instances are considered to be referenced too."

	| referencedClasses |
	referencedClasses := IdentitySet new.
	self rootClasses do: [:each | self addClassesReferencedByClass: each to: referencedClasses].
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
	Notification signal: 'All resources stripped'.
	flags := flags maskSet: AllResourcesStripped.
	self finishedStrippingResources.
	self finishedWithAll: #(#logRemainingResources #resourceManager)!

appendManifestContent: manifest 
	self isConsoleApplication 
		ifFalse: 
			["GUI apps need common controls, console apps do not."
			manifest 
				nextPutAll: '<dependency><dependentAssembly><assemblyIdentity type="win32" name="Microsoft.Windows.Common-Controls" version="6.0.0.0" processorArchitecture="X86" publicKeyToken="6595b64144ccf1df" language="*"/></dependentAssembly></dependency>']!

binaryStoreOn: aStream
	"Stores the receiver in a binary form on aStream that can be reconstituted using 
	Object class>>binaryReadFrom:. Clear down some caching instance variables
	first to minimize file size."

	elementStack := logStream := rootClasses := developmentClasses := preservedMessages := nil.
	super binaryStoreOn: aStream.!

buildManifest: assemblyNameString description: assemblyDescriptionString version: aVersionResource 
	"GUI apps need common controls, console apps do not."

	| manifest |
	manifest := String writeStream.
	manifest nextPutAll: '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'.
	manifest 
		nextPutAll: ('%<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">%<assemblyIdentity name="<1s>" version="<3s>" processorArchitecture="X86" type="win32" />%<description><2s>%</description>' 
				expandMacrosWith: assemblyNameString
				with: assemblyDescriptionString
				with: aVersionResource fileVersion).
	self appendManifestContent: manifest.
	manifest nextPutAll: '</assembly>'.
	^manifest contents!

buildMessageMap
	^self referencesFromObjectsInClasses: ((Class allClasses)
				removeAll: ImageStripper withAllSubclasses;
				yourself)!

buildPreservedMessages
	"Private - Build the set of all the message selectors that are to be preserved
	due to membership of one of the requiredMethodCategories."

	| resourceSelectors |
	preservedMessages := IdentitySet new.
	self requiredMethodCategories 
		do: [:each | preservedMessages addAll: (each contents collect: [:method | method selector])].
	"Currently we have to preserve all resources because they are referenced by string name
	(except from ReferenceViews in other resources)"
	resourceSelectors := self resourceManager allResourceIdentifiers asSet 
				collect: [:each | each selector].
	preservedMessages addAll: resourceSelectors!

buildRootClasses
	"Private - Build the <IdentitySet> of <Class>es that are considered the roots of the 
	application being deployed."

	rootClasses := IdentitySet new.
	rootClasses addAll: self requiredClasses.
	rootClasses addAll: self rootPackage classes

	"We can't discard the methods only used here at this stage, not until the runtime session manager is installed"!

canDeploy
	"Answer true if the receiver is currently in a state where it can be deployed."

	^(self executableName ifNil: [false] ifNotNil: [:name | name notEmpty]) 
		and: [self isResourceUpdatingPossible]!

checkedStubFilePath
	"Private - Answer the full path to the stub file. 
	Check that it exists, and if not raise an error."

	| stubFile |
	stubFile := self stubFilePath.
	^(File exists: stubFile) 
		ifTrue: [stubFile]
		ifFalse: [self error: 'Stub file not found: ''' , stubFile , '''']!

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

	^(self notRequiredClasses copy) addAll: developmentClasses; yourself!

clearChangedProperties
	"Private - Remove development change flags."

	Class allSubinstances do: [:b | b isChanged: false].
	PoolConstantsDictionary allSubinstances do: [:p | p isChanged: false].
	self finishedWith: #clearChangedProperties
!

closeAllDevelopmentTools
	"Private - Forcibly close all development tools so that they may be stripped from the image."

	"Ensure any junk or sensitive information in the Transcript is removed."

	Transcript clear.
	#(#SmalltalkToolShell #SmalltalkWorkspaceDocument) do: 
			[:each | 
			Smalltalk at: each
				ifPresent: [:class | class allSubinstances do: [:tool | tool view isTopView ifTrue: [tool view destroy]]]].
	(SessionManager current)
		closeConsole;
		perform: #closeAllHelp.
	(SessionManager inputState)
		pumpMessages;
		processDeferredActions;
		purgeDeadWindows.

	"Update the desktop to redraw under removed windows"
	UserLibrary default updateWindow: UserLibrary default getDesktopWindow.
	self collectGarbage: 3!

closeChangeLog
	"Private - Close the change log so that the activities of the image stripper do not bloat it."

	SourceManager default closeChangesFile!

closeExternalLibraries
	"Private - Close all default sub-instances of <ExternalLibrary>s."

	ExternalLibrary closeAllDefaults.

	self finishedWith: #closeExternalLibraries

!

closeLog
	[elementStack isEmpty] whileFalse: [self endElement].
	logStream close.
	logStream := nil!

compileExternalStructures
	"Answer whether the stripping process will  attempt to compile all
	ExternalStructures so that the template definitions may be removed"

	^flags allMask: CompileStructsMask!

compileExternalStructures: aBoolean
	"Set the compile ExternalStructures option of the stripping process to aBoolean"

	flags := flags mask: CompileStructsMask set: aBoolean!

copyAndUpdateStub: stubFile to: exeFile 
	"Private - Copy over the stub and update it if required. Answer the name of the
	new stub file."

	Notification signal: 'Creating executable stub: ' , exeFile.
	File createDirectoryPath: (File splitPathFrom: exeFile).
	File copy: stubFile to: exeFile.
	File isWriteable: exeFile set: true.
	self isResourceUpdatingRequired 
		ifTrue: 
			[KernelLibrary default updateResourcesOf: exeFile do: [:hUpdate | self updateStubResources: hUpdate]].
	^exeFile!

defaultStubFilePath
	^FileLocator installRelative localFileSpecFor: self stubFile!

deferredSaveExecutable: aString 
	SessionManager inputState queueDeferredAction: [self saveExecutable: aString]!

developmentClasses
	"Answers an <IdentitySet> of all the classes that are in the basic
	development system. These are marked by being in the 'Development'
	category"

	| devClasses |
	devClasses := WeakIdentitySet withAll: (Object classCategoryClass name: 'Development') contents.
	^devClasses
!

developmentMethodCategoryNames
	"Answer a <collection> of the names of <MethodCategory>s containing only development methods
	which must therefore be stripped from the image when it is deployed."

	| names |
	names := Set 
				withAll: #('development' 'categories-accessing' 'categories-adding' 'categories-removing').
	self stripSubclassResponsibility 
		ifTrue: 
			["It should be safe to remove these methods in a properly tested application
			 as they are errors intended for the developer."
			names add: 'subclass responsibility'].
	self stripShouldNotImplement 
		ifTrue: 
			["Ditto"
			names add: 'should not implement'].
	^names!

developmentMethods
	"Answer a <collection> of the loose <CompiledMethod>s which are considered part of the development system, 
	and which must therefore be stripped from the image when it is deployed."

	| catClass devMethods |
	catClass := Object methodCategoryClass.
	devMethods := WeakIdentitySet new: 500.
	self developmentMethodCategoryNames do: [:name | devMethods addAll: (catClass name: name) contents].
	^devMethods!

developmentResources
	"Answer a <collection> of <ResourceIdentifier>s representing any development system resources that
	are not owned directly by development classes."

	| devres |
	devres := OrderedCollection new.
	#(#Dialog #Presenter #AXControlSite #AXValueConvertingControlSite) 
		do: [:s | Smalltalk at: s ifPresent: [:d | devres add: (ResourceIdentifier class: d name: 'Default view')]].
	^devres!

disableClassChangeFlagging
	"Private - Disable class change recording - the properties consume a lot of space."

	Smalltalk removeEventsTriggeredFor: Smalltalk developmentSystem.

	Class basicCompile: 'isChanged: flag ^self error: ''Change flagging disabled'''.

	self finishedWith: #disableClassChangeFlagging!

disableDevelopmentSystem
	"Private - Before removing anything, prevent the package manager from reacting to events, also
	We don't need categories, etc, maintained, so unwire SmalltalkSystem from dev. events"

	self systemPackageManager onPreStripImage.
	Smalltalk removeEventsTriggeredFor: Smalltalk developmentSystem!

displayTerminationMessage
	"Write a message over the desktop to indicate the the strip is not quite complete - use
	low-level windows calls directly to avoid creating a dependency on Canvas, Font, etc."

	termWnd := VMLibrary default 
		displayDesktopMessage: 'Please wait while Dolphin Lagoon terminates'!

emptyMethodDictionariesOfStubbornClasses
	"Answer whether the method dictionaries of classes that refuse to uninstall with their
	owning package should be emptied. Although this is somewhat of a risky option, it does
	help one to track down the root of stripping problems since it helps to remove the knock
	on effects of the original source of the problem."

	^false.!

endElement
	self endElement: true!

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

executableName: aString
	"Set the executable name to which the resultant stripped image will
	be saved"

	executableName := FileLocator imageRelative relativePathTo: aString.
	executableName notEmpty ifTrue: [
		"Default the file extension and save the path relative to the installation directory"
		executableName := File default: executableName extension: self exeFileExtension ].
!

executablePath
	"Answer the full path of the executable to which the resultant stripped image will
	be saved"

	^self executableName notEmpty 
		ifTrue: [FileLocator imageRelative localFileSpecFor: self executableName]
		ifFalse: ['Please choose an executable name']
!

exeFileExtension
	"Answer the extension to use for the executable file"

	^self runtimeSessionManagerClass asSessionManagerClass imageExtension!

finalActions
	"Private - Perform the last few steps before the image is saved."

	
	[self removeMyClass.
	self finishedWithAll: #(#isUnattended #keepImageFile #removeMyClass).
	self collectGarbage: 3.
	self logManifest.
	self closeLog.
	self finishedWithAll: #(#logManifest #collectGarbage: #notify:status: #finalActions)] 
			on: Error
			do: [:ex | self onError: ex].
	self finishedWithAll: #(#onError: #logError: #closeLog #finishedWithAll: #finishedWith:)!

finishedStrippingResources
	self 
		finishedWithAll: #(#resourcesForClasses: #stripRedundantResources:notifying: #addReferencedViews:to: #scanResourcesForViewReferences:)!

finishedWith: selector
	"Private - The receiver has finished with its method identified by the selector argument,
	so it can be stripped. By dynamically reducing its method set as the stripping progresses
	the received contributes to reducing the set of referenced methods and classes.
	Note that the removal of methods is disabled in a development session in order to
	enable debugging."

	SessionManager current isRuntime 
		ifTrue: 
			["Remove the method all the way up the superclass chain, including from ImageStripper, but stopping there"
			| current |
			current := self class.
			[current name == #Model] whileFalse: 
					[current methodDictionary removeKey: selector ifAbsent: [].
					current := current superclass]]
		ifFalse: 
			[Notification signal: 'finishedWith: called before runtime session manager installed: #' , selector]!

finishedWithAll: aCollectionOfSymbols 
	"Private - The receiver has finished with its method identified by the selectors in
	the <collection> argument, so they can be stripped."

	aCollectionOfSymbols do: [:each | self finishedWith: each]!

finishedWithStripping
	"Private - Pair away the stripping methods of the receiver's class that might still exist.
	These will mainly be methods that are used by the stripping algorithm itself, and which
	it cannot therefore remove."

	self finishedWithAll: #(
		#addClassesReferencedByMethod:to:
		#addClassesReferencedByClass:to:
		#allMethodsInClasses:do:
		#allReferencedClasses
		#allResourcesStripped
		#classesReferencedByMethod: 
		#classReferencesToIgnore
		#emptyMethodDictionariesOfStubbornClasses
		#ignoreViewReferences
		#messagesImplementedBy:
		#messagesSentBy:
		#potentialAspectSettersIn:
		#notRequiredClasses
		#preservedMessages
		#preserveAspectSetters
		#purgeStubbornClass:notifying:
		#resourcesForClasses:
		#removeMethod:notifying: #removeMethods:notifying:
		#rootClasses
		#speciallySentMessages
		#stripClassBuilder
		#stripDeprecatedMethods
		#stripDevelopmentClasses
		#stripDevelopmentMethods
		#stripRedundantClasses
		#stripRedundantClassesAndResources:notifying:
		#stripRedundantMethods
		#stripRedundantMethodsNotifying:
		#stripRedundantMethodsOnceFrom:notifying:
		#finishedWithStripping)!

ignoreViewReferences
	"Answer whether view resources should NOT be scanned for references to other
	view resources."

	^flags allMask: IgnoreViewReferencesMask!

ignoreViewReferences: aBoolean
	"Set whether view resources should NOT be scanned for references to other
	view resources."

	flags := flags mask: IgnoreViewReferencesMask set: aBoolean!

includeManifestResource
	"Answer whether the resulting executable will include a Windows XP application manifest
	resource. This resource allows the application to adopt Windows XP look and feel when
	running on Windows XP without shipping a separate manifest file (which remains an
	option, since it will override the resource)."

	^(flags allMask: NoXPManifestMask) not!

includeManifestResource: aBoolean 
	"Set whether the resulting executable will include a Windows XP application manifest
	resource."

	flags := flags mask: NoXPManifestMask set: aBoolean not!

initialize
	"Private - Initialize the receiver"

	self 
		executableName: '';
		runtimeSessionManagerClass: self defaultSessionManagerClass.
	flags := self class defaultOptions.
	
	!

initialTidy
	"Private - Discard methods of the receiver that are no longer required now that early processing is finished
	and the runtime session manager has been installed."

	"We have have done the resource updating."

	versionResource := nil.
	self 
		finishedWithAll: #(#actualRequiredPackages #buildMessageMap #buildPreservedMessages #buildRootClasses #canDeploy #checkedStubFilePath #closeAllDevelopmentTools #closeChangeLog #buildManifest:description:version: #appendManifestContent: #copyAndUpdateStub:to: #defaultStubFilePath #developmentClasses #developmentMethodCategoryNames #developmentMethods #disableDevelopmentSystem #executableName #executableName: #executablePath #exeFileExtension #ignoreViewReferences: #includeManifestResource #initialize #initialTidy #installRuntimeSessionManager #isResourceUpdatingPossible #isResourceUpdatingRequired #isToGo #logConfiguration #logFileExtension #logFileName #logPreservedClasses #logPreservedMessages #logReferencesToClasses: #logRemainingPackages #manifestResourceId #notifyClassesOfImminentStrip: #notifyClassesOfStrip #notRequiredMethodCategories #openLogFile #prepareToStrip #preStripCheck #preStripScript #preStripScript: #referencesFromObjectsInClasses: #requiredClasses #requiredMethodCategories #requiredPackageNames #resizeStubFile: #retainInstVarNames: #rootClasses: #rootPackage #rootPackage: #runPreStripScript #runtimeSessionManagerClass #runtimeSessionManagerClass: #snapshotType: #stripAndSave #stripAndSaveWithProgress #stripNotRequiredMethodsNotifying: #stripRedundantPackages #stripRedundantPackagesNotifying: #stripShouldNotImplement #stubFile #stubFilePath #updateIconResource: #updateStringTableResource: #updateStubResources: #updateVersionResource: #updateXPManifestResource: #vmReferencedClasses #writeLogFile)!

installRuntimeSessionManager
	"Private - Install the application <SessionManager>. For an application deployed with its
	main window open this can often be just <RuntimeSessionManager> itself."

	self runtimeSessionManagerClass installNew!

isConsoleApplication
	^self runtimeSessionManagerClass asSessionManagerClass isConsoleApplication!

isResourceUpdatingPossible
	"Private - Resource updating APIs only available on NT platforms, not Win95/98"

	^OSVERSIONINFO current isNT!

isResourceUpdatingRequired
	"Answer whether this <ImageStripper> would like to update any resources in the executable stub."

	^true!

isToGo
	"Answer whether the resulting executable is to be deployed standalone (that is without
	a separate VM DLL). This is the default."

	^flags allMask: ToGoMask!

isToGo: aBoolean 
	"Set whether the resulting executable is to be deployed standalone (that is without
	a separate VM DLL)."

	"Ensure path nilled if using default"

	self stubFilePath: self stubFilePath.
	flags := flags mask: ToGoMask set: aBoolean!

isUnattended
	^flags allMask: UnattendedMask!

isUnattended: aBoolean 
	"Controls whether or not any prompts for user input will be displayed during the deployment,
	e.g. the final success message box. By default this is disabled (i.e. attended deploiyment)."

	flags := flags mask: UnattendedMask set: aBoolean!

keepImageFile
	"Answer whether the raw image file (which has the same name as the deployed exe/dll but with
	no extension) should be retained. By default it is deleted, but it can be useful for debugging
	purposes, or (if a plug-in image) for use with IMAGE tag."

	^false!

logComment: aString 
	logStream
		crtab: elementStack size;
		nextPutAll: '<!!-- ';
		nextPutAll: aString;
		nextPutAll: ' -->'!

logConfiguration
	| stamp |
	self startElement: 'Configuration'.
	self logElement: 'ImagePath' value: SessionManager current imagePath.
	stamp := TimeStamp current.
	self logElement: 'TimeStamp'
		value: (Locale userDefault 
				printDate: stamp date
				format: 'yyyy-MM-dd'
				flags: 0) , 'T' 
				, (Locale userDefault 
						printTime: stamp time
						format: 'hh:mm:ss'
						flags: 0).
	self logElement: 'Target' value: self executablePath.
	self logImageStats.
	self logDevelopmentCategories.
	false 
		ifTrue: 
			["Can't build this 'til later, as we don't know which of the VM referenced classes will still be around"
			self logPreservedClasses].
	self logPreservedMessages.
	self endElement!

logDevelopmentCategories
	self startElement: 'DevelopmentMethodCategories'.
	self developmentMethodCategoryNames 
		do: [:each | self logElement: 'MethodCategory' value: each].
	self endElement!

logElement: aString attributes: aCollection value: anObject 
	self startTag: aString attributes: aCollection.
	anObject notNil ifTrue: [self logValue: anObject].
	self endTag!

logElement: aString value: anObject 
	self 
		logElement: aString
		attributes: #()
		value: anObject!

logError: anError 
	logStream isNil ifTrue: [^self].
	self 
		logElement: 'Error'
		attributes: (Array with: 'class' -> anError class name)
		value: anError description.
	logStream flush!

logFileExtension
	"Answer the extension to use for the log file"

	^'xml'!

logFileName
	"Answers the file name to use for logging strip info"

	^File change: self executablePath extension: self logFileExtension!

logFold: aString folded: count total: total 
	self startElement: aString.
	self logElement: 'Total' value: total.
	self logElement: 'Folded' value: count.
	self endElement!

logImageStats
	"Private - Dump some stats about the image to the log file to help determine
	the effectiveness of the stripping process."

	self startElement: 'ImageStatistics'.
	self logElement: 'ObjectCount' value: MemoryManager current objectCount.
	self logElement: 'ClassCount' value: Metaclass primAllInstances size.
	self logElement: 'MethodCount' value: CompiledMethod primAllSubinstances size.
	self logElement: 'SymbolCount' value: Symbol primAllInstances size.
	self endElement!

logManifest
	"Private - Logs a list of the remaining classes to the log stream (if any)."

	self startElement: 'Manifest'.
	self logImageStats.
	self logRemainingClasses.
	developmentClasses := nil.
	(flags allMask: AllResourcesStripped) ifFalse: [self logRemainingResources].
	self endElement.
	self 
		finishedWithAll: #(#logReferencesToClasses #logImageStats: #logRemainingResources #logRemainingClasses)!

logPackagePrerequisites
	"Answer whether the stripping log should include a package pre-requisites trace showing
	the package dependencies that exist for the deployed package."

	^flags allMask: LogReferencesMask!

logPreservedClasses
	"Private - Logs a list of the classes that form the root set for the application."

	| classes developmentRoots |
	classes := self rootClasses.
	self startElement: 'RootClasses'.
	developmentRoots := OrderedCollection new.
	classes asSortedCollection do: 
			[:each | 
			| attributes |
			attributes := (developmentClasses includes: each) 
				ifTrue: 
					[developmentRoots add: each.
					Array with: 'development' -> true]
				ifFalse: [#()].
			self 
				logElement: 'RootClass'
				attributes: attributes
				value: each name].
	developmentClasses removeAll: developmentRoots.
	self endElement.
!

logPreservedMessages
	"Private - Logs a list of the classes that form the root set for the application."

	self startElement: 'RequiredMethodCategories'.
	self requiredMethodCategories asSortedCollection 
		do: [:each | self logElement: 'MethodCategory' value: each name].
	self endElement.
	self startElement: 'PreservedMessages'.
	self preservedMessages asSortedCollection do: [:each | self logSelector: each].
	self endElement!

logReferencesToClasses
	"Answer whether the log of classes remaining in the image should include a column to
	show all the references to those classes. This can be useful in determining why a class
	remains in the image after stripping."

	^flags allMask: LogReferencesMask!

logReferencesToClasses: aBoolean
	"Set whether the remaining classes log should include references to those classes for	
	debugging purposes."

	flags := flags mask: LogReferencesMask set: aBoolean
!

logRemainingClasses
	"Private - Logs a list of the remaining classes to the log stream (if any). N.B. This method
	is deliberately constructed not to use any full blocks to simplify debug reference tracing
	to the classes.."

	| classes totalInstances totalMethods totalClassMethods totalMemory stats |
	stats := MemoryManager current primInstanceStats: nil.
	classes := IdentityDictionary new: stats size // 6.
	totalInstances := 0.
	totalMemory := 0.
	1 to: stats size
		by: 3
		do: 
			[:i | 
			| each |
			each := stats at: i.
			each isMeta 
				ifTrue: 
					[| instClass |
					totalInstances := totalInstances + (stats at: i + 1).
					totalMemory := totalMemory + (stats at: i + 2).
					instClass := each instanceClass.
					(classes includesKey: instClass) 
						ifFalse: 
							[classes at: instClass
								put: (Array 
										with: instClass
										with: 0
										with: 0)]]
				ifFalse: 
					[classes at: each
						put: (Array 
								with: each
								with: (stats at: i + 1)
								with: (stats at: i + 2))]].
	classes at: Class
		put: (Array 
				with: Class
				with: totalInstances
				with: totalMemory).
	classes := classes asSortedCollection: [:a :b | a first <= b first].
	totalMethods := totalClassMethods := 0.
	self startElement: 'Classes' attributes: (Array with: 'count' -> classes size).
	classes do: 
			[:triplet | 
			| fugitive insts attributes memory each |
			each := triplet at: 1.
			attributes := OrderedCollection new.
			(fugitive := (Smalltalk includesKey: each name) not) 
				ifTrue: [attributes addLast: 'unbound' -> true].
			(developmentClasses includes: each) ifTrue: [attributes addLast: 'development' -> true].
			self startElement: 'Class' attributes: attributes.
			self logElement: 'Name' value: each name.
			insts := triplet at: 2.
			self logElement: 'InstanceCount' value: insts.
			memory := triplet at: 3.
			self logElement: 'MemoryUsage' value: memory.
			self startElement: 'Methods' attributes: (Array with: 'count' -> each methodDictionary size).
			each methodDictionary keys asSortedCollection 
				do: [:eachMethod | self logElement: 'Method' value: eachMethod].
			self endElement.
			self startElement: 'ClassMethods'
				attributes: (Array with: 'count' -> each class methodDictionary size).
			each class methodDictionary keys asSortedCollection 
				do: [:eachMethod | self logElement: 'Method' value: eachMethod].
			self endElement.
			"			fugitive 
				ifTrue: 
					[logStream 
						print: (each allReferences reject: 
									[:r | 
									r == each class 
										or: [r == classes or: [(r isKindOf: CompiledMethod) and: [r methodClass == each]]]]).
					logStream nextPutAll: '</EM>']
				ifFalse: 
					[self logReferencesToClasses 
						ifTrue: 
							[| refs |
							refs := (Smalltalk associationAt: each name) allReferences 
										reject: [:r | r == Smalltalk or: [r == Processor activeProcess]].
							refs notEmpty ifTrue: [logStream display: refs].
							false
								ifTrue: 
									[each methodDictionary keys asSortedCollection do: 
											[:s | 
											logStream
												nextPutAll: '<BR>';
												print: s]]]].
"
			self endElement.
			totalMemory := totalMemory + memory.
			totalInstances := totalInstances + insts.
			totalMethods := totalMethods + each methodDictionary size.
			totalClassMethods := totalClassMethods + each class methodDictionary size].
	self endElement.
	self logElement: 'TotalInstances' value: totalInstances.
	self logElement: 'TotalMemory' value: totalMemory.
	self logElement: 'TotalMethods' value: totalMethods.
	self logElement: 'TotalClassMethods' value: totalClassMethods.
	self finishedWith: #logReferencesToClasses!

logRemainingPackages
	"Private - Write a list of the remaining packages to the stripping log."

	self startElement: 'RetainedPackages'.
	(self systemPackageManager packages collect: [:each | each name]) asSortedCollection 
		do: [:each | self logElement: 'Package' value: each].
	self endElement!

logRemainingResources
	"Private - Logs a list of the remaining classes to the log stream (if any).
	N.B. This method is deliberately constructed not to use any true blocks
	to simplify debug reference tracing to the classes.."

	| total resman |
	self startElement: 'RemainingResources'.
	total := 0.
	resman := self resourceManager.
	resman allResourceIdentifiers do: 
			[:each | 
			self startElement: 'Resource'.
			self logElement: 'OwningClass' value: each owningClass name.
			self logElement: 'Name' value: each name.
			self logElement: 'ByteSize' value: each resource size.
			self endElement.
			total := total + each resource size].
	self logElement: 'TotalResourcesSize' value: total.
	self endElement!

logRemoveMethod: aCompiledMethod 
	self 
		logElement: 'RemoveMethod'
		attributes: (Array with: 'methodClass' -> aCompiledMethod methodClass name)
		value: aCompiledMethod selector!

logSelector: each 
	^self logElement: 'Selector' value: each!

logSentMessages: aWeakIdentityDictionary 
	| aCollectionOfClasses implemented originallySent allRefs diff sent |
	self startElement: 'SentMessages'.
	originallySent := Set new.
	aWeakIdentityDictionary do: [:each | originallySent addAll: each].
	aCollectionOfClasses := Class allClasses 
				reject: [:each | each includesBehavior: BasicImageStripper].
	allRefs := self messagesSentByClasses: aCollectionOfClasses.
	sent := allRefs intersection: originallySent.
	sent asSortedCollection do: [:each | self logSelector: each].
	self endElement.
	"	self startElement: 'OverheadMessages'.
	diff := allSent difference: originallySent.
	diff asSortedCollection do: [:each | self logSelector: each].
	self endElement.
"
	self startElement: 'UnimplementedMessages'.
	implemented := self messagesImplementedBy: aCollectionOfClasses.
	diff := sent difference: implemented.
	diff asSortedCollection do: [:each | self logSelector: each].
	self endElement!

logValue: anObject 
	| string |
	string := anObject displayString.
	(string includesAnyOf: '<>
	&') 
		ifTrue: 
			[string do: 
					[:each | 
					(##((LookupTable new)
"						at: Character tab put: '&#9';
						at: Character lf put: '&#10';
						at: Character cr put: '&#13';"
						at: $& put: '&amp;';
						at: $< put: '&lt;';
						at: $> put: '&gt;';
						at: $" put: '&quot;';
						shrink) at: each ifAbsent: []) 
						ifNil: [logStream nextPut: each]
						ifNotNil: [:quoted | logStream nextPutAll: quoted]]]
		ifFalse: [logStream nextPutAll: string]!

manifestResourceId
	^self runtimeSessionManagerClass asSessionManagerClass isDLL 
		ifTrue: [ISOLATIONAWARE_MANIFEST_RESOURCE_ID]
		ifFalse: [CREATEPROCESS_MANIFEST_RESOURCE_ID]!

messagesImplementedBy: classes
	"Private - Answer a <Set> of all the messages selectors that have a method implemented
	somewhere in <collection> of <Class>es, classes."

	| answer |
	answer := IdentitySet new: (classes size * 12).
	self allMethodsInClasses: classes do: [:each | answer add: each selector ].
	^answer!

messagesSentByClasses: aCollectionOfClasses 
	| sent |
	sent := (IdentitySet new: aCollectionOfClasses size * 10)
				addAll: self preservedMessages;
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
	Object _eventsRegister 
		do: [:each | each do: [:mseq | mseq messagesDo: [:ms | sent add: ms selector]]].

	"If it is likely that aspects setter selectors (#blah:) are composed programmatically
	we will not have them in our list of sent messages. We should add them here unless
	explicitly told not to."
	self preserveAspectSetters 
		ifTrue: 
			["Assume all one argument keyword messages are potentially setters if a corresponding
			 zero argument 'getter' exists"
			aCollectionOfClasses do: 
					[:each | 
					sent
						addAll: (self potentialAspectSettersIn: each);
						addAll: (self potentialAspectSettersIn: each class)]].
	^sent!

notify: notifier status: aStringMessage 
	notifier first status: aStringMessage!

notifyClassesOfCompletedStrip: notifier 
	"Private - Inform all classes that the imagehas been stripped, by sending them an
	#onPostStripImage message if they implement it directly. This is an opportunity for classes
	to reverse any tentative uninitialization they may have done in a #onPreStripImage method in
	anticipation of being unloaded. Since the classes are still loaded, we give them the
	opportunity to reinitiatlize themselves."

	Class allClassesDo: 
			[:e | 
			(e class compiledMethodAt: #onPostStripImage ifAbsent: []) 
				ifNotNil: 
					[:method | 
					e onPostStripImage.
					self removeMethod: method notifying: notifier]]!

notifyClassesOfImminentStrip: notifier 
	"Private - Inform all classes that the image is about to be stripped, by sending them an
	#onPreStripImage message if they implement it directly. This is an opportunity for the
	classes to contribute to the stripping process, for example by minimizing lazily initialized
	state. The fewer classes there are with instances in the image, the smaller the set of roots
	from which the retained functionality need be calculated."

	self startElement: 'PreStrip'.
	Class allClassesDo: 
			[:e | 
			(e class compiledMethodAt: #onPreStripImage ifAbsent: []) 
				ifNotNil: 
					[:method | 
					e onPreStripImage.
					self removeMethod: method notifying: notifier]].
	self endElement!

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
	
	| catClass cats |
	catClass := Object methodCategoryClass.
	cats := IdentitySet
			with: (catClass name: 'must strip')
			with: (catClass name: 'examples').

	self stripDeprecatedMethods ifTrue: [
		cats add: (catClass name: 'deprecated')].

	^cats!

onError: anError 
	"Private - An error occur while stripping. Heaven knows what state the image may be in
	now so just report the error and forcibly exit"

	| text |
	self logError: anError.
	self closeLog.
	text := 'The following error occurred while stripping. 
The image MUST exit immediately, but see crash dump (if configured).

' 
				, anError description.
	UserLibrary default 
		messageBox: nil
		lpText: text
		lpCaption: SessionManager current applicationName
		uType: ##(MB_OK | MB_ICONERROR | MB_TASKMODAL | MB_SETFOREGROUND).
	VMLibrary default crashDump: anError description.
	SessionManager current primQuit: -1!

onNotification: aNotification notifier: notifier 
	| description |
	description := aNotification description.
	self notify: notifier status: description.
	self logComment: aNotification class name , ': ' , description!

openLogFile
	"Private - Open log stream if requested"

	elementStack := OrderedCollection new.
	logStream := self writeLogFile 
				ifTrue: 
					[File createDirectoryPath: (File splitPathFrom: self logFileName).
					FileStream write: self logFileName text: true]
				ifFalse: [String writeStream].
	logStream nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>'; cr.
	self startElement: 'Lagoon'
		attributes: (Array with: 'xmlns:xsi' -> 'http://www.w3.org/2001/XMLSchema-instance'
				with: 'xsi:noNamespaceSchemaLocation' -> 'Lagoon.xsd')!

potentialAspectSettersIn: aClass 
	"Private - Answer a collection of the methods in the specified class that _might_ be aspect
	setters. These are judged as those with one-argument keyword selectors for which there is a
	corresponding unary selector implemented in the class or its superclasses. This is, of
	course, a conservative judgement and will tend to result in more methods being preserved
	than are strictly required."

	^(aClass methodDictionary select: 
			[:each | 
			each selector last = $: and: 
					[each argumentCount == 1 and: 
							[| getter |
							getter := (each selector copyFrom: 1 to: each selector size - 1) asSymbol.
							aClass canUnderstand: getter]]]) 
		keys!

prepareToStrip
	"Perform pre-image stripping actions, such as opening the log file.
	This is invoked before even the development tools have been closed.
	Answer whether to proceed with the application deployment."

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

preserveAspectSetters: aBoolean
	"Sets the preserve aspect setters option of the receiver to aBoolean.
	See comment in #preserveAspectSetters"

	flags := flags mask: PreserveAspectsMask set: aBoolean!

preservedMessages
	"Private - Answers a Set of all the message selectors that are to be preserved
	due to membership of one of the requiredMethodCategories.
	Implementation Note: The set is recorded so that the category system can
	be removed as soon as possible."

	preservedMessages isNil ifTrue: [self buildPreservedMessages].
	^preservedMessages!

preStripCheck
	"Private - Perform pre-image stripping checks, such as whether any packages have cyclic
	pre-requisites.
	Answer whether the checks passed and it is OK to continue with the deployment."

	^true!

preStripScript
	"Answer the pre-image stripping script which allows for custom image stripping actions
	such as removing classes from the development category if one wishes to preserve them
	or perhaps forcibly removing stubborn methods."

	^preStripScript ifNil: ['']!

preStripScript: aString 
	"Set the pre-image stripping script which allows for custom image stripping actions."

	preStripScript := aString notEmpty ifTrue: [aString]!

progressDialogClass
	^Smalltalk at: #ImageStripperProgress!

purgeIcons: anObject 
	"Private - If there are no open windows, then we can safely purge the icon image manager."

	(SessionManager inputState topLevelWindows reject: [:each | each isKindOf: ImageStripperProgress]) 
		isEmpty ifTrue: [Smalltalk at: #Icon ifPresent: [:iconClass | iconClass clear]]!

queryCommand: query 
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery>, query."

	(query canPerformAgainst: self) ifTrue: [query isEnabled: true].
	^false	"There was no specific enablement of the command at this level"!

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
			messages := (eachMethod messages)
						remove: eachMethod selector ifAbsent: [];
						yourself.
			messages isEmpty ifFalse: [messageMap at: eachMethod put: messages]].

	"Add all messages that can be triggered by events"
	Object _eventsRegister 
		do: [:each | each do: [:mseq | mseq messagesDo: [:ms | messageMap at: ms put: (Array with: ms selector)]]].
	self preserveAspectSetters ifTrue: [#todo	"How are we going to handle aspect setters?"].


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

removeMyClass
	"Private - As one of the last steps, remove the receiver's class from the system.
	It will still continue to exist while the instance is alive of course."

	preservedMessages := nil.
	
	[ImageStripper allSubclasses 
		reverseDo: [:each | each environment removeClass: each].
	ImageStripper environment removeClass: ImageStripper] 
			on: Error
			do: [:e | e resume: true].
	self collectGarbage: 2!

requiredClasses
	"Answer an IdentitySet of Classes that are known to be required and that
	should be preserved during an image strip. Can be overridden by subclasses to alter the stripping
	strategy"

	^(IdentitySet new: 32)
		add: Process;
		add: ProcessorScheduler;
		add: self runtimeSessionManagerClass asSessionManagerClass;
		addAll: self vmReferencedClasses;
		yourself!

requiredMethodCategories
	"Answer an IdentitySet of MethodCategorys whose methods are known to be required
	and should be preserved during an image strip. Can be overridden by subclasses to 
	alter the stripping strategy"

	"By default we preserve only the 'must not strip' and the view resource categories"

	| cat |
	cat := Object methodCategoryClass.
	^IdentitySet new
		add: (cat name: 'must not strip');
		yourself

	!

requiredPackageNames
	"Answers a <Set> of the names of the packages required by application. These should already 
	have been loaded into the image."

	^Set new
		add: rootPackageName;
		yourself.!

resizeStubFile: exeFilePath 
	"Private - Update the stub file size in the specified Dolphin executable stub file."

	| stream pos exeSize |
	stream := FileStream 
				write: exeFilePath
				mode: #open
				check: true
				type: #binary.
	exeSize := stream size.
	(stream skipToAll: '.DLPHSGT' asByteArray) 
		ifFalse: [self error: 'Invalid exe stub: ' , exeFilePath].
	pos := stream
				skip: 12;
				nextSDWORD.
	stream
		position: pos;
		nextSDWORDPut: exeSize.
	stream close!

resourceManager
	^ResourceIdentifier!

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
		do: [:m | m literalsDo: [:l | l class == String ifTrue: [literalStrings add: l]]].
	resourceIds := Set new.
	classes do: 
			[:class | 
			| resources |
			resources := class resourceIdentifiers .
			resources do: 
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

retainInstVarNames: aBoolean
	"Set the retain Retain Instance Variable Names option of the stripping process to aBoolean"

	flags := flags mask: RetainInstVarNamesMask set: aBoolean!

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

rootPackage: aPackageOrNil 
	"Sets the root package associated with the receiver."

	| sessionManager |
	rootPackageName := aPackageOrNil notNil ifTrue: [aPackageOrNil name].
	aPackageOrNil notNil ifFalse: [^self].
	sessionManager := aPackageOrNil classes 
				detect: [:each | each includesBehavior: SessionManager]
				ifNone: [].
	sessionManager notNil ifTrue: [self runtimeSessionManagerClass: sessionManager]!

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
			Notification signal: ('Error in pre-strip script at line <1d>: <2d>' expandMacrosWith: x line
						with: (x _descriptionArguments at: 5)).
			x resume]!

runtimeSessionManagerClass
	"Answer the class of runtime session manager to install into
	a stripped image"

	^runtimeSessionManagerClass!

runtimeSessionManagerClass: aSessionManagerClass 
	"Set the class of runtime session manager that the receiver will install into a stripped image"

	aSessionManagerClass asSessionManagerClass isRuntime 
		ifFalse: [^self error: aSessionManagerClass name , ' is not a runtime session manager'].
	runtimeSessionManagerClass := aSessionManagerClass!

saveExecutable: exePath 
	"Private - Save a snapshot of the current image to an executable. This is appended to the
	executable stub at the <readableString> path, exePath.
	Following the completion of this process the development system MUST exit"

	| image retainImage imageFile unattended |
	unattended := self isUnattended.
	retainImage := self keepImageFile.
	self finalActions.
	image := File change: exePath extension: 'tmp'.
	self snapshot: image.

	"We can't send any more messages to the receiver after this point as its method dictionary
	 has been removed."
	imageFile := File open: image mode: #read.
	
	[| imageData |
	imageData := ByteArray new: imageFile size.
	imageFile read: imageData.
	KernelLibrary default updateResourcesOf: exePath
		do: 
			[:hUpdate | 
			(KernelLibrary default 
				updateResource: hUpdate
				lpType: RT_RCDATA
				lpName: 100
				wLanguage: 0
				lpData: imageData
				cbData: imageData size) ifFalse: [KernelLibrary default systemError]]] 
			ensure: 
				[imageFile close.
				retainImage ifFalse: [File delete: image]].
	unattended 
		ifFalse: 
			[UserLibrary default 
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

shrinkHashedCollections
	"Minimize set of hashed collections."

	Set primAllSubinstances do: [:each | each shrink].

	self finishedWith: #shrinkHashedCollections

!

shrinkSymbolTable
	"Private - Resize symbol table. Must be performed at a very high priority to be
	safe."

	[Symbol resizeTable: 20] forkAt: Processor timingPriority.

	self finishedWith: #shrinkSymbolTable

!

snapshot: anImageFilename
	"Private - Save the current stripped image out to anImageFilename"

	"We can now empty the method dictionary as every method still required
	 is on the stack."

	| sesh type  |
	type := self snapshotType.
	self class methodDictionary: MethodDictionary new.
	Smalltalk clearCachedClasses.

	"Flush out the garbage again"
	2 timesRepeat: 
			[(MemoryManager current)
				collectGarbage;
				administerLastRites;
				compact].
	sesh := SessionManager current.
	sesh onPreSaveImage.
	sesh 
		primSnapshot: anImageFilename
		backup: false
		type: type.
	sesh onPostSaveImage!

snapshotType
	snapshotType isNil ifTrue: [snapshotType := 6].
	^snapshotType!

snapshotType: anInteger
	(anInteger between: -1 and: 9) 
		ifFalse: [self error: 'snapshotType out of range (-1..9)'].
	snapshotType := anInteger!

speciallySentMessages
	"Private - A number of messages can be sent without  appearing in the literal
	frame of any method. Answer a Set of these selectors here."

	^WeakSet withAll: (VMLibrary default registry select: [:each | each class == Symbol])!

startElement: aString 
	self startElement: aString attributes: #()!

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

	self prepareToStrip ifTrue: [
		self stripAndSaveNotifying: (Array with: DeafObject current)]!

stripAndSaveNotifying: notifier 
	"Strips the image and saves an executable file according to the configuration held by the
	receiver. Notification messages are sent to notifier in the form of #status: messages. N.B.
	This method is in the 'must not strip' category to prevent the receiver pulling the rug out
	from under its own feet!!"

	| path |
	
	["Check stub file exists before we get too far"
	| stubFile developmentMethods messageMap |
	stubFile := self checkedStubFilePath.
	path := self executablePath.
	developmentClasses := self developmentClasses.
	developmentMethods := self developmentMethods.
	"Save down a collection of all sent messages for use later in determining unimplemented
	messages which are still sent - these can arise, for example, where the package stripping
	process removes loose methods."
	messageMap := self buildMessageMap.
	self logConfiguration.
	stubFile := self copyAndUpdateStub: stubFile to: path.
	self
		closeAllDevelopmentTools;
		runPreStripScript.
	self notifyClassesOfImminentStrip: notifier.
	self collectGarbage: 3.
	self defineExternalStructuresNotifying: notifier.
	self closeChangeLog.

	"These methods must be stripped BEFORE redundant packages, as they may cause pre-requisites
	we don't want in the deployed application"
	self stripNotRequiredMethodsNotifying: notifier.
	self stripRedundantPackagesNotifying: notifier.
	self logRemainingPackages.
	self logPreservedClasses.
	"... and make sure we've garnered all the info we require from development structures to
	allow these to be removed immediately. This must be done before we disable the package
	manager."
	self disableDevelopmentSystem.
	self installRuntimeSessionManager.
	self assert: [SessionManager current isRuntime].

	"#finishedWith: doesn't remove methods unless a run-time session manager is installed so we
	can only start throwing stuff away now"
	self initialTidy.

	"Before we can remove any classes, we must ensure isChanged properties are removed"
	self clearChangedProperties.
	self disableClassChangeFlagging.
	self prepareExternalStructuresNotifying: notifier.
	self stripDevelopmentSystemNotifying: notifier.
	self purgeIcons: notifier.
	self finishedWithAll: #(#disableClassChangeFlagging #stripDevelopmentSystemNotifying: #purgeIcons:).

	"Empty the receiver's class' method dictionary"
	self class class methodDictionary: MethodDictionary new.
	self stripRedundantObjects: false notifying: notifier.
	self stripDuplicatesNotifying: notifier.
	self finishedWith: #stripDuplicatesNotifying:.
	self stripDevelopmentObjects: developmentMethods notifying: notifier.
	self finishedWith: #stripDevelopmentObjects:notifying:.
	developmentMethods := nil.
	self stripSystemDictionaryNotifying: notifier.

	"Have another go at finding redundant stuff now dev. classes out of the picture, but
	 this time strip resources too"
	self stripRedundantObjects: true notifying: notifier.
	self destroyAndRemoveProgressNotifying: notifier.


	"Some of the libraries may no longer be required."
	self closeExternalLibraries.

	"Necessary to clear these before other class meta-info in order to allow GUID to be stripped by
	before the ClassBuilder is removed."
	self stripClassGuidsNotifying: notifier.

	"One last go with the progress dialog removed"
	self stripRedundantObjects: true notifying: notifier.
	self finishedStrippingResources.
	self stripRedundantObjects: false notifying: notifier.

	"Class removal will no longer be possible after the next message is sent. This is the point to insert any 
	debug trace to determine why a class remains in the image"
	self stripClassRemovalNotifying: notifier.
	self stripClassInfoNotifying: notifier.
	self notifyClassesOfCompletedStrip: notifier.

	"And one final go at the methods that might be hanging around because of class stripping code"
	self 
		finishedWithAll: #(#stripClassRemovalNotifying: #stripRedundantResources #stripRedundantObjects:notifying: #addClassesReferencedByClass:andResources:to: #stripClassInfoNotifying: #notifyClassesOfCompletedStrip: #finishedStrippingResources).
	self stripRedundantMethodsNotifying: notifier.
	self finishedWithAll: #(#stripRedundantMethodsNotifying: #stripRedundantMethodsOnceFrom:notifying:).
	self logSentMessages: messageMap.
	messageMap := nil.
	self foldEmptyMethodDictionariesNotifying: notifier.
	self 
		finishedWithAll: #(#stripEmptyMethodDictionaries #foldEmptyMethodDictionariesNotifying: #logFold:folded:total:).


	"Remove as much as we can of the remainder of ImageStripper in case it hangs around"
	self finishedWithStripping.
	self shrinkHashedCollections.
	self shrinkSymbolTable] 
			on: Error
			do: [:ex | self onError: ex]
			on: Notification
			do: 
				[:ex | 
				self onNotification: ex notifier: notifier.
				ex resume].
	self deferredSaveExecutable: path.
	self finishedWithAll: #(#stripAndSaveNotifying:)!

stripAndSaveWithProgress
	"Strips the image and saves an executable file according to the configuration held by the receiver
	displaying progress in an ImageStripperProgress dialog."

	self prepareToStrip ifTrue: [
		self stripAndSaveNotifying: (Array with: self progressDialogClass show)]!

stripClassBuilder
	"Answer true if the stripping process will remove the class builder.
	This is normally safe, unless run-time construction of classes, etc, is
	anticipated. The class builder has to be removed separately because
	it is intimately involved in the stripping of other classes."

	^flags allMask: StripClassBuilderMask!

stripClassBuilder: aBoolean
	"Set the strip class builder option of the stripping process to aBoolean."

	flags := flags mask: StripClassBuilderMask set: aBoolean!

stripClassGuids
	"Answer whether the class GUIDs should be nulled at the end of the stripping process.
	This is appropriate unless the application makes use of these to uniquely identify classes.
	Note that guids of COMInterface's subclasses will not be nulled, as these are in fact the
	IIDs of the corresponding interfaces."

	^flags allMask: ClearGuidsMask!

stripClassGuids: aBoolean
	"Set whether the class GUIDs should be nulled at the end of the stripping process.
	This is appropriate unless the application makes use of these to uniquely identify classes.
	Note that guids of COMInterface's subclasses will not be nulled, as these are in fact the
	IIDs of the corresponding interfaces."

	flags := flags mask: ClearGuidsMask set: aBoolean!

stripClassGuidsNotifying: notifier 
	"Private - Remove all (presumably) redundant class info"

	(self stripClassInfo and: [self stripClassGuids]) 
		ifTrue: 
			[| guids |
			self notify: notifier status: 'Removing class GUIDs'.
			Class allClassesDo: [:each | each clearGuid].
			guids := GUID allSubinstances.
			self startElement: 'RemainingGUIDs' attributes: (Array with: 'count' -> guids size).
			guids do: [:each | self logElement: 'GUID' value: each].
			self endElement].
	self finishedWithAll: #(#stripClassGuids #stripClassGuidsNotifying:)!

stripClassInfo
	"Answer true if the stripping process will remove class information such as
	instance variable names, pools names and comments"

	^flags allMask: StripClassInfoMask!

stripClassInfo: aBoolean
	"Set the strip class info option of the stripping process to aBoolean"

	flags := flags mask: StripClassInfoMask set: aBoolean!

stripDeprecatedMethods
	"Answer true if the stripping process will remove those methods which
	have been deprecated. This option may need to be turned off for an
	older application."

	^flags allMask: StripDeprecatedMask!

stripDeprecatedMethods: aBoolean
	"Sets the option to remove deprecated methods during the 
	receiver's stripping process."

	flags := flags mask: StripDeprecatedMask set: aBoolean
!

stripDevelopmentClasses
	"Answer true if the stripping process will forcibly remove those classes in
	the 'Development' category. This option must always be enabled for applications
	that are to be distributed. To retain individual development classes use the stripper 
	script to remove the class from the category before stripping starts, but be aware
	that this may be an infringement of the license (please check with OA)."

	^true!

stripDevelopmentMethods
	"Answer true if the stripping process will forcibly remove those methods in
	the 'development' category. This option must always be true in order to comply
	with the Dolphin license, which does not permit parts of the development system
	to be shipped in a deployed application without express permission. To retain
	individual development methods use the stripper script to remove the method
	from the category before stripping starts, but written permission must first
	be sought from Object Arts."

	^true!

stripDevelopmentObjects: devMethods notifying: notifier 
	"Private - Remove any remaining vestiges of the development system.
	Answer the number of development classes removed."

	| totalRemoved |
	self startElement: 'StripDevelopmentObjects'.
	self notify: notifier status: 'Removing remaining development classes and methods'.
	"Remove the methods first in case they reference the development classes"
	totalRemoved := self stripDevelopmentMethods 
				ifTrue: [self removeMethods: devMethods notifying: notifier]
				ifFalse: [0].
	self collectGarbage: 3.
	self stripDevelopmentClasses 
		ifTrue: 
			[| removed |
			[(removed := self removeClasses: developmentClasses asSortedCollection notifying: notifier) > 0] 
				whileTrue: 
					[self collectGarbage: 2.
					totalRemoved := totalRemoved + removed]].
	self endElement: totalRemoved > 0.
	"developmentClasses inst. var. must be nilled later as still needed for reporting purposes"
	^totalRemoved!

stripDuplicateBytecodes
	"Answer true if the stripping process will fold instances of duplicate byte code arrays 
	into one common instance"

	^flags allMask: FoldBytecodesMask!

stripDuplicateBytecodes: aBoolean
	"Set the bytecode folding option of the stripping process to aBoolean."

	flags := flags mask: FoldBytecodesMask set: aBoolean!

stripDuplicatesNotifying: notifier 
	"Private - Fold any duplicate objects that we can such as literals and strings."

	self foldDuplicateStringsNotifying: notifier.
	self foldDuplicateBytecodesNotifying: notifier.
	self 
		finishedWithAll: #(#stripDuplicateBytecodes #stripDuplicateStrings #foldDuplicateStringsNotifying: #foldDuplicateBytecodesNotifying:)!

stripDuplicateStrings
	"Answer true if the stripping process will fold instances of duplicate strings
	into one common instance"

	^flags allMask: FoldStringsMask!

stripDuplicateStrings: aBoolean
	"Set the fold duplicate strings option of the stripping process to aBoolean"

	flags := flags mask: FoldStringsMask set: aBoolean!

stripEmptyMethodDictionaries
	"Answer whether the stripping process will replace empty method dictionaries with a 
	shared empty dictionary.	This is safe unless the application adds new methods 
	at run time (most don't)."

	^flags allMask: FoldMethodDictsMask!

stripEmptyMethodDictionaries: aBoolean
	"Set whether the stripping process will replace empty method dictionaries with a 
	shared empty dictionary.	This is safe unless the application adds new methods 
	at run time (most don't)."

	flags := flags mask: FoldMethodDictsMask set: aBoolean!

stripRedundantClasses
	"Answer true if the receiver will attempt to remove redundant classes not
	referenced from a root package during its stripping process"

	^flags allMask: StripClassesMask!

stripRedundantClasses: aBoolean
	"Sets the option to remove redundant classes during the receiver's stripping process
	to aBoolean. Note that setting this to true will significantly increase the time take to 
	strip an image"

	flags := flags mask: StripClassesMask set: aBoolean!

stripRedundantMethods
	"Answer true if the receiver will attempt to remove redundant methods during
	its stripping process"

	^flags allMask: StripMethodsMask!

stripRedundantMethods: aBoolean
	"Sets the option to remove redundant methods during the receiver's stripping process
	to aBoolean. Note that setting this to true significantly increases the time take to 
	strip an image"

	flags := flags mask: StripMethodsMask set: aBoolean!

stripRedundantPackages
	"Answer true if the receiver will attempt to remove redundant packages not
	referenced from a root package during its stripping process."

	^flags allMask: StripPackagesMask!

stripRedundantPackages: aBoolean
	"Sets the option to remove redundant packages during the receiver's stripping process
	to aBoolean."

	flags := flags mask: StripPackagesMask set: aBoolean
!

stripRedundantResources
	"Answer true if the receiver will attempt to remove redundant resources not referenced from
	a root package during its stripping process. Note that class stripping must be enabled too."

	^(flags bitAnd: StripResourcesMask | AllResourcesStripped) = StripResourcesMask!

stripRedundantResources: aBoolean
	"Sets the option to remove redundant resources during the receiver's stripping process
	to aBoolean."

	flags := flags mask: StripResourcesMask set: aBoolean
!

stripRedundantResources: referencedClasses notifying: anObject 
	| liveResources resCount resman |
	resCount := 0.
	liveResources := self resourcesForClasses: referencedClasses.
	liveResources isEmpty 
		ifTrue: 
			[self allResourcesStripped.
			^0].

	"Remove all but the live resources"
	resman := self resourceManager.
	self startElement: 'StripResources'.
	(resman allResourceIdentifiers difference: liveResources) do: 
			[:each | 
			self 
				logElement: 'RemoveResource'
				attributes: (Array with: 'owningClass' -> each owningClass name)
				value: each name.
			resman removeResource: each.
			resCount := resCount + 1].
	self endElement: resCount > 0.
	^resCount!

stripShouldNotImplement
	"Answer true if the stripping process will remove those methods which
	consist of a 'self shouldNotImplement' error report. It should be safe to
	remove such methods in a properly tested application, since they are
	intended as an indication of a logic error for the developer."

	^flags allMask: StripShouldNotImplMask!

stripShouldNotImplement: aBoolean
	"Sets the option to remove 'self shouldNotImplement' methods during the 
	receiver's stripping process."

	flags := flags mask: StripShouldNotImplMask set: aBoolean
!

stripSubclassResponsibility
	"Answer true if the stripping process will remove those methods which consist of a 'self
	subclassResponsibility' error report. It should be safe to remove such methods in a properly
	tested application, since they are intended as an indication of a logic error for the
	developer."

	^flags noMask: RetainSubclassRespMask!

stripSubclassResponsibility: aBoolean 
	"Set/reset the option to remove those methods which consist of a 'self
	subclassResponsibility' error report, depending on the <Boolean> argument. It should be safe
	to remove such methods in a properly tested application, since they are intended as an
	indication of a logic error for the developer."

	flags := flags mask: RetainSubclassRespMask set: aBoolean not!

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

stubFilePath: aString
	"Set the path of a custom stub file."

	stubFilePath := (aString isNil or: [aString sameAs: self defaultStubFilePath]) 
				ifFalse: [FileLocator imageRelative relativePathTo: aString]!

systemPackageManager
	"Private - Answer the package manager to be used by the receiver.
	N.B. All references to PackageManager must be through this accessor
	to prevent the PackageManager and Package classes remaining in the
	deployed image."

	^(Smalltalk at: #Package ifAbsent: [DeafObject current]) manager!

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
	VersionLibrary closeDefault!

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
	strings := ver stringTables at: '040904e4' ifAbsent: [ver stringTables values at: 1 ifAbsent: []].
	strings isNil ifTrue: [^nil].
	assemblyName := String writeStream.
	#('CompanyName' 'ProductName') do: 
			[:each | 
			(strings at: each ifAbsent: []) 
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
	(KernelLibrary default 
		updateResource: anExternalHandle
		lpType: RT_MANIFEST
		lpName: self manifestResourceId
		wLanguage: ver languageId
		lpData: manifest
		cbData: manifest size) ifFalse: [KernelLibrary default systemError]!

versionResource
	"Answer the <VersionResource> describing the version resource to be built into	
	the deployed application/dll."

	| originalFilename |
	versionResource isNil 
		ifTrue: 
			[versionResource := VersionResource forPath: self checkedStubFilePath.
			"Stub might not contain a version resource"
			versionResource isNil ifTrue: [^nil]].
	originalFilename := File splitFilenameFrom: self executableName.
	versionResource stringTables do: 
			[:each | 
			(each includesKey: 'OriginalFilename') ifTrue: [each at: 'OriginalFilename' put: originalFilename]].
	^versionResource!

versionResource: aVersionResource
	"Set the <VersionResource> describing the version resource to be built into	
	the deployed application/dll."

	versionResource := aVersionResource!

vmReferencedClasses
	"Answer a <collection> of all the classes referenced directly by the VM.
	These must not be stripped!!"

	^VMLibrary default registry 
		select: [:each | each class isMeta and: [(#('GUID' 'PoolConstantsDictionary') includes: each name asString) not]]!

writeLogFile
	"Answer true if the receiver will write a log file during
	its stripping process"

	^flags allMask: WriteLogMask!

writeLogFile: aBoolean
	"Sets the option to write a log file during the receiver's stripping process
	to aBoolean."

	flags := flags mask: WriteLogMask set: aBoolean! !
!ImageStripper categoriesFor: #actualRequiredPackages!accessing!private! !
!ImageStripper categoriesFor: #addClassesReferencedByClass:to:!helpers!private! !
!ImageStripper categoriesFor: #addClassesReferencedByMethod:to:!helpers!private! !
!ImageStripper categoriesFor: #addReferencedViews:to:!helpers!private! !
!ImageStripper categoriesFor: #allMethodsInClasses:do:!helpers!private! !
!ImageStripper categoriesFor: #allReferencedClasses!operations!private! !
!ImageStripper categoriesFor: #allResourcesStripped!operations!private! !
!ImageStripper categoriesFor: #appendManifestContent:!helpers!private! !
!ImageStripper categoriesFor: #binaryStoreOn:!binary filing!development!public! !
!ImageStripper categoriesFor: #buildManifest:description:version:!helpers!private! !
!ImageStripper categoriesFor: #buildMessageMap!must not strip!private! !
!ImageStripper categoriesFor: #buildPreservedMessages!helpers!private! !
!ImageStripper categoriesFor: #buildRootClasses!helpers!private! !
!ImageStripper categoriesFor: #canDeploy!public!testing! !
!ImageStripper categoriesFor: #checkedStubFilePath!accessing!private! !
!ImageStripper categoriesFor: #classesReferencedByMethod:!helpers!private! !
!ImageStripper categoriesFor: #classReferencesToIgnore!configuration!private! !
!ImageStripper categoriesFor: #clearChangedProperties!operations!private! !
!ImageStripper categoriesFor: #closeAllDevelopmentTools!operations!private! !
!ImageStripper categoriesFor: #closeChangeLog!helpers!private! !
!ImageStripper categoriesFor: #closeExternalLibraries!operations!private! !
!ImageStripper categoriesFor: #closeLog!operations!private! !
!ImageStripper categoriesFor: #compileExternalStructures!accessing!public! !
!ImageStripper categoriesFor: #compileExternalStructures:!accessing!public! !
!ImageStripper categoriesFor: #copyAndUpdateStub:to:!operations!private! !
!ImageStripper categoriesFor: #defaultStubFilePath!constants!private! !
!ImageStripper categoriesFor: #deferredSaveExecutable:!must not strip!private! !
!ImageStripper categoriesFor: #developmentClasses!configuration!public! !
!ImageStripper categoriesFor: #developmentMethodCategoryNames!constants!public! !
!ImageStripper categoriesFor: #developmentMethods!configuration!public! !
!ImageStripper categoriesFor: #developmentResources!configuration!public! !
!ImageStripper categoriesFor: #disableClassChangeFlagging!operations!private! !
!ImageStripper categoriesFor: #disableDevelopmentSystem!operations!private! !
!ImageStripper categoriesFor: #displayTerminationMessage!operations!private! !
!ImageStripper categoriesFor: #emptyMethodDictionariesOfStubbornClasses!public!testing! !
!ImageStripper categoriesFor: #endElement!helpers!private! !
!ImageStripper categoriesFor: #endElement:!helpers!private! !
!ImageStripper categoriesFor: #endTag!helpers!private! !
!ImageStripper categoriesFor: #executableName!accessing!public! !
!ImageStripper categoriesFor: #executableName:!accessing!public! !
!ImageStripper categoriesFor: #executablePath!accessing!public! !
!ImageStripper categoriesFor: #exeFileExtension!constants!public! !
!ImageStripper categoriesFor: #finalActions!helpers!private! !
!ImageStripper categoriesFor: #finishedStrippingResources!helpers!private! !
!ImageStripper categoriesFor: #finishedWith:!operations!private! !
!ImageStripper categoriesFor: #finishedWithAll:!operations!private! !
!ImageStripper categoriesFor: #finishedWithStripping!operations!private! !
!ImageStripper categoriesFor: #ignoreViewReferences!accessing!public! !
!ImageStripper categoriesFor: #ignoreViewReferences:!accessing!public! !
!ImageStripper categoriesFor: #includeManifestResource!accessing!public!testing! !
!ImageStripper categoriesFor: #includeManifestResource:!accessing!development!public! !
!ImageStripper categoriesFor: #initialize!development!initializing!private! !
!ImageStripper categoriesFor: #initialTidy!helpers!private! !
!ImageStripper categoriesFor: #installRuntimeSessionManager!operations!private! !
!ImageStripper categoriesFor: #isConsoleApplication!public!testing! !
!ImageStripper categoriesFor: #isResourceUpdatingPossible!private!testing! !
!ImageStripper categoriesFor: #isResourceUpdatingRequired!private!testing! !
!ImageStripper categoriesFor: #isToGo!accessing!public!testing! !
!ImageStripper categoriesFor: #isToGo:!accessing!development!public! !
!ImageStripper categoriesFor: #isUnattended!public!testing! !
!ImageStripper categoriesFor: #isUnattended:!accessing!development!public! !
!ImageStripper categoriesFor: #keepImageFile!public!testing! !
!ImageStripper categoriesFor: #logComment:!event handling!private! !
!ImageStripper categoriesFor: #logConfiguration!operations!private! !
!ImageStripper categoriesFor: #logDevelopmentCategories!operations!private! !
!ImageStripper categoriesFor: #logElement:attributes:value:!helpers!private! !
!ImageStripper categoriesFor: #logElement:value:!helpers!private! !
!ImageStripper categoriesFor: #logError:!event handling!private! !
!ImageStripper categoriesFor: #logFileExtension!constants!public! !
!ImageStripper categoriesFor: #logFileName!accessing!public! !
!ImageStripper categoriesFor: #logFold:folded:total:!operations!private! !
!ImageStripper categoriesFor: #logImageStats!helpers!private! !
!ImageStripper categoriesFor: #logManifest!operations!private! !
!ImageStripper categoriesFor: #logPackagePrerequisites!public!testing! !
!ImageStripper categoriesFor: #logPreservedClasses!operations!private! !
!ImageStripper categoriesFor: #logPreservedMessages!operations!private! !
!ImageStripper categoriesFor: #logReferencesToClasses!public!testing! !
!ImageStripper categoriesFor: #logReferencesToClasses:!accessing!public! !
!ImageStripper categoriesFor: #logRemainingClasses!operations!private! !
!ImageStripper categoriesFor: #logRemainingPackages!operations!private! !
!ImageStripper categoriesFor: #logRemainingResources!operations!private! !
!ImageStripper categoriesFor: #logRemoveMethod:!operations!private! !
!ImageStripper categoriesFor: #logSelector:!operations!private! !
!ImageStripper categoriesFor: #logSentMessages:!helpers!private! !
!ImageStripper categoriesFor: #logValue:!helpers!private! !
!ImageStripper categoriesFor: #manifestResourceId!constants!private! !
!ImageStripper categoriesFor: #messagesImplementedBy:!helpers!private! !
!ImageStripper categoriesFor: #messagesSentByClasses:!helpers!private! !
!ImageStripper categoriesFor: #notify:status:!operations!private! !
!ImageStripper categoriesFor: #notifyClassesOfCompletedStrip:!operations!private! !
!ImageStripper categoriesFor: #notifyClassesOfImminentStrip:!operations!private! !
!ImageStripper categoriesFor: #notRequiredClasses!configuration!public! !
!ImageStripper categoriesFor: #notRequiredMethodCategories!configuration!public! !
!ImageStripper categoriesFor: #onError:!event handling!private! !
!ImageStripper categoriesFor: #onNotification:notifier:!event handling!private! !
!ImageStripper categoriesFor: #openLogFile!operations!private! !
!ImageStripper categoriesFor: #potentialAspectSettersIn:!helpers!private! !
!ImageStripper categoriesFor: #prepareToStrip!operations!public! !
!ImageStripper categoriesFor: #preserveAspectSetters!accessing!public! !
!ImageStripper categoriesFor: #preserveAspectSetters:!accessing!development!public! !
!ImageStripper categoriesFor: #preservedMessages!accessing!private! !
!ImageStripper categoriesFor: #preStripCheck!operations!private! !
!ImageStripper categoriesFor: #preStripScript!accessing!public! !
!ImageStripper categoriesFor: #preStripScript:!accessing!public! !
!ImageStripper categoriesFor: #progressDialogClass!constants!public! !
!ImageStripper categoriesFor: #purgeIcons:!helpers!private! !
!ImageStripper categoriesFor: #queryCommand:!commands!development!private! !
!ImageStripper categoriesFor: #referencesFromObjectsInClasses:!helpers!private! !
!ImageStripper categoriesFor: #removeMyClass!operations!private! !
!ImageStripper categoriesFor: #requiredClasses!configuration!public! !
!ImageStripper categoriesFor: #requiredMethodCategories!configuration!public! !
!ImageStripper categoriesFor: #requiredPackageNames!accessing!public! !
!ImageStripper categoriesFor: #resizeStubFile:!operations!private! !
!ImageStripper categoriesFor: #resourceManager!operations!private! !
!ImageStripper categoriesFor: #resourcesForClasses:!helpers!private! !
!ImageStripper categoriesFor: #retainInstVarNames!accessing!public! !
!ImageStripper categoriesFor: #retainInstVarNames:!accessing!public! !
!ImageStripper categoriesFor: #rootClasses!accessing!private! !
!ImageStripper categoriesFor: #rootPackage!accessing!public! !
!ImageStripper categoriesFor: #rootPackage:!accessing!public! !
!ImageStripper categoriesFor: #runPreStripScript!operations!public! !
!ImageStripper categoriesFor: #runtimeSessionManagerClass!accessing!public! !
!ImageStripper categoriesFor: #runtimeSessionManagerClass:!accessing!public! !
!ImageStripper categoriesFor: #saveExecutable:!operations!private! !
!ImageStripper categoriesFor: #scanResourcesForViewReferences:!helpers!private! !
!ImageStripper categoriesFor: #shrinkHashedCollections!operations!public! !
!ImageStripper categoriesFor: #shrinkSymbolTable!operations!private! !
!ImageStripper categoriesFor: #snapshot:!operations!private! !
!ImageStripper categoriesFor: #snapshotType!accessing!public! !
!ImageStripper categoriesFor: #snapshotType:!accessing!public! !
!ImageStripper categoriesFor: #speciallySentMessages!configuration!private! !
!ImageStripper categoriesFor: #startElement:!helpers!private! !
!ImageStripper categoriesFor: #startElement:attributes:!helpers!private! !
!ImageStripper categoriesFor: #startTag:attributes:!helpers!private! !
!ImageStripper categoriesFor: #stripAndSave!operations!public! !
!ImageStripper categoriesFor: #stripAndSaveNotifying:!must not strip!public! !
!ImageStripper categoriesFor: #stripAndSaveWithProgress!operations!public! !
!ImageStripper categoriesFor: #stripClassBuilder!accessing!public! !
!ImageStripper categoriesFor: #stripClassBuilder:!accessing!development!public! !
!ImageStripper categoriesFor: #stripClassGuids!accessing!public! !
!ImageStripper categoriesFor: #stripClassGuids:!accessing!development!public! !
!ImageStripper categoriesFor: #stripClassGuidsNotifying:!operations!private! !
!ImageStripper categoriesFor: #stripClassInfo!accessing!public! !
!ImageStripper categoriesFor: #stripClassInfo:!accessing!development!public! !
!ImageStripper categoriesFor: #stripDeprecatedMethods!public!testing! !
!ImageStripper categoriesFor: #stripDeprecatedMethods:!accessing!development!public! !
!ImageStripper categoriesFor: #stripDevelopmentClasses!accessing!public!testing! !
!ImageStripper categoriesFor: #stripDevelopmentMethods!accessing!public!testing! !
!ImageStripper categoriesFor: #stripDevelopmentObjects:notifying:!operations!private! !
!ImageStripper categoriesFor: #stripDuplicateBytecodes!accessing!public!testing! !
!ImageStripper categoriesFor: #stripDuplicateBytecodes:!accessing!development!public! !
!ImageStripper categoriesFor: #stripDuplicatesNotifying:!operations!private! !
!ImageStripper categoriesFor: #stripDuplicateStrings!accessing!public!testing! !
!ImageStripper categoriesFor: #stripDuplicateStrings:!accessing!development!public! !
!ImageStripper categoriesFor: #stripEmptyMethodDictionaries!accessing!public!testing! !
!ImageStripper categoriesFor: #stripEmptyMethodDictionaries:!accessing!development!public! !
!ImageStripper categoriesFor: #stripRedundantClasses!accessing!public!testing! !
!ImageStripper categoriesFor: #stripRedundantClasses:!accessing!development!public! !
!ImageStripper categoriesFor: #stripRedundantMethods!accessing!public!testing! !
!ImageStripper categoriesFor: #stripRedundantMethods:!accessing!development!public! !
!ImageStripper categoriesFor: #stripRedundantPackages!accessing!public!testing! !
!ImageStripper categoriesFor: #stripRedundantPackages:!accessing!development!public! !
!ImageStripper categoriesFor: #stripRedundantResources!accessing!public!testing! !
!ImageStripper categoriesFor: #stripRedundantResources:!accessing!development!public! !
!ImageStripper categoriesFor: #stripRedundantResources:notifying:!operations!private! !
!ImageStripper categoriesFor: #stripShouldNotImplement!accessing!public!testing! !
!ImageStripper categoriesFor: #stripShouldNotImplement:!accessing!development!public! !
!ImageStripper categoriesFor: #stripSubclassResponsibility!public!testing! !
!ImageStripper categoriesFor: #stripSubclassResponsibility:!accessing!development!public! !
!ImageStripper categoriesFor: #stubFile!public!testing! !
!ImageStripper categoriesFor: #stubFilePath!accessing!public! !
!ImageStripper categoriesFor: #stubFilePath:!accessing!development!public! !
!ImageStripper categoriesFor: #systemPackageManager!accessing!private! !
!ImageStripper categoriesFor: #updateIconResource:!operations!public! !
!ImageStripper categoriesFor: #updateStringTableResource:!operations!public! !
!ImageStripper categoriesFor: #updateStubResources:!operations!private! !
!ImageStripper categoriesFor: #updateVersionResource:!operations!public! !
!ImageStripper categoriesFor: #updateXPManifestResource:!operations!private! !
!ImageStripper categoriesFor: #versionResource!accessing!private! !
!ImageStripper categoriesFor: #versionResource:!accessing!private! !
!ImageStripper categoriesFor: #vmReferencedClasses!constants!public! !
!ImageStripper categoriesFor: #writeLogFile!accessing!public!testing! !
!ImageStripper categoriesFor: #writeLogFile:!accessing!development!public! !

!ImageStripper class methodsFor!

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

for: aPackage
	"Answers an instance of the receiver suitable for stripping aPackage"

	^self new rootPackage: aPackage!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	ClearGuidsMask := 16r1.
	FoldStringsMask := 16r2.
	PreserveAspectsMask := 16r4.
	RetainInstVarNamesMask := 16r8.
	StripClassesMask := 16r10.
	StripClassInfoMask := 16r20.
	StripMethodsMask := 16r40.
	StripResourcesMask := 16r80.
	CompileStructsMask := 16r100.
	FoldMethodDictsMask := 16r200.
	WriteLogMask := 16r400.
	EmptyMethodDictsMask := 16r800.
	FoldBytecodesMask := 16r1000.
	LogReferencesMask := 16r2000.
	StripClassBuilderMask := 16r4000.
	StripShouldNotImplMask := 16r8000.
	StripDeprecatedMask := 16r10000.
	StripPackagesMask := 16r20000.
	LogPrerequisitesMask := 16r40000.
	IgnoreViewReferencesMask := 16r80000.
	ToGoMask := 16r100000.
	NoXPManifestMask := 16r200000.
	AllResourcesStripped := 16r400000.
	RetainSubclassRespMask := 16r800000.
	UnattendedMask := 16r1000000!

isSafeToEncryptWithProductProtection
	"Answer whether it is save to encrypt the receiver's methods as part of the
	the deployment of a Protected Product application"

	^false!

stbConvertFrom: anSTBClassFormat
	"Convert from previous version. 
		Version 1: Added a retainPachydermInfo instance var (removed in v3).
		Version 2: Added a rootClasses instance var and the events instance var in model.
		Version 3: Consolidates all flags into one integer flags variable.
		Version 4:  isToGo flag added (the default)"

	^
	[:data | 
	| newInstance ver |
	newInstance := self basicNew.
	ver := anSTBClassFormat version.
	ver < 2 
		ifTrue: [1 to: data size do: [:i | newInstance instVarAt: i + 1 put: (data at: i)]]
		ifFalse: [1 to: data size do: [:i | newInstance instVarAt: i put: (data at: i)]].
	ver < 3 
		ifTrue: 
			["Former stripRedundantClasses boolean slot now used for flags variable to hold all booleans"
			| stripClasses base var |
			var := ImageStripper indexOfInstVar: 'flags'.
			stripClasses := newInstance instVarAt: var.

			"Initialize flags"
			newInstance instVarAt: var put: self defaultOptions.
			newInstance stripRedundantClasses: stripClasses.
			newInstance stripRedundantPackages: true.

			"Convert former boolean vars to individual bits in the flags variable."
			base := self superclass instSize.
			#(5 6 7 8 9 10 13) 
				with: #(#stripRedundantMethods: #preserveAspectSetters: #stripDuplicateStrings: #compileExternalStructures: #writeLogFile: #stripClassInfo: #retainInstVarNames:)
				do: 
					[:i :setter | 
					newInstance perform: setter with: (newInstance instVarAt: i + base).
					newInstance instVarAt: i + base put: nil]].
	ver < 4 
		ifTrue: 
			["Default is now 'To Go' deployment"
			newInstance isToGo: true].
	newInstance]!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^4! !
!ImageStripper class categoriesFor: #defaultOptions!constants!private! !
!ImageStripper class categoriesFor: #for:!development!instance creation!public! !
!ImageStripper class categoriesFor: #initialize!development!initializing!private! !
!ImageStripper class categoriesFor: #isSafeToEncryptWithProductProtection!constants!public!testing! !
!ImageStripper class categoriesFor: #stbConvertFrom:!binary filing!development!public! !
!ImageStripper class categoriesFor: #stbVersion!binary filing!public! !

