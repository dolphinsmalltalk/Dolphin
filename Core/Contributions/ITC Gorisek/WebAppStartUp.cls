"Filed out from Dolphin Smalltalk X6.1"!

RuntimeSessionManager subclass: #WebAppStartUp
	instanceVariableNames: 'errorLog errorLogSemaphore switches'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebAppStartUp guid: (GUID fromString: '{5282C00A-4DB2-45D7-8899-AABED212AB76}')!
WebAppStartUp comment: ''!
!WebAppStartUp categoriesForClass!Unclassified! !
!WebAppStartUp methodsFor!

errorLog

	errorLog isNil
		ifTrue: [ errorLog := FileStream write: ItcSystemManager startUpDirectoryPath, 'ERROR.LOG' mode: #append ].
	^errorLog!

logError: anException 
	^self logError: anException terminateAfterWritingLog: true!

logError: anException terminateAfterWritingLog: aBoolean 
	| stream session webUser |
	
	[stream := self errorLog.
	session := self webSession.
	webUser := session notNil ifTrue: [session usernameInfo] ifFalse: ['/'].
	stream 
		nextPutAll: '
Error at ' , Timestamp now asFilenameString , '
User: ' , webUser 
				, '
Description: ' , anException itcDescription 
				, '[' , anException messageText asWebString 
				, ']
'.
	anException printTraceOn: stream depth: 50.
	stream
		cr;
		cr;
		flush] 
			on: Error
			do: [:e | e exitWith: nil].
	^(anException isUserResumable or: [aBoolean == false]) 
		ifTrue: [anException]
		ifFalse: [Processor activeProcess itcSafeTerminate]!

makeOmniBaseBackupFor: application 
	| db |
	db := application db class openOn: application omniBasePath.
	
	[db 
		createBackupOn: application dbBackupLocalDirectory , '/' , application applicationPath 
				, '-ODB-' , Timestamp now asFilenameString] 
			ensure: [db close]!

parseCommandLine
	| stream arg value serverClass portNumber pn result |
	switches := Set new.
	result := true.
	serverClass := WebHttpServer.
	stream := ReadStream on: self argv.
	[stream atEnd] whileFalse: 
			[arg := stream next asUppercase.
			('-PORT*' match: arg) 
				ifTrue: 
					[value := (arg copyFrom: 6 to: arg size) itcAsInteger.
					value < 80 ifFalse: [portNumber := value]]
				ifFalse: 
					["		arg asUppercase = '-HTTPS'
			ifTrue: [serverClass := WebHttpsServer]"
					(arg size > 1 and: [arg first = $-]) ifTrue: [switches add: (arg copyFrom: 2 to: arg size)]]].
	
	[pn := portNumber isNil ifTrue: [80] ifFalse: [portNumber].
	portNumber isNil ifTrue: [serverClass startup] ifFalse: [serverClass startupOnPort: portNumber]] 
			on: SocketError
			do: 
				[:ex | 
				result := false.
				MessageBox 
					errorMsg: ('Ob zagonu strežnika e-obraèuni je prišlo do napake:

" Strežniški port št. %1 je zaseden. "

Možen vzrok za napako:

(1) Internetni strežnik je že zagnan na portu %1. Dvojni zagon programa ni mogoè.

(2) Na portu %1 teèe drug internetni strežnik, ki je zasedel potreben port.

Predlog rešitve:

(a) Zaustavite strežnik, ki že teèe na portu %1.

(b) Strežnik e-obraèuni zaženite na drugem portu z ukazom:

     obracuni -port<št.porta>
' 
							webTranslateWith: pn printString)
					caption: '[WikiDoc] Napaka'].
	^result!

runBackupProcessFor: application 
	
	[| timeNow |
	[true] whileTrue: 
			[(timeNow := Time now asSeconds) >= 3600 
				ifTrue: [(Delay forSeconds: 86400 - timeNow + 3600) wait]
				ifFalse: [(Delay forSeconds: 3600 - timeNow) wait].
			ItcSystemManager forkNewProcessOn: 
					[application db class name = #OmniBase 
						ifTrue: [self makeOmniBaseBackupFor: application]
						ifFalse: [self makePsqlBackupFor: application]]
				named: 'Database backup in progress'.
			(Delay forSeconds: 600) wait]] 
			forkAt: ItcSystemManager cronJobDaemonPriority!

serverLogStream
	^self stdout!

startApplication: webApplication 
	[webApplication startup] on: Error
		do: 
			[:ex | 
			self writeErrorLog: ex.
			MessageBox errorMsg: 'The following error occured during server startup:

' , ex description 
						, '


File ERROR.LOG was generated with detailed description of this error.

Plase send the ERROR.LOG and SERVER_LOG_nnn.TXT
by e-mail to info@e-racuni.com to receive support concerning this error.

(log files are located in the program files folder, most probably in C:\Program Files\...)'.
			self exit].
	WebTranslationService defaultLanguage: webApplication defaultLanguage.
	webApplication hasDbBackup 
		ifTrue: 
			[ItcSystemManager logLine: 'Starting database backup daemon for ' , webApplication urlPrefix.
			self runBackupProcessFor: webApplication]!

unhandledException: anException 
	"Private - The unhandled Exception, anException, occurred in the active Process.
	Depending on the user response and the resumability of the exception, either 
	resume or terminate the process.
	Note: The exception response protocol (#resume, #pass, #outer, #exit, etc)
	can only be sent to an Exception inside a handler block (i.e. the second
	argument to BlockClosure>>on:do:)."

	| session webUser |
	session := self webSession.
	webUser := session notNil ifTrue: [session usernameInfo] ifFalse: ['/'].
	(self stderr)
		nextPutAll: '
Error at ' , Timestamp now asFilenameString , '
User: ' , webUser 
					, '
Description: ' , anException description 
					, '
';
		flush.
	self logError: anException.
	^anException isUserResumable 
		ifTrue: [anException]
		ifFalse: [Processor activeProcess itcSafeTerminate]!

writeErrorLog: anException 
	^self writeErrorLog: anException terminateAfterWritingLog: true!

writeErrorLog: anException terminateAfterWritingLog: aBoolean 
	| session webUser |
	session := self webSession.
	webUser := session notNil ifTrue: [session usernameInfo] ifFalse: ['/'].
	(self stderr)
		nextPutAll: '
Error at ' , Timestamp now asFilenameString , '
User: ' , webUser 
					, '
Description: ' , anException itcDescription 
					, '
';
		flush.
	self logError: anException terminateAfterWritingLog: aBoolean! !
!WebAppStartUp categoriesFor: #errorLog!public! !
!WebAppStartUp categoriesFor: #logError:!public! !
!WebAppStartUp categoriesFor: #logError:terminateAfterWritingLog:!public! !
!WebAppStartUp categoriesFor: #makeOmniBaseBackupFor:!public! !
!WebAppStartUp categoriesFor: #parseCommandLine!public! !
!WebAppStartUp categoriesFor: #runBackupProcessFor:!public! !
!WebAppStartUp categoriesFor: #serverLogStream!public! !
!WebAppStartUp categoriesFor: #startApplication:!public! !
!WebAppStartUp categoriesFor: #unhandledException:!public! !
!WebAppStartUp categoriesFor: #writeErrorLog:!public! !
!WebAppStartUp categoriesFor: #writeErrorLog:terminateAfterWritingLog:!public! !

!WebAppStartUp class methodsFor!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^WebApplicationServerShell! !
!WebAppStartUp class categoriesFor: #mainShellClass!constants!public! !

