"Filed out from Dolphin Smalltalk 7"!

UI.ValueDialog subclass: #'Tools.AXTypeLibraryPrompter'
	instanceVariableNames: 'typeLibs path guidPresenter'
	classVariableNames: ''
	imports: #()
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
	self value: (reg isNil ifFalse: [Smalltalk.AXTypeLibraryAnalyzer fromRegistration: reg]).
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
			path value: (Smalltalk.ITypeLib
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
	typelib := Smalltalk.AXTypeLibraryAnalyzer open.
	typelib notNil ifTrue: [
		self value: typelib.
		super ok]

!

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

	currentTypeLibs := Smalltalk.AXTypeLibraryAnalyzer allTypeLibs collect: [:each | each registration ].
	registrations := Smalltalk.AXTypeLibraryAnalyzer typeLibRegistrations.
	registrations := registrations difference: currentTypeLibs.
	typeLibs list: registrations asSortedCollection.
	self onTypeLibrarySelected
! !
!Tools.AXTypeLibraryPrompter categoriesFor: #createComponents!initializing!public! !
!Tools.AXTypeLibraryPrompter categoriesFor: #createSchematicWiring!initializing!public! !
!Tools.AXTypeLibraryPrompter categoriesFor: #ok!commands!public! !
!Tools.AXTypeLibraryPrompter categoriesFor: #onTypeLibraryChosen!event handling!private! !
!Tools.AXTypeLibraryPrompter categoriesFor: #onTypeLibrarySelected!event handling!private! !
!Tools.AXTypeLibraryPrompter categoriesFor: #onViewOpened!event handling!private! !
!Tools.AXTypeLibraryPrompter categoriesFor: #openTypeLib!commands!public! !
!Tools.AXTypeLibraryPrompter categoriesFor: #queryCommand:!commands!private! !
!Tools.AXTypeLibraryPrompter categoriesFor: #refresh!commands!private! !

!Tools.AXTypeLibraryPrompter class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 165 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 ##(Graphics.Point) 193 193 nil 416 984838 ##(UI.BorderLayout) 1 1 nil 410 ##(UI.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Presenter) #resource_OK_Cancel_button_block nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 21 743 578 689 81 640 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 115 1 0 0 98 1 0 0 155 1 0 0] 8 #() 578 193 193 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 960 nil nil nil 7 nil nil nil 960 1048838 ##(UI.FramingLayout) 170 176 34 12 410 ##(UI.StaticText) 34 16 nil 960 34 2 8 1140850946 1 1088 nil nil nil 7 nil nil nil 1088 nil 8 1801195232 1049094 ##(UI.NullConverter) nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 657 578 111 41 1088 802 #text: 34 1 8 '&GUID:' 1088 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 72 1 0 0 55 0 0 0 92 1 0 0] 8 #() 944 nil 27 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedParentLeft 1 1442 #fixedViewLeft 111 1442 #fixedViewBottom -39 1442 #fixedParentBottom -25 410 ##(UI.StaticText) 34 16 nil 960 34 2 8 1140850944 1 1520 nil nil nil 7 nil nil nil 1520 nil 8 1801195232 1170 nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 131 657 578 561 41 1520 802 #text: 34 1 8 'GUID of selected library here...' 1520 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 72 1 0 0 89 1 0 0 92 1 0 0] 8 #() 944 nil 27 1410 1456 131 1472 561 1488 -39 1504 -25 410 ##(UI.PushButton) 34 20 nil 960 34 2 8 1140924416 1 1840 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 1840 nil 8 1801347024 1377606 4 ##(UI.CommandDescription) #openTypeLib 8 '&Open...' 1 1 nil nil false nil nil nil 738 138 144 34 3 802 #createAt:extent: 34 2 578 535 507 578 141 51 1840 802 #isEnabled: 8 #(false) 1840 802 #text: 34 1 8 '&Open...' 1840 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 1 0 0 253 0 0 0 81 1 0 0 22 1 0 0] 8 #() 944 nil 29 1410 1442 #fixedViewRight -139 1442 #fixedParentRight -13 1488 -49 1504 -165 410 ##(UI.ListView) 34 45 nil 960 34 2 8 1140953165 1025 2288 787270 2 ##(UI.ListModel) 138 144 928 nil 1769478 ##(Kernel.IdentitySearchPolicy) 1920 nil 7 nil nil nil 2288 nil 8 1801282304 786950 ##(Core.Message) #description 8 #() nil 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil nil 138 144 34 2 1117254 5 ##(UI.ListViewColumn) 8 'Library' 565 #left ##(UI.BasicListAbstract) 2450 #<= 8 #() 2450 #description 8 #() nil 2288 nil 3 nil nil 2562 8 'Version' 105 #left ##(UI.BasicListAbstract) 2450 #<= 8 #() 2450 #versionString 2656 nil 2288 nil 1 nil nil #report 8 #() nil 131137 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 1 578 685 487 2288 802 #text: 34 1 8 'Library' 2288 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 1 0 0 243 0 0 0] 8 #() 944 nil 35 1410 1456 1 2272 -3 1442 #fixedParentTop 1 1504 -235 410 ##(UI.StaticText) 34 16 nil 960 34 2 8 1140850944 1 3008 nil nil nil 7 nil nil nil 3008 nil 8 1801195232 1170 nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 131 577 578 561 61 3008 802 #text: 34 1 8 'Path of selected library here...on two lines if necessary to get the whole path to fit.' 3008 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 32 1 0 0 89 1 0 0 62 1 0 0] 8 #() 944 nil 27 1410 1456 131 1472 561 1488 -59 1504 -85 410 ##(UI.StaticText) 34 16 nil 960 34 2 8 1140850946 1 3328 nil nil nil 7 nil nil nil 3328 nil 8 1801195232 1170 nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 577 578 111 51 3328 802 #text: 34 1 8 '&Location:' 3328 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 32 1 0 0 55 0 0 0 57 1 0 0] 8 #() 944 nil 27 1410 1456 1 1472 111 1488 -49 1504 -95 170 192 34 6 2288 8 'typeLibs' 3008 8 'libraryPath' 1520 8 'guid' nil 738 138 144 34 1 802 #createAt:extent: 34 2 578 21 21 578 689 723 960 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 98 1 0 0 115 1 0 0] 34 6 2288 1840 3328 3008 1088 1520 944 nil 27 170 192 928 1180166 ##(Graphics.Rectangle) 578 21 21 578 21 21 nil nil nil nil 28733 nil nil 578 1201 1191 578 721 591 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 nil 8 1996777232 738 138 144 34 2 802 #createAt:extent: 34 2 578 6143 21 578 761 921 416 802 #text: 34 1 8 'Registered Components' 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 123 13 0 0 214 1 0 0] 34 2 960 640 944 nil 27 )! !
!Tools.AXTypeLibraryPrompter class categoriesFor: #resource_Default_view!public!resources-views! !

