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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 721158 ##(Smalltalk.SystemColor) 31 nil 167 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil 466 31 nil 7 nil nil nil 640 610 1 1 410 ##(Smalltalk.StaticRectangle) 34 14 nil 640 34 2 8 1140850951 262145 736 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 7 nil nil nil 736 nil 8 1906774720 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 1 1 578 689 5 736 930 #isEnabled: 8 #(false) 736 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 578 193 193 nil 27 410 ##(Smalltalk.ReferenceView) 34 14 nil 640 34 2 8 1140850688 131073 1120 nil nil nil 7 nil nil nil 1120 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 866 138 144 34 1 930 #createAt:extent: 34 2 578 1 1 578 689 81 1120 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 40 0 0 0] 8 #() 1104 nil 27 nil nil nil 170 192 1360 nil 866 138 144 34 2 930 #createAt:extent: 34 2 578 21 743 578 689 81 640 930 #text: 34 1 8 'Buttons' 640 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 115 1 0 0 98 1 0 0 155 1 0 0] 34 2 736 1120 1104 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1600 nil 466 31 nil 7 nil nil nil 1600 852230 ##(Smalltalk.FramingLayout) 170 176 34 12 410 ##(Smalltalk.StaticText) 34 16 nil 1600 34 2 8 1140850944 1 1744 nil nil nil 7 nil nil nil 1744 nil 8 1906774720 852486 ##(Smalltalk.NullConverter) nil nil nil 866 138 144 34 2 930 #createAt:extent: 34 2 578 131 657 578 561 41 1744 930 #text: 34 1 8 'GUID of selected library here...' 1744 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 72 1 0 0 89 1 0 0 92 1 0 0] 8 #() 1104 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 131 2098 #fixedViewLeft 561 2098 #fixedViewBottom -39 2098 #fixedParentBottom -25 410 ##(Smalltalk.StaticText) 34 16 nil 1600 34 2 8 1140850946 1 2176 nil nil nil 7 nil nil nil 2176 nil 8 1906774720 1826 nil nil nil 866 138 144 34 2 930 #createAt:extent: 34 2 578 1 657 578 111 41 2176 930 #text: 34 1 8 '&GUID:' 2176 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 72 1 0 0 55 0 0 0 92 1 0 0] 8 #() 1104 nil 27 2066 2112 1 2128 111 2144 -39 2160 -25 410 ##(Smalltalk.PushButton) 34 20 nil 1600 34 2 8 1140924416 1 2496 nil 802 832 nil 7 nil nil nil 2496 nil 8 1906824432 1180998 4 ##(Smalltalk.CommandDescription) #openTypeLib 8 '&Open...' 1 1 nil nil false nil nil nil 866 138 144 34 3 930 #createAt:extent: 34 2 578 535 507 578 141 51 2496 930 #isEnabled: 8 #(false) 2496 930 #text: 34 1 8 '&Open...' 2496 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 1 0 0 253 0 0 0 81 1 0 0 22 1 0 0] 8 #() 1104 nil 29 2066 2098 #fixedViewRight -139 2098 #fixedParentRight -13 2144 -49 2160 -165 410 ##(Smalltalk.StaticText) 34 16 nil 1600 34 2 8 1140850944 1 2928 nil nil nil 7 nil nil nil 2928 nil 8 1906774720 1826 nil nil nil 866 138 144 34 2 930 #createAt:extent: 34 2 578 131 577 578 561 61 2928 930 #text: 34 1 8 'Path of selected library here...on two lines if necessary to get the whole path to fit.' 2928 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 32 1 0 0 89 1 0 0 62 1 0 0] 8 #() 1104 nil 27 2066 2112 131 2128 561 2144 -59 2160 -85 410 ##(Smalltalk.ListView) 34 30 nil 1600 34 2 8 1140953165 1025 3248 590662 2 ##(Smalltalk.ListModel) 138 144 1360 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 802 832 nil 7 nil nil nil 3248 nil 8 1906899344 459270 ##(Smalltalk.Message) #description 8 #() nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 2 920646 5 ##(Smalltalk.ListViewColumn) 8 'Library' 565 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 3426 #description 8 #() nil 3248 nil 3 nil nil 3538 8 'Version' 105 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 3426 #versionString 3600 nil 3248 nil 1 nil nil #report 1360 nil 131137 nil 34 4 nil nil 578 1 1 nil 866 138 144 34 2 930 #createAt:extent: 34 2 578 1 1 578 685 487 3248 930 #text: 34 1 8 'Library' 3248 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 1 0 0 243 0 0 0] 8 #() 1104 nil 27 2066 2112 1 2912 -3 2098 #fixedParentTop 1 2160 -235 410 ##(Smalltalk.StaticText) 34 16 nil 1600 34 2 8 1140850946 1 3936 nil nil nil 7 nil nil nil 3936 nil 8 1906774720 1826 nil nil nil 866 138 144 34 2 930 #createAt:extent: 34 2 578 1 577 578 111 51 3936 930 #text: 34 1 8 '&Location:' 3936 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 32 1 0 0 55 0 0 0 57 1 0 0] 8 #() 1104 nil 27 2066 2112 1 2128 111 2144 -49 2160 -95 170 192 34 6 1744 8 'guid' 3248 8 'typeLibs' 2928 8 'libraryPath' nil 866 138 144 34 1 930 #createAt:extent: 34 2 578 21 21 578 689 723 1600 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 98 1 0 0 115 1 0 0] 34 6 3248 2496 3936 2928 2176 1744 1104 nil 27 170 192 1360 590342 ##(Smalltalk.Rectangle) 578 21 21 578 21 21 nil nil nil nil 21545 nil nil 578 1201 1191 578 721 591 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2010075552 866 138 144 34 3 930 #createAt:extent: 34 2 578 3839 21 578 761 921 416 930 #text: 34 1 8 'Registered Components' 416 930 #updateMenuBar 1360 416 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 251 8 0 0 214 1 0 0] 34 2 1600 640 1104 nil 27 )! !
!AXTypeLibraryPrompter class categoriesFor: #resource_Default_view!public!resources-views! !

