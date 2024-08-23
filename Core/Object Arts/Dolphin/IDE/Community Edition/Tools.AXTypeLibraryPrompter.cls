"Filed out from Dolphin Smalltalk"!

UI.ValueDialog
	subclass: #'Tools.AXTypeLibraryPrompter'
	instanceVariableNames: 'typeLibs path guidPresenter'
	classVariableNames: ''
	imports: #(#{OS.COM private})
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.AXTypeLibraryPrompter guid: (Core.GUID fromString: '{4febe003-3945-11d3-9fe6-00a0cc3e4a32}')!

Tools.AXTypeLibraryPrompter comment: 'AXTypeLibraryPrompter is a <valueDialogPresenter> that can be used to prompt for a COM component type library to install into the image. Its displays a list of all the registered type libraries (including those already installed) and also gives the user an opportunity to load a type library directly from a DLL, OCX, EXE, or TLB file. The subject <valueModel> is filled with an instance of AXTypeLibrary representing the chosen library when the dialogue is confirmed.

Note that the prompter takes care not to actually load the type libraries until the user chooses one.

Example:
	AXTypeLibraryPrompter showModal "Display it"

Instance Variables:
	typeLibs		<ListPresenter> displaying a list of <AXTypeLibRegistration>s.
	path		<TextPresenter> displaying the path to the chosen type library.

'!

!Tools.AXTypeLibraryPrompter categoriesForClass!MVP-Presenters! !

!Tools.AXTypeLibraryPrompter methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	typeLibs := self add: ListPresenter new name: 'typeLibs'.
	path := self add: TextPresenter new name: 'libraryPath'.
	guidPresenter := self add: TextPresenter new name: 'guid'.

!

createSchematicWiring
	"Create the trigger wiring for the receiver"
	
	super createSchematicWiring.
	typeLibs when: #actionPerformed send: #onTypeLibraryChosen to: self.
	typeLibs when: #selectionChanged send: #onTypeLibrarySelected to: self!

ok
	"Close the receiver and apply the changes cached in the receiver back to the model"

	| reg |
	reg := typeLibs selectionOrNil.
	self value: (reg isNil ifFalse: [TypeLibraryAnalyzer fromRegistration: reg]).
	super ok!

onTypeLibraryChosen
	"Private - A type library has been chosen by the user double-clicking an entry in the list.
	This is the same as the OK command, but we need to test that #ok command is actually
	enabled."

	self view onCommand: (CommandDescription command: #ok)!

onTypeLibrarySelected
	"Private - A type library has been selected. Refresh the information about
	it, including the list of available interfaces."

	| reg |
	path clear.
	guidPresenter clear.
	(reg := typeLibs selectionOrNil) notNil
		ifTrue: 
			[
			[| guid |
			guid := reg libid.
			path value: (ITypeLib
						queryPath: guid
						major: reg majorVersion
						minor: reg minorVersion
						locale: 0).
			guidPresenter value: guid]
					on: OS.HRESULTError
					do: 
						[:e |
						e beep.
						path value: ('Unable to load type library <1p>:<n><2s>' expandMacrosWith: reg description
									with: e messageText)]]!

onViewOpened
	"Private - Received when the receiver's view is been connected. Refresh the
	list of current type libraries"

	super onViewOpened.
	self refresh.
	typeLibs setFocus
!

openTypeLib
	"Browse the file system for a type library to open."

	| typelib |
	typelib := TypeLibraryAnalyzer open.
	typelib notNil
		ifTrue: 
			[self value: typelib.
			super ok]!

refresh
	"Private - Refresh the list of current AXTypeLibraryAnalyzers in the image"

	| registrations currentTypeLibs |
	currentTypeLibs := TypeLibraryAnalyzer allTypeLibs collect: [:each | each registration].
	registrations := TypeLibraryAnalyzer typeLibRegistrations.
	registrations := registrations difference: currentTypeLibs.
	typeLibs list: registrations asSortedCollection.
	self onTypeLibrarySelected!

validateModel
	^ValidationResult value: (guidPresenter value isKindOf: GUID)! !

!Tools.AXTypeLibraryPrompter categoriesForMethods!
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
ok!commands!public! !
onTypeLibraryChosen!event handling!private! !
onTypeLibrarySelected!event handling!private! !
onViewOpened!event handling!private! !
openTypeLib!commands!public! !
refresh!commands!private! !
validateModel!helpers!private! !
!

!Tools.AXTypeLibraryPrompter class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 240 nil nil nil 5 nil nil nil 240 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[10 0 0 0 115 1 0 0 98 1 0 0 155 1 0 0] 193 272 8 '' 240 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 576 nil nil nil 5 nil nil nil 576 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 12 18 #{UI.ListView} 50 45 nil 576 50 2 8 1140953165 1025 720 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 5 nil nil nil 720 nil nil 518 #{Core.Message} #description 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 818 2 3142 5 #{UI.ListViewColumn} 8 'Library' 565 #left 914 #displayString 8 #() 914 #<= 8 #() 914 #description 8 #() nil 720 nil 3 nil nil 1010 8 'Version' 105 #left 1056 914 #<= 8 #() 914 #versionString 1136 nil 720 nil 1 nil nil #report 8 #() nil 131137 nil 1 nil nil nil nil 1 262 #{UI.ListViewVirtualUpdateMode} 720 nil nil nil nil nil nil nil nil nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[0 0 0 0 0 0 0 0 86 1 0 0 243 0 0 0] 193 752 8 'Library' 720 3 8 #() 546 193 193 nil 35 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 1 1474 #fixedParentRight -3 1474 #fixedParentTop 1 1474 #fixedParentBottom -235 18 #{UI.PushButton} 50 20 nil 576 50 2 8 1140924416 1 1552 nil 896 nil 5 nil nil nil 1552 nil nil 1350 4 #{UI.CommandDescription} #openTypeLib 8 '&Open…' 1 1 nil nil false nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[12 1 0 0 253 0 0 0 82 1 0 0 22 1 0 0] 193 1584 8 '&Open…' 1552 386 #isEnabled: 8 #(false) 1552 3 8 #() 546 193 193 nil 29 1442 1474 #fixedViewRight -139 1504 -11 1474 #fixedViewBottom -49 1536 -165 18 #{UI.StaticText} 50 16 nil 576 50 2 8 1140850946 1 1904 nil nil nil 5 nil nil nil 1904 nil nil 518 #{UI.NullConverter} nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[2 0 0 0 38 1 0 0 57 0 0 0 58 1 0 0] 193 1936 nil 1904 386 #text: 50 1 8 '&Location:' 1904 3 8 #() 546 193 193 nil 27 1442 1488 5 1474 #fixedViewLeft 111 1888 -39 1536 -93 18 #{UI.StaticPath} 50 17 nil 576 50 2 8 1140850944 1 2224 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil nil nil 5 nil nil nil 2224 nil nil 1970 nil nil nil 8 'Path of selected library here…on two lines if necessary to get the whole path to fit.' 338 50 2 386 #createWindow: 50 1 434 466 8 #[65 0 0 0 38 1 0 0 82 1 0 0 58 1 0 0] 193 2256 nil 2224 386 #text: 50 1 2368 2224 3 8 #() 546 193 193 nil 27 1442 1488 131 1504 -11 1888 -39 1536 -93 18 #{UI.StaticText} 50 16 nil 576 50 2 8 1140850946 1 2576 nil nil nil 5 nil nil nil 2576 nil nil 1970 nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[0 0 0 0 67 1 0 0 55 0 0 0 87 1 0 0] 193 2608 nil 2576 386 #text: 50 1 8 '&GUID:' 2576 3 8 #() 546 193 193 nil 27 1442 1488 1 2208 111 1888 -39 1536 -35 18 #{UI.StaticText} 50 16 nil 576 50 2 8 1140850944 1 2864 nil nil nil 5 nil nil nil 2864 nil nil 1970 nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[65 0 0 0 67 1 0 0 82 1 0 0 87 1 0 0] 193 2896 nil 2864 386 #text: 50 1 8 'GUID of selected library here…' 2864 3 8 #() 546 193 193 nil 27 1442 1488 131 1504 -11 1888 -39 1536 -35 674 #{Core.IdentityDictionary} 50 6 2864 8 'guid' 2224 8 'libraryPath' 720 8 'typeLibs' nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[10 0 0 0 10 0 0 0 98 1 0 0 115 1 0 0] 193 608 8 '' 576 3 50 6 720 1552 1904 2224 2576 2864 546 193 193 nil 27 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 546 21 21 546 21 21 nil nil nil nil 1 nil nil 546 1201 1191 546 721 591 nil nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 338 50 2 386 #createWindow: 50 1 518 #{UI.CreateDialog} 3426 546 6143 21 546 6903 941 193 32 386 #setWindowText: 50 1 8 'Registered Components' 32 1 50 2 576 240 546 193 193 nil 29)! !

!Tools.AXTypeLibraryPrompter class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

