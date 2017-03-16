"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ItcSystemManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'previousTimeReading rollOverValue isHeadless liveUpdatePatchDict'!
ItcSystemManager guid: (GUID fromString: '{1bae3813-906e-4aab-b758-d8ca80e1500c}')!
ItcSystemManager comment: ''!
!ItcSystemManager categoriesForClass!Unclassified! !
!ItcSystemManager class methodsFor!

absoluteMillisecondsClockValue
	"Answer milliseconds clock value on absolute time scale using system timer.
	Value is always incremented, no wrap-around can occur and no daylight saving occurs.
	This method is thread safe."

	| time |
	time := Time millisecondClockValue.
	rollOverValue isNil 
		ifTrue: 
			[rollOverValue := 0.
			previousTimeReading := 0]
		ifFalse: [time := time + rollOverValue].
	previousTimeReading - time > 86400000 
		ifTrue: 
			[self 
				logLineWithTS: 'Absolute ms clock roll over, previous=' , previousTimeReading printString 
						, ' current=' , time printString 
						, ' rollover=' , rollOverValue printString.
			time := time + (2 raisedTo: 32).
			rollOverValue := time - (time \\ (2 raisedToInteger: 32))].
	^time > previousTimeReading 
		ifTrue: 
			[previousTimeReading := time.
			time]
		ifFalse: [previousTimeReading]!

absoluteSecondsClockValue
	"Answer seconds clock value on absolute time scale.
	Value is always incremented, no wrap-around can occur and no daylight saving occurs."

	^self absoluteMillisecondsClockValue // 1000!

activeProcessDumpString
	^Processor activeProcess stackTrace: 20!

assert: aValue 
	aValue = true 
		ifFalse: 
			[self isRuntime 
				ifTrue: [self logLine: 'ASSERT FAILED']
				ifFalse: [self error: 'Assert failed']]!

basicShowProgressDialogWhile: aBlock caption: captionString allowCancel: allowCancelBoolean 
	| dlg |
	dlg := #ProgressDialog itcAsClass create: #ProgressDialog itcAsClass defaultView.
	^dlg
		operation: [:progress | aBlock value: dlg value: progress];
		allowCancel: allowCancelBoolean;
		caption: captionString;
		showModal!

batchJobPriority
	^3!

caption: aString 
	"Private - Do nothing"

	!

checkDolphinObjectTableSize
	"Private - Use this method to check the size of Dolphin's object table to prevent image from crashing."

	| fs max val |
	self logLineWithTS: 'Current number of objects is ' , MemoryManager current objectCount printString.
	fs := FileStream readWrite: SessionManager current imageFileName.
	fs beBinary.
	fs position: 16r20.
	max := fs nextSDWORD.
	val := (100 * MemoryManager current objectCount / max) asDecimalOrFloat roundTo: 0.01s.
	val := (val respondsTo: #asWebStringWithMinimumDecimals) 
				ifTrue: [val printString]
				ifFalse: [val asWebStringWithMinimumDecimals].
	self
		logLineWithTS: 'Current object table size is ' , max printString;
		logLineWithTS: 'Currently running at ' , val , '%'.
	fs close!

checkEmail: aString 
	"Perform basic validity check of an eMail address and answer <true> if OK, else answer <false>."

	| tokens nameString domain domainTokens eMail |
	(aString isNil or: [aString size < 6]) ifTrue: [^false].
	eMail := aString.
	((eMail includes: $;) or: [eMail includes: $,]) 
		ifTrue: 
			[eMail := aString copy replaceAll: $, with: $;.
			^(eMail itcSubStrings: $;) conform: [:eachEmail | self checkEmail: eachEmail trimBlanks]].
	(eMail includes: $ ) ifTrue: [^false].
	tokens := eMail itcSubStrings: $@.
	tokens size = 2 ifFalse: [^false].
	nameString := tokens first asLowercase.
	domain := tokens last asLowercase.
	domainTokens := domain itcSubStrings: $..
	domainTokens size < 2 ifTrue: [^false].
	(domainTokens conform: 
			[:each | 
			each notEmpty and: 
					[(each conform: [:eachLetter | 'abcdefghijklmnopqrstuvwxyz-0123456789' includes: eachLetter]) 
						and: [each first ~= $- and: [each last ~= $-]]]]) 
		ifFalse: [^false].
	((#('aero' 'asia' 'biz' 'cat' 'com' 'coop' 'edu' 'gov' 'info' 'int' 'jobs' 'mil' 'mobi' 'museum' 'name' 'net' 'org' 'pro' 'tel' 'travel') 
		includes: domainTokens last) or: [domainTokens last size = 2]) 
		ifFalse: [^false].
	nameString isEmpty ifTrue: [^false].
	(nameString last = $. or: [nameString last = $- or: [nameString last = $_]]) ifTrue: [^false].
	(nameString itcSubStrings: $.) do: [:each | each isEmpty ifTrue: [^false]].
	(nameString itcSubStrings: $-) do: [:each | each isEmpty ifTrue: [^false]].
	(nameString itcSubStrings: $_) do: [:each | each isEmpty ifTrue: [^false]].
	^nameString conform: [:eachLetter | 'abcdefghijklmnopqrstuvwxyz-0123456789._' includes: eachLetter]!

checkImageConsistency
	"Depending on the platform, this message will check image consistency with regard to GPF errors.
	Output will be written to console."

	"do nothing in Dolphin"

	!

compileRuntimePatchForClass: aClass methodSource: methodSource 
	| userStr |
	userStr := (userStr := (self respondsTo: #webSession) ifTrue: [self webSession]) isNil 
				ifTrue: ['']
				ifFalse: [userStr usernameInfo].
	^self 
		compileRuntimePatchForClass: aClass
		methodSource: methodSource
		user: userStr
		timestamp: Timestamp now!

compileRuntimePatchForClass: aClass methodSource: methodSource user: username timestamp: methodTimestamp 
	"Dictionary of compiled methods stores arrays with 3 elements:
		1. Method source;
		2. Username string of the user who made live update,
		3. Original method timestamp when live update was made."

	| error result |
	ItcSystemManager isRuntime 
		ifFalse: 
			[ItcSystemManager logDevTimeError: 'Can not apply live updates in development environment.'.
			^true].
	liveUpdatePatchDict isNil ifTrue: [liveUpdatePatchDict := IdentityDictionary new].
	result := error := nil.
	
	[result := Compiler 
				compile: methodSource
				in: aClass
				flags: Compiler defaultFlags] 
			on: CompilerErrorNotification
			do: [:n | error := n].
	^(error isNil and: [result notNil]) 
		ifTrue: 
			[| selector method |
			method := result method.
			selector := method selector asSymbol.
			aClass addSelector: selector withMethod: method.
			method isImmutable: true.
			self logLineWithTsAndSession: 'Live update adding patch for ' , aClass printString , '>>' 
						, method selector printString.
			(liveUpdatePatchDict at: aClass ifAbsentPut: [IdentityDictionary new]) at: method selector
				put: (Array 
						with: methodSource
						with: username
						with: methodTimestamp).
			true]
		ifFalse: [false]!

convert: aString with: str1 with: str2 
	| in out i j x b1 b2 ic pos |
	pos := 0.
	b1 := str1 asByteArray.
	str1 size even ifTrue: [b1 := b1 reverse].
	b2 := str2 asByteArray.
	str2 size even ifTrue: [b2 := b2 reverse].
	i := (b1 at: 1) * 11.
	j := (b2 at: 1) * 7.
	x := j * 13.
	in := ReadStream on: aString asByteArray.
	out := WriteStream on: ByteArray new.
	[in atEnd] whileFalse: 
			[ic := in next.
			i := i + (b1 at: i \\ b1 size + 1) bitAnd: 131071.
			j := j + (b2 at: i \\ b2 size + 1) bitAnd: 131071.
			pos := pos + 1.
			x := (((x bitXor: pos) bitXor: i) bitXor: j) bitAnd: 255.
			out nextPut: (ic bitXor: x).
			x even ifTrue: [x := x bitXor: 13] ifFalse: [x := x bitXor: 111]].
	^out contents!

cronJobDaemonPriority
	^4!

currentPlatformID
	"Answer aSymbol telling the code in which Smalltalk platform it is running:
	
		#DolphinSmalltalkVM
		#VastWindowsVM
		#VastLinuxVM
		#VisualWorksWindowsVM
		#VisualWorksLinuxVM
		#SqueakVM
		#SmalltalkXVM
	"

	^#DolphinSmalltalkVM!

destroy
	"do nothing"

	!

directoryCreate: pathName 
	| result |
	result := true.
	[File createDirectory: pathName] on: Error do: [:ex | result := false].
	^result!

directoryRemove: pathName 
	| result |
	result := true.
	[File deleteDirectory: pathName] on: Error do: [:ex | result := false].
	^result!

fileDataFor: filePath 
	"Answer <nil> if a file does not exist.
	else answer an Array with file creation time, modification time and file size."

	| file result |
	(file := Filename named: filePath) exists 
		ifTrue: 
			[
			[result := Array 
						with: file creationTime
						with: file lastModificationTime
						with: file size] 
					ensure: [file close]].
	^result!

fileExists: pathName 
	"Answer <true> if file exists."

	^File exists: pathName!

fileExtensionFromPath: aString 
	| index fn |
	aString isNilOrEmpty ifTrue: [^''].
	fn := self fileNameFromPath: aString.
	^(index := fn reverse indexOf: $.) > 1 
		ifTrue: [(fn copyFrom: fn size - index + 2) asUppercase]
		ifFalse: ['']!

fileNameFromPath: aString 
	| lastIndex ch |
	aString isNil ifTrue: [^nil].
	lastIndex := 1.
	1 to: aString size
		do: 
			[:i | 
			ch := aString at: i.
			(ch = $/ or: [ch = $\]) ifTrue: [lastIndex := i + 1]].
	^aString copyFrom: lastIndex to: aString size!

fileNameWithoutExtension: aString 
	| lastIndex ch dotIndex |
	aString isNil ifTrue: [^nil].
	lastIndex := 1.
	1 to: aString size
		do: 
			[:i | 
			ch := aString at: i.
			(ch = $/ or: [ch = $\]) ifTrue: [lastIndex := i + 1]].
	dotIndex := aString size + 1.
	lastIndex to: aString size
		do: 
			[:i | 
			ch := aString at: i.
			ch = $. ifTrue: [dotIndex := i]].
	^aString copyFrom: 1 to: dotIndex - 1!

fileRemove: pathName 
	"Answer <true> if successfull."

	| result |
	
	[File delete: pathName.
	result := true] on: Error do: [:ex | result := false].
	^result!

fileRename: existingFilename to: newFilename 
	"Rename file. Trigger an error if file rename fails."

	File rename: existingFilename to: newFilename!

forkExternalProgram: externalProgram 
	ShellLibrary default shellOpen: externalProgram!

forkExternalProgramScript: commandLineScriptString 
	| cmdFilename stream |
	cmdFilename := Timestamp now asFilenameString , '_script.bat'.
	stream := FileStream write: cmdFilename mode: #truncate.
	
	[stream
		nextPutAll: commandLineScriptString;
		cr;
		nextPutAll: 'exit';
		cr] 
			ensure: [stream close].
	self forkExternalProgram: cmdFilename!

forkNewProcessOn: aBlock named: processName 
	^(aBlock newProcess)
		name: processName;
		priority: Processor activeProcess priority;
		resume;
		yourself!

forkNewProcessOn: aBlock named: processName priority: priority 
	^(aBlock newProcess)
		name: processName;
		priority: priority;
		resume;
		yourself!

ftpDownload: downloadFilePathAndName hostname: hostname username: username password: password intoDirectory: localDirectoryString 
	| stream tempCommandsFilename localDirectory result |
	localDirectory := localDirectoryString.
	localDirectory last = self pathSeparator 
		ifTrue: [localDirectory := localDirectory copyFrom: 1 to: localDirectory size - 1].
	ItcSystemManager 
		logLineWithTsAndSession: 'FTP download from ' , username , '@' , hostname , ', file named: ' 
				, downloadFilePathAndName.
	tempCommandsFilename := localDirectory , self pathSeparatorString , 'FTP_commands_' 
				, Timestamp now asFilenameString , ItcSystemManager generateShortRandomString 
				, '.txt'.
	stream := FileStream write: tempCommandsFilename mode: #truncate.
	
	[stream
		nextPutAll: 'user ' , username , ' ' , password , '
';
		nextPutAll: 'lcd ' , localDirectory , '
bin
' , 'get ' , downloadFilePathAndName , '
' , 'bye
'] 
			ensure: [stream close].
	[result := self startExternalProgramScript: 'ftp -n -s:' , tempCommandsFilename , ' ' , hostname] 
		ensure: [self fileRemove: tempCommandsFilename].
	^result!

generateRandomString
	^(self getBase62EncodedStringFrom: self absoluteMillisecondsClockValue maxLength: 10) 
		, (self getBase62EncodedStringFrom: Object new identityHash maxLength: 10)!

generateShortRandomString
	^(self getBase62EncodedStringFrom: self absoluteMillisecondsClockValue + Object new identityHash
		maxLength: 4) , (self getBase62EncodedStringFrom: Object new identityHash maxLength: 4)!

getActiveUserOrSessionInfo
	| session |
	session := (self respondsTo: #webSession) ifTrue: [self webSession].
	^session notNil 
		ifTrue: 
			[(session usernameInfo 
				add: '[' , (session sessionData at: #defaultMandantId ifAbsent: ['-']) asWebString , ']'
				withDelimiter: ' ') , ' ' 
				, session application urlPrefix , ' ' 
				, session application currentReleaseId]
		ifFalse: ['/']!

getAllFilenamesInDirectory: pathname 
	^((self getAllFilesAndDirectoriesInDirectory: pathname) select: [:each | (each at: 6) = false]) 
		collect: [:each | each first]!

getAllFilesAndDirectoriesInDirectory: pathname 
	| coll |
	coll := OrderedCollection new.
	File 
		for: '*'
		in: pathname
		do: 
			[:each | 
			coll add: ((Array new: 7)
						at: 1 put: each fileName;
						at: 2 put: each fileSize;
						at: 3 put: (Timestamp fromSYSTEMTIME: each ftCreationTime asSYSTEMTIME);
						at: 4 put: (Timestamp fromSYSTEMTIME: each ftLastAccessTime asSYSTEMTIME);
						at: 5 put: (Timestamp fromSYSTEMTIME: each ftLastWriteTime asSYSTEMTIME);
						at: 6 put: each isDirectory;
						at: 7 put: each isReadOnly;
						yourself)].
	^coll!

getBase62EncodedStringFrom: anInteger maxLength: maxLen 
	| n digits str |
	n := anInteger.
	str := String new: maxLen.
	digits := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.
	1 to: maxLen
		do: 
			[:i | 
			str at: i put: (digits at: n \\ 62 + 1).
			n := n // 62.
			n = 0 ifTrue: [^str copyFrom: 1 to: i]].
	^str!

getBMPImageSize: aByteArray 
	"As member of Microsoft family BMP format has large number of internal formats based on versions. Versions 2.x , 3.x and 4.x are covered here."

	| stream size w h |
	aByteArray size < 26 ifTrue: [^nil].
	stream := ReadStream on: aByteArray.
	(stream next: 2) = 'BM' ifFalse: [^nil].
	"Skip file header."
	stream next: 12.
	size := stream next asInteger.
	(#(12 40 108) includes: size) 
		ifFalse: 
			[self isRuntime ifFalse: [self error: 'Unsupported BMP format'].
			^nil].
	stream next: 3.
	size == 12 
		ifTrue: 
			["BMP 2.x"
			w := stream next asInteger.
			h := stream next asInteger.
			^w @ h].
	aByteArray size < 52 ifTrue: [^nil].
	"Height can be negative and it represents picture origin. Not implemented yet."
	w := stream next asInteger + (stream next asInteger * 256) + (stream next asInteger * 65536) 
				+ (stream next asInteger * 16777216).
	h := stream next asInteger + (stream next asInteger * 256) + (stream next asInteger * 65536) 
				+ (stream next asInteger * 16777216).
	^w @ h!

getComputerName
	^SessionManager current computerName!

getCurrentOsProcessId
	"Answer operating system PID of the process in which the Smalltalk VM is running."

	^KernelLibrary default getCurrentProcessId!

getCurrentUserName
	^SessionManager current userName!

getFreeDiskSpace
	^(DiskVolumeInformation forPath: self startUpDirectoryPath) totalFreeBytes!

getGIF87aImageSize: aByteArray 
	| stream lsw lsh |
	stream := ReadStream on: aByteArray.
	"skip header"
	stream next: 6.
	"screen descriptor"
	lsw := stream next asInteger + (stream next asInteger * 256).
	lsh := stream next asInteger + (stream next asInteger * 256).
	^lsw @ lsh!

getGIF89aImageSize: aByteArray 
	| stream lsw lsh |
	stream := ReadStream on: aByteArray.
	"skip header"
	stream next: 6.
	"screen descriptor"
	lsw := stream next asInteger + (stream next asInteger * 256).
	lsh := stream next asInteger + (stream next asInteger * 256).
	^lsw @ lsh!

getGIFImageSize: aByteArray 
	| desc |
	aByteArray size < 10 ifTrue: [^nil].
	desc := (aByteArray copyFrom: 1 to: 6) asString.
	desc = 'GIF87a' ifTrue: [^self getGIF87aImageSize: aByteArray].
	desc = 'GIF89a' ifTrue: [^self getGIF89aImageSize: aByteArray].
	^nil!

getHostnameFromIP: ipString 
	| host |
	[host := (InternetAddress fromIPString: ipString) host] on: Error
		do: [:ex | ex exitWith: nil].
	^host isNil ifTrue: ['N/A'] ifFalse: [host]

	"	Should the code above block, use external NSLOOKUP instead."

	"
	| str stream host line |
	[str := ItcSystemManager startExternalProgram: 'nslookup ', ipString.
	stream := ReadStream on: str.
	[stream atEnd] whileFalse: [
		line := stream nextLine.
		(line beginsWith: 'Name:')
			ifTrue: [ host := ((ReadStream on: line reverse) upTo: $ ) reverse]]
	] on: Error do: [:ex | ex exitWith: nil ].
	^host
	"!

getImageSize: imageBytes fileName: fileName 
	| tipDatoteke imageSize gdiplusImage width height |
	tipDatoteke := ItcSystemManager fileExtensionFromPath: fileName.
	tipDatoteke = 'GIF' 
		ifTrue: [imageSize := self getGIFImageSize: imageBytes]
		ifFalse: 
			[(tipDatoteke = 'JPG' or: [tipDatoteke = 'JPEG']) 
				ifTrue: [imageSize := self getJpegImageSize: imageBytes]
				ifFalse: 
					[tipDatoteke = 'PNG' 
						ifTrue: [imageSize := self getPNGImageSize: imageBytes]
						ifFalse: [tipDatoteke = 'BMP' ifTrue: [imageSize := self getBMPImageSize: imageBytes]]]].
	imageSize isNil 
		ifTrue: 
			[
			[gdiplusImage := GdiplusImage fromByteArray: imageBytes.
			width := gdiplusImage width.
			height := gdiplusImage height.
			imageSize := width @ height] 
					on: Error
					do: [:ex | ex exitWith: nil]].
	^imageSize!

getJpegImageSize: aByteArray 
	| stream segmentType segmentSize h w |
	aByteArray size < 10 ifTrue: [^nil].
	stream := ReadStream on: aByteArray.
	(stream next: 2) asByteArray = #[16rFF 16rD8] ifFalse: [^nil].
	"branje segmentov"
	
	[[stream atEnd] whileFalse: 
			[[stream peek asInteger = 16rFF] whileTrue: [stream next].
			segmentType := stream next asInteger.
			(#[16rD0 16rD1 16rD2 16rD3 16rD4 16rD5 16rD6 16rD7 16r01] includes: segmentType) 
				ifFalse: 
					[segmentSize := stream next asInteger * 256 + stream next asInteger.
					"Start of Frame 0 segment ?"
					segmentType = 16rC0 
						ifTrue: 
							[stream next.
							h := stream next asInteger * 256 + stream next asInteger.
							w := stream next asInteger * 256 + stream next asInteger.
							^w @ h]
						ifFalse: [stream next: segmentSize - 2]]]] 
			on: Error
			do: [:ex | ex exitWith: nil].
	^nil!

getLiveUpdatePatchDict
	liveUpdatePatchDict isNil ifTrue: [liveUpdatePatchDict := IdentityDictionary new].
	^liveUpdatePatchDict!

getPNGImageSize: aByteArray 
	| stream h w |
	aByteArray size < 30 ifTrue: [^nil].
	stream := ReadStream on: aByteArray.
	(stream next: 8) asByteArray = #[137 80 78 71 13 10 26 10] ifFalse: [^nil].
	"Skip IHDR chunk size."
	stream next: 4.
	(stream next: 4) asString = 'IHDR' ifFalse: [^nil].
	"Width and height are stored in 4 bytes unsigned integers."
	w := stream next asInteger * 16777216 + (stream next asInteger * 65536) 
				+ (stream next asInteger * 256) + stream next asInteger.
	h := stream next asInteger * 16777216 + (stream next asInteger * 65536) 
				+ (stream next asInteger * 256) + stream next asInteger.
	(w == 0 or: [h == 0]) ifFalse: [^w @ h].
	^nil!

getThumbnailBytesForImageNamed: filename imageBytes: imageBytes application: application maxWidth: maxWidth maxHeight: maxHeight 
	| imageSize |
	imageSize := ItcSystemManager getImageSize: imageBytes fileName: filename.
	^(imageSize notNil and: [imageSize x < maxWidth and: [imageSize y < maxHeight]]) 
		ifFalse: 
			[self 
				getThumbnailBytesForImageNamedUsingGdiPlus: filename
				imageBytes: imageBytes
				imageSize: imageSize
				application: application
				maxWidth: maxWidth
				maxHeight: maxHeight]!

getThumbnailBytesForImageNamedUsingGdiPlus: filename imageBytes: imageBytes imageSize: imageSize application: application maxWidth: maxWidth maxHeight: maxHeight 
	| thumbnailBytes img |
	
	[img := GdiplusBitmap fromImage: (GdiplusImage fromByteArray: imageBytes)
				centeredIn: maxWidth @ maxHeight.
	thumbnailBytes := img 
				asByteArray: (GdiplusImage mimeTypeForExtension: (ItcSystemManager fileExtensionFromPath: filename))] 
			on: Error
			do: [:ex | ex exitWith: nil].
	^thumbnailBytes!

getThumbnailBytesForImageNamedUsingIrfanView: filename imageBytes: imageBytes imageSize: imageSize application: application maxWidth: maxWidth maxHeight: maxHeight 
	| f f2 imageName thumbName thumbContent allowedTypes tempFilesPath irfanViewPathname |
	tempFilesPath := application temporaryDirectoryPath.
	irfanViewPathname := application configurationSettingsAt: 'application.IrfanViewPathname'
				ifAbsent: ['C:\Program Files\IrfanView\i_view32.exe'].
	allowedTypes := #('GIF' 'JPG' 'JPEG').
	thumbContent := nil.
	(allowedTypes includes: (ItcSystemManager fileExtensionFromPath: filename)) 
		ifTrue: 
			[(imageSize isNil or: [imageSize x > maxWidth or: [imageSize y > maxHeight]]) 
				ifTrue: 
					[imageName := tempFilesPath , 'NormalSize.' , (ItcSystemManager fileExtensionFromPath: filename).
					f := FileStream write: imageName.
					[f nextPutAll: imageBytes] ensure: [f close].
					thumbName := tempFilesPath , 'Thumbnail.' , (ItcSystemManager fileExtensionFromPath: filename).
					ItcSystemManager 
						startExternalProgramScript: 'cd "' , tempFilesPath , '"
"' , irfanViewPathname , '" "' , imageName 
								, '" /resize=(' , maxWidth printString 
								, ',' , maxHeight printString 
								, ') /aspectration /convert="' , thumbName 
								, '" /jpgq=25'.
					[f2 := FileStream read: thumbName] on: Error do: [:ex | ex exitWith: nil].
					f2 isFileStream 
						ifTrue: 
							[[thumbContent := f2 contents] ensure: [f2 close].
							FileStream delete: thumbName].
					[FileStream delete: imageName] on: Error do: [:ex | ex exitWith: nil]]].
	^thumbContent isNil ifTrue: [imageBytes] ifFalse: [thumbContent]!

getUniqueIdString
	^GUID newUnique asString select: [:each | each isLetter or: [each isDigit]]!

getUUIDString
	^GUID newUnique idlString!

globalGarbageCollect
	"Flush out the garbage again."

	2 timesRepeat: 
			[(MemoryManager current)
				collectGarbage;
				administerLastRites;
				compact]!

imageCommandLine
	"Answer command line which started the current session."

	^SessionManager current getCommandLine!

imageCommandLineArguments
	"Answer command line arguments which were used to start the current session."

	| rs |
	rs := ReadStream on: self imageCommandLine.
	rs next = $" 
		ifTrue: 
			[rs upTo: $".
			rs atEnd ifFalse: [rs next]]
		ifFalse: [rs upTo: $ ].
	^rs upToEnd!

imageFilename
	"Answer image/executable filename without extension string."

	| filename index endIndex |
	filename := SessionManager current imageFileName.
	(index := filename lastIndexOf: $\) < 1 
		ifTrue: [(index := filename lastIndexOf: $/) < 1 ifTrue: [index := 0]].
	filename := (endIndex := filename lastIndexOf: $.) < 1 
				ifTrue: [filename copyFrom: index + 1]
				ifFalse: [filename copyFrom: index + 1 to: endIndex - 1].
	^filename!

imageTimestamp
	| imgFile |
	(imgFile := Filename named: SessionManager current imageFileName) exists ifFalse: [^nil].
	^imgFile lastModificationTime!

increaseDolphinObjectTableSize
	"Private - Use this method to increase the size of Dolphin's object table by half a million to prevent image from crashing."

	| fs max val |
	self logLineWithTS: 'Current number of objects is ' , MemoryManager current objectCount printString.
	fs := FileStream readWrite: SessionManager current imageFileName.
	fs beBinary.
	fs position: 16r20.
	max := fs nextSDWORD.
	val := (100 * MemoryManager current objectCount / max) asDecimalOrFloat roundTo: 0.01s.
	val := (val respondsTo: #asWebStringWithMinimumDecimals) 
				ifTrue: [val printString]
				ifFalse: [val asWebStringWithMinimumDecimals].
	self
		logLineWithTS: 'Current object table size is ' , max printString;
		logLineWithTS: 'Currently running at ' , val , '%'.
	fs position: 16r20.
	fs nextSDWORDPut: max + 500000.
	fs close!

isHeadless
	^isHeadless = true "or: [SessionManager current isHeadless]"!

isHeadless: aBoolean 
	"Do not use - should be used for testing only."

	isHeadless := aBoolean!

isIgnoredSocketError: ex socket: anObject 
	| str |
	[str := ex description] on: Error do: [:err | err exitWith: nil].
	(str isNil or: 
			[str = 'Windows Socket error 10053: WSAECONNABORTED' 
				or: [str = 'Windows Socket error 10054: WSAECONNRESET']]) 
		ifTrue: [^true].
	^ex class == SocketClosed!

isRunningOnLinux
	^false!

isRunningOnWindows
	^true!

isRuntime
	^SessionManager current isRuntime!

log: aString 
	(self serverLogStream)
		nextPutAll: aString;
		flush!

logDevTimeError: aStringOrBlock 
	| str |
	self isRuntime 
		ifFalse: 
			[str := aStringOrBlock isBlockClosure ifTrue: [aStringOrBlock value] ifFalse: [aStringOrBlock].
			self logLineWithTsAndSession: str]!

logLine: aString 
	(self serverLogStream)
		nextPutAll: aString;
		cr;
		flush!

logLineDevTime: aStringOrBlock 
	| str |
	self isRuntime 
		ifFalse: 
			[str := aStringOrBlock isBlockClosure ifTrue: [aStringOrBlock value] ifFalse: [aStringOrBlock].
			self logLineWithTS: str]!

logLineWithTS: aString 
	^self logLine: Timestamp now asFilenameString , ': ' , aString!

logLineWithTsAndPID: aString 
	^self 
		logLine: Timestamp now asFilenameString , '[' , Processor activeProcess itcProcessId printString 
				, ']: ' , aString!

logLineWithTsAndSession: aString 
	^self 
		logLine: Timestamp now asFilenameString , ' - ' , self getActiveUserOrSessionInfo , ': ' , aString!

message: message 
	self logLine: '
' , message!

newProcessOn: aBlock named: processName 
	^(aBlock newProcess)
		name: processName;
		yourself!

newRandomNumberGenerator
	^Random new!

newScaledDecimalNumerator: n denominator: d scale: scale 
	^(ScaledDecimal basicNew)
		setFraction: (Fraction numerator: n denominator: d) scale: scale;
		yourself!

newSerialPortWriter
	"Answer new COM/serial port device read/write communication object."

	^COMPortWriter new!

newServerSocketOnPort: serverPort backlog: backlog 
	^ServerSocket port: serverPort backlog: backlog!

newSSLclientSocketToHost: host port: port 
	^(ItcSSLSocket port: port host: host)
		connect;
		yourself!

newTCPclientSocketToHost: host port: port 
	^(Socket port: port host: host)
		connect;
		yourself!

onStartup
	rollOverValue := 0.
	previousTimeReading := 0!

pathSeparator
	^$\!

pathSeparatorString
	^'\'!

progress
	"Dummy method for wrapping Dolphin ProgressDialog, not needed for other dialects..."

	^0!

quitImage
	self isRuntime 
		ifFalse: 
			[(#MessageBox itcAsClass confirm: 'Are you sure you want to exit Smalltalk image?') = true 
				ifFalse: [^nil]].
	SessionManager current quit!

requestHandlerPriority
	^5!

serverDaemonPriority
	^6!

serverLogStream
	^self isRuntime 
		ifTrue: [SessionManager current serverLogStream]
		ifFalse: [Smalltalk at: #Transcript]!

serverLogStreamFilename
	^self isRuntime ifTrue: [SessionManager current serverLogFilename]!

serverWatchdogPriority
	^7!

showBusyCursorWhile: aBlock 
	^self isHeadless ifTrue: [aBlock value] ifFalse: [#Cursor itcAsClass wait showWhile: aBlock]!

showProgressDialogWhile: aBlock caption: captionString allowCancel: allowCancelBoolean 
	"Accepts two argument block:
		- the first argument will be progress bar dialog which understands message #caption: and #destroy
		- the second argument will be progress bar value model which understands #value: from 0 to 100
	"

	^self isHeadless 
		ifTrue: [aBlock value: self value: self]
		ifFalse: 
			[self 
				basicShowProgressDialogWhile: aBlock
				caption: captionString
				allowCancel: allowCancelBoolean]!

socketErrorClass
	^SocketError!

startExternalProgram: externalProgram 
	| cmdFile cmdFilename done stream contents logFile quote |
	logFile := Timestamp now asFilenameString , ItcSystemManager generateRandomString , '.log'.
	cmdFilename := Timestamp now asFilenameString , ItcSystemManager generateRandomString , '.bat'.
	cmdFile := FileStream write: cmdFilename mode: #truncate.
	"enclose external program executable name in quotes if not already"
	quote := externalProgram first = $" ifTrue: [''] ifFalse: ['"'].
	
	[cmdFile 
		nextPutAll: quote , externalProgram , quote , ' 1>' , logFile , ' 2>&1

echo Exiting... >> ' 
				, logFile , '
'] 
			ensure: [cmdFile close].
	
	[self forkExternalProgram: cmdFilename.
	
	[(Delay forMilliseconds: 500) wait.
	self fileExists: logFile] whileFalse: [].
	done := false.
	[done] whileFalse: 
			[[stream := ODBFileStream openExclusivelyOn: logFile] on: Error do: [:ex | ex exitWith: nil].
			stream isNil 
				ifTrue: [(Delay forMilliseconds: 500) wait]
				ifFalse: 
					[stream close.
					stream := FileStream read: logFile text: true.
					[contents := stream contents] ensure: [stream close].
					done := true]]] 
			ensure: 
				[[FileStream delete: cmdFilename] on: Error do: [:ex | ex exitWith: nil].
				[FileStream delete: logFile] on: Error do: [:ex | ex exitWith: nil]].
	^contents!

startExternalProgram: exeNameString commandLineParameters: cmdLineString 
	| cmdFile cmdFilename done stream contents logFile |
	logFile := Timestamp now asFilenameString , '.log'.
	cmdFilename := Timestamp now asFilenameString , '.bat'.
	cmdFile := FileStream write: cmdFilename mode: #truncate.
	
	[cmdFile 
		nextPutAll: '"' , exeNameString , '" ' , cmdLineString , ' 1>' , logFile 
				, ' 2>&1

echo Exiting... >> ' , logFile 
				, '
'] 
			ensure: [cmdFile close].
	
	[self forkExternalProgram: cmdFilename.
	done := false.
	[done] whileFalse: 
			[(Delay forMilliseconds: 500) wait.
			
			[stream := FileStream 
						write: logFile
						mode: #append
						check: false
						text: true] 
					on: Error
					do: [:ex | ex exitWith: nil].
			stream isFileStream 
				ifTrue: 
					[done := stream isEmpty not.
					contents := stream contents.
					stream close.
					stream := nil]]] 
			ensure: 
				[[FileStream delete: logFile] on: Error do: [:ex | ex exitWith: nil].
				[FileStream delete: cmdFilename] on: Error do: [:ex | ex exitWith: nil]].
	^contents!

startExternalProgram: externalProgram maxSecondsToRun: maxSecondsToRun 
	| cmdFile cmdFilename done stream contents logFile quote totalSeconds |
	logFile := Timestamp now asFilenameString , ItcSystemManager generateRandomString , '.log'.
	cmdFilename := Timestamp now asFilenameString , ItcSystemManager generateRandomString , '.bat'.
	cmdFile := FileStream write: cmdFilename mode: #truncate.
	"enclose external program executable name in quotes if not already"
	quote := externalProgram first = $" ifTrue: [''] ifFalse: ['"'].
	
	[cmdFile 
		nextPutAll: quote , externalProgram , quote , ' 1>' , logFile , ' 2>&1

echo Exiting... >> ' 
				, logFile , '
'] 
			ensure: [cmdFile close].
	totalSeconds := 0.
	
	[self forkExternalProgram: cmdFilename.
	
	[(Delay forMilliseconds: 500) wait.
	self fileExists: logFile] whileFalse: 
				[totalSeconds := totalSeconds + 0.5.
				totalSeconds > maxSecondsToRun 
					ifTrue: [self error: 'External program has exceeded its maximum allowed time to run']].
	done := false.
	[done] whileFalse: 
			[[stream := ODBFileStream openExclusivelyOn: logFile] on: Error do: [:ex | ex exitWith: nil].
			stream isNil 
				ifTrue: 
					[(Delay forMilliseconds: 500) wait.
					totalSeconds := totalSeconds + 0.5.
					totalSeconds > maxSecondsToRun 
						ifTrue: [self error: 'External program has exceeded its maximum allowed time to run']]
				ifFalse: 
					[stream close.
					stream := FileStream read: logFile text: true.
					[contents := stream contents] ensure: [stream close].
					done := true]]] 
			ensure: 
				[[FileStream delete: cmdFilename] on: Error do: [:ex | ex exitWith: nil].
				[FileStream delete: logFile] on: Error do: [:ex | ex exitWith: nil]].
	^contents!

startExternalProgram: externalProgram writeLogTo: logFilename 
	| cmdFile cmdFilename done stream contents logFile errorLogFile |
	(logFilename includes: $ ) 
		ifTrue: 
			[logFile := '"' , logFilename , '"'.
			errorLogFile := '"' , logFilename , '.errors"']
		ifFalse: 
			[logFile := logFilename.
			errorLogFile := logFilename , '.errors'].
	cmdFilename := Timestamp now asFilenameString , '.bat'.
	cmdFile := FileStream write: cmdFilename mode: #truncate.
	
	[cmdFile 
		nextPutAll: '"' , externalProgram , '" 1> ' , logFile , ' 2> ' , errorLogFile , '

echo > ' 
				, logFile , '
echo Exiting ... > ' 
				, logFile , '
exit
'] 
			ensure: [cmdFile close].
	
	[self forkExternalProgram: cmdFilename.
	done := false.
	[done] whileFalse: 
			[(Delay forSeconds: 4) wait.
			
			[stream := FileStream 
						write: logFilename
						mode: #append
						check: false
						text: true] 
					on: Error
					do: [:ex | ex exitWith: nil].
			stream isFileStream 
				ifTrue: 
					[done := stream isEmpty not.
					contents := stream contents.
					stream close]]] 
			ensure: [[FileStream delete: cmdFilename] on: Error do: [:ex | ex exitWith: nil]].
	^contents!

startExternalProgramScript: commandLineScriptString 
	| cmdFilename stream result |
	cmdFilename := Timestamp now asFilenameString , ItcSystemManager generateRandomString 
				, '_script.bat'.
	stream := FileStream write: cmdFilename mode: #truncate.
	ItcSystemManager isRuntime 
		ifFalse: 
			[ItcSystemManager 
				logLineWithTsAndSession: 'Starting script:
---
' , commandLineScriptString , '
---
'].
	
	[stream
		nextPutAll: commandLineScriptString;
		cr;
		nextPutAll: 'exit';
		cr] 
			ensure: [stream close].
	result := self startExternalProgram: cmdFilename.
	FileStream delete: cmdFilename.
	^result!

startUpDirectoryPath
		"Answer with ending backslach/slash, e.g. c:\image\"

	^SessionManager current imageBase!

startUpSessionManager
	^SessionManager current!

timeZoneMinutesFromGMT
	^60!

totalAllocatedMemory
	"Answer amount of total allocated OS memory for this virtual machine in bytes."

	"NOTE: this is not implemented in Dolphin so we just answer total number of objects in the image times 120 bytes which is the average number of bytes per object from run-time observations.
	"

	^MemoryManager current objectCount * 120!

unzipArchive: archiveString into: directoryString 
	^self 
		unzipArchive: archiveString
		into: directoryString
		junkPaths: true!

unzipArchive: archiveString into: directoryString junkPaths: junkPaths 
	| directory archive junkPathsParam |
	junkPathsParam := junkPaths == true ifTrue: ['-j '] ifFalse: [''].
	directory := ((directoryString includes: $ ) and: [directoryString first ~= $"]) 
				ifTrue: ['"' , directoryString , '"']
				ifFalse: [directoryString].
	archive := ((archiveString includes: $ ) and: [archiveString first ~= $"]) 
				ifTrue: ['"' , archiveString , '"']
				ifFalse: [archiveString].
	^ItcSystemManager 
		startExternalProgramScript: 'cd ' , directory , '
unzip -o ' , junkPathsParam , archive , '
'!

value: anObject 
	"Private - Do nothing"

	!

writeErrorLog: ex 
	SessionManager current isRuntime 
		ifTrue: [SessionManager current writeErrorLog: ex]
		ifFalse: 
			[Transcript
				nextPutAll: ex itcDescription;
				cr]!

writeErrorLogInRuntime: ex 
	"Write to error.log in run-time.
	Signal an exception in dev-time."

	SessionManager current isRuntime 
		ifTrue: [SessionManager current writeErrorLog: ex terminateAfterWritingLog: false]
		ifFalse: [ex signal]!

zipDirectory: directory intoArchive: archivePathname 
	^self 
		zipDirectory: directory
		intoArchive: archivePathname
		junkPaths: true!

zipDirectory: directoryString intoArchive: archiveString junkPaths: junkPaths 
	| directory archive junkPathsParam |
	junkPathsParam := junkPaths == true ifTrue: [' -j '] ifFalse: [' -r '].
	directory := ((directoryString includes: $ ) and: [directoryString first ~= $"]) 
				ifTrue: ['"' , directoryString , '"']
				ifFalse: [directoryString].
	archive := ((archiveString includes: $ ) and: [archiveString first ~= $"]) 
				ifTrue: ['"' , archiveString , '"']
				ifFalse: [archiveString].
	^ItcSystemManager 
		startExternalProgramScript: 'cd ' , directory , '
zip' , junkPathsParam , archive , ' *.*
'! !
!ItcSystemManager class categoriesFor: #absoluteMillisecondsClockValue!public! !
!ItcSystemManager class categoriesFor: #absoluteSecondsClockValue!public! !
!ItcSystemManager class categoriesFor: #activeProcessDumpString!logging!public! !
!ItcSystemManager class categoriesFor: #assert:!public! !
!ItcSystemManager class categoriesFor: #basicShowProgressDialogWhile:caption:allowCancel:!private!progress dialog! !
!ItcSystemManager class categoriesFor: #batchJobPriority!public!scheduling priority! !
!ItcSystemManager class categoriesFor: #caption:!private!progress dialog! !
!ItcSystemManager class categoriesFor: #checkDolphinObjectTableSize!private!VM and session managerment! !
!ItcSystemManager class categoriesFor: #checkEmail:!public!sockets! !
!ItcSystemManager class categoriesFor: #checkImageConsistency!public! !
!ItcSystemManager class categoriesFor: #compileRuntimePatchForClass:methodSource:!public!runtime image live update! !
!ItcSystemManager class categoriesFor: #compileRuntimePatchForClass:methodSource:user:timestamp:!public!runtime image live update! !
!ItcSystemManager class categoriesFor: #convert:with:with:!public! !
!ItcSystemManager class categoriesFor: #cronJobDaemonPriority!public!scheduling priority! !
!ItcSystemManager class categoriesFor: #currentPlatformID!public!VM and session managerment! !
!ItcSystemManager class categoriesFor: #destroy!private!progress dialog! !
!ItcSystemManager class categoriesFor: #directoryCreate:!file system!public! !
!ItcSystemManager class categoriesFor: #directoryRemove:!file system!public! !
!ItcSystemManager class categoriesFor: #fileDataFor:!file system!public! !
!ItcSystemManager class categoriesFor: #fileExists:!file system!public! !
!ItcSystemManager class categoriesFor: #fileExtensionFromPath:!file system!public! !
!ItcSystemManager class categoriesFor: #fileNameFromPath:!file system!public! !
!ItcSystemManager class categoriesFor: #fileNameWithoutExtension:!file system!public! !
!ItcSystemManager class categoriesFor: #fileRemove:!file system!public! !
!ItcSystemManager class categoriesFor: #fileRename:to:!file system!public! !
!ItcSystemManager class categoriesFor: #forkExternalProgram:!public! !
!ItcSystemManager class categoriesFor: #forkExternalProgramScript:!public! !
!ItcSystemManager class categoriesFor: #forkNewProcessOn:named:!public!scheduling priority! !
!ItcSystemManager class categoriesFor: #forkNewProcessOn:named:priority:!public!scheduling priority! !
!ItcSystemManager class categoriesFor: #ftpDownload:hostname:username:password:intoDirectory:!FTP support!public! !
!ItcSystemManager class categoriesFor: #generateRandomString!public! !
!ItcSystemManager class categoriesFor: #generateShortRandomString!public! !
!ItcSystemManager class categoriesFor: #getActiveUserOrSessionInfo!logging!public! !
!ItcSystemManager class categoriesFor: #getAllFilenamesInDirectory:!file system!public! !
!ItcSystemManager class categoriesFor: #getAllFilesAndDirectoriesInDirectory:!file system!public! !
!ItcSystemManager class categoriesFor: #getBase62EncodedStringFrom:maxLength:!public! !
!ItcSystemManager class categoriesFor: #getBMPImageSize:!image manipulation!private! !
!ItcSystemManager class categoriesFor: #getComputerName!public!sockets! !
!ItcSystemManager class categoriesFor: #getCurrentOsProcessId!public! !
!ItcSystemManager class categoriesFor: #getCurrentUserName!public!sockets! !
!ItcSystemManager class categoriesFor: #getFreeDiskSpace!file system!public! !
!ItcSystemManager class categoriesFor: #getGIF87aImageSize:!image manipulation!private! !
!ItcSystemManager class categoriesFor: #getGIF89aImageSize:!image manipulation!private! !
!ItcSystemManager class categoriesFor: #getGIFImageSize:!image manipulation!private! !
!ItcSystemManager class categoriesFor: #getHostnameFromIP:!public!sockets! !
!ItcSystemManager class categoriesFor: #getImageSize:fileName:!image manipulation!public! !
!ItcSystemManager class categoriesFor: #getJpegImageSize:!image manipulation!private! !
!ItcSystemManager class categoriesFor: #getLiveUpdatePatchDict!public!runtime image live update! !
!ItcSystemManager class categoriesFor: #getPNGImageSize:!image manipulation!private! !
!ItcSystemManager class categoriesFor: #getThumbnailBytesForImageNamed:imageBytes:application:maxWidth:maxHeight:!image manipulation!public! !
!ItcSystemManager class categoriesFor: #getThumbnailBytesForImageNamedUsingGdiPlus:imageBytes:imageSize:application:maxWidth:maxHeight:!image manipulation!private! !
!ItcSystemManager class categoriesFor: #getThumbnailBytesForImageNamedUsingIrfanView:imageBytes:imageSize:application:maxWidth:maxHeight:!image manipulation!private! !
!ItcSystemManager class categoriesFor: #getUniqueIdString!public! !
!ItcSystemManager class categoriesFor: #getUUIDString!public! !
!ItcSystemManager class categoriesFor: #globalGarbageCollect!public! !
!ItcSystemManager class categoriesFor: #imageCommandLine!public! !
!ItcSystemManager class categoriesFor: #imageCommandLineArguments!public! !
!ItcSystemManager class categoriesFor: #imageFilename!public! !
!ItcSystemManager class categoriesFor: #imageTimestamp!public! !
!ItcSystemManager class categoriesFor: #increaseDolphinObjectTableSize!private!VM and session managerment! !
!ItcSystemManager class categoriesFor: #isHeadless!public!VM and session managerment! !
!ItcSystemManager class categoriesFor: #isHeadless:!private!VM and session managerment! !
!ItcSystemManager class categoriesFor: #isIgnoredSocketError:socket:!public!sockets! !
!ItcSystemManager class categoriesFor: #isRunningOnLinux!public!VM and session managerment! !
!ItcSystemManager class categoriesFor: #isRunningOnWindows!public!VM and session managerment! !
!ItcSystemManager class categoriesFor: #isRuntime!public!VM and session managerment! !
!ItcSystemManager class categoriesFor: #log:!logging!public! !
!ItcSystemManager class categoriesFor: #logDevTimeError:!logging!public! !
!ItcSystemManager class categoriesFor: #logLine:!logging!public! !
!ItcSystemManager class categoriesFor: #logLineDevTime:!logging!public! !
!ItcSystemManager class categoriesFor: #logLineWithTS:!logging!public! !
!ItcSystemManager class categoriesFor: #logLineWithTsAndPID:!logging!public! !
!ItcSystemManager class categoriesFor: #logLineWithTsAndSession:!logging!public! !
!ItcSystemManager class categoriesFor: #message:!public! !
!ItcSystemManager class categoriesFor: #newProcessOn:named:!public!scheduling priority! !
!ItcSystemManager class categoriesFor: #newRandomNumberGenerator!public!sockets! !
!ItcSystemManager class categoriesFor: #newScaledDecimalNumerator:denominator:scale:!public!scaled decimals support! !
!ItcSystemManager class categoriesFor: #newSerialPortWriter!public!serial port support! !
!ItcSystemManager class categoriesFor: #newServerSocketOnPort:backlog:!public!sockets! !
!ItcSystemManager class categoriesFor: #newSSLclientSocketToHost:port:!public!sockets! !
!ItcSystemManager class categoriesFor: #newTCPclientSocketToHost:port:!public!sockets! !
!ItcSystemManager class categoriesFor: #onStartup!private! !
!ItcSystemManager class categoriesFor: #pathSeparator!file system!public! !
!ItcSystemManager class categoriesFor: #pathSeparatorString!file system!public! !
!ItcSystemManager class categoriesFor: #progress!private!progress dialog! !
!ItcSystemManager class categoriesFor: #quitImage!public!VM and session managerment! !
!ItcSystemManager class categoriesFor: #requestHandlerPriority!public!scheduling priority! !
!ItcSystemManager class categoriesFor: #serverDaemonPriority!public!scheduling priority! !
!ItcSystemManager class categoriesFor: #serverLogStream!private! !
!ItcSystemManager class categoriesFor: #serverLogStreamFilename!public! !
!ItcSystemManager class categoriesFor: #serverWatchdogPriority!public!scheduling priority! !
!ItcSystemManager class categoriesFor: #showBusyCursorWhile:!progress dialog!public! !
!ItcSystemManager class categoriesFor: #showProgressDialogWhile:caption:allowCancel:!progress dialog!public! !
!ItcSystemManager class categoriesFor: #socketErrorClass!public!sockets! !
!ItcSystemManager class categoriesFor: #startExternalProgram:!public! !
!ItcSystemManager class categoriesFor: #startExternalProgram:commandLineParameters:!public! !
!ItcSystemManager class categoriesFor: #startExternalProgram:maxSecondsToRun:!public! !
!ItcSystemManager class categoriesFor: #startExternalProgram:writeLogTo:!public! !
!ItcSystemManager class categoriesFor: #startExternalProgramScript:!public! !
!ItcSystemManager class categoriesFor: #startUpDirectoryPath!public! !
!ItcSystemManager class categoriesFor: #startUpSessionManager!public!VM and session managerment! !
!ItcSystemManager class categoriesFor: #timeZoneMinutesFromGMT!public! !
!ItcSystemManager class categoriesFor: #totalAllocatedMemory!public!VM and session managerment! !
!ItcSystemManager class categoriesFor: #unzipArchive:into:!public!zip and unzip support! !
!ItcSystemManager class categoriesFor: #unzipArchive:into:junkPaths:!public!zip and unzip support! !
!ItcSystemManager class categoriesFor: #value:!private!progress dialog! !
!ItcSystemManager class categoriesFor: #writeErrorLog:!logging!public! !
!ItcSystemManager class categoriesFor: #writeErrorLogInRuntime:!logging!public! !
!ItcSystemManager class categoriesFor: #zipDirectory:intoArchive:!public!zip and unzip support! !
!ItcSystemManager class categoriesFor: #zipDirectory:intoArchive:junkPaths:!public!zip and unzip support! !

