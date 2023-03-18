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

queryCommand: query
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery>, query."

	| cmd |
	cmd := query commandSymbol.
	
	cmd == #ok ifTrue: [
		query isEnabled: (guidPresenter value isKindOf: GUID).
		^true].

	^super queryCommand: query.
!

refresh
	"Private - Refresh the list of current AXTypeLibraryAnalyzers in the image"

	| registrations currentTypeLibs |
	currentTypeLibs := TypeLibraryAnalyzer allTypeLibs collect: [:each | each registration].
	registrations := TypeLibraryAnalyzer typeLibRegistrations.
	registrations := registrations difference: currentTypeLibs.
	typeLibs list: registrations asSortedCollection.
	self onTypeLibrarySelected! !
!Tools.AXTypeLibraryPrompter categoriesForMethods!
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
ok!commands!public! !
onTypeLibraryChosen!event handling!private! !
onTypeLibrarySelected!event handling!private! !
onViewOpened!event handling!private! !
openTypeLib!commands!public! !
queryCommand:!commands!private! !
refresh!commands!private! !
!

!Tools.AXTypeLibraryPrompter class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 nil 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1376838 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 21 743 578 689 81 640 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 115 1 0 0 98 1 0 0 155 1 0 0] 8 #() 578 193 193 nil 27 nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 944 nil nil nil 7 nil nil nil 944 1048838 #{UI.FramingLayout} 170 176 34 12 410 #{UI.PushButton} 34 20 nil 944 34 2 8 1140924416 1 1072 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 1072 nil 8 1815097472 1377606 4 #{UI.CommandDescription} #openTypeLib 8 '&Open…' 1 1 nil nil false nil nil nil 738 34 3 786 #createAt:extent: 34 2 578 535 507 578 141 51 1072 786 #isEnabled: 8 #(false) 1072 786 #text: 34 1 8 '&Open…' 1072 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 1 0 0 253 0 0 0 81 1 0 0 22 1 0 0] 8 #() 928 nil 29 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedViewRight -139 1490 #fixedParentRight -13 1490 #fixedViewBottom -49 1490 #fixedParentBottom -165 410 #{UI.StaticText} 34 16 nil 944 34 2 8 1140850946 1 1568 nil nil nil 7 nil nil nil 1568 nil 8 1815137184 1049094 #{UI.NullConverter} nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 1 577 578 111 51 1568 786 #text: 34 1 8 '&Location:' 1568 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 32 1 0 0 55 0 0 0 57 1 0 0] 8 #() 928 nil 27 1458 1490 #fixedParentLeft 1 1490 #fixedViewLeft 111 1536 -49 1552 -95 410 #{UI.StaticText} 34 16 nil 944 34 2 8 1140850946 1 1920 nil nil nil 7 nil nil nil 1920 nil 8 1815137184 1650 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 1 657 578 111 41 1920 786 #text: 34 1 8 '&GUID:' 1920 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 72 1 0 0 55 0 0 0 92 1 0 0] 8 #() 928 nil 27 1458 1888 1 1904 111 1536 -39 1552 -25 410 #{UI.StaticText} 34 16 nil 944 34 2 8 1140850944 1 2224 nil nil nil 7 nil nil nil 2224 nil 8 1815137184 1650 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 131 657 578 561 41 2224 786 #text: 34 1 8 'GUID of selected library here…' 2224 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 72 1 0 0 89 1 0 0 92 1 0 0] 8 #() 928 nil 27 1458 1888 131 1904 561 1536 -39 1552 -25 410 #{UI.ListView} 34 45 nil 944 34 2 8 1140953165 1025 2528 787270 2 #{UI.ListModel} 138 144 912 nil 1769478 #{Kernel.IdentitySearchPolicy} 1152 nil 7 nil nil nil 2528 nil 8 1815049392 786950 #{Core.Message} #description 8 #() nil 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 138 144 34 2 1117254 5 #{UI.ListViewColumn} 8 'Library' 565 #left 2690 #displayString 912 2690 #<= 8 #() 2690 #description 8 #() nil 2528 nil 3 nil nil 2802 8 'Version' 105 #left 2848 2690 #<= 8 #() 2690 #versionString 2912 nil 2528 nil 1 nil nil #report 8 #() nil 131137 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 1 1 578 685 487 2528 786 #text: 34 1 8 'Library' 2528 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 1 0 0 243 0 0 0] 8 #() 928 nil 35 1458 1888 1 1520 -3 1490 #fixedParentTop 1 1552 -235 410 #{UI.StaticText} 34 16 nil 944 34 2 8 1140850944 1 3248 nil nil nil 7 nil nil nil 3248 nil 8 1815137184 1650 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 131 577 578 561 61 3248 786 #text: 34 1 8 'Path of selected library here…on two lines if necessary to get the whole path to fit.' 3248 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 32 1 0 0 89 1 0 0 62 1 0 0] 8 #() 928 nil 27 1458 1888 131 1904 561 1536 -59 1552 -85 170 192 34 6 2224 8 'guid' 3248 8 'libraryPath' 2528 8 'typeLibs' nil 738 34 1 786 #createAt:extent: 34 2 578 21 21 578 689 723 944 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 98 1 0 0 115 1 0 0] 34 6 2528 1072 1568 3248 1920 2224 928 nil 27 170 192 912 1180166 #{Graphics.Rectangle} 578 21 21 578 21 21 nil nil nil nil 37139 nil nil 578 1201 1191 578 721 591 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 738 34 2 786 #createAt:extent: 34 2 578 12287 21 578 761 921 416 786 #text: 34 1 8 'Registered Components' 416 866 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 123 25 0 0 214 1 0 0] 34 2 944 640 928 nil 27)! !
!Tools.AXTypeLibraryPrompter class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

