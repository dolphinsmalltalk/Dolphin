"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #PackageTest
	instanceVariableNames: 'loadedPackages'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PackageTest guid: (GUID fromString: '{0BCDE90D-A936-43EE-9E4A-2BDEC39ABF2A}')!
PackageTest comment: ''!
!PackageTest categoriesForClass!Unclassified! !
!PackageTest methodsFor!

checkNoTestPackageContents
	| scribbleTestClass scribbleTest scribbleTestResourceMethod scribbleTestDefaultViewId scribbleTestViewId |
	scribbleTestClass := Smalltalk at: #ScribbleTest ifAbsent: [].
	self assert: scribbleTestClass isNil.
	self assert: (Scribble compiledMethodAt: #looseA ifAbsent: []) isNil.
	self assert: (Scribble compiledMethodAt: #looseC ifAbsent: []) isNil.
	self assert: (Scribble class compiledMethodAt: #resource_Scribble_test ifAbsent: []) isNil!

checkTestPackageContents
	| scribbleTestPackage scribbleTestClass scribbleTest scribbleTestResourceMethod scribbleTestDefaultViewId scribbleTestViewId |
	scribbleTestPackage := loadedPackages first.
	self assert: (scribbleTestPackage name beginsWith: 'ScribbleTest').
	scribbleTestClass := Smalltalk at: #ScribbleTest.
	self assert: scribbleTestClass notNil.
	self assert: (scribbleTestPackage classes identityIncludes: scribbleTestClass).
	scribbleTestResourceMethod := scribbleTestClass class 
				compiledMethodAt: #resource_Default_scribble_test_view.
	self assert: scribbleTestResourceMethod owningPackage = scribbleTestPackage.
	self assert: (Scribble compiledMethodAt: #looseA) owningPackage = scribbleTestPackage.
	self assert: (Scribble compiledMethodAt: #looseC) owningPackage = scribbleTestPackage.
	self assert: (Scribble class compiledMethodAt: #resource_Scribble_test) owningPackage 
				= scribbleTestPackage.
	self assert: scribbleTestPackage resourceIdentifiers size = 2.
	scribbleTestDefaultViewId := ResourceIdentifier class: scribbleTestClass
				name: 'Default scribble test view'.
	self assert: (scribbleTestPackage resourceIdentifiers includes: scribbleTestDefaultViewId).
	self assert: scribbleTestDefaultViewId owningPackage = scribbleTestPackage.
	scribbleTestViewId := ResourceIdentifier class: Scribble name: 'Scribble test'.
	self assert: (scribbleTestPackage resourceIdentifiers includes: scribbleTestViewId).
	self assert: scribbleTestViewId owningPackage = scribbleTestPackage.
	
	[scribbleTest := scribbleTestClass show.
	self assert: scribbleTest a = 'A'] 
			ensure: [scribbleTest view topView destroy]!

d5ForwardRefTestPacContents
	^'| package |
package := Package name: ''D5LoadTest''.
package paxVersion: 0;
	basicComment: ''''.


package resourceNames
	add: #Presenter -> ''D6'';
	add: #Shell -> ''D6'';
	add: #Toolbar -> ''D6'';
	yourself.

package binaryGlobalNames: (Set new
	yourself).

package globalAliases: (Set new
	yourself).

package allResourceNames: (Set new
	add: #Presenter -> ''D6'';
	add: #Shell -> ''D6'';
	add: #Toolbar -> ''D6'';
	yourself).

package setPrerequisites: (IdentitySet new
	add: ''Object Arts\Dolphin\Base\Dolphin'';
	add: ''Object Arts\Dolphin\MVP\Views\Common Controls\Dolphin Common Controls'';
	add: ''Object Arts\Dolphin\MVP\Views\Control Bars\Dolphin Control Bars'';
	add: ''Object Arts\Dolphin\MVP\Base\Dolphin MVP Base'';
	yourself).

package!!

"Class Definitions"!!


"Global Aliases"!!


"Loose Methods"!!

"End of package definition"!!

"Source Globals"!!

"Classes"!!

"Binary Globals"!!

"Resources"!!

(ResourceIdentifier class: Presenter name: ''D6'') assign: (Object fromBinaryStoreBytes:
(ByteArray fromBase64String: ''IVNUQiAxIEYCDAABAAAAVmlld1Jlc291cmNlAAAAAA4BJABTVEJSZXNvdXJjZVNUQkJ5dGVBcnJh
eUFjY2Vzc29yUHJveHkAAAAAcgAAALoGAAAhU1RCIDEgTggMAAoAAABTVEJWaWV3UHJveHkAAAAA
mgAAAAAAAABSAAAAEAAAAERvbHBoaW4gTVZQIEJhc2VSAAAADQAAAENvbnRhaW5lclZpZXdiAAAA
DwAAAAAAAAAAAAAAYgAAAAIAAACCAAAABAAAAAAAAEQBAAIAoAEAAAAAAAAAAAAAAAAAAAcAAAAA
AAAAAAAAAAAAAACgAQAAAAAAAOoAAAAAAAAAAAEAAGIAAAAAAAAAAAAAAAYBDwBNZXNzYWdlU2Vx
dWVuY2UAAAAAygAAAAAAAADQAAAAYgAAAAEAAAAGAwsATWVzc2FnZVNlbmQAAAAAugAAAAAAAABS
AAAAEAAAAGNyZWF0ZUF0OmV4dGVudDpiAAAAAgAAAAYCBQBQb2ludAAAAAALAAAACwAAAMICAAAA
AAAAvQIAAPUBAACgAQAABgEPAFdJTkRPV1BMQUNFTUVOVAAAAAByAAAALAAAACwAAAAAAAAAAAAA
AP////////////////////8FAAAABQAAAGMBAAD/AAAAygAAAAAAAADQAAAAYgAAAAIAAACaAQAA
AAAAAJoAAAAAAAAAUgAAABcAAABEb2xwaGluIENvbW1vbiBDb250cm9sc1IAAAAZAAAATXVsdGlw
bGVTZWxlY3Rpb25MaXN0Vmlld2IAAAAeAAAAAAAAAKABAABiAAAAAgAAAIIAAAAEAAAASRABRAEE
AABAAwAARgMJAAIAAABMaXN0TW9kZWwAAAAAygAAAAAAAADQAAAAIAIAAAAAAAAOAhEAU1RCU2lu
Z2xldG9uUHJveHkAAAAAmgAAAAAAAABSAAAABwAAAERvbHBoaW5SAAAADAAAAFNlYXJjaFBvbGlj
eboAAAAAAAAAUgAAAAgAAABpZGVudGl0eQAAAAAAAAAABwAAAAAAAAAAAAAAAAAAAEADAAAAAAAA
ggAAAAgAAAAzA///AAAAAJoAAAAAAAAAwAEAAFIAAAARAAAAQmFzaWNMaXN0QWJzdHJhY3SaAAAA
AAAAAGADAABSAAAAEgAAAEljb25pY0xpc3RBYnN0cmFjdOoDAAAAAAAAmgAAAAAAAADAAQAAUgAA
ABAAAABJY29uSW1hZ2VNYW5hZ2VyugAAAAAAAABSAAAABwAAAGN1cnJlbnQAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAADKAAAAAAAAANAAAABiAAAAAQAAAEYMDgAFAAAATGlzdFZpZXdDb2x1bW4AAAAA
UgAAAAgAAABDb2x1bW4gMckAAAC6AAAAAAAAAFIAAAAEAAAAbGVmdGAEAACaAAAAAAAAABAEAABS
AAAAEAAAAFNvcnRlZENvbGxlY3Rpb24AAAAAAAAAAEADAAAAAAAAAQAAAAAAAAAAAAAAugAAAAAA
AABSAAAABgAAAHJlcG9ydGIAAAAAAAAAAAAAAGEAAAAAAAAAAAAAADICAAAAAAAAygAAAAAAAADQ
AAAAYgAAAAIAAAByAgAAAAAAAJACAABiAAAAAgAAAMICAAAAAAAAbwAAAEcAAADCAgAAAAAAAJEB
AACNAQAAQAMAAHICAAAAAAAAugAAAAAAAABSAAAABQAAAHRleHQ6YgAAAAEAAABSAAAACAAAAENv
bHVtbiAxQAMAAPICAAAAAAAAcgAAACwAAAAsAAAAAAAAAAEAAAD/////////////////////NwAA
ACMAAAD/AAAA6QAAAMoAAAAAAAAA0AAAACACAADCAgAAAAAAAMEAAADBAAAAAAAAABcAAACaAQAA
AAAAAJoAAAAAAAAAwAEAAFIAAAANAAAAUmVmZXJlbmNlVmlld2IAAAAOAAAAAAAAAKABAABiAAAA
AgAAAIIAAAAEAAAAAAAARAEAAgCwBgAAAAAAAAAAAAAAAAAABwAAAAAAAAAAAAAAAAAAALAGAAAG
AhIAUmVzb3VyY2VJZGVudGlmaWVyAAAAAJoAAAAAAAAAUgAAABQAAABEb2xwaGluIENvbnRyb2wg
QmFyc1IAAAAHAAAAVG9vbGJhclIAAAACAAAARDYAAAAAMgIAAAAAAADKAAAAAAAAANAAAABiAAAA
AQAAAHICAAAAAAAAkAIAAGIAAAACAAAAwgIAAAAAAABRAAAACwAAAMICAAAAAAAA4QEAAFEAAACw
BgAA8gIAAAAAAAByAAAALAAAACwAAAAAAAAAAQAAAP////////////////////8oAAAABQAAABgB
AAAtAAAAYgAAAAAAAACgBgAAAAAAABUAAACgBgAAAAAAABMAAABGBQQAAwAAAEljb24AAAAAAAAA
ABAAAAAOAhEAU1RCU2luZ2xldG9uUHJveHkAAAAAmgAAAAAAAABSAAAABwAAAERvbHBoaW5SAAAA
GAAAAEltYWdlUmVsYXRpdmVGaWxlTG9jYXRvcroAAAAAAAAAUgAAAAcAAABjdXJyZW50UgAAABEA
AABDb250YWluZXJWaWV3Lmljbw4CHwBTVEJFeHRlcm5hbFJlc291cmNlTGlicmFyeVByb3h5AAAA
AFIAAAAQAAAAZG9scGhpbmRyMDA1LmRsbAAAAAA=''))!!

(ResourceIdentifier class: Shell name: ''D6'') assign: (Object fromBinaryStoreBytes:
(ByteArray fromBase64String: ''IVNUQiAxIEYCDAABAAAAVmlld1Jlc291cmNlAAAAAA4BJABTVEJSZXNvdXJjZVNUQkJ5dGVBcnJh
eUFjY2Vzc29yUHJveHkAAAAAcgAAALUEAAAhU1RCIDEgTggMAAoAAABTVEJWaWV3UHJveHkAAAAA
mgAAAAAAAABSAAAAEAAAAERvbHBoaW4gTVZQIEJhc2VSAAAACQAAAFNoZWxsVmlld2IAAAAbAAAA
AAAAAAAAAABiAAAAAgAAAAEAngEBAAIAoAEAAAAAAAAAAAAAAAAAAAcCAAAAAAAAAAAAAAAAAACg
AQAAAAAAAOoAAAAAAAAAAAEAAGIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAA
AAAAAAAAAAAAAAEAAAAAAAAAAAAAAAYBDwBNZXNzYWdlU2VxdWVuY2UAAAAAygAAAAAAAADQAAAA
YgAAAAIAAAAGAwsATWVzc2FnZVNlbmQAAAAAugAAAAAAAABSAAAAEAAAAGNyZWF0ZUF0OmV4dGVu
dDpiAAAAAgAAAAYCBQBQb2ludAAAAAALAAAACwAAALICAAAAAAAATQMAAOcCAACgAQAAYgIAAAAA
AAC6AAAAAAAAAFIAAAAIAAAAbWVudUJhcjpiAAAAAQAAAAAAAACgAQAABgEPAFdJTkRPV1BMQUNF
TUVOVAAAAAByAAAALAAAACwAAAAAAAAAAAAAAP////////////////////8FAAAABQAAAKsBAAB4
AQAAygAAAAAAAADQAAAAYgAAAAIAAACaAQAAAAAAAJoAAAAAAAAAwAEAAFIAAAANAAAAUmVmZXJl
bmNlVmlld2IAAAAOAAAAAAAAAKABAABiAAAAAgAAAIIAAAAEAAAAAAAARAEAAgBwAwAAAAAAAAAA
AAAAAAAABwAAAAAAAAAAAAAAAAAAAHADAAAGAhIAUmVzb3VyY2VJZGVudGlmaWVyAAAAAJoAAAAA
AAAAwAEAAFIAAAAJAAAAUHJlc2VudGVyUgAAAAIAAABENgAAAAAiAgAAAAAAAMoAAAAAAAAA0AAA
AGIAAAABAAAAYgIAAAAAAACAAgAAYgAAAAIAAACyAgAAAAAAAHkAAACDAAAAsgIAAAAAAAB3AgAA
dwIAAHADAAAiAwAAAAAAAHIAAAAsAAAALAAAAAAAAAABAAAA/////////////////////zwAAABB
AAAAdwEAAHwBAABiAAAAAAAAALICAAAAAAAAwQAAAMEAAAAAAAAAFQAAAJoBAAAAAAAAgAMAAGIA
AAAOAAAAAAAAAKABAABiAAAAAgAAAIIAAAAEAAAAAAAARAEAAgDQBAAAAAAAAAAAAAAAAAAABwAA
AAAAAAAAAAAAAAAAANAEAADSAwAAAAAAAJoAAAAAAAAAUgAAABQAAABEb2xwaGluIENvbnRyb2wg
QmFyc1IAAAAHAAAAVG9vbGJhclIAAAACAAAARDYAAAAAIgIAAAAAAADKAAAAAAAAANAAAABiAAAA
AQAAAGICAAAAAAAAgAIAAGIAAAACAAAAsgIAAAAAAAApAAAACwAAALICAAAAAAAA9QEAAFsAAADQ
BAAAIgMAAAAAAAByAAAALAAAACwAAAAAAAAAAQAAAP////////////////////8UAAAABQAAAA4B
AAAyAAAAsAQAAMAEAAAAAAAAFQAAAMAEAAAAAAAAFQAAAEYFBAADAAAASWNvbgAAAAAAAAAAEAAA
AA4CEQBTVEJTaW5nbGV0b25Qcm94eQAAAACaAAAAAAAAAFIAAAAHAAAARG9scGhpblIAAAAYAAAA
SW1hZ2VSZWxhdGl2ZUZpbGVMb2NhdG9yugAAAAAAAABSAAAABwAAAGN1cnJlbnRSAAAADQAAAFNo
ZWxsVmlldy5pY28OAh8AU1RCRXh0ZXJuYWxSZXNvdXJjZUxpYnJhcnlQcm94eQAAAABSAAAAEAAA
AGRvbHBoaW5kcjAwNS5kbGwAAAAA''))!!

(ResourceIdentifier class: Toolbar name: ''D6'') assign: (Object fromBinaryStoreBytes:
(ByteArray fromBase64String: ''IVNUQiAxIEYCDAABAAAAVmlld1Jlc291cmNlAAAAAA4BJABTVEJSZXNvdXJjZVNUQkJ5dGVBcnJh
eUFjY2Vzc29yUHJveHkAAAAAcgAAAFUFAAAhU1RCIDEgTggMAAoAAABTVEJWaWV3UHJveHkAAAAA
mgAAAAAAAABSAAAAFAAAAERvbHBoaW4gQ29udHJvbCBCYXJzUgAAAAcAAABUb29sYmFyYgAAABkA
AAAAAAAAAAAAAGIAAAACAAAAggAAAAQAAAAECwBEAQACAKABAAAAAAAABgELAFN5c3RlbUNvbG9y
AAAAAB8AAAAAAAAABwIAAAAAAAAGBAQARm9udAAAAAAAAAAAEAAAAAYBBwBMT0dGT05UAAAAAHIA
AAA8AAAA8////wAAAAAAAAAAAAAAAJABAAAAAAAAAwIBIkFyaWFsAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAABgIFAFBvaW50AAAAAMEAAADBAAAAAAAAAKABAAAAAAAAggAAAAgAAADdA///AAAA
AOoAAAAAAAAAAAEAAGIAAAAAAAAA6gAAAAAAAAAAAQAAYgAAAAYAAADLvgAABgcNAFRvb2xiYXJC
dXR0b24AAAAAy74AAAAAAACgAQAAAQAAAEYFEgAEAAAAQ29tbWFuZERlc2NyaXB0aW9uAAAAALoA
AAAAAAAAUgAAAAkAAABub0NvbW1hbmRSAAAACgAAAE5vIGNvbW1hbmQBAAAAAQAAAAAAAABGCAYA
AwAAAEJpdG1hcAAAAAAAAAAAEAAAAA4CEQBTVEJTaW5nbGV0b25Qcm94eQAAAACaAAAAAAAAAFIA
AAAHAAAARG9scGhpblIAAAAYAAAASW1hZ2VSZWxhdGl2ZUZpbGVMb2NhdG9yugAAAAAAAABSAAAA
BwAAAGN1cnJlbnRSAAAACQAAAFRvb2xzLmJtcA4CHwBTVEJFeHRlcm5hbFJlc291cmNlTGlicmFy
eVByb3h5AAAAAFIAAAAQAAAAZG9scGhpbmRyMDA1LmRsbAAAAAAAAAAABwAAAIICAAAAAAAAIQcA
ACEAAABHAAAAzb4AAPICAAAAAAAAzb4AAAAAAACgAQAAAQAAABIDAAAAAAAAMAMAAFADAAABAAAA
AQAAAAAAAABiAwAAAAAAAAAAAAAQAAAAkAMAAPADAAAQBAAAAAAAAAUAAAAAAAAARwAAAM++AADy
AgAAAAAAAM++AAAAAAAAoAEAAAEAAAASAwAAAAAAADADAABQAwAAAQAAAAEAAAAAAAAAYgMAAAAA
AAAAAAAAEAAAAJADAADwAwAAEAQAAAAAAAAFAAAAAAAAAEcAAABiAAAAAwAAAAADAABABAAAcAQA
AOoAAAAAAAAA8AAAAGIAAAACAAAAcAMAAAEAAAAAAAAAIAAAAAAAAACCAgAAAAAAACEAAAAhAAAA
ggIAAAAAAAAtAAAALQAAAAAAAAAGAwoARmxvd0xheW91dAAAAAABAAAAAQAAALoAAAAAAAAAUgAA
AAQAAABsZWZ0BgEPAE1lc3NhZ2VTZXF1ZW5jZQAAAADKAAAAAAAAANAAAABiAAAAAgAAAAYDCwBN
ZXNzYWdlU2VuZAAAAAC6AAAAAAAAAFIAAAAQAAAAY3JlYXRlQXQ6ZXh0ZW50OmIAAAACAAAAggIA
AAAAAAALAAAACwAAAIICAAAAAAAAvQIAADMAAACgAQAAcgUAAAAAAAC6AAAAAAAAAFIAAAAKAAAA
dXBkYXRlU2l6ZWIAAAAAAAAAoAEAAAYBDwBXSU5ET1dQTEFDRU1FTlQAAAAAcgAAACwAAAAsAAAA
AAAAAAAAAAD/////////////////////BQAAAAUAAABjAQAAHgAAAMoAAAAAAAAA0AAAAMACAACC
AgAAAAAAAMEAAADBAAAAAAAAABMAAABGBQQAAwAAAEljb24AAAAAAAAAABAAAAAOAhEAU1RCU2lu
Z2xldG9uUHJveHkAAAAAmgAAAAAAAABSAAAABwAAAERvbHBoaW5SAAAAGAAAAEltYWdlUmVsYXRp
dmVGaWxlTG9jYXRvcroAAAAAAAAAUgAAAAcAAABjdXJyZW50UgAAABYAAABDb250cm9sQmFyQWJz
dHJhY3QuaWNvDgIfAFNUQkV4dGVybmFsUmVzb3VyY2VMaWJyYXJ5UHJveHkAAAAAUgAAABAAAABk
b2xwaGluZHIwMDUuZGxsAAAAAA==''))!!


'!

filenameFor: aString 
	^FileLocator installRelative localFileSpecFor: 'Resources\Tests\' , aString!

loadAndTestPackage: filename 
	self checkNoTestPackageContents.
	loadedPackages := Package manager install: (self filenameFor: filename).
	self checkTestPackageContents!

setUp
	Package classPool at: 'CheckTimestamps' put: true.
	self testPackages do: [:each | each updateTimestamp]!

tearDown
	Package classPool at: 'CheckTimestamps' put: false.
	#(#a #b #c) do: 
			[:each | 
			| package |
			package := DolphinTestPackages current perform: each.
			(Array with: package packageFileName with: package fileOutName) do: [:filename | (File exists: filename) ifTrue: [File delete: filename]]].
	loadedPackages notNil ifTrue: [loadedPackages do: [:each | Package manager basicUninstall: each]].
	DolphinTestPackages reset!

testForwardRefLoadPac
	"#1720: Test loading and converting of old packages with forward reference view referereces"

	| pacName |
	pacName := self filenameFor: 'D5LoadTest.pac'.
	(FileStream write: pacName)
		nextPutAll: self d5ForwardRefTestPacContents;
		close.
	[loadedPackages := Package manager install: pacName] ensure: [File delete: pacName]!

testLoad21Pac
	self loadAndTestPackage: 'ScribbleTestPackages\2.1\ScribbleTest21.pac'!

testLoad40Pac
	self loadAndTestPackage: 'ScribbleTestPackages\4.0\ScribbleTest4.pac'!

testLoad40Pax
	self loadAndTestPackage: 'ScribbleTestPackages\4.0\ScribbleTest4.pax'!

testLoad51Pac
	self loadAndTestPackage: 'ScribbleTestPackages\5.1\ScribbleTest51.pac'!

testLoad51Pax
	self loadAndTestPackage: 'ScribbleTestPackages\5.1\ScribbleTest51.pax'!

testLoad60Pac
	self loadAndTestPackage: 'ScribbleTestPackages\6.0\ScribbleTest6.pac'!

testLoad60Pax
	self loadAndTestPackage: 'ScribbleTestPackages\6.0\ScribbleTest6.pax'!

testPackages
	^Array 
		with: DolphinTestPackages current a
		with: DolphinTestPackages current b
		with: DolphinTestPackages current c!

testPacTimestampUpdate
	| a stamp stream text warned |
	a := DolphinTestPackages current a.
	self deny: a isUsingPAX.
	self deny: a isRenegade.
	2 timesRepeat: 
			[stamp := a timestamp.
			warned := false.
			self assert: ([a save] on: Warning
						do: 
							[:ex | 
							warned := true.
							false]).
			self deny: warned.
			self deny: a isUsingPAX.
			self deny: a isRenegade.
			self assert: a timestamp asInteger > stamp asInteger.
			Processor sleep: 1].
	stream := FileStream read: a packageFileName text: true.
	text := stream contents.
	stream close.
	self deny: a isRenegade.
	Processor sleep: 10.
	stream := FileStream write: a packageFileName text: true.
	stream nextPutAll: text.
	stream close.
	self assert: a isRenegade.
	self deny: ([a save] on: Warning do: [:ex | false]).
	self assert: a isRenegade.
	warned := false.
	self assert: ([a save] on: Warning
				do: 
					[:ex | 
					warned := true.
					ex resume]).
	self assert: warned.
	self deny: a isRenegade.
	warned := false.
	self assert: ([a save] on: Warning
				do: 
					[:ex | 
					warned := true.
					false]).
	self deny: warned.
	"Finally remove and reinstall it"
	a uninstall.
	a := (Package manager install: a packageFileName) first.
	self assert: a name = 'A'.
	self deny: a isRenegade!

testPaxTimestampUpdate
	| b stamp stream text warned |
	b := DolphinTestPackages current b.
	self deny: b isRenegade.
	b fileOutAll.
	self assert: b isUsingPAX.
	self deny: b isRenegade.
	2 timesRepeat: 
			[stamp := b timestamp.
			warned := false.
			self assert: ([b save] on: Warning
						do: 
							[:ex | 
							warned := true.
							false]).
			self deny: warned.
			self assert: b isUsingPAX.
			self deny: b isRenegade.
			self assert: b timestamp asInteger > stamp asInteger.
			Processor sleep: 10].
	stream := FileStream read: b fileOutName text: true.
	text := stream contents.
	stream close.
	self deny: b isRenegade.
	Processor sleep: 10.
	stream := FileStream write: b fileOutName text: true.
	stream nextPutAll: text.
	stream close.
	self assert: b isRenegade.
	self deny: ([b save] on: Warning do: [:ex | false]).
	self assert: b isRenegade.
	warned := false.
	self assert: ([b save] on: Warning
				do: 
					[:ex | 
					warned := true.
					ex resume]).
	self assert: warned.
	self deny: b isRenegade.
	warned := false.
	self assert: ([b save] on: Warning
				do: 
					[:ex | 
					warned := true.
					false]).
	self deny: warned.
	"Finally remove and reinstall it"
	b uninstall.
	b := (Package manager install: b fileOutName) first.
	self assert: b name = 'B'.
	self deny: b isRenegade!

testTimestampInitialized
	self assert: Package new timestamp asInteger = 0! !
!PackageTest categoriesFor: #checkNoTestPackageContents!private!unit tests! !
!PackageTest categoriesFor: #checkTestPackageContents!private!unit tests! !
!PackageTest categoriesFor: #d5ForwardRefTestPacContents!private!unit tests! !
!PackageTest categoriesFor: #filenameFor:!private!unit tests! !
!PackageTest categoriesFor: #loadAndTestPackage:!private!unit tests! !
!PackageTest categoriesFor: #setUp!private!unit tests! !
!PackageTest categoriesFor: #tearDown!private!unit tests! !
!PackageTest categoriesFor: #testForwardRefLoadPac!public!unit tests! !
!PackageTest categoriesFor: #testLoad21Pac!public!unit tests! !
!PackageTest categoriesFor: #testLoad40Pac!public!unit tests! !
!PackageTest categoriesFor: #testLoad40Pax!public!unit tests! !
!PackageTest categoriesFor: #testLoad51Pac!public!unit tests! !
!PackageTest categoriesFor: #testLoad51Pax!public!unit tests! !
!PackageTest categoriesFor: #testLoad60Pac!public!unit tests! !
!PackageTest categoriesFor: #testLoad60Pax!public!unit tests! !
!PackageTest categoriesFor: #testPackages!public!unit tests! !
!PackageTest categoriesFor: #testPacTimestampUpdate!public!unit tests! !
!PackageTest categoriesFor: #testPaxTimestampUpdate!public!unit tests! !
!PackageTest categoriesFor: #testTimestampInitialized!public!unit tests! !

!PackageTest class methodsFor!

resources
	^Array with: DolphinTestPackages! !
!PackageTest class categoriesFor: #resources!Accessing!public! !

