"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #CRTLibraryImportTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CRTLibraryImportTest guid: (GUID fromString: '{A3836AC0-E09A-4F44-B33F-3F87F52F2098}')!
CRTLibraryImportTest comment: ''!
!CRTLibraryImportTest categoriesForClass!SUnit! !
!CRTLibraryImportTest methodsFor!

defFilePaths
	^#('Core\DolphinVM\ConsoleToGo\ConsoleToGo.def' 'Core\DolphinVM\InProcToGo\IPToGo.def' 'Core\DolphinVM\ToGoStub\togo.def')!

test
	"Ensure that .def files include proper CRTLibrary imports (#183)."

	| expectedFunctions extra fileStream functions i j line pieces sourceString |
	(File exists: (File splitPathFrom: SessionManager current imagePath) , '\Core') ifFalse: [^self].
	functions := Set new.
	CRTLibrary selectors do: 
			[:each |
			sourceString := CRTLibrary sourceCodeAt: each.
			0 < (i := sourceString findString: 'cdecl:')
				ifTrue: 
					[j := sourceString indexOf: $> startingAt: i.
					sourceString := sourceString copyFrom: i to: j - 1.
					pieces := sourceString subStrings.
					functions add: (pieces at: 3)]].
	self defFilePaths do: 
			[:each |
			fileStream := FileStream read: (File splitPathFrom: SessionManager current imagePath) , each.
			
			[[fileStream atEnd not] whileTrue: 
					[0 < (fileStream nextLine findString: 'CRT')
						ifTrue: 
							[expectedFunctions := functions copy.
							extra := Set new.
							fileStream nextLine.
							[(line := fileStream nextLine trimSeparators) notEmpty]
								whileTrue: [expectedFunctions remove: line ifAbsent: [extra add: line]].
							self assert: expectedFunctions isEmpty.
							self assert: extra isEmpty]]]
					ensure: [fileStream close]]! !
!CRTLibraryImportTest categoriesFor: #defFilePaths!public! !
!CRTLibraryImportTest categoriesFor: #test!public! !

