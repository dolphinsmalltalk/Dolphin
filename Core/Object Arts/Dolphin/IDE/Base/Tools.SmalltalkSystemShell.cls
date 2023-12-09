"Filed out from Dolphin Smalltalk"!

Tools.SmalltalkToolShell
	subclass: #'Tools.SmalltalkSystemShell'
	instanceVariableNames: 'systemFolderPresenter'
	classVariableNames: 'Backcolor BackImage BackImageAlphaPercent BackImageIsTiled Default HotKey PlaySystemSounds ResetWhenInvisible Textcolor ViewMode'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.SmalltalkSystemShell guid: (Core.GUID fromString: '{87b4c6c3-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.SmalltalkSystemShell comment: 'SmalltalkSystemShell is a <SmalltalkToolShell> that implements the user interface onto theDolphin Smalltalk system folder. This an iconic daunting point for all of the installed tools, sample applications etc.

Instance Variables:
	systemFolderPresenter		<FolderPresenter> displaying the system folder hierarchy.

Class Variables:
	Default				<SmalltalkSystemShell> which is the singleton instance.
	DefaultBackcolor			<color> for the background of the folder.




'!
!Tools.SmalltalkSystemShell categoriesForClass!MVP-Presenters! !
!Tools.SmalltalkSystemShell methodsFor!

addToCommandRoute: route 
	"Update the <OrderedCollection>, path, with the receiver's contribution to the command path
	held by the <CommandPolicy>, route. Answer the next <Presenter> to visit. The receiver is
	guaranteed not to be on the command path already."

	"Implementation Note: We add folder presenter to the command route so that the navigation
	buttons and view options are enabled even whent the search field has focus."

	| next |
	next := super addToCommandRoute: route.
	systemFolderPresenter addToCommandRoute: route.
	^next!

applyOptions
	"Private - Apply the class options to the receiver"

	super applyOptions.
	self folderView
		backcolorChanged;
		backImage: self class backImage;
		backImageIsTiled: self class backImageIsTiled;
		backImageAlphaPercent: self class backImageAlphaPercent;
		forecolor: self class textcolor;
		viewMode: self class viewMode!

browseCompilationFailures
	"Open a method browser on all methods in the system which have failed compilation (i.e.
	which are instances of CompileFailedMethod)."

	self developmentSystem browseCompilationFailuresIn: self searchEnvironment!

browseCompilationIssues
	"Open a method browser on all methods in the system which have failed compilation (i.e.
	which are instances of CompileFailedMethod)."

	self developmentSystem browseCompilationIssuesIn: self searchEnvironment!

browseDeprecatedMethods
	self browseMethodCategory: '*-deprecated'!

browseMessageDefinitions
	"Prompt for a selector and open a method browser displaying the implementors of that selector."

	self model browseMessageDefinitionsIn: self searchEnvironment!

browseMessageReferences
	"Prompt for a selector and open a method browser displaying the references to that
	selector, using the first word of the clipboard text as the initial suggestion."

	self model browseMessageReferencesIn: self searchEnvironment!

browseMethodCategory: aMethodCategory
	self model browseMethodCategories: {aMethodCategory} in: self searchEnvironment!

browseNotYetImplemented
	self browseMethodCategory: '*-not yet implemented'!

browseUnclassifiedMethods
	self browseMethodCategory: '*-unclassified'!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	systemFolderPresenter := (self
				add: (FolderPresenter new beSorted: [:a :b | a description < b description])
				name: 'systemFolder')
				openBlock: [:presenter :item | item openIn: presenter];
				yourself!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	self 
		when: #closeRequested:
		send: #onCloseRequested:
		to: self.
	SessionManager current 
		when: #imageSaveCompleted
		send: #updateCaption
		to: self!

defaultHelpId
	^10626!

folderView
	^systemFolderPresenter view!

hasSelection
	^systemFolderPresenter hasSelection!

hasToolSelected
	^systemFolderPresenter hasSelection and: [systemFolderPresenter selection tool notNil]!

initialize
	"Private - Initialize the receiver. 
	Ensure the Transcript is available"

	super initialize.
	TranscriptShell current!

inspectSystemOptions
	"Open a <PropertyInspector> on the system options."

	^(self model inspectSystemOptions)
		selectionOrNil: self class;
		yourself!

model: aSmalltalkSystem
	"Connects the receiver to aSmalltalkSystem.
	The systemFolderPresenter displays the contents of the #systemFolder
	aspect of the model"

	super model: aSmalltalkSystem.
	systemFolderPresenter model: aSmalltalkSystem systemFolder!

onCloseRequested: aBooleanValue
	"Private - Request to shut the session down. If the request is unacceptable then
	set the value of the out parameter, aBooleanValue to false"

	self == self class default ifTrue: [
		"This is the root system shell closing then shut down system"
		self model smalltalkExit.
		aBooleanValue value: false ]!

onHotKey: anInteger 
	anInteger = 1000 ifTrue: [self view show; beForeground].
	super onHotKey: anInteger!

onPositionChanged: aPositionEvent
	"Private - Handler for a change in position (resize or move) of the receiver's view."

	(aPositionEvent isResize and: [aPositionEvent  isVisibilityChange not]) ifTrue: [self rememberThisSize].
	^super onPositionChanged: aPositionEvent!

onViewDestroyed
	"Private - Handler for view final view destruction. This is sent on receipt of WM_NCDESTROY,
	and is expected to be the last communication from Windows. There is nothing
	more we can do to save the patient. No event is triggered."

	SessionManager current removeEventsTriggeredFor: self.
	self unregisterHotKey.
	self == Default ifTrue: [Default := nil].
	super onViewDestroyed!

onViewModeChanged
	"Private - Event handler for view mode changed. Save the new mode to the user preferences"

	self class viewMode: systemFolderPresenter view viewMode!

onViewOpened
	"Private - Received when the receiver's view is been connected. "

	| toolbar |
	super onViewOpened.
	systemFolderPresenter selectionByIndex: 1.
	toolbar := self view viewNamed: 'systemShellTools'.
	toolbar presenterConnectionPoint 
		when: #dropDown:
		send: #onDropDown:
		to: systemFolderPresenter view.
	systemFolderPresenter view 
		when: #viewModeChanged
		send: #onViewModeChanged
		to: self!

onViewStateRestored
	super onViewStateRestored.
	self registerHotKey!

properties
	<commandQuery: #hasToolSelected>
	^systemFolderPresenter selection tool inspect!

registerHotKey
	| codes flags modifiers |
	HotKey isNil ifTrue: [^self].
	codes := AcceleratorTable splitKeyCode: HotKey.
	flags := codes last.
	modifiers := 0.
	(flags allMask: FALT) ifTrue: [modifiers := modifiers bitOr: MOD_ALT].
	(flags allMask: FCONTROL) ifTrue: [modifiers := modifiers bitOr: MOD_CONTROL].
	(flags allMask: FSHIFT) ifTrue: [modifiers := modifiers bitOr: MOD_SHIFT].
	self view 
		registerHotKeyId: 1000
		modifiers: modifiers
		vkey: codes first!

resetSelection
	"Private - Reset any selection in the receiver."

	systemFolderPresenter selectionByIndex: 1
!

resetWhenInvisible
	"Answer whether the SystemFolder should be reset (i.e. a new launcher opened) when there are no visible windows.
	Note that this can be triggered by virtual desktop managers such as MSVDM, as these work by either hiding or moving
	the windows entirely off screen. The system detects this as having no visible windows, and therefore "!

searchEnvironment
	^self model browserEnvironment!

systemFolderPresenter
	^systemFolderPresenter!

unregisterHotKey
	self view unregisterHotKeyId: 1000
!

updateCaption
	"The receiver has changed in such a way that the caption may need to be refreshed.
	Do this here"

	| sesh title |
	sesh := SessionManager current.
	title := String writeStream.
	title
		nextPutAll: sesh applicationName;
		nextPutAll: ' - ';
		nextPutAll: (File splitFilenameFrom: sesh imageFileName).
	SessionManager current bootInfo
		ifNotNil: 
			[:bootInfo |
			title
				nextPutAll: ' - ';
				display: bootInfo].
	self caption: title contents!

whatsThis
	<commandQuery: #hasSelection>
	systemFolderPresenter selection whatsThis! !
!Tools.SmalltalkSystemShell categoriesForMethods!
addToCommandRoute:!commands!public! !
applyOptions!operations!options!private! !
browseCompilationFailures!browsing!commands!public! !
browseCompilationIssues!commands!public! !
browseDeprecatedMethods!browsing!commands!public! !
browseMessageDefinitions!browsing!commands!public! !
browseMessageReferences!browsing!commands!public! !
browseMethodCategory:!browsing!private! !
browseNotYetImplemented!browsing!commands!public! !
browseUnclassifiedMethods!browsing!commands!public! !
createComponents!**auto generated**!initializing!public! !
createSchematicWiring!initializing!public! !
defaultHelpId!constants!public! !
folderView!accessing!private! !
hasSelection!commands!private! !
hasToolSelected!commands!private! !
initialize!initializing!private! !
inspectSystemOptions!commands!public! !
model:!accessing!public! !
onCloseRequested:!event handling!private! !
onHotKey:!event handling!private! !
onPositionChanged:!event handling!private! !
onViewDestroyed!event handling!private! !
onViewModeChanged!event handling!private! !
onViewOpened!event handling!private! !
onViewStateRestored!event handling!private! !
properties!commands!public! !
registerHotKey!helpers!private! !
resetSelection!event handling!private! !
resetWhenInvisible!options!public! !
searchEnvironment!commands!public! !
systemFolderPresenter!accessing!private! !
unregisterHotKey!helpers!private! !
updateCaption!public!updating! !
whatsThis!commands!public! !
!

!Tools.SmalltalkSystemShell class methodsFor!

applyOptions
	self primAllSubinstances do: [:each | each applyOptions]!

backcolor
	"Answer the default background to use for instances of the receiver"

	self ensureOptionsLoaded.
	^Backcolor actualColor!

backcolor: aColor
	"Set the background colour to use for instances of the receiver (and anything else using the #smalltalkSystem theme colour)."

	self backcolor = aColor ifTrue: [^self].
	Backcolor actualColor: (aColor ifNil: [self defaultBackcolor]).
	self persistOptions
		ifTrue: [self primAllSubinstances do: [:each | each folderView backcolorChanged]]!

backImage
	"Answe the background image to use for instances of the receiver"

	self ensureOptionsLoaded.
	^BackImage!

backImage: aBitmapOrNil
	"Set the background image to use for instances of the receiver"

	self backImage = aBitmapOrNil ifTrue: [^self].
	BackImage := aBitmapOrNil.
	self persistOptions
		ifTrue: [self primAllSubinstances do: [:each | each folderView backImage: aBitmapOrNil]]!

backImageAlphaPercent
	"Answer the background image alpha for instances of the receiver"

	self ensureOptionsLoaded.
	^BackImageAlphaPercent!

backImageAlphaPercent: anInteger
	"Set the background image alpha for instances of the receiver"

	self backImageAlphaPercent = anInteger ifTrue: [^self].
	BackImageAlphaPercent := anInteger.
	self persistOptions.
	self persistOptions
		ifTrue: [self primAllSubinstances do: [:each | each folderView backImageAlphaPercent: anInteger]]!

backImageIsTiled
	"Answer the tiling mode to use for the background image of instances of the receiver"

	self ensureOptionsLoaded.
	^BackImageIsTiled!

backImageIsTiled: aBoolean
	"Set the tiling mode to use for the background image of instances of the receiver"

	self backImageIsTiled == aBoolean ifTrue: [^self].
	BackImageIsTiled := aBoolean.
	self persistOptions
		ifTrue: [self primAllSubinstances do: [:each | each folderView backImageIsTiled: aBoolean]]!

default
	"Answer the default instance of the receiver

	SmalltalkSystemShell default
"

	Default isNil ifTrue: [Default := self show].
	^Default!

defaultBackcolor
	"Private - Answer the default background to use for instances of the receiver"

	^Color seaGreen!

defaultBackImage
	^nil!

defaultTextcolor
	^Color brightness: 243/255!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'System Folder'!

firstReset
	"Private - Reset the class for first use. 
	Force the creation of an new default instance of the receiver
	
	self firstReset
	"

	self reset.
	SmalltalkSystem current helpContents!

free
	"Close and release the current system shell (e.g. to create a runtime image).
	Also close the associated Transcript"

	TranscriptShell free.
	Default notNil
		ifTrue: 
			[Default view destroy.
			Default := nil]!

hotKey
	"Answer the hot key that can be used to bring the system shell into the foreground even when
	minimised or if another application is active."

	^HotKey ?? 0!

hotKey: anInteger 
	"Set the hot key that can be used to bring the system shell into the foreground even when
	minimised or if another application is active."

	| open |
	self hotKey = anInteger ifTrue: [^self].
	open := Default notNil and: [Default isOpen].
	open ifTrue: [Default unregisterHotKey].
	HotKey := anInteger = 0 ifFalse: [anInteger].
	open ifTrue: [Default registerHotKey].
	self persistOptions!

icon
	"Answers an Icon that can be used to represent this class"

	^SmalltalkSystem current icon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	SmalltalkSystem current
		registerTool: self;
		systemFolderClass: self.
	Backcolor := ThemeColor addNamed: #smalltalkSystem color: self defaultBackcolor!

onNoVisibleWindows
	"The system has detected that there are no visible windows. If so configured, open a new
	launcher. This is off by default because certain virtual desktop managers may otherwise
	cause the launcher to be reset each time the user switches to a new desktop, causing the
	launcher to appear to follow the user around between desktops."

	self resetWhenInvisible ifTrue: [self reset]!

onStartup
	"Private - The development system is starting, perform initialization actions.
	Sent after windows are restored."

	"Cause the desktop icon title font to be picked up correctly"

	SmalltalkSystem current defaultFont isNil ifTrue: [SmalltalkSystem current defaultFont: nil].

	"Update the SmalltalkSystemShell caption to show current image file name. This
	may have changed if the .img/.exe has been copied outside of Dolphin.
	Have to perform this after windows have been recreated or else they
	will just show the caption when the image was saved."
	self default updateCaption!

playSystemSounds
	"Answer true if the IDE sounds are turned on"

	self ensureOptionsLoaded.
	^PlaySystemSounds
		
!

playSystemSounds: aBoolean
	"Sets wherher the IDE sounds are turned on"

	self playSystemSounds == aBoolean ifTrue: [^self].
	PlaySystemSounds := aBoolean.
	self persistOptions
		
!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published the receiver."

	| aspects |
	aspects := super publishedAspects.
	aspects removeKey: #reuseIfOpen.
	aspects
		add: ((Aspect color: #backcolor)
					defaultValue: self defaultBackcolor;
					yourself);
		add: ((Aspect color: #textcolor)
					defaultValue: self defaultTextcolor;
					yourself);
		add: ((Aspect bitmap: #backImage)
					defaultValue: self defaultBackImage;
					yourself);
		add: ((Aspect integer: #backImageAlphaPercent)
					defaultValue: 80;
					yourself);
		add: ((Aspect symbol: #viewMode from: #(#smallIcons #largeIcons #tileIcons #list #report #thumbnails))
					defaultValue: #thumbnails;
					yourself);
		add: ((Aspect hotkey: #hotKey)
					defaultValue: [AcceleratorTable keyCodeFromInvariantString: 'CTRL+ALT+D'];
					yourself);
		add: (Aspect boolean: #resetWhenInvisible).
	#(#playSystemSounds #backImageIsTiled)
		do: [:each | aspects add: ((Aspect boolean: each)
						defaultValue: true;
						yourself)].
	^aspects!

reset
	"Private - Reset the class. 
	Force the creation of an new default instance of the receiver

	self reset
	"

	self
		free;
		default.
!

resetWhenInvisible
	self ensureOptionsLoaded.
	^ResetWhenInvisible!

resetWhenInvisible: aBoolean 
	self resetWhenInvisible == aBoolean ifTrue: [^self].
	ResetWhenInvisible := aBoolean.
	self persistOptions!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 518 #{Graphics.ThemeColor} #toolBackground nil 5 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1140853572 131073 160 nil nil nil 517 nil nil nil 160 nil nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 8 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 272 nil nil nil 5 nil nil nil 272 582 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Image_tools nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 1 1 466 63 51 272 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 8 #() 466 193 193 nil 27 8 'imageTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 608 nil nil nil 5 nil nil nil 608 338 #{UI.Toolbar} #resource_Search_tools nil 370 50 1 418 #createAt:extent: 50 2 466 615 1 466 437 51 608 514 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 560 576 nil 27 8 'searchTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 832 nil nil nil 5 nil nil nil 832 338 #{UI.Toolbar} #resource_Smalltalk_tools nil 370 50 1 418 #createAt:extent: 50 2 466 63 1 466 553 51 832 514 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 560 576 nil 27 8 'smalltalkTools' 18 #{UI.Toolbar} 50 28 nil 160 50 2 8 1140853572 65 1056 nil nil nil 517 nil nil nil 1056 nil nil 226 #{Core.IdentityDictionary} 560 nil nil nil nil 50 6 1094 1 #{UI.ToolbarIconButton} 1056 1 1350 4 #{UI.CommandDescription} #up 8 'Up' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'FolderUp.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil 1154 1056 1 1186 #historyBack 8 'Back' 1 1 1234 nil true 1266 8 'HistoryBack.ico' 1328 65541 nil nil 1154 1056 1 1186 #historyForward 8 'Forward' 1 1 1234 nil true 1266 8 'HistoryForward.ico' 1328 65541 nil nil 582 1 #{UI.ToolbarSeparator} 1056 1 1154 1056 17 1186 #viewModeSelect 8 'Views' 1 1 1234 nil true 1266 8 'ViewMode.ico' 1328 65541 nil nil 1554 1056 1 nil nil 1 nil nil nil nil nil 370 50 1 418 #createAt:extent: 50 2 466 1051 1 466 247 51 1056 514 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 136 2 0 0 25 0 0 0] 8 #() 576 nil 29 8 'systemShellTools' nil nil nil nil 550 #{Core.OrderedCollection} 0 nil nil 1 nil 466 33 33 nil nil 838 1 #{UI.FlowLayout} 1 1 1 370 50 1 418 #createAt:extent: 50 2 466 1 1 466 1509 51 160 514 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 242 2 0 0 25 0 0 0] 50 4 272 832 608 1056 576 nil 29 nil nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2080 nil nil nil 5 nil nil nil 2080 130 1 1 nil nil nil nil 18 #{UI.ListView} 50 45 nil 2080 50 2 8 1140937036 1 2160 838 2 #{UI.ListModel} 1858 0 nil 6 #{Kernel.IdentitySearchPolicy} 98 #smalltalkSystem nil 5 2886 4 #{UI.Menu} nil true 50 3 1094 2 #{UI.CommandMenuItem} 1 1186 #properties 8 '&Properties' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 2370 1 1186 #whatsThis 8 '&What''s This?' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 2160 nil nil 518 #{Core.Message} #description 8 #() 2530 #iconImageIndex 8 #() 1350 1 #{Graphics.IconImageManager} nil nil nil 466 129 129 nil nil 1858 1 3142 5 #{UI.ListViewColumn} 8 'Column 1' 1119 #left 2530 #description 8 #() 2530 #<= 8 #() 2530 #yourself 8 #() nil 2160 2576 3 nil nil #thumbnails 8 #() 466 241 241 131169 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 370 50 2 418 #createAt:extent: 50 2 466 1 1 466 1509 713 2160 418 #text: 50 1 8 'Column 1' 2160 514 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 242 2 0 0 100 1 0 0] 8 #() 576 nil 35 226 #{Core.IdentityDictionary} 50 2 2160 8 'systemFolder' nil 370 50 1 418 #createAt:extent: 50 2 466 1 51 466 1509 713 2080 514 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 242 2 0 0 125 1 0 0] 50 1 2160 576 nil 27 226 #{Core.IdentityDictionary} 50 2 160 8 'toolbar' nil 2886 4 #{UI.MenuBar} nil true 50 5 2322 nil true 50 10 2370 1 1186 #newWorkspace 8 '&New Workspace' 9373 1 1234 nil true 1266 8 'NewWorkspace.ico' 1328 65541 nil nil nil 2370 1 1186 #openWorkspace 8 '&Open Workspace…' 9375 1 1234 nil true 1266 8 'OpenWorkspace.ico' 1328 65541 nil nil nil 2370 1 1186 #fileFileIn 8 '&File In…' 1 1 1234 nil true 1266 8 'FileIn.ico' 1328 65541 nil nil nil 2434 4097 2370 1 1186 #saveImage 8 'Sa&ve Image' 1 1 1234 nil true 1266 8 'Snapshot.ico' 1328 65541 nil nil nil 2370 1 1186 #saveImageAs 8 'Save Image As…' 1 1 nil nil nil 2370 1 1186 #compressChanges 8 '&Compress Changes…' 1 1 2374 2 #{Graphics.TextTileIcon} 8 $🗜 nil nil 6 #{Graphics.Color} #navy nil nil 1 nil nil nil nil 2370 1 1186 #compressSources 8 'Co&mpress Sources…' 1 1 nil nil nil 2434 4097 2370 1 1186 #smalltalkExit 8 'E&xit Dolphin' 1 1 1234 nil true 1266 8 'PowerSwitch.ico' 1328 65541 nil nil nil 8 '&File' nil 134217729 nil nil nil nil nil 2322 nil true 50 12 2370 1 1186 #browseHierarchy 8 '&Classes' 1 1 1234 nil true 1266 8 'ClassBrowserShell.ico' 1328 65541 nil nil nil 2370 1 1186 #browsePackages 8 '&Packages' 1 1 1234 nil true 1266 8 'Package.ico' 1328 65541 nil nil nil 2370 1 1186 #browseProtocols 8 'Pr&otocols' 1 1 1234 nil true 1266 8 'MethodProtocol.ico' 1328 65541 nil nil nil 2370 1 1186 #browseResources 8 '&Resources' 1 1 1234 nil true 1266 8 'ResourceBrowser.ico' 1328 65541 nil nil nil 2370 1 1186 #browseSystem 8 'S&ystem' 1 1 1234 nil true 1266 8 'SystemBrowserShell.ico' 1328 65541 nil nil nil 2434 4097 2370 1 1186 #browseMessageDefinitions 8 'All &Definitions Of…' 1 1 nil nil nil 2370 1 1186 #browseMessageReferences 8 'All Re&ferences To…' 1 1 nil nil nil 2370 1 1186 2530 #browseReferencesToGlobal: 50 1 8 '' 8 'References to Global…' 1 1 nil nil nil 2370 1 1186 #browseContainingText 8 'Containing &Text…' 1 1 1234 nil true 1266 8 'Find.ico' 1328 65541 nil nil nil 2370 1 1186 #browseAllUnimplementedSelectors 8 'All &Unimplemented' 1 1 nil nil nil 2322 nil true 50 5 2370 1 1186 #browseCompilationFailures 8 '&Compilation Failures' 1 1 1234 nil true 1266 8 'CompileFailedMethod.ico' 1328 65541 nil nil nil 2370 1 1186 #browseDeprecatedMethods 8 '&Deprecated' 1 1 1234 nil true 518 #{Graphics.IconFromSystemInitializer} nil 65031 nil nil 2370 1 1186 #browseNotYetImplemented 8 '&Not Yet Implemented' 1 1 nil nil nil 2370 1 1186 #browseUnclassifiedMethods 8 '&Unclassified' 1 1 nil nil nil 2370 1 1186 #browseMethodCategory 8 '&Other…' 1 1 nil nil nil 8 'Method Cate&gory' nil 134217729 1234 nil true 1266 8 'Category.ico' 1328 65541 nil nil nil nil nil 8 '&Browse' nil 134217729 nil nil nil nil nil 2322 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil nil nil nil 2322 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil nil nil nil 2322 nil true 50 15 2370 1 1186 #helpContents 8 '&Contents' 1025 1 1234 nil true 1266 8 'Help.ico' 1328 65541 nil nil nil 2370 1 1186 #help 8 'On this &Tool' 1249 1 nil nil nil 2370 1 1186 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 2434 4097 2370 1 1186 #learnSmalltalk 8 'Learn Smalltalk' 1 1 3858 8 $🎓 nil 3906 #orchid 3906 #white nil nil 1 nil nil nil nil 2434 4097 2370 1 1186 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 2370 1 1186 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 2370 1 1186 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 2434 4097 2370 1 1186 #dolphinHomePage 8 'Dolphin Homepage' 1 1 1234 nil true 1266 8 '!!APPLICATION' 1328 65541 nil nil nil 2370 1 1186 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 2370 1 1186 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 2434 4097 2370 1 1186 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 3858 8 $🐬 nil nil 3906 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil 466 2049 2049 nil 1 nil nil 370 50 2 418 #createAt:extent: 50 2 466 6143 21 466 1541 881 32 418 #text: 50 1 8 'Dolphin Smalltalk' 32 514 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 1 15 0 0 194 1 0 0] 50 2 160 2080 576 nil 27)!

textcolor
	"Answer the text color to use for instances of the receiver"

	self ensureOptionsLoaded.
	^Textcolor!

textcolor: aColor
	"Set the text color to use for instances of the receiver"

	self textcolor = aColor ifTrue: [^self].
	Textcolor := aColor.
	self persistOptions
		ifTrue: [self primAllSubinstances do: [:each | each folderView forecolor: aColor]]!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	Color removeNamed: #smalltalkSystem.
	self free.
	SmalltalkSystem.Current
		ifNotNil: [:devsys | devsys systemFolderClass == self ifTrue: [devsys systemFolderClass: nil]]!

viewMode
	"Answer the view mode of the receiver.
	This can be one of:
		#report 
		#extraLargeIcons 
		#thumbnails 
		#tileIcons 
		#largeIcons 
		#smallIcons"

	self ensureOptionsLoaded.
	^ViewMode
		
!

viewMode: aSymbol
	"Sets the view mode of the receiver to aSymbol.
	This can be one of:
		#smallIcons
		#largeIcons
		#tileIcons
		#list
		#report"

	self viewMode == aSymbol ifTrue: [^self].
	ViewMode := aSymbol.
	self persistOptions
		ifTrue: [self primAllSubinstances do: [:each | each folderView viewMode: aSymbol]]! !
!Tools.SmalltalkSystemShell class categoriesForMethods!
applyOptions!accessing!options!private! !
backcolor!accessing!options!public! !
backcolor:!accessing!options!public! !
backImage!accessing!options!public! !
backImage:!accessing!options!public! !
backImageAlphaPercent!accessing!options!public! !
backImageAlphaPercent:!accessing!options!public! !
backImageIsTiled!accessing!options!public! !
backImageIsTiled:!accessing!options!public! !
default!instance creation!public! !
defaultBackcolor!accessing!options!private! !
defaultBackImage!private! !
defaultTextcolor!private! !
displayOn:!displaying!public! !
firstReset!private! !
free!public!realizing/unrealizing! !
hotKey!accessing!options!public! !
hotKey:!accessing!options!public! !
icon!constants!public! !
initialize!initializing!private! !
onNoVisibleWindows!public! !
onStartup!events-session!private! !
playSystemSounds!accessing!options!public! !
playSystemSounds:!accessing!options!public! !
publishedAspects!constants!options!public! !
reset!operations!public! !
resetWhenInvisible!accessing!options!public! !
resetWhenInvisible:!accessing!options!public! !
resource_Default_view!public!resources-views! !
textcolor!accessing!options!public! !
textcolor:!accessing!options!public! !
uninitialize!class hierarchy-removing!private! !
viewMode!accessing!options!public! !
viewMode:!accessing!options!public! !
!

