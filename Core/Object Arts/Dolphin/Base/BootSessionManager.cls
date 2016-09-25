"Filed out from Dolphin Smalltalk 7"!

SessionManager subclass: #BootSessionManager
	instanceVariableNames: 'productDetails'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BootSessionManager guid: (GUID fromString: '{9DBC5FA6-DACE-4809-88B9-83242B7F7D72}')!
BootSessionManager comment: 'BootSessionManager is the class of <SessionManager>s installed when the Dolphin image is booting from sources.'!
!BootSessionManager categoriesForClass!Development! !
!BootSessionManager methodsFor!

basicTertiaryStartup
	"Perform tertiary system startup operations."

	"Nothing to do - this SessionManager should never be installed on startup anyway?"!

fileInClass: aClass 
	aClass sourceManager fileIn: aClass fileOutName!

keepAlive
	"We stay alive until explicitly terminated."

	^self!

logError: anException 
	"Append details about the unhandled exception, anException, to the session error log.
	Ignored for runtime systems, but it is suggested that subclasses perform some appropriate
	form of error logging. The VM crash dump is one such facility (it doesn't cause a crash and
	can be used for generating a VM walkback to the crash dump file at any time)"

	"Write to the crash dump log - this always works"

	| stderrBad |
	super logError: anException.
	stderrBad := false.
	
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
		flush.
	"In case the session is attended, pause briefly so the user can see the error"
	Processor sleep: 10000] 
			on: Error
			do: [:e | ]!

main
	self stdout 
		nextPutAll: 'Dolphin Smalltalk Boot'; cr; 
		nextPutAll: 'Copyright (c) Object Arts Ltd, 1997-2004.'; cr; cr;
		nextPutAll: 'Loading boot script...'; cr; flush.

	self class sourceManager fileIn: 'Boot.st'.
!

onPreSaveImage
	"Private - Perform pre-image save actions (but without the MemoryManager>>onPreSaveImage,
	since this causes a problem when saving an image. This method should be removed later to
	re-inherit the superclass version."

	self trigger: #imageSaveStarting.
	self saveSessionState.
	
	"MemoryManager current onPreSaveImage."
	self class environment at: #Delay ifPresent: [:d | d onPreSaveImage]
!

openSources
	"Private - Open the source files with names derived from the current image path."

	self class sourceManager openSources: self imagePath!

primaryStartup
	"Private - Perform very early startup actions.
	We must initialize the source manager fairly early on so that we can use the change log."

	self basicPrimaryStartup.
	self openSources!

productDetails
	"Private - Answers a five element<Array> describing this version of the development environment

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
	"Private - Sets the receiver's product details to a five element<Array> 
	describing this version of the development environment"

	productDetails := anArray!

productVersion
	"Answers the <Float> version of this product"
	
	^VMLibrary default defaultProductDetails at: 3
!

reloadSystemPackage
	| srcMgr basePackage baseClasses imageDir obsoleteMethodFilter missingClasses |
	basePackage := PackageManager systemPackage.
	imageDir := self imageBase.
	srcMgr := SourceManager default.
	"First load the constants pools to ensure all constants ref'd in new code are defined"
	Notification signal: 'Reloading BCL constants pools...'.
	basePackage sourceGlobalVariables 
		collect: [:each | srcMgr fileIn: (File relativePathOf: each value fileOutName to: imageDir)].
	Notification signal: 'Updating ClassBuilder...'.
	self fileInClass: ClassBuilder.
	Notification signal: 'Reloading BCL class definitions...'.
	"First tag all the existing classes so we can spot the dead ones later."
	srcMgr fileIn: (File relativePathOf: basePackage classDefinitionsFileName to: imageDir).
	Class subclasses: nil.
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
						m methodClass removeSelector: m selector]]!

saveImageDefault
	"Save an image of the current session to the default persistant store (whatever that is)."

	self class sourceManager flushChanges.
	self snapshot.!

saveImageTo: aString 
	"Private - Snapshot to filePath.img, marking the log with a timestamp and copying sources
	files. N.B. Use the public entry point #saveImage: to save an image to a new path.

	Take a special interest if we do not currently have the source files available. This will be
	the case when we load from a .exe. In this case we generate some suitable empty source
	files. We also have to mark methods so that they know they have lost any reference to
	information in a .sml file."

	| oldImagePath oldSentry |
	oldImagePath := self imagePath.
	oldSentry := sentry.

	"Now save image and swap over sources. Take care to end up with a good sources and imagePath"
	
	[self imagePath: aString.
	self createSentinel 
		ifTrue: 
			[| mb |
			mb := MessageBox new.
			mb beTaskModal.
			mb 
				errorMsg: ('The image <1p> is open in another Dolphin instance.<n><n>Close that instance and try again should you still wish to save this image to that name.<n><n>The image has not been saved!!' 
						expandMacrosWith: self imageFileName).
			^self].
	self class sourceManager copyAndReopenSources: self imagePath.
	self
		snapshot: self imageFileName;
		logComment: ('Image saved to <1p>' expandMacrosWith: aString).
	KernelLibrary default closeHandle: oldSentry] 
			ifCurtailed: 
				["Attempt to return to the old state so sources & stuff are intact
				 before showing the user the problem."
				
				[KernelLibrary default closeHandle: sentry.
				sentry := oldSentry.
				self
					imagePath: oldImagePath;
					openSources] 
						on: Error
						do: [:anError | anError resignalAsWarning]]!

shellClosed: aShell
	"Inform the receiver that aShell has been closed"
!

shellOpened: aShell
	"Inform the receiver that aShell has been opened"


!

shutdown
	"Perform shutdown operations before the VM puts out the lights."

	self trace: 'Shutting down boot session', String lineDelimiter.
	super shutdown!

snapshot
	"Private - Performs a snapshot of the current image."
	
	Notification signal: 'Saving booted image to ', self imageFileName.
	self snapshot: self imageFileName!

startUI
	"Start up the input loop/message loop (instruct InputState appropriate depending on whether
	this is a GUI or console session)."

	self inputState consoleStartup!

trace: aString
	"Append aString to the trace device.
	Use the stderr stream if available, otherwise the OS debug trace device (implemented in superclass)"

	stdioStreams isNil
		ifTrue: [super trace: aString]
		ifFalse: [self stderr nextPutAll: aString; flush]!

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

	self reloadSystemPackage! !
!BootSessionManager categoriesFor: #basicTertiaryStartup!operations-startup!public! !
!BootSessionManager categoriesFor: #fileInClass:!private! !
!BootSessionManager categoriesFor: #keepAlive!idling!public! !
!BootSessionManager categoriesFor: #logError:!operations-logging!public! !
!BootSessionManager categoriesFor: #main!operations-startup!public! !
!BootSessionManager categoriesFor: #onPreSaveImage!event handling!public! !
!BootSessionManager categoriesFor: #openSources!operations-source files!private! !
!BootSessionManager categoriesFor: #primaryStartup!operations-startup!private! !
!BootSessionManager categoriesFor: #productDetails!accessing!private!product! !
!BootSessionManager categoriesFor: #productDetails:!accessing!private!product! !
!BootSessionManager categoriesFor: #productVersion!accessing!product!public! !
!BootSessionManager categoriesFor: #reloadSystemPackage!operations-startup!public! !
!BootSessionManager categoriesFor: #saveImageDefault!operations-saving!public! !
!BootSessionManager categoriesFor: #saveImageTo:!operations-saving!private! !
!BootSessionManager categoriesFor: #shellClosed:!operations-startup!private! !
!BootSessionManager categoriesFor: #shellOpened:!operations-startup!private! !
!BootSessionManager categoriesFor: #shutdown!operations-shutdown!public! !
!BootSessionManager categoriesFor: #snapshot!operations-saving!private! !
!BootSessionManager categoriesFor: #startUI!operations-startup!public! !
!BootSessionManager categoriesFor: #trace:!operations-logging!public! !
!BootSessionManager categoriesFor: #unhandledException:!exceptions!private! !
!BootSessionManager categoriesFor: #updateBootImage!operations-startup!public! !

!BootSessionManager class methodsFor!

imageExtension
	"Answer the suffix for an executable image file"

	^'img7'.! !
!BootSessionManager class categoriesFor: #imageExtension!constants!public! !

