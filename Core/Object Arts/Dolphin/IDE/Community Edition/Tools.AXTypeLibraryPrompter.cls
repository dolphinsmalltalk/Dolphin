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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 135 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 272 nil nil nil 7 nil nil nil 272 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 210 21 743 210 689 81 272 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 115 1 0 0 98 1 0 0 155 1 0 0] 8 #() 210 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 576 nil nil nil 7 nil nil nil 576 262 #{UI.FramingLayout} 550 #{Core.LookupTable} 6 18 #{UI.ListView} 50 45 nil 576 50 2 8 1140953165 1025 704 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 7 nil nil nil 704 nil 8 1853243664 518 #{Core.Message} #description 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 802 2 3142 5 #{UI.ListViewColumn} 8 'Library' 565 #left 914 #displayString 8 #() 914 #<= 8 #() 914 #description 8 #() nil 704 nil 3 nil nil 1010 8 'Version' 105 #left 1056 914 #<= 8 #() 914 #versionString 1136 nil 704 nil 1 nil nil #report 8 #() nil 131137 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 1 1 210 685 487 704 418 #text: 50 1 8 'Library' 704 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 1 0 0 243 0 0 0] 8 #() 560 nil 35 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 1 1474 #fixedParentRight -3 1474 #fixedParentTop 1 1474 #fixedParentBottom -235 18 #{UI.PushButton} 50 20 nil 576 50 2 8 1140924416 1 1552 nil 880 nil 7 nil nil nil 1552 nil 8 1853182784 1350 4 #{UI.CommandDescription} #openTypeLib 8 '&Open…' 1 1 nil nil false nil nil nil 370 50 3 418 #createAt:extent: 50 2 210 535 507 210 141 51 1552 418 #isEnabled: 8 #(false) 1552 418 #text: 50 1 8 '&Open…' 1552 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 1 0 0 253 0 0 0 81 1 0 0 22 1 0 0] 8 #() 560 nil 29 1442 1474 #fixedViewRight -139 1504 -13 1474 #fixedViewBottom -49 1536 -165 18 #{UI.StaticText} 50 16 nil 576 50 2 8 1140850944 1 1952 nil nil nil 7 nil nil nil 1952 nil 8 1853387904 518 #{UI.NullConverter} nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 131 657 210 561 41 1952 418 #text: 50 1 8 'GUID of selected library here…' 1952 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 72 1 0 0 89 1 0 0 92 1 0 0] 8 #() 560 nil 27 1442 1488 131 1474 #fixedViewLeft 561 1936 -39 1536 -25 18 #{UI.StaticText} 50 16 nil 576 50 2 8 1140850946 1 2288 nil nil nil 7 nil nil nil 2288 nil 8 1853387904 2034 nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 1 657 210 111 41 2288 418 #text: 50 1 8 '&GUID:' 2288 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 72 1 0 0 55 0 0 0 92 1 0 0] 8 #() 560 nil 27 1442 1488 1 2272 111 1936 -39 1536 -25 18 #{UI.StaticText} 50 16 nil 576 50 2 8 1140850946 1 2592 nil nil nil 7 nil nil nil 2592 nil 8 1853387904 2034 nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 1 577 210 111 51 2592 418 #text: 50 1 8 '&Location:' 2592 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 32 1 0 0 55 0 0 0 57 1 0 0] 8 #() 560 nil 27 1442 1488 1 2272 111 1936 -49 1536 -95 18 #{UI.StaticText} 50 16 nil 576 50 2 8 1140850944 1 2896 nil nil nil 7 nil nil nil 2896 nil 8 1853387904 2034 nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 131 577 210 561 61 2896 418 #text: 50 1 8 'Path of selected library here…on two lines if necessary to get the whole path to fit.' 2896 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 32 1 0 0 89 1 0 0 62 1 0 0] 8 #() 560 nil 27 1442 1488 131 2272 561 1936 -59 1536 -85 550 #{Core.IdentityDictionary} 3 704 8 'typeLibs' 1952 8 'guid' 2896 8 'libraryPath' nil 370 50 1 418 #createAt:extent: 50 2 210 21 21 210 689 723 576 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 98 1 0 0 115 1 0 0] 50 6 704 1552 2592 2896 2288 1952 560 nil 27 3202 0 518 #{Graphics.Rectangle} 210 21 21 210 21 21 nil nil nil nil 13891 nil nil 210 1201 1191 210 721 591 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil 8 2011790800 370 50 2 418 #createAt:extent: 50 2 210 6143 21 210 761 921 32 418 #text: 50 1 8 'Registered Components' 32 498 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 123 13 0 0 214 1 0 0] 50 2 576 272 560 nil 27)! !
!Tools.AXTypeLibraryPrompter class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

