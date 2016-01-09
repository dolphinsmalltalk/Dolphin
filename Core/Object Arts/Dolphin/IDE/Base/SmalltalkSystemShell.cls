"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #SmalltalkSystemShell
	instanceVariableNames: 'systemFolderPresenter'
	classVariableNames: 'Backcolor BackImage BackImageAlphaPercent BackImageIsTiled Default HotKey PlaySystemSounds ResetWhenInvisible Textcolor ViewMode'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmalltalkSystemShell guid: (GUID fromString: '{87B4C6C3-026E-11D3-9FD7-00A0CC3E4A32}')!
SmalltalkSystemShell comment: 'SmalltalkSystemShell is a <SmalltalkToolShell> that implements the user interface onto theDolphin Smalltalk system folder. This an iconic daunting point for all of the installed tools, sample applications etc.

Instance Variables:
	systemFolderPresenter		<FolderPresenter> displaying the system folder hierarchy.

Class Variables:
	Default				<SmalltalkSystemShell> which is the singleton instance.
	DefaultBackcolor			<color> for the background of the folder.




'!
!SmalltalkSystemShell categoriesForClass!Development!MVP-Presenters! !
!SmalltalkSystemShell methodsFor!

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

	(systemFolderPresenter view)
		backcolor: self class backcolor;
		backImage: self class backImage;
		backImageIsTiled: self class backImageIsTiled;
		backImageAlphaPercent: self class backImageAlphaPercent;
		forecolor: self class textcolor;
		viewMode: self class viewMode!

browseCompilationFailures
	"Open a method browser on all methods in the system which have failed compilation (i.e.
	which are instances of CompileFailedMethod)."

	self systemModel browseCompilationFailuresIn: self searchEnvironment!

browseCompilationIssues
	"Open a method browser on all methods in the system which have failed compilation (i.e.
	which are instances of CompileFailedMethod)."

	self systemModel browseCompilationIssuesIn: self searchEnvironment!

browseDeprecatedMethods
	self browseMethodCategory: (MethodCategory name: '*-deprecated')!

browseMessageDefinitions
	"Prompt for a selector and open a method browser displaying the implementors of that
	selector."

	self model browseMessageDefinitionsIn: self searchEnvironment!

browseMessageReferences
	"Prompt for a selector and open a method browser displaying the references to that
	selector, using the the first word of the clipboard text as the initial suggestion."

	self model browseMessageReferencesIn: self searchEnvironment!

browseMethodCategory: aMethodCategory 
	self model browseMethodCategories: (Array with: aMethodCategory) in: self searchEnvironment!

browseNotYetImplemented
	self browseMethodCategory: (MethodCategory name: '*-not yet implemented')!

browseUnclassifiedMethods
	self browseMethodCategory: MethodCategory unclassified!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	systemFolderPresenter := (self 
				add: (FolderPresenter new beSorted: 
							[:a :b | 
							a description < b description])
				name: 'systemFolder')
				openBlock: [:presenter :item | presenter openItem: item];
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

onViewCreated
	"Private - The receiver's has been created (that is the CreateWindow() API call has returned), but may
	not yet be connected to the receiver (if the view-presenter pair is being instantiated, then
	the connection will not have been made, but if the view is being restored from saved state
	in the image then the presenter will be connected). This is an appropriate point for
	subclasses to apply any dynamic view configuration that must be performed every time the
	view is created. Typically this might involve customising some feature of the view that it
	does not itself save, perhaps because a feature of the underlying control does not have full
	support in the wrapper class. Note that one should normally override #onViewAvailable to
	restore user configuration settings, since the views will normally save and restore all
	relevant settings across an image save."

	self registerHotKey.
	^super onViewCreated!

onViewDestroyed
	"Private - Handler for view final view destruction. This is sent on receipt of WM_NCDESTROY,
	and is expected to be the last communication from Windows. There is nothing
	more we can do to save the patient. No event is triggered."

	self unregisterHotKey.
	super onViewDestroyed!

onViewModeChanged
	"Private - Event handler for view mode changed. Save the new mode to the user preferences"

	self class viewMode: systemFolderPresenter view viewMode!

onViewOpened
	"Private - Received when the receiver's view is been connected. "

	| toolbar |
	super onViewOpened.
	self applyOptions.
	systemFolderPresenter selectionByIndex: 1.
	self view position: self class defaultPosition.
	toolbar := self view viewNamed: 'systemShellTools'.
	toolbar presenterConnectionPoint 
		when: #dropDown:
		send: #onDropDown:
		to: systemFolderPresenter view.
	systemFolderPresenter view 
		when: #viewModeChanged
		send: #onViewModeChanged
		to: self!

properties
	^systemFolderPresenter selection tool inspect!

queryCommand: aCommandQuery 
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery> argument."

	| selector |
	selector := aCommandQuery commandSymbol.
	selector == #properties 
		ifTrue: 
			[aCommandQuery 
				isEnabled: (systemFolderPresenter hasSelection and: [systemFolderPresenter selection tool notNil]).
			^true].
	selector == #whatsThis 
		ifTrue: 
			[aCommandQuery isEnabled: systemFolderPresenter hasSelection.
			^true].
	^super queryCommand: aCommandQuery!

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
	^self model systemEnvironment!

systemFolderPresenter
	^systemFolderPresenter!

unregisterHotKey
	self view unregisterHotKeyId: 1000
!

updateCaption
	"The receiver has changed in such a way that the caption may need to be refreshed.
	Do this here"

	| sesh |
	sesh := SessionManager current.
	self caption: ('<1s> - <2s>' expandMacrosWith: sesh applicationName
				with: (File splitFilenameFrom: sesh imageFileName))!

whatsThis
	systemFolderPresenter selection whatsThis ! !
!SmalltalkSystemShell categoriesFor: #addToCommandRoute:!commands!public! !
!SmalltalkSystemShell categoriesFor: #applyOptions!operations!options!private! !
!SmalltalkSystemShell categoriesFor: #browseCompilationFailures!browsing!commands!public! !
!SmalltalkSystemShell categoriesFor: #browseCompilationIssues!commands!public! !
!SmalltalkSystemShell categoriesFor: #browseDeprecatedMethods!browsing!commands!public! !
!SmalltalkSystemShell categoriesFor: #browseMessageDefinitions!browsing!commands!public! !
!SmalltalkSystemShell categoriesFor: #browseMessageReferences!browsing!commands!public! !
!SmalltalkSystemShell categoriesFor: #browseMethodCategory:!browsing!private! !
!SmalltalkSystemShell categoriesFor: #browseNotYetImplemented!browsing!commands!public! !
!SmalltalkSystemShell categoriesFor: #browseUnclassifiedMethods!browsing!commands!public! !
!SmalltalkSystemShell categoriesFor: #createComponents!**auto generated**!initializing!public! !
!SmalltalkSystemShell categoriesFor: #createSchematicWiring!initializing!public! !
!SmalltalkSystemShell categoriesFor: #defaultHelpId!constants!public! !
!SmalltalkSystemShell categoriesFor: #initialize!initializing!private! !
!SmalltalkSystemShell categoriesFor: #inspectSystemOptions!commands!public! !
!SmalltalkSystemShell categoriesFor: #model:!accessing!public! !
!SmalltalkSystemShell categoriesFor: #onCloseRequested:!event handling!private! !
!SmalltalkSystemShell categoriesFor: #onHotKey:!event handling!private! !
!SmalltalkSystemShell categoriesFor: #onPositionChanged:!event handling!private! !
!SmalltalkSystemShell categoriesFor: #onViewCreated!event handling!private! !
!SmalltalkSystemShell categoriesFor: #onViewDestroyed!event handling!private! !
!SmalltalkSystemShell categoriesFor: #onViewModeChanged!event handling!private! !
!SmalltalkSystemShell categoriesFor: #onViewOpened!event handling!private! !
!SmalltalkSystemShell categoriesFor: #properties!commands!public! !
!SmalltalkSystemShell categoriesFor: #queryCommand:!commands!private! !
!SmalltalkSystemShell categoriesFor: #registerHotKey!helpers!private! !
!SmalltalkSystemShell categoriesFor: #resetSelection!event handling!private! !
!SmalltalkSystemShell categoriesFor: #resetWhenInvisible!options!public! !
!SmalltalkSystemShell categoriesFor: #searchEnvironment!commands!public! !
!SmalltalkSystemShell categoriesFor: #systemFolderPresenter!accessing!private! !
!SmalltalkSystemShell categoriesFor: #unregisterHotKey!helpers!private! !
!SmalltalkSystemShell categoriesFor: #updateCaption!public!updating! !
!SmalltalkSystemShell categoriesFor: #whatsThis!commands!public! !

!SmalltalkSystemShell class methodsFor!

applyOptions
	self allSubinstances do: [:each | each applyOptions]!

backcolor
	"Answe the default background to use for instances of the receiver"

	^Backcolor!

backcolor: aColorOrNil
	"Set the background to use for instances of the receiver"

	Backcolor := aColorOrNil.
	self applyOptions
	!

backImage
	"Answe the background image to use for instances of the receiver"

	^BackImage!

backImage: aBitmapOrNil 
	"Set the background image to use for instances of the receiver"

	BackImage := aBitmapOrNil.
	self applyOptions!

backImageAlphaPercent
	"Answer the background image alpha for instances of the receiver"

	BackImageAlphaPercent ifNil: [BackImageAlphaPercent := 80].
	^BackImageAlphaPercent!

backImageAlphaPercent: anInteger 
	"Set the background image alpha for instances of the receiver"

	BackImageAlphaPercent := anInteger.
	self applyOptions!

backImageIsTiled
	"Answer the tiling mode to use for the background image of instances of the receiver"

	BackImageIsTiled ifNil: [BackImageIsTiled := true].
	^BackImageIsTiled!

backImageIsTiled: aBoolean 
	"Set the tiling mode to use for the background image of instances of the receiver"

	BackImageIsTiled := aBoolean.
	self applyOptions!

default
	"Answer the default instance of the receiver

	SmalltalkSystemShell default
"

	Default isNil ifTrue: [Default := self show].
	^Default!

defaultBackcolor
	"Private - Answer the default background to use for instances of the receiver"

	^RGB 
		red: 41
		green: 124
		blue: 182!

defaultBackImage
	^nil!

defaultPosition
	"Private - Answer the default location of the receiver"

	^22@22!

defaultTextcolor
	^RGB 
		red: 243
		green: 243
		blue: 243!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'System Folder'!

firstReset
	"Private - Reset the class for first use. 
	Force the creation of an new default instance of the receiver
	
	self firstReset
	"

	self reset.
	self showTipsAtStartup: true.
	self default systemModel helpContents!

free
	"Close and release the current system shell (e.g. to create a runtime image).
	Also close the associated Transcript"

	Default notNil ifTrue: [ 
		TranscriptShell free.
		Default view destroy ].
	Default := nil!

hotKey
	"Answer the hot key that can be used to bring the system shell into the foreground even when
	minimised or if another application is active."

	^HotKey ifNil: [0]!

hotKey: anInteger 
	"Set the hot key that can be used to bring the system shell into the foreground even when
	minimised or if another application is active."

	| open |
	open := Default notNil and: [Default isOpen].
	open ifTrue: [Default unregisterHotKey].
	HotKey := anInteger = 0 ifFalse: [anInteger].
	open ifTrue: [Default registerHotKey]!

icon
	"Answers an Icon that can be used to represent this class"

	^Smalltalk developmentSystem icon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	Smalltalk developmentSystem registerTool: self.
	self backImage: self defaultBackImage.
	self backcolor: self defaultBackcolor.
	self textcolor: self defaultTextcolor.
	self viewMode: #tileIcons.
	self playSystemSounds: true.
	self resetWhenInvisible: false.
	HotKey := 16r3244!

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
	self default updateCaption.


!

playSystemSounds
	"Answer true if the IDE sounds are turned on"

	^PlaySystemSounds
		
!

playSystemSounds: aBoolean
	"Sets wherher the IDE sounds are turned on"

	PlaySystemSounds := aBoolean
		
!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published the receiver."

	^(super publishedAspects)
		add: (Aspect color: #backcolor);
		add: (Aspect color: #textcolor);
		add: (Aspect bitmap: #backImage);
		add: (Aspect boolean: #backImageIsTiled);
		add: (Aspect integer: #backImageAlphaPercent);
		add: (Aspect choice: #viewMode from: #(#smallIcons #largeIcons #tileIcons #list #report));
		add: (Aspect boolean: #playSystemSounds);
		add: (Aspect hotkey: #hotKey);
		add: (Aspect boolean: #resetWhenInvisible);
		yourself!

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
	^ResetWhenInvisible!

resetWhenInvisible: aBoolean 
	ResetWhenInvisible := aBoolean!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 196934 1 ##(Smalltalk.RGB)  8 4294967295 0 39 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 410 8 ##(Smalltalk.Toolbar)  98 25 0 416 98 2 8 1140851524 131073 560 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 519 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 560 642 8 4278190080 8 4294903109 234 256 98 6 410 8 ##(Smalltalk.ReferenceView)  98 14 0 560 98 2 8 1140850688 131073 880 0 721158 ##(Smalltalk.SystemColor)  31 0 7 0 0 0 880 1180166 ##(Smalltalk.ResourceIdentifier)  576 8 #resource_Smalltalk_tools 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 770 63 1 770 991 51 880 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 98 0 770 193 193 0 27 8 'smalltalkTools' 410 896 98 14 0 560 98 2 8 1140850688 131073 1296 0 962 31 0 7 0 0 0 1296 994 576 8 #resource_Image_tools 0 1042 202 208 98 1 1106 1136 98 2 770 1 1 770 63 51 1296 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1248 1264 0 27 8 'imageTools' 410 576 98 25 0 560 98 2 8 1140853572 65 1568 0 642 672 770 251 51 519 0 690 0 16 722 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 770 193 193 0 1568 642 816 8 4294903109 234 256 1248 234 256 98 8 15357 1115910 ##(Smalltalk.ToolbarIconButton)  15357 0 1568 1 1180998 4 ##(Smalltalk.CommandDescription)  8 #historyBack 8 'Back' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'HistoryBack.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr7.dll' 0 395334 3 ##(Smalltalk.Bitmap)  0 16 0 0 0 0 3 770 33 33 1 15359 1810 15359 0 1568 1 1842 8 #historyForward 8 'Forward' 1 1 1906 0 16 1952 8 'HistoryForward.ico' 2000 2034 0 16 0 0 0 0 3 770 33 33 1 15361 853766 ##(Smalltalk.ToolbarButton)  15361 0 1568 17 1842 8 #viewModeSelect 8 'Views' 1 1 0 2034 0 16 1952 8 'ViewBar.bmp' 2000 0 7 770 129 33 3 15355 1810 15355 0 1568 1 1842 8 #up 8 'Up' 1 1 1906 0 16 1952 8 'Up.ico' 2000 2034 0 16 0 0 0 0 3 770 33 33 1 98 6 2336 1824 2080 1050118 ##(Smalltalk.ToolbarSeparator)  0 0 1568 3 0 1 2224 2482 0 0 1568 3 0 1 234 240 98 8 2176 5 2432 1 2048 3 2288 7 0 1 0 770 33 33 770 45 45 0 656198 1 ##(Smalltalk.FlowLayout)  1 1 1 1042 202 208 98 2 1106 1136 98 2 770 1053 1 770 251 51 1568 1106 8 #updateSizePosted 1248 1568 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 2 0 0 0 0 0 0 139 2 0 0 25 0 0 0] 98 0 1264 0 27 8 'systemShellTools' 234 256 1248 202 208 1248 234 240 1248 0 1 0 770 33 33 770 45 45 0 2594 1 1 1 1042 202 208 98 2 1106 1136 98 2 770 1 1 770 1709 51 560 1106 2752 1248 560 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 3 0 0 25 0 0 0] 98 3 1296 880 1568 1264 0 27 0 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 3104 0 642 8 4278190080 0 7 0 0 0 3104 530 1 1 0 0 0 0 410 8 ##(Smalltalk.ListView)  98 30 0 3104 98 2 8 1140932940 1 3232 590662 2 ##(Smalltalk.ListModel)  202 208 1248 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  642 8 4278190080 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 3 984134 2 ##(Smalltalk.CommandMenuItem)  1 1842 8 #properties 8 '&Properties' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 3474 1 1842 8 #whatsThis 8 '&What''s This?' 1 1 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 3232 0 8 4294903001 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  2 1 170 8 'Dolphin List Presenter' 8 'BasicListAbstract' 8 'doIt' 8 '[:item | item description]' 8 #[30 105 17 158 106] 8 #description 3696 7 257 0 8 ##(Smalltalk.IconicListAbstract)  1049926 1 ##(Smalltalk.IconImageManager)  0 0 0 770 65 65 0 0 202 208 98 1 920646 5 ##(Smalltalk.ListViewColumn)  8 'Column 1' 1119 8 #left 3682 0 0 3714 2 1 3744 8 'doIt' 8 '[:item | item description]' 8 #[30 105 17 158 106] 3840 4016 7 257 0 8 ##(Smalltalk.SortedCollection)  459270 ##(Smalltalk.Message)  8 #yourself 98 0 0 3232 3952 3 0 0 8 #largeIcons 1248 770 241 241 131169 0 98 4 0 0 770 1 1 0 1042 202 208 98 3 1106 1136 98 2 770 1 1 770 1709 723 3232 1106 8 #contextMenu: 98 1 3440 3232 1106 8 #text: 98 1 8 'Column 1' 3232 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 3 0 0 105 1 0 0] 98 0 1264 0 27 234 256 98 2 3232 8 'systemFolder' 0 1042 202 208 98 1 1106 1136 98 2 770 1 51 770 1709 723 3104 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 86 3 0 0 130 1 0 0] 98 1 3232 1264 0 27 234 256 98 2 560 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 5 3426 0 16 98 10 3474 1 1842 8 #newWorkspace 8 '&New Workspace' 9373 1 1906 0 16 1952 8 'SmalltalkWorkspace.ico' 2000 0 0 3474 1 1842 8 #openWorkspace 8 '&Open Workspace...' 9375 1 1906 0 16 1952 8 'FileOpen.ico' 2000 0 0 3474 1 1842 8 #fileFileIn 8 '&File In...' 1 1 0 0 0 3554 4097 3474 1 1842 8 #saveImage 8 'Sa&ve Image' 1 1 1906 0 16 1952 8 'Snapshot.ico' 2000 0 0 3474 1 1842 8 #saveImageAs 8 'Save Image As...' 1 1 0 0 0 3474 1 1842 8 #compressChanges 8 '&Compress Changes...' 1 1 0 0 0 3474 1 1842 8 #compressSources 8 'Co&mpress Sources...' 1 1 0 0 0 3554 4097 3474 1 1842 8 #smalltalkExit 8 'E&xit Dolphin' 1 1 1906 0 16 1952 8 'PowerSwitch.ico' 2000 0 0 8 '&File' 0 134217729 0 0 15557 0 0 3426 0 16 98 12 3474 1 1842 8 #browseHierarchy 8 '&Classes' 1 1 1906 0 16 1952 8 'ClassBrowserShell.ico' 2000 0 0 3474 1 1842 8 #browsePackages 8 '&Packages' 1 1 1906 0 16 1952 8 'Package.ico' 2000 0 0 3474 1 1842 8 #browseProtocols 8 'Pr&otocols' 1 1 1906 0 16 1952 8 'ProtocolBrowserShell.ico' 2000 0 0 3474 1 1842 8 #browseResources 8 '&Resources' 1 1 1906 0 16 1952 8 'Resource.ico' 2000 0 0 3474 1 1842 8 #browseSystem 8 'S&ystem' 1 1 1906 0 16 1952 8 'SystemBrowserShell.ico' 2000 0 0 3554 4097 3474 1 1842 8 #browseMessageDefinitions 8 'All &Definitions Of...' 1 1 0 0 0 3474 1 1842 8 #browseMessageReferences 8 'All Re&ferences To...' 1 1 0 0 0 3474 1 1842 4114 8 #browseReferencesToGlobal: 98 1 8 '' 8 'References to Global...' 1 1 0 0 0 3474 1 1842 8 #browseContainingText 8 'Containing &Text...' 1 1 1906 0 16 1952 47 786694 ##(Smalltalk.ShellLibrary)  0 0 3474 1 1842 8 #browseAllUnimplementedSelectors 8 'All &Unimplemented' 1 1 0 0 0 3426 0 16 98 5 3474 1 1842 8 #browseCompilationFailures 8 '&Compilation Failures' 1 1 0 0 0 3474 1 1842 8 #browseDeprecatedMethods 8 '&Deprecated' 1 1 0 0 0 3474 1 1842 8 #browseNotYetImplemented 8 '&Not Yet Implemented' 1 1 0 0 0 3474 1 1842 8 #browseUnclassifiedMethods 8 '&Unclassified' 1 1 0 0 0 3474 1 1842 8 #browseMethodCategory 8 '&Other...' 1 1 0 0 0 8 'Method Cate&gory' 0 134217729 0 0 15589 0 0 8 '&Browse' 0 134217729 0 0 15591 0 0 3426 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 15593 0 0 3426 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 15595 0 0 3426 0 16 98 17 3474 1 1842 8 #helpContents 8 '&Contents' 1025 1 1906 0 16 1952 49 6400 0 0 3474 1 1842 8 #help 8 'On this &Tool' 1249 1 0 0 0 3474 1 1842 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 3554 4097 3474 1 1842 8 #helpFirstSplash 8 'First Splash!!' 1 1 0 0 0 3554 4097 3474 1 1842 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 3474 1 1842 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 3474 1 1842 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 3426 0 16 98 4 3474 2097153 1842 8 #tipOfTheDay 8 '&Next Tip of the Day' 9441 1 1906 0 16 1952 8 'TipOfTheDay.ico' 2000 0 0 3474 1 1842 8 #previousTipOfTheDay 8 '&Previous Tip of the Day' 13537 1 1906 0 16 1952 8 'TipOfTheDay.ico' 2000 0 0 3554 4097 3474 1 1842 8 #toggleShowTipsAtStartup 8 '&Show Tips at Startup' 1 1 0 0 0 8 'Tip of the &Day' 0 134217729 0 0 15617 0 0 3554 4097 3474 1 1842 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 3474 1 1842 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 3474 1 1842 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 3554 4097 3474 1 1842 8 #bootLog 0 1 1 0 0 0 3474 1 1842 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 1906 0 16 1952 8 '!!APPLICATION' 2000 0 0 8 '&Help' 0 134217729 0 0 15629 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 770 2049 2049 0 1 0 0 1042 202 208 98 3 1106 1136 98 2 770 5119 21 770 1741 891 416 1106 4416 98 1 8 'Dolphin Smalltalk' 416 1106 8 #updateMenuBar 1248 416 1202 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 10 0 0 0 101 13 0 0 199 1 0 0] 98 2 560 3104 1264 0 27 )!

showTipsAtStartup
	| todClass |
	todClass := Smalltalk developmentSystem tipOfTheDayClass.
	^todClass notNil ifTrue: [todClass showTipsAtStartup] ifFalse: [false]!

showTipsAtStartup: aBoolean 
	| todClass |
	todClass := Smalltalk developmentSystem tipOfTheDayClass.
	todClass notNil ifTrue: [todClass showTipsAtStartup: aBoolean]!

textcolor
	"Answer the text color to use for instances of the receiver"

	^Textcolor!

textcolor: aColorOrNil
	"Set the text color to use for instances of the receiver"

	Textcolor := aColorOrNil.
	self applyOptions
	!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	self free.
	Smalltalk developmentSystem unregisterTool: self.
!

viewMode
	"Answer the view mode of the reciver.
	This can be one of:
		#smallIcons
		#largeIcons
		#tileIcons
		#list
		#report"

	^ViewMode
		
!

viewMode: aSymbol
	"Sets the view mode of the reciver to aSymbol.
	This can be one of:
		#smallIcons
		#largeIcons
		#tileIcons
		#list
		#report"

	ViewMode := aSymbol.
	self applyOptions! !
!SmalltalkSystemShell class categoriesFor: #applyOptions!accessing!options!private! !
!SmalltalkSystemShell class categoriesFor: #backcolor!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #backcolor:!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #backImage!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #backImage:!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #backImageAlphaPercent!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #backImageAlphaPercent:!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #backImageIsTiled!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #backImageIsTiled:!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #default!instance creation!public! !
!SmalltalkSystemShell class categoriesFor: #defaultBackcolor!accessing!options!private! !
!SmalltalkSystemShell class categoriesFor: #defaultBackImage!private! !
!SmalltalkSystemShell class categoriesFor: #defaultPosition!constants!private! !
!SmalltalkSystemShell class categoriesFor: #defaultTextcolor!private! !
!SmalltalkSystemShell class categoriesFor: #displayOn:!displaying!public! !
!SmalltalkSystemShell class categoriesFor: #firstReset!private! !
!SmalltalkSystemShell class categoriesFor: #free!public!realizing/unrealizing! !
!SmalltalkSystemShell class categoriesFor: #hotKey!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #hotKey:!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #icon!constants!public! !
!SmalltalkSystemShell class categoriesFor: #initialize!initializing!private! !
!SmalltalkSystemShell class categoriesFor: #onNoVisibleWindows!public! !
!SmalltalkSystemShell class categoriesFor: #onStartup!events-session!private! !
!SmalltalkSystemShell class categoriesFor: #playSystemSounds!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #playSystemSounds:!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #publishedAspects!constants!development!public! !
!SmalltalkSystemShell class categoriesFor: #reset!operations!public! !
!SmalltalkSystemShell class categoriesFor: #resetWhenInvisible!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #resetWhenInvisible:!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #resource_Default_view!public!resources-views! !
!SmalltalkSystemShell class categoriesFor: #showTipsAtStartup!public! !
!SmalltalkSystemShell class categoriesFor: #showTipsAtStartup:!public! !
!SmalltalkSystemShell class categoriesFor: #textcolor!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #textcolor:!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!SmalltalkSystemShell class categoriesFor: #viewMode!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #viewMode:!accessing!options!public! !

