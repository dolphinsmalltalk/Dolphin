"Filed out from Dolphin Smalltalk"!

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

!AXTypeLibraryPrompter categoriesForClass!MVP-Presenters! !

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

!AXTypeLibraryPrompter categoriesForMethods!
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

!AXTypeLibraryPrompter class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 608 nil nil nil 5 nil nil nil 608 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[10 0 0 0 115 1 0 0 98 1 0 0 155 1 0 0] 193 640 8 '' 608 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 960 nil nil nil 5 nil nil nil 960 852230 ##(Smalltalk.FramingLayout) 170 176 34 12 410 ##(Smalltalk.StaticText) 34 16 nil 960 34 2 8 1140850944 1 1088 nil nil nil 5 nil nil nil 1088 nil 8 1759212608 852486 ##(Smalltalk.NullConverter) nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[65 0 0 0 32 1 0 0 89 1 0 0 62 1 0 0] 193 1120 nil 1088 770 #text: 34 1 8 'Path of selected library here...on two lines if necessary to get the whole path to fit.' 1088 3 8 #() 930 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 131 1442 #fixedViewLeft 561 1442 #fixedViewBottom -59 1442 #fixedParentBottom -85 410 ##(Smalltalk.ListView) 34 45 nil 960 34 2 8 1140953165 1025 1520 590662 2 ##(Smalltalk.ListModel) 138 144 912 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 1520 nil 8 1759068368 459270 ##(Smalltalk.Message) #description 8 #() nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 2 920646 5 ##(Smalltalk.ListViewColumn) 8 'Library' 565 #left ##(Smalltalk.BasicListAbstract) 1714 #<= 8 #() 1714 #description 8 #() nil 1520 nil 3 nil nil 1826 8 'Version' 105 #left ##(Smalltalk.BasicListAbstract) 1714 #<= 8 #() 1714 #versionString 1920 nil 1520 nil 1 nil nil #report 8 #() nil 131137 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 0 0 0 0 86 1 0 0 243 0 0 0] 193 1552 8 'Library' 1520 3 8 #() 930 193 193 nil 35 1410 1456 1 1442 #fixedParentRight -3 1442 #fixedParentTop 1 1504 -235 410 ##(Smalltalk.StaticText) 34 16 nil 960 34 2 8 1140850946 1 2256 nil nil nil 5 nil nil nil 2256 nil 8 1759212608 1170 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 32 1 0 0 55 0 0 0 57 1 0 0] 193 2288 nil 2256 770 #text: 34 1 8 '&Location:' 2256 3 8 #() 930 193 193 nil 27 1410 1456 1 1472 111 1488 -49 1504 -95 410 ##(Smalltalk.StaticText) 34 16 nil 960 34 2 8 1140850944 1 2576 nil nil nil 5 nil nil nil 2576 nil 8 1759212608 1170 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[65 0 0 0 72 1 0 0 89 1 0 0 92 1 0 0] 193 2608 nil 2576 770 #text: 34 1 8 'GUID of selected library here...' 2576 3 8 #() 930 193 193 nil 27 1410 1456 131 1472 561 1488 -39 1504 -25 410 ##(Smalltalk.StaticText) 34 16 nil 960 34 2 8 1140850946 1 2896 nil nil nil 5 nil nil nil 2896 nil 8 1759212608 1170 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 72 1 0 0 55 0 0 0 92 1 0 0] 193 2928 nil 2896 770 #text: 34 1 8 '&GUID:' 2896 3 8 #() 930 193 193 nil 27 1410 1456 1 1472 111 1488 -39 1504 -25 410 ##(Smalltalk.PushButton) 34 20 nil 960 34 2 8 1140924416 1 3216 nil 1680 nil 5 nil nil nil 3216 nil 8 1759007584 1180998 4 ##(Smalltalk.CommandDescription) #openTypeLib 8 '&Open...' 1 1 nil nil false nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[11 1 0 0 253 0 0 0 81 1 0 0 22 1 0 0] 193 3248 8 '&Open...' 3216 770 #isEnabled: 8 #(false) 3216 3 8 #() 930 193 193 nil 29 1410 1442 #fixedViewRight -139 2224 -13 1488 -49 1504 -165 170 192 34 6 2576 8 'guid' 1520 8 'typeLibs' 1088 8 'libraryPath' nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[10 0 0 0 10 0 0 0 98 1 0 0 115 1 0 0] 193 992 8 '' 960 3 34 6 1520 3216 2256 1088 2896 2576 930 193 193 nil 27 170 192 912 590342 ##(Smalltalk.Rectangle) 930 21 21 930 21 21 nil nil nil nil 10455 nil nil 930 1201 1191 930 721 591 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2006356512 nil nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 3858 930 1 1 930 761 921 193 416 770 #setWindowText: 34 1 8 'Registered Components' 416 1 34 2 960 608 930 193 193 nil 29 )! !

!AXTypeLibraryPrompter class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

