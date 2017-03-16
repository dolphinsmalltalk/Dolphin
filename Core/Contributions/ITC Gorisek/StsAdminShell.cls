"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #StsAdminShell
	instanceVariableNames: 'localRepositoryPathPresenter localRepositoryDeveloperPresenter remoteRepositoryUrlPresenter remoteRepositoryUsernamePresenter remoteRepositoryPasswordPresenter recentLocalFileHandler recentRemoteUrlHandler localStatusPresenter remoteStatusPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsAdminShell guid: (GUID fromString: '{a45d9132-cdd3-4f44-95e7-bfe294ad1ed9}')!
StsAdminShell comment: ''!
!StsAdminShell categoriesForClass!Development! !
!StsAdminShell methodsFor!

allOpenStsTools
	"Answers a collection of all the open STS tools"

	^self allStsToolClasses inject: OrderedCollection new
		into: 
			[:all :eachClass | 
			all addAll: eachClass allInstances.
			all]!

allStsToolClasses
	^(OrderedCollection new)
		add: StsProjectBrowserShell;
		add: StsPackageEditionsBrowserShell;
		add: StsStoredChangeSetsBrowserShell;
		add: StsClassEditionsBrowserShell;
		add: StsComparisonBrowser;
		add: StsMethodComparisonShell;
		add: StsMethodEditionsBrowserShell;
		add: StsVersionTreeDiagram;
		yourself!

backup
	| backupPath |
	localStatusPresenter ensureVisible.
	backupPath := self defaultRepositoryBackupPath.
	(MessageBox confirm: 'You are about to backup your STS code repository to ' , backupPath 
				, '. 

This may take several minutes during which the system may be unresponsive. Do you wish to continue?'
		caption: self caption) ifFalse: [^self].
	
	[self view isEnabled: false.
	Cursor wait showWhile: [self db createBackupOn: backupPath]] 
			ensure: [self view isEnabled: true]!

checkRepositoryExists: aRepoPathString 
	"Private - Answer true if the repository at aRepoPathString exists and can be opened."

	| odb exists path |
	exists := false.
	
	[odb := self manager databaseClass openOn: aRepoPathString.
	odb close.
	exists := true] on: Error
			do: [:ex | ].
	^exists!

chooseDeveloper
	"Private - Let the user choose the developer alias for this computer"

	| alias |
	alias := Prompter 
				on: self getCurrentDeveloperAlias
				prompt: 'Enter a developer name for this computer'
				caption: self caption.
	(alias isNil or: [alias = self getCurrentDeveloperAlias]) ifTrue: [^self].
	self setCurrentDeveloperAlias: alias!

chooseRepository
	| repositoryPath |
	repositoryPath := self manager chooseRepository.
	repositoryPath ifNil: [^nil].
	^self makeRepositoryFullPath: repositoryPath!

compact
	localStatusPresenter ensureVisible.
	(MessageBox 
		confirm: 'You are about to compact your STS code repository. 

This may take several minutes during which the system may be unresponsive. Do you wish to continue?'
		caption: self caption) ifFalse: [^self].
	
	[self view isEnabled: false.
	Cursor wait showWhile: [self db reorganize]] 
			ensure: [self view isEnabled: true]!

connectTo
	"Browse for a repository and connect to it"

	| repositoryPath |
	repositoryPath := self chooseRepository.
	repositoryPath ifNil: [^self].
	self disconnect ifFalse: [^self].
	^self connectTo: repositoryPath!

connectTo: repositoryPath 
	| rootPath |
	self disconnect ifFalse: [^self].
	(self checkRepositoryExists: repositoryPath) 
		ifFalse: [^self errorRepositoryNotFoundOrCorrupt: repositoryPath].
	rootPath := self makeRepositoryRootPath: repositoryPath.
	(self manager)
		shutdown;
		startUpOn: rootPath.
	recentLocalFileHandler addToRecentList: repositoryPath.
	self setCurrentDeveloperAlias: self loadCurrentDeveloperAlias!

createComponents
	super createComponents.
	localRepositoryPathPresenter := self add: TextPresenter new name: 'localRepositoryPath'.
	localRepositoryDeveloperPresenter := self add: TextPresenter new name: 'localRepositoryDeveloper'.
	remoteRepositoryUrlPresenter := self add: TextPresenter new name: 'remoteRepositoryUrl'.
	remoteRepositoryUsernamePresenter := self add: TextPresenter new name: 'remoteRepositoryUsername'.
	remoteRepositoryPasswordPresenter := self add: TextPresenter new name: 'remoteRepositoryPassword'.
	localStatusPresenter := self add: ImagePresenter new name: 'localRepositoryStatus'.
	remoteStatusPresenter := self add: ImagePresenter new name: 'remoteRepositoryStatus'!

db
	^self manager databaseConnection!

defaultRepositoryBackupPath
	| fullPath |
	fullPath := self makeRepositoryFullPath: self manager repositoryPath.
	^fullPath , '(' , Date today asFilenameString , ')'!

developerOfPackage: aPackage 
	"Attempt to ascertain the developer of aPackage so that the developer name may be included in a snapshot of the package. This method is temporary only and needs improving."

	aPackage isBaseImagePackage ifTrue: [^'Object Arts Ltd'].
	(self manager refactoryPackageNames includes: aPackage name) ifTrue: [^'Refactory Inc'].
	(self manager stsPackageNames includes: aPackage name) ifTrue: [^'David Gorisek'].
	^''!

disconnect
	"Disconnect from the current repository aftyer closing all tools"

	| openStsTools ok |
	localStatusPresenter ensureVisible.
	self isConnected ifFalse: [^true].
	openStsTools := self allOpenStsTools.
	openStsTools notEmpty 
		ifTrue: 
			[ok := MessageBox 
						confirm: 'Disconnecting from the current repository will close all open STS tools.
Are you sure you wish to continue?'
						caption: self caption.
			ok ifFalse: [^false]].
	openStsTools do: [:each | each exit].
	self manager shutdown.
	^true!

disconnectedMessage
	^'<disconnected>'!

errorRepositoryAlreadyExists: pathString 
	MessageBox errorMsg: 'A respository at ' , pathString , ' already exists.' caption: self caption!

errorRepositoryNotFoundOrCorrupt: pathString 
	MessageBox errorMsg: 'The respository at ' , pathString , ' was not found or was corrupt.'
		caption: self caption!

getCurrentDeveloperAlias
	^self manager getCurrentDeveloper!

getRemotePassword
	^self getRemoteServerLoginInfo at: #password ifAbsent: []!

getRemoteServerLoginInfo
	^self manager remoteLoginData at: self getRemoteServerUrl ifAbsent: [LookupTable new]!

getRemoteServerUrl
	^self manager getCurrentServerUrl!

getRemoteUsername
	^self getRemoteServerLoginInfo at: #username ifAbsent: []!

initialize
	| stsRegistryKey |
	super initialize.
	stsRegistryKey := SessionManager current productRegistryKey , '\Source Tracking System'.
	recentLocalFileHandler := (RegistryRecentMenu withProductKey: stsRegistryKey)
				recentRegistryKey: 'Recent Repositories';
				recentMenuName: #connectToRecent;
				openSelector: #connectTo:;
				yourself.
	recentRemoteUrlHandler := (RegistryRecentMenu withProductKey: stsRegistryKey)
				recentRegistryKey: 'Recent Remote Servers';
				recentMenuName: #remoteConnectToRecent;
				openSelector: #remoteConnectTo:;
				yourself!

isConnected
	^self manager isConnected!

isRemoteConnected
	^self getRemoteServerUrl notNil!

loadCurrentDeveloperAlias
	"Private - Answer the developer alias for the current repository as actually pulled from the database"

	| rootDeveloper currentDeveloperAlias dict |
	rootDeveloper := self rootDeveloper.
	self isConnected ifFalse: [^rootDeveloper].
	
	[(dict := OmniBase root at: self stsDeveloperNameMapKey ifAbsent: []) isNil 
		ifFalse: [currentDeveloperAlias := dict at: rootDeveloper ifAbsent: [rootDeveloper]]] 
			evaluateIn: self db newReadOnlyTransaction.
	^currentDeveloperAlias!

makeRepositoryFullPath: aPathString 
	"Private - Answers the path to be used to access the repository at aPathString. Ensures the path is a directory name terminated with \Repository"

	| repository splits fullPath |
	fullPath := File fullPathOf: aPathString.
	repository := '\Repository'.
	(fullPath size >= repository size 
		and: [(fullPath rightString: repository size) asLowercase = repository asLowercase]) 
			ifTrue: [^fullPath].
	splits := File splitPath: fullPath.
	splits at: 4 put: ''.
	splits at: 3
		put: (splits third isEmpty ifTrue: [repository allButFirst] ifFalse: [splits third , repository]).
	^File makePath: splits!

makeRepositoryRootPath: aPathString 
	"Private - Answers the path to be used to access the repository at aPathString but without the appended \Repository string."

	| repository |
	repository := '\Repository'.
	self assert: [(aPathString rightString: repository size) = repository].
	^aPathString leftString: aPathString size - repository size!

manager
	^StsManager current!

newRepository
	| repositoryPath rootPath |
	localStatusPresenter ensureVisible.
	repositoryPath := self chooseRepository.
	repositoryPath ifNil: [^self].
	self disconnect ifFalse: [^self].
	(self checkRepositoryExists: repositoryPath) 
		ifTrue: [^self errorRepositoryAlreadyExists: repositoryPath].
	rootPath := self makeRepositoryRootPath: repositoryPath.
	Cursor wait showWhile: [self manager createRepositoryOn: rootPath].
	self connectTo: repositoryPath.
	self setCurrentDeveloperAlias: self rootDeveloper!

onAboutToDisplayMenu: possibleRecentMenu 
	"Private - The system is about to display the <Menu>, popup, this is our chance
	to fiddle with it and display the recent files list if appropriate."

	super onAboutToDisplayMenu: possibleRecentMenu.
	recentLocalFileHandler onAboutToDisplayMenu: possibleRecentMenu.
	recentRemoteUrlHandler onAboutToDisplayMenu: possibleRecentMenu!

queryCommand: query 
	"Private - Enters details about a potential command for the receiver into the 
	<CommandQuery>,  query."

	| cmd |
	cmd := query commandSymbol.
	(#(#disconnect #compact) includes: cmd) 
		ifTrue: 
			[query isEnabled: self isConnected.
			^true].
	(#(#toggleConnect) includes: cmd) 
		ifTrue: 
			[query text: (self isConnected ifTrue: ['Disconnect'] ifFalse: ['Connect']).
			query isEnabled: true.
			^true].
	query commandSymbol == #connectToRecent 
		ifTrue: 
			[query isEnabled: recentLocalFileHandler notEmpty.
			^true].
	query commandSymbol == #remoteConnectToRecent 
		ifTrue: 
			[query isEnabled: recentRemoteUrlHandler notEmpty.
			^true].
	query commandSymbol == #remoteDisconnect 
		ifTrue: 
			[query isEnabled: self isRemoteConnected.
			^true].
	^super queryCommand: query!

remoteConnectTo
	"Prompt for a remote repository server and connect to it"

	| ok |
	remoteStatusPresenter ensureVisible.
	
	[self view isEnabled: false.
	Cursor wait showWhile: 
			[ok := (self manager connectToRemoteServerWithCaption: 'Connect to Repository Server'
						readOnlyAccess: true) notNil]] 
			ensure: [self view isEnabled: true].
	ok 
		ifTrue: 
			[| url user pw |
			url := self getRemoteServerUrl.
			user := self getRemoteUsername.
			pw := self getRemotePassword.
			recentRemoteUrlHandler addToRecentList: user , '@' , url , ',' , pw]!

remoteConnectTo: aConnectString 
	"Restore the remote connect information from aConnectString"

	| stream user url pw loginInfo |
	remoteStatusPresenter ensureVisible.
	stream := aConnectString readStream.
	user := stream upTo: $@.
	url := stream upTo: $,.
	pw := stream upToEnd.
	self manager setRemoteServerUrl: url.
	loginInfo := self getRemoteServerLoginInfo.
	loginInfo at: #username put: user.
	loginInfo at: #password put: pw!

remoteDisconnect
	"Disconnect from the remote repository after closing all tools"

	| loginInfo |
	remoteStatusPresenter ensureVisible.
	self isRemoteConnected ifFalse: [^true].
	loginInfo := self getRemoteServerLoginInfo.
	loginInfo
		removeKey: #username ifAbsent: [];
		removeKey: #password ifAbsent: [].
	self manager setRemoteServerUrl: nil.
	^true!

rootDeveloper
	"Private - Answer the name of the root developer for this computer. This may be overidden"

	^(SessionManager current userName , '@' , SessionManager current computerName) asLowercase!

setCurrentDeveloperAlias: newDeveloperAlias 
	newDeveloperAlias = self loadCurrentDeveloperAlias 
		ifTrue: [^self manager setCurrentDeveloper: newDeveloperAlias].

	"Save developer name mapping at the root key for the next time"
	
	[| lookup |
	lookup := OmniBase root at: self stsDeveloperNameMapKey ifAbsentPut: [LookupTable newPersistent].
	lookup
		at: self rootDeveloper put: newDeveloperAlias;
		markDirty] 
			evaluateAndCommitIn: self db newTransaction.
	self manager setCurrentDeveloper: newDeveloperAlias!

stsDeveloperNameMapKey
	^'sts.developerNameMap'!

toggleConnect
	self isConnected ifTrue: [self disconnect] ifFalse: [self connectTo]!

validateUserInterface
	"Private - Set the state of the receiver accordingly. This method is sent at judicious times
	in an attempt to ensure that the receivers state is up to date. "

	super validateUserInterface.
	localRepositoryPathPresenter 
		value: (self isConnected ifTrue: [self manager repositoryPath] ifFalse: [self disconnectedMessage]).
	localRepositoryPathPresenter view isEnabled: self isConnected.
	localRepositoryDeveloperPresenter 
		value: (self isConnected ifTrue: [self getCurrentDeveloperAlias] ifFalse: [self disconnectedMessage]).
	localRepositoryDeveloperPresenter view isEnabled: self isConnected.
	remoteRepositoryUrlPresenter value: self getRemoteServerUrl.
	remoteRepositoryUsernamePresenter value: self getRemoteUsername.
	remoteRepositoryPasswordPresenter value: self getRemotePassword.
	localStatusPresenter value: (self isConnected 
				ifTrue: [self class repoConnectedIcon]
				ifFalse: [self class repoDisconnectedIcon]).
	remoteStatusPresenter value: (self isRemoteConnected 
				ifTrue: [self class repoConnectedIcon]
				ifFalse: [self class repoDisconnectedIcon])!

versionSnapshotAllPackages
	localStatusPresenter ensureVisible.
	(MessageBox 
		confirm: 'Do you want to version ALL loaded packages to the current repository?

Depending on your mode of working, this is recommended if you have just created a NEW repository or if you are upgrading to a new version of Dolphin Smalltalk and connecting to an EXISTING repository.'
		caption: self caption) ifFalse: [^self].
	self versionSnapshotPackagesList: Package manager packages!

versionSnapshotDolphinBasePackages
	localStatusPresenter ensureVisible.
	(MessageBox 
		confirm: 'Do you want to version the Dolphin Base packages to the current repository?

Depending on your mode of working, this is recommended if you have just created a NEW repository or if you are upgrading to a new version of Dolphin Smalltalk and connecting to an EXISTING repository.'
		caption: self caption) ifFalse: [^self].
	self 
		versionSnapshotPackagesList: (Package manager packages select: [:each | each isBaseImagePackage])!

versionSnapshotNonDolphinPackages
	localStatusPresenter ensureVisible.
	(MessageBox 
		confirm: 'Do you want to version everything EXCEPT the Dolphin Base packages to the current repository?

Depending on your mode of working, this is recommended if you have just created a NEW repository or if you are upgrading to a new version of Dolphin Smalltalk and connecting to an EXISTING repository.'
		caption: self caption) ifFalse: [^self].
	self 
		versionSnapshotPackagesList: (Package manager packages reject: [:each | each isBaseImagePackage])!

versionSnapshotPackage: each 
	"Version aPackage as part of a snapshot operation. Snapshots are typically taken immediately
	after the creation of a new repository or when a new version of Dolphin has just been
	installed"

	| originalDeveloper |
	originalDeveloper := self manager getCurrentDeveloper.
	
	[self manager setCurrentDeveloper: (self developerOfPackage: each).
	self manager 
		basicVersionPackage: each
		versionDescriptor: (each packageVersion notEmpty ifTrue: [each packageVersion] ifFalse: ['0.001'])
		previousEdition: nil
		versionComment: 'STS snapshot'
		checkExisting: false
		silentBool: true] 
			ensure: 
				[self manager setCurrentDeveloper: originalDeveloper.
				self invalidateUserInterface]!

versionSnapshotPackagesList: packageList 
	| countClasses totalClasses |
	totalClasses := packageList inject: 0 into: [:sum :each | sum + each classes size].
	countClasses := 0.
	ProgressDialog showModal: 'No cancel view'
		while: 
			[:progress | 
			| percent |
			packageList do: 
				[:each | 
				progress text: 'Versioning ' , each name.
				self versionSnapshotPackage: each.
				countClasses := countClasses + each classes size.
				percent := countClasses * 100 // totalClasses.
				progress value: percent]].! !
!StsAdminShell categoriesFor: #allOpenStsTools!private! !
!StsAdminShell categoriesFor: #allStsToolClasses!private! !
!StsAdminShell categoriesFor: #backup!commands!public! !
!StsAdminShell categoriesFor: #checkRepositoryExists:!helpers!private! !
!StsAdminShell categoriesFor: #chooseDeveloper!private! !
!StsAdminShell categoriesFor: #chooseRepository!helpers!private! !
!StsAdminShell categoriesFor: #compact!commands!public! !
!StsAdminShell categoriesFor: #connectTo!commands!public! !
!StsAdminShell categoriesFor: #connectTo:!commands!public! !
!StsAdminShell categoriesFor: #createComponents!private! !
!StsAdminShell categoriesFor: #db!private! !
!StsAdminShell categoriesFor: #defaultRepositoryBackupPath!private! !
!StsAdminShell categoriesFor: #developerOfPackage:!public! !
!StsAdminShell categoriesFor: #disconnect!commands!public! !
!StsAdminShell categoriesFor: #disconnectedMessage!operations!private! !
!StsAdminShell categoriesFor: #errorRepositoryAlreadyExists:!exceptions!private! !
!StsAdminShell categoriesFor: #errorRepositoryNotFoundOrCorrupt:!exceptions!private! !
!StsAdminShell categoriesFor: #getCurrentDeveloperAlias!helpers!private! !
!StsAdminShell categoriesFor: #getRemotePassword!helpers!private! !
!StsAdminShell categoriesFor: #getRemoteServerLoginInfo!helpers!private! !
!StsAdminShell categoriesFor: #getRemoteServerUrl!helpers!private! !
!StsAdminShell categoriesFor: #getRemoteUsername!helpers!private! !
!StsAdminShell categoriesFor: #initialize!initializing!private! !
!StsAdminShell categoriesFor: #isConnected!accessing!public! !
!StsAdminShell categoriesFor: #isRemoteConnected!public! !
!StsAdminShell categoriesFor: #loadCurrentDeveloperAlias!private! !
!StsAdminShell categoriesFor: #makeRepositoryFullPath:!helpers!private! !
!StsAdminShell categoriesFor: #makeRepositoryRootPath:!helpers!private! !
!StsAdminShell categoriesFor: #manager!accessing!private! !
!StsAdminShell categoriesFor: #newRepository!commands!public! !
!StsAdminShell categoriesFor: #onAboutToDisplayMenu:!event handling!private! !
!StsAdminShell categoriesFor: #queryCommand:!commands!private! !
!StsAdminShell categoriesFor: #remoteConnectTo!commands!public! !
!StsAdminShell categoriesFor: #remoteConnectTo:!commands!public! !
!StsAdminShell categoriesFor: #remoteDisconnect!commands!public! !
!StsAdminShell categoriesFor: #rootDeveloper!private! !
!StsAdminShell categoriesFor: #setCurrentDeveloperAlias:!private! !
!StsAdminShell categoriesFor: #stsDeveloperNameMapKey!constants!private! !
!StsAdminShell categoriesFor: #toggleConnect!commands!public! !
!StsAdminShell categoriesFor: #validateUserInterface!operations!private! !
!StsAdminShell categoriesFor: #versionSnapshotAllPackages!commands!public! !
!StsAdminShell categoriesFor: #versionSnapshotDolphinBasePackages!commands!public! !
!StsAdminShell categoriesFor: #versionSnapshotNonDolphinPackages!commands!public! !
!StsAdminShell categoriesFor: #versionSnapshotPackage:!commands!helpers!private! !
!StsAdminShell categoriesFor: #versionSnapshotPackagesList:!commands!private! !

!StsAdminShell class methodsFor!

displayOn: aStream 
	aStream nextPutAll: 'Source Tracking Administrator'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	(Smalltalk developmentSystem)
		addSystemFolderIcon: self toolsFolderIcon to: Smalltalk developmentSystem sourceTrackingToolsFolder;
		registerTool: self.
	self reuseIfOpen: true!

repoConnectedIcon
	^InternalIcon 
		fromBytes: #[137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 48 0 0 0 48 8 6 0 0 0 87 2 249 135 0 0 0 1 115 82 71 66 0 174 206 28 233 0 0 0 4 103 65 77 65 0 0 177 143 11 252 97 5 0 0 0 9 112 72 89 115 0 0 14 195 0 0 14 195 1 199 111 168 100 0 0 17 25 73 68 65 84 104 67 221 153 9 80 86 87 150 199 187 219 201 76 85 103 172 244 244 204 36 113 193 61 184 37 198 93 137 113 139 136 2 34 18 68 64 64 100 95 62 62 182 143 125 135 15 100 223 247 125 151 85 89 84 16 148 85 22 119 16 92 112 139 154 196 164 59 169 154 170 238 158 170 169 233 233 156 255 156 251 4 253 20 136 177 170 187 58 213 84 253 234 222 119 222 189 231 157 243 206 185 231 222 199 247 139 95 252 163 254 105 104 236 126 119 235 86 45 181 173 90 127 103 216 134 237 219 117 222 127 163 247 188 99 183 206 166 29 187 116 254 103 231 110 61 250 57 176 67 83 247 207 90 218 6 187 127 146 19 161 161 161 191 210 222 103 208 107 100 106 133 159 19 122 6 198 67 219 183 111 255 167 215 58 161 255 185 169 158 169 133 61 89 88 203 192 136 86 181 175 42 155 110 204 155 202 167 122 206 36 29 135 45 29 200 200 196 202 252 71 29 48 50 50 154 193 111 253 154 189 204 155 24 140 183 170 125 85 217 116 99 222 84 62 213 115 166 212 97 118 212 241 174 92 46 255 151 105 157 48 59 226 112 208 201 213 15 174 94 161 63 75 156 221 252 97 237 224 97 55 157 3 191 180 177 119 27 246 9 142 161 103 196 98 114 95 85 54 221 152 55 149 79 245 156 233 117 56 202 125 31 242 58 157 188 22 156 228 126 90 241 41 133 148 83 84 47 145 91 124 2 175 246 85 101 211 141 121 83 249 84 207 249 49 29 73 25 165 228 19 20 245 249 164 40 120 251 135 134 213 55 181 161 173 99 224 103 205 169 214 110 4 69 196 41 39 57 224 36 119 87 230 228 151 162 225 84 59 53 50 77 167 207 65 180 170 125 85 217 116 99 222 84 62 213 115 126 76 199 241 154 70 200 221 188 163 39 57 224 224 36 87 102 229 22 227 68 99 43 157 104 60 75 39 57 26 162 85 237 171 202 166 27 243 166 242 169 158 243 99 58 202 143 159 132 147 92 49 217 1 59 7 153 50 35 187 8 117 39 91 80 215 208 2 209 143 140 78 70 90 70 193 223 149 99 177 169 72 101 27 132 77 130 210 138 122 56 201 60 166 118 32 61 171 0 85 117 167 168 154 241 244 9 193 141 209 123 244 197 163 167 244 232 241 55 80 109 69 255 213 235 137 49 111 42 127 221 188 91 183 191 32 15 175 96 8 155 4 69 101 181 112 144 185 77 118 192 198 206 73 153 154 145 143 202 234 70 170 172 105 34 15 239 16 220 188 253 128 238 221 127 66 247 31 124 9 213 86 244 95 189 158 24 243 166 242 215 205 27 187 247 152 220 20 65 16 54 9 10 74 170 225 224 52 141 3 201 105 185 40 175 106 64 126 209 113 4 5 135 113 234 228 98 236 238 163 215 114 103 236 145 136 22 46 95 189 133 190 193 33 244 15 94 199 141 145 187 175 157 247 83 117 187 122 6 74 118 9 242 216 54 91 7 249 228 8 88 217 56 41 147 82 115 80 82 94 79 145 209 137 84 127 130 87 187 187 55 221 226 40 220 190 243 16 183 110 189 104 69 95 48 124 99 12 231 187 47 81 75 251 5 234 232 26 196 133 254 43 212 123 129 175 91 59 81 84 82 69 89 57 197 212 204 213 236 230 173 251 210 248 9 61 170 253 169 100 170 247 197 92 185 187 191 100 151 32 39 191 98 58 7 28 148 9 201 89 16 57 22 20 26 133 202 202 106 28 181 182 199 232 205 123 147 184 201 178 211 45 157 34 221 208 211 51 128 161 161 155 24 27 123 136 145 27 119 112 253 250 8 238 220 121 192 14 223 195 149 203 67 168 174 105 64 122 86 33 46 93 190 49 165 174 9 253 151 174 140 96 240 242 40 206 119 14 160 169 185 13 35 163 119 165 241 35 28 89 25 31 111 132 93 130 204 220 82 88 219 201 38 71 192 210 202 65 25 151 152 193 233 83 69 129 193 74 18 14 88 90 219 209 208 141 59 52 60 50 134 231 237 240 109 18 111 183 176 184 146 58 187 250 80 87 223 68 114 185 7 237 216 169 137 181 107 55 144 96 195 134 205 56 120 208 132 98 98 19 169 167 119 16 167 207 180 83 82 106 54 245 245 95 149 244 188 170 179 173 189 155 78 52 156 161 150 150 118 52 53 157 161 246 115 221 84 83 215 140 161 225 59 116 157 159 231 36 247 145 236 18 164 103 21 195 218 118 74 7 236 148 49 9 233 200 41 168 36 191 128 80 202 200 200 134 153 133 21 93 187 118 147 174 15 221 194 68 91 86 94 67 73 201 153 116 178 177 133 92 228 30 216 184 81 131 220 221 21 212 212 116 138 243 126 132 198 198 238 82 255 192 32 210 211 51 73 91 71 143 118 237 218 131 220 188 98 170 174 109 160 132 164 76 92 188 52 252 146 206 161 161 219 28 161 124 10 11 143 162 202 170 122 180 156 237 96 199 147 40 62 41 29 237 231 122 232 42 63 223 145 79 198 194 46 65 74 70 33 142 218 58 77 142 128 133 165 157 50 58 46 13 217 156 99 254 129 17 56 126 92 68 192 30 87 174 142 62 167 167 247 18 223 11 67 97 73 37 140 14 29 198 222 189 186 184 112 161 15 223 127 255 61 186 123 122 81 80 88 140 156 220 124 212 214 213 227 254 253 7 120 250 244 41 66 67 35 176 126 253 38 68 199 37 11 67 145 87 80 246 146 78 161 223 93 225 7 31 191 96 94 67 87 185 8 92 67 237 137 83 224 170 136 227 213 39 185 48 140 194 222 89 129 172 188 114 137 164 180 124 78 237 41 29 176 81 70 197 164 32 61 187 132 124 253 67 165 20 58 114 212 150 46 94 28 162 75 151 134 33 218 212 180 28 222 220 18 201 218 214 137 223 172 22 221 188 121 19 253 253 3 228 228 36 39 109 109 61 236 217 163 75 134 134 198 180 79 239 0 244 244 12 40 37 37 157 190 250 234 107 68 68 68 210 250 245 155 41 38 33 21 129 33 17 212 221 51 248 92 167 88 27 238 158 126 228 228 226 65 53 245 205 168 170 109 164 220 252 82 50 49 179 68 121 101 29 13 242 115 237 156 60 145 198 118 9 18 82 114 113 196 218 97 114 4 204 44 108 148 202 232 36 164 100 20 145 207 132 3 86 182 52 48 112 141 6 185 44 246 247 95 37 47 159 64 94 224 145 180 234 227 181 84 90 86 65 141 156 54 194 80 3 131 67 20 17 149 136 246 142 65 106 57 219 77 199 98 146 97 240 185 9 29 56 112 144 20 10 31 12 12 92 36 93 221 253 100 96 104 204 14 40 169 184 228 248 51 157 3 87 165 54 53 35 143 236 28 92 40 49 37 19 177 9 169 188 6 195 185 246 251 163 173 173 91 172 27 178 117 112 103 187 10 69 250 80 108 82 54 204 143 78 233 128 149 50 156 141 72 78 47 128 127 144 18 10 133 55 172 172 237 208 215 127 5 125 125 87 208 210 218 1 103 206 121 147 195 71 160 173 189 15 21 149 53 96 3 161 161 177 13 145 199 18 56 66 215 165 138 212 205 244 245 95 70 107 91 23 76 205 172 176 109 219 103 8 143 56 134 208 48 37 86 126 184 10 222 156 42 209 177 201 146 206 9 58 58 251 160 240 10 64 92 98 58 142 197 166 192 219 55 24 37 165 85 210 253 222 190 203 176 182 119 227 212 41 144 136 142 207 132 249 17 187 201 17 224 135 41 195 148 241 136 79 206 165 216 196 108 58 96 96 130 234 234 6 234 238 190 72 61 61 151 112 188 234 4 191 9 23 108 219 190 139 204 204 143 146 163 179 27 237 216 161 9 99 211 35 92 149 142 83 57 59 116 162 161 153 171 73 51 213 241 30 82 84 82 73 25 217 133 164 241 201 54 236 227 40 133 112 228 150 46 93 193 235 202 129 124 252 66 184 58 93 194 132 110 209 42 35 227 40 58 46 29 225 81 73 124 116 8 160 179 103 187 164 251 93 221 131 100 101 235 42 217 37 136 138 77 199 225 35 182 83 59 16 18 17 135 24 54 62 38 33 139 172 236 92 113 150 211 161 163 179 159 186 186 6 80 90 90 45 57 176 118 221 70 50 97 163 247 236 221 71 139 22 171 195 197 205 139 162 185 106 164 101 228 32 53 61 155 4 162 159 156 154 73 161 17 49 244 153 230 94 172 88 177 74 74 145 85 171 214 192 200 216 140 60 20 126 146 206 9 221 162 141 137 77 166 99 92 68 34 142 37 243 125 127 46 165 189 210 253 243 29 125 100 105 227 2 97 147 32 34 58 21 135 205 167 112 192 216 204 82 25 20 22 35 133 72 201 131 120 161 34 45 61 23 231 207 95 144 40 43 171 129 141 189 12 107 214 110 128 142 174 62 52 62 217 10 53 181 5 224 197 199 231 115 5 59 50 25 55 15 31 236 248 76 11 139 151 44 197 231 134 38 88 190 252 67 24 153 152 195 205 221 7 108 152 164 247 108 251 121 20 158 140 66 96 222 30 248 149 126 140 128 106 117 4 213 126 128 240 218 141 136 175 53 66 81 67 52 142 216 56 226 24 219 37 8 139 76 130 137 185 245 228 8 24 155 90 42 3 66 142 65 25 147 70 126 129 74 202 47 40 129 220 195 151 196 66 106 107 235 65 93 93 51 113 248 241 201 150 237 180 113 211 39 180 110 221 38 90 182 124 165 148 18 110 158 190 188 221 123 75 71 143 113 164 190 135 151 63 105 108 217 142 21 43 63 162 93 154 123 73 77 109 62 120 195 36 79 150 183 183 247 32 173 34 132 156 210 86 194 167 120 29 242 59 172 112 234 122 24 122 198 210 209 115 55 3 103 134 35 80 216 101 195 78 173 131 77 194 18 120 199 216 18 191 88 10 142 72 192 161 195 71 39 59 96 100 106 161 244 15 142 226 28 76 230 146 166 160 244 244 44 206 111 115 222 29 59 169 181 181 11 103 206 116 144 173 189 11 244 185 226 168 171 47 231 220 222 42 25 180 117 187 38 133 134 71 147 56 126 136 10 37 8 14 139 66 72 88 20 41 124 130 105 214 236 185 156 66 31 209 166 205 91 104 254 252 133 92 8 20 20 28 26 78 138 148 253 112 74 251 8 101 189 46 232 125 144 140 11 95 36 162 255 73 34 46 126 149 136 65 166 239 113 34 122 31 50 124 175 180 199 5 78 233 171 96 171 220 133 128 176 99 211 56 96 108 161 244 13 84 34 148 67 228 40 243 228 157 52 11 135 76 205 249 24 112 254 57 1 129 225 124 46 241 230 212 153 15 94 3 88 189 122 29 222 123 111 54 167 145 39 178 243 74 144 194 251 132 40 133 226 187 34 53 51 31 235 55 106 96 222 188 133 208 220 173 13 177 128 53 181 116 96 197 169 105 19 177 29 94 249 91 112 226 154 23 78 143 6 162 245 118 32 218 239 6 225 252 253 32 116 62 12 70 199 131 96 156 191 23 132 182 177 64 180 220 10 196 169 145 0 212 95 245 130 34 111 11 44 2 182 224 160 137 69 204 164 79 74 67 99 51 165 183 127 4 130 194 226 201 206 209 141 226 226 18 97 104 100 202 71 132 179 212 204 135 43 209 150 148 84 177 1 206 116 192 208 132 56 159 201 194 210 22 235 120 131 98 135 104 47 175 11 126 243 188 208 210 196 166 132 165 203 86 210 226 37 234 36 114 127 175 182 158 52 70 212 118 19 249 78 200 51 54 160 180 207 30 85 151 156 81 123 85 134 250 33 25 26 110 184 160 113 212 5 77 163 114 137 198 17 23 156 28 150 161 238 186 12 213 87 100 168 188 232 140 146 11 246 144 165 111 192 126 199 181 221 147 29 48 50 83 122 249 133 33 32 52 86 114 32 41 41 85 170 24 39 79 182 80 67 67 43 38 218 128 192 48 82 248 6 211 182 29 154 180 142 143 8 238 156 255 90 123 117 105 201 7 75 241 238 123 179 104 222 188 5 180 96 193 34 124 188 122 45 167 156 140 196 145 99 214 172 57 36 227 106 101 229 104 5 179 8 117 164 181 25 33 167 211 12 249 61 102 40 188 96 142 146 1 115 148 13 90 160 252 146 5 42 24 209 150 93 180 64 233 160 57 138 251 205 81 208 107 134 220 46 51 228 116 152 33 237 172 17 140 67 23 255 121 159 239 172 121 47 57 97 96 100 170 244 244 9 133 111 80 52 159 183 93 165 20 98 7 80 127 226 244 75 84 243 17 218 157 171 75 72 68 52 14 240 206 186 120 241 7 56 106 101 11 15 133 47 127 41 185 74 103 24 81 149 156 156 229 188 224 183 114 5 82 135 79 64 168 88 212 176 9 216 131 128 138 79 145 212 170 135 228 214 253 72 62 187 31 169 109 251 145 118 78 31 25 231 245 145 217 169 143 44 70 180 25 29 250 72 103 89 90 251 126 164 240 184 188 22 23 158 163 143 164 22 61 248 151 111 129 174 215 172 184 151 29 48 52 85 186 243 183 167 119 64 36 89 219 201 165 69 108 100 124 152 106 248 51 174 182 182 25 170 109 121 121 29 249 112 20 2 66 148 92 183 227 73 103 159 62 45 92 180 4 243 23 44 164 133 11 23 209 156 57 115 177 122 205 122 142 164 156 226 121 77 184 184 42 40 60 34 154 44 34 63 68 84 195 78 28 107 252 12 209 77 130 93 207 104 222 133 24 193 169 151 17 242 232 102 77 84 119 70 226 155 111 191 68 99 79 26 162 27 53 17 117 114 39 140 66 213 30 179 3 191 124 238 132 62 59 224 202 223 158 158 190 17 188 97 185 81 112 72 24 14 30 50 165 227 85 39 169 170 186 129 79 167 47 90 209 175 168 168 167 248 248 84 40 188 3 40 48 84 201 231 148 92 254 216 40 162 140 220 66 202 204 43 70 20 111 110 124 118 34 79 62 105 102 100 228 83 118 81 54 217 167 46 67 112 205 102 132 212 10 52 144 212 120 8 161 117 155 159 81 63 153 176 58 13 212 176 241 79 191 121 130 223 127 247 13 190 253 253 215 40 110 247 146 116 216 164 168 255 176 207 85 37 141 244 13 140 149 114 143 0 184 121 135 146 147 171 63 31 19 180 16 18 28 33 25 90 89 121 2 170 173 232 79 92 151 148 84 115 180 242 40 60 60 26 62 62 65 228 229 29 72 190 190 33 136 138 74 160 236 236 34 226 104 73 115 227 179 34 201 37 119 5 124 202 62 134 79 249 106 212 118 69 227 225 147 219 200 111 149 195 183 98 53 124 43 95 101 141 244 230 191 250 230 11 60 253 246 9 190 249 221 151 232 29 169 129 95 197 58 120 179 14 231 236 101 196 235 224 211 231 17 224 31 16 148 50 254 239 175 220 51 4 46 30 193 48 48 178 68 46 127 190 149 241 103 220 95 131 232 204 16 88 38 205 135 77 218 34 228 156 118 199 147 175 239 75 198 125 241 229 29 228 156 113 129 107 193 114 184 22 46 135 155 196 10 84 117 69 62 31 243 229 211 135 232 184 86 9 89 238 114 216 103 44 98 29 11 113 36 97 30 233 249 191 251 226 87 27 61 125 35 165 147 171 47 156 221 3 57 2 1 164 111 104 193 161 47 160 162 162 227 92 62 171 161 218 138 254 171 215 19 99 166 147 71 166 5 146 121 252 92 88 196 171 193 62 109 5 6 71 79 227 241 215 119 37 30 60 185 137 212 147 14 56 146 164 198 204 67 121 123 132 228 216 196 253 115 87 202 97 157 178 4 22 9 98 254 92 152 199 207 129 89 236 28 210 13 124 87 243 121 4 116 217 1 7 23 111 56 202 253 97 239 226 135 163 118 238 176 119 116 135 47 151 214 191 6 50 95 123 241 80 152 197 205 129 57 227 152 246 33 6 70 78 113 26 221 146 184 247 104 4 233 141 50 84 156 139 196 131 199 163 207 229 194 120 155 228 37 146 209 98 222 4 102 49 115 104 111 192 187 155 95 56 160 103 168 180 119 246 130 157 204 151 108 156 125 200 214 217 7 206 30 193 36 243 12 33 23 78 43 213 86 244 95 189 158 24 51 157 220 193 211 139 14 199 62 123 123 19 198 136 227 65 255 141 102 54 126 120 156 33 149 254 48 218 47 151 177 241 234 47 12 31 159 107 145 48 7 166 49 179 255 178 203 111 246 191 63 119 64 155 29 176 117 244 132 181 163 55 89 57 40 24 47 60 107 85 251 170 178 233 198 76 47 55 13 231 239 129 228 185 156 38 76 34 167 67 226 28 200 178 62 198 133 225 6 220 121 120 245 37 218 46 151 192 54 85 157 211 102 142 52 78 140 23 243 196 124 129 113 244 156 107 47 237 3 218 186 6 74 254 249 6 71 237 61 113 196 214 227 111 130 169 167 54 156 115 23 195 46 115 1 172 82 213 96 153 194 198 48 242 220 53 232 29 58 129 155 247 46 74 180 94 42 132 67 230 178 231 247 197 152 163 140 85 154 154 52 87 232 48 8 159 227 254 146 3 251 12 14 173 61 104 114 116 76 123 191 241 119 90 58 7 255 75 176 103 223 161 255 221 255 185 57 137 138 164 199 173 246 126 19 232 30 56 76 123 116 15 254 73 75 247 224 31 180 116 13 255 160 165 99 244 199 103 28 252 227 30 29 195 63 105 49 19 237 164 190 158 193 127 91 198 46 33 121 193 7 16 56 229 46 130 67 246 2 216 102 204 131 71 225 58 116 95 175 69 203 197 60 56 102 47 149 140 181 102 108 51 230 75 99 132 209 46 249 207 230 29 73 88 240 221 110 197 123 111 79 249 91 217 91 111 189 245 17 223 208 101 14 44 93 246 225 197 196 228 108 18 255 243 140 79 204 164 157 154 226 52 233 74 51 223 249 141 56 13 202 25 241 22 20 140 47 227 207 4 49 33 76 24 19 206 68 140 35 250 66 22 178 116 219 204 42 89 174 58 121 20 175 120 21 132 84 111 229 58 191 1 30 37 43 153 21 47 80 25 235 156 167 254 195 129 208 217 251 166 52 126 92 184 156 219 45 204 158 101 203 63 234 203 204 46 198 131 71 191 67 65 113 21 246 232 24 240 191 245 220 104 230 204 119 132 65 182 140 3 227 204 184 48 110 227 14 121 142 59 229 197 173 42 194 81 113 207 227 131 205 51 59 125 202 214 82 112 245 166 151 169 217 36 237 178 207 16 253 113 198 199 121 151 174 33 13 227 223 6 255 152 241 226 158 88 217 11 152 149 51 102 204 216 181 100 137 122 176 142 142 94 246 230 79 182 22 189 255 254 236 244 119 222 249 55 97 148 62 99 192 24 50 70 140 49 99 194 28 102 204 24 241 131 180 192 98 156 137 107 113 79 252 76 26 190 96 205 175 251 188 11 54 252 37 182 73 155 84 137 107 214 134 68 147 54 84 229 158 5 235 255 111 225 186 183 139 120 174 58 243 171 215 57 49 113 95 28 150 126 10 66 225 79 229 159 121 236 98 70 119 230 127 206 8 219 235 48 127 52 164 74 243 135 244 214 195 148 213 110 249 18 66 22 124 124 215 15 90 182 106 215 222 254 237 175 220 121 206 58 102 230 79 53 254 111 61 238 45 126 192 127 48 75 127 253 155 25 186 234 91 102 70 238 180 80 171 51 240 88 222 101 224 185 188 243 51 203 121 53 234 159 254 107 200 219 239 204 216 201 99 230 50 98 209 190 56 125 142 91 247 255 132 73 53 1 240 29 236 110 0 0 0 0 73 69 78 68 174 66 96 130]!

repoDisconnectedIcon
	^InternalIcon 
		fromBytes: #[137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 48 0 0 0 48 8 6 0 0 0 87 2 249 135 0 0 0 1 115 82 71 66 0 174 206 28 233 0 0 0 4 103 65 77 65 0 0 177 143 11 252 97 5 0 0 0 9 112 72 89 115 0 0 14 195 0 0 14 195 1 199 111 168 100 0 0 17 86 73 68 65 84 104 67 221 89 9 80 149 87 150 78 103 153 169 154 137 157 152 244 104 212 184 239 154 184 160 162 104 20 84 100 21 5 17 1 65 246 29 30 251 190 61 224 137 128 108 194 99 145 237 129 11 155 108 138 138 74 68 65 54 81 20 23 84 20 151 68 179 142 61 83 213 157 169 234 234 153 212 249 230 220 95 65 20 48 177 170 123 58 53 84 125 117 238 61 247 220 251 159 239 63 231 158 123 255 199 91 111 253 127 253 211 208 216 52 110 237 90 157 201 107 117 254 193 96 31 52 53 13 62 121 163 247 172 181 201 96 165 214 70 131 191 172 223 100 68 191 5 104 105 27 254 183 142 190 201 166 95 69 66 46 151 191 173 191 217 228 130 153 165 61 126 75 48 50 49 239 209 212 212 124 247 23 73 108 221 102 105 100 185 203 133 118 57 120 130 33 228 208 246 80 221 104 54 111 170 31 233 57 195 214 216 105 235 74 102 22 246 214 175 37 96 102 102 246 14 191 245 43 46 158 65 196 192 115 57 180 61 84 55 154 205 155 234 71 122 206 136 107 88 217 185 221 149 201 100 255 60 42 9 43 27 215 237 238 222 161 240 14 148 255 38 225 225 19 6 7 87 63 231 209 8 252 206 209 197 231 90 112 84 34 61 67 18 134 183 135 234 70 179 121 83 253 72 207 25 125 13 55 89 200 3 222 167 195 247 130 187 44 84 39 121 95 17 237 87 85 75 200 43 174 193 171 237 161 186 209 108 222 84 63 210 115 94 183 70 90 214 1 10 142 140 223 54 44 10 65 97 242 152 234 99 103 112 166 169 227 55 141 227 167 154 17 25 183 87 49 140 128 187 204 87 177 191 224 0 234 142 55 210 81 198 177 19 95 66 200 161 237 161 186 209 108 222 84 63 210 115 94 183 70 89 229 81 200 124 130 18 134 17 112 117 151 41 114 242 138 81 115 244 20 213 28 61 77 181 28 13 33 135 182 135 234 70 179 121 83 253 72 207 121 221 26 135 202 106 225 46 11 24 78 192 217 213 83 145 149 171 66 85 109 3 170 234 26 32 218 187 19 210 145 153 85 248 15 197 158 164 12 100 176 15 194 39 129 3 135 171 225 238 233 55 50 1 101 78 33 202 171 142 83 5 195 63 56 26 215 111 222 163 135 143 190 165 71 95 125 135 161 82 180 95 237 15 216 188 169 254 151 230 221 186 253 144 252 2 163 32 124 18 80 29 60 2 87 79 159 225 4 28 157 221 21 25 89 5 40 173 56 74 165 149 199 200 47 40 26 189 183 239 211 189 254 175 169 255 254 99 12 149 162 253 106 127 192 230 77 245 191 52 175 239 222 87 228 19 16 9 225 147 64 97 73 5 92 221 71 33 144 158 153 135 67 229 117 40 80 149 33 50 42 134 83 39 15 125 119 31 253 34 238 244 61 18 209 194 165 238 91 104 235 236 65 123 231 85 92 191 113 247 23 231 253 218 181 189 253 35 36 191 4 242 217 55 39 87 217 240 8 216 59 186 43 210 50 246 163 228 80 53 237 78 72 165 234 26 222 237 190 65 116 139 163 112 251 206 3 220 186 245 66 138 182 192 181 235 125 56 219 220 69 13 141 173 212 116 190 19 173 237 151 233 66 43 247 79 157 131 170 164 156 114 246 23 83 61 87 179 222 91 253 146 253 192 58 67 219 35 233 134 142 139 185 50 223 48 201 47 129 253 5 135 71 35 224 170 72 73 207 129 200 177 72 121 60 74 75 43 96 231 224 130 155 189 247 134 161 151 117 39 26 206 137 116 67 75 75 7 122 122 122 209 215 247 0 55 174 223 193 213 171 55 112 231 206 125 38 124 15 151 47 245 160 162 178 14 202 156 34 116 93 186 62 226 90 3 235 119 93 190 129 206 75 55 113 246 92 7 142 213 159 193 141 155 119 37 251 27 28 89 79 190 222 8 191 4 178 243 14 192 193 217 115 120 4 108 237 93 21 123 83 179 56 125 202 41 34 74 65 130 128 173 131 51 245 92 191 67 215 110 244 97 80 94 187 77 226 237 22 21 151 210 185 243 109 168 170 62 70 50 153 31 105 173 215 134 154 218 10 18 88 177 98 21 182 111 183 160 196 164 84 106 185 208 137 19 39 27 41 45 35 151 218 218 187 165 117 94 93 243 76 99 51 213 212 157 164 134 134 70 28 59 118 146 26 191 108 166 202 170 122 244 92 187 67 87 249 121 238 178 96 201 47 1 101 78 49 28 156 70 36 224 172 72 76 81 98 127 97 41 133 134 203 41 43 43 23 86 187 236 233 202 149 94 186 218 115 11 3 242 224 161 74 74 75 207 166 218 163 13 228 37 243 131 186 186 6 249 250 6 208 177 99 199 57 239 111 80 95 223 93 106 239 232 132 82 153 77 250 6 70 180 113 163 46 242 242 139 169 226 72 29 165 164 101 227 98 215 181 151 214 236 233 185 205 17 42 160 152 216 120 42 45 175 70 195 233 38 38 158 70 201 105 74 52 126 217 66 221 252 124 55 190 25 11 191 4 246 101 21 193 206 201 125 120 4 118 217 58 43 18 246 102 34 151 115 44 44 34 14 101 101 34 2 46 184 220 125 115 16 45 23 186 120 44 6 69 37 165 48 219 177 19 122 122 134 104 109 109 195 211 167 79 209 220 114 1 133 69 197 216 159 87 128 35 85 213 232 239 191 143 111 191 253 22 114 121 28 150 47 95 137 132 189 233 194 81 228 23 30 124 105 77 177 190 111 64 40 130 67 163 120 15 117 115 17 184 130 35 53 199 193 85 17 101 21 181 92 24 110 194 197 35 0 57 249 135 36 164 101 22 112 106 143 72 192 81 17 159 184 15 202 220 18 10 9 147 75 41 100 99 231 68 23 47 246 80 87 215 53 8 153 145 185 159 15 183 84 114 112 114 231 55 171 67 189 189 189 104 111 239 32 119 119 25 233 235 27 65 87 215 144 76 77 205 105 179 145 49 140 140 76 104 223 62 37 61 121 242 13 226 226 118 211 242 229 171 40 49 37 3 17 209 113 212 220 210 57 184 166 216 27 190 254 161 228 238 229 71 149 213 245 40 63 114 148 242 10 14 144 133 149 45 14 149 86 81 39 63 215 217 221 31 153 236 151 64 202 190 60 216 56 184 14 143 128 213 46 71 133 34 33 13 251 178 84 20 60 64 192 222 137 58 58 174 80 39 151 197 246 246 110 10 12 142 224 13 190 155 22 45 86 163 3 7 15 211 81 78 27 225 168 137 201 14 138 139 79 69 99 83 39 53 156 110 166 61 137 233 48 217 102 65 198 198 219 41 32 32 24 29 29 23 201 208 112 11 153 152 154 51 1 5 21 151 148 61 91 179 163 91 146 25 89 249 228 236 234 69 169 251 178 145 148 146 193 123 48 150 107 127 24 206 156 105 22 251 134 156 92 125 217 175 34 145 62 148 148 150 11 107 187 17 9 216 43 98 217 137 116 101 33 194 34 21 8 8 8 130 189 131 51 218 218 47 163 173 237 50 26 78 53 193 131 115 222 98 167 13 244 245 55 227 112 105 37 216 65 104 104 172 195 238 61 41 28 161 171 82 69 106 102 180 181 95 194 169 51 231 97 105 101 143 117 235 54 32 54 110 15 228 49 10 44 252 108 17 130 56 85 18 146 210 165 53 7 208 116 174 13 1 129 225 216 155 170 196 158 164 125 8 10 137 66 201 129 114 105 252 66 219 37 56 184 248 112 234 20 74 72 72 206 134 181 141 243 240 8 240 195 20 49 138 100 36 167 231 81 82 106 46 25 155 88 160 162 162 142 154 155 47 82 75 75 23 202 202 107 248 77 120 97 157 230 70 178 178 182 35 55 15 31 210 210 210 134 185 165 13 87 165 50 58 196 132 106 234 234 185 154 212 83 21 159 33 170 146 82 202 202 45 34 141 213 235 176 153 163 20 205 145 155 59 119 1 239 43 87 10 14 141 230 234 212 133 129 181 133 84 236 222 75 9 123 149 136 141 79 227 171 67 56 157 62 125 94 26 63 223 220 73 246 78 222 146 95 2 241 73 74 236 180 113 26 153 64 116 220 94 36 178 243 137 41 57 100 239 236 141 211 156 14 77 231 218 233 252 249 14 28 56 80 33 17 80 91 166 78 22 236 180 174 222 102 154 49 115 14 188 124 2 41 129 171 70 102 214 126 100 40 115 73 64 180 211 51 178 73 30 151 72 27 180 245 176 96 193 34 41 69 22 45 90 10 51 115 43 242 11 8 149 214 28 88 91 200 196 164 116 218 195 69 36 110 79 58 143 135 113 41 189 32 141 159 109 106 35 91 71 47 8 159 4 226 18 50 176 211 122 4 2 230 86 182 138 200 152 68 41 68 10 54 226 141 138 76 101 30 206 158 109 149 112 240 96 37 28 93 60 177 84 109 5 12 12 183 66 99 245 90 76 158 60 13 188 249 248 126 30 192 68 134 195 199 47 24 90 27 116 48 115 214 92 108 51 181 192 252 249 159 193 204 194 26 62 190 193 96 199 6 215 110 60 249 37 178 253 100 200 221 178 30 170 47 230 163 108 229 52 84 107 204 68 197 134 69 168 180 53 65 160 137 49 18 248 102 188 135 125 139 217 157 6 11 107 135 225 17 48 183 180 85 132 71 239 129 34 49 147 66 35 20 84 80 88 2 153 95 8 137 141 116 230 76 11 170 170 234 137 195 143 213 107 52 73 125 229 106 90 182 108 37 205 155 191 80 74 9 31 255 16 62 238 131 164 171 199 115 72 109 191 192 48 210 88 163 137 5 11 63 167 141 218 122 52 121 242 84 240 129 73 254 172 111 108 108 193 233 83 231 169 52 54 26 25 107 22 66 181 113 41 154 124 236 112 67 153 128 7 165 5 120 88 174 66 111 86 18 206 249 57 162 100 227 18 164 175 154 139 61 206 78 20 21 151 130 29 59 237 134 19 48 179 220 165 8 139 138 231 28 76 231 146 22 64 74 101 14 231 183 53 159 142 231 232 212 169 243 56 121 178 137 156 92 188 176 149 43 206 156 57 243 57 183 215 74 14 173 213 212 38 121 108 2 137 235 135 168 80 2 81 49 241 136 142 137 167 128 224 40 154 48 241 83 78 161 207 105 229 170 53 52 117 234 116 46 4 1 36 151 199 211 137 99 167 145 97 105 140 125 236 124 91 184 15 30 22 101 226 107 85 6 30 23 166 226 155 162 84 60 97 249 117 65 26 30 21 101 72 99 173 17 62 76 116 62 162 13 54 192 210 220 42 101 216 23 153 153 249 46 69 72 132 2 114 14 145 155 167 63 159 164 57 216 97 105 205 215 128 179 131 8 143 136 229 123 73 16 167 206 84 240 30 192 146 37 203 48 126 252 68 78 35 127 228 230 151 96 31 159 19 162 20 138 239 138 140 236 2 44 87 215 192 148 41 211 161 189 73 31 98 3 107 235 24 192 222 201 3 251 115 139 144 100 162 135 2 253 47 112 109 119 24 122 147 34 112 135 113 47 37 18 247 83 162 240 32 245 25 250 185 127 55 57 18 183 18 35 112 147 209 163 8 67 190 238 26 248 45 157 213 39 215 124 235 229 95 38 76 205 173 20 65 97 113 136 140 73 38 103 55 31 218 187 55 21 166 102 150 124 69 56 77 245 124 185 18 178 164 164 92 56 64 198 166 22 196 249 76 187 108 157 176 140 15 40 38 68 122 188 47 248 205 243 70 203 20 135 18 230 206 91 72 51 103 205 33 145 251 122 250 70 146 141 168 237 98 51 167 187 59 35 107 253 10 116 6 121 224 82 136 39 174 132 121 225 90 132 23 110 68 122 225 102 148 12 189 209 207 112 51 82 134 235 172 239 9 247 66 119 168 39 58 131 61 208 17 232 14 165 214 114 248 207 30 23 241 82 20 76 205 172 20 129 161 49 8 151 39 73 4 210 210 50 164 138 81 91 219 64 117 117 167 48 32 195 35 98 40 32 36 138 214 105 105 211 50 190 34 248 114 254 235 232 25 210 172 217 115 49 110 252 4 154 50 101 26 77 155 54 3 139 151 168 113 202 121 146 184 114 76 152 48 137 60 185 90 137 42 150 166 72 32 197 242 185 56 235 96 129 115 46 214 104 113 179 70 155 155 21 58 56 215 47 122 237 194 37 153 205 32 186 184 221 233 105 141 118 31 71 92 112 221 137 102 87 107 156 115 182 194 151 246 59 32 95 60 253 191 124 230 142 159 54 72 194 196 204 82 225 31 44 71 72 100 2 223 183 189 165 20 98 2 168 174 57 241 18 42 248 10 237 203 213 37 58 46 1 198 124 178 206 156 57 27 118 246 78 240 11 8 225 47 37 111 233 14 35 170 146 187 135 140 55 252 90 174 64 115 16 28 46 23 155 26 177 177 9 72 182 225 243 69 239 11 156 182 52 146 112 202 220 16 29 73 177 248 230 225 35 180 114 68 206 89 111 193 121 27 99 9 77 214 70 104 13 145 241 216 67 180 42 34 216 214 0 167 45 120 158 197 102 148 233 112 42 205 30 159 246 130 128 169 165 194 151 191 61 131 194 119 147 131 179 76 218 196 102 230 59 169 146 63 227 142 28 169 199 80 121 232 80 21 5 115 20 194 163 21 92 183 147 201 96 243 86 154 62 99 22 166 78 155 78 211 167 207 160 73 147 62 197 146 165 203 57 146 50 74 230 61 225 229 29 64 113 124 38 84 242 23 85 252 234 197 56 110 168 137 250 205 90 168 55 88 135 54 118 236 143 124 25 252 143 63 62 197 247 143 31 227 172 151 35 142 115 57 61 110 164 197 85 201 25 63 60 121 34 141 61 253 241 71 92 136 12 146 230 212 111 214 228 53 214 65 190 112 242 189 65 2 91 153 128 55 127 123 250 135 196 113 168 125 40 42 58 6 219 119 88 82 89 121 45 149 87 212 241 237 244 133 20 237 195 135 171 41 57 57 3 1 65 225 20 33 87 240 61 37 143 63 54 84 148 149 87 68 217 249 197 136 231 195 141 239 78 228 207 55 205 172 172 2 42 45 171 161 170 67 229 200 82 155 141 90 206 225 154 245 12 150 167 109 182 227 135 199 95 225 233 247 223 73 248 254 241 215 56 227 180 19 141 174 187 216 249 199 131 250 31 190 122 132 83 86 38 168 214 90 198 243 158 33 115 241 204 159 95 16 48 49 87 200 252 194 225 19 36 39 119 239 48 190 38 232 32 58 42 78 114 180 180 180 6 67 165 104 15 244 75 74 42 56 90 249 36 210 35 56 56 146 2 131 34 40 36 36 26 241 241 41 148 155 171 34 142 150 52 87 160 90 117 0 197 75 102 161 92 125 62 202 87 46 96 44 228 246 2 156 176 216 130 239 31 62 144 28 254 145 241 221 195 251 248 254 209 3 169 45 116 223 221 239 71 189 169 30 202 87 60 159 199 115 68 91 181 120 38 6 9 240 63 16 20 158 252 235 175 204 63 26 94 126 81 48 49 179 69 30 127 190 29 228 207 184 191 21 170 11 85 200 154 250 111 200 157 49 30 249 179 39 162 112 222 100 168 22 78 129 106 193 20 28 53 53 192 55 119 251 36 199 135 226 73 223 109 212 110 221 36 217 168 22 76 149 230 136 185 185 211 199 67 57 229 227 33 4 182 154 41 220 189 67 224 225 27 193 17 8 167 173 166 187 56 244 133 164 82 149 113 249 172 192 80 41 218 175 246 7 108 94 167 175 202 231 31 201 62 29 11 229 167 31 177 252 24 202 201 207 49 229 15 200 152 240 1 234 221 29 241 237 163 135 248 166 255 174 4 209 62 234 100 35 141 13 216 102 74 115 63 130 114 210 88 100 78 250 240 5 1 67 38 224 234 21 4 55 89 24 92 188 66 97 231 236 11 23 55 95 132 112 105 253 91 33 141 175 212 194 153 76 129 137 31 74 78 72 142 112 191 88 107 21 250 175 118 227 235 59 189 47 225 94 247 37 20 125 177 92 178 145 108 121 158 52 159 145 241 18 1 35 83 133 139 71 32 156 61 67 200 209 35 152 156 60 130 225 225 23 69 158 254 209 228 197 105 53 84 138 246 171 253 1 155 215 233 195 248 101 164 79 31 135 44 126 243 153 207 157 201 24 63 6 170 181 234 184 123 249 34 30 221 188 38 161 255 82 7 238 139 254 141 103 253 187 93 29 40 92 173 134 204 79 126 255 140 52 71 64 164 34 175 245 151 193 61 160 207 4 156 220 252 225 224 22 68 246 174 1 140 64 60 147 67 219 67 117 163 217 140 174 119 112 11 68 156 218 2 228 204 156 128 108 206 97 225 68 201 198 53 184 211 217 134 251 61 151 241 128 113 143 157 63 172 253 5 202 116 53 209 207 36 132 238 65 79 55 110 119 92 64 241 122 13 100 77 27 135 108 158 159 59 123 18 18 230 76 188 252 130 128 161 137 130 255 125 3 59 23 127 216 56 249 253 221 224 165 167 143 3 171 151 34 127 241 28 228 204 249 20 149 102 91 208 223 221 197 142 119 162 175 163 21 229 124 89 203 158 241 9 178 152 96 133 209 38 220 101 114 98 236 222 229 78 148 27 235 33 103 238 100 20 44 153 43 173 17 57 111 146 223 32 129 205 38 59 212 182 91 216 245 233 111 49 255 119 29 131 237 255 41 160 187 121 199 95 183 108 179 38 81 145 140 88 234 111 177 128 161 241 78 210 53 220 254 147 142 225 246 63 233 24 154 254 73 199 192 236 207 207 176 253 207 186 6 166 63 233 48 6 228 72 109 3 189 173 63 37 171 47 162 67 235 212 113 112 237 114 168 212 63 195 49 103 27 220 110 57 139 202 45 58 200 101 82 185 243 166 72 16 4 143 108 211 231 177 38 212 217 154 67 181 242 115 105 206 33 77 117 100 168 205 125 44 155 245 209 239 135 221 74 223 123 239 189 207 89 105 200 48 158 59 239 179 139 169 233 185 36 126 243 76 78 205 166 245 218 226 54 233 77 99 62 248 48 145 199 101 12 95 70 0 35 132 17 198 136 100 68 51 98 24 177 140 184 231 16 109 161 19 99 145 235 62 126 191 236 192 250 149 116 88 123 13 167 11 99 131 6 142 24 235 226 240 198 213 40 229 126 41 167 149 4 49 198 186 35 91 117 36 155 1 251 146 117 43 126 14 153 51 110 235 48 231 159 43 230 179 92 195 208 157 55 255 243 182 236 220 98 220 127 244 3 10 139 203 161 107 96 194 63 235 249 208 152 49 31 8 135 156 24 174 12 15 134 23 195 231 57 33 255 231 164 2 89 14 133 32 42 198 4 105 31 245 177 239 55 86 27 235 81 173 249 22 212 238 48 66 141 153 145 36 71 194 224 24 219 86 25 235 210 182 137 31 189 124 19 125 133 201 199 220 159 198 88 248 206 59 239 108 156 53 107 78 148 129 129 81 238 170 213 107 85 159 124 50 81 249 193 7 99 133 83 130 189 9 195 148 97 198 48 103 88 48 118 50 172 24 226 31 210 2 187 158 99 160 47 198 132 141 32 31 179 252 195 127 109 45 221 162 253 243 25 87 59 52 184 216 160 129 83 105 68 184 216 66 216 28 54 210 254 171 198 216 247 149 60 119 6 227 237 87 252 30 177 251 59 214 254 26 136 197 222 4 255 196 246 179 24 6 227 222 125 91 46 91 56 235 102 157 213 182 159 207 251 121 160 57 216 23 205 33 207 193 109 161 171 217 185 237 127 60 22 206 184 242 135 119 223 246 230 57 75 25 99 126 141 243 255 23 54 239 241 67 68 196 103 140 125 231 45 253 213 31 143 137 179 155 51 165 54 100 233 130 11 65 106 11 90 28 102 79 174 210 248 232 253 200 15 223 125 75 147 109 198 49 254 229 249 11 29 244 237 127 1 28 108 50 57 64 234 204 240 0 0 0 0 73 69 78 68 174 66 96 130]!

repoIcon
	^InternalIcon 
		fromBytes: #[137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 48 0 0 0 48 8 6 0 0 0 87 2 249 135 0 0 0 1 115 82 71 66 0 174 206 28 233 0 0 0 4 103 65 77 65 0 0 177 143 11 252 97 5 0 0 0 9 112 72 89 115 0 0 14 195 0 0 14 195 1 199 111 168 100 0 0 14 205 73 68 65 84 104 67 221 90 121 80 148 89 146 159 153 158 14 103 38 162 195 221 216 136 62 199 86 91 91 91 237 118 108 181 181 213 240 232 22 65 40 16 74 174 226 62 44 40 10 40 138 170 130 130 2 170 10 234 147 251 166 138 163 184 145 91 46 65 69 65 81 80 14 241 194 3 21 143 30 231 216 222 216 152 142 152 136 158 249 99 98 119 35 50 55 223 215 22 83 90 69 43 251 79 27 107 196 47 242 125 249 242 229 203 252 50 95 190 252 10 127 246 179 255 175 255 118 236 56 240 246 238 221 142 203 118 59 254 196 32 27 246 238 117 121 119 81 239 121 223 1 151 237 251 246 187 252 227 171 3 110 240 58 96 159 131 224 191 29 157 133 7 94 201 9 189 94 255 11 103 87 225 37 111 191 48 124 157 224 38 244 157 217 187 119 239 47 95 234 132 251 97 63 55 191 160 72 8 10 143 65 2 163 214 99 107 222 66 50 139 229 219 219 199 70 135 127 136 4 188 69 97 129 63 234 128 183 183 247 27 244 214 111 68 198 36 2 1 159 81 235 177 53 111 33 153 197 242 237 237 99 87 71 64 104 212 67 153 76 182 100 65 39 2 130 37 94 210 184 100 140 75 208 191 150 136 150 107 48 92 162 136 88 200 129 159 31 137 148 223 82 107 115 224 7 228 162 237 216 154 183 144 204 98 249 246 246 89 88 71 148 44 233 27 58 167 182 103 65 42 75 118 204 47 169 131 170 250 110 30 230 134 30 124 113 108 205 91 72 102 177 124 123 251 252 152 142 34 83 19 168 211 50 15 219 68 33 81 163 79 239 238 31 194 161 145 201 215 26 39 207 140 98 154 33 143 179 113 64 42 139 231 170 106 154 176 239 228 48 156 32 244 159 58 135 140 90 143 173 121 11 201 44 150 111 111 159 31 211 209 214 121 2 101 242 196 108 27 7 36 82 25 87 97 110 192 158 19 103 160 231 196 89 232 165 104 48 106 61 182 230 45 36 179 88 190 189 125 126 76 71 115 91 47 74 101 42 91 7 34 36 49 156 169 178 30 187 122 7 177 171 111 16 217 248 104 118 49 150 153 106 127 82 100 229 150 98 41 217 192 108 98 104 106 233 70 105 140 194 190 3 198 138 90 108 239 58 9 29 4 165 90 135 183 239 62 130 223 63 253 22 158 254 225 63 208 154 178 241 139 207 22 153 197 242 95 182 238 222 253 223 131 34 65 139 204 38 134 250 99 199 81 18 35 183 117 224 72 132 148 43 53 213 96 107 199 9 104 237 236 7 69 162 14 103 239 63 129 71 143 255 8 143 159 252 9 173 41 27 191 248 108 145 89 44 255 101 235 230 30 253 1 228 170 52 100 54 49 212 54 118 160 68 186 128 3 197 101 102 108 110 239 195 154 250 54 76 211 166 83 234 152 113 238 225 211 151 226 193 220 83 22 45 188 122 253 30 142 79 205 224 196 212 77 188 125 231 225 75 215 189 170 238 56 101 42 111 23 67 53 217 38 150 200 108 35 16 118 68 202 21 149 86 97 99 115 55 28 205 46 132 238 30 58 237 241 137 112 143 162 112 255 193 55 120 239 222 63 41 27 51 220 186 61 135 231 71 167 97 112 248 50 140 92 156 194 203 19 215 224 210 101 122 62 115 1 235 27 219 161 162 170 1 6 168 154 205 222 123 204 203 91 244 88 143 237 241 172 231 217 90 89 188 134 183 139 161 170 166 101 33 7 36 92 65 113 5 178 28 75 211 103 98 107 107 7 134 134 71 226 221 217 71 54 152 37 222 169 193 11 44 221 112 108 108 18 103 102 102 113 110 238 27 188 115 251 1 222 188 121 7 31 60 120 66 14 63 194 107 87 103 176 163 179 15 141 21 117 56 125 245 182 93 93 22 253 211 215 238 224 212 213 187 120 254 194 36 246 15 12 225 157 187 15 121 249 59 20 217 24 106 111 152 93 12 229 230 38 12 143 136 177 141 64 72 152 132 203 43 52 81 250 180 67 170 150 3 230 64 72 120 4 204 220 126 0 183 238 204 225 60 189 117 31 216 219 173 107 104 133 11 23 199 177 171 187 31 100 50 5 236 251 202 1 55 111 254 2 24 190 248 226 75 244 242 18 65 78 110 33 140 93 154 194 83 167 135 161 168 180 18 198 39 174 243 122 94 212 57 52 60 10 61 125 167 97 112 112 24 251 251 79 195 240 185 81 232 236 26 192 153 91 15 224 38 237 39 149 169 121 187 24 140 21 13 24 46 182 235 64 4 151 83 96 196 170 218 86 72 78 209 131 201 84 137 1 65 97 112 227 198 44 220 156 185 135 22 122 172 185 19 138 138 203 161 247 196 32 196 202 20 184 109 219 14 136 143 87 65 127 255 73 202 251 59 48 55 247 16 38 38 167 208 104 44 7 103 23 55 216 191 223 9 205 213 13 208 113 188 15 10 138 202 241 202 244 173 231 116 206 204 220 167 8 213 64 122 70 38 180 182 119 227 224 217 17 114 188 8 242 139 140 56 124 110 12 174 211 254 81 212 25 51 187 24 74 76 117 24 42 150 218 70 32 40 36 130 203 206 43 195 74 202 49 77 170 1 219 218 88 4 34 241 218 245 187 243 24 187 52 77 115 233 88 215 216 138 222 62 254 120 240 160 0 47 95 30 199 239 190 251 14 71 199 46 97 109 93 3 86 153 107 240 120 87 55 62 126 252 4 191 253 246 91 212 235 13 184 117 235 118 204 206 43 102 134 98 117 237 177 231 116 50 253 241 170 100 84 39 107 233 12 93 167 34 112 3 143 247 156 68 170 138 216 214 209 75 133 225 46 70 70 171 176 162 186 153 71 81 89 13 165 182 93 7 142 112 153 57 37 104 172 108 132 36 141 158 79 161 224 80 49 92 185 50 3 211 211 183 144 209 210 178 42 186 220 10 33 92 44 165 55 235 8 179 179 179 56 49 49 9 82 169 12 156 157 221 208 201 73 0 158 158 190 224 234 230 129 110 110 66 40 41 49 194 159 255 252 239 104 48 28 133 173 91 191 132 156 130 82 76 213 25 96 116 108 106 94 39 59 27 241 202 100 144 198 42 160 179 123 0 219 143 159 0 115 77 19 136 2 66 176 185 181 11 166 104 223 8 169 18 203 200 46 134 130 18 51 6 135 75 108 35 16 16 116 132 227 178 139 176 196 84 15 106 139 3 97 98 152 156 188 1 83 84 22 39 38 174 67 130 58 149 14 248 81 216 248 187 205 208 116 172 5 78 80 218 48 67 133 66 31 48 100 22 226 240 200 20 12 158 29 133 172 156 98 20 30 22 129 135 135 23 168 84 106 156 156 188 2 2 193 33 16 122 250 146 3 28 52 52 182 253 160 115 242 58 79 75 77 213 16 33 137 133 194 146 114 204 45 40 165 51 152 65 181 95 131 67 67 163 236 220 128 88 18 79 118 213 177 244 129 220 162 74 12 12 181 235 64 24 151 65 70 20 27 107 81 147 198 161 74 149 136 97 225 17 56 62 113 13 199 199 175 225 224 153 17 140 166 156 23 249 7 163 179 179 43 182 180 118 34 25 136 59 118 236 193 163 89 5 20 161 155 124 69 26 37 140 79 92 197 51 67 23 209 47 32 12 247 236 249 26 51 12 89 168 79 231 112 195 167 27 49 145 82 37 59 183 152 215 105 193 200 133 113 84 37 164 96 94 161 17 179 114 75 48 49 73 139 141 77 237 252 252 165 241 171 24 30 41 167 212 169 229 145 157 95 142 129 193 17 182 17 160 205 184 116 46 31 243 139 205 144 91 88 9 30 66 17 118 116 244 193 232 232 21 24 27 155 198 182 246 30 122 19 177 184 103 239 126 8 8 12 133 168 104 57 236 219 231 128 190 126 193 84 149 218 160 153 28 234 233 27 160 106 50 0 93 116 135 212 55 182 130 169 178 14 118 236 220 131 174 20 37 29 69 110 237 218 245 116 174 36 160 78 214 81 117 154 70 139 110 70 185 163 121 144 157 103 196 140 204 34 106 29 82 224 236 217 139 252 252 197 209 41 8 19 199 241 118 49 100 230 26 209 63 88 108 223 1 157 33 15 115 200 248 156 130 10 8 139 136 195 179 148 14 35 23 38 224 226 197 73 108 106 234 224 29 216 188 101 27 136 200 104 167 131 174 240 209 170 53 24 43 79 128 108 170 26 101 166 42 44 53 86 2 3 27 23 151 150 131 222 144 3 95 59 28 196 245 235 55 242 41 178 113 227 231 232 237 27 0 10 85 50 175 211 162 155 209 156 220 98 200 162 34 98 200 42 166 121 13 149 210 75 252 252 249 145 113 8 57 18 139 204 38 6 67 118 41 250 7 218 113 192 55 32 132 75 75 207 225 67 196 145 16 29 84 44 51 154 241 252 249 203 60 142 29 235 196 35 145 49 248 249 230 47 208 69 224 142 59 118 238 198 101 203 86 32 29 62 234 207 85 228 136 45 228 10 53 238 251 218 17 87 173 94 139 135 61 69 184 110 221 167 232 45 10 68 121 188 26 201 176 121 221 76 191 209 84 141 185 249 38 50 180 156 175 116 231 200 1 198 103 142 4 135 197 96 22 217 197 144 126 180 8 69 129 225 182 17 240 245 11 225 82 116 89 200 229 148 65 114 42 7 53 181 141 40 83 36 1 59 72 67 67 99 216 213 53 0 20 126 220 185 107 47 108 219 190 19 182 108 217 14 159 172 219 192 167 132 92 153 68 215 125 34 223 122 60 3 63 86 36 104 96 199 174 189 184 126 195 103 176 223 225 32 44 91 182 28 233 194 4 37 241 135 135 199 248 8 51 221 140 214 213 181 0 235 4 10 75 204 192 101 230 205 243 207 156 185 8 129 161 82 246 82 129 65 107 40 64 31 255 80 91 7 188 253 130 56 141 54 147 114 176 152 74 154 10 140 198 10 202 239 64 186 29 47 0 41 193 211 167 71 64 28 25 139 238 84 113 214 172 89 71 185 189 155 55 104 247 94 7 208 103 100 3 107 63 88 133 98 208 166 103 162 46 61 19 84 106 45 188 247 254 111 41 133 62 131 237 95 238 130 229 203 87 82 33 80 129 94 159 201 235 28 28 28 153 167 45 173 221 80 98 172 198 178 242 122 40 44 54 205 243 79 157 58 15 1 33 81 152 78 118 49 164 166 231 45 224 128 111 16 151 148 202 161 158 66 20 21 163 164 155 180 2 125 252 2 169 13 56 63 143 148 212 12 234 75 18 41 117 150 35 157 1 220 180 105 11 190 243 206 251 148 70 74 172 172 110 196 18 186 39 88 41 100 223 21 165 229 53 184 117 219 14 252 240 195 149 232 112 192 25 217 1 118 112 116 193 48 113 52 221 204 141 207 233 101 123 28 167 214 193 68 61 147 185 182 5 203 105 189 101 223 129 147 195 232 23 36 65 29 87 196 67 163 205 65 47 81 176 109 4 60 125 3 184 68 141 1 211 210 243 33 34 74 14 121 121 133 232 233 237 71 45 194 89 24 160 230 138 209 198 198 118 102 0 120 120 138 128 242 25 130 66 196 184 133 46 40 114 8 14 210 185 160 55 79 7 173 140 93 74 184 246 147 13 176 106 245 26 96 185 127 208 217 141 151 97 181 157 29 230 222 222 211 243 58 45 186 187 187 79 130 137 110 234 122 42 22 228 192 252 124 111 239 32 136 2 35 48 85 159 7 12 234 212 44 244 244 177 231 128 119 0 151 144 156 142 41 250 92 222 129 162 162 82 190 98 48 5 125 125 103 208 66 83 82 211 65 149 164 133 61 251 28 96 11 181 8 241 148 255 142 7 5 176 250 227 181 248 246 59 239 193 135 31 174 128 21 43 62 194 223 109 218 76 41 23 3 172 229 120 239 189 15 32 134 170 21 171 98 70 99 181 141 78 166 187 167 231 20 85 48 51 107 31 232 198 55 207 239 217 69 142 249 248 139 81 163 203 1 134 4 205 81 20 250 4 218 70 64 232 237 199 41 213 122 76 74 203 166 126 59 142 79 33 114 0 187 123 78 61 135 14 106 161 227 169 186 232 12 217 232 65 55 235 170 85 31 99 104 152 24 21 170 36 250 82 138 227 123 24 86 149 164 209 50 58 240 187 169 2 173 65 117 138 158 29 106 204 200 200 198 238 238 231 245 89 235 231 184 28 76 73 209 97 13 245 75 22 126 231 241 1 250 145 57 28 217 155 103 80 36 101 160 208 203 158 3 158 126 92 60 125 123 38 166 28 133 240 8 25 127 136 189 125 253 161 147 62 227 142 147 18 107 218 220 220 5 106 138 66 138 142 163 186 157 15 46 174 238 176 242 163 213 184 124 197 74 88 185 242 35 248 224 131 223 226 166 207 183 82 36 101 144 79 103 34 54 78 5 6 186 19 152 243 76 143 61 157 140 199 230 91 219 122 160 163 243 196 252 158 236 217 211 55 12 19 52 28 189 125 14 228 9 233 232 238 233 111 27 1 119 114 32 142 190 61 149 73 6 10 181 28 180 186 116 244 242 241 131 182 246 94 104 239 232 163 238 244 159 148 141 91 90 186 33 63 191 20 85 137 41 148 155 28 245 41 102 250 216 168 7 147 185 14 202 171 27 48 147 46 55 234 157 64 73 157 166 201 84 3 204 16 139 30 107 93 246 120 214 243 199 154 143 195 97 159 16 84 168 51 128 65 166 212 46 224 128 208 151 147 41 82 80 158 168 7 105 156 134 218 4 71 212 105 13 188 161 173 173 61 104 77 217 216 242 220 216 216 65 209 170 6 150 30 106 117 26 36 36 166 66 82 146 14 51 51 11 160 178 178 30 40 90 252 218 23 215 219 211 105 225 89 203 54 144 126 15 175 96 246 99 51 48 196 196 167 162 155 80 100 27 1 250 3 2 23 67 191 254 202 148 58 140 85 104 81 232 29 130 102 250 124 59 70 159 113 63 37 234 234 90 233 141 7 241 54 49 68 197 105 208 205 221 158 3 238 222 156 52 46 9 163 227 83 41 2 41 192 22 153 76 181 80 95 223 70 229 179 3 173 41 27 191 248 108 145 89 44 255 101 235 232 37 130 155 48 0 153 77 12 145 49 73 40 112 247 177 141 128 128 28 144 196 38 98 148 76 131 145 177 201 24 26 17 143 145 81 241 152 68 165 245 167 132 36 90 137 33 98 57 111 19 131 88 154 136 206 110 246 28 112 243 228 34 163 19 48 34 38 9 142 68 171 65 28 173 198 104 133 22 98 148 58 136 165 180 178 166 108 252 226 179 69 102 177 252 87 89 199 108 97 54 49 132 73 84 228 128 151 109 4 156 201 1 113 148 18 195 163 18 153 16 33 1 127 160 214 99 107 222 66 50 139 229 219 219 103 97 29 33 98 5 58 9 60 237 56 32 16 114 244 231 27 12 141 84 98 48 9 189 174 8 12 151 163 163 139 48 203 230 231 117 87 161 207 102 47 81 232 156 243 33 223 191 56 186 120 253 149 193 201 213 231 191 14 29 14 4 86 145 220 136 58 31 18 161 192 195 31 156 4 94 127 119 20 120 125 239 40 240 252 222 209 197 251 111 63 192 235 111 78 46 158 127 119 36 88 168 253 177 23 47 59 191 142 215 227 245 61 211 41 112 247 67 42 153 172 108 2 27 187 184 251 129 203 33 209 255 88 236 113 116 245 249 139 139 187 255 35 146 223 182 224 31 250 222 124 243 205 207 104 82 64 240 88 251 201 167 87 10 139 43 129 253 230 153 95 88 14 95 57 176 110 50 14 222 90 250 47 57 52 47 35 196 19 84 132 36 130 134 144 70 208 17 210 9 25 4 195 51 176 49 227 177 57 38 195 100 213 207 214 50 29 178 37 191 254 117 150 143 40 4 207 210 207 148 231 70 38 65 228 31 198 90 6 250 162 19 204 50 91 152 77 100 219 166 5 13 183 154 88 71 227 93 4 167 79 214 125 54 94 94 217 128 79 158 254 39 214 54 180 163 147 139 144 126 214 147 195 91 111 45 101 6 137 9 18 66 52 33 150 32 39 48 99 148 207 12 75 32 106 13 230 40 155 99 50 113 207 214 176 181 76 135 248 87 191 250 141 214 207 63 12 166 166 239 224 205 219 143 232 235 79 70 95 111 161 184 111 191 243 45 154 119 124 102 211 122 162 63 127 153 19 255 70 2 43 8 27 222 120 227 141 253 171 87 175 209 186 184 184 85 126 185 115 119 253 187 239 190 111 92 186 244 95 153 81 238 4 33 193 147 224 77 240 37 136 8 254 132 0 2 251 131 52 67 208 51 88 158 217 28 147 97 178 108 13 91 203 116 48 93 238 75 151 46 85 236 218 181 187 140 246 171 95 245 241 154 202 183 223 126 87 191 100 201 18 246 95 12 152 225 204 38 102 219 75 29 176 118 144 9 191 10 126 65 114 255 23 188 138 238 69 25 252 178 232 188 118 243 255 11 131 165 176 93 46 29 173 63 0 0 0 0 73 69 78 68 174 66 96 130]!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 26607617 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 39 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 0 0 0 410 8 ##(Smalltalk.CardContainer)  98 16 0 416 98 2 8 1409286144 131073 560 0 482 8 4278190080 0 7 0 0 0 560 655878 ##(Smalltalk.CardLayout)  202 208 98 2 721414 ##(Smalltalk.Association)  8 'Local Repository' 410 8 ##(Smalltalk.ContainerView)  98 15 0 560 98 2 8 1140850688 131073 784 0 0 0 7 0 0 0 784 530 1 1 0 0 410 800 98 15 0 784 98 2 8 1140850688 131073 880 0 917766 ##(Smalltalk.PluggableColor)  787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  5 1 8 ##(Smalltalk.RGB)  8 'doIt' 8 'PluggableColor with: [SmalltalkSystem toolBackgroundColor]' 8 #[29 33 112 30 160 106 179 105] 944 8 ##(Smalltalk.SmalltalkSystem)  8 #toolBackgroundColor 8 #with: 992 9 1 0 0 7 0 0 0 880 0 234 256 98 2 410 8 ##(Smalltalk.ImageView)  98 21 0 880 98 2 8 1140850944 1 1184 721990 2 ##(Smalltalk.ValueHolder)  0 32 1310726 ##(Smalltalk.EqualitySearchPolicy)  0 0 0 7 0 0 0 1184 0 0 852486 ##(Smalltalk.NullConverter)  0 0 0 0 8 #scaleToFit 0 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  27 71 1506 129 129 1184 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 0 0 0 35 0 0 0 77 0 0 0 99 0 0 0] 98 0 1506 193 193 0 27 8 'localRepositoryStatus' 0 1378 202 208 98 2 1442 1472 98 2 1506 749 1 1506 181 379 880 1442 8 #text: 98 1 8 'Status' 880 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 118 1 0 0 0 0 0 0 208 1 0 0 189 0 0 0] 98 1 1184 1616 0 27 0 410 800 98 15 0 784 98 2 8 1140850688 131073 1872 0 0 0 7 0 0 0 1872 0 234 256 98 4 410 8 ##(Smalltalk.StaticText)  98 16 0 1872 98 2 8 1140850944 262145 1968 0 0 0 7 0 0 0 1968 0 8 4294904313 1330 0 0 0 1378 202 208 98 2 1442 1472 98 2 1506 249 63 1506 421 41 1968 1442 1776 98 1 8 'Repository
' 1968 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 124 0 0 0 31 0 0 0 78 1 0 0 51 0 0 0] 98 0 1616 0 27 8 'localRepositoryPath' 410 1984 98 16 0 1872 98 2 8 1140916480 262145 2304 1266 0 32 1312 0 482 8 4278190080 0 7 0 0 0 2304 0 8 4294904313 1330 0 0 0 1378 202 208 98 1 1442 1472 98 2 1506 249 169 1506 421 41 2304 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 124 0 0 0 84 0 0 0 78 1 0 0 104 0 0 0] 98 0 1616 0 27 8 'localRepositoryDeveloper' 0 1378 202 208 98 1 1442 1472 98 2 1506 1 1 1506 749 379 1872 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 118 1 0 0 189 0 0 0] 98 6 410 1984 98 16 0 1872 98 2 8 1140850944 1 2784 0 0 0 7 0 0 0 2784 0 8 4294904313 1330 0 0 0 1378 202 208 98 2 1442 1472 98 2 1506 41 63 1506 201 51 2784 1442 1776 98 1 8 'Repository Path:' 2784 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 31 0 0 0 120 0 0 0 56 0 0 0] 98 0 1616 0 27 1968 410 8 ##(Smalltalk.ToolButton)  98 14 0 1872 98 2 8 1140850688 131073 3088 0 0 0 7 0 0 0 3088 0 410 8 ##(Smalltalk.Toolbar)  98 25 0 3088 98 2 8 1140853580 131137 3168 0 0 0 3 0 0 0 3168 0 8 4294905469 0 234 256 98 2 38025 1115910 ##(Smalltalk.ToolbarIconButton)  38025 0 3168 1 1180998 4 ##(Smalltalk.CommandDescription)  8 #toggleConnect 8 'Connect' 1 1 786694 ##(Smalltalk.InternalIcon)  852742 ##(Smalltalk.GdiplusBitmap)  0 16 2097670 ##(Smalltalk.GdiplusImageFromBytesInitializer)  0 8 #[137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 48 0 0 0 48 8 6 0 0 0 87 2 249 135 0 0 0 1 115 82 71 66 0 174 206 28 233 0 0 0 4 103 65 77 65 0 0 177 143 11 252 97 5 0 0 0 9 112 72 89 115 0 0 14 195 0 0 14 195 1 199 111 168 100 0 0 7 48 73 68 65 84 104 67 237 153 123 76 147 103 20 198 167 67 119 113 110 89 150 5 55 201 150 37 243 15 93 182 37 222 69 16 221 80 1 29 211 57 220 69 153 243 50 47 219 220 98 116 19 227 240 54 141 83 163 67 5 229 170 40 114 171 208 10 8 222 80 81 17 16 4 202 165 148 123 91 74 41 55 65 157 215 144 120 118 158 23 170 224 90 63 253 67 248 150 216 228 73 155 190 167 239 249 61 231 188 223 73 251 245 185 231 158 61 158 85 224 89 5 172 86 64 81 92 220 55 241 88 234 226 120 85 242 185 152 184 196 91 177 113 137 212 157 66 206 120 101 242 185 164 148 147 75 82 82 82 94 120 162 54 157 58 117 225 29 69 92 162 58 237 66 22 213 153 27 169 173 173 141 238 221 187 215 173 66 78 228 6 67 180 226 136 58 33 225 196 123 143 101 2 110 1 175 46 44 165 219 119 219 232 214 157 54 186 118 227 46 93 189 126 167 91 133 156 200 13 6 176 68 198 42 11 214 250 251 191 34 105 34 94 149 178 52 245 108 6 181 92 187 45 84 223 124 163 71 101 225 0 211 162 37 75 87 120 121 121 61 255 72 19 138 184 164 204 178 202 26 106 108 185 41 192 205 61 44 48 128 5 76 126 187 246 230 56 56 56 188 244 72 3 81 49 202 155 230 134 86 50 55 253 35 47 49 83 100 140 234 22 195 191 206 234 109 211 68 180 66 69 141 205 87 169 174 241 186 172 4 38 176 49 248 0 23 23 23 59 171 6 136 168 87 84 172 138 26 56 216 212 112 77 86 2 19 216 24 124 224 176 97 195 250 216 52 16 25 163 164 134 166 86 50 213 95 165 90 153 8 44 96 2 27 131 59 72 24 136 167 122 14 174 53 183 146 81 38 2 11 152 34 99 226 165 13 28 138 102 3 141 45 100 172 107 161 26 153 8 44 96 2 27 58 48 100 200 144 190 54 143 80 68 84 28 213 55 48 188 233 10 25 100 34 176 128 9 108 143 97 224 48 153 27 0 223 76 250 90 121 8 44 96 138 136 58 44 109 224 96 36 27 168 7 120 19 233 140 242 16 88 192 4 54 201 14 28 56 164 160 58 14 214 25 27 169 186 70 30 2 11 152 192 38 109 32 34 150 71 104 51 195 55 80 149 65 30 2 11 152 14 48 155 164 129 240 136 24 50 153 155 24 190 158 42 245 242 16 88 192 4 54 73 3 251 15 182 27 168 212 155 169 82 39 19 49 11 152 192 38 105 96 223 129 104 170 173 107 164 10 134 175 208 213 201 68 102 193 4 54 105 3 225 81 237 6 170 235 168 92 38 2 139 48 192 108 146 6 194 194 35 201 104 106 160 242 42 19 149 85 213 202 66 96 1 19 216 36 13 132 238 63 68 53 181 245 252 3 194 72 218 10 121 8 44 96 2 155 164 129 144 125 237 6 74 43 106 72 91 46 15 129 5 76 96 147 54 16 22 65 6 14 6 124 73 185 225 190 138 180 85 148 87 168 165 156 188 34 202 206 45 164 188 2 45 225 189 206 49 150 215 133 37 149 188 94 66 57 28 7 229 243 143 242 226 210 106 235 177 154 10 202 85 107 196 158 216 91 93 84 70 154 82 93 151 88 176 128 41 132 217 36 13 4 135 29 36 131 209 44 54 208 148 233 133 46 171 75 40 32 48 148 22 46 254 145 220 220 220 105 194 132 79 196 235 224 208 112 177 102 137 195 115 102 182 154 118 236 12 160 185 243 127 160 137 19 39 209 164 201 147 105 233 47 203 248 107 64 44 169 139 203 59 197 234 40 45 253 18 109 222 178 157 102 123 127 39 246 156 50 245 51 90 254 155 15 41 226 19 185 56 213 247 99 193 2 38 176 73 26 8 10 61 208 97 160 29 30 213 220 195 240 216 220 201 201 153 70 141 26 69 35 71 142 36 103 231 113 244 165 215 87 98 205 2 118 57 95 67 91 182 238 32 119 143 41 28 235 36 226 16 239 226 50 158 102 205 246 22 38 208 53 236 155 145 157 79 127 248 174 163 201 147 221 104 236 216 177 237 177 163 71 11 35 115 231 45 32 101 66 74 39 3 122 193 4 54 73 3 129 33 225 100 168 225 14 112 146 226 82 61 101 231 21 211 60 174 230 136 17 35 136 127 9 221 215 240 225 195 57 177 147 88 75 207 204 21 201 78 158 62 79 223 124 59 91 192 96 221 18 143 215 227 92 92 232 167 159 127 229 227 162 229 88 3 169 24 112 250 244 25 98 223 135 99 97 98 249 10 31 206 175 19 12 96 1 19 216 164 13 4 195 64 29 39 193 135 117 148 158 145 77 99 198 140 161 161 67 135 118 49 0 56 36 198 218 241 83 103 132 1 69 156 138 70 115 21 59 27 237 108 194 209 209 145 178 114 242 249 120 234 41 40 36 76 116 199 86 44 138 83 204 221 2 3 88 192 20 200 108 146 6 246 6 239 239 98 224 2 27 64 34 91 6 176 118 252 100 187 129 216 195 74 81 125 91 80 48 151 197 71 7 6 2 131 67 109 198 226 243 40 204 195 6 192 38 105 96 79 208 62 210 163 3 236 188 72 171 227 138 169 105 230 204 175 109 86 31 107 184 127 137 86 39 31 75 165 207 167 77 23 157 121 248 88 160 162 179 189 231 240 164 41 22 177 49 10 37 185 185 123 88 141 197 245 53 127 193 66 113 33 131 1 44 96 2 155 180 129 192 118 3 24 123 216 32 143 71 224 186 13 155 196 133 246 48 148 171 235 68 177 150 147 167 17 177 23 179 242 120 138 172 252 79 44 186 226 238 225 65 219 253 252 121 76 150 115 101 171 233 116 90 6 45 92 180 132 43 237 216 101 95 196 122 122 78 227 145 121 80 92 240 216 23 44 194 0 179 73 26 8 8 12 123 96 160 132 77 176 206 164 101 146 207 42 95 242 226 106 227 2 115 114 118 22 93 89 183 126 19 175 101 136 24 168 80 83 201 93 56 205 23 224 74 250 98 134 151 152 62 227 199 243 4 154 229 77 127 241 184 132 65 75 108 65 81 5 29 230 113 137 17 11 96 236 249 169 171 43 205 249 126 30 249 237 220 211 94 148 142 125 45 6 192 38 109 96 111 40 233 13 38 225 188 176 164 170 67 149 60 246 212 124 214 207 146 242 72 18 39 78 16 175 49 243 49 102 31 196 85 81 1 155 72 207 202 165 148 19 167 41 94 149 200 74 162 147 169 231 232 82 110 81 151 56 124 6 227 247 252 197 28 58 122 236 148 216 83 149 144 76 169 103 211 41 135 199 113 231 61 193 2 166 0 102 147 52 224 15 3 220 174 174 6 44 70 122 230 89 24 96 38 176 73 222 216 218 29 16 114 203 96 52 137 209 85 168 97 96 25 72 140 81 102 218 185 59 232 54 12 176 172 223 90 196 205 162 237 126 187 179 74 180 101 84 165 171 21 240 56 18 61 41 48 128 5 76 171 125 55 20 48 226 219 44 235 55 119 97 96 219 54 191 101 170 132 163 212 220 124 133 191 82 27 122 20 30 133 3 3 88 192 228 225 225 185 133 17 223 100 217 254 147 195 211 211 179 255 159 155 183 22 165 95 204 164 43 87 90 168 214 196 63 236 117 70 177 81 119 10 57 145 27 12 96 89 179 110 83 101 159 62 125 62 102 248 254 172 94 40 182 213 199 218 181 107 123 15 26 52 104 240 134 141 91 52 74 158 32 90 110 93 83 115 51 181 182 182 118 171 144 83 91 90 70 96 240 93 191 177 202 222 222 126 10 3 15 96 89 191 47 218 217 13 110 95 247 235 215 207 222 205 109 234 106 159 213 107 114 255 222 181 247 206 78 255 32 234 78 249 237 218 115 247 247 85 190 133 174 147 220 182 219 217 217 141 100 190 129 172 151 31 89 253 206 38 58 254 5 65 187 222 98 189 207 250 128 245 17 11 109 124 218 66 158 15 89 131 89 239 178 222 96 189 200 178 253 215 146 141 19 133 15 160 101 112 14 51 175 118 232 53 126 126 154 178 228 193 223 170 0 199 69 107 251 220 219 128 183 246 54 54 233 78 61 1 218 255 52 244 95 129 95 41 143 160 135 143 1 0 0 0 0 73 69 78 68 174 66 96 130] 395334 3 ##(Smalltalk.Bitmap)  0 16 0 0 0 0 3 1506 33 33 1 98 1 3312 234 240 98 2 3520 1 0 1 0 1506 33 33 1506 31 31 0 0 1378 202 208 98 2 1442 1472 98 2 1506 1 1 1506 41 41 3168 1442 8 #updateSizePosted 98 0 3168 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 20 0 0 0 20 0 0 0] 98 0 1616 0 27 1378 202 208 98 3 1442 1472 98 2 1506 679 61 1506 41 41 3088 1442 8 #isEnabled: 98 1 32 3088 1442 1776 98 1 8 'toggleConnect' 3088 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 83 1 0 0 30 0 0 0 103 1 0 0 50 0 0 0] 98 1 3168 1616 0 27 410 1984 98 16 0 1872 98 2 8 1140850944 1 4096 0 0 0 7 0 0 0 4096 0 8 4294904313 1330 0 0 0 1378 202 208 98 2 1442 1472 98 2 1506 41 173 1506 171 43 4096 1442 1776 98 1 8 'User Name:' 4096 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 86 0 0 0 105 0 0 0 107 0 0 0] 98 0 1616 0 27 2304 410 3104 98 14 0 1872 98 2 8 1140850688 131073 4400 0 0 0 7 0 0 0 4400 0 410 3184 98 25 0 4400 98 2 8 1140853580 131137 4464 0 0 0 3 0 0 0 4464 0 8 4294905469 0 234 256 98 2 38027 3298 38027 0 4464 1 3330 8 #chooseDeveloper 8 'Choose Developer' 1 1 3394 3426 0 16 3458 0 3488 3506 0 16 0 0 0 0 3 1506 33 33 1 98 1 4576 234 240 98 2 4688 1 0 1 0 1506 33 33 1506 31 31 0 0 1378 202 208 98 2 1442 1472 98 2 1506 1 1 1506 41 41 4464 1442 3760 3776 4464 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 20 0 0 0 20 0 0 0] 98 0 1616 0 27 1378 202 208 98 3 1442 1472 98 2 1506 679 161 1506 41 41 4400 1442 3968 98 1 32 4400 1442 1776 98 1 8 'chooseDeveloper' 4400 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 83 1 0 0 80 0 0 0 103 1 0 0 100 0 0 0] 98 1 4464 1616 0 27 1616 0 27 234 256 3776 0 1378 202 208 98 2 1442 1472 98 2 1506 9 49 1506 929 379 784 1442 1776 98 1 8 'Local Repository' 784 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 24 0 0 0 212 1 0 0 213 0 0 0] 98 2 1872 880 1616 0 27 738 8 'Remote Repository' 410 800 98 15 0 560 98 2 8 1140850688 131073 5472 0 0 0 5 0 0 0 5472 530 1 1 0 0 410 800 98 15 0 5472 98 2 8 1140850688 131073 5552 0 946 978 0 0 1010 5 1 1040 8 'doIt' 8 'PluggableColor with: [SmalltalkSystem toolBackgroundColor]' 8 #[29 33 112 30 160 106 179 105] 944 1104 1120 1136 5632 9 1 0 0 5 0 0 0 5552 0 234 256 98 2 410 1200 98 21 0 5552 98 2 8 1140850944 1 5744 1266 0 32 1312 0 0 0 5 0 0 0 5744 0 0 1330 0 0 0 0 1360 0 0 0 1378 202 208 98 1 1442 1472 98 2 1506 27 71 1506 129 129 5744 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 0 0 0 35 0 0 0 77 0 0 0 99 0 0 0] 98 0 1616 0 27 8 'remoteRepositoryStatus' 0 1378 202 208 98 2 1442 1472 98 2 1506 749 1 1506 181 379 5552 1442 1776 98 1 8 'Status' 5552 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 118 1 0 0 0 0 0 0 208 1 0 0 189 0 0 0] 98 1 5744 1616 0 27 0 410 800 98 15 0 5472 98 2 8 1140850688 131073 6224 0 0 0 5 0 0 0 6224 0 234 256 98 6 410 8 ##(Smalltalk.TextEdit)  98 16 0 6224 98 2 8 1140916384 262145 6320 0 482 8 4278190080 0 5 0 0 0 6320 0 8 4294904303 1330 0 0 1 1378 202 208 98 5 1442 1472 98 2 1506 247 275 1506 421 41 6320 1442 3968 98 1 32 6320 1442 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 6320 1442 8 #isTextModified: 98 1 32 6320 1442 8 #setMarginWidths: 98 1 98 2 7 7 6320 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 123 0 0 0 137 0 0 0 77 1 0 0 157 0 0 0] 98 0 1616 0 27 8 'remoteRepositoryPassword' 410 1984 98 16 0 6224 98 2 8 1140850944 262145 6864 0 0 0 5 0 0 0 6864 0 8 4294904313 1330 0 0 0 1378 202 208 98 2 1442 1472 98 2 1506 249 63 1506 421 41 6864 1442 1776 98 1 8 '

' 6864 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 124 0 0 0 31 0 0 0 78 1 0 0 51 0 0 0] 98 0 1616 0 27 8 'remoteRepositoryUrl' 410 1984 98 16 0 6224 98 2 8 1140916480 262145 7184 1266 0 32 1312 0 482 2400 0 5 0 0 0 7184 0 8 4294904313 1330 0 0 0 1378 202 208 98 1 1442 1472 98 2 1506 249 169 1506 421 41 7184 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 124 0 0 0 84 0 0 0 78 1 0 0 104 0 0 0] 98 0 1616 0 27 8 'remoteRepositoryUsername' 0 1378 202 208 98 1 1442 1472 98 2 1506 1 1 1506 749 379 6224 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 118 1 0 0 189 0 0 0] 98 8 410 1984 98 16 0 6224 98 2 8 1140850944 1 7648 0 0 0 5 0 0 0 7648 0 8 4294904313 1330 0 0 0 1378 202 208 98 2 1442 1472 98 2 1506 41 63 1506 201 51 7648 1442 1776 98 1 8 'Repository Path:' 7648 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 31 0 0 0 120 0 0 0 56 0 0 0] 98 0 1616 0 27 6864 410 3104 98 14 0 6224 98 2 8 1140850688 131073 7952 0 0 0 5 0 0 0 7952 0 410 3184 98 25 0 7952 98 2 8 1140853580 131137 8016 0 0 0 1 0 0 0 8016 0 8 4294905469 0 234 256 98 2 38029 3298 38029 0 8016 1 3330 3360 3376 1 1 3394 3426 0 16 3458 0 3488 3506 0 16 0 0 0 0 3 1506 33 33 1 98 1 8128 234 240 98 2 8208 1 0 1 0 1506 33 33 1506 31 31 0 0 1378 202 208 98 2 1442 1472 98 2 1506 1 1 1506 41 41 8016 1442 3760 3776 8016 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 20 0 0 0 20 0 0 0] 98 0 1616 0 27 1378 202 208 98 3 1442 1472 98 2 1506 677 59 1506 41 41 7952 1442 3968 98 1 32 7952 1442 1776 98 1 8 'toggleConnect' 7952 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 82 1 0 0 29 0 0 0 102 1 0 0 49 0 0 0] 98 1 8016 1616 0 27 410 1984 98 16 0 6224 98 2 8 1140850944 1 8736 0 0 0 5 0 0 0 8736 0 8 4294904313 1330 0 0 0 1378 202 208 98 2 1442 1472 98 2 1506 41 173 1506 171 43 8736 1442 1776 98 1 8 'User Name:' 8736 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 86 0 0 0 105 0 0 0 107 0 0 0] 98 0 1616 0 27 7184 410 3104 98 14 0 6224 98 2 8 1140850688 131073 9040 0 0 0 5 0 0 0 9040 0 410 3184 98 25 0 9040 98 2 8 1140853580 131137 9104 0 0 0 1 0 0 0 9104 0 8 4294905469 0 234 256 98 2 38031 3298 38031 0 9104 1 3330 8 #chooseRemoteLogin 8 'Choose Remote Login' 1 1 3394 3426 0 16 3458 0 3488 3506 0 16 0 0 0 0 3 1506 33 33 1 98 1 9216 234 240 98 2 9328 1 0 1 0 1506 33 33 1506 31 31 0 0 1378 202 208 98 2 1442 1472 98 2 1506 1 1 1506 41 41 9104 1442 3760 3776 9104 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 20 0 0 0 20 0 0 0] 98 0 1616 0 27 1378 202 208 98 3 1442 1472 98 2 1506 677 161 1506 41 41 9040 1442 3968 98 1 32 9040 1442 1776 98 1 8 'chooseRemoteLogin' 9040 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 82 1 0 0 80 0 0 0 102 1 0 0 100 0 0 0] 98 1 9104 1616 0 27 410 1984 98 16 0 6224 98 2 8 1140850944 1 9856 0 0 0 5 0 0 0 9856 0 8 4294904313 1330 0 0 0 1378 202 208 98 2 1442 1472 98 2 1506 41 277 1506 171 43 9856 1442 1776 98 1 8 'Password:' 9856 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 138 0 0 0 105 0 0 0 159 0 0 0] 98 0 1616 0 27 6320 1616 0 27 234 256 3776 0 1378 202 208 98 2 1442 1472 98 2 1506 9 49 1506 929 379 5472 1442 1776 98 1 8 'Remote Repository' 5472 1554 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 24 0 0 0 212 1 0 0 213 0 0 0] 98 2 6224 5552 1616 0 27 784 234 256 3776 0 410 8 ##(Smalltalk.TabViewXP)  98 28 0 560 98 2 8 1140916736 1 10400 590662 2 ##(Smalltalk.ListModel)  202 208 98 2 768 5456 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  0 0 1 0 0 0 10400 0 8 4294904129 978 0 0 918822 ##(Smalltalk.CompiledMethod)  2 3 8 ##(Smalltalk.ListControlView)  8 #defaultGetTextBlock 575230339 8 #[30 105 226 0 106] 8 #displayString 10592 7 257 0 978 0 0 10610 2 3 8 ##(Smalltalk.IconicListAbstract)  8 #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] 8 #iconImageIndex 10704 7 257 0 1049926 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 8 #noIcons 0 0 0 0 0 1378 202 208 98 3 1442 1472 98 2 1506 1 1 1506 945 435 10400 1442 8 #basicSelectionsByIndex: 98 1 98 1 3 10400 1442 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 10400 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 216 1 0 0 217 0 0 0] 98 0 1616 0 27 1378 202 208 98 1 1442 1472 98 2 1506 1 1 1506 945 435 560 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 216 1 0 0 217 0 0 0] 98 3 784 5472 10400 1616 0 27 234 256 3776 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 4 265030 4 ##(Smalltalk.Menu)  0 16 98 8 984134 2 ##(Smalltalk.CommandMenuItem)  1 3330 8 #newRepository 8 'New Repository...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 11394 1 3330 8 #connectTo 8 'Connect to...' 1 1 0 0 0 11346 0 16 98 0 8 'Connect to Recent' 8 #connectToRecent 134217729 0 0 41789 0 0 11474 4097 11394 1 3330 8 #disconnect 8 'Disconnect' 1 1 0 0 0 11474 4097 11394 1 3330 8 #exit 8 'E&xit' 1 1 0 0 0 8 '&Local' 0 134217729 0 0 41795 0 0 11346 0 16 98 3 11394 1 3330 8 #compact 8 'Compact...' 1 1 0 0 0 11474 4097 11394 1 3330 8 #backup 8 'Backup...' 1 1 0 0 0 8 'Housekeeping' 0 134217729 0 0 41801 0 0 11346 0 16 98 4 11394 1 3330 8 #versionSnapshotAllPackages 8 'Version All Packages...' 1 1 0 0 0 11474 4097 11394 1 3330 8 #versionSnapshotDolphinBasePackages 8 'Version Only Dolphin Base Packages...' 1 1 0 0 0 11394 1 3330 8 #versionSnapshotNonDolphinPackages 8 'Version Only Non-Dolphin Base Packages...' 1 1 0 0 0 8 '&Snapshot' 0 134217729 0 0 41809 0 0 11346 0 16 98 4 11394 1 3330 8 #remoteConnectTo 8 'Connect to Server...' 1 1 0 0 0 11346 0 16 98 0 8 'Connect to Recent Server' 8 #remoteConnectToRecent 134217729 0 0 41813 0 0 11474 4097 11394 1 3330 8 #remoteDisconnect 8 'Disconnect from Server' 1 1 0 0 0 8 '&Remote' 0 134217729 0 0 41817 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1378 202 208 98 3 1442 1472 98 2 1506 3359 21 1506 957 531 416 1442 1776 98 1 8 'Source Tracking Administrator' 416 1442 8 #updateMenuBar 3776 416 1554 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 109 8 0 0 19 1 0 0] 98 1 560 1616 0 27 )!

uninitialize
	"Private - Un-register the system tools folder icon for the receiver to allow clean
	removal of this class from the system.
		self uninitialize
	Note: As in all Development classes, this method must be stripped to prevent
	it generating an error when this class is removed."

	(Smalltalk developmentSystem)
		removeSystemFolderIcon: self toolsFolderIcon;
		unregisterTool: self! !
!StsAdminShell class categoriesFor: #displayOn:!public! !
!StsAdminShell class categoriesFor: #icon!constants!public! !
!StsAdminShell class categoriesFor: #initialize!initializing!private! !
!StsAdminShell class categoriesFor: #repoConnectedIcon!icons!public! !
!StsAdminShell class categoriesFor: #repoDisconnectedIcon!icons!public! !
!StsAdminShell class categoriesFor: #repoIcon!icons!public! !
!StsAdminShell class categoriesFor: #resource_Default_view!public!resources-views! !
!StsAdminShell class categoriesFor: #uninitialize!initializing!must strip!private! !

