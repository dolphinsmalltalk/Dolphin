"Filed out from Dolphin Smalltalk"!

Tools.SmalltalkToolShell
	subclass: #'Tools.ProcessMonitor'
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

canDebug
	| proc |
	proc := self process.
	^proc notNil and: 
			[proc ~~ Delay timingProcess
				and: [proc ~~ SessionManager inputState idler and: [(#(#dead #debug) includes: proc state) not]]]!

canTerminate
	| proc |
	proc := self process.
	^proc notNil and: [SessionManager current isOAD or: [(#(#dead #debug) includes: proc state) not]]!

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

	<commandQuery: #canDebug>
	self process debug!

defaultHelpId
	^10894!

hasLiveUserProcessSelected
	| proc |
	proc := self process.
	^proc notNil and: [proc isAlive and: [(self isSystemProcess: proc) not]]!

hasSelection
	^listPresenter hasSelection!

inspectIt
	"Open an inspector on the currently selected process."

	<commandQuery: #hasSelection>
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

priorityMenu
	<commandQuery: #hasLiveUserProcessSelected>!

process
	"Private - Answer the currently selected process, or nil if none."

	^listPresenter selectionOrNil!

process: aProcess
	"Private - Set the currently selected process to the argument."

	listPresenter selection: aProcess!

queryLowerPriority: aCommandQuery
	| proc |
	proc := self process.
	proc isNil ifTrue: [^self].
	aCommandQuery
		isEnabled: (proc isAlive and: [(self isSystemProcess: proc) not and: [proc isMain not]]);
		isChecked: proc priorityName == aCommandQuery command arguments single!

querySetPriority: aCommandQuery
	| proc |
	proc := self process.
	proc isNil ifTrue: [^self].
	aCommandQuery
		isEnabled: (proc isAlive and: [(self isSystemProcess: proc) not]);
		isChecked: proc priorityName == aCommandQuery command arguments single!

querySetSpeed: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: self updateInterval = (UpdateIntervals at: aCommandQuery command arguments single)!

refresh
	"Refresh the process list display."

	| proc |
	proc := self process.
	"Try not to prevent process' being GC'd"
	(proc notNil and: [proc isTerminated]) ifTrue: [proc := nil].
	listPresenter list: #().
	listPresenter list: (Process allInstances sort: [:a :b | a id <= b id]).
	proc notNil ifTrue: [self process: proc]!

renameIt
	<commandQuery: #hasLiveUserProcessSelected>
	self pause.
	listPresenter view editSelectionLabel!

setLowerPriority: priorityName
	"Lower the priority of the selected process."

	<commandQuery: #queryLowerPriority:>
	self setPriority: priorityName!

setPriority: priorityName
	"Set the priority of the selected process."

	<commandQuery: #querySetPriority:>
	self process priority: (Processor perform: priorityName)!

setSpeed: intervalName
	"Set the update speed."

	<commandQuery: #querySetSpeed:>
	self updateInterval: (UpdateIntervals at: intervalName)!

setTimer
	"Private - (Re)Set the receiver's refresh timer."

	self pause.
	updateInterval isNil ifFalse: [self view setTimer: 1 interval: updateInterval asMilliseconds asInteger]!

terminateProcess
	"Prompt the user for confirmation to terminate the currently selected process,
	and if given the go ahead, make it so."

	<commandQuery: #canTerminate>
	| proc |
	proc := self process.
	(MessageBox new
		headline: 'Terminate process <d>?' << proc id;
		text: 'The <p> process will be terminated.' << proc name;
		customButtons: #(#(#yes '&Terminate') #(#no 'Cancel'));
		isCancellable: true;
		confirm) ifTrue: [proc terminate]!

updateInterval
	^updateInterval!

updateInterval: aDuration
	"Private - Set the interval between updates to the specified <Duration>."

	updateInterval := aDuration.
	self setTimer! !
!Tools.ProcessMonitor categoriesForMethods!
canDebug!commands-queries!private! !
canTerminate!commands-queries!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
debugIt!commands-actions!public! !
defaultHelpId!constants!public! !
hasLiveUserProcessSelected!commands-queries!private! !
hasSelection!accessing!private! !
inspectIt!commands-actions!public! !
isSystemProcess:!enquiries!public! !
onProcess:renameTo:accept:!event handling!private! !
onStartup!event handling!private! !
onTimerTick:!event handling!public! !
onViewDestroyed!event handling!public! !
onViewOpened!event handling!public! !
pause!helpers!private! !
priorityMenu!commands-menus!public! !
process!accessing!private! !
process:!accessing!private! !
queryLowerPriority:!commands-queries!private! !
querySetPriority:!commands-queries!private! !
querySetSpeed:!commands-queries!private! !
refresh!commands-actions!public! !
renameIt!commands-actions!public! !
setLowerPriority:!commands-actions!public! !
setPriority:!commands-actions!public! !
setSpeed:!commands-actions!public! !
setTimer!helpers!private! !
terminateProcess!commands-actions!public! !
updateInterval!accessing!private! !
updateInterval:!accessing!private! !
!

!Tools.ProcessMonitor class methodsFor!

defaultUpdateInterval
	"Answer the default number of milliseconds between the refreshes in instances
	of the receiver."

	^UpdateIntervals at: #default!

defaultUpdateInterval: aDuration
	"Set the default Duration between the refreshes in instances of the receiver (not less than 200mS)."

	self defaultUpdateInterval = aDuration ifTrue: [^self].
	UpdateIntervals at: #default put: (aDuration max: 200 milliseconds).
	self persistOptions!

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

	UpdateIntervals := IdentityDictionary new
				at: #low put: 5 seconds;
				at: #default put: 2 seconds;
				at: #high put: 500 milliseconds;
				at: #pause put: nil;
				shrink.
	SmalltalkSystem current
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^super publishedAspects
		removeKey: #reuseIfOpen;
		add: ((Aspect integer: #defaultUpdateInterval)
					defaultValue: 2 seconds;
					yourself);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #default 518 #{Graphics.Point} 1021 411 517 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 130 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 nil nil nil nil 18 #{UI.ListView} 50 45 nil 32 50 2 8 1140916301 1 288 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 112 nil 5 2886 4 #{UI.Menu} nil true 50 7 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #terminateProcess 8 '&Terminate' 1 1 nil nil nil 498 1 530 #debugIt 8 '&Debug' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'Debugger.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 498 1 530 #inspectIt 8 '&Inspect' 1 1 626 nil true 658 8 'BasicInspector.ico' 720 65541 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 450 nil true 50 5 498 1025 530 518 #{Core.Message} #setPriority: 8 #(#lowIOPriority) 8 '&High' 1 1 nil nil nil 498 1025 530 946 #setPriority: 8 #(#userInterruptPriority) 8 '&Above Normal' 1 1 nil nil nil 498 1025 530 946 #setPriority: 8 #(#userSchedulingPriority) 8 '&Normal' 1 1 nil nil nil 498 1025 530 946 #setLowerPriority: 8 #(#userBackgroundPriority) 8 '&Below Normal' 1 1 nil nil nil 498 1025 530 946 #setLowerPriority: 8 #(#systemBackgroundPriority) 8 '&Low' 1 1 nil nil nil 8 '&Set Priority' #priorityMenu 134217729 nil nil nil nil nil 850 4097 498 1 530 #renameIt 8 '&Rename…' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 288 nil nil 946 #displayString 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 386 7 3142 5 #{UI.ListViewColumn} 8 'Name' 261 #left 1424 946 #<= 8 #() 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:process | process name displayString]' 8 #[31 105 17 158 159 106] #name #displayString 1600 7 257 nil nil 288 nil 1 nil nil 1506 8 'Id' 89 #left 1424 946 #<= 8 #() 946 #id 8 #() nil 288 nil 1 nil nil 1506 8 'State' 113 #right 1424 946 #<= 8 #() 946 #state 8 #() nil 288 nil 1 nil nil 1506 8 'Priority' 97 #right 1424 946 #< 8 #() 946 #priority 1872 nil 288 nil 1 nil nil 1506 8 'Size' 81 #right 1424 946 #<= 8 #() 946 #size 1872 nil 288 nil 1 nil nil 1506 8 'Calls' 77 #right 1424 946 #<= 8 #() 946 #callbackDepth 1872 nil 288 nil 1 nil nil 1506 8 'Executing' 277 #left 1586 0 nil 1618 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:process | process isActive ifTrue: [''…''] ifFalse: [process suspendedFrame displayString]]' 8 #[33 105 17 158 119 30 106 17 160 161 106] #isActive 8 '…' #suspendedFrame #displayString 2160 7 257 nil 1586 0 nil 1618 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a topFrame displayString < b topFrame displayString]' 8 #[31 105 17 158 159 18 158 159 128 106] #topFrame #displayString 2256 7 513 nil nil nil 288 nil 3 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 130 1 1 130 989 293 288 2402 #text: 50 1 8 'Name' 288 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 238 1 0 0 146 0 0 0] 8 #() 130 193 193 nil 35 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 288 8 'list' nil 2886 4 #{UI.MenuBar} nil true 50 7 450 nil true 50 1 498 1 530 #exit 8 '&Close' 17639 1 2374 2 #{Graphics.TextTileIcon} 8 $✖ nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil nil nil nil 450 nil true 50 7 498 1 530 #terminateProcess 8 '&Terminate' 1 1 nil nil nil 498 1 530 #debugIt 8 '&Debug' 1269 1 640 nil nil 498 1 530 #inspectIt 8 '&Inspect' 9363 1 800 nil nil 850 4097 450 nil true 50 5 498 1025 530 946 #setPriority: 8 #(#lowIOPriority) 8 '&High' 1 1 nil nil nil 498 1025 530 946 #setPriority: 8 #(#userInterruptPriority) 8 '&Above Normal' 1 1 nil nil nil 498 1025 530 946 #setPriority: 8 #(#userSchedulingPriority) 8 '&Normal' 1 1 nil nil nil 498 1025 530 946 #setLowerPriority: 8 #(#userBackgroundPriority) 8 '&Below Normal' 1 1 nil nil nil 498 1025 530 946 #setLowerPriority: 8 #(#systemBackgroundPriority) 8 '&Low' 1 1 nil nil nil 8 '&Set Priority' #priorityMenu 134217729 nil nil nil nil nil 850 4097 498 1 530 #renameIt 8 '&Rename' 1251 1 nil nil nil 8 '&Process' nil 134217729 nil nil nil nil nil 498 1 530 #refresh 8 '&Refresh!!' 1 1 nil nil nil 450 nil true 50 1 450 nil true 50 4 498 1025 530 946 #setSpeed: 8 #(#high) 8 '&High' 1 1 nil nil nil 498 2098177 530 946 #setSpeed: 8 #(#default) 8 '&Normal' 1 1 nil nil nil 498 1025 530 946 #setSpeed: 8 #(#low) 8 '&Low' 1 1 nil nil nil 498 1025 530 946 #setSpeed: 8 #(#pause) 8 '&Paused' 1 1 nil nil nil 8 '&Update Speed' nil 134217729 nil nil nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil 450 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil nil nil nil 450 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil nil nil nil 450 nil true 50 15 498 1 530 #helpContents 8 '&Contents' 1025 1 626 nil true 658 8 'Help.ico' 720 65541 nil nil nil 498 1 530 #help 8 'On this &Tool' 1249 1 nil nil nil 498 1 530 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 850 4097 498 1 530 #learnSmalltalk 8 'Learn Smalltalk' 1 1 2802 8 $🎓 nil 98 #orchid 98 #white nil nil 1 nil nil nil nil 850 4097 498 1 530 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 498 1 530 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 498 1 530 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 850 4097 498 1 530 #dolphinHomePage 8 'Dolphin Homepage' 1 1 626 nil true 658 8 '!!APPLICATION' 720 65541 nil nil nil 498 1 530 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 498 1 530 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 850 4097 498 1 530 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 2802 8 $🐬 nil nil 98 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 2354 50 2 2402 #createAt:extent: 50 2 130 6143 21 130 1021 411 32 2402 #text: 50 1 8 'Process Monitor' 32 2530 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 253 13 0 0 215 0 0 0] 50 1 288 2592 nil 27)!

reuseIfOpen
	"Answers true if an already open instance of the receiver should be reused instead of
	creating additional instances."

	"Implementation Note: Opening more than one process monitor can mean that processes never
	get GC'd, so always re-use the existing instance."

	^true!

toolsFolderHelpId
	^10597! !
!Tools.ProcessMonitor class categoriesForMethods!
defaultUpdateInterval!options!public! !
defaultUpdateInterval:!options!public! !
displayOn:!displaying!public! !
icon!constants!public! !
initialize!initializing!private! !
publishedAspects!public! !
resource_Default_view!public!resources-views! !
reuseIfOpen!accessing!public! !
toolsFolderHelpId!constants!public! !
!

