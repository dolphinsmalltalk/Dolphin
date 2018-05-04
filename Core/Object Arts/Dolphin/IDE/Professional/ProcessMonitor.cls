"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #ProcessMonitor
	instanceVariableNames: 'listPresenter updateInterval'
	classVariableNames: 'UpdateIntervals'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ProcessMonitor guid: (GUID fromString: '{71fe0342-5801-4ae5-a04d-a99350724251}')!
ProcessMonitor comment: 'ProcessMonitor is a <SmalltalkSystemTool> that displays a dynamically updating list of the running Processes (threads) on the system, including information such as the process'' names, priorities, state, and the method they are currently executing. Menu commands are available to debug, inspect, terminate, and change the priorities of the running processes. ProcessMonitor can be used to help with debugging, and is also an excellent way of learning about how processes are used in Dolphin.

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
!ProcessMonitor categoriesForClass!Development!MVP-Presenters! !
!ProcessMonitor methodsFor!

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
	refreshTime := Time millisecondsToRun: [self refresh].
	refreshTime > updateInterval ifTrue: [
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
	updateInterval isNil ifFalse: [self view setTimer: 1 interval: updateInterval]!

terminateProcess
	"Prompt the user for confirmation to terminate the currently selected process,
	and if given the go ahead, make it so."

	| proc |
	proc := self process.
	(MessageBox confirm: 'Are you sure you want to terminate the process?') ifTrue: [proc terminate]!

updateInterval
	"Private - Answer the value of the receiver's ''updateInterval'' instance variable."

	^updateInterval!

updateInterval: milliseconds
	"Private - Set the interval between updates to the number of milliseconds
	specified by the <integer> argument."

	updateInterval := milliseconds.
	self setTimer! !
!ProcessMonitor categoriesFor: #createComponents!initializing!public! !
!ProcessMonitor categoriesFor: #createSchematicWiring!initializing!public! !
!ProcessMonitor categoriesFor: #debugIt!commands!public! !
!ProcessMonitor categoriesFor: #defaultHelpId!constants!public! !
!ProcessMonitor categoriesFor: #inspectIt!commands!public! !
!ProcessMonitor categoriesFor: #isSystemProcess:!enquiries!public! !
!ProcessMonitor categoriesFor: #onProcess:renameTo:accept:!event handling!private! !
!ProcessMonitor categoriesFor: #onStartup!event handling!private! !
!ProcessMonitor categoriesFor: #onTimerTick:!event handling!public! !
!ProcessMonitor categoriesFor: #onViewDestroyed!event handling!public! !
!ProcessMonitor categoriesFor: #onViewOpened!event handling!public! !
!ProcessMonitor categoriesFor: #pause!helpers!private! !
!ProcessMonitor categoriesFor: #process!accessing!private! !
!ProcessMonitor categoriesFor: #process:!accessing!private! !
!ProcessMonitor categoriesFor: #queryCommand:!commands!private! !
!ProcessMonitor categoriesFor: #refresh!commands!private! !
!ProcessMonitor categoriesFor: #renameIt!commands!public! !
!ProcessMonitor categoriesFor: #setLowerPriority:!commands!public! !
!ProcessMonitor categoriesFor: #setPriority:!commands!public! !
!ProcessMonitor categoriesFor: #setSpeed:!commands!public! !
!ProcessMonitor categoriesFor: #setTimer!helpers!private! !
!ProcessMonitor categoriesFor: #terminateProcess!commands!public! !
!ProcessMonitor categoriesFor: #updateInterval!accessing!private! !
!ProcessMonitor categoriesFor: #updateInterval:!accessing!private! !

!ProcessMonitor class methodsFor!

defaultUpdateInterval
	"Answer the default number of milliseconds between the refreshes in instances
	of the receiver."

	^UpdateIntervals at: #default!

defaultUpdateInterval: milliseconds
	"Set the default number of milliseconds between the refreshes in instances
	of the receiver (not less than 200mS)."

	UpdateIntervals at: #default put: (milliseconds max: 200)!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Process Monitor'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	UpdateIntervals := 
		IdentityDictionary new
			at: #low put: 5000;
			at: #default put: 2000;
			at: #high put: 500;
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

	^(super publishedAspects)
		add: (Aspect boolean: #reuseIfOpen);
		add: ((Aspect integer: #defaultUpdateInterval)
					isNullable: false;
					yourself);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 328198 ##(Smalltalk.Point) 1021 411 551 0 263174 ##(Smalltalk.Font) 0 16 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 116 114 97 32 66 111 108 100 0 0 0] 530 193 193 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 0 0 0 0 410 8 ##(Smalltalk.ListView) 98 30 0 416 98 2 8 1140916301 1025 688 590662 2 ##(Smalltalk.ListModel) 202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 482 512 0 7 265030 4 ##(Smalltalk.Menu) 0 16 98 7 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) 8 #terminateProcess 8 '&Terminate' 1 1 0 0 0 930 1 962 8 #debugIt 8 '&Debug' 1 1 263494 3 ##(Smalltalk.Icon) 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Debugger.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 930 1 962 8 #inspectIt 8 '&Inspect' 1 1 1090 0 16 1136 8 'BasicInspector.ico' 1184 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 882 0 16 98 5 930 1025 962 459270 ##(Smalltalk.Message) 8 #setPriority: 98 1 8 #lowIOPriority 8 '&High' 1 1 0 0 0 930 1025 962 1410 1440 98 1 8 #userInterruptPriority 8 '&Above Normal' 1 1 0 0 0 930 1025 962 1410 1440 98 1 8 #userSchedulingPriority 8 '&Normal' 1 1 0 0 0 930 1025 962 1410 8 #setLowerPriority: 98 1 8 #userBackgroundPriority 8 '&Below Normal' 1 1 0 0 0 930 1025 962 1410 1744 98 1 8 #systemBackgroundPriority 8 '&Low' 1 1 0 0 0 8 '&Set Priority' 8 #priorityMenu 134217729 0 0 0 0 0 1314 4097 930 1 962 8 #renameIt 8 '&Rename...' 1 1 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 688 0 8 4294909021 8 ##(Smalltalk.BasicListAbstract) 0 1049926 1 ##(Smalltalk.IconImageManager) 0 0 0 0 0 0 202 208 98 7 920646 5 ##(Smalltalk.ListViewColumn) 8 'Name' 261 8 #left 2048 8 ##(Smalltalk.SortedCollection) 787814 3 ##(Smalltalk.BlockClosure) 0 0 1180966 ##(Smalltalk.CompiledExpression) 3 1 8 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:process | process name displayString]' 8 #[31 105 17 158 159 106] 8 #name 8 #displayString 2224 7 257 0 0 688 0 1 0 0 2130 8 'Id' 73 2176 2048 2210 0 0 918822 ##(Smalltalk.CompiledMethod) 1 83886081 170 8 'Dolphin' 8 'SortedCollection' 8 #defaultSortBlock 1507281411 8 #[29 105 233 1 130 106] 2400 7 513 0 1410 8 #id 98 0 0 688 0 1 0 0 2130 8 'State' 101 8 #right 2048 2192 1410 8 #state 98 0 0 688 0 1 0 0 2130 8 'Priority' 93 2608 2048 1410 8 #< 98 0 1410 8 #priority 2656 0 688 0 1 0 0 2130 8 'Size' 81 2608 2048 2192 1410 8 #size 2656 0 688 0 1 0 0 2130 8 'Calls' 77 2608 2048 2192 1410 8 #callbackDepth 2656 0 688 0 1 0 0 2130 8 'Executing' 301 2176 2210 0 0 2242 5 1 2272 8 'doIt' 8 '[:process | process isActive ifTrue: [''...''] ifFalse: [process suspendedFrame displayString]]' 8 #[33 105 17 158 119 30 106 17 160 161 106] 8 #isActive 8 '...' 8 #suspendedFrame 2352 2944 7 257 0 2210 0 0 2242 3 1 2272 8 'doIt' 8 '[:a :b | a topFrame displayString < b topFrame displayString]' 8 #[31 105 17 158 159 18 158 159 128 106] 8 #topFrame 2352 3072 7 513 0 0 0 688 0 3 0 0 8 #report 816 0 131169 0 98 1 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 3 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 530 1 1 530 989 293 688 3266 8 #contextMenu: 98 1 896 688 3266 8 #text: 98 1 8 'Name' 688 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 238 1 0 0 146 0 0 0] 98 0 530 193 193 0 27 234 256 98 2 688 8 'list' 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 7 882 0 16 98 1 930 1 962 8 #exit 8 '&Close' 17639 1 1090 0 16 1136 8 'CloseWindow.ico' 1184 0 0 8 '&File' 0 134217729 0 0 31673 0 0 882 0 16 98 7 930 1 962 992 8 '&Terminate' 1 1 0 0 0 930 1 962 1056 8 '&Debug' 1269 1 1104 0 0 930 1 962 1248 8 '&Inspect' 9363 1 1280 0 0 1314 4097 882 0 16 98 5 930 1025 962 1410 1440 98 1 1472 8 '&High' 1 1 0 0 0 930 1025 962 1410 1440 98 1 1568 8 '&Above Normal' 1 1 0 0 0 930 1025 962 1410 1440 98 1 1664 8 '&Normal' 1 1 0 0 0 930 1025 962 1410 1744 98 1 1776 8 '&Below Normal' 1 1 0 0 0 930 1025 962 1410 1744 98 1 1872 8 '&Low' 1 1 0 0 0 8 '&Set Priority' 1920 134217729 0 0 31691 0 0 1314 4097 930 1 962 1984 8 '&Rename' 1251 1 0 0 0 8 '&Process' 0 134217729 0 0 31695 0 0 930 1 962 8 #refresh 8 '&Refresh!!' 1 1 0 0 0 882 0 16 98 1 882 0 16 98 4 930 1025 962 1410 8 #setSpeed: 98 1 8 #high 8 '&High' 1 1 0 0 0 930 2098177 962 1410 4688 98 1 8 #default 8 '&Normal' 1 1 0 0 0 930 1025 962 1410 4688 98 1 8 #low 8 '&Low' 1 1 0 0 0 930 1025 962 1410 4688 98 1 8 #pause 8 '&Paused' 1 1 0 0 0 8 '&Update Speed' 0 134217729 0 0 31707 0 0 8 '&View' 0 134217729 0 0 31709 0 0 882 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 31711 0 0 882 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 31713 0 0 882 0 16 98 15 930 1 962 8 #helpContents 8 '&Contents' 1025 1 1090 0 16 1136 49 786694 ##(Smalltalk.ShellLibrary) 0 0 930 1 962 8 #help 8 'On this &Tool' 1249 1 0 0 0 930 1 962 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 1314 4097 930 1 962 8 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 1314 4097 930 1 962 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 930 1 962 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 930 1 962 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 1314 4097 930 1 962 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 930 1 962 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 930 1 962 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 1314 4097 930 1 962 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 1090 0 16 1136 8 '!!APPLICATION' 1184 0 0 8 '&Help' 0 134217729 0 0 31737 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 3202 202 208 98 3 3266 3296 98 2 530 3839 21 530 1021 411 416 3266 3424 98 1 8 'Process Monitor' 416 3266 8 #updateMenuBar 816 416 3474 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 125 9 0 0 215 0 0 0] 98 1 688 3536 0 27 )!

reuseIfOpen
	"Answers true if an already open instance of the receiver should be reused instead of
	creating additional instances.
	Implementation Note :opening more than one process monitor can mean that processes never
	get GC'd, so always re-use the existing instance."

	^true
!

toolsFolderHelpId
	^10597!

uninitialize
	"Private - Un-register the system tools folder icon for the receiver to allow clean
	removal of this class from the system.
		self uninitialize
	"

	Smalltalk developmentSystem
		removeSystemFolderIconNamed: self toolDescription;
		unregisterTool: self! !
!ProcessMonitor class categoriesFor: #defaultUpdateInterval!options!public! !
!ProcessMonitor class categoriesFor: #defaultUpdateInterval:!options!public! !
!ProcessMonitor class categoriesFor: #displayOn:!displaying!public! !
!ProcessMonitor class categoriesFor: #icon!constants!public! !
!ProcessMonitor class categoriesFor: #initialize!initializing!private! !
!ProcessMonitor class categoriesFor: #publishedAspects!development!public! !
!ProcessMonitor class categoriesFor: #resource_Default_view!public!resources-views! !
!ProcessMonitor class categoriesFor: #reuseIfOpen!accessing!public! !
!ProcessMonitor class categoriesFor: #toolsFolderHelpId!constants!public! !
!ProcessMonitor class categoriesFor: #uninitialize!class hierarchy-removing!private! !

