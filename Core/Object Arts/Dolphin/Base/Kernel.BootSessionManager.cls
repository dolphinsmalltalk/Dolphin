"Filed out from Dolphin Smalltalk 7"!

Core.SessionManager subclass: #'Kernel.BootSessionManager'
	instanceVariableNames: 'productDetails startTime'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.BootSessionManager guid: (Core.GUID fromString: '{9dbc5fa6-dace-4809-88b9-83242b7f7d72}')!
Kernel.BootSessionManager comment: 'BootSessionManager is the class of <SessionManager>s installed when the Dolphin image is booting from sources.'!
!Kernel.BootSessionManager categoriesForClass!Development! !
!Kernel.BootSessionManager methodsFor!

allocConsole
	"Private - Open a console window for this session."

	"Attach to the existing console so that the output goes to the build log"

	(KernelLibrary default attachConsole: ATTACH_PARENT_PROCESS)
		ifFalse: [KernelLibrary default allocConsole]!

basicTertiaryStartup
	"Perform tertiary system startup operations."

	"Nothing to do - this SessionManager should never be installed on startup anyway?"!

bootFinished
	| endTime duration |
	endTime := DateAndTime now.
	duration := endTime - startTime.
	self stdout
		nextPutAll: 'Boot completed at';
		print: endTime;
		nextPutAll: ', duration ';
		display: duration;
		cr;
		flush!

bootStarted
	startTime := DateAndTime now.
	self stdout
		nextPutAll: 'Boot started at';
		print: startTime;
		cr!

fileInClass: aClass 
	aClass sourceManager fileIn: aClass fileOutName!

initializeBootPackages
	"Initialize any base system classes that require initialization not performed to create the boot image.
	We cannot reinitialize all the base system classes after re-load as the class initialize methods are not
	all safe to re-run. Therefore we must do this selectively."

	PackageManager systemPackage basicComment: PackageManager systemPackageComment.
	STBPrefix initialize.
	Delay initializeTimingSemaphore.
	CompilerNotification initialize.
	#{Utf8String} value initialize.
	#{SmalltalkLocale} value initialize!

keepAlive
	"We stay alive until explicitly terminated."

	^self!

logError: anException
	"Append details about the unhandled exception, anException, to the session error log.
	Ignored for runtime systems, but it is suggested that subclasses perform some appropriate
	form of error logging. The VM crash dump is one such facility (it doesn't cause a crash and
	can be used for generating a VM walkback to the crash dump file at any time)"

	"Write to the crash dump log - this always works"

	VMLibrary default
		dump: anException description
		path: nil
		stackDepth: -1
		walkbackDepth: -1.
	
	[| target |
	target := self stderr.
	target
		next: 40 put: $-;
		nextPutAll: 'Unhandled exception - '.
	anException printTraceOn: target.
	target
		next: 40 put: $-;
		cr;
		cr;
		flush]
			on: Error
			do: [:e | ]!

main
	self bootStarted.

	self stdout nextPutAll: 'Loading boot script...'; cr; flush.

	self class sourceManager fileIn: 'Boot.st'.
!

onPreSaveImage
	"Private - Perform pre-image save actions (but without the MemoryManager>>onPreSaveImage,
	since this causes a problem when saving an image. This method should be removed later to
	re-inherit the superclass version."

	self trigger: #imageSaveStarting.
	self saveSessionState.
	
	"MemoryManager current onPreSaveImage."
	#{Delay} ifDefined: [:d | d onPreSaveImage]
!

onUnhandledWarning: aWarning
	self stderr
		nextPutAll: aWarning description;
		cr!

openConsole
	self
		allocConsole;
		openConsoleStreams!

openFd: anInteger mode: aSymbol
	^(super openFd: anInteger mode: aSymbol)
		locale: Locale smalltalk;
		yourself!

openSources
	"Private - Open the source files with names derived from the current image path."

	self class sourceManager openSources: self imagePath.
	(File exists: 'Rescue.st') ifTrue: [SourceManager default fileIn: 'Rescue.st'].
	self stdout
		nextPutAll: 'Dolphin Smalltalk Boot';
		cr;
		nextPutAll: 'Copyright (c) Object Arts Ltd, 1997-2018.';
		cr;
		flush!

primaryStartup
	"Private - Perform very early startup actions.
	We must initialize the source manager fairly early on so that we can use the change log."

	self basicPrimaryStartup.
	self openSources!

productDetails
	"Private - Answers an eight element<Array> describing this version of the development environment

	1. <readableString> Product name 
	2. <readableString> Short product name
	3. <Float> Version number
	4. <readableString> Version special
	5. <Integer> Image patch level
	6 <readableString> Very short product name
	7 <readableString> Serial number
	8 <readableString> Boot source info"

	productDetails isNil ifTrue: [productDetails := VMLibrary default defaultProductDetails].
	^productDetails!

productDetails: anArray
	"Private - Sets the receiver's product details to an eight element<Array> 
	describing this version of the development environment"

	productDetails := anArray!

productVersion
	"Answers the <Float> version of this product"

	^VMLibrary default defaultProductDetails at: 3!

quit: anInteger
	"Private - Force a close down of the session with the specified exit code."

	self onExit == true ifTrue: [self primQuit: anInteger].
	^false	"cancelled"!

reloadBootPackages
	| srcMgr basePackage baseClasses imageDir obsoleteMethodFilter missingClasses classesBefore |
	basePackage := PackageManager systemPackage.
	imageDir := self imageBase.
	srcMgr := SourceManager default.
	"First load the constants pools to ensure all constants ref'd in new code are defined"
	Notification signal: 'Reloading BCL constants pools...'.
	basePackage sourceVariableNames
		collect: [:each | srcMgr fileIn: (File relativePathOf: each value fileOutName to: imageDir)].
	Notification signal: 'Updating ClassBuilder...'.
	self fileInClass: ClassBuilder.
	classesBefore := (Package manager allPackagedClasses collect: [:each | each name]) asSet.
	Notification signal: 'Reloading BCL class definitions...'.
	srcMgr fileIn: (File relativePathOf: basePackage classDefinitionsFileName to: imageDir).
	Class subclasses: #().
	"Ensure all base classes (including any defined after the boot image was created) are packaged"
	Object withAllSubclassesDo: 
			[:each |
			(classesBefore includes: each name)
				ifFalse: 
					[Notification signal: 'Adding new class ' , each name , ' to BCL package'.
					each owningPackage: basePackage]].
	"Remove names of any classes that have been renamed"
	classesBefore do: 
			[:each |
			| class |
			class := basePackage classFromName: each.
			class name == each
				ifFalse: 
					[Notification signal: 'Boot class ' , each , ' renamed to ' , class name.
					basePackage removeClassName: each]].
	Smalltalk clearCachedClasses.
	"Then reload all base package classes in breadth-first order"
	Notification signal: 'Reloading BCL classes...'.
	baseClasses := basePackage classesInHierarchyOrder.
	missingClasses := OrderedCollection new.
	baseClasses do: 
			[:each |
			(#(#BootSessionManager #ClassBuilder) identityIncludes: each name)
				ifFalse: 
					[| relativePath |
					relativePath := File relativePathOf: each fileOutName to: imageDir.
					(File exists: relativePath)
						ifTrue: [srcMgr fileIn: relativePath]
						ifFalse: [missingClasses add: each]]].
	missingClasses reverseDo: 
			[:each |
			Notification signal: 'Removing obsolete boot class ' , each printString , '...'.
			each removeFromSystem.
			basePackage basicRemoveClass: each].
	Package manager packages do: [:each | each == basePackage ifFalse: [self reloadPackage: each]].
	Notification signal: 'Deleting obsolete boot image methods...'.
	obsoleteMethodFilter := [:each | each hasChanged not].
	(baseClasses difference: missingClasses) do: 
			[:each |
			each setInstanceVariables: each instVarNames.
			(((each selectMethods: obsoleteMethodFilter)
				asSortedCollection: [:a :b | a printString <= b printString])
				addAll: (each class selectMethods: obsoleteMethodFilter);
				yourself) do: 
						[:m |
						Notification signal: 'Removing obsolete boot image method ' , m printString.
						m methodClass removeSelector: m selector]].
	self initializeBootPackages!

reloadPackage: aPackage
	| newPackage missingClasses |
	Notification signal: 'Reloading ' , aPackage name printString , ' ...'.
	newPackage := Package fromFile: aPackage fileOutName.
	Package manager
		basicRemovePackage: aPackage;
		forgetLooseMethods;
		basicAddPackage: newPackage;
		basicInstall: newPackage;
		observePackage: newPackage.

	"Remove names of any classes that have been renamed from the old package"
	aPackage classNames do: 
			[:each |
			| class |
			class := newPackage classFromName: each.
			class asQualifiedReference = each
				ifFalse: 
					[Notification signal: 'Boot class ' , each asString , ' renamed to ' , class fullName.
					aPackage removeClassName: each]].
	missingClasses := aPackage classesInHierarchyOrder difference: newPackage classes.
	missingClasses reverseDo: 
			[:each |
			Notification signal: 'Removing obsolete boot class ' , each fullName , '...'.
			each removeFromSystem]!

saveImageDefault
	"Save an image of the current session to the default persistant store (whatever that is)."

	self class sourceManager flushChanges.
	self snapshot.!

shellClosed: aShell
	"Inform the receiver that aShell has been closed"
!

shellOpened: aShell
	"Inform the receiver that aShell has been opened"


!

shutdown
	"Perform shutdown operations before the VM puts out the lights. Note that if the boot
	session is successful, this will never be reached since the BootSessionManager will have
	been replaced with a DevelopmentSessionManager before the booted image exits."

	[self traceLine: 'Shutting down boot session'] on: Error do: [:ex |].
	super shutdown!

snapshot
	"Private - Performs a snapshot of the current image."

	Notification signal: 'Saving booted image to ' , self imageFileName.
	self snapshot: self imageFileName!

startUI
	"Start up the input loop/message loop (instruct InputState appropriate depending on whether
	this is a GUI or console session)."

	self inputState consoleStartup!

traceStream
	"Answer a <puttableStream> onto the session's trace output device."

	^stdioStreams isNil ifTrue: [super traceStream] ifFalse: [self stdout]!

unhandledException: anException
	"Private - The unhandled Exception, anException, occurred in the active Process.
	Depending on the user response and the resumability of the exception, either 
	resume or terminate the process.
	Note: The exception response protocol (#resume, #pass, #outer, #exit, etc)
	can only be sent to an Exception inside a handler block (i.e. the second
	argument to BlockClosure>>on:do:)."

	self logError: anException.
	"Note that unlike a GUI session (which is event driven), we kill the entire session in the event
	  of an unhandled Error. If you are writing a multi-threaded, headless, server then you may 
	  want to override this behaviour to just #terminate the faulting <Process>."
	anException isUserResumable ifFalse: [
		self quit: -1].
	^anException!

updateBootImage
	"Update the boot image with any changes made since it was last created."

	"The only thing done currently is to reload the BCL."

	self reloadBootPackages! !
!Kernel.BootSessionManager categoriesFor: #allocConsole!operations!private! !
!Kernel.BootSessionManager categoriesFor: #basicTertiaryStartup!operations-startup!public! !
!Kernel.BootSessionManager categoriesFor: #bootFinished!event handling!public! !
!Kernel.BootSessionManager categoriesFor: #bootStarted!event handling!public! !
!Kernel.BootSessionManager categoriesFor: #fileInClass:!private! !
!Kernel.BootSessionManager categoriesFor: #initializeBootPackages!initializing!public! !
!Kernel.BootSessionManager categoriesFor: #keepAlive!idling!public! !
!Kernel.BootSessionManager categoriesFor: #logError:!operations-logging!public! !
!Kernel.BootSessionManager categoriesFor: #main!operations-startup!public! !
!Kernel.BootSessionManager categoriesFor: #onPreSaveImage!event handling!public! !
!Kernel.BootSessionManager categoriesFor: #onUnhandledWarning:!event handling!public! !
!Kernel.BootSessionManager categoriesFor: #openConsole!operations!public! !
!Kernel.BootSessionManager categoriesFor: #openFd:mode:!operations!private! !
!Kernel.BootSessionManager categoriesFor: #openSources!operations-source files!private! !
!Kernel.BootSessionManager categoriesFor: #primaryStartup!operations-startup!private! !
!Kernel.BootSessionManager categoriesFor: #productDetails!accessing!private!product! !
!Kernel.BootSessionManager categoriesFor: #productDetails:!accessing!private!product! !
!Kernel.BootSessionManager categoriesFor: #productVersion!accessing!product!public! !
!Kernel.BootSessionManager categoriesFor: #quit:!operations-shutdown!private! !
!Kernel.BootSessionManager categoriesFor: #reloadBootPackages!operations-startup!public! !
!Kernel.BootSessionManager categoriesFor: #reloadPackage:!operations-startup!public! !
!Kernel.BootSessionManager categoriesFor: #saveImageDefault!operations-saving!public! !
!Kernel.BootSessionManager categoriesFor: #shellClosed:!operations-startup!private! !
!Kernel.BootSessionManager categoriesFor: #shellOpened:!operations-startup!private! !
!Kernel.BootSessionManager categoriesFor: #shutdown!operations-shutdown!public! !
!Kernel.BootSessionManager categoriesFor: #snapshot!operations-saving!private! !
!Kernel.BootSessionManager categoriesFor: #startUI!operations-startup!public! !
!Kernel.BootSessionManager categoriesFor: #traceStream!accessing!operations-logging!public! !
!Kernel.BootSessionManager categoriesFor: #unhandledException:!exceptions!private! !
!Kernel.BootSessionManager categoriesFor: #updateBootImage!operations-startup!public! !

!Kernel.BootSessionManager class methodsFor!

imageExtension
	"Answer the suffix for an executable image file"

	^'img7'.! !
!Kernel.BootSessionManager class categoriesFor: #imageExtension!constants!public! !

