"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #PresenterTest
	instanceVariableNames: 'presenter'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!

PresenterTest guid: (GUID fromString: '{80e6f4ef-64d4-40f6-857c-5b74578eb87b}')!

PresenterTest isAbstract: true!

PresenterTest comment: ''!

!PresenterTest categoriesForClass!Unclassified! !

!PresenterTest methodsFor!

classToTest
	^self subclassResponsibility!

desktopMonitors
	^DisplayMonitor desktopMonitors asSortedCollection: [:a :b | a origin < b origin]!

destroyPresenter
	| shell |
	presenter ifNil: [^self].
	shell := presenter topShell.
	shell = View desktop ifTrue: [presenter destroy] ifFalse: [shell close].
	presenter := nil!

getTextExtent: actualText
	| subject textExtent canvas |
	subject := self view.
	canvas := subject canvas.
	canvas font: subject actualFont.
	textExtent := canvas textExtent: actualText.
	canvas free.
	^textExtent!

initializePresenter
	self classToTest
		ifNotNil: 
			[:subjectClass |
			| shell |
			presenter := subjectClass show.
			shell := presenter topShell.
			shell = View desktop
				ifFalse: 
					[shell view text: self printString.
					presenter view = shell view ifFalse: [shell view name: presenter view as: 'view']]]!

leftClickAt: aPoint 
	"Fire a left-click at the specified client coordinate of the tested presenter."

	"Implementation Note: Use the correct method of sending input (i.e. the SendInput API). This
	actually moves the mouse as if the user were generating the input, but note that the
	coordinates have to be mapped into normalised screen coordinates in the range 0..65535.
	Frankly it is a lot easier just to send a couple of messages, but I wanted to try this out
	as an experiment for future reference. Unforunately I can't get it to work except when
	evaluating the expression from the debugger. This suggests there is some timing related
	issue."

	| lParam |
	self waitForInputIdle.
	lParam := aPoint x << 16 | aPoint y.
	presenter view 
		sendMessage: WM_LBUTTONDOWN
		wParam: MK_LBUTTON
		lParam: lParam.
	presenter view 
		sendMessage: WM_LBUTTONUP
		wParam: 0
		lParam: lParam.
	^self.
!

nonProportionalFont
	^Font name: 'Courier'!

oldStlResources
	^self class resourceIdentifiers!

setUp
	super setUp.
	self shouldSetupPresenter ifTrue: [self initializePresenter]!

shouldSetupPresenter
	^(self thisTestMethod refersToLiteral: #nocreate) not!

tearDown
	self destroyPresenter!

testStbUpgradeFromBinaryResources
	"Test upgrades of old STB version .vu resources. These were used in versions of Dolphin prior to 6.0, after which the STL format was introduced and the resources stored as literal arrays in class methods.
	The STL resources of later Dolphin versions are tested separately."

	"In order to test a subclass:
		- Create a subdirectory under the Resources\Tests\ViewResources folder
		- Drop copies of the binary .vu resource files exported from the old Dolphin images at different stbVersions. 
		- Rename the .vu files to include the integer stbVersion of the view in the file separated by a semi-colon from the rest of the filename. If you are uncertain of the version, either open and dump it using the STBDebugger, or rename to '<class>.<resource>;0.vu', and then run the test. The test will fail on an assertion that the version is not 0, informing you of the actual version.
		- Override the #verifyUpgradedView: method to add any further validation of the upgrade process, if required."

	| resourceDir |
	#nocreate.
	resourceDir := self resourceFilename: 'ViewResources\' , self classToTest name.
	(File exists: resourceDir) ifFalse: [^self].
	File
		for: '*.vu'
		in: resourceDir
		do: 
			[:each |
			self verifyStbUpgrade: each path.
			self destroyPresenter]!

testStlUpgradesFromLiteralResources
	"Test upgrades of old STL versions in STL format, e.g. from D6 or 7."

	"In order to test a subclass:
		- drop a copy of a relevant STL view resource method on the class side of the test class.
		- Override the #verifyUpgradedView: method to add any further validation of the upgrade process, if required."

	#nocreate.
	self oldStlResources do: 
			[:each |
			self verifyStlUpgrade: each.
			self destroyPresenter]!

verifyStbUpgrade: pathString
	| filename stbVersion stream filer version notifications viewProxy parts |
	filename := File splitStemFrom: pathString.
	parts := $; split: filename.
	stbVersion := Integer fromString: parts last.
	stream := FileStream read: pathString text: false.
	"stream reset. Tools.STBDebugger dumpToTranscript: stream. stream reset"
	filer := (STBInFiler on: stream)
				context: View desktop;
				yourself.
	viewProxy := [filer basicNext] on: Notification do: [:ex | self fail: 'Unexpected Notification'].
	stream close.
	version := viewProxy version.
	"Sanity check we got what it said on the tin"
	self assert: version equals: stbVersion.
	"filer will become: proxy to view"
	presenter := viewProxy.
	notifications := OrderedCollection new.
	[filer evaluateDeferredActions] on: Notification
		do: 
			[:ex |
			notifications add: ex.
			ex resume].
	parts := $. split: parts first.
	self verifyUpgradedView: version
		identifier: (ResourceIdentifier class: (Smalltalk at: parts first) name: parts last).
	^notifications!

verifyStlUpgrade: aResourceIdentifier
	| version filer |
	filer := STLInFiler on: aResourceIdentifier resource readStream.
	presenter := filer
				context: View desktop;
				basicNext.
	version := presenter version.
	filer evaluateDeferredActions.
	self verifyUpgradedView: version identifier: aResourceIdentifier!

verifyUpgradedView: anInteger identifier: aResourceIdentifier
	| view |
	view := self view.
	self assert: view isKindOf: self viewClass.
	self assert: view isOpen!

view
	^presenter view!

viewClass
	^self classToTest!

waitForInputIdle
	SessionManager inputState pumpMessages! !

!PresenterTest categoriesForMethods!
classToTest!constants!private! !
desktopMonitors!helpers!private! !
destroyPresenter!public!Running! !
getTextExtent:!helpers!private! !
initializePresenter!public!Running! !
leftClickAt:!helpers!private! !
nonProportionalFont!constants!private! !
oldStlResources!constants!private! !
setUp!public!Running! !
shouldSetupPresenter!helpers!private! !
tearDown!public!Running! !
testStbUpgradeFromBinaryResources!public!unit tests! !
testStlUpgradesFromLiteralResources!public!unit tests! !
verifyStbUpgrade:!helpers!private! !
verifyStlUpgrade:!helpers!private! !
verifyUpgradedView:identifier:!helpers!private! !
view!accessing!private! !
viewClass!constants!private! !
waitForInputIdle!helpers!private! !
!

