"Filed out from Dolphin Smalltalk 7"!

ValueDialog subclass: #AXTypeLibraryPrompter
	instanceVariableNames: 'typeLibs path guidPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AXTypeLibraryPrompter guid: (GUID fromString: '{4febe003-3945-11d3-9fe6-00a0cc3e4a32}')!
AXTypeLibraryPrompter comment: 'AXTypeLibraryPrompter is a <valueDialogPresenter> that can be used to prompt for a COM component type library to install into the image. Its displays a list of all the registered type libraries (including those already installed) and also gives the user an opportunity to load a type library directly from a DLL, OCX, EXE, or TLB file. The subject <valueModel> is filled with an instance of AXTypeLibrary representing the chosen library when the dialogue is confirmed.

Note that the prompter takes care not to actually load the type libraries until the user chooses one.

Example:
	AXTypeLibraryPrompter showModal "Display it"

Instance Variables:
	typeLibs		<ListPresenter> displaying a list of <AXTypeLibRegistration>s.
	path		<TextPresenter> displaying the path to the chosen type library.

'!
!AXTypeLibraryPrompter categoriesForClass!Development!MVP-Presenters! !
!AXTypeLibraryPrompter methodsFor!

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
	self value: (reg isNil ifFalse: [AXTypeLibraryAnalyzer fromRegistration: reg]).
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
					on: HRESULTError
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
	typelib := AXTypeLibraryAnalyzer open.
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

	currentTypeLibs := AXTypeLibraryAnalyzer allTypeLibs collect: [:each | each registration ].
	registrations := AXTypeLibraryAnalyzer typeLibRegistrations.
	registrations := registrations difference: currentTypeLibs.
	typeLibs list: registrations asSortedCollection.
	self onTypeLibrarySelected
! !
!AXTypeLibraryPrompter categoriesFor: #createComponents!initializing!public! !
!AXTypeLibraryPrompter categoriesFor: #createSchematicWiring!initializing!public! !
!AXTypeLibraryPrompter categoriesFor: #ok!commands!public! !
!AXTypeLibraryPrompter categoriesFor: #onTypeLibraryChosen!event handling!private! !
!AXTypeLibraryPrompter categoriesFor: #onTypeLibrarySelected!event handling!private! !
!AXTypeLibraryPrompter categoriesFor: #onViewOpened!event handling!private! !
!AXTypeLibraryPrompter categoriesFor: #openTypeLib!commands!public! !
!AXTypeLibraryPrompter categoriesFor: #queryCommand:!commands!private! !
!AXTypeLibraryPrompter categoriesFor: #refresh!commands!private! !

!AXTypeLibraryPrompter class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26738689 131073 416 0 721158 ##(Smalltalk.SystemColor)  31 0 167 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 204 53 87 1 3 0 34 59 0 0 0 0 15 1 31 86 135 1] 328198 ##(Smalltalk.Point)  193 193 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 656 0 482 31 0 7 0 0 0 656 626 1 1 410 8 ##(Smalltalk.StaticRectangle)  98 14 0 656 98 2 8 1140850951 262145 768 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 7 0 0 0 768 0 8 4294903625 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 594 1 1 594 705 5 768 978 8 #isEnabled: 98 1 32 768 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 96 1 0 0 2 0 0 0] 98 0 594 193 193 0 27 410 8 ##(Smalltalk.ReferenceView)  98 14 0 656 98 2 8 1140850688 131073 1200 0 0 0 7 0 0 0 1200 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.Presenter)  8 #resource_OK_Cancel_button_block 0 914 202 208 98 1 978 1008 98 2 594 1 1 594 705 81 1200 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 96 1 0 0 40 0 0 0] 98 0 1184 0 27 0 0 0 234 256 1488 0 914 202 208 98 2 978 1008 98 2 594 21 753 594 705 81 656 978 8 #text: 98 1 8 'Buttons' 656 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 120 1 0 0 106 1 0 0 160 1 0 0] 98 2 768 1200 1184 0 27 0 0 410 672 98 15 0 416 98 2 8 1140850688 131073 1744 0 482 31 0 7 0 0 0 1744 852230 ##(Smalltalk.FramingLayout)  234 240 98 12 410 8 ##(Smalltalk.StaticText)  98 16 0 1744 98 2 8 1140850944 1 1888 0 0 0 7 0 0 0 1888 0 8 4294903625 852486 ##(Smalltalk.NullConverter)  0 0 0 914 202 208 98 2 978 1008 98 2 594 131 667 594 561 41 1888 978 1648 98 1 8 'GUID of selected library here...' 1888 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 77 1 0 0 89 1 0 0 97 1 0 0] 98 0 1184 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedParentLeft 131 2258 8 #fixedViewLeft 561 2258 8 #fixedViewBottom -39 2258 8 #fixedParentBottom -25 410 1904 98 16 0 1744 98 2 8 1140850946 1 2400 0 0 0 7 0 0 0 2400 0 8 4294903625 1986 0 0 0 914 202 208 98 2 978 1008 98 2 594 1 667 594 111 41 2400 978 1648 98 1 8 '&GUID:' 2400 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 77 1 0 0 55 0 0 0 97 1 0 0] 98 0 1184 0 27 2226 2272 1 2304 111 2336 -39 2368 -25 410 8 ##(Smalltalk.ListView)  98 30 0 1744 98 2 8 1140953165 1025 2720 590662 2 ##(Smalltalk.ListModel)  202 208 1488 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  850 880 0 7 0 0 0 2720 0 8 4294903801 459270 ##(Smalltalk.Message)  8 #description 98 0 0 1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 0 202 208 98 2 920646 5 ##(Smalltalk.ListViewColumn)  8 'Library' 597 8 #left 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.SortedCollection)  2914 2944 98 0 0 2720 0 3 0 0 3042 8 'Version' 97 3088 3104 3120 2914 8 #versionString 3152 0 2720 0 1 0 0 8 #report 1488 0 131137 0 0 914 202 208 98 2 978 1008 98 2 594 1 1 594 701 497 2720 978 1648 98 1 8 'Library' 2720 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 248 0 0 0] 98 0 1184 0 27 2226 2272 1 2258 8 #fixedParentRight -3 2258 8 #fixedParentTop 1 2368 -235 410 8 ##(Smalltalk.PushButton)  98 17 0 1744 98 2 8 1140924416 1 3536 0 850 880 0 7 0 0 0 3536 0 8 4294903631 1180998 4 ##(Smalltalk.CommandDescription)  8 #openTypeLib 8 '&Open...' 1 1 0 0 32 914 202 208 98 3 978 1008 98 2 594 551 517 594 141 51 3536 978 1088 98 1 32 3536 978 1648 98 1 8 '&Open...' 3536 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 19 1 0 0 2 1 0 0 89 1 0 0 27 1 0 0] 98 0 1184 0 27 2226 2258 8 #fixedViewRight -139 3472 -13 2336 -49 2368 -165 410 1904 98 16 0 1744 98 2 8 1140850944 1 4000 0 0 0 7 0 0 0 4000 0 8 4294903625 1986 0 0 0 914 202 208 98 2 978 1008 98 2 594 131 587 594 561 61 4000 978 1648 98 1 8 'Path of selected library here...on two lines if necessary to get the whole path to fit.' 4000 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 37 1 0 0 89 1 0 0 67 1 0 0] 98 0 1184 0 27 2226 2272 131 2304 561 2336 -59 2368 -85 410 1904 98 16 0 1744 98 2 8 1140850946 1 4320 0 0 0 7 0 0 0 4320 0 8 4294903625 1986 0 0 0 914 202 208 98 2 978 1008 98 2 594 1 587 594 111 51 4320 978 1648 98 1 8 '&Location:' 4320 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 37 1 0 0 55 0 0 0 62 1 0 0] 98 0 1184 0 27 2226 2272 1 2304 111 2336 -49 2368 -95 234 256 98 6 1888 8 'guid' 2720 8 'typeLibs' 4000 8 'libraryPath' 0 914 202 208 98 1 978 1008 98 2 594 21 21 594 705 733 1744 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 106 1 0 0 120 1 0 0] 98 6 2720 3536 4320 4000 2400 1888 1184 0 27 234 256 1488 590342 ##(Smalltalk.Rectangle)  594 21 21 594 21 21 0 0 0 0 32759 0 0 594 1201 1191 594 721 591 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 2010572111 914 202 208 98 3 978 1008 98 2 594 2799 21 594 761 921 416 978 1648 98 1 8 'Registered Components' 416 978 8 #updateMenuBar 1488 416 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 243 6 0 0 214 1 0 0] 98 2 1744 656 1184 0 27 )! !
!AXTypeLibraryPrompter class categoriesFor: #resource_Default_view!public!resources-views! !

