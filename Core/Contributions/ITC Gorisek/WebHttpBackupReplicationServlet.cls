"Filed out from Dolphin Smalltalk X6.1"!

WebHttpServlet subclass: #WebHttpBackupReplicationServlet
	instanceVariableNames: 'mutex currentToken currentIP currentFilename lastRequestTS lastPosition hashList'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebHttpBackupReplicationServlet guid: (GUID fromString: '{3A36B296-9641-4067-9BC6-718AC262B616}')!
WebHttpBackupReplicationServlet comment: ''!
!WebHttpBackupReplicationServlet categoriesForClass!Unclassified! !
!WebHttpBackupReplicationServlet methodsFor!

denyReponseFrom: request on: stream reason: reason 
	ItcSystemManager 
		logLineWithTS: application urlPrefix , ' backup replication GET denied  IP: ' 
				, request clientIP asWebString , ' Hostname: ' 
				, request clientHostname , ' Reason: ' 
				, reason.
	stream fileNotFoundResponse!

initialize
	mutex := Semaphore forMutualExclusion.
	self loadHashList!

loadHashList
	| fs line |
	hashList := OrderedCollection new.
	[fs := FileStream read: self class hashListFilename] on: Error
		do: 
			[:ex | 
			ItcSystemManager 
				logLineWithTS: 'Backup replication hash list file opening error ' , ex itcDescription asWebString].
	fs isFileStream 
		ifTrue: 
			[
			[[fs atEnd] whileFalse: 
					[line := fs nextLine.
					line isNilOrEmpty ifFalse: [hashList add: line]]] 
					ensure: [fs close]]!

processGet: request on: stream 
	| position fs |
	(lastRequestTS isNil or: [currentToken isNil]) 
		ifTrue: 
			[^self 
				denyReponseFrom: request
				on: stream
				reason: 'no active session'].
	(currentToken notNil and: [(request header cookieAt: 'BackupTokenID') = currentToken]) 
		ifFalse: 
			[^self 
				denyReponseFrom: request
				on: stream
				reason: 'bad session id'].
	(ItcSystemManager absoluteSecondsClockValue - lastRequestTS between: 0 and: 3600) 
		ifFalse: 
			[lastRequestTS := nil.
			currentFilename := nil.
			currentToken := nil.
			currentIP := nil.
			^self 
				denyReponseFrom: request
				on: stream
				reason: 'session expired'].
	position := request integerAt: 'pos'.
	(position notNil and: [position >= lastPosition]) 
		ifFalse: 
			[^self 
				denyReponseFrom: request
				on: stream
				reason: 'bad position request'].
	lastPosition := position.
	lastRequestTS := ItcSystemManager absoluteSecondsClockValue.
	ItcSystemManager 
		logLineWithTS: application urlPrefix , ' backup replication sending block at ' 
				, position printString , ' IP: ' 
				, request clientIP asWebString.
	fs := FileStream read: currentFilename text: false.
	
	[fs position: position.
	stream
		contentType: 'application/x-zip';
		isBytes: true;
		nextPutAll: (fs next: (fs size - position min: 1048576))] 
			ensure: [fs close]!

processPost: request on: stream 
	| password hash hostname forceBackup |
	password := request contents.
	forceBackup := '*forceBackup=1' match: request header url.
	hash := self class getHashFor: password.
	hostname := request clientHostname.
	ItcSystemManager 
		logLineWithTS: application urlPrefix , ' backup replication received request IP: ' 
				, currentIP asWebString , ' Hostname: ' 
				, hostname.
	hashList isNilOrEmpty 
		ifTrue: [self loadHashList]
		ifFalse: 
			[hash isNil 
				ifFalse: 
					[(hashList includes: hash) 
						ifFalse: 
							["reload hash list in case it (the file) was changed since the last time it was loaded"
							self loadHashList]]].
	hashList isNilOrEmpty 
		ifTrue: 
			[ItcSystemManager logLineWithTS: application urlPrefix , ' backup replication HASH list is empty'].
	(hashList includes: hash) 
		ifTrue: 
			[hashList remove: hash.
			self writeHashList.
			currentIP := request clientIP.
			forceBackup 
				ifTrue: 
					["forcibly make another backup file if the current one is older than 6 hours"
					| a |
					a := application getLastDatabaseBackupFileNameAndTimestamp.
					(a isNil or: [Timestamp now totalSeconds - a last totalSeconds > 21600]) 
						ifTrue: 
							[ItcSystemManager 
								logLineWithTsAndSession: 'Starting forced database backup for on-line remote backup process.'.
							[ItcSystemManager startUpSessionManager makePsqlBackupFor: application] fork.
							(Delay forSeconds: 20) wait]].
			currentFilename := application dbBackupLocalDirectory , ItcSystemManager pathSeparatorString 
						, application getLastDatabaseBackupFileName.
			currentToken := application getNewSessionId 
						, ItcSystemManager absoluteMillisecondsClockValue printString 
							, ItcSystemManager generateRandomString.
			lastRequestTS := ItcSystemManager absoluteSecondsClockValue.
			lastPosition := 0.
			stream 
				setCookieNamed: 'BackupTokenID'
				value: currentToken
				path: '/'
				expires: (Timestamp fromSeconds: (Timestamp now asSeconds + 60) * 60 * 3)
				domain: nil
				secure: true.
			stream
				contentType: 'application/octet-stream';
				nextPutAll: currentFilename;
				cr;
				nextPutAll: (ItcSystemManager fileDataFor: currentFilename) last printString;
				cr.
			ItcSystemManager 
				logLineWithTS: application urlPrefix , ' backup replication started. IP: ' , currentIP asWebString 
						, ' Hostname: ' , hostname 
						, ' File: ' , currentFilename]
		ifFalse: 
			[ItcSystemManager 
				logLineWithTS: application urlPrefix , ' backup replication ACCESS DENIED  IP: ' 
						, currentIP asWebString , ' Hostname: ' 
						, hostname.
			stream fileNotFoundResponse]!

writeHashList
	| fs |
	fs := FileStream write: self class hashListFilename text: true.
	[hashList do: 
			[:eachHash | 
			fs
				nextPutAll: eachHash;
				cr]] ensure: [fs close]! !
!WebHttpBackupReplicationServlet categoriesFor: #denyReponseFrom:on:reason:!public! !
!WebHttpBackupReplicationServlet categoriesFor: #initialize!public! !
!WebHttpBackupReplicationServlet categoriesFor: #loadHashList!public! !
!WebHttpBackupReplicationServlet categoriesFor: #processGet:on:!public! !
!WebHttpBackupReplicationServlet categoriesFor: #processPost:on:!public! !
!WebHttpBackupReplicationServlet categoriesFor: #writeHashList!private! !

!WebHttpBackupReplicationServlet class methodsFor!

generatePlainTextAndHashText
	"

		self generatePlainTextAndHashText

	"

	| plainTextStream str hashStream |
	plainTextStream := WriteStream on: String new.
	hashStream := WriteStream on: String new.
	365 timesRepeat: 
			[str := ''.
			[str size < 192] whileTrue: [str := str , ItcSystemManager generateRandomString].
			str := str trimToSize: 192.
			plainTextStream
				nextPutAll: str;
				cr.
			hashStream
				nextPutAll: (self getHashFor: str);
				cr].
	ItcSystemManager 
		logLine: '

Plaintext:
-------------------
' , plainTextStream contents 
				, '

Hash:
--------------------
' , hashStream contents 
				, '

'!

getHashFor: plainText 
	| hash1 hash2 hash3 |
	(plainText notNil and: [plainText size = 192]) ifFalse: [^nil].
	hash1 := MD5 hashMessage: (plainText copyFrom: 1 to: 64).
	hash2 := MD5 hashMessage: (plainText copyFrom: 65 to: 128).
	hash3 := MD5 hashMessage: (plainText copyFrom: 129 to: 192).
	^((hash1 bitXor: hash2 * (2 raisedTo: 64)) bitXor: hash3 * (2 raisedTo: 128)) asHexString 
		trimOrZeroPadToSize: 64!

hashListFilename
	^ItcSystemManager startUpDirectoryPath , 'BackupReplicationHashList.txt'!

isActivated
	^ItcSystemManager fileExists: self hashListFilename!

servletName
	^'RemoteLocationBackupReplication'! !
!WebHttpBackupReplicationServlet class categoriesFor: #generatePlainTextAndHashText!public! !
!WebHttpBackupReplicationServlet class categoriesFor: #getHashFor:!public! !
!WebHttpBackupReplicationServlet class categoriesFor: #hashListFilename!public! !
!WebHttpBackupReplicationServlet class categoriesFor: #isActivated!public! !
!WebHttpBackupReplicationServlet class categoriesFor: #servletName!public! !

