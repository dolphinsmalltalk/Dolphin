"Filed out from Dolphin Smalltalk 7"!

Tools.SmalltalkToolShell subclass: #'Tools.ProcessMonitor'
	instanceVariableNames: 'listPresenter updateInterval'
	classVariableNames: 'UpdateIntervals'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ProcessMonitor guid: (Core.GUID fromString: '{71fe0342-5801-4ae5-a04d-a99350724251}')!
Tools.ProcessMonitor comment: 'ProcessMonitor is a <SmalltalkSystemTool> that displays a dynamically updating list of the running Processes (threads) on the system, including information such as the process'' names, priorities, state, and the method they are currently executing. Menu commands are available to debug, inspect, terminate, and change the priorities of the running processes. ProcessMonitor can be used to help with debugging, and is also an excellent way of learning about how processes are used in Dolphin.

All of the system processes can be safely terminated or debugged, as Dolphin will simply start new ones when it notices that they are not available. However changing the priorities of these processes (with the exception of the main UI process) is likely to make the system unstable, and so this is not permitted. User processes can be manipulated in any manner desired.

It is expected that the only process one will observe in the running state is the main UI processas this is the process that updates the display!!

Note that if a process is debugged, it may be automatically terminated when the debugger is closed. To avoid this you can either use the Debugger''s Debug - Go/Detach command (which simply causes the process to resume whatever it was doing before, including waiting on a semaphore, and closes the debugger window), or you can change the default behaviour of the debugger so that it either doesn''t terminate the debugger process when closing or prompts to do so. This can be controlled with the Debugger''s terminateOnClose option in the Dolphin Options window.

The refresh rate of a ProcessMonitor can be altered using the View - Update Speed menu. The speeds range from updating every 500mS to paused. When paused the display can be refreshed on demand using the Refresh!! command, but be aware that a paused monitor will prevent any dead processes in its list from being garbage collected until it is next refreshed.

ProcessMonitor uses Windows timers to refresh its display so that starting it does not require a further process, which would change the population it is supposed to be monitoring.

Instance Variables:
	listPresenter		<ListPresenter>. List of current live processes.
	updateInterval		<Integer>|<UndefinedObject>. Interval in milliseconds between display refreshes, or nil for paused.

Class Variables:
	UpdateIntervals		<IdentityDictionary>. Map between update speeds and corresponding interval in mS, or nil for paused.

'!
!Tools.ProcessMonitor categoriesForClass!MVP-Presenters! !
!Tools.ProcessMonitor methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	listPresenter := self add: ListPresenter new name: 'list'.!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	self 
		when: #timerTick:
		send: #onTimerTick:
		to: self.
	listPresenter 
		when: #labelOf:editedTo:accept:
		send: #onProcess:renameTo:accept:
		to: self.

	"We need to know when the session is started in order to renew the Windows timer"
	SessionManager current 
		when: #sessionStarted
		send: #onStartup
		to: self!

debugIt
	"Open a debugger on the currently selected process."

	self process debug!

defaultHelpId
	^10894!

inspectIt
	"Open an inspector on the currently selected process."

	self process inspect!

isSystemProcess: aProcess
	"Answer whether the <Process>, aProcess, is a system process.
	Note that the main process is not considered to be a system process."

	^aProcess == SessionManager inputState idler 
		or: [aProcess == Delay timingProcess 
		or: [ | objmem |	
			objmem := MemoryManager current.
			aProcess == objmem undertaker 
				or: [aProcess == objmem finalizer]]]!

onProcess: aProcess renameTo: aString accept: aValueHolder 
	(self isSystemProcess: aProcess) 
		ifTrue: [aValueHolder value: false]
		ifFalse: 
			[aProcess name: aString.
			aValueHolder value: true].
	self setTimer!

onStartup
	"Private - The image has just started. Renew the refresh timer."

	updateInterval notNil 
		ifTrue: [
			[self refresh.
			self updateInterval: updateInterval] postToMessageQueue]!

onTimerTick: timerId
	"The receiver's refresh timer has fired, so refresh the list. "

	| refreshTime |
	refreshTime := [self refresh] timeToRun.
	refreshTime > updateInterval ifTrue: [
		self view killTimer: 1.
		self updateInterval: refreshTime]!

onViewDestroyed
	"Handler for view final view destruction. This is sent on receipt of WM_NCDESTROY,
	and is expected to be the last communication from Windows."

	listPresenter list: #().
	^super onViewDestroyed!

onViewOpened
	"Received when the receiver's view is been connected. "

	super onViewOpened.
	self refresh.
	self updateInterval: (UpdateIntervals at: #default)!

pause
	self view killTimer: 1!

process
	"Private - Answer the currently selected process, or nil if none."

	^listPresenter selectionOrNil!

process: aProcess
	"Private - Set the currently selected process to the argument."

	listPresenter selection: aProcess!

queryCommand: query 
	"Private - Enter details about a potential command for the receiver into the 
	<CommandQuery>, query."

	| command proc |
	command := query commandSymbol.
	#refresh == command 
		ifTrue: 
			[query isEnabled: true.
			^true].
	#setSpeed: == command 
		ifTrue: 
			[query
				isEnabled: true;
				isChecked: self updateInterval = (UpdateIntervals at: query command arguments first).
			^true].
	proc := self process.
	#inspectIt == command 
		ifTrue: 
			[query isEnabled: proc notNil.
			^true].
	#debugIt == command 
		ifTrue: 
			[query 
				isEnabled: (proc notNil and: 
							[proc ~~ Delay timingProcess 
								and: [proc ~~ SessionManager inputState idler and: [(#(#dead #debug) includes: proc state) not]]]).
			^true].
	#terminateProcess == command 
		ifTrue: 
			[query isEnabled: (proc notNil 
						and: [SessionManager current isOAD or: [(#(#dead #debug) includes: proc state) not]]).
			^true].
	(#(#priorityMenu #renameIt) identityIncludes: command) 
		ifTrue: 
			[query isEnabled: (proc notNil and: [(self isSystemProcess: proc) not]).
			^true].
	#setLowerPriority: == command 
		ifTrue: 
			[query
				isEnabled: (proc notNil and: [(self isSystemProcess: proc) not and: [proc isMain not]]);
				isChecked: (proc notNil and: [proc priorityName == query command arguments first]).
			^true].
	#setPriority: == command 
		ifTrue: 
			[query
				isEnabled: (proc notNil and: [(self isSystemProcess: proc) not]);
				isChecked: (proc notNil and: [proc priorityName == query command arguments first]).
			^true].
	^super queryCommand: query!

refresh
	"Private - Refresh the process list display."

	| proc |
	proc := self process.
	"Try not to prevent process' being GC'd"
	(proc notNil and: [proc isTerminated]) ifTrue: [proc := nil].
	listPresenter list: #().
	listPresenter list: Process allInstances.
	proc notNil ifTrue: [self process: proc]!

renameIt
	self pause.
	listPresenter view editSelectionLabel!

setLowerPriority: priorityName
	"Lower the priority of the selected process."

	self setPriority: priorityName!

setPriority: priorityName
	"Set the priority of the selected process."

	self process priority: (Processor perform: priorityName)!

setSpeed: intervalName
	"Set the update speed."

	self updateInterval: (UpdateIntervals at: intervalName)!

setTimer
	"Private - (Re)Set the receiver's refresh timer."

	self pause.
	updateInterval isNil ifFalse: [self view setTimer: 1 interval: updateInterval asMilliseconds asInteger]!

terminateProcess
	"Prompt the user for confirmation to terminate the currently selected process,
	and if given the go ahead, make it so."

	| proc |
	proc := self process.
	(MessageBox confirm: 'Are you sure you want to terminate the process?') ifTrue: [proc terminate]!

updateInterval
	^updateInterval!

updateInterval: aDuration
	"Private - Set the interval between updates to the specified <Duration>."

	updateInterval := aDuration.
	self setTimer! !
!Tools.ProcessMonitor categoriesFor: #createComponents!initializing!public! !
!Tools.ProcessMonitor categoriesFor: #createSchematicWiring!initializing!public! !
!Tools.ProcessMonitor categoriesFor: #debugIt!commands!public! !
!Tools.ProcessMonitor categoriesFor: #defaultHelpId!constants!public! !
!Tools.ProcessMonitor categoriesFor: #inspectIt!commands!public! !
!Tools.ProcessMonitor categoriesFor: #isSystemProcess:!enquiries!public! !
!Tools.ProcessMonitor categoriesFor: #onProcess:renameTo:accept:!event handling!private! !
!Tools.ProcessMonitor categoriesFor: #onStartup!event handling!private! !
!Tools.ProcessMonitor categoriesFor: #onTimerTick:!event handling!public! !
!Tools.ProcessMonitor categoriesFor: #onViewDestroyed!event handling!public! !
!Tools.ProcessMonitor categoriesFor: #onViewOpened!event handling!public! !
!Tools.ProcessMonitor categoriesFor: #pause!helpers!private! !
!Tools.ProcessMonitor categoriesFor: #process!accessing!private! !
!Tools.ProcessMonitor categoriesFor: #process:!accessing!private! !
!Tools.ProcessMonitor categoriesFor: #queryCommand:!commands!private! !
!Tools.ProcessMonitor categoriesFor: #refresh!commands!private! !
!Tools.ProcessMonitor categoriesFor: #renameIt!commands!public! !
!Tools.ProcessMonitor categoriesFor: #setLowerPriority:!commands!public! !
!Tools.ProcessMonitor categoriesFor: #setPriority:!commands!public! !
!Tools.ProcessMonitor categoriesFor: #setSpeed:!commands!public! !
!Tools.ProcessMonitor categoriesFor: #setTimer!helpers!private! !
!Tools.ProcessMonitor categoriesFor: #terminateProcess!commands!public! !
!Tools.ProcessMonitor categoriesFor: #updateInterval!accessing!private! !
!Tools.ProcessMonitor categoriesFor: #updateInterval:!accessing!private! !

!Tools.ProcessMonitor class methodsFor!

defaultUpdateInterval
	"Answer the default number of milliseconds between the refreshes in instances
	of the receiver."

	^UpdateIntervals at: #default!

defaultUpdateInterval: aDuration
	"Set the default Duration between the refreshes in instances of the receiver (not less than 200mS)."

	UpdateIntervals at: #default put: (aDuration max: 200 milliseconds)!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Process Monitor'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	UpdateIntervals := 
		IdentityDictionary new
			at: #low put: 5000 milliseconds;
			at: #default put: 2000 milliseconds;
			at: #high put: 500 milliseconds;
			at: #pause put: nil;
			shrink.
	optionFlags := 0.
	Smalltalk developmentSystem
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self.
	self reuseIfOpen: true.
	!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^super publishedAspects
		add: ((Aspect integer: #defaultUpdateInterval)
					isNullable: false;
					yourself);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 917510 ##(Graphics.Color) #default 918022 ##(Graphics.Point) 1021 411 517 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 416 984838 ##(UI.BorderLayout) 1 1 nil nil nil nil 410 ##(UI.ListView) 34 45 nil 416 34 2 8 1140916301 1 656 787270 2 ##(UI.ListModel) 138 144 8 #() nil 1769478 ##(Kernel.IdentitySearchPolicy) 480 nil 7 461638 4 ##(UI.Menu) nil true 34 7 1180742 2 ##(UI.CommandMenuItem) 1 1377606 4 ##(UI.CommandDescription) #terminateProcess 8 '&Terminate' 1 1 nil nil nil 866 1 898 #debugIt 8 '&Debug' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'Debugger.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 866 1 898 #inspectIt 8 '&Inspect' 1 1 994 nil true 1040 8 'BasicInspector.ico' 1088 nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 818 nil true 34 5 866 1025 898 786950 ##(Core.Message) #setPriority: 8 #(#lowIOPriority) 8 '&High' 1 1 nil nil nil 866 1025 898 1298 #setPriority: 8 #(#userInterruptPriority) 8 '&Above Normal' 1 1 nil nil nil 866 1025 898 1298 #setPriority: 8 #(#userSchedulingPriority) 8 '&Normal' 1 1 nil nil nil 866 1025 898 1298 #setLowerPriority: 8 #(#userBackgroundPriority) 8 '&Below Normal' 1 1 nil nil nil 866 1025 898 1298 #setLowerPriority: 8 #(#systemBackgroundPriority) 8 '&Low' 1 1 nil nil nil 8 '&Set Priority' #priorityMenu 134217729 nil nil nil nil nil 1202 4097 866 1 898 #renameIt 8 '&Rename...' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 656 nil 8 1801282304 ##(UI.BasicListAbstract) nil 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil nil 138 144 34 7 1117254 5 ##(UI.ListViewColumn) 8 'Name' 261 #left ##(UI.BasicListAbstract) 1298 #<= 8 #() 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 3 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:process | process name displayString]' 8 #[31 105 17 158 159 106] #name #displayString 1952 7 257 nil nil 656 nil 1 nil nil 1858 8 'Id' 73 #left ##(UI.BasicListAbstract) 1298 #<= 8 #() 1298 #id 8 #() nil 656 nil 1 nil nil 1858 8 'State' 101 #right ##(UI.BasicListAbstract) 1298 #<= 8 #() 1298 #state 8 #() nil 656 nil 1 nil nil 1858 8 'Priority' 93 #right ##(UI.BasicListAbstract) 1298 #< 8 #() 1298 #priority 2224 nil 656 nil 1 nil nil 1858 8 'Size' 81 #right ##(UI.BasicListAbstract) 1298 #<= 8 #() 1298 #size 2224 nil 656 nil 1 nil nil 1858 8 'Calls' 77 #right ##(UI.BasicListAbstract) 1298 #<= 8 #() 1298 #callbackDepth 2224 nil 656 nil 1 nil nil 1858 8 'Executing' 301 #left 1938 0 nil 1970 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:process | process isActive ifTrue: [''...''] ifFalse: [process suspendedFrame displayString]]' 8 #[33 105 17 158 119 30 106 17 160 161 106] #isActive 8 '...' #suspendedFrame #displayString 2512 7 257 nil 1938 0 nil 1970 3 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:a :b | a topFrame displayString < b topFrame displayString]' 8 #[31 105 17 158 159 18 158 159 128 106] #topFrame #displayString 2608 7 513 nil nil nil 656 nil 3 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 3 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 498 1 1 498 989 293 656 2770 #contextMenu: 34 1 832 656 2770 #text: 34 1 8 'Name' 656 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 238 1 0 0 146 0 0 0] 8 #() 498 193 193 nil 35 170 192 34 2 656 8 'list' nil 658246 4 ##(UI.MenuBar) nil true 34 7 818 nil true 34 1 866 1 898 #exit 8 '&Close' 17639 1 1378630 1 ##(Graphics.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 50257 nil nil 818 nil true 34 7 866 1 898 #terminateProcess 8 '&Terminate' 1 1 nil nil nil 866 1 898 #debugIt 8 '&Debug' 1269 1 1008 nil nil 866 1 898 #inspectIt 8 '&Inspect' 9363 1 1168 nil nil 1202 4097 818 nil true 34 5 866 1025 898 1298 #setPriority: 8 #(#lowIOPriority) 8 '&High' 1 1 nil nil nil 866 1025 898 1298 #setPriority: 8 #(#userInterruptPriority) 8 '&Above Normal' 1 1 nil nil nil 866 1025 898 1298 #setPriority: 8 #(#userSchedulingPriority) 8 '&Normal' 1 1 nil nil nil 866 1025 898 1298 #setLowerPriority: 8 #(#userBackgroundPriority) 8 '&Below Normal' 1 1 nil nil nil 866 1025 898 1298 #setLowerPriority: 8 #(#systemBackgroundPriority) 8 '&Low' 1 1 nil nil nil 8 '&Set Priority' #priorityMenu 134217729 nil nil 50275 nil nil 1202 4097 866 1 898 #renameIt 8 '&Rename' 1251 1 nil nil nil 8 '&Process' nil 134217729 nil nil 50279 nil nil 866 1 898 #refresh 8 '&Refresh!!' 1 1 nil nil nil 818 nil true 34 1 818 nil true 34 4 866 1025 898 1298 #setSpeed: 8 #(#high) 8 '&High' 1 1 nil nil nil 866 2098177 898 1298 #setSpeed: 8 #(#default) 8 '&Normal' 1 1 nil nil nil 866 1025 898 1298 #setSpeed: 8 #(#low) 8 '&Low' 1 1 nil nil nil 866 1025 898 1298 #setSpeed: 8 #(#pause) 8 '&Paused' 1 1 nil nil nil 8 '&Update Speed' nil 134217729 nil nil 50291 nil nil 8 '&View' nil 134217729 nil nil 50293 nil nil 818 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 50295 nil nil 818 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 50297 nil nil 818 nil true 34 15 866 1 898 #helpContents 8 '&Contents' 1025 1 994 nil true 1040 8 'Help.ico' 1088 nil nil 866 1 898 #help 8 'On this &Tool' 1249 1 nil nil nil 866 1 898 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 1202 4097 866 1 898 #learnSmalltalk 8 'Learn Smalltalk' 1 1 3186 $\x1F393 nil 466 #orchid 466 #white nil nil 1 nil nil nil nil 1202 4097 866 1 898 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 866 1 898 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 866 1 898 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 1202 4097 866 1 898 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 994 nil true 1040 8 '!!APPLICATION' 1088 nil nil 866 1 898 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 866 1 898 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 1202 4097 866 1 898 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 3186 $\x1F42C nil nil 466 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 50321 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 2706 138 144 34 2 2770 #createAt:extent: 34 2 498 6143 21 498 1021 411 416 2770 #text: 34 1 8 'Process Monitor' 416 2930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 253 13 0 0 215 0 0 0] 34 1 656 2992 nil 27 )!

reuseIfOpen
	"Answers true if an already open instance of the receiver should be reused instead of
	creating additional instances.
	Implementation Note :opening more than one process monitor can mean that processes never
	get GC'd, so always re-use the existing instance."

	^true
!

toolsFolderHelpId
	^10597! !
!Tools.ProcessMonitor class categoriesFor: #defaultUpdateInterval!options!public! !
!Tools.ProcessMonitor class categoriesFor: #defaultUpdateInterval:!options!public! !
!Tools.ProcessMonitor class categoriesFor: #displayOn:!displaying!public! !
!Tools.ProcessMonitor class categoriesFor: #icon!constants!public! !
!Tools.ProcessMonitor class categoriesFor: #initialize!initializing!private! !
!Tools.ProcessMonitor class categoriesFor: #publishedAspects!public! !
!Tools.ProcessMonitor class categoriesFor: #resource_Default_view!public!resources-views! !
!Tools.ProcessMonitor class categoriesFor: #reuseIfOpen!accessing!public! !
!Tools.ProcessMonitor class categoriesFor: #toolsFolderHelpId!constants!public! !

