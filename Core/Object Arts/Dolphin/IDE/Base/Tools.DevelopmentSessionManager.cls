"Filed out from Dolphin Smalltalk"!

UI.GUISessionManager
	subclass: #'Tools.DevelopmentSessionManager'
	instanceVariableNames: 'imageStamp installationDirectory backupOnImageSave productDetails showSplashAtStartup'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.DevelopmentSessionManager guid: (Core.GUID fromString: '{5902537a-8d40-49c3-94f3-2cd287656c38}')!
Tools.DevelopmentSessionManager comment: ''!
!Tools.DevelopmentSessionManager categoriesForClass!System-Support! !
!Tools.DevelopmentSessionManager methodsFor!

advanceImageVersionMinor
	"Advance the minor component of the images version number."

	self imageVersionMinor: self imageVersionMinor + 1.!

allowDuplicate
	"It would appear that the image associated with this session is already open. Take action
	appropriate to the policies of the receiver. Ask the user whether to continue the session."

	| mb |
	mb := MessageBox new.
	mb beTaskModal.
	^mb
		caption: self applicationName;
		icon: self icon;
		defaultButton: 2;
		headline: 'The image <1p> is already open' << self imageFileName;
		text: 'You can continue, but you risk corrupting the change log.<n><n>Are you sure that you really want to open the same image again?'
					expandMacros;
		confirm!

appIdString
	^'5902537A8D4049C394F32CD287656C38'!

applicationName
	"Answers the <readableString> name of this Dolphin product"
	
	^self productDetails at: #productName

!

applicationShortName
	"Answer a <readableString> which is the abbreviated application name."

	^self productDetails at: #shortProductName!

backupOnImageSave
	"Answer whether the image should be backed up (i.e. the old .img file is renamed to .bak when the new .img
	file is successfully written). Note that this will slow down the operation quite a bit, as the OS has to do a lot
	more juggling."

	backupOnImageSave isNil ifTrue: [backupOnImageSave := super backupOnImageSave].
	^backupOnImageSave!

backupOnImageSave: aBoolean
	"Set whether the image should be backed up (i.e. the old .img file is renamed to .bak when the new .img
	file is successfully written)."

	backupOnImageSave := aBoolean!

bootInfo
	"Answer the Git info of the sources from which this image was originally booted"

	^self productDetails at: #bootInfo!

bootInfo: aStringOrNil 
	"Set the Git info of the sources from which this image was originally booted"

	^self productDetails at: #bootInfo put: aStringOrNil!

canPlaySounds
	^SmalltalkSystemShell playSystemSounds!

closeAllHelp
	"Close all HTML Help windows"

	HTMLHelpLibrary htmlHelpCloseAll!

commandLineParser
	"
	-d path - Rebase Dolphin core packages to supplied path
	-f fileInFile - file in an ST chunk file
	-h - headless (embedded) mode
	-i imageFile - initialize a new image
	-q - quiet startup (no splash)
	-u - run unattended (i.e. don't prompt the user for input)
	-x - immediately exit
	"

	| startupSession |
	startupSession := self sessionId.	"deferred actions might get saved and show up in a new session and we want to do them only in the original session"
	^super commandLineParser
		addOption: $u;
		addOptionAllowingArgument: $d
			whenPresentDo: 
				[:rebasePath |
				self inputState queueDeferredAction: 
						[startupSession == self sessionId
							ifTrue: 
								[Package manager rebaseBasePackagesTo: rebasePath ?? '.'.
								self saveImage]]];
		addOptionRequiringArgument: $f
			whenPresentDo: 
				[:fileInFile |
				self inputState queueDeferredAction: 
						[startupSession == self sessionId ifTrue: [SourceManager default fileIn: fileInFile]]];
		addOptionAllowingArgument: $i
			whenPresentDo: 
				[:newImageFile |
				self inputState queueDeferredAction: 
						[startupSession == self sessionId ifTrue: [self saveImage: newImageFile ?? 'Dolphin']]];
		addOption: $x
			whenPresentDo: 
				[self inputState queueDeferredAction: [startupSession == self sessionId ifTrue: [self quit]]];
		yourself!

free
	"Free any artifacts of the current session.
	WARNING: This may disable the development system, so use carefully."

	self mainShellClass free.
!

getInstallationDirectory
	"Private - Determine and answer the installation directory."

	| folder |
	SmalltalkSystem current isOAD ifTrue: [^self imageBase].
	"Note we use a read-only key because some users do not have the rights to open a read/write key under HKLM"
	folder := (RegKey localMachineRoot: #read) at: self productRegistryKey ifPresent: [:key | key value].
	folder isNil
		ifTrue: 
			["Otherwise try the path to the VM"
			folder := File splitPathFrom: VM fileName].
	^File appendPathDelimiter: folder!

imageStamp
	"Answer the <DateAndTime> at which the image was last saved."

	^imageStamp!

imageStamp: aDateAndTime
	"Private - Set the <DateAndTime> marking the date and time of the image."

	imageStamp := aDateAndTime!

imageVersionMinor: anInteger
	"Private - Set the minor component of the image's version Integer."

	^VM registryAt: #ImageVersionMinor put: anInteger!

initialize
	super initialize.
	showSplashAtStartup := true!

initializeFromSessionManager: oldSessionManager 
	"Private - The receiver has taken take over as the current session
	manager from oldSessionManager. This is an opportunity to transfer
	state information from the replaced manager."

	super initializeFromSessionManager: oldSessionManager.
	self productDetails: oldSessionManager productDetails.
	self 
		when: #queryEndSession:
		send: #onQueryEndSession:
		to: self!

installationDirectory
	"Answer the directory String of the directory the Dolphin development system is installed.
		SessionManager current installationDirectory.
	"

	installationDirectory isNil 
		ifTrue: [installationDirectory := self getInstallationDirectory].
	^installationDirectory!

isBinaryLooseMethodInstallationAllowed
	"Private - Answer true if loose method can be installed into the image by a BinaryPackage.
	By default the development environment does not allow this to avoid the development
	browsers becoming confused by such methods. 

	If you wish to debug BinaryPackages that make contain loose methods you may temporarily
	change this method to answer true but BEWARE; the loose methods will appear to be owned
	by the normal source packages. If you accidentally save these source packages they will
	contain these methods"

	^false!

isDLL
	"Private - Answer whether the receiver is a shared library, as opposed to an application.
	Implementation Note: The development image may be started under the control of another
	application (e.g. the browser plug-in, or as in-proc COM component) and so we must
	dynamically decide whether we are a DLL or not."

	^self outer notNull!

isEmbedded
	"Answer whether the session is running, or should be started, in 'embedded' 
	mode (i.e. headless). In the case of a development session we only want to
	do this if the headless flag was specifically used, since in other cases we
	want to display the UI regardless in order that the development tools are
	available for debugging, etc."

	^self isEmbedding!

isOAD
	"Private - Is this an Object Arts Development image?"

	^(self productDetails at: #abbreviatedProductName) = 'OAE'!

keepAlive
	"The inputState has determined that there are no live windows.
	For safety, we bring up a new system shell in a development session, as this
	will help to recover (in particular) from situations where a bad image has been
	saved down. Even this may not work if insufficient Session startup was achieved
	before the error occurred."

	self isEmbedded ifFalse: [self mainShellClass onNoVisibleWindows]!

lastSerialNumberRegistryKeyFor: aDolphinProduct
	"Private - Answers the <readableString> registry key of this serial number for this product"

	^'<1s>\Last <2s> Serial Number'
		expandMacrosWithArguments: {self productRegistryKey. aDolphinProduct name}
		locale: Locale invariant!

lastSerialNumberRegistryKeyPre61
	"Private - Answers the <readableString> registry key of this serial number for this product"

	^'<1s>\Last Serial Number' expandMacrosWithArguments: {self productRegistryKey}
		locale: Locale invariant!

logComment: aString
	"Append the informational message, aString, to the development change log."

	self class sourceManager logComment: aString!

logError: anException
	"Append details about the unhandled exception, anException, to the session error log.
	N.B. MUST NOT RAISE ANY EXCEPTIONS OTHERWISE RECURSIVE WALKBACK MAY RESULT."

	self isUnattended
		ifTrue: 
			[VM
				dump: anException description
				path: nil
				stackDepth: -1
				walkbackDepth: -1.
			^self].
	
	[| f |
	f := FileStream
				write: self errorLogName
				mode: #append
				type: #utf8.
	f
		print: DateAndTime now;
		nextPutAll: ': Unhandled exception - '.
	anException printTraceOn: f.
	f
		next: 100 put: $-;
		cr;
		cr;
		close]
			on: Error
			do: 
				[:e |
				[e toTrace	"Suppress errors writing to log"] on: Error
					do: 
						[:e2 |
						"Couldn't even write a trace message"
						]]!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^#{SmalltalkSystemShell} valueOrNil ?? TranscriptShell!

onExit
	"Perform pre-termination actions."

	"Close any outstanding help windows"
	self closeAllHelp.

	^super onExit!

onQueryEndSession: aBooleanValue
	"The user has initiated the end of the session, either by shutting down (or logging off of)
	Window, or by closing the system launcher window. Prompt the user to save the image, and
	give them the opportunity to abort the shutdown."

	| mb |
	self isEmbedded ifTrue: [^self].
	mb := MessageBox new.
	mb beTaskModal.
	mb
		headline: 'Exit Dolphin Smalltalk?';
		customButtons: #(#(#yes '&Save Image') #(#no 'Do&n''t Save'));
		confirm: 'Saving the image will preserve changes for your next session.'
			onYes: [self saveImage]
			onNo: []
			onCancel: [aBooleanValue value: false]!

onQueryWindowsShutdown
	"The Windows OS is shutting down, save the image and allow shutdown"

	self saveImage.
	self quit: 0!

onUnhandledWarning: aWarning
	"The unhandled Warning, aWarning, occurred in the active Process.
	Override the superclass implementation in order to give the user
	the opportunity to bring up a walkback and go into the debugger."

	| mb description details |
	description := aWarning description readStream.
	mb := MessageBox new
				headline: description nextLine;
				yourself.
	details := description upToEnd.
	details := details notEmpty
				ifTrue: 
					[(WriteStream with: details)
						cr;
						cr;
						yourself]
				ifFalse: [String writeStream].
	aWarning isSuppressible
		ifTrue: 
			[mb
				isSuppressible: true;
				uniqueId: aWarning raisingFrame method suppressionId.
			aWarning isUserResumable
				ifTrue: 
					[(mb
						customButtons: #(#(#ok '&Continue'));
						detailsText: (details
									nextPutAll: 'Press Continue to resume execution, disregarding the warning.
Press Cancel to terminate the process, cancelling the operation.

You can suppress this warning, in which case it will not be shown again. If the warning is suppressed, then it will be ignored on future occurrence, regardless of the choice you make now.';
									contents);
						buttonStyle: #okCancel;
						warning) ~~ #ok
						ifTrue: [Processor activeProcess terminate]]
				ifFalse: 
					["Not resumable"
					mb errorMsg.
					Processor activeProcess terminate]]
		ifFalse: 
			[| response |
			response := mb
						buttonStyle: #abortRetryIgnore;
						customButtons: #(#(#abort '&Cancel') #(#retry '&Debug') #(#ignore '&Continue'));
						detailsText: (details
									nextPutAll: 'Press Cancel to terminate the process, cancelling the operation.
Press Debug to open a debugger at the warning site.
Press Continue to resume execution, disregarding the warning.';
									contents);
						warning.
			response == #retry
				ifTrue: [self unhandledException: aWarning]
				ifFalse: [response == #abort ifTrue: [Processor activeProcess terminate]]
			"#ignore - Continue execution"]!

onUserBreak
	"Bring up the Smalltalk debugger (suspending the active process) ..."

	| process |
	process := Processor activeProcess.
	process halt: process topFrame sender cause: 'Interrupted'!

open: filename
	"Private - Opens a file identified by the <readableString> filename in this instance of
	the development environment"

	| openMsg ext |
	ext := (File splitExtensionFrom: filename) asUppercase.
	openMsg := ##(LookupTable new
		at: 'PAC' put: #openPackage:;
		at: 'PAX' put: #openPackage:;
		at: 'CLS' put: #openWorkspace:;
		at: 'ST' put: #openWorkspace:;
		at: 'XML' put: #openXmlFile:;
		yourself) at: ext ifAbsent: [
			^MessageBox notify: 'Unable to open <1s>' << filename ].
	self perform: openMsg with: filename 
!

openFd: anInteger mode: aSymbol
	^(super openFd: anInteger mode: aSymbol)
		locale: Locale smalltalk;
		yourself!

openPackage: filename
	"Private - Opens a file identified by the <readableString> filename as a package file"

	| package name devsys |
	devsys := SmalltalkSystem current.
	name := File splitStemFrom: filename.
	package := devsys packageManager packageNamed: name
				ifNone: 
					[| loaded |
					loaded := devsys packageManager install: filename.
					loaded notEmpty ifTrue: [package := loaded last]].
	package notNil ifTrue: [package browse]!

openSources
	"Private - Open the source files with names derived from the current image path."

	self class sourceManager openSources: self imagePath!

openWorkspace: filename
	"Private - Opens a file identified by the <readableString> filename as a workspace file"

	SmalltalkSystem current openWorkspace: filename!

openXmlFile: aString
	"Private - Opens a file identified by the <readableString> argument an XML file"

	SmalltalkSystem current dropXmlFile: aString!

parseCmdLineFlags
	super parseCmdLineFlags.
	(self commandLineParser options includesKey: $u) ifTrue: [flags := flags maskSet: UnattendedMask]!

patchLevel
	"Answer the current patch level of this image"

	^self productDetails at: 5!

patchLevel: anInteger
	"Private - Set the current patch level of this image to anInteger"

	anInteger > self patchLevel ifTrue: [
		self productDetails at: 5 put: anInteger.
		Notification signal: 'Image now at Patch Level ', anInteger displayString ] !

playImageSaveSound
	self canPlaySounds 
		ifTrue: 
			[(Sound fromFile: 'Resources\ImageSave.wav' usingLocator: FileLocator installRelative) woof]!

playStartupSound
	self canPlaySounds 
		ifTrue: 
			[(Sound fromFile: 'Resources\Startup.wav' usingLocator: FileLocator installRelative) woof]!

popupHelpFile
	^FileLocator installRelative localFileSpecFor: 'EducationCentrePopups7.hlp'!

preStart
	"Private - Sent before the secondary level startup code has a chance to run.
	This allows us to user-defined actions after the system source is available,
	but before the windowing and process systems, etc, have been started."

	(File exists: PreStartFile) ifFalse: [^self].
	"We can't use the TaskDialog here, so use the raw MessageBox API"
	(User32
		messageBox: nil
		text: 'File in "' , PreStartFile , '"?'
		caption: self applicationName
		style: ##(MessageBoxConstants.MB_TASKMODAL | MessageBoxConstants.MB_SETFOREGROUND
				| MessageBoxConstants.MB_YESNO)
		icon: nil
		instance: nil) == IDYES
		ifTrue: [self class sourceManager fileIn: PreStartFile]!

primaryStartup
	"Private - Perform very early startup actions."

	installationDirectory := nil.
	self basicPrimaryStartup.
	"We must initialize the source manager fairly early on so that we can use the change log."
	self openSources!

processCommandLine
	"private
	-d path - Rebase Dolphin core packages to supplied path
	-f fileInFile - file in an ST chunk file
	-h - headless (embedded) mode
	-i imageFile - initialize a new image
	-q - quiet startup (no splash)
	-x - immediately exit
	"

	| commandLine arguments |
	commandLine := (self commandLineParser)
				processOptions;
				yourself.
	"-h and -q are already defined"
	(arguments := commandLine arguments) isEmpty ifTrue: [^self].
	"Open a source file (CLS, ST, PAX, PAC, SML) in the appropriate tool"
	arguments allButFirst do: [:openFile | self open: openFile]	"leave off image name"!

productDetails
	"Private - Answers a <LookupTable>  of key-value pairs describing this version of the development environment"

	productDetails isNil ifTrue: [productDetails := VM defaultProductDetails].
	^productDetails!

productDetails: anArray
	"Private - Sets the receiver's product details to an eight element<Array> 
	describing this version of the development environment"

	productDetails := anArray.
	installationDirectory := nil!

productMajorVersion
	"Answers the <Integer> major version number of this development image."
	
	^self productVersion major
!

productRegistryKey
	"Private - Answers the <readableString> registry key of this product"

	| key version |
	key := 'Software\Object Arts\Dolphin Smalltalk'.
	version := self productRegistryVersion.
	^version isEmpty ifTrue: [key] ifFalse: [key , ' ' , version]!

productRegistryVersion
	"Private - Answers the version this product suitable for looking up our installation in the registry. This is a special version that normally doesn't change between major versions."
	
	^self productDetails at: #registryVersion
!

productVersion
	"Answers a `SemVer` describing the version of this product."

	^SemVer fromString: (self productDetails at: #productVersionString)!

productVersionSpecial
	"Answers the <readableString> special version of this product"
	
	^self productDetails at: 4
!

registeredSerialNumber
	"Private - Answers the primary <readableString> registered serial number for this product."

	^self productDetails at: #serialNumber!

registeredSerialNumber: aString
	"Private - Sets the primary <readableString> registered serial number for this product."

	self productDetails at: 7 put: aString!

resetPatchLevel
	"Private - Set the current patch level of this image to 0"

	self productDetails at: #basePatchLevel put: 0.
!

resourcesLocatorForClass: aClass 
	^aClass owningPackage fileLocator!

retire
	"This SessionManager instance is stepping down in favour of a new boy. Perform any
	uninitialisation that might be required; because the session manager instances are swapped
	with become, we must make sure to remove any unwanted event subscriptions as these will be
	transferred to the new session manager."

	self removeEventsTriggeredFor: self!

saveImageDefault
	"Private - Snapshot the running image to the path from which it was started,
	marking the log with a timestamp.

	If the source files are available then we can just flush the changes and write the
	image. If we do not have the source files then we have to call the full
	saveImage: method which will create these files."

	self class sourceManager hasSources 
		ifTrue: 
			[self class sourceManager flushChanges.
			self
				snapshot;
				logComment: 'Image saved']
		ifFalse: [self saveImageTo: self imageFileName].!

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
				headline: 'The image <1p> is open in another Dolphin instance.' << self imageFileName;
				errorMsg: 'Close that instance and try again should you still wish to save this image to that name.<n><n>The image has not been saved!!'
							expandMacros.
			^self].
	self class sourceManager copyAndReopenSources: self imagePath.
	self
		snapshot: self imageFileName;
		logComment: ('Image saved to <1p>' expandMacrosWith: aString).
	Kernel32 closeHandle: oldSentry]
			ifCurtailed: 
				["Attempt to return to the old state so sources & stuff are intact
				 before showing the user the problem."
				
				[Kernel32 closeHandle: sentry.
				sentry := oldSentry.
				self
					imagePath: oldImagePath;
					openSources]
						on: Error
						do: [:anError | anError resignalAsWarning]]!

saveSessionState
	"Save down any session state that needs to be preserved and which is not automatically
	preserved by a normal image save. Examples would be externally managed resources
	such as Windows."

	self imageStamp: DateAndTime now.
	super saveSessionState.!

sentinelName
	"Answer the name of the Win32 Event object created to uniquely identify this session
	so that attempts to run additional instances can be detected.
	Here we override to force a machine global name so that attempts by different users
	to run up the same image can be detected, although this is only relevant on terminal
	server hosts, or those running Windows XP with fast-user switching enabled."

	^'Global\' , super sentinelName!

showSplash
	"Show a splash screen for this session."

	(self splashShellClass notNil and: [self splashShowAtStartup]) ifFalse: [^false].
	^(self splashShellClass new)
		when: #viewClosed
			send: #trigger:
			to: self
			with: #sessionReady;
		showTimed!

shutdown
	"Perform development system shutdown actions."

	super shutdown.
	self class sourceManager onExit!

snapshot
	"Private - Performs a snapshot of the current image."
	
	self snapshot: self imageFileName!

snapshot: fileName
	"Save the current image to fileName. Advance the minor component of
	the image version."

	^self
		advanceImageVersionMinor;
		primSnapshot: fileName
			backup: self backupOnImageSave
			type: 0
			maxObjects: nil!

splashShellClass
	"Private - Answer the class of splash shell to display on startup, or nil for no splash."

	^SmalltalkSystem current aboutBoxClass!

splashShellClass: aSplash
	"Private - Set the class of splash shell to display on startup, or nil for no splash."

	^SmalltalkSystem current aboutBoxClass: aSplash!

splashShowAtStartup
	showSplashAtStartup isNil ifTrue: [showSplashAtStartup := true].
	^showSplashAtStartup!

splashShowAtStartup: aBoolean 
	showSplashAtStartup := aBoolean!

tertiaryStartup
	"Perform development system tertiary startup (e.g. ensure 
	SmalltalkSystemShell is available)."

	"Invalidate options before restoring window state"

	SmalltalkToolShell invalidateOptions.
	super tertiaryStartup.
	self disableWindowGhosting.
	ClipboardBinaryObjectTypeConverter current beUnrestricted.
	"Flush any output accumulated in the transcript buffer during startup."
	TranscriptShell current flush.
	self mainShellClass onStartup.
	self processCommandLine!

traceStream
	^(self isHeadless not and: [Transcript notNil])
		ifTrue: [Transcript]
		ifFalse: [stdioStreams isNil ifTrue: [super traceStream] ifFalse: [self stderr]]!

unhandledException: anException
	"Private - The <Exception> argument has been raised but not caught and handled. Log the
	exception to the error log and, if the session is attended, pop up a walkback. Otherwise for
	unattended sessions either continue from the point of error if the exception is user
	resumable, or fail fast if not."

	self logError: anException.
	self isUnattended
		ifTrue: [anException isUserResumable ifTrue: [anException resume] ifFalse: [self primQuit: -1]]
		ifFalse: 
			[| topFrame |
			topFrame := anException raisingFrame.
			topFrame process
				walkback: ([anException description] on: Error do: [:e | anException class name])
				topFrame: topFrame
				resumable: anException isResumable]!

versionInfo
	"Answer the <VersionInfo> for this session, extracted from the host executable."

	^VM versionInfo!

versionString
	"Answers a String containing the current version of the system"

	^'<1s> <2d>' expandMacrosWith: self applicationShortName with: self productVersion majorMinorPatch! !
!Tools.DevelopmentSessionManager categoriesForMethods!
advanceImageVersionMinor!operations-saving!public! !
allowDuplicate!operations-startup!public! !
appIdString!constants!public! !
applicationName!constants!public! !
applicationShortName!constants!public! !
backupOnImageSave!accessing!public! !
backupOnImageSave:!accessing!public! !
bootInfo!patching!public! !
bootInfo:!patching!public! !
canPlaySounds!accessing!public! !
closeAllHelp!operations!public! !
commandLineParser!helpers!private! !
free!public!realizing/unrealizing! !
getInstallationDirectory!helpers!private! !
imageStamp!accessing!public! !
imageStamp:!accessing!private! !
imageVersionMinor:!accessing!private! !
initialize!public! !
initializeFromSessionManager:!initializing!private! !
installationDirectory!constants!public! !
isBinaryLooseMethodInstallationAllowed!private!testing! !
isDLL!private!testing! !
isEmbedded!public!testing! !
isOAD!accessing!private!product! !
keepAlive!idling!operations-shutdown!public! !
lastSerialNumberRegistryKeyFor:!accessing!private!product! !
lastSerialNumberRegistryKeyPre61!accessing!private!product! !
logComment:!operations-logging!public! !
logError:!operations-logging!public! !
mainShellClass!constants!public! !
onExit!event handling!public! !
onQueryEndSession:!event handling!public! !
onQueryWindowsShutdown!event handling!public! !
onUnhandledWarning:!event handling!public! !
onUserBreak!event handling!private! !
open:!operations-startup!private! !
openFd:mode:!operations!private! !
openPackage:!operations-startup!private! !
openSources!operations-source files!private! !
openWorkspace:!operations-startup!private! !
openXmlFile:!operations-startup!private! !
parseCmdLineFlags!operations-startup!private! !
patchLevel!patching!public! !
patchLevel:!patching!private! !
playImageSaveSound!operations-sounds!private! !
playStartupSound!operations-sounds!private! !
popupHelpFile!constants!public! !
preStart!operations-startup!private! !
primaryStartup!operations-startup!private! !
processCommandLine!helpers!private! !
productDetails!accessing!private!product! !
productDetails:!accessing!private!product! !
productMajorVersion!accessing!product!public! !
productRegistryKey!accessing!product!public! !
productRegistryVersion!accessing!private!product! !
productVersion!accessing!product!public! !
productVersionSpecial!accessing!product!public! !
registeredSerialNumber!accessing!private!product! !
registeredSerialNumber:!accessing!private!product! !
resetPatchLevel!patching!private! !
resourcesLocatorForClass:!private! !
retire!public! !
saveImageDefault!operations-saving!private! !
saveImageTo:!operations-saving!private! !
saveSessionState!operations!public! !
sentinelName!constants!public! !
showSplash!operations!public! !
shutdown!operations-shutdown!public! !
snapshot!operations-saving!private! !
snapshot:!operations-saving!public! !
splashShellClass!constants!private! !
splashShellClass:!constants!private! !
splashShowAtStartup!accessing!public! !
splashShowAtStartup:!accessing!public! !
tertiaryStartup!operations-startup!public! !
traceStream!accessing!private! !
unhandledException:!exceptions!private! !
versionInfo!accessing-version!public! !
versionString!accessing!public! !
!

!Tools.DevelopmentSessionManager class methodsFor!

icon
	"Answer an icon for the receiver and its instances."

	^Icon fromId: '!!APPLICATION'!

imageExtension
	"Answer the suffix for an image file, We'll append the major version of Dolphin that
	should be associated with this particular image."

	^'img8'! !
!Tools.DevelopmentSessionManager class categoriesForMethods!
icon!constants!public! !
imageExtension!constants!public! !
!

