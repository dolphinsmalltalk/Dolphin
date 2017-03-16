"Filed out from Dolphin Smalltalk 7"!

StsSqueakPackageProxy subclass: #StsSqueakMonticelloPackageImporter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsSqueakMonticelloPackageImporter guid: (GUID fromString: '{79f0659e-6fcd-4d7c-ba68-3c236dacc53a}')!
StsSqueakMonticelloPackageImporter comment: ''!
!StsSqueakMonticelloPackageImporter categoriesForClass!Unclassified! !
!StsSqueakMonticelloPackageImporter methodsFor!

loadFrom: pathname 
	| tempDirectory filesExist counter result fileList fs |
	fileList := #('source.st' 'version' 'package').
	tempDirectory := SessionManager current imageBase , 'STS_TEMP'.
	File createDirectory: tempDirectory.
	
	[fileList do: [:each | [File delete: tempDirectory , '\' , each] on: Win32Error do: [:ex | ]].
	
	[ShellLibrary default 
		shellOpen: 'unzip.exe'
		directory: nil
		parameters: ' -joC "' , pathname , '" snapshot/source.st version package  -d "' , tempDirectory 
				, '"'] 
			on: Win32Error
			do: 
				[:ex | 
				MessageBox warning: 'File ' , pathname 
							, ' can not be unzipped.

Please check if you have UNZIP.EXE in your path.

You can download InfoZip UNZIP.EXE for free from the following URL:

http://www.info-zip.org/UnZip.html'
					caption: 'Unzip.exe not found'].
	counter := 0.
	
	[filesExist := fileList allSatisfy: 
					[:each | 
					
					[fs := File 
								open: tempDirectory , '\' , each
								mode: #append
								check: true
								share: #exclusive.
					fs close.
					true] 
							on: Error
							do: [:ex | false]].
	filesExist or: [counter > 60]] 
			whileFalse: 
				[counter := counter + 1.
				(Delay forMilliseconds: 250) wait].
	filesExist 
		ifFalse: 
			[MessageBox warning: 'SqueakMap/Monticello file can not be imported due to unknown file format.'
				caption: 'Unknown MCZ file format'.
			^nil].
	
	[result := super loadFrom: tempDirectory , '\source.st'.
	result isNil 
		ifFalse: 
			[
			[fs := FileStream read: tempDirectory , '\package'.
			result name: (fs
						upTo: $';
						upToAll: ''')')] 
					ensure: [fs close].
			self setVersionAndVersionCommentFor: result from: tempDirectory , '\version']] 
			ensure: [fileList do: [:each | [File delete: tempDirectory , '\' , each] on: Win32Error do: [:ex | ]]]] 
			ensure: [[File removeDirectory: tempDirectory] on: Win32Error do: [:ex | ]].
	^result!

setVersionAndVersionCommentFor: package from: fileName 
	| fs array string versionString date time index |
	fs := FileStream read: fileName.
	[string := fs contents] ensure: [fs close].
	(array := Compiler evaluate: '#' , string) isNil 
		ifFalse: 
			[date := ''.
			time := ''.
			versionString := ''.
			(index := array indexOf: #message) > 0 ifTrue: [package comment: (array at: index + 1)].
			(index := array indexOf: #author) > 0 ifTrue: [package developer: (array at: index + 1)].
			(index := array indexOf: #date) > 0 ifTrue: [date := array at: index + 1].
			(index := array indexOf: #time) > 0 ifTrue: [time := array at: index + 1].
			(index := array indexOf: #name) > 0 ifTrue: [versionString := array at: index + 1].
			package packageVersion: versionString , ' ' , date , ' ' , time]! !
!StsSqueakMonticelloPackageImporter categoriesFor: #loadFrom:!public! !
!StsSqueakMonticelloPackageImporter categoriesFor: #setVersionAndVersionCommentFor:from:!public! !

