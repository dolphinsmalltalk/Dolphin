"Filed out from Dolphin Smalltalk 2000 release 4.01"!

BrowserTextTool subclass: #BrowserClassTool
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BrowserClassTool comment: ''!

BrowserClassTool guid: (GUID fromString: '{A8B6C1BF-0E73-11D5-B80B-000102677BBF}')!

!BrowserClassTool categoriesForClass!Unclassified! !
!BrowserClassTool methodsFor!

abstractVariable
	| string |
	string := self selectedText.
	(self isInstVar: string) ifTrue: [self abstractInstVar: string].
	(self isClassVar: string) ifTrue: [self abstractClassVar: string]!

accept
	| change |
	change := InteractiveAddClassChange 
				definition: self text
				application: self application
				for: self.
	self performChange: change.
	change definedClass notNil 
		ifTrue: [codeModel setClass: change definedClass]
!

addClassVar
	self navigator addClassVarIn: self selectedClass.
	self updateContents
!

addInstVar
	self navigator addInstVarIn: self selectedClass.
	self updateContents
!

buildInterfaceIn: aWidget

	| textWidget breakpointWidget manager |

	self
		addWidget: (
			textWidget :=
				aWidget
					stsCreateScrolledColorText: 'text'
					argBlock: [:w |
						w
							editMode: XmMULTILINEEDIT;
							scrollHorizontal: false;
							wordWrap: true;
							tabSpacing: EmTextCompatibilityFilter tabSize;
							addCallback: XmNresizeCallback
								receiver: self
								selector: #stsResize:clientData:callData:
								clientData: nil])
		named: #text.
		
	textWidget manageChild.
	self
		addWidget: (
			breakpointWidget :=
				DbgTagWidget
					createWidget: 'breakpoints'
					parent: aWidget
					argBlock: [:w |
						w
							fontStruct: (
								self class fontList isNil
									ifTrue: [CgDisplay default defaultFontStruct]
									ifFalse: [self class fontList fontStruct]);
							verticalScrollBar: textWidget parent verticalScrollBar;
							width: 10;
							textWidget: textWidget;
							disabled: System image breakpointManager breakpointsEnabled not;
							leftAttachment: XmATTACHFORM;
							topAttachment: XmATTACHFORM;
							bottomAttachment: XmATTACHFORM])
		named: #breakpoints.
	breakpointWidget manageChild.
	textWidget parent setValuesBlock: [:w |
		w
			leftAttachment: XmATTACHFORM;
			rightAttachment: XmATTACHFORM;
			bottomAttachment: XmATTACHFORM;
			topAttachment: XmATTACHFORM].!

createAccessors
	| string |
	string := self selectedText.
	(self isInstVar: string) ifTrue: [self createAccessorsForInstVar: string].
	(self isClassVar: string) 
		ifTrue: [self createAccessorsForClassVar: string]!

isClassVar: aString 
	^(self nonMetaClass classVarNames detect: [:each | each asString = aString]
		ifNone: [nil]) notNil!

isClassVarSelected
	^self isClassVar: self selectedText!

isEnabled
	^self application notNil!

isInstVar: aString 
	^self selectedClass instVarNames includes: aString!

isInstVarSelected
	^self isInstVar: self selectedText!

noSelectionItems
	^#('Do It' 'Print It' 'Inspect It' 'Push Up' 'Push Down' 'Rename As...' 'Remove' 'Create Accessors' 'Abstract' 'Protect/Concrete')!

otherMenuItems
	^(self isEditing or: [self selectedClass isNil]) 
		ifTrue: [#('Variables')]
		ifFalse: 
			[self isInstVarSelected 
				ifTrue: [#()]
				ifFalse: 
					[self isClassVarSelected 
						ifTrue: [#('References...' 'Readers...' 'Writers...' 'Protect/Concrete')]
						ifFalse: 
							[#('References...' 'Readers...' 'Writers...' 'Protect/Concrete' 'Rename As...' 'Remove' 'Push Up' 'Push Down' 'Create Accessors' 'Abstract' 'Protect/Concrete')]]]!

postBuild

	| textWidget |

	super postBuild.
	selectionManager disconnect.
	textWidget := self widgetAt: #text.
	(selectionManager := StsSmalltalkTextSelectionManager for: textWidget) connect.
	textWidget
		addEventHandler: KeyPressMask
		receiver: self
		selector: #stsKeyPress:clientData:callData:
		clientData: selectionManager!

protectInstVar
	| string |
	string := self selectedText.
	self protectInstVar: string!

pushDownVariable
	| string |
	string := self selectedText.
	(self isInstVar: string) ifTrue: 
			[self performRefactoring: (PushDownInstanceVariableRefactoring variable: string
						class: self selectedClass)].
	(self isClassVar: string) ifTrue: 
			[self performRefactoring: (PushDownClassVariableRefactoring variable: string asSymbol
						class: self nonMetaClass)]
!

pushUpVariable
	| string |
	string := self selectedText.
	(self isInstVar: string) ifTrue: [self pushUpInstVar: string].
	(self isClassVar: string) ifTrue: [self pushUpClassVar: string]!

releaseCallbacks

	super releaseCallbacks.
	(self widgetAt: #text)
		removeEventHandler: KeyPressMask
		receiver: self
		selector: #stsKeyPress:clientData:callData:
		clientData: selectionManager!

removeVariable
	| string |
	string := self selectedText.
	(self isInstVar: string) ifTrue: 
			[self performRefactoring: (RemoveInstanceVariableRefactoring variable: string class: self selectedClass)].
	(self isClassVar: string) ifTrue: 
			[self performRefactoring: (RemoveClassVariableRefactoring variable: string asSymbol
						class: self nonMetaClass)]
!

renameVariable
	| string |
	string := self selectedText.
	(self isInstVar: string) ifTrue: [self renameInstVar: string].
	(self isClassVar: string) ifTrue: [self renameClassVar: string].
	self updateContents!

stsUseColorSyntax

	^StsPowerTools useColorSyntax!

textNoChange: aString 

	super textNoChange: aString.
"rbDmm VA -----------------------------------
	self stsUpdateCompiledMethod.
	self stsUpdateParseTree
---------------------------------------------- "!

updateContents
	self text: (self selectedClass isNil
			ifTrue: [self application isNil
					ifTrue: ['']
					ifFalse: [self class classTemplate]]
			ifFalse: [self selectedClass definitionString])! !
!BrowserClassTool categoriesFor: #abstractVariable!*-unclassified!public! !
!BrowserClassTool categoriesFor: #accept!*-unclassified!public! !
!BrowserClassTool categoriesFor: #addClassVar!*-unclassified!public! !
!BrowserClassTool categoriesFor: #addInstVar!*-unclassified!public! !
!BrowserClassTool categoriesFor: #buildInterfaceIn:!*-compilation failures!*-unclassified!public! !
!BrowserClassTool categoriesFor: #createAccessors!*-unclassified!public! !
!BrowserClassTool categoriesFor: #isClassVar:!*-unclassified!public! !
!BrowserClassTool categoriesFor: #isClassVarSelected!*-unclassified!public! !
!BrowserClassTool categoriesFor: #isEnabled!*-unclassified!public! !
!BrowserClassTool categoriesFor: #isInstVar:!*-unclassified!public! !
!BrowserClassTool categoriesFor: #isInstVarSelected!*-unclassified!public! !
!BrowserClassTool categoriesFor: #noSelectionItems!*-unclassified!private! !
!BrowserClassTool categoriesFor: #otherMenuItems!*-unclassified!private! !
!BrowserClassTool categoriesFor: #postBuild!*-compilation failures!*-unclassified!public! !
!BrowserClassTool categoriesFor: #protectInstVar!*-unclassified!public! !
!BrowserClassTool categoriesFor: #pushDownVariable!*-unclassified!public! !
!BrowserClassTool categoriesFor: #pushUpVariable!*-unclassified!public! !
!BrowserClassTool categoriesFor: #releaseCallbacks!*-compilation failures!*-unclassified!public! !
!BrowserClassTool categoriesFor: #removeVariable!*-unclassified!public! !
!BrowserClassTool categoriesFor: #renameVariable!*-unclassified!public! !
!BrowserClassTool categoriesFor: #stsUseColorSyntax!*-compilation failures!*-unclassified!public! !
!BrowserClassTool categoriesFor: #textNoChange:!*-unclassified!public! !
!BrowserClassTool categoriesFor: #updateContents!*-unclassified!public! !

!BrowserClassTool class methodsFor!

classTemplate
	^'NameOfSuperclass subclass: #NameOfClass<n>	instanceVariableNames: ''instVarName1 instVarName2''<n>	classVariableNames: ''ClassVarName1 ClassVarName2''<n>	poolDictionaries: ''''' expandMacros!

menu
	^nil

"rbDmm
this code is VA gui specific
MenuHolder 
		fromSpec: #(#('&Find...' '&Replace...' '&Find/Replace...' nil '&Undo' 'Redo' nil '&Copy' 'Cu&t' '&Paste' nil '&Do It' 'Pri&nt It' '&Inspect It' nil '&Accept' 'Cancel' nil '&Variables' nil 'Print') #(#find #replace #findReplace nil #undo #redo nil #copySelection #cut #paste nil #doIt #printIt #inspectIt nil #accept #cancelText nil #(#('Add &Instance Variable...' 'Add &Class Variable...' nil 'References...' 'Readers...' 'Writers...' nil 'Re&name As...' '&Remove' nil 'Push &Up' 'Push &Down' nil 'Create Accessors' 'Abstract' 'Protect/Concrete') #(#addInstVar #addClassVar nil #browseInstVarRefs #browseInstVarReaders #browseInstVarWriters nil #renameVariable #removeVariable nil #pushUpVariable #pushDownVariable nil #createAccessors #abstractVariable #protectInstVar)) nil #hardcopy))
"! !
!BrowserClassTool class categoriesFor: #classTemplate!*-unclassified!public! !
!BrowserClassTool class categoriesFor: #menu!*-unclassified!public! !

