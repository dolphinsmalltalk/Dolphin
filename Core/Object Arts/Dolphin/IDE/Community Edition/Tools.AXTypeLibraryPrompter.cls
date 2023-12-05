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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 272 nil nil nil 5 nil nil nil 272 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 210 21 743 210 689 81 272 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 115 1 0 0 98 1 0 0 155 1 0 0] 8 #() 210 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 576 nil nil nil 5 nil nil nil 576 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 12 18 #{UI.ListView} 50 45 nil 576 50 2 8 1140953165 1025 720 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 5 nil nil nil 720 nil nil 518 #{Core.Message} #description 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 818 2 3142 5 #{UI.ListViewColumn} 8 'Library' 565 #left 914 #displayString 8 #() 914 #<= 8 #() 914 #description 8 #() nil 720 nil 3 nil nil 1010 8 'Version' 105 #left 1056 914 #<= 8 #() 914 #versionString 1136 nil 720 nil 1 nil nil #report 8 #() nil 131137 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 1 1 210 685 487 720 418 #text: 50 1 8 'Library' 720 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 1 0 0 243 0 0 0] 8 #() 560 nil 35 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 1 1474 #fixedParentRight -3 1474 #fixedParentTop 1 1474 #fixedParentBottom -235 18 #{UI.PushButton} 50 20 nil 576 50 2 8 1140924416 1 1552 nil 896 nil 5 nil nil nil 1552 nil nil 1350 4 #{UI.CommandDescription} #openTypeLib 8 '&Open…' 1 1 nil nil false nil nil nil 370 50 3 418 #createAt:extent: 50 2 210 535 507 210 141 51 1552 418 #isEnabled: 8 #(false) 1552 418 #text: 50 1 8 '&Open…' 1552 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 1 0 0 253 0 0 0 81 1 0 0 22 1 0 0] 8 #() 560 nil 29 1442 1474 #fixedViewRight -139 1504 -13 1474 #fixedViewBottom -49 1536 -165 18 #{UI.StaticText} 50 16 nil 576 50 2 8 1140850946 1 1936 nil nil nil 5 nil nil nil 1936 nil nil 518 #{UI.NullConverter} nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 1 577 210 111 51 1936 418 #text: 50 1 8 '&Location:' 1936 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 32 1 0 0 55 0 0 0 57 1 0 0] 8 #() 560 nil 27 1442 1488 1 1474 #fixedViewLeft 111 1920 -49 1536 -95 18 #{UI.StaticText} 50 16 nil 576 50 2 8 1140850944 1 2256 nil nil nil 5 nil nil nil 2256 nil nil 2002 nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 131 577 210 561 61 2256 418 #text: 50 1 8 'Path of selected library here…on two lines if necessary to get the whole path to fit.' 2256 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 32 1 0 0 89 1 0 0 62 1 0 0] 8 #() 560 nil 27 1442 1488 131 2240 561 1920 -59 1536 -85 18 #{UI.StaticText} 50 16 nil 576 50 2 8 1140850946 1 2544 nil nil nil 5 nil nil nil 2544 nil nil 2002 nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 1 657 210 111 41 2544 418 #text: 50 1 8 '&GUID:' 2544 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 72 1 0 0 55 0 0 0 92 1 0 0] 8 #() 560 nil 27 1442 1488 1 2240 111 1920 -39 1536 -25 18 #{UI.StaticText} 50 16 nil 576 50 2 8 1140850944 1 2832 nil nil nil 5 nil nil nil 2832 nil nil 2002 nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 131 657 210 561 41 2832 418 #text: 50 1 8 'GUID of selected library here…' 2832 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 72 1 0 0 89 1 0 0 92 1 0 0] 8 #() 560 nil 27 1442 1488 131 2240 561 1920 -39 1536 -25 674 #{Core.IdentityDictionary} 50 6 2832 8 'guid' 2256 8 'libraryPath' 720 8 'typeLibs' nil 370 50 1 418 #createAt:extent: 50 2 210 21 21 210 689 723 576 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 98 1 0 0 115 1 0 0] 50 6 720 1552 1936 2256 2544 2832 560 nil 27 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 210 21 21 210 21 21 nil nil nil nil 1 nil nil 210 1201 1191 210 721 591 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil nil 370 50 2 418 #createAt:extent: 50 2 210 6143 21 210 761 921 32 418 #text: 50 1 8 'Registered Components' 32 498 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 123 13 0 0 214 1 0 0] 50 2 576 272 560 nil 27)! !
!Tools.AXTypeLibraryPrompter class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

