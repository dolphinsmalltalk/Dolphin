"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #WebApplicationAdministrationManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'newExecutableFileName scheduledRestartProcess scheduledRestartTimestamp md5digest memoryUsageStats'!
WebApplicationAdministrationManager guid: (GUID fromString: '{94F1E621-1485-4A19-928F-B0660878AC4A}')!
WebApplicationAdministrationManager comment: ''!
!WebApplicationAdministrationManager categoriesForClass!Unclassified! !
!WebApplicationAdministrationManager class methodsFor!

allWebApplicationInstances
	| result |
	result := (OrderedCollection new)
				addAll: WebApplication allInstances;
				yourself.
	WebApplication allSubclasses do: [:eachClass | result addAll: eachClass allInstances].
	^result!

allWebServerInstances
	| result |
	result := (OrderedCollection new)
				addAll: WebHttpServer allInstances;
				yourself.
	WebHttpServer allSubclasses do: [:eachClass | result addAll: eachClass allInstances].
	^result!

memoryUsageStats
	| current coll snapshot1 snapshot2 snapshot3 previousRecord currentInstanceCount previousInstanceCount |
	memoryUsageStats isNil ifTrue: [^nil].
	current := memoryUsageStats last.
	current isNil ifTrue: [^nil].
	current value hasValue ifFalse: [^false].
	coll := current value value collect: 
					[:each | 
					(Array new: 8)
						at: 1 put: each key;
						at: 2 put: each value;
						yourself].
	snapshot1 := (memoryUsageStats at: 3) 
				ifNotNil: [:value | value value hasValue ifTrue: [value value value]].
	snapshot2 := (memoryUsageStats at: 2) 
				ifNotNil: [:value | value value hasValue ifTrue: [value value value]].
	snapshot3 := (memoryUsageStats at: 1) 
				ifNotNil: [:value | value value hasValue ifTrue: [value value value]].
	coll do: 
			[:each | 
			currentInstanceCount := each at: 2.
			snapshot1 isNil 
				ifFalse: 
					[previousRecord := snapshot1 detect: [:assoc | assoc key == (each at: 1)] ifNone: [].
					previousRecord isNil 
						ifFalse: 
							[previousInstanceCount := previousRecord value.
							each at: 3 put: currentInstanceCount - previousInstanceCount.
							each at: 4
								put: (previousInstanceCount ~= 0 
										ifTrue: [(currentInstanceCount - previousInstanceCount) / previousInstanceCount])]].
			snapshot2 isNil 
				ifFalse: 
					[previousRecord := snapshot2 detect: [:assoc | assoc key == (each at: 1)] ifNone: [].
					previousRecord isNil 
						ifFalse: 
							[previousInstanceCount := previousRecord value.
							each at: 5 put: currentInstanceCount - previousInstanceCount.
							each at: 6
								put: (previousInstanceCount ~= 0 
										ifTrue: [(currentInstanceCount - previousInstanceCount) / previousInstanceCount])]].
			snapshot3 isNil 
				ifFalse: 
					[previousRecord := snapshot3 detect: [:assoc | assoc key == (each at: 1)] ifNone: [].
					previousRecord isNil 
						ifFalse: 
							[previousInstanceCount := previousRecord value.
							each at: 7 put: currentInstanceCount - previousInstanceCount.
							each at: 8
								put: (previousInstanceCount ~= 0 
										ifTrue: [(currentInstanceCount - previousInstanceCount) / previousInstanceCount])]]].
	^Association key: current key value: coll!

newExecutableFileGetMD5forPlatform: platformID 
	^md5digest isNil ifFalse: [md5digest at: platformID ifAbsent: []]!

newExecutableFileName
	^self newExecutableFileNameGetForPlatform: ItcSystemManager currentPlatformID!

newExecutableFileName: anObject forPlatform: platformID 
	newExecutableFileName isNil ifTrue: [newExecutableFileName := ItcLookupTable new].
	newExecutableFileName at: platformID put: anObject.
	md5digest isNil ifTrue: [md5digest := ItcLookupTable new].
	md5digest at: platformID put: nil.
	
	[md5digest at: platformID
		put: (MD5 hashForFileNamed: ItcSystemManager startUpDirectoryPath , anObject)] 
			on: Error
			do: 
				[:ex | 
				"ignore error if MD5 command line utility is not present"
				ItcSystemManager writeErrorLogInRuntime: ex.
				ex exitWith: nil]!

newExecutableFileNameGetAllAvailablePlatforms
	"Answer a list of platform IDs for which a new uploaded executable/image was uploaded."

	^newExecutableFileName isNil ifFalse: [newExecutableFileName keys]!

newExecutableFileNameGetForPlatform: platformID 
	^newExecutableFileName isNil ifFalse: [newExecutableFileName at: platformID ifAbsent: []]!

recordMemoryUsageStatistics: anArray 
	memoryUsageStats isNil ifTrue: [memoryUsageStats := Array new: 4].
	"move previous stats at the beginning of the array"
	1 to: 3 do: [:i | memoryUsageStats at: i put: (memoryUsageStats at: i + 1)].
	"put current stats in the last slot"
	memoryUsageStats at: 4 put: (Association key: Timestamp now value: anArray).
	^anArray!

restartApplication: filename port: anInteger startParameters: startParameters serverClusterManager: aServerClusterManager redistributeServerImage: redistributeBoolean 
	| port |
	filename isNilOrEmpty ifTrue: [self error: 'Executable file is not specified'].
	ItcSystemManager logLineWithTsAndSession: 'Automatic server restart begin'.
	aServerClusterManager isNil 
		ifTrue: [port := anInteger ifNil: [WebHttpServer defaultPort]]
		ifFalse: 
			[port := aServerClusterManager application webServer serverPort.
			ItcSystemManager 
				logLineWithTsAndSession: 'Automatic server restart - clean up dead servers in the cluster'.
			aServerClusterManager cleanUpDeadWorkerServers.
			redistributeBoolean = false 
				ifTrue: 
					[ItcSystemManager 
						logLineWithTsAndSession: 'Automatic server restart - new exe file WILL NOT BE SENT to everyone in cluster, presumed as already there']
				ifFalse: 
					[ItcSystemManager 
						logLineWithTsAndSession: 'Automatic server restart - sending new exe file to everyone in cluster'.
					aServerClusterManager sendNewExecutableFileToEveryoneInCluster].
			ItcSystemManager 
				logLineWithTsAndSession: 'Automatic server restart - sending new exe file to everyone in cluster - DONE'.
			aServerClusterManager kickServerClusterRestartWithParameters: startParameters].
	ItcSystemManager isRuntime 
		ifFalse: 
			[ItcSystemManager 
				logLineWithTsAndSession: 'This is the end my friend, say good bye to your code...

just joking, we are not in run-time yet ;-)'.
			^self].
	ItcSystemManager logLineWithTS: 'Forking server restart code'.
	
	[(Delay forMilliseconds: 500) wait.
	ItcSystemManager currentPlatformID == #DolphinSmalltalkVM 
		ifTrue: 
			[self 
				restartApplicationOnDolphinVM: filename
				port: port
				startParameters: startParameters].
	ItcSystemManager currentPlatformID == #VastWindowsVM 
		ifTrue: 
			[self 
				restartApplicationOnVastWindowsVM: filename
				port: port
				startParameters: startParameters].
	ItcSystemManager currentPlatformID == #VastLinuxVM 
		ifTrue: 
			[self 
				restartApplicationOnVastLinuxVM: filename
				port: port
				startParameters: startParameters]] 
			forkAt: ItcSystemManager serverWatchdogPriority!

restartApplicationOnDolphinVM: filename port: port startParameters: startParameters 
	| fileStream |
	ItcSystemManager logLineWithTS: 'Restarting Dolphin Windows executable'.
	fileStream := FileStream write: ItcSystemManager startUpDirectoryPath , 'automaticRestart.bat'
				mode: #truncate.
	
	[fileStream
		nextPutAll: 'cd "' , ItcSystemManager startUpDirectoryPath , '"';
		cr;
		nextPutAll: 'sleep 5';
		cr;
		nextPutAll: 'kill -f ' , ItcSystemManager getCurrentOsProcessId printString;
		cr;
		nextPutAll: 'pskill ' , ItcSystemManager getCurrentOsProcessId printString;
		cr;
		nextPutAll: 'sleep 5';
		cr;
		nextPutAll: 'rename ' , ItcSystemManager imageFilename , '.exe ' , filename , '.old';
		cr;
		nextPutAll: 'rename ' , filename , ' ' , ItcSystemManager imageFilename , '.exe';
		cr;
		nextPutAll: 'start ' , ItcSystemManager imageFilename , '.exe ' , startParameters , '-port' 
					, port printString;
		cr;
		nextPutAll: 'exit';
		cr] 
			ensure: [fileStream close].
	self shutdownAllWebServerAndWebApplicationInstances.
	ItcSystemManager
		forkExternalProgram: ItcSystemManager startUpDirectoryPath , 'automaticRestart.bat';
		quitImage!

restartApplicationOnVastLinuxVM: filename port: port startParameters: startParameters 
	| fileStream pid ws |
	ItcSystemManager logLineWithTS: 'Restarting VAST Linux VM image'.
	pid := ItcSystemManager getCurrentOsProcessId printString.
	ws := WriteStream on: String new.
	ws 
		nextPutAll: 'cd "' , ItcSystemManager startUpDirectoryPath , '"
kill ' , pid 
				, '
sleep 5
for x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
do
        if ps -p ' 
					, pid , ' | grep ' 
				, pid 
					, '
        then
                echo "Process still running, waiting..."
                sleep 3
                kill ' 
					, pid 
					, '
        else
                echo "Process ended - starting new instance...."
                break
        fi
done

if ps -p ' 
					, pid , ' | grep ' 
				, pid , '
then
        echo "Process stil running, terminating it..."
        kill -9 ' 
				, pid , '
fi

echo "Starting new instance"

rm ' 
				, ItcSystemManager imageFilename , '.icx.old
mv ' 
				, ItcSystemManager imageFilename , '.icx ' 
				, ItcSystemManager imageFilename , '.icx.old
mv ' 
				, filename , ' ' 
				, ItcSystemManager imageFilename , '.icx
./start.sh
'.
	fileStream := FileStream write: ItcSystemManager startUpDirectoryPath , 'start_app_restart.sh'
				mode: #truncate.
	fileStream beBinary.
	
	["convert from CR LF to LF only as required by Unix shell scripts"
	fileStream nextPutAll: (ws contents asByteArray reject: [:each | each = 13])] 
			ensure: [fileStream close].
	self shutdownAllWebServerAndWebApplicationInstances.
	(Delay forSeconds: 3) wait.
	ItcSystemManager
		logLineWithTS: 'Forking automatic restart command line script...';
		startExternalProgramScript: 'chmod +x "' , ItcSystemManager startUpDirectoryPath 
					, 'start_app_restart.sh"';
		forkExternalProgram: ItcSystemManager startUpDirectoryPath , 'start_app_restart.sh'.
	ItcSystemManager logLineWithTS: 'Waiting for 4 seconds...'.
	(Delay forSeconds: 4) wait.
	ItcSystemManager logLineWithTS: 'Exiting image'.
	ItcSystemManager quitImage!

restartApplicationOnVastWindowsVM: filename port: port startParameters: startParameters 
	| fileStream |
	ItcSystemManager logLineWithTS: 'Restarting VAST Windows VM image'.
	fileStream := FileStream write: ItcSystemManager startUpDirectoryPath , 'automaticRestart.bat'
				mode: #truncate.
	
	[fileStream
		nextPutAll: 'cd "' , ItcSystemManager startUpDirectoryPath , '"';
		cr;
		nextPutAll: 'sleep 8';
		cr;
		nextPutAll: 'kill -f ' , ItcSystemManager getCurrentOsProcessId printString;
		cr;
		nextPutAll: 'pskill ' , ItcSystemManager getCurrentOsProcessId printString;
		cr;
		nextPutAll: 'sleep 3';
		cr;
		nextPutAll: 'rename ' , ItcSystemManager imageFilename , '.icx ' , filename , '.old';
		cr;
		nextPutAll: 'rename ' , filename , ' ' , ItcSystemManager imageFilename , '.icx';
		cr;
		nextPutAll: 'start ' , ItcSystemManager imageFilename , '.exe -i' , ItcSystemManager imageFilename 
					, '.icx ' , startParameters 
					, '-port' , port printString;
		cr;
		nextPutAll: 'exit';
		cr] 
			ensure: [fileStream close].
	self shutdownAllWebServerAndWebApplicationInstances.
	(Delay forSeconds: 3) wait.
	ItcSystemManager
		logLineWithTS: 'Forking automatic restart command line script...';
		forkExternalProgram: ItcSystemManager startUpDirectoryPath , 'automaticRestart.bat'.
	ItcSystemManager logLineWithTS: 'Waiting for 4 seconds...'.
	(Delay forSeconds: 4) wait.
	ItcSystemManager logLineWithTS: 'Exiting image'.
	ItcSystemManager quitImage!

scheduleApplicationServerRestartAt: aTime port: anIntegerOrNil startParameters: aStringOrNil serverClusterManager: anObject 
	scheduledRestartProcess isNil 
		ifFalse: 
			[scheduledRestartProcess itcSafeTerminate.
			scheduledRestartProcess := nil].
	scheduledRestartTimestamp := aTime asSeconds < Time now asSeconds 
				ifTrue: [Timestamp date: (Date today addDays: 1) time: aTime]
				ifFalse: [Timestamp date: Date today time: aTime].
	ItcSystemManager logLineWithTsAndSession: 'Scheduling server restart with new version at ' 
				, scheduledRestartTimestamp asWebString.
	scheduledRestartProcess := (ItcSystemManager newProcessOn: 
					["najprej caka, da bo 20 minut pred nadgradnjo"
					| delta newExeFileName |
					newExeFileName := self newExecutableFileName.
					anObject isNil 
						ifFalse: 
							[ItcSystemManager 
								logLineWithTsAndSession: 'Automatic server restart scheduled - Preparing for restart and sending new exe file to everyone in cluster'.
							anObject cleanUpDeadWorkerServers.
							anObject sendNewExecutableFileToEveryoneInCluster].
					(Delay 
						forSeconds: (scheduledRestartTimestamp totalSeconds - 1200 - Timestamp now totalSeconds max: 1)) 
							wait.
					"nato vsako sekundo cakanja izpise obvestilo, da bo prislo do nadgradnje"
					
					[delta := scheduledRestartTimestamp totalSeconds - Timestamp now totalSeconds max: 0.
					delta > 0] 
							whileTrue: 
								[self allWebApplicationInstances do: 
										[:eachApp | 
										eachApp serverMessage: ('ApplicationAdministration.ServerIsAboutToBeRestartedMessage' 
													webTranslateWith: scheduledRestartTimestamp time asShortWebString
													with: (delta // 60) asWebString
													with: (delta \\ 60) asWebString)
											distributed: anObject notNil].
								delta > 60 ifTrue: [(Delay forSeconds: 5) wait] ifFalse: [(Delay forSeconds: 1) wait]].
					self allWebApplicationInstances 
						do: [:eachApp | eachApp serverMessage: 'Server upgrade in progress...' distributed: anObject notNil].
					self 
						restartApplication: newExeFileName
						port: anIntegerOrNil
						startParameters: aStringOrNil
						serverClusterManager: anObject
						redistributeServerImage: false]
				named: 'Auto restart at ' , scheduledRestartTimestamp asWebString)
				priority: ItcSystemManager serverWatchdogPriority;
				language: Processor activeProcess language;
				yourself.
	scheduledRestartProcess resume!

shutdownAllWebServerAndWebApplicationInstances
	ItcSystemManager logLineWithTS: 'Shutting down applications...'.
	self allWebApplicationInstances do: 
			[:eachWebApplication | 
			ItcSystemManager logLineWithTS: 'Shutting down ' , eachWebApplication class printString.
			[eachWebApplication shutdown] on: Error do: [:ex | ]].
	ItcSystemManager logLineWithTS: 'Shutting down web server...'.
	self allWebServerInstances do: [:eachWebServer | [eachWebServer shutdown] on: Error do: [:ex | ]]!

startUploadedApplication: application onPort: anIntegerOrNil additionalArguments: aStringOrNil serverClusterManager: anObject 
	| fn port startParameters |
	fn := self newExecutableFileName.
	fn isNilOrEmpty ifTrue: [^'Error, no executable file is uploaded'].
	(ItcSystemManager fileExists: ItcSystemManager startUpDirectoryPath , fn) 
		ifFalse: [^'Error, file does not exists: ' , fn].
	ItcSystemManager logLineWithTsAndSession: 'Starting uploaded application - file ' , fn.
	port := anIntegerOrNil ifNil: [application webServer serverPort].
	startParameters := aStringOrNil ifNil: [''].
	self 
		restartApplication: fn
		port: port
		startParameters: startParameters
		serverClusterManager: anObject
		redistributeServerImage: true.
	^nil! !
!WebApplicationAdministrationManager class categoriesFor: #allWebApplicationInstances!private! !
!WebApplicationAdministrationManager class categoriesFor: #allWebServerInstances!private! !
!WebApplicationAdministrationManager class categoriesFor: #memoryUsageStats!accessing!public! !
!WebApplicationAdministrationManager class categoriesFor: #newExecutableFileGetMD5forPlatform:!accessing!public! !
!WebApplicationAdministrationManager class categoriesFor: #newExecutableFileName!accessing!public! !
!WebApplicationAdministrationManager class categoriesFor: #newExecutableFileName:forPlatform:!accessing!public! !
!WebApplicationAdministrationManager class categoriesFor: #newExecutableFileNameGetAllAvailablePlatforms!accessing!public! !
!WebApplicationAdministrationManager class categoriesFor: #newExecutableFileNameGetForPlatform:!accessing!public! !
!WebApplicationAdministrationManager class categoriesFor: #recordMemoryUsageStatistics:!accessing!public! !
!WebApplicationAdministrationManager class categoriesFor: #restartApplication:port:startParameters:serverClusterManager:redistributeServerImage:!public! !
!WebApplicationAdministrationManager class categoriesFor: #restartApplicationOnDolphinVM:port:startParameters:!private! !
!WebApplicationAdministrationManager class categoriesFor: #restartApplicationOnVastLinuxVM:port:startParameters:!private! !
!WebApplicationAdministrationManager class categoriesFor: #restartApplicationOnVastWindowsVM:port:startParameters:!private! !
!WebApplicationAdministrationManager class categoriesFor: #scheduleApplicationServerRestartAt:port:startParameters:serverClusterManager:!public! !
!WebApplicationAdministrationManager class categoriesFor: #shutdownAllWebServerAndWebApplicationInstances!private! !
!WebApplicationAdministrationManager class categoriesFor: #startUploadedApplication:onPort:additionalArguments:serverClusterManager:!public! !

