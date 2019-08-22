"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #HelpImagesCreationTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HelpImagesCreationTest guid: (GUID fromString: '{69e9952f-6704-4c28-bc09-f93e64883bad}')!
HelpImagesCreationTest comment: ''!
!HelpImagesCreationTest categoriesForClass!Unclassified! !
!HelpImagesCreationTest methodsFor!

createImageOfIcon: anIcon filename: filename 
	| image bitmap |
	bitmap := Bitmap displayCompatibleWithExtent: anIcon extent.
	(bitmap canvas)
		backcolor: Color white;
		erase.
	anIcon drawOn: bitmap canvas.
	image := GdiplusBitmap extent: anIcon extent.
	bitmap 
		drawOnGraphics: image graphics
		at: Point zero
		extent: anIcon extent
		from: Point zero
		extent: anIcon extent
		unit: nil
		attributes: nil.
	"Ensure the directory exists or the save will fail"
	File createDirectoryPath: (File splitPathFrom: filename).
	image saveToFile: (FileLocator imageRelative localFileSpecFor: 'Help\Images\' , filename , '.png')!

createImageOfIconId: aString 
	^self createImageOfIcon: (Icon fromId: aString, '.ico') filename: aString,'Icon'!

createImageOfTool: aClass 
	^self createImageOfTool: aClass using: [:shell | ]!

createImageOfTool: aClass using: aMonadicValuable 
	| tool |
	tool := aClass show topShell.
	tool extent: self defaultToolExtent.
	aMonadicValuable value: tool.
	SessionManager inputState pumpMessages.
	tool view saveHelpImageNamed: tool class name.
	self createImagesOfSubPresentersIn: tool.
	tool exit!

createImagesOfSubPresentersIn: tool 
	"Special case for scrolling decorators"

	(tool respondsTo: #subPresenters) ifFalse: [^self].
	tool subPresenters do: 
			[:each | 
			| viewToSave subname |
			viewToSave := each view.
			(viewToSave parentView isKindOf: CardContainer) 
				ifTrue: [viewToSave := viewToSave parentView parentView].
			each ensureVisible.
			subname := tool nameOf: each.
			viewToSave extent y < 4096 
				ifTrue: 
					[viewToSave saveHelpImageNamed: tool class name , '_' , subname.
					self createImagesOfSubPresentersIn: each]]!

defaultToolExtent
	^800	@ 600!

expandPackageDependentsOf: aPackageBrowserShell 
	| dependentsPresenter treePresenter |
	dependentsPresenter := aPackageBrowserShell instVarNamed: 'dependentsPresenter'.
	treePresenter := dependentsPresenter instVarNamed: 'treePresenter'.
	treePresenter ensureVisible.
	treePresenter selectionOrNil: treePresenter model asArray second!

expandPackagePrerequisitesOf: aPackageBrowserShell 
	| prereqsPresenter treePresenter |
	prereqsPresenter := aPackageBrowserShell instVarNamed: 'prerequisitesPresenter'.
	prereqsPresenter ensureVisible.
	treePresenter := prereqsPresenter instVarNamed: 'treePresenter'.
	treePresenter selectionOrNil: treePresenter model asArray second!

renameHelpImage: filename1 to: filename2 
	| path1 path2 |
	path1 := FileLocator imageRelative localFileSpecFor: 'Help\Images\' , filename1 , '.png'.
	path2 := FileLocator imageRelative localFileSpecFor: 'Help\Images\' , filename2 , '.png'.
	[File delete: path2] on: Error do: [:x | ].
	File rename: path1 to: path2!

saveIconImagesInFolder: folderPresenter 
	1 to: folderPresenter list size
		do: 
			[:n | 
			| rect |
			rect := folderPresenter view itemRect: n.
			folderPresenter view saveHelpImageRect: rect named: (folderPresenter list at: n) description]!

testChat
	| chat |
	chat := Chat show.
	chat topShell view extent: 480 @ 340.
	(chat instVarNamed: 'calleeAddress') value: 'MOLLY'.
	chat topShell view saveHelpImageNamed: 'Chat'.
	chat topShell exit!

testDbConnection
	| connection rs inspector |
	connection := (DBConnection new)
				dsn: 'NWind';
				connect.
	rs := connection query: 'select * from Orders'.
	inspector := rs inspect.
	inspector renderers first selectionPath: #(#yourself 3 'CustomerID').
	inspector extent: self defaultToolExtent.
	inspector view saveHelpImageNamed: 'DBResultSet Inspector'.
	inspector exit!

testDebugger
	| debuggerProcess debuggerShell |
	Debugger showWalkbacks: false.
	debuggerProcess := 
			["Breakpoint here"
			self halt] forkAt: Processor userInterruptPriority.
	Debugger showWalkbacks: true.
	debuggerShell := debuggerProcess debugger.
	debuggerShell extent: self defaultToolExtent.
	SessionManager inputState pumpMessages.
	debuggerShell view saveHelpImageNamed: debuggerShell class name.
	self createImagesOfSubPresentersIn: debuggerShell.
	debuggerShell exit!

testDeploymentWizard
	| package adw cards |
	package := Package manager packageNamed: 'Hello World'.
	adw := ApplicationDeploymentWizard showOn: package imageStripper.
	cards := adw view subViews first.
	1 to: 6
		do: 
			[:n | 
			adw view saveHelpImageNamed: 'ApplicationDeplomentWizard_Page_' , n displayString.
			cards nextCard].
	adw exit!

testIcons
	"Images of class icons"

	self createImageOfIconId: 'CompiledMethod_Public'.
	self createImageOfIconId: 'CompiledMethod_Private'.
	self createImageOfIconId: 'CompiledMethod_Deprecated'.
	self createImageOfIconId: 'CompileFailedMethod'.
	self createImageOfIconId: 'MethodProtocol'.
	self createImageOfIconId: 'MethodProtocol_ANSI'.
	self createImageOfIconId: 'MethodProtocol_ReadOnly'.
	self createImageOfIconId: 'Changed'.
	self createImageOfIconId: 'LintPass'.
	self createImageOfIconId: 'LintInfo'.
	self createImageOfIconId: 'LintWarning'.
	self createImageOfIconId: 'LintError'.
	self createImageOfIconId: 'HistoryBack'.
	self createImageOfIconId: 'HistoryForward'.
	self createImageOfIconId: 'MovePrior'.
	self createImageOfIconId: 'MoveNext'.
	self createImageOfIconId: 'Package'.
	self createImageOfIconId: 'StsPackageEdition'.
	self createImageOfIcon: SmalltalkSystem icon filename: 'BeachBall'.
	self createImageOfIcon: Object icon filename: 'Object'.
	self createImageOfIcon: Model icon filename: 'Model'.
	self createImageOfIcon: View icon filename: 'View'.
	self createImageOfIcon: Presenter icon filename: 'Presenter'.
	self createImageOfIcon: Icon warning filename: 'Warning'!

testInspector
	| inspector |
	inspector := View desktop rectangle inspect.
	inspector renderers first selectionPath: #(#yourself).
	inspector extent: 780 @ 200.
	inspector view saveHelpImageNamed: 'FlipperInspector'.
	inspector extent: 480 @ 200.
	self createImagesOfSubPresentersIn: inspector.
	inspector exit!

testPersonalMoney
	| personalMoneyShell accountShell transactionDialog |
	personalMoneyShell := PersonalMoneyShell show.
	personalMoneyShell setDocumentData: (Object 
				fromBinaryStoreBytes: #[33 83 84 66 32 51 32 70 3 13 0 1 0 0 0 80 101 114 115 111 110 97 108 77 111 110 101 121 0 0 0 0 82 0 0 0 15 0 0 0 65 114 116 104 117 114 32 69 114 105 99 115 115 111 110 70 3 9 0 2 0 0 0 76 105 115 116 77 111 100 101 108 202 0 0 0 208 0 0 0 98 0 0 0 3 0 0 0 70 6 15 0 1 0 0 0 80 101 114 115 111 110 97 108 65 99 99 111 117 110 116 0 0 0 0 82 0 0 0 8 0 0 0 78 97 116 32 87 101 115 116 82 0 0 0 9 0 0 0 48 49 48 49 50 51 52 53 54 54 0 5 0 70 108 111 97 116 8 0 0 0 164 112 61 10 215 145 149 64 194 1 0 0 14 3 24 0 83 84 66 83 111 114 116 101 100 67 111 108 108 101 99 116 105 111 110 80 114 111 120 121 154 0 0 0 82 0 0 0 7 0 0 0 68 111 108 112 104 105 110 82 0 0 0 16 0 0 0 83 111 114 116 101 100 67 111 108 108 101 99 116 105 111 110 98 0 0 0 2 0 0 0 70 5 26 0 1 0 0 0 80 101 114 115 111 110 97 108 65 99 99 111 117 110 116 84 114 97 110 115 97 99 116 105 111 110 0 0 0 0 6 1 4 0 68 97 116 101 71 43 1 0 82 0 0 0 9 0 0 0 70 72 75 32 83 104 111 101 115 66 2 0 0 8 0 0 0 143 194 245 40 92 63 84 64 16 0 0 0 210 2 0 0 0 0 0 0 242 2 0 0 71 43 1 0 82 0 0 0 17 0 0 0 87 97 116 101 114 109 97 110 39 115 32 45 32 83 117 105 116 133 3 0 0 16 0 0 0 102 5 12 0 3 0 0 0 66 108 111 99 107 67 108 111 115 117 114 101 0 0 0 0 0 0 0 0 38 5 14 0 67 111 109 112 105 108 101 100 77 101 116 104 111 100 8 0 0 0 3 0 0 0 0 2 0 0 178 0 0 0 10 0 0 0 105 110 105 116 105 97 108 105 122 101 163 248 178 26 114 0 0 0 20 0 0 0 29 82 30 208 5 84 31 32 36 115 226 4 226 36 130 106 181 182 85 101 82 0 0 0 11 0 0 0 78 101 119 32 97 99 99 111 117 110 116 66 2 0 0 8 0 0 0 0 0 0 0 0 0 0 0 192 1 0 0 144 2 0 0 178 0 0 0 4 0 0 0 100 97 116 101 178 0 0 0 10 0 0 0 115 111 114 116 66 108 111 99 107 58 178 0 0 0 3 0 0 0 111 110 58 112 3 0 0 23 0 0 0 1 2 0 0 0 0 0 0 0 0 0 0 14 2 17 0 83 84 66 83 105 110 103 108 101 116 111 110 80 114 111 120 121 154 0 0 0 160 2 0 0 82 0 0 0 12 0 0 0 83 101 97 114 99 104 80 111 108 105 99 121 178 0 0 0 8 0 0 0 105 100 101 110 116 105 116 121 66 2 0 0 8 0 0 0 246 40 92 143 194 139 138 64 2 2 0 0 0 0 0 0 82 0 0 0 38 0 0 0 65 98 98 101 121 32 73 110 116 101 114 110 97 116 105 111 110 97 108 32 45 32 66 117 105 108 100 105 110 103 32 83 111 99 105 101 116 121 82 0 0 0 7 0 0 0 65 73 53 54 55 52 51 145 95 1 0 194 1 0 0 122 2 0 0 144 2 0 0 98 0 0 0 0 0 0 0 112 3 0 0 0 0 0 0 32 4 0 0 145 95 1 0 2 2 0 0 0 0 0 0 82 0 0 0 4 0 0 0 86 105 115 97 82 0 0 0 19 0 0 0 52 53 52 52 32 50 52 53 54 32 55 56 51 52 32 50 51 52 49 66 2 0 0 8 0 0 0 51 51 51 51 51 135 124 64 194 1 0 0 122 2 0 0 144 2 0 0 192 4 0 0 112 3 0 0 0 0 0 0 32 4 0 0 0 5 0 0 0 0 0 0 32 4 0 0]).
	personalMoneyShell view saveHelpImageNamed: 'PersonalMoneyShell'.
	(personalMoneyShell instVarNamed: 'accountsPresenter') selectionByIndex: 1.
	personalMoneyShell editAccount.
	accountShell := View active topShell.
	accountShell view saveHelpImageNamed: 'PersonalAccountShell'.
	(accountShell instVarNamed: 'transactionsPresenter') selectionByIndex: 1.
	transactionDialog := PersonalAccountTransactionDialog 
				showOn: (accountShell instVarNamed: 'transactionsPresenter') selectionOrNil.
	transactionDialog view saveHelpImageNamed: 'PersonalAccountTransactionDialog'.
	transactionDialog exit.
	accountShell exit.
	personalMoneyShell exit!

testPlayground
	| playground charlie teresa simon workspace |
	playground := Playground new.
	playground extent: 480 @ 320.
	charlie := playground add: Circle new.
	teresa := playground add: Triangle new.
	simon := playground add: Square new.
	simon moveUp: 8.
	teresa growBy: 10.
	teresa moveLeft: 5.
	simon moveRight: 5.
	charlie moveUp: -5.
	playground view saveHelpImageNamed: 'Playground'.
	playground exit.
	workspace := SmalltalkWorkspaceDocument show.
	workspace extent: 640 @ 380.
	workspace 
		setDocumentData: '
playground := Playground new.

charlie := playground add: Circle new.
teresa := playground add: Triangle new.
simon := playground add: Square new.

simon moveUp: 8.
teresa growBy: 10.
teresa moveLeft: 5.
simon moveRight: 5.
charlie moveUp: -5'.
	workspace view saveHelpImageNamed: 'Playground_Workspace'.
	workspace exit!

testProgrammingInSmalltalk
	| chb |
	chb := ClassBrowserShell show.
	chb extent: 800 @ 600.
	chb actualClass: Object.
	(chb instVarNamed: 'classesPresenter') view saveHelpImageNamed: 'CHB_ObjectHierarchy'.
	chb actualClass: String.
	(chb instVarNamed: 'methodBrowserPresenter') methodsPresenter view 
		saveHelpImageNamed: 'CHB_StringMethods'.
	chb exit!

testSmalltalkTools
	"Images of all SmalltalkToolShell subclasses"

	"Tools that need special configuration"

	| classBrowserId |
	classBrowserId := ResourceIdentifier class: ClassBrowserShell name: 'Default view'.
	self createImageOfTool: MethodExplorerShell
		using: 
			[:shell | 
			shell methods: (SelectorEnvironment implementorsOf: #createComponents in: BrowserEnvironment new)].
	self renameHelpImage: 'MethodBrowser_methods' to: 'MethodExplorerShell_methods'.
	self renameHelpImage: 'MethodBrowser_source' to: 'MethodExplorerShell_source'.
	self createImageOfTool: EnvironmentBrowserShell
		using: 
			[:shell | 
			shell
				browseExecutableManifestFile: (FileLocator installRelative 
							localFileSpecFor: 'Help\Hello World.xml');
				method: (HelloWorld compiledMethodAt: #onPaintRequired:);
				ensureSourceVisible].
	"Do these two after the EnvBrowser to get proper contents in sub view images"
	self createImageOfTool: ClassBrowserShell
		using: [:shell | shell method: (Presenter compiledMethodAt: #createView:)].
	self createImageOfTool: SystemBrowserShell
		using: [:shell | shell method: (Presenter compiledMethodAt: #createView:)].
	self createImageOfTool: ProcessMonitor using: [:shell | shell extent: 400 @ 200].
	"View Composer image needs manual creation since the contents don't appear correctly"
	self createImageOfTool: ViewComposer
		using: 
			[:shell | 
			shell openOn: (ResourceIdentifier class: ClassBrowserShell).
			(shell instVarNamed: 'toolboxPresenter') selection: classBrowserId.
			(shell instVarNamed: 'inspector') selectionPath: #(#yourself #extent)].
	Transcript
		nextPutAll: 'Manually create ViewComposer image please';
		cr.
	self createImageOfTool: PackageBrowserShell
		using: 
			[:shell | 
			shell
				extent: 800 @ 400;
				packages: (Array with: (Package manager packageNamed: 'Development System')).
			self
				expandPackagePrerequisitesOf: shell;
				expandPackageDependentsOf: shell].
	self createImageOfTool: ProtocolBrowserShell
		using: 
			[:shell | 
			shell extent: 650 @ 400.
			(shell instVarNamed: 'protocolsPresenter') selectionByIndex: 3].
	self createImageOfTool: SmalltalkWorkspaceDocument using: [:shell | shell extent: 640 @ 320].
	self createImageOfTool: ResourceBrowser
		using: [:shell | shell resourceToolboxPresenter selection: classBrowserId].
	self createImageOfTool: IdeaSpaceShell using: [:shell | ].

	"Tools that should be givenh a default size"
	#(#ClassHierarchyDiagram) 
		do: [:eachToolClass | self createImageOfTool: (Smalltalk at: eachToolClass)].
	"Tools that should use their own size"
	#() do: [:eachToolClass | self createImageOfTool: (Smalltalk at: eachToolClass) using: [:x | ]]!

testSystemFolder
	"Images of System Folder"

	"Standard system folder image"

	| folderPresenter smalltalkSystemShell poolDictionaryInspector stsTools samples additionalTools originalExtent |
	smalltalkSystemShell := SmalltalkSystemShell default.
	folderPresenter := smalltalkSystemShell instVarNamed: 'systemFolderPresenter'.
	folderPresenter expand: nil.
	(SmalltalkSystemShell default)
		caption: (DolphinProfessional new fullName, ' - Dolphin.img');
		view saveHelpImageNamed: 'SystemFolder';
		updateCaption.

	"Client only image"
	folderPresenter resetSelection.
	(folderPresenter view)
		lvmSetBkImage: LVBKIMAGEW new;
		backcolor: (Color 
					red: 41
					green: 124
					blue: 182).
	folderPresenter view saveHelpImageNamed: 'SystemFolderClient'.
	originalExtent := folderPresenter topShell view extent.
	folderPresenter topShell view extent: 1000 @ 500.
	"stsTools := folderPresenter list detect: [:each | each description = 'Source Tracking Tools']."
	samples := folderPresenter list detect: [:each | each description = 'Sample Applications'].
	additionalTools := folderPresenter list detect: [:each | each description = 'Additional Tools'].
	"Top level icon images"
	self saveIconImagesInFolder: folderPresenter.
	"Source Tracking Tools images"
	"folderPresenter expand: stsTools.
	self saveIconImagesInFolder: folderPresenter."
	"Samples images"
	folderPresenter expand: samples.
	self saveIconImagesInFolder: folderPresenter.
	"Additional Tools images"
	folderPresenter expand: additionalTools.
	self saveIconImagesInFolder: folderPresenter.

	"Restore original system folder options"
	folderPresenter expand: nil.
	folderPresenter topShell view extent: originalExtent.
	smalltalkSystemShell applyOptions.

	"Pool Dictionary inspector"
	poolDictionaryInspector := SmalltalkSystem current inspectPoolDictionaries.
	poolDictionaryInspector
		object: Win32Constants;
		extent: 580 @ 460;
		view saveHelpImageNamed: 'PoolDictionaryInspector'.
	poolDictionaryInspector topShell exit! !
!HelpImagesCreationTest categoriesFor: #createImageOfIcon:filename:!private! !
!HelpImagesCreationTest categoriesFor: #createImageOfIconId:!private! !
!HelpImagesCreationTest categoriesFor: #createImageOfTool:!private! !
!HelpImagesCreationTest categoriesFor: #createImageOfTool:using:!private! !
!HelpImagesCreationTest categoriesFor: #createImagesOfSubPresentersIn:!private! !
!HelpImagesCreationTest categoriesFor: #defaultToolExtent!private! !
!HelpImagesCreationTest categoriesFor: #expandPackageDependentsOf:!private! !
!HelpImagesCreationTest categoriesFor: #expandPackagePrerequisitesOf:!private! !
!HelpImagesCreationTest categoriesFor: #renameHelpImage:to:!private! !
!HelpImagesCreationTest categoriesFor: #saveIconImagesInFolder:!private! !
!HelpImagesCreationTest categoriesFor: #testChat!public! !
!HelpImagesCreationTest categoriesFor: #testDbConnection!public! !
!HelpImagesCreationTest categoriesFor: #testDebugger!public! !
!HelpImagesCreationTest categoriesFor: #testDeploymentWizard!public! !
!HelpImagesCreationTest categoriesFor: #testIcons!public! !
!HelpImagesCreationTest categoriesFor: #testInspector!public! !
!HelpImagesCreationTest categoriesFor: #testPersonalMoney!public! !
!HelpImagesCreationTest categoriesFor: #testPlayground!public! !
!HelpImagesCreationTest categoriesFor: #testProgrammingInSmalltalk!public! !
!HelpImagesCreationTest categoriesFor: #testSmalltalkTools!public! !
!HelpImagesCreationTest categoriesFor: #testSystemFolder!public! !

