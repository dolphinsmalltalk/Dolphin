"Filed out from Dolphin Smalltalk 7"!

Debugger subclass: #SSWDebugger
	instanceVariableNames: 'debugState'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDebugger guid: (GUID fromString: '{9F0C6CC1-3DA8-11D6-87E5-0010A70883E2}')!
SSWDebugger comment: ''!
!SSWDebugger categoriesForClass!Unclassified! !
!SSWDebugger methodsFor!

breakAfter: frame

	self debugState: 'Step through'.

	self breakFrame: frame.

	self makeDebugFrame: frame sender.
	self runDebuggedProcess!

breakFrame: aStackFrame

	self makeDebugFrame: aStackFrame.

	self breakWhen: 
		[ :iFrame | 
		(self shouldSkipOutOf: iFrame method) 
			ifTrue: [self breakAfter: iFrame. false]
			ifFalse: [iFrame index <= aStackFrame index]]!

breakFrameOrMethod: aStackFrame

	self makeDebugFrame: aStackFrame.

	self breakWhen: 
		[ :iFrame | 
		(self shouldSkipOutOf: iFrame method) 
			ifTrue: [self breakAfter: iFrame. false]
			ifFalse: [(iFrame index <= aStackFrame index) or: [iFrame method = aStackFrame method]]]!

createSchematicWiring

	super createSchematicWiring.

	self methodSpyManager 
		when: #methodSpiesCompiledIn: send: #onMethodSpiesCompiledIn: to: self!

debugState

	"Maintain the setting for future enquiries"

	^debugState!

debugState: aString

	"Maintain the setting for future enquiries"

	debugState := aString.
	^super debugState: aString!

methodSpyManager
	^MethodSpyManager current!

onMethodSpiesCompiledIn: aCompiledMethod

	"Check for a relevant change in spies originated here, and restart if necessary"

	| myMethod |

	"Crude test for origin of spy change
	(self isOpen and: [(self view class focus ifNil: [^self]) topView = self view]) ifFalse: [^self]."

	myMethod := self selectedMethod.
	myMethod isNil ifTrue: [^self].

	"Only restart if the current method is affected"
	(myMethod methodClass = aCompiledMethod methodClass 
		and: [myMethod selector = aCompiledMethod selector])
			ifTrue: [self restartMethod]!

onMethodSpyIn: aStackFrame

	"A method spy has been encountered in aStackFrame.
	Treat this as a break if we are stepping"

	self debugState = 'Step Into' ifTrue: [self onHalt: aStackFrame]!

onViewClosed

	"Unattach from the spy manager"

	self methodSpyManager removeEventsTriggeredFor: self.

	^super onViewClosed 
!

queryCommand: aCommandQuery

	| command animating running runnable |

	super queryCommand: aCommandQuery.

	command := aCommandQuery commandSymbol.
	animating := self isAnimating.
	running := self isRunning or: [animating].
	runnable := running not and: [self isResumable].

	(command == #stepThrough) ifTrue: 
		[aCommandQuery isEnabled: runnable.
		^true].

	^false!

shouldSkipOutOf: aMethod 
	^aMethod methodClass == MethodSpy and: [aMethod selector == #handle]!

stepThrough

	| frame |

	self debugState: 'Step through'.
	frame := self frame.
	
	frame isBlockFrame
		ifTrue: [self breakFrameOrMethod: (self frames detect: [ :each | each ~~ frame and: [each method = frame method]])]
		ifFalse: [self breakFrameOrMethod: frame].

	self makeDebugFrame: frame sender.
	self runDebuggedProcess! !
!SSWDebugger categoriesFor: #breakAfter:!commands!private! !
!SSWDebugger categoriesFor: #breakFrame:!commands!private! !
!SSWDebugger categoriesFor: #breakFrameOrMethod:!commands!private! !
!SSWDebugger categoriesFor: #createSchematicWiring!initializing!public! !
!SSWDebugger categoriesFor: #debugState!accessing!public! !
!SSWDebugger categoriesFor: #debugState:!accessing!public! !
!SSWDebugger categoriesFor: #methodSpyManager!accessing!public! !
!SSWDebugger categoriesFor: #onMethodSpiesCompiledIn:!event handling!public! !
!SSWDebugger categoriesFor: #onMethodSpyIn:!event handling!private! !
!SSWDebugger categoriesFor: #onViewClosed!event handling!public! !
!SSWDebugger categoriesFor: #queryCommand:!commands!private! !
!SSWDebugger categoriesFor: #shouldSkipOutOf:!public!testing! !
!SSWDebugger categoriesFor: #stepThrough!commands!private! !

!SSWDebugger class methodsFor!

displayOn: aStream

	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'SSW '.
	super displayOn: aStream
!

initialize
	super initialize.
	self
		skipSelector: #handle
			of: MethodSpy
			type: 2;
		skipSelector: #spy
			of: Process
			type: 2!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DebuggerShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4294967295 328198 ##(Smalltalk.Point)  1599 1051 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 410 8 ##(Smalltalk.Toolbar)  98 25 0 416 98 2 8 1140851532 65 592 0 482 8 4278190080 0 519 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 530 193 193 0 592 482 688 8 4294903187 234 256 98 8 410 8 ##(Smalltalk.ReferenceView)  98 14 0 592 98 2 8 1140850688 131073 864 0 0 0 7 0 0 0 864 1180166 ##(Smalltalk.ResourceIdentifier)  608 8 #resource_Workspace_tools 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 530 1053 1 530 193 51 864 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 2 0 0 0 0 0 0 110 2 0 0 25 0 0 0] 98 0 530 193 193 0 27 8 'workspaceTools' 410 880 98 14 0 592 98 2 8 1140850688 131073 1248 0 0 0 7 0 0 0 1248 946 608 8 #resource_Image_tools 0 994 202 208 98 1 1058 1088 98 2 530 1 1 530 63 51 1248 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1200 1216 0 27 8 'imageTools' 410 880 98 14 0 592 98 2 8 1140850688 131073 1504 0 0 0 7 0 0 0 1504 946 608 8 #resource_SSWDebugger_tools 0 994 202 208 98 1 1058 1088 98 2 530 1 51 530 339 51 1504 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 169 0 0 0 50 0 0 0] 1200 1216 0 27 8 'debuggerTools' 410 880 98 14 0 592 98 2 8 1140850688 131073 1760 0 0 0 7 0 0 0 1760 946 608 8 #resource_Smalltalk_tools 0 994 202 208 98 1 1058 1088 98 2 530 63 1 530 991 51 1760 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 1200 1216 0 27 8 'smalltalkTools' 234 256 1200 202 208 1200 234 240 1200 0 1 0 530 33 33 530 45 45 0 656198 1 ##(Smalltalk.FlowLayout)  1 1 1 994 202 208 98 2 1058 1088 98 2 530 1 1 530 1245 101 592 1058 8 #updateSize 1200 592 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 110 2 0 0 50 0 0 0] 98 4 1248 1760 864 1504 1216 0 27 0 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 2320 0 0 0 7 0 0 0 2320 1180166 ##(Smalltalk.ProportionalLayout)  202 8 ##(Smalltalk.Dictionary)  98 2 721414 ##(Smalltalk.Association)  410 8 ##(Smalltalk.Splitter)  98 12 0 2320 98 2 8 1140850688 1 2512 0 482 688 0 519 0 0 0 2512 994 202 208 98 1 1058 1088 98 2 530 1 297 530 1245 11 2512 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 148 0 0 0 110 2 0 0 153 0 0 0] 98 0 1216 0 27 1 2482 410 880 98 14 0 2320 98 2 8 1140916224 131073 2784 0 0 0 23 0 0 0 2784 946 8 ##(Smalltalk.MethodWorkspace)  8 #resource_Debugger_source 0 994 202 208 98 1 1058 1088 98 2 530 1 307 530 1245 297 2784 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 153 0 0 0 110 2 0 0 45 1 0 0] 1200 1216 0 27 3 16 234 256 98 2 2784 8 'source' 0 994 202 208 98 1 1058 1088 98 2 530 1 101 530 1245 603 2320 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 50 0 0 0 110 2 0 0 95 1 0 0] 98 3 410 2336 98 15 0 2320 98 2 8 1140850688 131073 3248 0 0 0 7 0 0 0 3248 2402 202 2448 98 3 2482 410 2336 98 15 0 3248 98 2 8 1140850688 131073 3376 0 0 0 7 0 0 0 3376 2402 234 240 98 4 410 8 ##(Smalltalk.ListView)  98 30 0 3376 98 2 8 1140949069 1 3488 590662 2 ##(Smalltalk.ListModel)  202 208 1200 0 1114638 ##(Smalltalk.STBSingletonProxy)  8 ##(Smalltalk.SearchPolicy)  8 #identity 482 688 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 8 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #inspectIt 8 '&Inspect' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 3626 8 ##(Smalltalk.ImageRelativeFileLocator)  8 #current 8 'BasicInspector.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 3746 1 3778 8 #inspectReferences 8 'Inspect &References' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 3746 1 3778 8 #nilVariable 8 'Set to &Nil' 1 1 0 0 0 4050 4097 3746 1 3778 8 #browseVariableClass 8 '&Browse Class' 1 1 0 0 0 4050 4097 3746 1 3778 8 #refreshVariables 8 'Re&fresh' 1 1 0 0 0 8 '&Inspect' 0 134217729 0 0 0 0 0 0 0 3488 0 8 4294903147 459270 ##(Smalltalk.Message)  8 #first 98 0 0 3626 8 ##(Smalltalk.IconImageManager)  3904 0 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  3 1 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:each | Debugger debugPrintStringFor: each]' 8 #[31 105 45 17 177 106] 2482 8 #Debugger 8 ##(Smalltalk.Debugger)  8 #debugPrintStringFor: 4448 7 257 0 0 0 0 0 202 208 98 2 920646 5 ##(Smalltalk.ListViewColumn)  8 'Variable' 301 8 #left 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.SortedCollection)  4434 0 0 4466 2 1 4496 8 'doIt' 8 '[:each | each first]' 8 #[30 105 17 158 106] 4368 4752 7 257 0 0 3488 0 1 0 0 4658 8 'Value' 381 4704 4434 0 0 4466 3 1 4496 8 'doIt' 8 '[:each | Debugger debugPrintStringFor: each]' 8 #[31 105 45 17 177 106] 2482 4576 4592 4608 4864 7 257 0 4434 0 0 918822 ##(Smalltalk.CompiledMethod)  1 83886081 170 8 'Dolphin' 8 'SortedCollection' 8 #defaultSortBlock 1540880899 8 #[29 105 233 1 130 106] 4960 7 513 0 4434 0 0 4466 2 1 4496 8 'doIt' 8 '[:each | each second]' 8 #[30 105 17 158 106] 8 #second 5088 7 257 0 0 3488 0 3 0 0 8 #report 1200 0 131143 0 0 994 202 208 98 3 1058 1088 98 2 530 1 1 530 681 215 3488 1058 8 #contextMenu: 98 1 3712 3488 1058 8 #text: 98 1 8 'Variable' 3488 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 84 1 0 0 107 0 0 0] 98 0 1216 0 27 7 410 880 98 14 0 3376 98 2 8 1140916224 131073 5472 0 0 0 23 0 0 0 5472 946 8 ##(Smalltalk.SmalltalkWorkspace)  8 #resource_Default_view 0 994 202 208 98 1 1058 1088 98 2 530 1 225 530 681 73 5472 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 112 0 0 0 84 1 0 0 148 0 0 0] 1200 1216 0 27 3 16 234 256 98 4 3488 8 'temps' 5472 8 'inspector' 590342 ##(Smalltalk.Rectangle)  530 1 1 530 1 1 994 202 208 98 1 1058 1088 98 2 530 565 1 530 681 297 3376 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 26 1 0 0 0 0 0 0 110 2 0 0 148 0 0 0] 98 3 3488 410 2528 98 12 0 3376 98 2 8 1140850688 1 6016 0 482 688 0 519 0 0 0 6016 994 202 208 98 1 1058 1088 98 2 530 1 215 530 681 11 6016 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 107 0 0 0 84 1 0 0 112 0 0 0] 98 0 1216 0 27 5472 1216 0 27 13 2482 410 8 ##(Smalltalk.ListBox)  98 17 0 3248 98 2 8 1144062209 1 6272 3570 202 208 1200 0 3632 482 688 0 7 3698 0 16 98 13 3746 1 3778 8 #stepInto 8 'Step &Into' 1269 5 3842 0 16 3872 8 'StepInto.ico' 3952 0 0 3746 1 3778 8 #stepOver 8 'Step O&ver' 1267 5 3842 0 16 3872 8 'StepOver.ico' 3952 0 0 3746 1 3778 8 #stepOut 8 'Step O&ut' 5365 1 3842 0 16 3872 8 'StepOut.ico' 3952 0 0 3746 1 3778 8 #returnFromMessage 8 'Retur&n ...' 1 1 0 0 0 3746 1 3778 8 #restartFrame 8 '&Restart' 1 1 3842 0 16 3872 8 'Restart.ico' 3952 0 0 4050 4097 3698 0 16 98 0 8 'Im&plement in' 8 #implementDNUMenu 134217729 0 0 0 0 0 3698 0 16 98 16 3746 1 3778 8 #renameMethod 8 'Re&name...' 1 1 0 0 0 3746 1 3778 8 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 0 0 0 3746 1 3778 8 #safeRemoveMethods 8 'Rem&ove' 1 5 0 0 0 4050 4097 3746 1 3778 8 #addParameter 8 'Add &Parameter...' 1 1 0 0 0 3698 0 16 98 0 8 'Remo&ve Parameter' 8 #removeParameterMenu 134217729 0 0 0 0 0 3698 0 16 98 0 8 'Rena&me Parameter' 8 #renameParameterMenu 134217729 0 0 0 0 0 3698 0 16 98 0 8 '&Inline Parameter' 8 #inlineParameterMenu 134217729 0 0 0 0 0 4050 4097 3698 0 16 98 0 8 'Rename &Temporary' 8 #renameTempMenu 134217729 0 0 0 0 0 3698 0 16 98 0 8 'Convert Temp to Inst. Var.' 8 #convertTempToInstVarMenu 134217729 0 0 0 0 0 4050 4097 3746 1 3778 8 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 0 0 0 3746 1 3778 8 #pushUp 8 'Push &Up' 1 1 0 0 0 3746 1 3778 8 #pushDown 8 'Push &Down' 1 1 0 0 0 3746 1 3778 8 #moveMethod 8 'Move to &Component...' 1 1 0 0 0 8 'Refactorin&gs' 8 #methodRefactoringsMenu 134217729 3842 0 16 3872 8 'Refactoring.ico' 3952 0 0 0 0 4050 4097 3746 1 3778 8 #moreFrames 8 '&More' 1 1 0 0 0 3746 1 3778 8 #allFrames 8 'A&ll' 1 1 0 0 0 4050 4097 3698 0 16 98 6 3698 0 16 98 1 3746 1 3778 8 #browseDefinitions 8 'Browse Defi&nitions' 247 1 0 0 0 8 '&Definitions Of' 8 #definitionsMenu 134217729 0 0 0 0 0 3698 0 16 98 1 3746 1 3778 8 #browseReferences 8 'Browse &References' 4343 1 0 0 0 8 '&References To' 8 #referencesMenu 134217729 0 0 0 0 0 3746 1 3778 8 #browseMethodInheritanceChain 8 '&Inheritance Chain' 1 1 0 0 0 4050 4097 3746 1 3778 8 #browseMethodHistory 8 '&Change History in Image' 1 1 0 0 0 3746 1 3778 8 #browseMethodEditions 8 'Browse &Editions' 1 1 0 0 0 8 '&Browse' 0 134217729 0 0 0 0 0 8 '&Debug' 0 134217729 0 0 0 0 0 0 0 6272 0 8 4294903519 4720 1200 0 994 202 208 98 3 1058 1088 98 2 530 1 1 530 555 297 6272 1058 5328 98 1 6400 6272 1058 8 #horizontalExtent: 98 1 1 6272 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 21 1 0 0 148 0 0 0] 98 0 1216 0 27 524806 ##(Smalltalk.Fraction)  3305 675 2482 410 2528 98 12 0 3248 98 2 8 1140850688 1 8928 0 482 688 0 519 0 0 0 8928 994 202 208 98 1 1058 1088 98 2 530 555 1 530 11 297 8928 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 21 1 0 0 0 0 0 0 26 1 0 0 148 0 0 0] 98 0 1216 0 27 1 32 234 256 98 2 6272 8 'stack' 0 994 202 208 98 1 1058 1088 98 2 530 1 1 530 1245 297 3248 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 110 2 0 0 148 0 0 0] 98 3 6272 8928 3376 1216 0 27 2512 2784 1216 0 27 234 256 98 4 592 8 'toolbar' 2320 8 'main' 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 8 3698 0 16 98 8 3746 1 3778 8 #fileNew 8 '&New' 9373 1 3842 0 16 3872 8 'FileNew.ico' 3952 0 0 3746 1 3778 8 #fileOpen 8 '&Open...' 9375 1 3842 0 16 3872 8 'FileOpen.ico' 3952 0 0 3746 1 3778 8 #fileFileIn 8 '&File In...' 1 1 0 0 0 4050 4097 3746 1 3778 8 #saveImage 8 'Sa&ve Image' 1 1 3842 0 16 3872 8 'Snapshot.ico' 3952 0 0 3746 1 3778 8 #smalltalkExit 8 'E&xit Dolphin' 1 1 3842 0 16 3872 8 'PowerSwitch.ico' 3952 0 0 4050 4097 3746 1 3778 8 #exit 8 'Close' 17639 1 3842 0 16 3872 8 'CloseWindow.ico' 3952 0 0 8 '&File' 0 134217729 0 0 16175 0 0 3698 0 16 98 13 3746 1 3778 8 #undo 8 '&Undo' 9397 1 3842 0 16 3872 8 'EditUndo.ico' 3952 0 0 4050 4097 3746 1 3778 8 #cutSelection 8 'Cu&t' 9393 1 3842 0 16 3872 8 'EditCut.ico' 3952 0 0 3746 1 3778 8 #copySelection 8 '&Copy' 9351 1 3842 0 16 3872 8 'EditCopy.ico' 3952 0 0 3746 1 3778 8 #pasteClipboard 8 '&Paste' 9389 1 3842 0 16 3872 8 'EditPaste.ico' 3952 0 0 3746 1 3778 8 #editDelete 8 '&Delete' 1 1 3842 0 16 3872 8 'EditClear.ico' 3952 0 0 3698 0 16 98 2 3746 1 3778 8 #reformatSource 8 '&Source' 9391 1 0 0 0 3746 1 3778 8 #reformatComment 8 '&Comment' 9367 1 0 0 0 8 'Ref&ormat' 0 134217729 0 0 16191 0 0 4050 4097 3746 1 3778 8 #selectAll 8 'Select &All' 9347 1 0 0 0 4050 4097 3746 1 3778 8 #editFind 8 '&Find...' 9357 1 3842 0 16 3872 47 3626 8 ##(Smalltalk.ShellLibrary)  8 #default 0 0 3746 1 3778 8 #findNext 8 'Find &Next' 1253 1 3842 0 16 3872 8 'FindNext.ico' 3952 0 0 3746 1 3778 8 #findReplace 8 '&Replace...' 9361 1 0 0 0 8 '&Edit' 0 134217729 0 0 16201 0 0 3698 0 16 98 17 3746 1 3778 8 #browseIt 8 '&Browse It' 9349 1 3842 0 16 3872 8 'ClassBrowserShell.ico' 3952 0 0 3746 1 3778 8 #displayIt 8 '&Display It' 9353 1 3842 0 16 3872 8 'DisplayIt.ico' 3952 0 0 3746 1 3778 8 #evaluateIt 8 '&Evaluate It' 9355 1 3842 0 16 3872 8 'EvaluateIt.ico' 3952 0 0 3746 1 3778 3808 8 '&Inspect It' 9363 1 3856 0 0 3746 1 3778 8 #debugIt 8 'Deb&ug It' 1 1 3842 0 16 3872 8 'Debugger.ico' 3952 0 0 3746 1 3778 8 #fileItIn 8 'Fi&le It In' 1 1 0 0 0 4050 4097 3746 1 3778 8192 8 'Defi&nitions...' 1271 1 0 0 0 3746 1 3778 8320 8 '&References...' 5367 1 0 0 0 4050 4097 3746 2097153 3778 8 #accept 8 '&Accept' 9383 1 3842 0 16 3872 8 'True.ico' 3952 0 0 3746 1 3778 8 #reformatAccept 8 'Refor&mat/Accept' 13479 1 0 0 0 3746 1 3778 8 #acceptNoRestart 8 'Acce&pt No Restart' 1 1 0 0 0 4050 4097 3698 0 16 98 13 3746 1 3778 8 #renameVariable 8 'Re&name <1d>...' 1 1 0 0 0 4050 4097 3746 1 3778 8 #extractToTemporary 8 'Extract to &Temporary...' 9385 1 0 0 0 3746 1 3778 8 #extractMethod 8 'E&xtract Method...' 9371 1 0 0 0 3746 1 3778 8 #extractToComponent 8 'Extract to &Component...' 1 1 0 0 0 3746 1 3778 8 #inlineMessage 8 'Inline &Message' 13467 1 0 0 0 4050 4097 3746 1 3778 8 #inlineTemporary 8 '&Inline Temporary' 13481 1 0 0 0 3746 1 3778 8 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 0 0 0 3746 1 3778 8 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 0 0 0 4050 4097 3746 1 3778 8 #inlineParameter 8 'In&line Parameter' 1 1 0 0 0 3746 1 3778 8 #removeParameter 8 'Remove &Parameter' 1 1 0 0 0 8 'Re&factorings' 8 #codeRefactoringsMenu 134217729 3842 0 16 3872 8 'Refactoring.ico' 3952 0 16245 0 0 4050 4097 3698 0 16 98 7 3746 1 3778 8 #toggleAutoCompletion 8 '&Auto-complete' 1 1 0 0 0 3746 1 3778 8 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 0 0 0 3746 1 3778 8 #toggleLineEndings 8 'Line &Endings' 1 1 0 0 0 3746 1 3778 8 #toggleLineNumbers 8 'Line N&umbers' 1 1 0 0 0 3746 1 3778 8 #toggleStyling 8 '&Syntax Coloring' 1 1 0 0 0 3746 1 3778 8 #toggleWhitespace 8 'W&hitespace' 1 1 0 0 0 3746 1 3778 8 #toggleWordWrap 8 '&Word Wrap' 1 1 0 0 0 8 '&Options' 0 134217729 0 0 16261 0 0 8 '&Workspace' 0 134217729 0 0 16263 0 0 3698 0 16 98 22 3746 1 3778 8 #resumeProcess 8 'G&o/detach' 1257 1 0 0 0 3746 1 3778 8 #toggleAnimation 8 '&Animate' 1 1 0 0 0 3746 1 3778 8 #terminateProcess 8 '&Terminate' 5353 1 0 0 0 3746 1 3778 8 #killProcess 8 '&Kill' 1 1 0 0 0 3746 1 3778 8 #userBreak 8 '&Break' 1 1 0 0 0 4050 4097 3746 1 3778 6464 8 'Step &Into' 1269 5 3842 0 16 3872 8 'StepInto.ico' 3952 0 0 3746 1 3778 6560 8 'Step O&ver' 1267 5 3842 0 16 3872 8 'StepOver.ico' 3952 0 0 3746 1 3778 6656 8 'Step O&ut' 5365 1 3842 0 16 3872 8 'StepOut.ico' 3952 0 0 3746 1 3778 8 #runToCursor 8 'Run to &Cursor' 9459 1 3842 0 16 3872 8 'RunToCursor.ico' 3952 0 0 3746 1 3778 8 #runProcess 8 '&Run' 9449 1 3842 0 16 3872 8 'Run.ico' 3952 0 0 3746 1 3778 6816 8 'R&estart' 13545 1 0 0 0 3746 1 3778 6752 8 'Retur&n ...' 1 1 0 0 0 4050 4097 3698 0 16 98 0 8 'Im&plement in' 6944 134217729 0 0 16289 0 0 3698 0 16 98 14 3698 0 16 98 3 3746 1 3778 7024 8 'All...' 1 1 0 0 0 3746 1 3778 8 #renameMethodInHierarchy 8 'In &Hierarchy...' 1 1 0 0 0 3746 1 3778 8 #renameMethodInPackage 8 'In &Package...' 1 1 0 0 0 8 'Re&name' 0 134217729 0 0 16297 0 0 3746 1 3778 7152 8 'Rem&ove' 1 1 0 0 0 4050 4097 3746 1 3778 7232 8 'Add &Parameter...' 1 1 0 0 0 3698 0 16 98 0 8 'Remo&ve Parameter' 7312 134217729 0 0 16303 0 0 3698 0 16 98 0 8 'Rena&me Parameter' 7376 134217729 0 0 16305 0 0 3698 0 16 98 0 8 '&Inline Parameter' 7440 134217729 0 0 16307 0 0 4050 4097 3698 0 16 98 0 8 'Rename &Temporary' 7520 134217729 0 0 16309 0 0 3698 0 16 98 0 8 'Convert Temp to Inst. Var.' 7584 134217729 0 0 16311 0 0 4050 4097 3746 1 3778 7648 8 'Inline &Self Sends' 1 1 0 0 0 3746 1 3778 8 #pushUpMethods 8 'Push &Up' 1 1 0 0 0 3746 1 3778 8 #pushDownMethods 8 'Push &Down' 1 1 0 0 0 8 'Refactorin&gs' 7888 134217729 3842 0 16 3872 8 'Refactoring.ico' 3952 0 16319 0 0 4050 4097 3746 1 3778 8 #toggleBreakpoint 8 'Toggle Breakpoint' 1265 1 0 0 0 3746 1 3778 8 #toggleDisassembly 8 'Disasse&mbly' 9461 1 0 0 0 3746 1 3778 8 #showNextStatement 8 'Show Ne&xt Statement' 17621 1 0 0 0 4050 4097 3698 0 16 98 2 3746 1 3778 7984 8 '&More' 1 1 0 0 0 3746 1 3778 8048 8 'A&ll' 1 1 0 0 0 8 'Call &Stack' 0 134217729 0 0 16331 0 0 8 '&Debug' 0 134217729 0 0 16333 0 0 3698 0 16 98 3 3746 1 3778 8 #undoChange 8 '&Undo <1d>' 1 1 3842 0 16 3872 8 'EditUndo.ico' 3952 0 0 3746 1 3778 8 #redoChange 8 '&Redo <1d>' 1 1 3842 0 16 3872 8 'EditRedo.ico' 3952 0 0 3746 1 3778 8 #clearChangeHistory 8 'Clear Change &History' 1 1 0 0 0 8 'H&istory' 0 134217729 0 0 16341 0 0 3698 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 16343 0 0 3698 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 16345 0 0 3698 0 16 98 19 3746 1 3778 8 #helpContents 8 '&Contents' 1025 1 3842 0 16 3872 49 10992 0 0 3746 1 3778 8 #help 8 'On this &Tool' 1249 1 0 0 0 3746 1 3778 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 4050 4097 3746 1 3778 8 #helpFirstSplash 8 'First Splash!!' 1 1 0 0 0 4050 4097 3746 1 3778 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 3746 1 3778 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 3746 1 3778 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 3698 0 16 98 4 3746 2097153 3778 8 #tipOfTheDay 8 '&Next Tip of the Day' 9441 1 3842 0 16 3872 8 'TipOfTheDay.ico' 3952 0 0 3746 1 3778 8 #previousTipOfTheDay 8 '&Previous Tip of the Day' 13537 1 3842 0 16 3872 8 'TipOfTheDay.ico' 3952 0 0 4050 4097 3746 1 3778 8 #toggleShowTipsAtStartup 8 '&Show Tips at Startup' 1 1 0 0 0 8 'Tip of the &Day' 0 134217729 0 0 16367 0 0 4050 4097 3746 1 3778 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 3746 1 3778 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 3746 1 3778 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 3746 1 3778 8 #myDolphinAccount 8 'My Dolphin Account' 1 1 0 0 0 4050 4097 3746 1 3778 8 #dolphinLiveUpdate 8 'Check for Live &Updates...' 1 1 3842 0 16 3872 8 'LiveUpdate.ico' 3952 0 0 4050 4097 3746 1 3778 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 3842 0 16 3872 8 '!!APPLICATION' 3952 0 0 8 '&Help' 0 134217729 0 0 16399 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 994 202 208 98 2 1058 1088 98 2 530 2047 21 530 1261 801 416 1058 8 #updateMenuBar 1200 416 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 3 0 0 10 0 0 0 117 6 0 0 154 1 0 0] 98 2 592 2320 1216 0 27 )!

uninitialize
	super uninitialize.
	self
		unskipSelector: #handle of: MethodSpy;
		unskipSelector: #spy of: Process! !
!SSWDebugger class categoriesFor: #displayOn:!displaying!public! !
!SSWDebugger class categoriesFor: #initialize!constants!public! !
!SSWDebugger class categoriesFor: #resource_Default_view!public!resources-views! !
!SSWDebugger class categoriesFor: #uninitialize!constants!public! !

