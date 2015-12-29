"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #ItcInstaller
	instanceVariableNames: 'files directories baseDirectory noFileCompression'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ItcInstaller guid: (GUID fromString: '{C0F5A326-05AD-4545-A9D2-F56F31D5C2A9}')!
ItcInstaller comment: ''!
!ItcInstaller categoriesForClass!Unclassified! !
!ItcInstaller methodsFor!

addAllInstallerFiles
	^self subclassResponsibility!

addAllInstallerFilesForFirstInstallation
	^self addAllInstallerFiles!

addDirectory: aString 
	self directories add: (Array with: #createInApplicationDirectory with: aString)!

addFile: fileName 
	self addFile: fileName from: fileName!

addFile: destinationFilename from: sourceFilename 
	self 
		addFile: destinationFilename
		from: sourceFilename
		flags: nil!

addFile: destinationFilename from: sourceFilename flags: flags 
	self files add: (Array 
				with: flags
				with: sourceFilename
				with: destinationFilename)!

applicationVersion
	^self subclassResponsibility!

baseDirectory
	^baseDirectory isNil ifTrue: [ItcSystemManager startUpDirectoryPath] ifFalse: [baseDirectory]!

createInstallerZipFile
	^ItcSystemManager startExternalProgramScript: self generateInstallerZipFileCreationScript!

directories
	directories isNil ifTrue: [directories := OrderedCollection new].
	^directories!

downloadAndSaveImagesFrom: aString 
	"Use this method to download all image files and other web server external resources from an existing server installation directly to development environment.

	Example:
	
		ObracuniRacunovodskiServisInstaller new
			downloadAndSaveImagesFrom: 'http://www.e-racuni.com/racuni'

	"

	| pictureFiles httpClient appDirString urlPrefix |
	urlPrefix := (#HttpClient itcAsClass decomposeUrl: aString) last.
	appDirString := self defaultApplication applicationRootDirectory.
	pictureFiles := OrderedCollection new.
	self files isEmpty ifTrue: [self addAllInstallerFiles].
	self files do: 
			[:each | 
			| destination source |
			(((each at: 3) beginsWith: self defaultApplication applicationPath , '\http-root\') and: 
					[#('GIF' 'JPG' 'ICO' 'PNG' 'CSS' 'JS') 
						includes: (ItcSystemManager fileExtensionFromPath: (each at: 2))]) 
				ifTrue: 
					[destination := appDirString 
								, ((each at: 3) copyFrom: self defaultApplication applicationPath size + 2).
					source := urlPrefix 
								, (((each at: 3) copyFrom: (self defaultApplication applicationPath , '\http-root\') size) 
										replaceAll: $\
										with: $/).
					pictureFiles add: (Array with: destination with: source)]].
	httpClient := #HttpClient itcAsClass forUrl: aString.
	pictureFiles do: 
			[:each | 
			| result fileStream |
			result := httpClient get: each last.
			result statusLine = 'HTTP/1.1 200 OK' 
				ifFalse: [ItcSystemManager logLine: 'Could not get image file from URL: ' , each last]
				ifTrue: 
					[| dirPath dirPathSub dirs |
					dirPath := (each first subStrings: (ItcSystemManager fileNameFromPath: each first)) first.
					dirs := dirPath subStrings: ItcSystemManager pathSeparator.
					dirPathSub := ''.
					dirs do: 
							[:eachDir | 
							eachDir isString 
								ifTrue: 
									[dirPathSub := dirPathSub , eachDir , ItcSystemManager pathSeparator asString.
									(ItcSystemManager fileExists: dirPathSub) ifFalse: [ItcSystemManager directoryCreate: dirPathSub]]].
					fileStream := FileStream write: each first text: false.
					[fileStream nextPutAll: result contents] ensure: [fileStream close]]]!

executableName
	^self subclassResponsibility!

files
	files isNil ifTrue: [files := OrderedCollection new].
	^files!

generateDeinstallationScript
	| ws destination flags |
	ws := WriteStream on: String new.
	self files do: 
			[:each | 
			flags := each first.
			(flags isNilOrEmpty or: [(flags includes: #noDelete) not]) 
				ifTrue: 
					[destination := each at: 3.
					ws
						nextPutAll: 'del "' , self baseDirectory , destination , '"';
						cr]].
	^ws contents!

generateInnoSetupScript
	| ws |
	ws := WriteStream on: String new.
	ws nextPutAll: '[_ISTool]
EnableISX=false

'.
	self
		generateInnoSetupScriptForFilesOn: ws;
		generateInnoSetupScriptForDirectoriesOn: ws;
		generateInnoSetupScriptAfterFilesAndDirectoriesOn: ws.
	^ws contents!

generateInnoSetupScriptAfterFilesAndDirectoriesOn: ws 
	!

generateInnoSetupScriptForDirectoriesOn: ws 
	self directories isNilOrEmpty ifTrue: [^self].
	ws nextPutAll: '[Dirs]
'.
	self directories do: 
			[:each | 
			each first == #createInApplicationDirectory 
				ifTrue: [ws nextPutAll: 'Name: {app}\' , each last , '
']].
	ws cr!

generateInnoSetupScriptForFilesOn: ws 
	| flags source destination destinationFileName destinationPath istoolFlags |
	ws nextPutAll: '[Files]
'.
	self files do: 
			[:each | 
			flags := each at: 1.
			destination := each at: 3.
			source := each at: 2.
			ws
				nextPutAll: 'Source: ';
				nextPutAll: source;
				nextPutAll: '; DestDir: {app}'.
			destinationFileName := ItcSystemManager fileNameFromPath: destination.
			destinationPath := destination copyFrom: 1
						to: (destination size - destinationFileName size - 1 max: 0).
			destinationPath isNilOrEmpty ifFalse: [ws nextPutAll: '\' , destinationPath].
			ws
				nextPutAll: '; DestName: ';
				nextPutAll: destinationFileName;
				nextPut: $;.
			flags isNilOrEmpty 
				ifFalse: 
					[istoolFlags := flags select: [:eachFlag | eachFlag class == String].
					istoolFlags isEmpty 
						ifFalse: 
							[ws nextPutAll: ' Flags:'.
							istoolFlags do: [:eachFlag | ws nextPutAll: ' ' , eachFlag].
							ws nextPut: $;].
					(flags includes: #firstInstallOnWin2000only) 
						ifTrue: [ws nextPutAll: ' OnlyBelowVersion: 0,5.00.2195sp1']].
			ws cr].
	ws cr!

generateInstallerZipFileCreationScript
	| ws source destination archiveName flags |
	archiveName := self zipArchiveFilename.
	ws := WriteStream on: String new.
	ws
		nextPutAll: 'md "' , self baseDirectory , archiveName , '"';
		cr.
	self directories do: 
			[:each | 
			each first == #createInApplicationDirectory 
				ifTrue: 
					[| dirs |
					ws
						nextPutAll: 'cd "' , self baseDirectory , archiveName , '"';
						cr.
					dirs := (each last replaceAll: $/ with: $\) itcSubStrings: $\.
					1 to: dirs size - 1
						do: 
							[:i | 
							ws
								nextPutAll: 'cd "' , (dirs at: i) , '"';
								cr].
					ws
						nextPutAll: 'md "' , dirs last , '"';
						cr]].
	self files do: 
			[:each | 
			flags := each at: 1.
			(flags isNilOrEmpty or: [(flags includes: #firstInstallOnWin2000only) not]) 
				ifTrue: 
					[destination := each at: 3.
					source := each at: 2.
					ws
						nextPutAll: 'copy "' , self baseDirectory , source , '" "' , self baseDirectory , archiveName , '\' 
									, destination , '"';
						cr]].
	ws 
		nextPutAll: 'cd "' , self baseDirectory , archiveName , '"
zip -mr ..\' , archiveName 
				, '.zip *.*
cd ..
del ' , archiveName 
				, '\*.*
rd ' , archiveName 
				, '
exit
'.
	^ws contents!

generateUpgradeScriptFor: newVersionZipArchivePathname 
	| ws |
	ws := WriteStream on: String new.
	ws
		nextPutAll: 'cd "' , ItcSystemManager startUpDirectoryPath 
					, '"
md Log_files
move ERROR.LOG Log_files\ERROR-' , self applicationVersion 
					, '-' , Timestamp now asFilenameString 
					, '.LOG
move SERVER_LOG*.txt Log_files
sleep 5
kill -f ' , ItcSystemManager imageFilename 
					, '.exe
pskill ' , ItcSystemManager imageFilename 
					, '.exe
sleep 10
';
		nextPutAll: self generateDeinstallationScript;
		nextPutAll: '
cd "' , ItcSystemManager startUpDirectoryPath , '"
unzip -o "' 
					, newVersionZipArchivePathname , '"
rename ' 
					, self executableName , ' ' 
					, ItcSystemManager imageFilename , '.exe
start ' 
					, ItcSystemManager imageFilename , '.exe ' 
					, ItcSystemManager imageCommandLineArguments , '
exit
'.
	^ws contents!

noFileCompression: aBoolean 
	noFileCompression := aBoolean!

zipArchiveFilename
	^self subclassResponsibility! !
!ItcInstaller categoriesFor: #addAllInstallerFiles!public! !
!ItcInstaller categoriesFor: #addAllInstallerFilesForFirstInstallation!public! !
!ItcInstaller categoriesFor: #addDirectory:!public! !
!ItcInstaller categoriesFor: #addFile:!public! !
!ItcInstaller categoriesFor: #addFile:from:!public! !
!ItcInstaller categoriesFor: #addFile:from:flags:!public! !
!ItcInstaller categoriesFor: #applicationVersion!public! !
!ItcInstaller categoriesFor: #baseDirectory!private! !
!ItcInstaller categoriesFor: #createInstallerZipFile!public! !
!ItcInstaller categoriesFor: #directories!private! !
!ItcInstaller categoriesFor: #downloadAndSaveImagesFrom:!public! !
!ItcInstaller categoriesFor: #executableName!public! !
!ItcInstaller categoriesFor: #files!private! !
!ItcInstaller categoriesFor: #generateDeinstallationScript!public! !
!ItcInstaller categoriesFor: #generateInnoSetupScript!InnoSetup support!public! !
!ItcInstaller categoriesFor: #generateInnoSetupScriptAfterFilesAndDirectoriesOn:!InnoSetup support!private! !
!ItcInstaller categoriesFor: #generateInnoSetupScriptForDirectoriesOn:!InnoSetup support!private! !
!ItcInstaller categoriesFor: #generateInnoSetupScriptForFilesOn:!InnoSetup support!private! !
!ItcInstaller categoriesFor: #generateInstallerZipFileCreationScript!public! !
!ItcInstaller categoriesFor: #generateUpgradeScriptFor:!public! !
!ItcInstaller categoriesFor: #noFileCompression:!public! !
!ItcInstaller categoriesFor: #zipArchiveFilename!public! !

