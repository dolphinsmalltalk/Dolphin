"Filed out from Dolphin Smalltalk X6"!

SmalltalkToolShell subclass: #LiveUpdate
	instanceVariableNames: 'updates status isOnline connectionIcon'
	classVariableNames: 'RestartActions'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LiveUpdate guid: (GUID fromString: '{65583D46-7DB0-4DA0-8071-38326C0D085E}')!
LiveUpdate comment: 'LiveUpdate is a <topPresenter> used by the development system to install live updates (patches) into the image.

Instance Variables:
	updates		<ListPresenter> holding <Associations> describing the updates available for this image.
	status		<TextPresenter> describing the current state of the Live Update process.
	isOnline		<boolean> indicating whether the update site can be contacted.
	connectionIcon	<ImagePresenter> holding an icon that indicates the connection state.
'!
!LiveUpdate categoriesForClass!Development!MVP-Presenters! !
!LiveUpdate methodsFor!

connect
	"Attempt to connect to the Dolphin Update site. If we are not able to do so then 
	we assume that we're not online. If successful, then download any available
	patches for this version."

	| url |
	connectionIcon value: (Icon fromId: 'LiveUpdateOff.ico').
	connectionIcon view update.
	url := self class dolphinUpdateLocation.
	
	[self connectTo: url.
	self downloadPatches: url.

	"Check for a description of a new base version of Dolphin"
	(self class urlExists: self class newVersionLocation) 
		ifTrue: [SmalltalkSystem current openUrl: self class newVersionLocation]] 
			on: OperationAborted
			do: [:ex | ].
	^isOnline!

connectTo: aString 
	self status: 'Connecting to ' , aString.

	"Prompt to go online"
	isOnline := WinInetLibrary default 
				internetGoOnline: aString
				hwndParent: self view handle
				dwReserved: 0.
	isOnline 
		ifFalse: 
			[self status: 'Could not connect to ' , aString.
			MessageBox 
				notify: 'The Dolphin Live Update facility requires a connection to the Internet. 
Either a connection is not available or the Dolphin Update site could not be contacted. 
Please verify that your computer is online and press the Connect button to try again.'
				caption: 'Dolphin Live Update: Update site could not be contacted'.
			OperationAborted signal].
	connectionIcon value: self icon!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	updates := self add: ListPresenter new name: 'updates'.
	status := self add: TextPresenter new name: 'status'.
	connectionIcon := self add: ImagePresenter new name: 'connectionIcon'.

!

defaultHelpId
	^10893!

downloadPatches: aString 
	| patches |
	self status: 'Downloading updates from ' , aString.
	patches := self class availablePatches.
	patches isNil ifTrue: [^self].
	patches isEmpty 
		ifTrue: [self status: 'There are no new updates available for this version of Dolphin.']
		ifFalse: 
			[self status: 'Downloaded updates from ' 
						, (self class dolphinUpdateLocation)].
	"The patches must be in ascending order"
	updates list: patches associations asSortedCollection!

fileOpen
	"Open a workspace displying the currently selected patch."

	self model newWorkspace workspace text: updates selection value!

hasSelectedPatch
	"Private - Answer true if we have a patch selected"

	^updates hasSelection!

help
	"Display any available help for the currently selected patch."

	self hasSelectedPatch 
		ifTrue: [ SmalltalkSystem current openUrl: (self class helpLocationFor: updates selection key) ]
		ifFalse: [ super help ]!

initialize
	"Private - Initialize the receiver"

	super initialize.
	isOnline := false!

install
	"Installs the currently selected patch and all pre-requisites."

	| patches progress selectedPatches |
	patches := updates model.
	selectedPatches := patches copyFrom: 1 to: updates selectionByIndex.
	progress := ProgressDialog operation: 
					[:progressIndicator | 
					"Start off at 10%"
					progressIndicator value: 10.
					[self installPatches: selectedPatches notifying: progressIndicator] on: NotTrustedError
						do: [:x | progressIndicator exit]].
	progress showModal.

	"Remove installed patches from the list"
	updates model list: (patches select: [:each | each key > self model patchLevel]).

	"Reset temporary trust store"
	NotSignedCertificate new beNotTrusted!

installPatch: aString 
	| stream |
	stream := aString readStream.
	"Skip first comment chunk from patch"
	(ChunkSourceFiler on: stream) nextChunk.
	self class sourceManager secureFileInFrom: stream!

installPatches: aSequenceableCollection notifying: aProgressDialog 
	| unchanged |
	unchanged := Package manager allSourceObjects reject: [:each | each isChanged].
	
	[aSequenceableCollection keysAndValuesDo: 
			[:i :each | 
			aProgressDialog text: 'Installing ' , (self class patchFilenameFor: each key).
			self installPatch: each value.
			aProgressDialog value: i / aSequenceableCollection size * 100.
			Processor sleep: 100]] 
			ensure: [unchanged do: [:each | each isChanged: false]]!

isOnline
	"Answer true if the receiver can contact the Dolphin Update site"
	
	^isOnline

!

onViewOpened
	"Received when the receiver's view is been connected. "

	super onViewOpened.
	self view show.
	[self connect] postToMessageQueue!

queryCommand: query
	"Private - Enters details about a potential command for the receiver into the 
	<CommandQuery>,  query."

	| cmd |
	cmd := query commandSymbol.

	(#(install fileOpen fileSave) includes: cmd) ifTrue: [
		query isEnabled: self hasSelectedPatch.
		^true].

	(#(connect) includes: cmd) ifTrue: [
		query isEnabled: self isOnline not.
		^true].

	^super queryCommand: query
!

status: aString
	"Report aString as the current status"

	status value: aString.
	self view update.! !
!LiveUpdate categoriesFor: #connect!commands!public! !
!LiveUpdate categoriesFor: #connectTo:!helpers!private! !
!LiveUpdate categoriesFor: #createComponents!initializing!public! !
!LiveUpdate categoriesFor: #defaultHelpId!public! !
!LiveUpdate categoriesFor: #downloadPatches:!helpers!private! !
!LiveUpdate categoriesFor: #fileOpen!commands!public! !
!LiveUpdate categoriesFor: #hasSelectedPatch!private!testing! !
!LiveUpdate categoriesFor: #help!commands!public! !
!LiveUpdate categoriesFor: #initialize!initializing!private! !
!LiveUpdate categoriesFor: #install!commands!public! !
!LiveUpdate categoriesFor: #installPatch:!helpers!private! !
!LiveUpdate categoriesFor: #installPatches:notifying:!helpers!public! !
!LiveUpdate categoriesFor: #isOnline!public!testing! !
!LiveUpdate categoriesFor: #onViewOpened!event handling!public! !
!LiveUpdate categoriesFor: #queryCommand:!commands!private! !
!LiveUpdate categoriesFor: #status:!accessing!public! !

!LiveUpdate class methodsFor!

availablePatches
	"Answer a LookupTable of the available patches for this base version of dolphin,
	taking into account the patches that have already been applied. If the user cancels the
	operation then answer nil."

	| patches level progress |
	patches := LookupTable new.
	level := SmalltalkSystem current patchLevel.
	progress := ProgressDialog create: ProgressDialog defaultView
				operation: 
					[:progressIndicator | 
					
					[| thisPatch |
					level := level + 1.
					progressIndicator value: level % 3 / 3 * 100.
					progress text: 'Attempting download of ' , (self patchFilenameFor: level).
					thisPatch := self patchFor: level.
					thisPatch notNil ifTrue: [patches at: level put: thisPatch].
					Processor sleep: 100.
					thisPatch notNil] 
							whileTrue.
					patches].
	^progress showModal!

backupFile: aString forPatchLevel: anInteger 
	| dir backupName |
	dir := File splitPathFrom: aString.
	backupName := File change: aString
				extension: ('PrePL<1p>.<2s>' expandMacrosWith: anInteger with: (File splitExtensionFrom: aString)).
	File copy: aString to: backupName.
	^dir!

baseVersion
	"Private - Answer the base version for which patches should be applied"

	^SessionManager current productVersion!

buildOfBinary: path 
	| build lib |
	lib := ExternalLibrary open: path.
	build := VMLibrary default versionInfo fixedInfo dwFileVersionLS lowWord.
	lib close.
	build.
	^lib!

deleteOnRestart: pathString 
	self queueRestartAction: 
			[Notification signal: ('Deleting <1p>...' expandMacrosWith: pathString).
			File delete: pathString]!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Dolphin Live Update'!

dolphinExePath
	^ExternalLibrary moduleFileName: nil!

dolphinUpdateLocation
	"Private - Answer the URL for the live update patches

	self dolphinUpdateLocation
"

	^'<1s>/Lib/Update/Dolphin/<2p>/<3s>' 
		expandMacrosWith: self dolphinUpdateSite
		with: self baseVersion
		with: SessionManager current applicationShortName!

dolphinUpdateSite
	"Private - Answer the site URL for the live update patches"
	
	^SessionManager current objectArtsUrl

!

download: url to: pathString 
	| downloadStream tempPath streamClass tempStream |
	streamClass := Smalltalk at: #IStream ifAbsent: [^nil].
	downloadStream := streamClass 
				onURL: url.
	tempPath := File change: pathString extension: 'bin'.
	tempStream := FileStream write: tempPath.
	[downloadStream atEnd] whileFalse: [tempStream nextPutAll: (downloadStream nextAvailable: 2048)].
	tempStream close.
	downloadStream free.
	^tempPath!

helpFilenameFor: anIntegerPatchLevel
	"Private - Answer the help filename for anIntegerPatchLevel"

	^'PL', anIntegerPatchLevel displayString, '.htm'!

helpLocationFor: anIntegerPatchLevel
	"Private - Answer the full help URL for anIntegerPatchLevel"

	^self patchesLocation , (self helpFilenameFor: anIntegerPatchLevel)!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver.

		self initialize.
	"

	Smalltalk developmentSystem
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self.
	RestartActions := OrderedCollection new.
!

installPackage: packagePath 
	"Private - Installs a package with <readableString> packagePath from the patch site into this image"

	| packageName |
	packageName := File splitStemFrom: packagePath.
	(Package manager includesPackageNamed: packageName) 
		ifFalse: 
			[| localPath sourcePath package |
			sourcePath := File 
						composePath: LiveUpdate patchesLocation
						stem: packageName
						extension: 'bin'.
			localPath := URLMonLibrary default urlDownloadToCacheFile: sourcePath.
			package := Package manager install: localPath.
			Package manager renamePackage: package to: packagePath]!

installPathOfSystemComponent: progIdString 
	| clsid classesRoot |
	classesRoot := RegKey classesRoot: #read.
	clsid := ((classesRoot at: progIdString) at: 'CLSID') value.
	^((RegKey classesRoot: #read) at: ('CLSID\<1s>\InProcServer32' expandMacrosWith: clsid)) value!

newVersionLocation
	"Private - Answer the URL for the description of a newer version of Dolphin"

	^self patchesLocation , 'NewVersion.htm?', TimeStamp current asSeconds displayString!

onSessionStarted
	self processRestartActions!

patchesLocation
	"Private - Answer the URL for the live update patches for this version of Dolphin"

	^self dolphinUpdateLocation, '/'!

patchFilenameFor: anIntegerPatchLevel
	"Private - Answer the filename for anIntegerPatchLevel"

	^'PL', anIntegerPatchLevel displayString, '.st'!

patchFor: anIntegerPatchLevel
	"Private - Answer the available patch (if any) for anIntegerPatchLevel"

	^[self urlContents: (self patchLocationFor:  anIntegerPatchLevel)] on: Error do: [:x | nil]

!

patchLocationFor: anIntegerPatchLevel
	"Private - Answer the full patch URL for anIntegerPatchLevel"

	^self patchesLocation , (self patchFilenameFor: anIntegerPatchLevel), '?', TimeStamp current asSeconds displayString!

processRestartActions
	| actions |
	RestartActions isEmpty ifTrue: [^self].
	actions := RestartActions.
	RestartActions := OrderedCollection new.
	actions do: [:each | [each value] on: Error do: [:ex | ex toTrace: 5]]!

queueRestartAction: aNiladicValuable
	RestartActions addLast: aNiladicValuable!

renameOnReboot: fromPath to: toPath 
	KernelLibrary default 
		moveFileEx: fromPath
		lpNewFileName: toPath
		dwFlags: 5!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 721158 ##(Smalltalk.SystemColor)  31 0 39 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 416 852230 ##(Smalltalk.FramingLayout)  234 240 98 18 410 8 ##(Smalltalk.ListView)  98 30 0 416 98 2 8 1140953165 1025 688 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1114638 ##(Smalltalk.STBSingletonProxy)  8 ##(Smalltalk.SearchPolicy)  8 #identity 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 4 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #install 8 '&Install...' 1 1 0 0 0 994 1 1026 8 #fileOpen 8 '&Open...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 994 1 1026 8 #help 8 '&Help...' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 688 0 8 4294904469 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  4 1 170 8 'Dolphin List Presenter' 8 'BasicListAbstract' 8 'doIt' 8 '[:x | ''Patch Level '', x displayString ]' 8 #[32 105 29 17 159 178 106] 8 'Patch Level ' 8 #displayString 8 #, 1296 7 257 0 1282 0 0 1314 4 1 8 ##(Smalltalk.MessageSend)  8 'doIt' 8 '[:x | LiveUpdate icon imageIndex ]' 8 #[32 105 45 159 160 106] 721414 ##(Smalltalk.Association)  8 #LiveUpdate 8 ##(Smalltalk.LiveUpdate)  8 #icon 8 #imageIndex 1488 7 257 0 842 8 ##(Smalltalk.IconImageManager)  8 #current 0 0 0 0 0 0 202 208 98 2 920646 5 ##(Smalltalk.ListViewColumn)  8 'Available Patches' 201 8 #left 1282 0 0 1314 5 1 1280 8 'doIt' 8 '[:x | ''Patch Level '', x key displayString ]' 8 #[33 105 29 17 159 160 179 106] 8 'Patch Level ' 8 #key 1456 1472 1824 7 257 0 8 ##(Smalltalk.SortedCollection)  0 0 688 0 1 0 0 1762 8 'Comment' 583 1808 1282 0 0 1314 3 1 1344 8 'doIt' 8 '[:x | x value lines first ]' 8 #[31 105 17 142 158 159 106] 8 #lines 8 #first 1984 7 257 0 1936 0 0 688 0 3 0 0 8 #report 816 0 131169 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 3 1522 8 #createAt:extent: 98 2 594 21 461 594 791 271 688 1522 8 #contextMenu: 98 1 960 688 1522 8 #text: 98 1 8 'Available Patches' 688 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 230 0 0 0 149 1 0 0 109 1 0 0] 98 0 594 193 193 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  842 8 ##(Smalltalk.FramingCalculation)  8 #fixedParentLeft 21 842 2496 8 #fixedParentRight -183 842 2496 8 #fixedParentTop 461 842 2496 8 #fixedParentBottom -81 410 8 ##(Smalltalk.StaticText)  98 16 0 416 98 2 8 1140850944 1 2624 0 0 0 7 0 514 0 16 546 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 594 193 193 0 2624 0 8 4294905149 852486 ##(Smalltalk.NullConverter)  0 0 0 2114 202 208 98 2 1522 2192 98 2 594 21 321 594 841 101 2624 1522 2320 98 1 8 'Once installed into an image, patches cannot be removed. For this reason, we recommend that you backup your image before applying any patches.

' 2624 2370 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 160 0 0 0 174 1 0 0 210 0 0 0] 98 0 2432 0 27 2450 2480 21 842 2496 8 #fixedViewLeft 841 2560 321 842 2496 8 #fixedViewTop 101 410 2640 98 16 0 416 98 2 8 1140850944 262145 3104 0 0 0 7 0 514 0 16 546 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 594 193 193 0 3104 0 8 4294905149 2786 0 0 0 2114 202 208 98 1 1522 2192 98 2 594 21 757 594 951 41 3104 2370 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 122 1 0 0 229 1 0 0 142 1 0 0] 98 0 2432 0 27 2450 2480 21 2528 -23 2592 -55 2592 -15 410 8 ##(Smalltalk.PushButton)  98 17 0 416 98 2 8 1140924416 1 3440 0 898 928 0 7 0 0 0 3440 0 8 4294904663 1026 1056 8 '&Install' 1 1 0 0 32 2114 202 208 98 3 1522 2192 98 2 594 831 561 594 141 51 3440 1522 8 #isEnabled: 98 1 32 3440 1522 2320 98 1 8 '&Install' 3440 2370 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 159 1 0 0 24 1 0 0 229 1 0 0 49 1 0 0] 98 0 2432 0 27 2450 2528 -163 3040 141 2560 561 3072 51 410 3456 98 17 0 416 98 2 8 1140924416 1 3856 0 898 928 0 7 0 0 0 3856 0 8 4294904663 1026 1216 8 '&Help' 1 1 0 0 32 2114 202 208 98 3 1522 2192 98 2 594 831 651 594 141 51 3856 1522 3712 98 1 32 3856 1522 2320 98 1 8 '&Help' 3856 2370 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 159 1 0 0 69 1 0 0 229 1 0 0 94 1 0 0] 98 0 2432 0 27 2450 2528 -163 3040 141 2560 651 3072 51 410 2640 98 16 0 416 98 2 8 1140850944 1 4240 0 0 0 7 0 0 0 4240 0 8 4294905149 2786 0 0 0 2114 202 208 98 2 1522 2192 98 2 594 21 111 594 841 201 4240 1522 2320 98 1 8 'Dolphin Live Update determines what updates are available for your system. You must be connected to the Internet to make use of this facility. Once connected to the Live Update site, the available updates will be displayed in the list below. 

To install a patch, select it in the list and click the Install button. This will also install any pre-requisites that are necessary for the chosen patch to work correctly. To find out more about the contents of a patch, select it and click the Help button. 
' 4240 2370 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 55 0 0 0 174 1 0 0 155 0 0 0] 98 0 2432 0 27 2450 2480 21 3040 841 2560 111 3072 201 410 2640 98 16 0 416 98 2 8 1140850944 1 4560 0 0 0 7 0 514 0 16 546 8 #[227 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 255 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 2752 0 4560 786694 ##(Smalltalk.IndexedColor)  33554437 8 4294905149 2786 0 0 0 2114 202 208 98 2 1522 2192 98 2 594 21 21 594 481 61 4560 1522 2320 98 1 8 'Live Update!!' 4560 2370 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 250 0 0 0 40 0 0 0] 98 0 2432 0 27 2450 2480 21 3040 481 2560 21 3072 61 410 3456 98 17 0 416 98 2 8 1140924416 1 4960 0 898 928 0 7 0 0 0 4960 0 8 4294904663 1026 8 #connect 8 '&Connect' 1 1 0 0 32 2114 202 208 98 3 1522 2192 98 2 594 831 471 594 141 51 4960 1522 3712 98 1 32 4960 1522 2320 98 1 8 '&Connect' 4960 2370 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 159 1 0 0 235 0 0 0 229 1 0 0 4 1 0 0] 98 0 2432 0 27 2450 2528 -163 3040 141 2560 471 3072 51 410 8 ##(Smalltalk.ImageView)  98 21 0 416 98 2 8 1140850944 1 5360 721990 2 ##(Smalltalk.ValueHolder)  0 32 1376774 ##(Smalltalk.PluggableSearchPolicy)  459270 ##(Smalltalk.Message)  8 #= 98 0 5506 8 #hash 98 0 263494 3 ##(Smalltalk.Icon)  0 16 842 8 ##(Smalltalk.ImageRelativeFileLocator)  1712 8 'LiveUpdate.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 482 31 0 7 0 0 0 5360 0 8 4294904615 2786 0 0 0 5632 8 #scaleToFit 1 0 0 2114 202 208 98 1 1522 2192 98 2 594 881 11 594 91 91 5360 2370 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 184 1 0 0 5 0 0 0 229 1 0 0 50 0 0 0] 98 0 2432 0 27 2450 842 2496 8 #fixedViewRight -89 2528 -23 2560 11 3072 91 234 256 98 6 688 8 'updates' 3104 8 'status' 5360 8 'connectionIcon' 0 0 0 0 0 1 0 0 0 594 1011 801 1 0 0 2114 202 208 98 3 1522 2192 98 2 594 6399 21 594 1011 881 416 1522 2320 98 1 8 'Live Update!!' 416 1522 8 #menuBar: 98 1 0 416 2370 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 12 0 0 10 0 0 0 120 14 0 0 194 1 0 0] 98 9 5360 688 3104 4960 3440 3856 4240 4560 2624 2432 0 27 )!

toolsFolderHelpId
	^10591!

twoPhaseRename: fromPath to: toPath 
	self queueRestartAction: 
			[Notification signal: ('Copying <1p> to <2p>...' expandMacrosWith: fromPath with: toPath).
			File copy: fromPath to: toPath.
			self deleteOnRestart: fromPath]!

uninitialize
	"Private - Un-register the system tools folder icon for the receiver to allow clean
	removal of this class from the system.
		self uninitialize
	"

	Smalltalk developmentSystem
		removeSystemFolderIconNamed: self toolDescription;
		unregisterTool: self!

updateSharedBinary: progIdString forLevel: anInteger withBytes: aByteArray 
	| tempPath prompt formatString lib verinfo path |
	path := self installPathOfSystemComponent: progIdString.
	(self buildOfBinary: path) >= anInteger ifTrue: [^self].
	self backupFile: path forPatchLevel: anInteger.
	tempPath := File change: path extension: 'bin'.
	(FileStream write: tempPath text: false)
		nextPutAll: aByteArray;
		close.
	formatString := OSVERSIONINFO current isWin9X 
				ifTrue: 
					['<n>A new binary (<3s>, version  <4s>), has been placed into your Dolphin installation directory to replace:<n><t><2s><n> If you wish to use this version (recommended) you must exit Dolphin, delete the old binary and rename the following file to replace it:<n><t><1s><n>']
				ifFalse: 
					[self renameOnReboot: tempPath to: path.
					'<n>A new binary (<3s>, version  <4s>), has been placed into your Dolphin installation directory to replace:<n><t><2s><n>To complete installation of this binary you must reboot your machine.<n>'].
	lib := ExternalLibrary open: tempPath.
	verinfo := lib versionInfo.
	prompt := formatString 
				expandMacrosWith: tempPath
				with: path
				with: verinfo fileDescription
				with: verinfo fileVersionString.
	lib close.
	[Notification signal: prompt] postToMessageQueue!

urlContents: aStringURL
	"Private - Answer the contents of aStringURL"

	| iStreamClass |
	iStreamClass := Smalltalk at: #IStream.
	^Cursor wait showWhile: [ (FileStream on: (iStreamClass onURL: aStringURL) text: true) contents ]
!

urlExists: aStringURL
	"Private - Answer true if aStringURL exists"

	^[ self urlContents: aStringURL. true ] on: Error do: [:x | ^false].
!

vmFilenameFor: anIntegerPatchLevel
	"Private - Answer the filename for a new VM installed by anIntegerPatchLevel"

	| vmName |
	vmName := self vmFilestem.
	^self patchesLocation, 'PL', anIntegerPatchLevel displayString, 'VM/', vmName, '.bin'!

vmFilestem
	"Private - Answer the filename stem of the VM."

	^File splitStemFrom: VMLibrary default fileName! !
!LiveUpdate class categoriesFor: #availablePatches!accessing!public! !
!LiveUpdate class categoriesFor: #backupFile:forPatchLevel:!operations!private! !
!LiveUpdate class categoriesFor: #baseVersion!accessing!private! !
!LiveUpdate class categoriesFor: #buildOfBinary:!operations!private! !
!LiveUpdate class categoriesFor: #deleteOnRestart:!operations!private! !
!LiveUpdate class categoriesFor: #displayOn:!displaying!public! !
!LiveUpdate class categoriesFor: #dolphinExePath!helpers!private! !
!LiveUpdate class categoriesFor: #dolphinUpdateLocation!accessing!private! !
!LiveUpdate class categoriesFor: #dolphinUpdateSite!accessing!private! !
!LiveUpdate class categoriesFor: #download:to:!operations!private! !
!LiveUpdate class categoriesFor: #helpFilenameFor:!accessing!private! !
!LiveUpdate class categoriesFor: #helpLocationFor:!accessing!private! !
!LiveUpdate class categoriesFor: #icon!constants!public! !
!LiveUpdate class categoriesFor: #initialize!initializing!private! !
!LiveUpdate class categoriesFor: #installPackage:!helpers!private! !
!LiveUpdate class categoriesFor: #installPathOfSystemComponent:!helpers!private! !
!LiveUpdate class categoriesFor: #newVersionLocation!accessing!private! !
!LiveUpdate class categoriesFor: #onSessionStarted!event handling!private! !
!LiveUpdate class categoriesFor: #patchesLocation!accessing!private! !
!LiveUpdate class categoriesFor: #patchFilenameFor:!accessing!private! !
!LiveUpdate class categoriesFor: #patchFor:!accessing!private! !
!LiveUpdate class categoriesFor: #patchLocationFor:!accessing!private! !
!LiveUpdate class categoriesFor: #processRestartActions!helpers!private! !
!LiveUpdate class categoriesFor: #queueRestartAction:!helpers!private! !
!LiveUpdate class categoriesFor: #renameOnReboot:to:!operations!private! !
!LiveUpdate class categoriesFor: #resource_Default_view!public!resources-views! !
!LiveUpdate class categoriesFor: #toolsFolderHelpId!public! !
!LiveUpdate class categoriesFor: #twoPhaseRename:to:!operations!private! !
!LiveUpdate class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!LiveUpdate class categoriesFor: #updateSharedBinary:forLevel:withBytes:!operations!private! !
!LiveUpdate class categoriesFor: #urlContents:!accessing!private! !
!LiveUpdate class categoriesFor: #urlExists:!accessing!private! !
!LiveUpdate class categoriesFor: #vmFilenameFor:!accessing!private! !
!LiveUpdate class categoriesFor: #vmFilestem!accessing!private! !

