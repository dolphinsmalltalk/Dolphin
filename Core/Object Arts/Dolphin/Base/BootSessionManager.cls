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

keepAlive
	"We stay alive until explicitly terminated."

	^self!

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
	"Private - Pop-up a walkback with details from the argument, anException."

	"Attempt to log the error, but don't allow it to become recursive (#logError: does not
	raise an exception if it fails)"
	| title topFrame |
	self logError: anException.
	title := [anException description] on: Error do: [:e | anException class name].
	topFrame := anException raisingFrame.

	"In a development session, we'll be wanting a walkback..."
	topFrame process 
		walkback: title
		topFrame: topFrame
		resumable: anException isResumable! !
!BootSessionManager categoriesFor: #basicTertiaryStartup!operations-startup!public! !
!BootSessionManager categoriesFor: #keepAlive!idling!public! !
!BootSessionManager categoriesFor: #main!operations-startup!public! !
!BootSessionManager categoriesFor: #onPreSaveImage!public! !
!BootSessionManager categoriesFor: #openSources!operations-source files!private! !
!BootSessionManager categoriesFor: #primaryStartup!operations-startup!private! !
!BootSessionManager categoriesFor: #productDetails!accessing!private!product! !
!BootSessionManager categoriesFor: #productDetails:!accessing!private!product! !
!BootSessionManager categoriesFor: #productVersion!accessing!product!public! !
!BootSessionManager categoriesFor: #saveImageDefault!operations-saving!public! !
!BootSessionManager categoriesFor: #saveImageTo:!operations-saving!private! !
!BootSessionManager categoriesFor: #shellClosed:!operations-startup!private! !
!BootSessionManager categoriesFor: #shellOpened:!operations-startup!private! !
!BootSessionManager categoriesFor: #shutdown!operations-shutdown!public! !
!BootSessionManager categoriesFor: #snapshot!operations-saving!private! !
!BootSessionManager categoriesFor: #startUI!operations-startup!public! !
!BootSessionManager categoriesFor: #trace:!operations-logging!public! !
!BootSessionManager categoriesFor: #unhandledException:!exceptions!private! !

!BootSessionManager class methodsFor!

imageExtension
	"Answer the suffix for an executable image file"

	^'img'! !
!BootSessionManager class categoriesFor: #imageExtension!constants!public! !

