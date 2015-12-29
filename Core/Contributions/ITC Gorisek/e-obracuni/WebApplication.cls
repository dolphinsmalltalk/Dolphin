"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #WebApplication
	instanceVariableNames: 'db sessions sessionsSemaphore lastSessionId oidProvider scavenger expirationTime configurationSettings configurationSettingsMutex eMailQueueMutex eMailQueue eMailSendingMutex httpLoadBalancer serverClusterManager serverMessage scriptServlet cssServlet'
	classVariableNames: ''
	poolDictionaries: 'DialectAbstractionLayerNS'
	classInstanceVariableNames: 'singleton'!
WebApplication guid: (GUID fromString: '{B7F08E52-C130-4594-8154-53C9A58AC636}')!
WebApplication comment: ''!
!WebApplication categoriesForClass!Unclassified! !
!WebApplication methodsFor!

activeSessions
	| copy |
	(sessionsSemaphore isNil or: [sessions isNil]) ifTrue: [^#()].
	sessionsSemaphore critical: [copy := sessions values].
	^copy!

activeSuperSessions
	^self activeSessions select: [:each | each superSession isNil]!

applicationLanguages
	"Answer language IDs for language/messages files to be loaded. Default none will be loaded."

	^self configurationSettingsAt: #applicationLanguages
		ifAbsent: [self defaultApplicationLanguages]!

applicationPath
	self subclassResponsibility!

applicationRootDirectory
	^ItcSystemManager startUpDirectoryPath , self applicationPath 
		, ItcSystemManager pathSeparatorString!

basicStartup
	ItcSystemManager logLine: 'Loading messages...'.
	self loadMessages.
	ItcSystemManager 
		log: 'Registering application ' , self urlPrefix , ' ' , self currentReleaseId asWebString , ' ...'.
	self
		loadAllowedAndBlockedIPlist;
		loadServlets.
	(#WebHttpBackupReplicationServlet itcAsClassOrNil notNil 
		and: [#WebHttpBackupReplicationServlet itcAsClass isActivated]) 
			ifTrue: 
				[ItcSystemManager log: ' [db backup replication ON] '.
				self servletManager addServlet: #WebHttpBackupReplicationServlet itcAsClass new for: self].
	sessions := LookupTable new.
	sessionsSemaphore := Semaphore forMutualExclusion.
	eMailQueueMutex := Semaphore forMutualExclusion.
	eMailSendingMutex := Semaphore forMutualExclusion.
	eMailQueue := OrderedCollection new.
	expirationTime isNil ifTrue: [expirationTime := self defaultExpirationTime].
	self startExpiredSessionsScavengerProcess.
	ItcSystemManager logLine: ' OK'!

checkEmail: eMail 
	"Perform basic validity check of an eMail address and answer <true> if OK, else answer <false>."

	^ItcSystemManager checkEmail: eMail!

checkIpMatchFor: aString with: clientIP 
	| ipArr beginIp endIp arrBegin arrEnd arrClientIp |
	(aString includes: $-) ifFalse: [^aString match: clientIP].
	ipArr := aString itcSubStrings: $-.
	beginIp := ipArr first.
	endIp := ipArr last.
	(beginIp = clientIP or: [endIp = clientIP]) ifTrue: [^true].
	arrBegin := beginIp itcSubStrings: $..
	arrClientIp := clientIP itcSubStrings: $..
	arrEnd := endIp itcSubStrings: $..
	1 to: 4
		do: 
			[:ind | 
			((arrClientIp at: ind) itcAsInteger > (arrBegin at: ind) itcAsInteger 
				and: [(arrClientIp at: ind) itcAsInteger < (arrEnd at: ind) itcAsInteger]) ifTrue: [^true].
			((arrClientIp at: ind) itcAsInteger < (arrBegin at: ind) itcAsInteger 
				or: [(arrClientIp at: ind) itcAsInteger > (arrEnd at: ind) itcAsInteger]) ifTrue: [^false]].
	^true!

checkUsername: username 
	"Perform basic validity check of an username and answer <nil> if OK, else answer error message string."

	username size < 2 ifTrue: [^'asp.user.error.UsernameTooShort'].
	^(username 
		conform: [:eachLetter | '@ABCDEFGHIJKLMNOPQRSTUVWXYZ-0123456789._' includes: eachLetter]) 
			ifFalse: ['asp.user.error.UsernameWithInvalidCharacters']!

compressMessages
	| messagesPath |
	messagesPath := self applicationRootDirectory , 'nls' , ItcSystemManager pathSeparatorString.
	self applicationLanguages do: [:each | WebTranslationService compressNlsFile: messagesPath , each]!

configuration
	^nil!

configurationFileName
	"Ime konfiguracijske datoteke se vzame iz config dictionary-ja zato, ker je dodana moznost,
	da se pri start-upu doloci iz katere configuracijske datoteke se nalozijo parametri."

	^self configurationSettingsAt: #configurationFileName ifAbsent: [self applicationPath , '.cfg']!

configurationSettingsAt: aString 
	^configurationSettings isNil 
		ifFalse: 
			[configurationSettingsMutex critical: 
					[configurationSettings 
						at: (aString class == Symbol ifTrue: [aString] ifFalse: [aString asUppercase])
						ifAbsent: []]]!

configurationSettingsAt: aString ifAbsent: aBlock 
	configurationSettings isNil ifTrue: [^aBlock value].
	^configurationSettingsMutex isNil 
		ifTrue: 
			[configurationSettings 
				at: (aString class == Symbol ifTrue: [aString] ifFalse: [aString asUppercase])
				ifAbsent: aBlock]
		ifFalse: 
			[configurationSettingsMutex critical: 
					[configurationSettings 
						at: (aString class == Symbol ifTrue: [aString] ifFalse: [aString asUppercase])
						ifAbsent: aBlock]]!

configurationSettingsAt: aString put: anObject 
	| key |
	key := aString class == Symbol ifTrue: [aString] ifFalse: [aString asUppercase].
	configurationSettings isNil ifTrue: [configurationSettings := LookupTable new].
	configurationSettingsMutex isNil 
		ifTrue: [configurationSettings at: key put: anObject]
		ifFalse: [configurationSettingsMutex critical: [configurationSettings at: key put: anObject]]!

configurationSettingsBooleanAt: aSymbol 
	"Answer <true> of <false> value of the configuration file parameter in section [Application].

	Default if absent always answer <false>. Symbols can be used instead of strings so that it is easier to track symbols.
	"

	| str |
	str := aSymbol asString.
	(str beginsWith: 'application') ifFalse: [self error: 'Invalid parameter'].
	str := (self configurationSettingsAt: 'application.' , (str copyFrom: 'application' size + 1)
				ifAbsent: ['']) asUppercase.
	^str = 'TRUE' or: [str = 'YES' or: [str = 'ON' or: [str = 'Y' or: [str = '1']]]]!

cssRootPath
	^'css'!

cssServlet
	^cssServlet!

cssStyleItcDefault
	^''!

cssStyleItcDefaultForMobileClient
	^self cssStyleItcDefault!

currentReleaseId
	^''!

db
	^db!

dbBackupDestination
	^self configurationSettingsAt: 'application.dbBackupDestination' ifAbsent: []!

dbBackupLocalDirectory
	^self configurationSettingsAt: 'application.dbBackupLocalDirectory'
		ifAbsent: [ItcSystemManager startUpDirectoryPath]!

dbBackupUpload
	^(self configurationSettingsAt: 'application.dbBackupUpload' ifAbsent: ['']) asUppercase = 'YES'!

dbBackupUploadPassword
	^self configurationSettingsAt: 'application.dbBackupUploadPassword' ifAbsent: []!

dbBackupUploadUrl
	^self configurationSettingsAt: 'application.dbBackupUploadUrl' ifAbsent: []!

dbBackupUploadUsername
	^self configurationSettingsAt: 'application.dbBackupUploadUsername' ifAbsent: []!

dbName
	| dbName |
	^(dbName := self configurationSettingsAt: #dbName) isNilOrEmpty 
		ifFalse: [dbName]
		ifTrue: [self configurationSettingsAt: 'Database Access.Database']!

dbPassword
	| dbPassword |
	^(dbPassword := self configurationSettingsAt: #dbPassword) isNilOrEmpty 
		ifFalse: [dbPassword]
		ifTrue: [self configurationSettingsAt: 'Database Access.Password']!

dbUsername
	| dbUsername |
	^(dbUsername := self configurationSettingsAt: #dbUsername) isNilOrEmpty 
		ifFalse: [dbUsername]
		ifTrue: [self configurationSettingsAt: 'Database Access.User']!

defaultApplicationLanguages
	"Answer language IDs for language/messages files to be loaded. Default none will be loaded."

	^#()!

defaultCodePage
	^nil!

defaultExpirationTime
	"Answer default time period after which a session will expire.
	The value here can be overriden with configuration file settings."

	| t |
	t := self configurationSettingsAt: 'application.sessionExpirationTime'.
	t isNil ifFalse: [t := t itcAsInteger].
	^(t isNil or: [t = 0]) ifTrue: [45] ifFalse: [t]!

defaultLanguage
	^self configurationSettingsAt: 'application.defaultLanguage' ifAbsent: ['English']!

defaultLocalization
	self defaultLanguage = 'Slovene' ifTrue: [^'SI'].
	self defaultLanguage = 'Serbian' ifTrue: [^'RS'].
	self defaultLanguage = 'Croatian' ifTrue: [^'HR'].
	self defaultLanguage = 'Russian' ifTrue: [^'RU'].
	self defaultLanguage = 'Bosnian' ifTrue: [^'BA'].
	self defaultLanguage = 'German' ifTrue: [^'DE'].
	self defaultLanguage = 'Czech' ifTrue: [^'CZ'].
	^'EN'!

defaultSenderEmail
	^self configurationSettingsAt: 'MailServer.SMTPMailFrom'!

digits
	^'1032547698zyxwvutsrqponmlkjihgfedcbaABCDEFGHIJKLMNOPQRSTUVWXYZ'!

domainName
	"Answer domain name string coming to this application. This is to enable virtual hosting
	i.e. multiple domain names under the same IP address. This way one could host www.sun.com
	and www.microsoft.com both on the same server with the same IP.
	Answer '...' for any domain name."

	"For example: ^'www.smalltalk.org'"

	^'...'!

emptyEmailQueue
	| smtpConnector message |
	eMailSendingMutex critical: 
			[eMailQueue isEmpty ifTrue: [^self].
			smtpConnector := self smtpConnector.
			
			[[eMailQueueMutex critical: [eMailQueue notEmpty and: [(message := eMailQueue removeFirst) notNil]]] 
				whileTrue: 
					[
					["ker se je zgodilo, da SMTP server ni javil time-outa in zaprl connection-a sem dodal time-out na nasi strani."

					"6 minut za posiljanje posameznega e-maila bi moralo biti preko zadosti"
					(Processor activeProcess)
						webApplication: self;
						webHttpRequestDeadline: nil;
						webHttpRequestExtendDeadline: 360.
					ItcSystemManager isRuntime ifTrue: [smtpConnector sendMessage: message value].
					ItcSystemManager 
						logLineWithTsAndSession: 'Mail sent to: ' , message value getRecipients asWebString] 
							on: Error
							do: 
								[:ex | 
								ItcSystemManager isRuntime ifTrue: [ItcSystemManager writeErrorLog: ex] ifFalse: [ex signal].
								"try to send it again if sent only once"
								message key < 1 
									ifTrue: 
										[message key: message key + 1.
										eMailQueueMutex critical: [eMailQueue add: message]].
								ex exitWith: nil]]] 
					ensure: [smtpConnector close]]!

fileBackupDestination
	"Example for the configuration file:

	[Application]
	;set where to copy files during backup of application files
	fileBackupDestination=E:\Files\MyApp

	"

	^self configurationSettingsAt: 'Application.fileBackupDestination' ifAbsent: []!

generateRandom1
	| random |
	random := 'dummy' copy identityHash + Time millisecondClockValue.
	10 timesRepeat: [random := random * 2 bitXor: 'asdads' copy identityHash].
	^random!

generateRandom2
	| random |
	random := 'poipkjy' copy identityHash + Time millisecondClockValue.
	10 timesRepeat: [random := random * 2 bitXor: 'asdads' copy identityHash].
	^random!

getLastDatabaseBackupFileName
	"Answer the filename of the last database backup file made."

	| filenames template dbName |
	dbName := self dbName.
	(dbName includes: $|) ifTrue: [dbName := (dbName itcSubStrings: $|) first].
	template := (dbName itcSubStrings: $/) last , '-*.*'.
	filenames := ((ItcSystemManager getAllFilenamesInDirectory: self dbBackupLocalDirectory) 
				select: [:each | template match: each]) asSortedCollection: [:a :b | a < b].
	filenames isEmpty ifFalse: [^filenames last].
	template := self urlPrefix , '-*.*'.
	filenames := ((ItcSystemManager getAllFilenamesInDirectory: self dbBackupLocalDirectory) 
				select: [:each | template match: each]) asSortedCollection: [:a :b | a < b].
	filenames isEmpty ifFalse: [^filenames last].
	template := self applicationPath , '-*.*'.
	filenames := ((ItcSystemManager getAllFilenamesInDirectory: self dbBackupLocalDirectory) 
				select: [:each | template match: each]) asSortedCollection: [:a :b | a < b].
	^filenames isEmpty ifFalse: [^filenames last]!

getLastDatabaseBackupFileNameAndTimestamp
	"Answer the filename and timestamp of the last database backup file made as array."

	| fileName fd |
	fileName := self getLastDatabaseBackupFileName.
	^fileName isNil 
		ifFalse: 
			[fd := ItcSystemManager 
						fileDataFor: self dbBackupLocalDirectory , ItcSystemManager pathSeparatorString , fileName.
			Array with: fileName with: (fd at: 1)]!

getNewSessionId
	| str mod stream number idString count |
	sessionsSemaphore critical: 
			[lastSessionId isNil ifTrue: [lastSessionId := 0].
			count := lastSessionId := lastSessionId + 1].
	str := self digits.
	mod := str size.
	stream := WriteStream on: (String new: 100).
	4 timesRepeat: 
			[number := self generateRandom1.
			stream
				nextPut: (str at: number \\ mod + 1);
				nextPut: (str at: number // mod \\ mod + 1);
				nextPut: (str at: number // mod // mod \\ mod + 1).
			number := self generateRandom2.
			stream
				nextPut: (str at: number \\ mod + 1);
				nextPut: (str at: number // mod \\ mod + 1);
				nextPut: (str at: number // mod // mod \\ mod + 1)].
	idString := stream contents.
	idString
		at: 10 put: (str at: count \\ mod + 1);
		at: 13 put: (str at: count // mod \\ mod + 1);
		at: 17 put: (str at: count // mod // mod \\ mod + 1).
	^idString!

getNextIdFor: classId 
	^oidProvider getNextIdFor: classId!

getRealCssPathFor: cssPath 
	^(cssPath isSymbol 
		and: [(cssPath beginsWith: 'cssStyle') and: [(cssPath endsWithUppercase: '.CSS') not]]) 
			ifTrue: ['/' , self urlPrefix , '/' , self cssServlet servletName , '/' , cssPath , '.css']
			ifFalse: ['/' , self urlPrefix , '/' , self cssRootPath , '/' , cssPath]!

getRealJavascriptPathFor: scriptPath 
	^(scriptPath isSymbol 
		and: [(scriptPath beginsWith: 'javascript') and: [(scriptPath endsWithUppercase: '.JS') not]]) 
			ifTrue: ['/' , self urlPrefix , '/' , self scriptServlet servletName , '/' , scriptPath , '.js']
			ifFalse: ['/' , self urlPrefix , '/' , self scriptRootPath , '/' , scriptPath]!

getUserLanguageBasedOnIPandRequestFor: request 
	| header |
	header := request header.
	((header acceptsLanguage: 'sl') or: [self isSlovenianIP: request clientIP]) ifTrue: [^'Slovene'].
	((header acceptsLanguage: 'sr') or: [self isSerbianIP: request clientIP]) ifTrue: [^'Serbian'].
	((header acceptsLanguage: 'hr') or: [self isCroatianIP: request clientIP]) ifTrue: [^'Croatian'].
	^nil!

hasDbBackup
	"Answer <true> if a database backup should be performed for this application.
	Default is no, otherwise take it from configuration file."

	| value |
	value := self configurationSettingsAt: 'application.dbBackup' ifAbsent: [^false].
	^value asUppercase = 'YES'!

httpLoadBalancer
	^httpLoadBalancer!

indexServlet
	^self servletManager indexServletFor: self!

ipRangeListForBulgaria
	"IP address list found on: http://proxysecurity.com/ip-address-range.php?country=BULGARIA

	see also http://www.ripe.net/perl/whois?form_type=simple&full_query_string=&searchtext=193.189.182.1&do_search=Search
	for checking IP addresses which are not included in proxysecurity list (not every address is covered there).
	"
	^#(
'62.44.96.0-62.44.127.255'
'62.73.64.0-62.73.127.255'
'62.176.64.0-62.176.127.255'
'62.204.128.0-62.204.159.255'
'62.213.160.0-62.213.191.255'
'80.72.64.0-80.72.95.255'
'80.80.128.0-80.80.159.255'
'80.95.16.0-80.95.31.255'
'80.246.192.0-80.246.207.255'
'80.253.48.0-80.253.63.255'
'81.161.208.0-81.161.223.255'
'81.161.240.0-81.161.255.255'
'82.101.64.0-82.101.127.255'
'82.103.64.0-82.103.127.255'
'82.118.224.0-82.118.255.255'
'82.119.64.0-82.119.95.255'
'82.137.64.0-82.137.127.255'
'82.146.0.0-82.146.31.255'
'82.147.128.0-82.147.159.255'
'82.199.192.0-82.199.223.255'
'83.97.24.0-83.97.31.255'
'83.97.64.0-83.97.71.255'
'83.142.16.0-83.142.23.255'
'83.143.144.0-83.143.151.255'
'83.143.176.0-83.143.183.255'
'83.143.248.0-83.143.255.255'
'83.148.64.0-83.148.127.255'
'83.222.160.0-83.222.191.255'
'83.228.0.0-83.228.127.255'
'84.21.192.0-84.21.223.255'
'84.22.0.0-84.22.31.255'
'84.43.128.0-84.43.255.255'
'84.54.128.0-84.54.191.255'
'84.201.192.0-84.201.207.255'
'84.238.128.0-84.238.255.255'
'84.242.128.0-84.242.191.255'
'84.252.0.0-84.252.63.255'
'85.11.128.0-85.11.191.255'
'85.14.0.0-85.14.63.255'
'85.91.128.0-85.91.159.255'
'85.95.64.0-85.95.95.255'
'85.118.64.0-85.118.95.255'
'85.118.192.0-85.118.199.255'
'85.130.0.0-85.130.127.255'
'85.187.0.0-85.187.255.255'
'85.196.128.0-85.196.191.255'
'85.217.128.0-85.217.255.255'
'85.239.128.0-85.239.159.255'
'85.255.128.0-85.255.143.255'
'85.255.160.0-85.255.175.255'
'87.97.128.0-87.97.255.255'
'87.116.64.0-87.116.127.255'
'87.118.128.0-87.118.191.255'
'87.119.64.0-87.119.127.255'
'87.120.0.0-87.121.255.255'
'87.126.0.0-87.126.255.255'
'87.227.128.0-87.227.255.255'
'87.239.152.0-87.239.159.255'
'87.246.0.0-87.246.63.255'
'87.247.248.0-87.247.255.255'
'87.252.160.0-87.252.191.255'
'88.80.96.0-88.80.159.255'
'88.87.0.0-88.87.31.255'
'88.203.128.0-88.203.255.255'
'88.213.192.0-88.213.255.255'
'89.106.96.0-89.106.127.255'
'89.186.192.0-89.186.223.255'
'193.16.102.0-193.16.102.255'
'193.16.157.0-193.16.157.255'
'193.16.246.0-193.16.246.255'
'193.17.229.0-193.17.229.255'
'193.19.172.0-193.19.175.255'
'193.22.103.0-193.22.103.255'
'193.22.248.0-193.22.248.255'
'193.23.52.0-193.23.52.255'
'193.24.240.0-193.24.243.255'
'193.25.162.0-193.25.163.255'
'193.26.14.0-193.26.14.255'
'193.26.216.0-193.26.216.255'
'193.28.250.0-193.28.250.255'
'193.29.55.0-193.29.55.255'
'193.30.228.0-193.30.231.255'
'193.41.64.0-193.41.67.255'
'193.41.182.0-193.41.183.255'
'193.41.188.0-193.41.191.255'
'193.41.206.0-193.41.206.255'
'193.43.26.0-193.43.26.255'
'193.47.74.0-193.47.74.255'
'193.84.86.0-193.84.86.255'
'193.93.24.0-193.93.27.255'
'193.108.24.0-193.108.24.255'
'193.108.32.0-193.108.33.255'
'193.109.54.0-193.109.55.255'
'193.110.82.0-193.110.82.255'
'193.110.132.0-193.110.132.255'
'193.110.159.0-193.110.159.255'
'193.110.216.0-193.110.223.255'
'193.111.89.0-193.111.89.255'
'193.111.194.0-193.111.195.255'
'193.138.67.0-193.138.67.255'
'193.151.20.0-193.151.23.255'
'193.151.80.0-193.151.83.255'
'193.178.152.0-193.178.153.255'
'193.178.166.0-193.178.166.255'
'193.178.222.0-193.178.222.255'
'193.192.48.0-193.192.49.255'
'193.192.56.0-193.192.57.255'
'193.193.162.0-193.193.164.255'
'193.193.182.0-193.193.182.255'
'193.194.140.0-193.194.141.255'
'193.194.156.0-193.194.156.255'
'193.200.0.0-193.200.255.255'
'193.201.114.0-193.201.115.255'
'193.201.172.0-193.201.172.255'
'193.201.240.0-193.201.243.255'
'193.254.29.0-193.254.29.255'
'194.8.53.0-194.8.53.255'
'194.8.60.0-194.8.60.255'
'194.12.224.0-194.12.255.255'
'194.50.73.0-194.50.73.255'
'194.50.76.0-194.50.76.255'
'194.50.122.0-194.50.122.255'
'194.54.140.0-194.54.147.255'
'194.63.136.0-194.63.139.255'
'194.79.12.0-194.79.15.255'
'194.141.0.0-194.141.255.255'
'194.145.63.0-194.145.63.255'
'194.145.160.0-194.145.163.255'
'194.146.232.0-194.146.235.255'
'194.150.116.0-194.150.119.255'
'194.150.180.0-194.150.181.255'
'194.153.145.0-194.153.145.255'
'194.187.132.0-194.187.135.255'
'194.246.110.0-194.246.111.255'
'195.10.193.0-195.10.193.255'
'195.22.146.0-195.22.147.255'
'195.24.32.0-195.24.63.255'
'195.24.88.0-195.24.95.255'
'195.34.96.0-195.34.127.255'
'195.39.198.0-195.39.199.255'
'195.39.212.0-195.39.213.255'
'195.47.193.0-195.47.193.255'
'195.62.22.0-195.62.23.255'
'195.68.200.0-195.68.201.255'
'195.68.214.0-195.68.215.255'
'195.69.108.0-195.69.111.255'
'195.69.120.0-195.69.123.255'
'195.69.164.0-195.69.167.255'
'195.72.112.0-195.72.112.255'
'195.85.215.0-195.85.215.255'
'195.96.224.0-195.96.255.255'
'195.114.112.0-195.114.113.255'
'195.128.224.0-195.128.225.255'
'195.137.252.0-195.137.253.255'
'195.138.128.0-195.138.159.255'
'195.149.248.0-195.149.255.255'
'195.170.166.0-195.170.166.255'
'195.177.218.0-195.177.219.255'
'195.177.248.0-195.177.249.255'
'195.178.98.0-195.178.99.255'
'195.214.248.0-195.214.255.255'
'195.225.124.0-195.225.127.255'
'195.225.252.0-195.225.255.255'
'195.230.0.0-195.230.31.255'
'195.234.84.0-195.234.87.255'
'195.234.236.0-195.234.239.255'
'195.238.84.0-195.238.85.255'
'195.242.106.0-195.242.107.255'
'195.242.126.0-195.242.127.255'
'195.242.240.0-195.242.243.255'
'195.246.240.0-195.246.241.255'
'212.5.128.0-212.5.159.255'
'212.7.192.0-212.7.223.255'
'212.21.128.0-212.21.159.255'
'212.25.32.0-212.25.63.255'
'212.36.0.0-212.36.31.255'
'212.39.64.0-212.39.95.255'
'212.50.0.0-212.50.31.255'
'212.56.0.0-212.56.31.255'
'212.72.192.0-212.72.223.255'
'212.73.128.0-212.73.159.255'
'212.91.160.0-212.91.191.255'
'212.95.160.0-212.95.191.255'
'212.104.96.0-212.104.127.255'
'212.116.128.0-212.116.159.255'
'212.122.160.0-212.122.191.255'
'212.124.64.0-212.124.95.255'
'213.16.32.0-213.16.63.255'
'213.91.128.0-213.91.255.255'
'213.130.64.0-213.130.95.255'
'213.137.32.0-213.137.63.255'
'213.145.96.0-213.145.127.255'
'213.167.0.0-213.167.31.255'
'213.169.32.0-213.169.63.255'
'213.174.0.0-213.174.31.255'
'213.191.192.0-213.191.223.255'
'213.222.32.0-213.222.63.255'
'213.226.0.0-213.226.63.255'
'213.240.192.0-213.240.255.255'
'217.9.224.0-217.9.239.255'
'217.10.240.0-217.10.255.255'
'217.18.240.0-217.18.255.255'
'217.30.208.0-217.30.223.255'
'217.75.128.0-217.75.159.255'
'217.79.32.0-217.79.47.255'
'217.79.64.0-217.79.95.255'
'217.145.80.0-217.145.95.255'
'217.145.160.0-217.145.175.255'
'217.174.144.0-217.174.159.255'
'217.197.128.0-217.197.143.255'
)!

ipRangeListForCroatia
	^#(
'77.237.96.0-77.237.127.255'
'78.0.0.0-78.3.255.255'
'78.134.128.0-78.134.255.255'
'80.80.48.0-80.80.63.255'
'80.253.160.0-80.253.175.255'
'82.193.192.0-82.193.223.255'
'83.131.0.0-83.131.255.255'
'83.139.64.0-83.139.127.255'
'85.94.64.0-85.94.95.255'
'85.114.32.0-85.114.63.255'
'87.252.128.0-87.252.159.255'
'88.207.0.0-88.207.127.255'
'89.17.0.0-89.17.31.255'
'89.164.0.0-89.164.255.255'
'89.172.0.0-89.172.255.255'
'89.201.128.0-89.201.255.255'
'92.37.120.0-92.37.127.255'
'93.136.0.0-93.143.255.255'
'161.53.0.0-161.53.255.255'
'193.23.182.0-193.23.182.255'
'193.47.246.0-193.47.246.255'
'193.58.252.0-193.58.252.255'
'193.111.164.0-193.111.164.255'
'193.164.232.160-193.164.232.191'
'193.192.15.64-193.192.15.127'
'193.198.0.0-193.198.255.255'
'194.126.213.0-194.126.214.255'
'194.152.192.0-194.152.255.255'
'195.29.0.0-195.29.255.255'
'195.78.32.0-195.78.33.255'
'195.137.173.0-195.137.173.255'
'195.245.255.0-195.245.255.255'
'212.15.160.0-212.15.191.255'
'212.91.96.0-212.91.127.255'
'213.147.96.0-213.147.127.255'
'213.149.32.0-213.149.63.255'
'213.185.224.0-213.185.255.255'
'213.191.128.0-213.191.159.255'
'213.202.64.0-213.202.127.255'
'217.14.208.0-217.14.223.255'
'217.16.128.0-217.16.143.255'
'217.68.80.0-217.68.95.255'
'217.198.96.0-217.198.111.255'
)!

ipRangeListForRomania
	"IP address list found on: http://proxysecurity.com/ip-address-range.php?country=BULGARIA

	see also http://www.ripe.net/perl/whois?form_type=simple&full_query_string=&searchtext=193.189.182.1&do_search=Search
	for checking IP addresses which are not included in proxysecurity list (not every address is covered there).
	"
	^#(
'62.217.192.0-62.217.255.255'
'62.231.64.0-62.231.127.255'
'80.74.48.0-80.74.63.255'
'80.86.96.0-80.86.127.255'
'80.96.0.0-80.97.255.255'
'81.12.128.0-81.12.255.255'
'81.18.64.0-81.18.95.255'
'81.22.144.0-81.22.159.255'
'81.24.16.0-81.24.31.255'
'81.89.0.0-81.89.31.255'
'81.180.0.0-81.181.255.255'
'81.196.0.0-81.196.255.255'
'82.76.0.0-82.79.255.255'
'82.137.0.0-82.137.63.255'
'82.208.128.0-82.208.191.255'
'83.103.128.0-83.103.255.255'
'83.143.32.0-83.143.39.255'
'83.166.192.0-83.166.223.255'
'83.243.120.0-83.243.127.255'
'84.232.128.0-84.232.255.255'
'84.234.96.0-84.234.111.255'
'84.243.64.0-84.243.127.255'
'84.247.0.0-84.247.127.255'
'85.9.0.0-85.9.63.255'
'85.120.0.0-85.123.255.255'
'85.158.216.0-85.158.223.255'
'85.186.0.0-85.186.255.255'
'85.204.0.0-85.204.255.255'
'86.34.0.0-86.35.255.255'
'86.55.0.0-86.55.255.255'
'86.104.0.0-86.107.255.255'
'86.120.0.0-86.127.255.255'
'87.237.104.0-87.237.111.255'
'87.239.160.0-87.239.167.255'
'87.239.224.0-87.239.231.255'
'87.239.248.0-87.239.255.255'
'88.158.0.0-88.158.255.255'
'89.32.0.0-89.47.255.255'
'89.114.0.0-89.115.255.255'
'89.120.0.0-89.123.255.255'
'89.136.0.0-89.137.255.255'
'89.149.0.0-89.149.63.255'
'89.165.128.0-89.165.255.255'
'193.0.225.0-193.0.225.255'
'193.16.148.0-193.16.148.255'
'193.16.213.0-193.16.213.255'
'193.16.218.0-193.16.218.255'
'193.16.221.0-193.16.221.255'
'193.17.70.0-193.17.70.255'
'193.17.195.0-193.17.195.255'
'193.17.220.0-193.17.220.255'
'193.19.192.0-193.19.195.255'
'193.22.93.0-193.22.93.255'
'193.22.95.0-193.22.95.255'
'193.22.141.0-193.22.141.255'
'193.22.173.0-193.22.173.255'
'193.24.0.0-193.24.0.255'
'193.24.31.0-193.24.31.255'
'193.25.104.0-193.25.105.255'
'193.25.110.0-193.25.113.255'
'193.26.7.0-193.26.7.255'
'193.26.10.0-193.26.10.255'
'193.26.129.0-193.26.129.255'
'193.26.219.0-193.26.219.255'
'193.27.70.0-193.27.73.255'
'193.27.84.0-193.27.85.255'
'193.28.151.0-193.28.151.255'
'193.41.122.0-193.41.123.255'
'193.41.126.0-193.41.127.255'
'193.41.216.0-193.41.217.255'
'193.41.244.0-193.41.251.255'
'193.43.78.0-193.43.78.255'
'193.47.72.0-193.47.72.255'
'193.47.75.0-193.47.75.255'
'193.47.101.0-193.47.101.255'
'193.47.144.0-193.47.144.255'
'193.47.162.0-193.47.162.255'
'193.47.249.0-193.47.249.255'
'193.58.243.0-193.58.243.255'
'193.84.64.0-193.84.64.255'
'193.84.69.0-193.84.69.255'
'193.84.115.0-193.84.115.255'
'193.84.185.0-193.84.185.255'
'193.93.40.0-193.93.43.255'
'193.93.140.0-193.93.143.255'
'193.108.234.0-193.108.235.255'
'193.111.68.0-193.111.69.255'
'193.111.120.0-193.111.121.255'
'193.111.161.0-193.111.161.255'
'193.111.229.0-193.111.229.255'
'193.111.232.0-193.111.232.255'
'193.138.85.0-193.138.85.255'
'193.138.97.0-193.138.99.255'
'193.138.103.0-193.138.103.255'
'193.138.168.0-193.138.171.255'
'193.138.192.0-193.138.199.255'
'193.148.0.0-193.148.0.255'
'193.151.28.0-193.151.31.255'
'193.178.141.0-193.178.141.255'
'193.178.165.0-193.178.165.255'
'193.178.224.0-193.178.225.255'
'193.189.70.0-193.189.71.255'
'193.192.42.0-193.192.47.255'
'193.192.52.0-193.192.53.255'
'193.194.0.0-193.194.0.255'
'193.194.21.0-193.194.21.255'
'193.194.130.0-193.194.131.255'
'193.201.20.0-193.201.21.255'
'193.201.44.0-193.201.44.255'
'193.201.154.128-193.201.154.255'
'193.201.161.0-193.201.161.255'
'193.201.232.0-193.201.235.255'
'193.202.22.0-193.202.22.255'
'193.203.204.0-193.203.205.255'
'193.203.214.0-193.203.215.255'
'193.222.63.0-193.222.63.255'
'193.223.101.0-193.223.101.255'
'193.226.0.0-193.226.191.255'
'193.227.226.0-193.227.227.255'
'193.227.236.0-193.227.237.255'
'193.227.242.0-193.227.243.255'
'193.230.0.0-193.231.255.255'
'193.238.0.0-193.238.3.255'
'193.238.56.0-193.238.59.255'
'193.238.244.0-193.238.247.255'
'193.239.64.0-193.239.67.255'
'193.239.130.0-193.239.131.255'
'193.239.134.0-193.239.135.255'
'193.239.138.0-193.239.141.255'
'193.239.144.0-193.239.147.255'
'193.239.158.0-193.239.159.255'
'193.239.166.0-193.239.167.255'
'193.239.172.0-193.239.173.255'
'193.239.190.0-193.239.191.255'
'193.239.194.0-193.239.195.255'
'193.239.212.0-193.239.213.255'
'193.239.218.0-193.239.219.255'
'193.239.230.0-193.239.233.255'
'193.239.236.0-193.239.237.255'
'193.239.246.0-193.239.247.255'
'193.239.252.0-193.239.253.255'
'193.242.120.0-193.242.120.255'
'193.254.32.0-193.254.63.255'
'193.254.230.0-193.254.231.255'
'193.254.242.0-193.254.243.255'
'194.6.200.0-194.6.203.255'
'194.6.212.0-194.6.215.255'
'194.6.230.0-194.6.230.255'
'194.9.90.0-194.9.93.255'
'194.9.167.0-194.9.167.255'
'194.24.234.0-194.24.235.255'
'194.30.161.0-194.30.161.255'
'194.30.177.0-194.30.177.255'
'194.42.100.0-194.42.105.255'
'194.42.126.0-194.42.127.255'
'194.50.7.0-194.50.8.255'
'194.50.11.0-194.50.11.255'
'194.50.44.0-194.50.44.255'
'194.50.50.0-194.50.50.255'
'194.50.63.0-194.50.63.255'
'194.50.72.0-194.50.72.255'
'194.50.126.0-194.50.126.255'
'194.50.170.0-194.50.170.255'
'194.50.174.0-194.50.174.255'
'194.54.128.0-194.54.131.255'
'194.55.169.0-194.55.169.255'
'194.63.152.0-194.63.155.255'
'194.79.44.0-194.79.47.255'
'194.88.6.0-194.88.6.255'
'194.88.134.0-194.88.135.255'
'194.88.146.0-194.88.149.255'
'194.88.194.0-194.88.195.255'
'194.88.202.0-194.88.203.255'
'194.102.32.0-194.102.255.255'
'194.105.0.0-194.105.31.255'
'194.105.104.0-194.105.111.255'
'194.105.140.0-194.105.143.255'
'194.106.204.0-194.106.205.255'
'194.106.212.0-194.106.213.255'
'194.113.165.0-194.113.165.255'
'194.116.136.0-194.116.137.255'
'194.116.140.0-194.116.141.255'
'194.116.168.0-194.116.169.255'
'194.116.190.0-194.116.191.255'
'194.116.200.0-194.116.201.255'
'194.116.216.0-194.116.217.255'
'194.116.236.0-194.116.237.255'
'194.116.246.0-194.116.247.255'
'194.117.230.0-194.117.231.255'
'194.117.234.0-194.117.239.255'
'194.117.242.0-194.117.243.255'
'194.126.152.0-194.126.153.255'
'194.126.160.0-194.126.163.255'
'194.126.176.0-194.126.179.255'
'194.126.184.0-194.126.187.255'
'194.126.202.0-194.126.202.255'
'194.126.205.0-194.126.205.255'
'194.126.220.0-194.126.220.255'
'194.126.227.0-194.126.227.255'
'194.126.244.0-194.126.244.255'
'194.126.253.0-194.126.253.255'
'194.143.130.0-194.143.131.255'
'194.145.120.0-194.145.120.255'
'194.145.155.0-194.145.155.255'
'194.145.159.0-194.145.159.255'
'194.145.202.0-194.145.203.255'
'194.145.238.0-194.145.238.255'
'194.146.125.0-194.146.125.255'
'194.150.170.0-194.150.171.255'
'194.150.186.0-194.150.187.255'
'194.150.194.0-194.150.195.255'
'194.150.216.0-194.150.217.255'
'194.150.242.0-194.150.243.255'
'194.150.254.0-194.150.255.255'
'194.153.224.0-194.153.255.255'
'194.176.160.0-194.176.191.255'
'194.187.20.0-194.187.23.255'
'194.187.120.0-194.187.123.255'
'194.187.136.0-194.187.139.255'
'194.187.188.0-194.187.191.255'
'194.213.16.0-194.213.16.255'
'194.246.103.0-194.246.103.255'
'195.5.96.0-195.5.97.255'
'195.5.114.0-195.5.115.255'
'195.5.126.0-195.5.127.255'
'195.7.0.0-195.7.15.255'
'195.8.105.0-195.8.105.255'
'195.8.119.0-195.8.120.255'
'195.10.219.0-195.10.219.255'
'195.12.52.0-195.12.55.255'
'195.13.48.0-195.13.49.255'
'195.14.6.0-195.14.7.255'
'195.14.13.0-195.14.13.255'
'195.16.64.0-195.16.67.255'
'195.20.106.0-195.20.107.255'
'195.28.162.0-195.28.163.255'
'195.28.176.0-195.28.177.255'
'195.28.184.0-195.28.185.255'
'195.28.188.0-195.28.189.255'
'195.35.118.0-195.35.118.255'
'195.47.194.0-195.47.194.255'
'195.47.214.0-195.47.214.255'
'195.47.242.0-195.47.242.255'
'195.60.72.0-195.60.79.255'
'195.60.178.0-195.60.181.255'
'195.66.142.0-195.66.147.255'
'195.78.42.0-195.78.43.255'
'195.85.194.0-195.85.194.255'
'195.85.201.0-195.85.201.255'
'195.85.211.0-195.85.211.255'
'195.85.239.0-195.85.239.255'
'195.90.110.0-195.90.111.255'
'195.90.114.0-195.90.115.255'
'195.90.124.0-195.90.125.255'
'195.95.128.0-195.95.128.255'
'195.95.228.0-195.95.229.255'
'195.95.254.0-195.95.255.255'
'195.114.116.0-195.114.117.255'
'195.114.124.0-195.114.125.255'
'195.128.168.0-195.128.169.255'
'195.128.188.0-195.128.189.255'
'195.137.166.0-195.137.166.255'
'195.137.186.0-195.137.186.255'
'195.137.190.0-195.137.190.255'
'195.137.204.0-195.137.205.255'
'195.144.27.0-195.144.27.255'
'195.149.67.0-195.149.67.255'
'195.149.72.0-195.149.73.255'
'195.149.119.0-195.149.119.255'
'195.160.160.0-195.160.165.255'
'195.160.204.0-195.160.207.255'
'195.170.161.0-195.170.161.255'
'195.170.171.0-195.170.172.255'
'195.170.190.0-195.170.190.255'
'195.177.224.0-195.177.225.255'
'195.178.102.0-195.178.103.255'
'195.178.110.0-195.178.111.255'
'195.178.120.0-195.178.121.255'
'195.178.124.0-195.178.127.255'
'195.182.26.0-195.182.27.255'
'195.182.198.0-195.182.199.255'
'195.182.208.0-195.182.209.255'
'195.182.212.0-195.182.215.255'
'195.182.220.0-195.182.221.255'
'195.189.138.0-195.189.139.255'
'195.189.144.0-195.189.145.255'
'195.189.150.0-195.189.155.255'
'195.189.164.0-195.189.165.255'
'195.189.174.0-195.189.177.255'
'195.189.184.0-195.189.187.255'
'195.189.190.0-195.189.191.255'
'195.189.194.0-195.189.195.255'
'195.190.159.0-195.190.159.255'
'195.210.40.0-195.210.41.255'
'195.210.44.0-195.210.45.255'
'195.225.40.0-195.225.43.255'
'195.225.54.0-195.225.55.255'
'195.225.64.0-195.225.67.255'
'195.225.84.0-195.225.87.255'
'195.225.108.0-195.225.111.255'
'195.225.140.0-195.225.143.255'
'195.234.54.0-195.234.55.255'
'195.234.58.0-195.234.58.255'
'195.234.130.0-195.234.130.255'
'195.234.161.0-195.234.161.255'
'195.234.169.0-195.234.169.255'
'195.234.172.0-195.234.172.255'
'195.234.177.0-195.234.177.255'
'195.234.181.0-195.234.182.255'
'195.234.188.0-195.234.188.255'
'195.234.191.0-195.234.191.255'
'195.238.80.0-195.238.83.255'
'195.238.88.0-195.238.91.255'
'195.238.94.0-195.238.95.255'
'195.242.76.0-195.242.79.255'
'195.242.88.0-195.242.89.255'
'195.242.244.0-195.242.247.255'
'195.244.14.0-195.244.15.255'
'195.244.18.0-195.244.19.255'
'195.245.82.0-195.245.83.255'
'195.245.88.0-195.245.89.255'
'195.245.214.0-195.245.214.255'
'195.245.220.0-195.245.220.255'
'195.245.239.0-195.245.239.255'
'195.245.251.0-195.245.251.255'
'195.246.242.0-195.246.243.255'
'195.246.246.0-195.246.247.255'
'195.246.250.0-195.246.251.255'
'195.250.53.0-195.250.53.255'
'195.250.59.0-195.250.59.255'
'195.254.132.0-195.254.141.255'
'195.254.152.0-195.254.153.255'
'212.35.128.0-212.35.159.255'
'212.54.96.0-212.54.127.255'
'212.93.128.0-212.93.159.255'
'212.146.64.0-212.146.127.255'
'213.154.96.0-213.154.159.255'
'213.157.160.0-213.157.191.255'
'213.164.224.0-213.164.255.255'
'213.233.64.0-213.233.127.255'
'217.10.192.0-217.10.223.255'
'217.13.96.0-217.13.111.255'
'217.19.0.0-217.19.15.255'
'217.73.160.0-217.73.175.255'
'217.115.208.0-217.115.223.255'
'217.156.0.0-217.156.127.255'
)!

ipRangeListForSerbia
	"IP address list found on: http://proxysecurity.com/ip-address-range.php?country=SLOVENIA

	see also http://www.ripe.net/perl/whois?form_type=simple&full_query_string=&searchtext=193.189.182.1&do_search=Search
	for checking IP addresses which are not included in proxysecurity list (not every address is covered there).
	"
	^#(
'62.108.96.0-62.108.127.255'
'62.193.128.0-62.193.159.255'
'77.46.128.0-77.46.255.255'
'77.105.0.0-77.105.63.255'
'77.247.200.0-77.247.201.255'
'78.30.128.0-78.30.191.255'
'79.101.0.0-79.101.255.255'
'79.175.64.0-79.175.127.255'
'80.70.240.0-80.70.255.255' 
'80.74.160.0-80.74.175.255'
'80.80.160.0-80.80.175.255'
'80.93.224.0-80.93.255.255'
'80.240.144.0-80.240.159.255'
'81.18.48.0-81.18.63.255'
'82.114.64.0-82.114.95.255'
'82.117.192.0-82.117.223.255'
'82.208.192.0-82.208.255.255'
'83.136.176.0-83.136.183.255'
'84.22.32.0-84.22.63.255'
'85.94.96.0-85.94.127.255'
'85.222.128.0-85.222.255.255'
'87.116.128.0-87.116.191.255'
'87.237.200.0-87.237.207.255'
'87.238.208.0-87.238.215.255'
'87.250.32.0-87.250.63.255'
'88.150.128.0-88.150.255.255'
'89.110.192.0-89.110.255.255'
'89.188.32.0-89.188.63.255'
'89.216.0.0-89.216.255.255'
'89.216.16.0-89.216.25.255'
'89.216.128.0-89.216.191.255'
'91.102.228.0-91.102.231.255'
'91.143.208.0-91.143.223.255'
'91.148.64.0-91.148.127.255'
'91.150.64.0-91.150.68.255'
'91.150.70.0-91.150.127.255'
'91.185.96.0-91.185.127.255'
'93.86.0.0-93.86.127.255'
'94.189.128.0-94.189.191.255'
'147.91.0.0-147.91.255.255'
'194.54.180.0-194.54.183.255'
'194.79.40.0-194.79.43.255'
'194.106.160.0-194.106.191.255'
'194.145.153.0-194.145.153.255'
'194.247.192.0-194.247.223.255'
'195.46.52.0-195.46.55.255'
'195.66.160.0-195.66.191.255'
'195.140.164.0-195.140.167.255'
'195.178.32.0-195.178.63.255'
'195.250.96.0-195.250.127.255'
'195.252.64.0-195.252.127.255'
'212.62.32.0-212.62.63.255'
'212.69.0.0-212.69.31.255'
'212.102.128.0-212.102.159.255'
'212.124.160.0-212.124.191.255'
'212.200.0.0-212.200.255.255'
'213.137.96.0-213.137.127.255'
'213.149.96.0-213.149.127.255'
'213.163.96.0-213.163.127.255'
'213.184.96.0-213.184.127.255'
'213.198.192.0-213.198.255.255'
'213.240.0.0-213.240.63.255'
'213.244.192.0-213.244.255.255'
'217.24.16.0-217.24.31.255'
'217.26.64.0-217.26.79.255'
'217.65.192.0-217.65.207.255'
'217.119.240.0-217.119.255.255'
'217.169.208.0-217.169.223.255'
'217.170.240.0-217.170.255.255'
'212.200.67.0-212.200.67.255'
)!

ipRangeListForSlovenia
	"IP address list found on: http://proxysecurity.com/ip-address-range.php?country=SLOVENIA

	see also http://www.ripe.net/perl/whois?form_type=simple&full_query_string=&searchtext=193.189.182.1&do_search=Search
	for checking IP addresses which are not included in proxysecurity list (not every address is covered there).
	"

	^#(
'78.153.32.0-78.153.63.255'
'80.95.224.0-80.95.239.255'
'80.246.224.0-80.246.239.255'
'81.17.224.0-81.17.239.255'
'81.24.96.0-81.24.111.255'
'81.90.176.0-81.90.191.255'
'82.149.0.0-82.149.31.255'
'82.192.32.0-82.192.63.255'
'82.214.64.0-82.214.127.255'
'84.20.224.0-84.20.255.255'
'84.41.0.0-84.41.127.255'
'84.52.128.0-84.52.191.255'
'84.255.192.0-84.255.255.255'
'85.10.0.0-85.10.63.255'
'86.58.0.0-86.58.127.255'
'86.61.0.0-86.61.127.255'
'87.119.128.0-87.119.159.255'
'88.200.0.0-88.200.127.255'
'89.107.32.0-89.107.39.255'
'89.142.0.0-89.143.255.255'
'89.212.0.0-89.212.255.255'
'90.157.128.0-90.157.247.255'
'92.37.56.0-92.37.71.25'
'92.63.16.0-92.63.31.25'
'93.103.0.0-93.103.255.25'
'153.5.0.0-153.5.255.255'
'164.8.*.*'
'192.160.15.*'
'193.0.244.0-193.0.244.255'
'193.2.0.0-193.2.255.255'
'193.16.109.0-193.16.109.255'
'193.17.227.0-193.17.227.255'
'193.19.220.0-193.19.223.255'
'193.22.31.0-193.22.31.255'
'193.22.81.0-193.22.81.255'
'193.23.49.0-193.23.49.255'
'193.23.62.0-193.23.62.255'
'193.24.248.0-193.24.251.255'
'193.26.26.0-193.26.26.255'
'193.28.146.0-193.28.146.255'
'193.30.43.0-193.30.43.255'
'193.41.35.0-193.41.36.255'
'193.41.89.0-193.41.89.255'
'193.47.136.0-193.47.136.255'
'193.77.0.0-193.77.255.255'
'193.95.192.0-193.95.255.255'
'193.109.124.0-193.109.124.255'
'193.109.227.0-193.109.227.255'
'193.110.14.0-193.110.15.255'
'193.110.145.0-193.110.145.255'
'193.111.192.0-193.111.193.255'
'193.111.220.0-193.111.223.255'
'193.138.1.0-193.138.5.255'
'193.138.9.0-193.138.9.255'
'193.138.32.0-193.138.63.255'
'193.178.188.0-193.178.188.255'
'193.189.160.0-193.189.191.255'
'193.201.45.0-193.201.45.255'
'193.201.101.0-193.201.101.255'
'193.201.109.0-193.201.109.255'
'193.201.155.0-193.201.155.127'
'193.201.165.0-193.201.165.255'
'193.201.212.0-193.201.215.255'
'193.221.112.0-193.221.112.255'
'193.221.115.0-193.221.115.255'
'193.243.140.0-193.243.141.255'
'194.6.237.0-194.6.237.255'
'194.6.242.0-194.6.242.255'
'194.39.85.0-194.39.85.255'
'194.50.166.0-194.50.166.255'
'194.116.204.0-194.116.205.255'
'194.126.197.0-194.126.197.255'
'194.146.109.0-194.146.109.255'
'194.152.0.0-194.152.31.255'
'194.153.155.128-194.153.155.255'
'194.165.96.0-194.165.127.255'
'194.213.3.0-194.213.3.255'
'194.213.26.0-194.213.26.255'
'194.242.36.0-194.242.36.255'
'194.249.0.0-194.249.255.255'
'195.35.122.0-195.35.122.255'
'195.47.197.0-195.47.197.255'
'195.47.211.0-195.47.211.255'
'195.47.213.0-195.47.213.255'
'195.47.224.0-195.47.224.255'
'195.47.226.0-195.47.226.255'
'195.69.96.0-195.69.99.255'
'195.80.225.0-195.80.225.255'
'195.85.192.0-195.85.192.255'
'195.149.94.0-195.149.94.255'
'195.170.177.0-195.170.177.255'
'195.178.118.0-195.178.119.255'
'195.190.129.0-195.190.129.255'
'195.190.136.0-195.190.136.255'
'195.190.158.0-195.190.158.255'
'195.210.192.0-195.210.255.255'
'195.234.137.0-195.234.137.255'
'195.245.106.0-195.245.107.255'
'195.245.208.0-195.245.208.255'
'195.245.216.0-195.245.216.255'
'195.245.250.0-195.245.250.255'
'195.246.0.0-195.246.31.255'
'195.250.58.0-195.250.58.255'
'195.250.192.0-195.250.223.255'
'212.13.224.0-212.13.255.255'
'212.18.32.0-212.18.63.255'
'212.30.64.0-212.30.95.255'
'212.72.96.0-212.72.127.255'
'212.93.224.0-212.93.255.255'
'212.103.128.0-212.103.159.255'
'212.118.64.0-212.118.95.255'
'212.235.128.0-212.235.255.255'
'213.143.64.0-213.143.95.255'
'213.157.224.0-213.157.255.255'
'213.161.0.0-213.161.31.255'
'213.172.224.0-213.172.255.255'
'213.229.192.0-213.229.255.255'
'213.250.0.0-213.250.63.255'
'213.253.64.0-213.253.127.255'
'217.72.64.0-217.72.95.255'
)!

isCroatianIP: clientIP 
	self ipRangeListForCroatia 
		do: [:each | (self checkIpMatchFor: each with: clientIP) ifTrue: [^true]].
	^false!

isKnownIP: clientIP 
	"Answer <true> if the IP is from a country where we operate."

	^(self isSlovenianIP: clientIP) 
		or: [(self isCroatianIP: clientIP) or: [self isSerbianIP: clientIP]]!

isRunning
	"Answer <true> if the application was properly initialized and is supposed to be running."

	^sessions notNil and: [scavenger notNil]!

isSafeToShutdown
	^true!

isSerbianIP: clientIP 
	self ipRangeListForSerbia do: [:each | (self checkIpMatchFor: each with: clientIP) ifTrue: [^true]].
	^false!

isSlovenianIP: clientIP 
	self ipRangeListForSlovenia 
		do: [:each | (self checkIpMatchFor: each with: clientIP) ifTrue: [^true]].
	^false!

liveUpdatesFilePathname
	"Answer full pathname of the file which will be used (or was used) to store live updates for the current server image."

	^ItcSystemManager startUpDirectoryPath , ItcSystemManager imageFilename asFilenameString 
		, '_LiveUpdate_' , self currentReleaseId asFilenameString!

liveUpdatesLoadAndCompileAll
	"Private - check if the live updates file exists. If it exists, then load the file and compile live updates."

	| fn fs bytes dict |
	fn := self liveUpdatesFilePathname.
	(ItcSystemManager fileExists: fn) 
		ifFalse: 
			[ItcSystemManager logLineWithTS: 'Live updates NOT loaded. File ' , fn , ' not found'.
			^self].
	ItcSystemManager logLineWithTS: 'Loading live updates from file ' , fn.
	fs := FileStream read: self liveUpdatesFilePathname text: false.
	fs isFileStream 
		ifFalse: [self error: 'Live updates file ' , self liveUpdatesFilePathname , ' can not be opened'].
	[bytes := fs contents] ensure: [fs close].
	ItcSystemManager logLineWithTS: 'Applying live updates...'.
	dict := ODBDeserializer deserializeFromBytes: bytes.
	dict class == IdentityDictionary ifFalse: [self error: 'Invalid live updates dictionary class'].
	dict keysAndValuesDo: 
			[:eachClass :eachMethodsDict | 
			ItcSystemManager logLineWithTS: 'Compiling live updates for ' , eachClass printString.
			eachMethodsDict keysAndValuesDo: 
					[:eachSelector :eachMethodSource | 
					ItcSystemManager
						logLineWithTS: 'Method ' , eachSelector printString;
						compileRuntimePatchForClass: eachClass
							methodSource: (eachMethodSource at: 1)
							user: (eachMethodSource at: 2)
							timestamp: (eachMethodSource at: 3)]].
	ItcSystemManager logLineWithTS: 'Live updates loaded and compiled OK'!

liveUpdatesStoreAll
	"Private - in run-time environment upon every change, store ALL live updates into a file so that they can be loaded in case the server is restarted"

	| fs |
	fs := FileStream write: self liveUpdatesFilePathname text: false.
	[fs nextPutAll: (ODBSerializer serializeToBytes: ItcSystemManager getLiveUpdatePatchDict)] 
		ensure: [fs close]!

loadAllowedAndBlockedIPlist
	(self servletManager)
		setAllowedIPString: (self configurationSettingsAt: 'Application.allowIP');
		setBlockedIPString: (self configurationSettingsAt: 'Application.blockIP')!

loadConfigurationSettings
	| configPath file line category item coll |
	category := ''.
	configPath := self configurationFileName.
	configurationSettings := LookupTable new.
	configurationSettings at: #configurationFileName put: configPath.
	configPath := ItcSystemManager startUpDirectoryPath , configPath.
	configurationSettingsMutex := Semaphore forMutualExclusion.
	[file := FileStream read: configPath] on: Error do: [:ex | ex exitWith: nil].
	file isFileStream 
		ifFalse: 
			[^ItcSystemManager message: 'Warning: Configuration file ' , configPath , ' could not be opened'].
	
	[[file atEnd] whileFalse: 
			[(line := file nextLine) notEmpty 
				ifTrue: 
					[line first = $[ 
						ifTrue: [category := (line copyFrom: 2 to: (line indexOf: $]) - 1) , '.']
						ifFalse: 
							[(line first ~= $; and: [(line indexOf: $=) > 0]) 
								ifTrue: 
									[item := line copyFrom: 1 to: (line indexOf: $=) - 1.
									configurationSettings at: (category , item) asUppercase
										put: (line copyFrom: item size + 2 to: line size)]]]]] 
			ensure: [file close].
	coll := (line := self configurationSettingsAt: 'application.languages' ifAbsent: []) isNilOrEmpty 
				ifFalse: [line itcSubStrings: $;].
	configurationSettings at: #applicationLanguages
		put: (coll isNilOrEmpty ifFalse: [coll] ifTrue: [self defaultApplicationLanguages])!

loadMessages
	| messagesPath str coll |
	messagesPath := self applicationRootDirectory , 'nls' , ItcSystemManager pathSeparatorString.
	self applicationLanguages do: 
			[:each | 
			WebTranslationService 
				loadMessagesFrom: messagesPath , each
				as: each
				resetBefore: false].
	coll := self applicationLanguages.
	coll isNilOrEmpty 
		ifFalse: 
			[(coll includes: self defaultLanguage) 
				ifFalse: 
					[str := 'Default language ' , self defaultLanguage asWebString 
								, ' is not available in the list of application languages.

Please change [application]defaultLanguage or include default language in [application]applicationLanguages in configuration settings file.'.
					ItcSystemManager isRuntime 
						ifTrue: [ItcSystemManager logLine: 'Warning: ' , str]
						ifFalse: [self error: str]]]!

loadServlets
	(self servletManager)
		addFileServlet: WebHttpFileServlet new for: self;
		addServlet: WebMainPageServlet new for: self;
		addServlet: WebTaskRoutingServlet new for: self;
		addServlet: WebLoginServlet new for: self.
	scriptServlet := self servletManager addFileScriptServlet: WebHttpScriptFileServlet new for: self.
	cssServlet := self servletManager addFileScriptServlet: WebHttpCssFileServlet new for: self!

loginMessageInvalidUsernameOrPassword
	self defaultLanguage = 'Slovene' ifTrue: [^'Vnešeno uporabniško ime ali geslo ni veljavno.'].
	self defaultLanguage = 'Serbian' ifTrue: [^'Pogrešno korisnièko ime ili lozinka.'].
	self defaultLanguage = 'Croatian' ifTrue: [^'Uneseno korisnièko ime ili zaporka nisu valjani.'].
	^'Invalid username or password.'!

loginMessageLoginNotPossibleDueToServerMaintenance
	self defaultLanguage = 'Slovene' 
		ifTrue: [^'Prijava trenutno ni mogoèa zaradi vzdrževalnih del na strežniku.'].
	self defaultLanguage = 'Serbian' ifTrue: [^'Prijava trenutno nije moguæa zbog održavanja servera.'].
	self defaultLanguage = 'Croatian' 
		ifTrue: [^'Prijava trenutno nije moguæa zbog radova na održavanju servera.'].
	^'Login is currently not possible due to server maintenance.'!

loginMessageUsernameMandatory
	self defaultLanguage = 'Slovene' ifTrue: [^'Prosimo vnesite uporabniško ime in geslo.'].
	self defaultLanguage = 'Serbian' ifTrue: [^'Molimo unesite korisnièko ime i lozinku.'].
	self defaultLanguage = 'Croatian' ifTrue: [^'Molimo unesite korisnièko ime i zaporku.'].
	^'Please enter you username and password.'!

maxInactivityTime
	"Answer number of seconds after which a session will be removed 
	if there is no user activity i.e. no request comes in during this time period.
	Default is 45 minutes."

	^expirationTime * 60!

newCoder: aStream 
	^(self basicNewCoder: aStream) urlPrefix: 'index.html'!

newEmail
	^(EMailMessage new)
		sender: self defaultSenderEmail;
		yourself!

newReadOnlyTransaction
	^db newReadOnlyTransaction!

newSession
	| session |
	session := (WebSession forLanguage: self defaultLanguage)
				setApplication: self
					clientIP: '127.0.0.1'
					sessionId: self getNewSessionId;
				userAgent: 'created by server';
				yourself.
	sessionsSemaphore critical: [sessions at: session sessionId put: session].
	^session!

newSessionFor: request sessionCookie: sessionCookie clientCookie: clientCookie 
	^self 
		newSessionFor: request
		sessionCookie: sessionCookie
		clientCookie: clientCookie
		onlyOneSessionPerClientCookie: false!

newSessionFor: request sessionCookie: sessionCookie clientCookie: clientCookie onlyOneSessionPerClientCookie: onlyOneSessionPerClientCookie 
	"Create new session with given session cookie for the given request and client cookie."

	| session clientIP |
	clientIP := request clientIP.
	session := (WebSession forLanguage: self defaultLanguage)
				setApplication: self
					clientIP: clientIP
					sessionId: self getNewSessionId;
				userAgent: request userAgent;
				cookieId: sessionCookie;
				clientCookie: clientCookie;
				yourself.
	onlyOneSessionPerClientCookie 
		ifTrue: 
			[sessionsSemaphore critical: 
					[sessions do: 
							[:each | 
							(each clientCookie = clientCookie 
								and: [each userAgent = request userAgent and: [each clientIP = clientIP and: [each user isNil]]]) 
									ifTrue: 
										["do not create another session if an active session for the given client already exists"
										^each]].
					sessions at: session sessionId put: session]]
		ifFalse: [sessionsSemaphore critical: [sessions at: session sessionId put: session]].
	^session!

newSessionFor: requestSender username: username password: password 
	"Subclass/replace this method with username/password checking."

	^self 
		newSessionFor: requestSender
		sessionCookie: nil
		clientCookie: nil!

newTransaction
	^db newTransaction!

notifyOnServerStartupCompleted
	"Private - this method will be sent upon successfull server startup."

	"first check if the server is running and if so, then send #onServerStartupCompleted"

	self isRunning ifTrue: [self onServerStartupCompleted]!

onLiveUpdatePerformed: aCollectionOfUpdates 
	"Private - This method is sent when application server is updated with live update. The live update methods are already compiled.
	The collection contains associations, key= aClass, value= method source string (only collection of newly added methods/updates)"

	ItcSystemManager isRuntime 
		ifTrue: 
			["in run-time environment upon every change, store ALL live updates into a file so that they can be loaded in case the server is restarted"
			self liveUpdatesStoreAll]!

onServerStartupCompleted
	"this method will be sent upon successfull server startup."

	"do nothing by default"

	!

purgeExpiredSessions
	"Periodicno pocisti vse session-e, ki so potekli zaradi neaktivnosti uporabnika."

	| allSessions currentTime lastRequestTime maxInactivityTime |
	maxInactivityTime := self maxInactivityTime.
	currentTime := ItcSystemManager absoluteSecondsClockValue.
	sessionsSemaphore critical: 
			["najprej selekta vse super sessione"
			allSessions := OrderedCollection new: sessions size.
			sessions do: [:each | each superSession isNil ifTrue: [allSessions add: each]].
			"ponoven prehod za primer, ce je aktiven se kak session brez aktivnega super session-a"
			sessions do: 
					[:each | 
					(each superSession isNil or: [allSessions includes: each superSession]) 
						ifFalse: [allSessions add: each]]].
	"najprej pocisti vse session-e"
	allSessions do: 
			[:eachSession | 
			(lastRequestTime := eachSession lastRequestTime) notNil 
				ifTrue: 
					[currentTime - lastRequestTime > maxInactivityTime 
						ifTrue: 
							[eachSession isPersistent 
								ifFalse: [self removeSession: eachSession removedDueToSessionExpiration: true]]]].
	"nato v preostalih session-ih pocisti vse potekle taske"
	sessionsSemaphore critical: [allSessions := sessions values].
	allSessions do: 
			[:eachSession | 
			eachSession lastRequestTime isNil 
				ifTrue: [eachSession lastRequestTime: ItcSystemManager absoluteSecondsClockValue].
			eachSession purgeExpiredTasks]!

reloadMessages
	| messagesPath |
	messagesPath := self applicationRootDirectory , 'nls' , ItcSystemManager pathSeparatorString.
	self applicationLanguages do: 
			[:each | 
			WebTranslationService 
				loadMessagesFrom: messagesPath , each
				as: each
				resetBefore: true]!

removeSession: session 
	^self removeSession: session removedDueToSessionExpiration: false!

removeSession: aWebSession removedDueToSessionExpiration: anObject 
	"Zbrise session oz. njegov superSession in vse, ki imajo enak superSession.
	Vrne collection vseh zbrisanih session-ov."

	| superSession sessionsToRemove |
	aWebSession superSession isNil 
		ifFalse: [superSession := aWebSession superSession]
		ifTrue: [superSession := aWebSession].
	sessionsToRemove := OrderedCollection with: superSession.
	sessionsSemaphore critical: 
			[sessions 
				do: [:eachSession | eachSession superSession == superSession ifTrue: [sessionsToRemove add: eachSession]]].
	sessionsToRemove do: [:eachSession | eachSession onSessionRemoved].
	sessionsSemaphore critical: 
			[sessionsToRemove do: [:eachSession | sessions removeKey: eachSession sessionId ifAbsent: []]].
	^sessionsToRemove!

restartScavengerProcess
	scavenger isNil ifFalse: [[scavenger itcSafeTerminate] on: Error do: [:ex | ]].
	self startExpiredSessionsScavengerProcess!

scriptRootPath
	^'scripts'!

scriptServlet
	^scriptServlet!

sendEmail: emailMessage 
	"Send emailMessage using SMTP host address read from the config file."

	"Change this method so that it will try to send e-mail more than once
	if the SMTP server is temporarily not working."

	eMailQueueMutex critical: [eMailQueue add: (Association key: 0 value: emailMessage)].
	(Processor allProcesses 
		select: [:each | each itcProcessName = 'Emptying e-mail send queue...' and: [each itcIsTerminated not]]) 
			size > 2 
		ifFalse: 
			["if there are no more than two e-mail processors emptying the queue, then start another emptying process"
			ItcSystemManager 
				forkNewProcessOn: [self emptyEmailQueue]
				named: 'Emptying e-mail send queue...'
				priority: ItcSystemManager batchJobPriority]!

sendFirstPageFor: session request: aWebRequest on: stream 
	"This method is sent the first time after the user has logged in."

	self subclassResponsibility!

sendLoginPageFor: request withMessage: messageString on: aStream 
	"This method is sent to application when the user logs in to the first time by typing in URL: applicationUrlPrefix/login.html.
	All this method does is it writes the login page to aStream. The username and password fields should be named username
	and password.
	Subclass/replace this method with a login page specific for your application."

	^self sendLoginPageWithMessage: messageString on: aStream!

sendLoginPageWithMessage: messageString on: aStream 
	"This method is sent to application when the user logs in to the first time by typing in URL: applicationUrlPrefix/login.html.
	All this method does is it writes the login page to aStream. The username and password fields should be named username
	and password.
	Subclass/replace this method with a login page specific for your application."

	self subclassResponsibility!

sendPageExpiredMessageFor: aWebSession on: aStream 
	self subclassResponsibility!

sendSessionExpiredResponseOn: stream 
	| indexServlet indexServletUrl |
	indexServlet := (self servletManager getServletsFor: self) 
				detect: [:each | each servletName = 'index.html']
				ifNone: [self indexServlet].
	indexServlet isNil 
		ifTrue: [indexServletUrl := '/']
		ifFalse: 
			[indexServletUrl := '/' , self urlPrefix , '/' , indexServlet servletName , '?action=sessionExpired'].
	self webRequest action isAjaxAction 
		ifTrue: [stream putAjaxResults: 'top.location=' , indexServletUrl asJavascriptValue , ';']
		ifFalse: 
			[stream 
				nextPutAll: '<!!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html><body onload="top.location=''' 
						, indexServletUrl , ''';">
' 
						, self sessionExpiredMessage , '
</body></html>']!

serverClusterManager
	^nil!

serverMessage
	^serverMessage!

serverMessage: aString 
	self serverMessage: aString distributed: false!

serverMessage: aString distributed: aBoolean 
	serverMessage := aString.
	serverClusterManager isNil 
		ifFalse: [aBoolean == true ifTrue: [serverClusterManager queueEvent: #setServerMessage for: aString]]!

servletInstanceOfClass: aServletClass 
	"Answer first instance of the given servlet class registered for this application."

	^(self servletManager getServletsFor: self) detect: [:each | each class == aServletClass] ifNone: []!

servletManager
	^self webServer servletManager!

servletUrlOfClass: aServletClass 
	"Answer local URL of this application's servlet instance of the given servlet class."

	| servlet |
	^(servlet := self servletInstanceOfClass: aServletClass) isNil ifFalse: [servlet urlPrefix]!

sessionAt: sessionIdString 
	| sessionId index session |
	(index := sessionIdString indexOf: $-) = 0 
		ifTrue: [sessionId := sessionIdString]
		ifFalse: [sessionId := sessionIdString copyFrom: 1 to: index - 1].
	sessionsSemaphore critical: [session := sessions at: sessionId ifAbsent: []].
	^session!

sessionAtCookie: cookie 
	| session |
	sessionsSemaphore critical: 
			[session := sessions detect: [:eachSession | eachSession cookieId = cookie] ifNone: []].
	^session!

sessionExpiredMessage
	self defaultLanguage = 'Slovene' 
		ifTrue: 
			[^'Zaradi daljše neaktivnosti uporabnika ali odjave iz sistema vas prosimo, da se ponovno prijavite v sistem.'].
	self defaultLanguage = 'Serbian' 
		ifTrue: [^'Zbog duže neaktivnosti odjavljeni ste iz programa. Molimo prijavite se ponovo.'].
	self defaultLanguage = 'Croatian' 
		ifTrue: 
			[^'Zbog duže neaktivnosti korisnika ili odjave iz sistema, molimo vas da se ponovno prijavite u sistem.'].
	^'Your user session has expired or you have already logged out. Please login again.'!

setLocalizedLanguageFor: session request: request 
	| requestLanguage |
	requestLanguage := self getUserLanguageBasedOnIPandRequestFor: request.
	session 
		language: ((requestLanguage notNil and: [self applicationLanguages includes: requestLanguage]) 
				ifTrue: [requestLanguage]
				ifFalse: [self defaultLanguage])!

shutdown
	[self activeSessions do: [:eachSession | self removeSession: eachSession]] on: Error
		do: [:ex | ex exitWith: nil].
	db notNil 
		ifTrue: 
			[db close.
			db := nil].
	scavenger notNil 
		ifTrue: 
			[scavenger itcSafeTerminate.
			scavenger := nil].
	WebHttpServer currentOrNil isNil ifFalse: [self servletManager removeServletsFor: self].
	serverClusterManager isNil 
		ifFalse: 
			[serverClusterManager shutdown.
			serverClusterManager := nil].
	configurationSettingsMutex := nil.
	eMailSendingMutex := nil.
	eMailQueue := nil.
	httpLoadBalancer := nil.
	lastSessionId := nil.
	sessions := nil.
	expirationTime := nil.
	oidProvider := nil!

smtpConnector
	^EmailSMTPConnector forSMTPHost: (self configurationSettingsAt: 'MailServer.SMTPServer')!

startExpiredSessionsScavengerProcess
	scavenger := ItcSystemManager newProcessOn: 
					[[true] whileTrue: 
							[10 timesRepeat: 
									["check expired sessions every minute"
									(Delay forSeconds: 60) wait.
									self purgeExpiredSessions].
							self sysAdminHasFreeDiskSpaceCheck 
								ifTrue: 
									["check free disk space every 10 minutes"
									[self sysAdminCheckFreeDiskSpace] on: Error do: [:ex | ]]]]
				named: 'Web server expired sessions clean-up daemon'.
	scavenger
		priority: ItcSystemManager cronJobDaemonPriority;
		resume!

startup
	self subclassResponsibility!

sysAdminCheckFreeDiskSpace
	"Check free disk space here and send e-mail with warning to administrator.

	Answer <true> if system administrator has been notified, else <false>"

	| freeSpace lastEmailTS timeNow |
	freeSpace := ItcSystemManager getFreeDiskSpace / 1024 / 1024 / 1024.
	freeSpace < 2 
		ifTrue: 
			["Warn in case there is less than 2 GB of free disk space and more than two hours since the last e-mail was sent."
			timeNow := ItcSystemManager absoluteSecondsClockValue.
			lastEmailTS := self configurationSettingsAt: 'sysadmin.lastEmailTS' ifAbsent: [].
			(lastEmailTS isNil or: [timeNow - lastEmailTS > 7200]) 
				ifTrue: 
					[self configurationSettingsAt: 'sysadmin.lastEmailTS' put: timeNow.
					ItcSystemManager 
						logLineWithTS: 'LOW DISK SPACE WARNING SENT TO E-MAIL: ' , self sysAdminEmailAddresses asWebString.
					self sendEmail: ((self newEmail)
								subject: 'LOW DISK SPACE WARNING';
								setMessage: 'Computer name: ' , ItcSystemManager getComputerName printString 
											, '

Free disk space: ' , freeSpace asDecimalOrFloat asWebString 
											, ' GB
Server time: ' , Timestamp now asFilenameString;
								addToRecipient: self sysAdminEmailAddresses;
								yourself).
					^true]].
	^false!

sysAdminEmailAddresses
	"Answer e-mail address(es) of the system administrator."

	^'info@e-racuni.com'!

sysAdminHasFreeDiskSpaceCheck
	"Answer <true> if free disk space checking is performed."

	^false!

taskAt: taskIdString 
	"Answer task for the taskIdString. The taskIdString is composed like this:

		SSSSSSSS-TTTTTTT-RRRR

	where: 
		SSSSSSSS  is session ID part of string
		TTTTTTTT      is the task ID withing this session
		RRRR           can be any random number "

	| session index |
	(index := taskIdString indexOf: $-) = 0 ifTrue: [^nil].
	sessionsSemaphore 
		critical: [session := sessions at: (taskIdString copyFrom: 1 to: index - 1) ifAbsent: []].
	^session isNil 
		ifFalse: [session taskAt: (taskIdString copyFrom: index + 1 to: taskIdString size)]!

temporaryDirectoryPath
	^self applicationRootDirectory , 'temp' , ItcSystemManager pathSeparatorString!

urlPrefix
	"Answer aString which will be part of the URL for every request that is sent for this application."

	self subclassResponsibility!

userAccountDisabledMessage
	self defaultLanguage = 'Slovene' 
		ifTrue: 
			[^'Vaš uporabniški dostop je trenutno onemogoèen. Kontaktirajte vašega sistemskega administratorja.'].
	self defaultLanguage = 'Serbian' 
		ifTrue: [^'Korisnièki pristup je trenutno onemoguæen. Kontaktirajte vašeg administratora sistema.'].
	self defaultLanguage = 'Croatian' 
		ifTrue: 
			[^'Vaš korisnièki pristup trenutno je onemoguæen. Obratite se na vašeg administratora sistema.'].
	^'Your account has been deactivated. Please contact your system administrator.'!

webFilesPath
	^self applicationRootDirectory , 'http-root'!

webServer
	^WebHttpServer current!

webSessionCookieName
	^'ItcSID' , self urlPrefix! !
!WebApplication categoriesFor: #activeSessions!public! !
!WebApplication categoriesFor: #activeSuperSessions!public! !
!WebApplication categoriesFor: #applicationLanguages!configuration!NLS support!public! !
!WebApplication categoriesFor: #applicationPath!public! !
!WebApplication categoriesFor: #applicationRootDirectory!public! !
!WebApplication categoriesFor: #basicStartup!public!shutdown / startup! !
!WebApplication categoriesFor: #checkEmail:!public!sending email! !
!WebApplication categoriesFor: #checkIpMatchFor:with:!localization IP locating!private! !
!WebApplication categoriesFor: #checkUsername:!public! !
!WebApplication categoriesFor: #compressMessages!NLS support!public! !
!WebApplication categoriesFor: #configuration!configuration!NLS support!public! !
!WebApplication categoriesFor: #configurationFileName!configuration file settings!public!shutdown / startup! !
!WebApplication categoriesFor: #configurationSettingsAt:!configuration file settings!public! !
!WebApplication categoriesFor: #configurationSettingsAt:ifAbsent:!configuration file settings!public! !
!WebApplication categoriesFor: #configurationSettingsAt:put:!configuration file settings!public! !
!WebApplication categoriesFor: #configurationSettingsBooleanAt:!configuration file settings!public! !
!WebApplication categoriesFor: #cssRootPath!layout definitions!public!web server! !
!WebApplication categoriesFor: #cssServlet!database!layout definitions!public!session management!web server! !
!WebApplication categoriesFor: #cssStyleItcDefault!database!layout definitions!public!session management!web server! !
!WebApplication categoriesFor: #cssStyleItcDefaultForMobileClient!database!layout definitions!public!session management!web server! !
!WebApplication categoriesFor: #currentReleaseId!public!shutdown / startup!web server! !
!WebApplication categoriesFor: #db!database!public! !
!WebApplication categoriesFor: #dbBackupDestination!database!public! !
!WebApplication categoriesFor: #dbBackupLocalDirectory!database!public! !
!WebApplication categoriesFor: #dbBackupUpload!configuration!database!public! !
!WebApplication categoriesFor: #dbBackupUploadPassword!configuration!database!public! !
!WebApplication categoriesFor: #dbBackupUploadUrl!configuration!database!public! !
!WebApplication categoriesFor: #dbBackupUploadUsername!configuration!database!public! !
!WebApplication categoriesFor: #dbName!configuration!database!public! !
!WebApplication categoriesFor: #dbPassword!configuration!database!public! !
!WebApplication categoriesFor: #dbUsername!configuration!database!public! !
!WebApplication categoriesFor: #defaultApplicationLanguages!NLS support!public! !
!WebApplication categoriesFor: #defaultCodePage!NLS support!public! !
!WebApplication categoriesFor: #defaultExpirationTime!configuration!public!session management!web server! !
!WebApplication categoriesFor: #defaultLanguage!configuration!NLS support!public! !
!WebApplication categoriesFor: #defaultLocalization!NLS support!public! !
!WebApplication categoriesFor: #defaultSenderEmail!configuration!public!sending email! !
!WebApplication categoriesFor: #digits!public! !
!WebApplication categoriesFor: #domainName!public!web server! !
!WebApplication categoriesFor: #emptyEmailQueue!public!sending email! !
!WebApplication categoriesFor: #fileBackupDestination!configuration!database!public! !
!WebApplication categoriesFor: #generateRandom1!private! !
!WebApplication categoriesFor: #generateRandom2!private! !
!WebApplication categoriesFor: #getLastDatabaseBackupFileName!database!public! !
!WebApplication categoriesFor: #getLastDatabaseBackupFileNameAndTimestamp!database!public! !
!WebApplication categoriesFor: #getNewSessionId!public! !
!WebApplication categoriesFor: #getNextIdFor:!database!public! !
!WebApplication categoriesFor: #getRealCssPathFor:!database!public!session management!web server! !
!WebApplication categoriesFor: #getRealJavascriptPathFor:!database!public!session management!web server! !
!WebApplication categoriesFor: #getUserLanguageBasedOnIPandRequestFor:!localization!localization IP locating!public! !
!WebApplication categoriesFor: #hasDbBackup!public! !
!WebApplication categoriesFor: #httpLoadBalancer!public! !
!WebApplication categoriesFor: #indexServlet!public! !
!WebApplication categoriesFor: #ipRangeListForBulgaria!localization IP locating!private! !
!WebApplication categoriesFor: #ipRangeListForCroatia!localization IP locating!private! !
!WebApplication categoriesFor: #ipRangeListForRomania!localization IP locating!private! !
!WebApplication categoriesFor: #ipRangeListForSerbia!localization IP locating!private! !
!WebApplication categoriesFor: #ipRangeListForSlovenia!localization IP locating!private! !
!WebApplication categoriesFor: #isCroatianIP:!localization IP locating!public! !
!WebApplication categoriesFor: #isKnownIP:!localization IP locating!public! !
!WebApplication categoriesFor: #isRunning!private!shutdown / startup! !
!WebApplication categoriesFor: #isSafeToShutdown!public! !
!WebApplication categoriesFor: #isSerbianIP:!localization IP locating!public! !
!WebApplication categoriesFor: #isSlovenianIP:!localization IP locating!public! !
!WebApplication categoriesFor: #liveUpdatesFilePathname!live updates!private! !
!WebApplication categoriesFor: #liveUpdatesLoadAndCompileAll!live updates!private! !
!WebApplication categoriesFor: #liveUpdatesStoreAll!live updates!private! !
!WebApplication categoriesFor: #loadAllowedAndBlockedIPlist!configuration!public!web server! !
!WebApplication categoriesFor: #loadConfigurationSettings!configuration file settings!private!shutdown / startup! !
!WebApplication categoriesFor: #loadMessages!NLS support!public! !
!WebApplication categoriesFor: #loadServlets!private!web server! !
!WebApplication categoriesFor: #loginMessageInvalidUsernameOrPassword!NLS support!public! !
!WebApplication categoriesFor: #loginMessageLoginNotPossibleDueToServerMaintenance!NLS support!public! !
!WebApplication categoriesFor: #loginMessageUsernameMandatory!NLS support!public! !
!WebApplication categoriesFor: #maxInactivityTime!public!session management!web server! !
!WebApplication categoriesFor: #newCoder:!public! !
!WebApplication categoriesFor: #newEmail!public!sending email! !
!WebApplication categoriesFor: #newReadOnlyTransaction!public! !
!WebApplication categoriesFor: #newSession!public!session management! !
!WebApplication categoriesFor: #newSessionFor:sessionCookie:clientCookie:!public!session management! !
!WebApplication categoriesFor: #newSessionFor:sessionCookie:clientCookie:onlyOneSessionPerClientCookie:!public!session management! !
!WebApplication categoriesFor: #newSessionFor:username:password:!public!session management! !
!WebApplication categoriesFor: #newTransaction!public! !
!WebApplication categoriesFor: #notifyOnServerStartupCompleted!private!shutdown / startup! !
!WebApplication categoriesFor: #onLiveUpdatePerformed:!live updates!private! !
!WebApplication categoriesFor: #onServerStartupCompleted!public!shutdown / startup! !
!WebApplication categoriesFor: #purgeExpiredSessions!private!session management! !
!WebApplication categoriesFor: #reloadMessages!NLS support!public! !
!WebApplication categoriesFor: #removeSession:!public!session management! !
!WebApplication categoriesFor: #removeSession:removedDueToSessionExpiration:!public!session management! !
!WebApplication categoriesFor: #restartScavengerProcess!public!session management! !
!WebApplication categoriesFor: #scriptRootPath!database!public!session management!web server! !
!WebApplication categoriesFor: #scriptServlet!database!public!session management!web server! !
!WebApplication categoriesFor: #sendEmail:!public!sending email! !
!WebApplication categoriesFor: #sendFirstPageFor:request:on:!public! !
!WebApplication categoriesFor: #sendLoginPageFor:withMessage:on:!public! !
!WebApplication categoriesFor: #sendLoginPageWithMessage:on:!public! !
!WebApplication categoriesFor: #sendPageExpiredMessageFor:on:!public! !
!WebApplication categoriesFor: #sendSessionExpiredResponseOn:!public! !
!WebApplication categoriesFor: #serverClusterManager!database!public!server clustering! !
!WebApplication categoriesFor: #serverMessage!public!shutdown / startup!web server! !
!WebApplication categoriesFor: #serverMessage:!public!shutdown / startup!web server! !
!WebApplication categoriesFor: #serverMessage:distributed:!public!shutdown / startup!web server! !
!WebApplication categoriesFor: #servletInstanceOfClass:!database!public!web server! !
!WebApplication categoriesFor: #servletManager!public!web server! !
!WebApplication categoriesFor: #servletUrlOfClass:!database!public!web server! !
!WebApplication categoriesFor: #sessionAt:!public!session management! !
!WebApplication categoriesFor: #sessionAtCookie:!public!session management! !
!WebApplication categoriesFor: #sessionExpiredMessage!public!session management! !
!WebApplication categoriesFor: #setLocalizedLanguageFor:request:!localization!localization IP locating!public! !
!WebApplication categoriesFor: #shutdown!public!shutdown / startup! !
!WebApplication categoriesFor: #smtpConnector!configuration!public!sending email! !
!WebApplication categoriesFor: #startExpiredSessionsScavengerProcess!public!session management!shutdown / startup! !
!WebApplication categoriesFor: #startup!public!shutdown / startup! !
!WebApplication categoriesFor: #sysAdminCheckFreeDiskSpace!private!system administration! !
!WebApplication categoriesFor: #sysAdminEmailAddresses!private!system administration! !
!WebApplication categoriesFor: #sysAdminHasFreeDiskSpaceCheck!private!system administration! !
!WebApplication categoriesFor: #taskAt:!public!session management! !
!WebApplication categoriesFor: #temporaryDirectoryPath!configuration!public! !
!WebApplication categoriesFor: #urlPrefix!public!web server! !
!WebApplication categoriesFor: #userAccountDisabledMessage!NLS support!public! !
!WebApplication categoriesFor: #webFilesPath!configuration!public!web server! !
!WebApplication categoriesFor: #webServer!database!public!web server! !
!WebApplication categoriesFor: #webSessionCookieName!database!public!session management!web server! !

!WebApplication class methodsFor!

default
	singleton isNil ifTrue: [singleton := self new].
	^singleton!

defaultOrNil
	^singleton!

reset
	singleton := nil!

resetAll
	self allSubclasses do: [:eachClass | eachClass reset]! !
!WebApplication class categoriesFor: #default!public! !
!WebApplication class categoriesFor: #defaultOrNil!public! !
!WebApplication class categoriesFor: #reset!public! !
!WebApplication class categoriesFor: #resetAll!public! !

